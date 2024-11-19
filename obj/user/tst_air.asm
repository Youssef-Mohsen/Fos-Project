
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
  800044:	e8 91 20 00 00       	call   8020da <sys_getenvid>
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
  80007c:	bb 32 2a 80 00       	mov    $0x802a32,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb 3c 2a 80 00       	mov    $0x802a3c,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb 48 2a 80 00       	mov    $0x802a48,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb 57 2a 80 00       	mov    $0x802a57,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb 66 2a 80 00       	mov    $0x802a66,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb 7b 2a 80 00       	mov    $0x802a7b,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb 90 2a 80 00       	mov    $0x802a90,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb a1 2a 80 00       	mov    $0x802aa1,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb b2 2a 80 00       	mov    $0x802ab2,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb c3 2a 80 00       	mov    $0x802ac3,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb cc 2a 80 00       	mov    $0x802acc,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb d6 2a 80 00       	mov    $0x802ad6,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb e1 2a 80 00       	mov    $0x802ae1,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb ed 2a 80 00       	mov    $0x802aed,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb f7 2a 80 00       	mov    $0x802af7,%ebx
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
  8001f7:	bb 01 2b 80 00       	mov    $0x802b01,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb 0f 2b 80 00       	mov    $0x802b0f,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb 1e 2b 80 00       	mov    $0x802b1e,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb 25 2b 80 00       	mov    $0x802b25,%ebx
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
  800264:	e8 d0 1a 00 00       	call   801d39 <smalloc>
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
  800342:	e8 f2 19 00 00       	call   801d39 <smalloc>
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
  800364:	e8 d0 19 00 00       	call   801d39 <smalloc>
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
  800385:	e8 af 19 00 00       	call   801d39 <smalloc>
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
  8003a6:	e8 8e 19 00 00       	call   801d39 <smalloc>
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
  8003c8:	e8 6c 19 00 00       	call   801d39 <smalloc>
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
  8003ef:	e8 45 19 00 00       	call   801d39 <smalloc>
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
  80040d:	e8 27 19 00 00       	call   801d39 <smalloc>
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
  80042b:	e8 09 19 00 00       	call   801d39 <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 f0 18 00 00       	call   801d39 <smalloc>
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
  80046c:	e8 c8 18 00 00       	call   801d39 <smalloc>
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
  800499:	e8 95 1f 00 00       	call   802433 <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 7a 1f 00 00       	call   802433 <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 5f 1f 00 00       	call   802433 <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 44 1f 00 00       	call   802433 <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 29 1f 00 00       	call   802433 <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 0e 1f 00 00       	call   802433 <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 f3 1e 00 00       	call   802433 <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 c0 27 80 00       	push   $0x8027c0
  800554:	e8 e0 17 00 00       	call   801d39 <smalloc>
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
  80057b:	bb 2c 2b 80 00       	mov    $0x802b2c,%ebx
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
  8005ae:	e8 cd 14 00 00       	call   801a80 <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ff fd ff ff    	lea    -0x201(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 31 fe ff ff    	lea    -0x1cf(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 36 fe ff ff    	lea    -0x1ca(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 86 15 00 00       	call   801b59 <strcconcat>
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
  8005fc:	e8 32 1e 00 00       	call   802433 <create_semaphore>
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
  80061b:	a1 04 40 80 00       	mov    0x804004,%eax
  800620:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800626:	a1 04 40 80 00       	mov    0x804004,%eax
  80062b:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800631:	89 c1                	mov    %eax,%ecx
  800633:	a1 04 40 80 00       	mov    0x804004,%eax
  800638:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80063e:	52                   	push   %edx
  80063f:	51                   	push   %ecx
  800640:	50                   	push   %eax
  800641:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800647:	50                   	push   %eax
  800648:	e8 38 1a 00 00       	call   802085 <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 3e 1a 00 00       	call   8020a3 <sys_run_env>
  800665:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800668:	a1 04 40 80 00       	mov    0x804004,%eax
  80066d:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800673:	a1 04 40 80 00       	mov    0x804004,%eax
  800678:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  80067e:	89 c1                	mov    %eax,%ecx
  800680:	a1 04 40 80 00       	mov    0x804004,%eax
  800685:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80068b:	52                   	push   %edx
  80068c:	51                   	push   %ecx
  80068d:	50                   	push   %eax
  80068e:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800694:	50                   	push   %eax
  800695:	e8 eb 19 00 00       	call   802085 <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 f1 19 00 00       	call   8020a3 <sys_run_env>
  8006b2:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8006b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8006ba:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8006c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8006c5:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8006cb:	89 c1                	mov    %eax,%ecx
  8006cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8006d2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8006d8:	52                   	push   %edx
  8006d9:	51                   	push   %ecx
  8006da:	50                   	push   %eax
  8006db:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	e8 9e 19 00 00       	call   802085 <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 a4 19 00 00       	call   8020a3 <sys_run_env>
  8006ff:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800702:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800709:	eb 70                	jmp    80077b <_main+0x743>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80070b:	a1 04 40 80 00       	mov    0x804004,%eax
  800710:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800716:	a1 04 40 80 00       	mov    0x804004,%eax
  80071b:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	a1 04 40 80 00       	mov    0x804004,%eax
  800728:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80072e:	52                   	push   %edx
  80072f:	51                   	push   %ecx
  800730:	50                   	push   %eax
  800731:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	e8 48 19 00 00       	call   802085 <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 d4 27 80 00       	push   $0x8027d4
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 1a 28 80 00       	push   $0x80281a
  800761:	e8 23 05 00 00       	call   800c89 <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 2e 19 00 00       	call   8020a3 <sys_run_env>
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
  800795:	e8 cd 1c 00 00       	call   802467 <wait_semaphore>
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
  8007b0:	e8 f1 1c 00 00       	call   8024a6 <env_sleep>
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
  8007f6:	68 2c 28 80 00       	push   $0x80282c
  8007fb:	e8 46 07 00 00       	call   800f46 <cprintf>
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
  80084e:	68 5c 28 80 00       	push   $0x80285c
  800853:	e8 ee 06 00 00       	call   800f46 <cprintf>
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
  80088d:	68 8c 28 80 00       	push   $0x80288c
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 1a 28 80 00       	push   $0x80281a
  80089c:	e8 e8 03 00 00       	call   800c89 <_panic>
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
  8008d0:	68 8c 28 80 00       	push   $0x80288c
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 1a 28 80 00       	push   $0x80281a
  8008df:	e8 a5 03 00 00       	call   800c89 <_panic>
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
  800931:	68 8c 28 80 00       	push   $0x80288c
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 1a 28 80 00       	push   $0x80281a
  800940:	e8 44 03 00 00       	call   800c89 <_panic>
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
  80095e:	e8 38 1b 00 00       	call   80249b <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 b0 28 80 00       	push   $0x8028b0
  800970:	68 d0 28 80 00       	push   $0x8028d0
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 1a 28 80 00       	push   $0x80281a
  80097f:	e8 05 03 00 00       	call   800c89 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 09 1b 00 00       	call   80249b <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 e8 28 80 00       	push   $0x8028e8
  80099f:	68 d0 28 80 00       	push   $0x8028d0
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 1a 28 80 00       	push   $0x80281a
  8009ae:	e8 d6 02 00 00       	call   800c89 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 da 1a 00 00       	call   80249b <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 08 29 80 00       	push   $0x802908
  8009ce:	68 d0 28 80 00       	push   $0x8028d0
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 1a 28 80 00       	push   $0x80281a
  8009dd:	e8 a7 02 00 00       	call   800c89 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 ab 1a 00 00       	call   80249b <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 2c 29 80 00       	push   $0x80292c
  8009fd:	68 d0 28 80 00       	push   $0x8028d0
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 1a 28 80 00       	push   $0x80281a
  800a0c:	e8 78 02 00 00       	call   800c89 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 7c 1a 00 00       	call   80249b <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 4e 29 80 00       	push   $0x80294e
  800a2c:	68 d0 28 80 00       	push   $0x8028d0
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 1a 28 80 00       	push   $0x80281a
  800a3b:	e8 49 02 00 00       	call   800c89 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 4d 1a 00 00       	call   80249b <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 6c 29 80 00       	push   $0x80296c
  800a5b:	68 d0 28 80 00       	push   $0x8028d0
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 1a 28 80 00       	push   $0x80281a
  800a6a:	e8 1a 02 00 00       	call   800c89 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 1e 1a 00 00       	call   80249b <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 90 29 80 00       	push   $0x802990
  800a89:	68 d0 28 80 00       	push   $0x8028d0
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 1a 28 80 00       	push   $0x80281a
  800a98:	e8 ec 01 00 00       	call   800c89 <_panic>

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
  800ac4:	e8 d2 19 00 00       	call   80249b <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 b8 29 80 00       	push   $0x8029b8
  800ad5:	68 d0 28 80 00       	push   $0x8028d0
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 1a 28 80 00       	push   $0x80281a
  800ae4:	e8 a0 01 00 00       	call   800c89 <_panic>
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
  800af7:	68 e0 29 80 00       	push   $0x8029e0
  800afc:	e8 45 04 00 00       	call   800f46 <cprintf>
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
  800b58:	e8 96 15 00 00       	call   8020f3 <sys_getenvindex>
  800b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b63:	89 d0                	mov    %edx,%eax
  800b65:	c1 e0 02             	shl    $0x2,%eax
  800b68:	01 d0                	add    %edx,%eax
  800b6a:	01 c0                	add    %eax,%eax
  800b6c:	01 d0                	add    %edx,%eax
  800b6e:	c1 e0 02             	shl    $0x2,%eax
  800b71:	01 d0                	add    %edx,%eax
  800b73:	01 c0                	add    %eax,%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	c1 e0 04             	shl    $0x4,%eax
  800b7a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b7f:	a3 04 40 80 00       	mov    %eax,0x804004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b84:	a1 04 40 80 00       	mov    0x804004,%eax
  800b89:	8a 40 20             	mov    0x20(%eax),%al
  800b8c:	84 c0                	test   %al,%al
  800b8e:	74 0d                	je     800b9d <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800b90:	a1 04 40 80 00       	mov    0x804004,%eax
  800b95:	83 c0 20             	add    $0x20,%eax
  800b98:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba1:	7e 0a                	jle    800bad <libmain+0x5b>
		binaryname = argv[0];
  800ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 7d f4 ff ff       	call   800038 <_main>
  800bbb:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800bbe:	e8 b4 12 00 00       	call   801e77 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800bc3:	83 ec 0c             	sub    $0xc,%esp
  800bc6:	68 64 2b 80 00       	push   $0x802b64
  800bcb:	e8 76 03 00 00       	call   800f46 <cprintf>
  800bd0:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bd3:	a1 04 40 80 00       	mov    0x804004,%eax
  800bd8:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800bde:	a1 04 40 80 00       	mov    0x804004,%eax
  800be3:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800be9:	83 ec 04             	sub    $0x4,%esp
  800bec:	52                   	push   %edx
  800bed:	50                   	push   %eax
  800bee:	68 8c 2b 80 00       	push   $0x802b8c
  800bf3:	e8 4e 03 00 00       	call   800f46 <cprintf>
  800bf8:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bfb:	a1 04 40 80 00       	mov    0x804004,%eax
  800c00:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800c06:	a1 04 40 80 00       	mov    0x804004,%eax
  800c0b:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800c11:	a1 04 40 80 00       	mov    0x804004,%eax
  800c16:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800c1c:	51                   	push   %ecx
  800c1d:	52                   	push   %edx
  800c1e:	50                   	push   %eax
  800c1f:	68 b4 2b 80 00       	push   $0x802bb4
  800c24:	e8 1d 03 00 00       	call   800f46 <cprintf>
  800c29:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2c:	a1 04 40 80 00       	mov    0x804004,%eax
  800c31:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	50                   	push   %eax
  800c3b:	68 0c 2c 80 00       	push   $0x802c0c
  800c40:	e8 01 03 00 00       	call   800f46 <cprintf>
  800c45:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	68 64 2b 80 00       	push   $0x802b64
  800c50:	e8 f1 02 00 00       	call   800f46 <cprintf>
  800c55:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800c58:	e8 34 12 00 00       	call   801e91 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800c5d:	e8 19 00 00 00       	call   800c7b <exit>
}
  800c62:	90                   	nop
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c6b:	83 ec 0c             	sub    $0xc,%esp
  800c6e:	6a 00                	push   $0x0
  800c70:	e8 4a 14 00 00       	call   8020bf <sys_destroy_env>
  800c75:	83 c4 10             	add    $0x10,%esp
}
  800c78:	90                   	nop
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <exit>:

void
exit(void)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c81:	e8 9f 14 00 00       	call   802125 <sys_exit_env>
}
  800c86:	90                   	nop
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800c92:	83 c0 04             	add    $0x4,%eax
  800c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c98:	a1 2c 40 80 00       	mov    0x80402c,%eax
  800c9d:	85 c0                	test   %eax,%eax
  800c9f:	74 16                	je     800cb7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ca1:	a1 2c 40 80 00       	mov    0x80402c,%eax
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	50                   	push   %eax
  800caa:	68 20 2c 80 00       	push   $0x802c20
  800caf:	e8 92 02 00 00       	call   800f46 <cprintf>
  800cb4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb7:	a1 00 40 80 00       	mov    0x804000,%eax
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	ff 75 08             	pushl  0x8(%ebp)
  800cc2:	50                   	push   %eax
  800cc3:	68 25 2c 80 00       	push   $0x802c25
  800cc8:	e8 79 02 00 00       	call   800f46 <cprintf>
  800ccd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	50                   	push   %eax
  800cda:	e8 fc 01 00 00       	call   800edb <vcprintf>
  800cdf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	6a 00                	push   $0x0
  800ce7:	68 41 2c 80 00       	push   $0x802c41
  800cec:	e8 ea 01 00 00       	call   800edb <vcprintf>
  800cf1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cf4:	e8 82 ff ff ff       	call   800c7b <exit>

	// should not return here
	while (1) ;
  800cf9:	eb fe                	jmp    800cf9 <_panic+0x70>

00800cfb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d01:	a1 04 40 80 00       	mov    0x804004,%eax
  800d06:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	39 c2                	cmp    %eax,%edx
  800d11:	74 14                	je     800d27 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 44 2c 80 00       	push   $0x802c44
  800d1b:	6a 26                	push   $0x26
  800d1d:	68 90 2c 80 00       	push   $0x802c90
  800d22:	e8 62 ff ff ff       	call   800c89 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d35:	e9 c5 00 00 00       	jmp    800dff <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	01 d0                	add    %edx,%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	75 08                	jne    800d57 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800d4f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d52:	e9 a5 00 00 00       	jmp    800dfc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800d57:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d5e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d65:	eb 69                	jmp    800dd0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d67:	a1 04 40 80 00       	mov    0x804004,%eax
  800d6c:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800d72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d75:	89 d0                	mov    %edx,%eax
  800d77:	01 c0                	add    %eax,%eax
  800d79:	01 d0                	add    %edx,%eax
  800d7b:	c1 e0 03             	shl    $0x3,%eax
  800d7e:	01 c8                	add    %ecx,%eax
  800d80:	8a 40 04             	mov    0x4(%eax),%al
  800d83:	84 c0                	test   %al,%al
  800d85:	75 46                	jne    800dcd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d87:	a1 04 40 80 00       	mov    0x804004,%eax
  800d8c:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800d92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d95:	89 d0                	mov    %edx,%eax
  800d97:	01 c0                	add    %eax,%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	c1 e0 03             	shl    $0x3,%eax
  800d9e:	01 c8                	add    %ecx,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dad:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	01 c8                	add    %ecx,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dc0:	39 c2                	cmp    %eax,%edx
  800dc2:	75 09                	jne    800dcd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800dc4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dcb:	eb 15                	jmp    800de2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dcd:	ff 45 e8             	incl   -0x18(%ebp)
  800dd0:	a1 04 40 80 00       	mov    0x804004,%eax
  800dd5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dde:	39 c2                	cmp    %eax,%edx
  800de0:	77 85                	ja     800d67 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800de2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800de6:	75 14                	jne    800dfc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800de8:	83 ec 04             	sub    $0x4,%esp
  800deb:	68 9c 2c 80 00       	push   $0x802c9c
  800df0:	6a 3a                	push   $0x3a
  800df2:	68 90 2c 80 00       	push   $0x802c90
  800df7:	e8 8d fe ff ff       	call   800c89 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800dfc:	ff 45 f0             	incl   -0x10(%ebp)
  800dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e02:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e05:	0f 8c 2f ff ff ff    	jl     800d3a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e19:	eb 26                	jmp    800e41 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e1b:	a1 04 40 80 00       	mov    0x804004,%eax
  800e20:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800e26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e29:	89 d0                	mov    %edx,%eax
  800e2b:	01 c0                	add    %eax,%eax
  800e2d:	01 d0                	add    %edx,%eax
  800e2f:	c1 e0 03             	shl    $0x3,%eax
  800e32:	01 c8                	add    %ecx,%eax
  800e34:	8a 40 04             	mov    0x4(%eax),%al
  800e37:	3c 01                	cmp    $0x1,%al
  800e39:	75 03                	jne    800e3e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800e3b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e3e:	ff 45 e0             	incl   -0x20(%ebp)
  800e41:	a1 04 40 80 00       	mov    0x804004,%eax
  800e46:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e4f:	39 c2                	cmp    %eax,%edx
  800e51:	77 c8                	ja     800e1b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e56:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e59:	74 14                	je     800e6f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	68 f0 2c 80 00       	push   $0x802cf0
  800e63:	6a 44                	push   $0x44
  800e65:	68 90 2c 80 00       	push   $0x802c90
  800e6a:	e8 1a fe ff ff       	call   800c89 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e6f:	90                   	nop
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	8b 00                	mov    (%eax),%eax
  800e7d:	8d 48 01             	lea    0x1(%eax),%ecx
  800e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e83:	89 0a                	mov    %ecx,(%edx)
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	88 d1                	mov    %dl,%cl
  800e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	8b 00                	mov    (%eax),%eax
  800e96:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e9b:	75 2c                	jne    800ec9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e9d:	a0 08 40 80 00       	mov    0x804008,%al
  800ea2:	0f b6 c0             	movzbl %al,%eax
  800ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea8:	8b 12                	mov    (%edx),%edx
  800eaa:	89 d1                	mov    %edx,%ecx
  800eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaf:	83 c2 08             	add    $0x8,%edx
  800eb2:	83 ec 04             	sub    $0x4,%esp
  800eb5:	50                   	push   %eax
  800eb6:	51                   	push   %ecx
  800eb7:	52                   	push   %edx
  800eb8:	e8 78 0f 00 00       	call   801e35 <sys_cputs>
  800ebd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	8b 40 04             	mov    0x4(%eax),%eax
  800ecf:	8d 50 01             	lea    0x1(%eax),%edx
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ed8:	90                   	nop
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ee4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800eeb:	00 00 00 
	b.cnt = 0;
  800eee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ef5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ef8:	ff 75 0c             	pushl  0xc(%ebp)
  800efb:	ff 75 08             	pushl  0x8(%ebp)
  800efe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f04:	50                   	push   %eax
  800f05:	68 72 0e 80 00       	push   $0x800e72
  800f0a:	e8 11 02 00 00       	call   801120 <vprintfmt>
  800f0f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f12:	a0 08 40 80 00       	mov    0x804008,%al
  800f17:	0f b6 c0             	movzbl %al,%eax
  800f1a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f20:	83 ec 04             	sub    $0x4,%esp
  800f23:	50                   	push   %eax
  800f24:	52                   	push   %edx
  800f25:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f2b:	83 c0 08             	add    $0x8,%eax
  800f2e:	50                   	push   %eax
  800f2f:	e8 01 0f 00 00       	call   801e35 <sys_cputs>
  800f34:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f37:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
	return b.cnt;
  800f3e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f4c:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
	va_start(ap, fmt);
  800f53:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f62:	50                   	push   %eax
  800f63:	e8 73 ff ff ff       	call   800edb <vcprintf>
  800f68:	83 c4 10             	add    $0x10,%esp
  800f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800f79:	e8 f9 0e 00 00       	call   801e77 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800f7e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	83 ec 08             	sub    $0x8,%esp
  800f8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8d:	50                   	push   %eax
  800f8e:	e8 48 ff ff ff       	call   800edb <vcprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
  800f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800f99:	e8 f3 0e 00 00       	call   801e91 <sys_unlock_cons>
	return cnt;
  800f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	53                   	push   %ebx
  800fa7:	83 ec 14             	sub    $0x14,%esp
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fb6:	8b 45 18             	mov    0x18(%ebp),%eax
  800fb9:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fc1:	77 55                	ja     801018 <printnum+0x75>
  800fc3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fc6:	72 05                	jb     800fcd <printnum+0x2a>
  800fc8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fcb:	77 4b                	ja     801018 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fcd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fd0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fd3:	8b 45 18             	mov    0x18(%ebp),%eax
  800fd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdb:	52                   	push   %edx
  800fdc:	50                   	push   %eax
  800fdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe0:	ff 75 f0             	pushl  -0x10(%ebp)
  800fe3:	e8 74 15 00 00       	call   80255c <__udivdi3>
  800fe8:	83 c4 10             	add    $0x10,%esp
  800feb:	83 ec 04             	sub    $0x4,%esp
  800fee:	ff 75 20             	pushl  0x20(%ebp)
  800ff1:	53                   	push   %ebx
  800ff2:	ff 75 18             	pushl  0x18(%ebp)
  800ff5:	52                   	push   %edx
  800ff6:	50                   	push   %eax
  800ff7:	ff 75 0c             	pushl  0xc(%ebp)
  800ffa:	ff 75 08             	pushl  0x8(%ebp)
  800ffd:	e8 a1 ff ff ff       	call   800fa3 <printnum>
  801002:	83 c4 20             	add    $0x20,%esp
  801005:	eb 1a                	jmp    801021 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	ff 75 20             	pushl  0x20(%ebp)
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	ff d0                	call   *%eax
  801015:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801018:	ff 4d 1c             	decl   0x1c(%ebp)
  80101b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80101f:	7f e6                	jg     801007 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801021:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102f:	53                   	push   %ebx
  801030:	51                   	push   %ecx
  801031:	52                   	push   %edx
  801032:	50                   	push   %eax
  801033:	e8 34 16 00 00       	call   80266c <__umoddi3>
  801038:	83 c4 10             	add    $0x10,%esp
  80103b:	05 54 2f 80 00       	add    $0x802f54,%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	0f be c0             	movsbl %al,%eax
  801045:	83 ec 08             	sub    $0x8,%esp
  801048:	ff 75 0c             	pushl  0xc(%ebp)
  80104b:	50                   	push   %eax
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	ff d0                	call   *%eax
  801051:	83 c4 10             	add    $0x10,%esp
}
  801054:	90                   	nop
  801055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80105d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801061:	7e 1c                	jle    80107f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8b 00                	mov    (%eax),%eax
  801068:	8d 50 08             	lea    0x8(%eax),%edx
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	89 10                	mov    %edx,(%eax)
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8b 00                	mov    (%eax),%eax
  801075:	83 e8 08             	sub    $0x8,%eax
  801078:	8b 50 04             	mov    0x4(%eax),%edx
  80107b:	8b 00                	mov    (%eax),%eax
  80107d:	eb 40                	jmp    8010bf <getuint+0x65>
	else if (lflag)
  80107f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801083:	74 1e                	je     8010a3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8b 00                	mov    (%eax),%eax
  80108a:	8d 50 04             	lea    0x4(%eax),%edx
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	89 10                	mov    %edx,(%eax)
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8b 00                	mov    (%eax),%eax
  801097:	83 e8 04             	sub    $0x4,%eax
  80109a:	8b 00                	mov    (%eax),%eax
  80109c:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a1:	eb 1c                	jmp    8010bf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8b 00                	mov    (%eax),%eax
  8010a8:	8d 50 04             	lea    0x4(%eax),%edx
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 10                	mov    %edx,(%eax)
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	83 e8 04             	sub    $0x4,%eax
  8010b8:	8b 00                	mov    (%eax),%eax
  8010ba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010c8:	7e 1c                	jle    8010e6 <getint+0x25>
		return va_arg(*ap, long long);
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	8d 50 08             	lea    0x8(%eax),%edx
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	89 10                	mov    %edx,(%eax)
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8b 00                	mov    (%eax),%eax
  8010dc:	83 e8 08             	sub    $0x8,%eax
  8010df:	8b 50 04             	mov    0x4(%eax),%edx
  8010e2:	8b 00                	mov    (%eax),%eax
  8010e4:	eb 38                	jmp    80111e <getint+0x5d>
	else if (lflag)
  8010e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ea:	74 1a                	je     801106 <getint+0x45>
		return va_arg(*ap, long);
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8b 00                	mov    (%eax),%eax
  8010f1:	8d 50 04             	lea    0x4(%eax),%edx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 10                	mov    %edx,(%eax)
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	83 e8 04             	sub    $0x4,%eax
  801101:	8b 00                	mov    (%eax),%eax
  801103:	99                   	cltd   
  801104:	eb 18                	jmp    80111e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	8d 50 04             	lea    0x4(%eax),%edx
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	89 10                	mov    %edx,(%eax)
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8b 00                	mov    (%eax),%eax
  801118:	83 e8 04             	sub    $0x4,%eax
  80111b:	8b 00                	mov    (%eax),%eax
  80111d:	99                   	cltd   
}
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
  801125:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801128:	eb 17                	jmp    801141 <vprintfmt+0x21>
			if (ch == '\0')
  80112a:	85 db                	test   %ebx,%ebx
  80112c:	0f 84 c1 03 00 00    	je     8014f3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801132:	83 ec 08             	sub    $0x8,%esp
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	53                   	push   %ebx
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	ff d0                	call   *%eax
  80113e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	8d 50 01             	lea    0x1(%eax),%edx
  801147:	89 55 10             	mov    %edx,0x10(%ebp)
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d8             	movzbl %al,%ebx
  80114f:	83 fb 25             	cmp    $0x25,%ebx
  801152:	75 d6                	jne    80112a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801154:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801158:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80115f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801166:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80116d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	8d 50 01             	lea    0x1(%eax),%edx
  80117a:	89 55 10             	mov    %edx,0x10(%ebp)
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f b6 d8             	movzbl %al,%ebx
  801182:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801185:	83 f8 5b             	cmp    $0x5b,%eax
  801188:	0f 87 3d 03 00 00    	ja     8014cb <vprintfmt+0x3ab>
  80118e:	8b 04 85 78 2f 80 00 	mov    0x802f78(,%eax,4),%eax
  801195:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801197:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80119b:	eb d7                	jmp    801174 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80119d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011a1:	eb d1                	jmp    801174 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	c1 e0 02             	shl    $0x2,%eax
  8011b2:	01 d0                	add    %edx,%eax
  8011b4:	01 c0                	add    %eax,%eax
  8011b6:	01 d8                	add    %ebx,%eax
  8011b8:	83 e8 30             	sub    $0x30,%eax
  8011bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011c6:	83 fb 2f             	cmp    $0x2f,%ebx
  8011c9:	7e 3e                	jle    801209 <vprintfmt+0xe9>
  8011cb:	83 fb 39             	cmp    $0x39,%ebx
  8011ce:	7f 39                	jg     801209 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011d0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011d3:	eb d5                	jmp    8011aa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 14             	mov    %eax,0x14(%ebp)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	83 e8 04             	sub    $0x4,%eax
  8011e4:	8b 00                	mov    (%eax),%eax
  8011e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011e9:	eb 1f                	jmp    80120a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011ef:	79 83                	jns    801174 <vprintfmt+0x54>
				width = 0;
  8011f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011f8:	e9 77 ff ff ff       	jmp    801174 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801204:	e9 6b ff ff ff       	jmp    801174 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801209:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80120a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80120e:	0f 89 60 ff ff ff    	jns    801174 <vprintfmt+0x54>
				width = precision, precision = -1;
  801214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801217:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80121a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801221:	e9 4e ff ff ff       	jmp    801174 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801226:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801229:	e9 46 ff ff ff       	jmp    801174 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80122e:	8b 45 14             	mov    0x14(%ebp),%eax
  801231:	83 c0 04             	add    $0x4,%eax
  801234:	89 45 14             	mov    %eax,0x14(%ebp)
  801237:	8b 45 14             	mov    0x14(%ebp),%eax
  80123a:	83 e8 04             	sub    $0x4,%eax
  80123d:	8b 00                	mov    (%eax),%eax
  80123f:	83 ec 08             	sub    $0x8,%esp
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	50                   	push   %eax
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	ff d0                	call   *%eax
  80124b:	83 c4 10             	add    $0x10,%esp
			break;
  80124e:	e9 9b 02 00 00       	jmp    8014ee <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801253:	8b 45 14             	mov    0x14(%ebp),%eax
  801256:	83 c0 04             	add    $0x4,%eax
  801259:	89 45 14             	mov    %eax,0x14(%ebp)
  80125c:	8b 45 14             	mov    0x14(%ebp),%eax
  80125f:	83 e8 04             	sub    $0x4,%eax
  801262:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801264:	85 db                	test   %ebx,%ebx
  801266:	79 02                	jns    80126a <vprintfmt+0x14a>
				err = -err;
  801268:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80126a:	83 fb 64             	cmp    $0x64,%ebx
  80126d:	7f 0b                	jg     80127a <vprintfmt+0x15a>
  80126f:	8b 34 9d c0 2d 80 00 	mov    0x802dc0(,%ebx,4),%esi
  801276:	85 f6                	test   %esi,%esi
  801278:	75 19                	jne    801293 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80127a:	53                   	push   %ebx
  80127b:	68 65 2f 80 00       	push   $0x802f65
  801280:	ff 75 0c             	pushl  0xc(%ebp)
  801283:	ff 75 08             	pushl  0x8(%ebp)
  801286:	e8 70 02 00 00       	call   8014fb <printfmt>
  80128b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80128e:	e9 5b 02 00 00       	jmp    8014ee <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801293:	56                   	push   %esi
  801294:	68 6e 2f 80 00       	push   $0x802f6e
  801299:	ff 75 0c             	pushl  0xc(%ebp)
  80129c:	ff 75 08             	pushl  0x8(%ebp)
  80129f:	e8 57 02 00 00       	call   8014fb <printfmt>
  8012a4:	83 c4 10             	add    $0x10,%esp
			break;
  8012a7:	e9 42 02 00 00       	jmp    8014ee <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8012af:	83 c0 04             	add    $0x4,%eax
  8012b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8012b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b8:	83 e8 04             	sub    $0x4,%eax
  8012bb:	8b 30                	mov    (%eax),%esi
  8012bd:	85 f6                	test   %esi,%esi
  8012bf:	75 05                	jne    8012c6 <vprintfmt+0x1a6>
				p = "(null)";
  8012c1:	be 71 2f 80 00       	mov    $0x802f71,%esi
			if (width > 0 && padc != '-')
  8012c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012ca:	7e 6d                	jle    801339 <vprintfmt+0x219>
  8012cc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012d0:	74 67                	je     801339 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	50                   	push   %eax
  8012d9:	56                   	push   %esi
  8012da:	e8 1e 03 00 00       	call   8015fd <strnlen>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012e5:	eb 16                	jmp    8012fd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012e7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	50                   	push   %eax
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	ff d0                	call   *%eax
  8012f7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012fa:	ff 4d e4             	decl   -0x1c(%ebp)
  8012fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801301:	7f e4                	jg     8012e7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801303:	eb 34                	jmp    801339 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801305:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801309:	74 1c                	je     801327 <vprintfmt+0x207>
  80130b:	83 fb 1f             	cmp    $0x1f,%ebx
  80130e:	7e 05                	jle    801315 <vprintfmt+0x1f5>
  801310:	83 fb 7e             	cmp    $0x7e,%ebx
  801313:	7e 12                	jle    801327 <vprintfmt+0x207>
					putch('?', putdat);
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	ff 75 0c             	pushl  0xc(%ebp)
  80131b:	6a 3f                	push   $0x3f
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	ff d0                	call   *%eax
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	eb 0f                	jmp    801336 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	53                   	push   %ebx
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	ff d0                	call   *%eax
  801333:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801336:	ff 4d e4             	decl   -0x1c(%ebp)
  801339:	89 f0                	mov    %esi,%eax
  80133b:	8d 70 01             	lea    0x1(%eax),%esi
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be d8             	movsbl %al,%ebx
  801343:	85 db                	test   %ebx,%ebx
  801345:	74 24                	je     80136b <vprintfmt+0x24b>
  801347:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80134b:	78 b8                	js     801305 <vprintfmt+0x1e5>
  80134d:	ff 4d e0             	decl   -0x20(%ebp)
  801350:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801354:	79 af                	jns    801305 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801356:	eb 13                	jmp    80136b <vprintfmt+0x24b>
				putch(' ', putdat);
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	ff 75 0c             	pushl  0xc(%ebp)
  80135e:	6a 20                	push   $0x20
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	ff d0                	call   *%eax
  801365:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801368:	ff 4d e4             	decl   -0x1c(%ebp)
  80136b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136f:	7f e7                	jg     801358 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801371:	e9 78 01 00 00       	jmp    8014ee <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801376:	83 ec 08             	sub    $0x8,%esp
  801379:	ff 75 e8             	pushl  -0x18(%ebp)
  80137c:	8d 45 14             	lea    0x14(%ebp),%eax
  80137f:	50                   	push   %eax
  801380:	e8 3c fd ff ff       	call   8010c1 <getint>
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80138e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801394:	85 d2                	test   %edx,%edx
  801396:	79 23                	jns    8013bb <vprintfmt+0x29b>
				putch('-', putdat);
  801398:	83 ec 08             	sub    $0x8,%esp
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	6a 2d                	push   $0x2d
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	ff d0                	call   *%eax
  8013a5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ae:	f7 d8                	neg    %eax
  8013b0:	83 d2 00             	adc    $0x0,%edx
  8013b3:	f7 da                	neg    %edx
  8013b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013bb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013c2:	e9 bc 00 00 00       	jmp    801483 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8013cd:	8d 45 14             	lea    0x14(%ebp),%eax
  8013d0:	50                   	push   %eax
  8013d1:	e8 84 fc ff ff       	call   80105a <getuint>
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013e6:	e9 98 00 00 00       	jmp    801483 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013eb:	83 ec 08             	sub    $0x8,%esp
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	6a 58                	push   $0x58
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	ff d0                	call   *%eax
  8013f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013fb:	83 ec 08             	sub    $0x8,%esp
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	6a 58                	push   $0x58
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	ff d0                	call   *%eax
  801408:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80140b:	83 ec 08             	sub    $0x8,%esp
  80140e:	ff 75 0c             	pushl  0xc(%ebp)
  801411:	6a 58                	push   $0x58
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	ff d0                	call   *%eax
  801418:	83 c4 10             	add    $0x10,%esp
			break;
  80141b:	e9 ce 00 00 00       	jmp    8014ee <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801420:	83 ec 08             	sub    $0x8,%esp
  801423:	ff 75 0c             	pushl  0xc(%ebp)
  801426:	6a 30                	push   $0x30
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	ff d0                	call   *%eax
  80142d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801430:	83 ec 08             	sub    $0x8,%esp
  801433:	ff 75 0c             	pushl  0xc(%ebp)
  801436:	6a 78                	push   $0x78
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	ff d0                	call   *%eax
  80143d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801440:	8b 45 14             	mov    0x14(%ebp),%eax
  801443:	83 c0 04             	add    $0x4,%eax
  801446:	89 45 14             	mov    %eax,0x14(%ebp)
  801449:	8b 45 14             	mov    0x14(%ebp),%eax
  80144c:	83 e8 04             	sub    $0x4,%eax
  80144f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801451:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80145b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801462:	eb 1f                	jmp    801483 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801464:	83 ec 08             	sub    $0x8,%esp
  801467:	ff 75 e8             	pushl  -0x18(%ebp)
  80146a:	8d 45 14             	lea    0x14(%ebp),%eax
  80146d:	50                   	push   %eax
  80146e:	e8 e7 fb ff ff       	call   80105a <getuint>
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801479:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80147c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801483:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	52                   	push   %edx
  80148e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801491:	50                   	push   %eax
  801492:	ff 75 f4             	pushl  -0xc(%ebp)
  801495:	ff 75 f0             	pushl  -0x10(%ebp)
  801498:	ff 75 0c             	pushl  0xc(%ebp)
  80149b:	ff 75 08             	pushl  0x8(%ebp)
  80149e:	e8 00 fb ff ff       	call   800fa3 <printnum>
  8014a3:	83 c4 20             	add    $0x20,%esp
			break;
  8014a6:	eb 46                	jmp    8014ee <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	ff 75 0c             	pushl  0xc(%ebp)
  8014ae:	53                   	push   %ebx
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	ff d0                	call   *%eax
  8014b4:	83 c4 10             	add    $0x10,%esp
			break;
  8014b7:	eb 35                	jmp    8014ee <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8014b9:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
			break;
  8014c0:	eb 2c                	jmp    8014ee <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8014c2:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
			break;
  8014c9:	eb 23                	jmp    8014ee <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	ff 75 0c             	pushl  0xc(%ebp)
  8014d1:	6a 25                	push   $0x25
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	ff d0                	call   *%eax
  8014d8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014db:	ff 4d 10             	decl   0x10(%ebp)
  8014de:	eb 03                	jmp    8014e3 <vprintfmt+0x3c3>
  8014e0:	ff 4d 10             	decl   0x10(%ebp)
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	48                   	dec    %eax
  8014e7:	8a 00                	mov    (%eax),%al
  8014e9:	3c 25                	cmp    $0x25,%al
  8014eb:	75 f3                	jne    8014e0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8014ed:	90                   	nop
		}
	}
  8014ee:	e9 35 fc ff ff       	jmp    801128 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014f3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f7:	5b                   	pop    %ebx
  8014f8:	5e                   	pop    %esi
  8014f9:	5d                   	pop    %ebp
  8014fa:	c3                   	ret    

008014fb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801501:	8d 45 10             	lea    0x10(%ebp),%eax
  801504:	83 c0 04             	add    $0x4,%eax
  801507:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80150a:	8b 45 10             	mov    0x10(%ebp),%eax
  80150d:	ff 75 f4             	pushl  -0xc(%ebp)
  801510:	50                   	push   %eax
  801511:	ff 75 0c             	pushl  0xc(%ebp)
  801514:	ff 75 08             	pushl  0x8(%ebp)
  801517:	e8 04 fc ff ff       	call   801120 <vprintfmt>
  80151c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80151f:	90                   	nop
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	8b 40 08             	mov    0x8(%eax),%eax
  80152b:	8d 50 01             	lea    0x1(%eax),%edx
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	8b 10                	mov    (%eax),%edx
  801539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153c:	8b 40 04             	mov    0x4(%eax),%eax
  80153f:	39 c2                	cmp    %eax,%edx
  801541:	73 12                	jae    801555 <sprintputch+0x33>
		*b->buf++ = ch;
  801543:	8b 45 0c             	mov    0xc(%ebp),%eax
  801546:	8b 00                	mov    (%eax),%eax
  801548:	8d 48 01             	lea    0x1(%eax),%ecx
  80154b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154e:	89 0a                	mov    %ecx,(%edx)
  801550:	8b 55 08             	mov    0x8(%ebp),%edx
  801553:	88 10                	mov    %dl,(%eax)
}
  801555:	90                   	nop
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    

00801558 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801564:	8b 45 0c             	mov    0xc(%ebp),%eax
  801567:	8d 50 ff             	lea    -0x1(%eax),%edx
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801572:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801579:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80157d:	74 06                	je     801585 <vsnprintf+0x2d>
  80157f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801583:	7f 07                	jg     80158c <vsnprintf+0x34>
		return -E_INVAL;
  801585:	b8 03 00 00 00       	mov    $0x3,%eax
  80158a:	eb 20                	jmp    8015ac <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80158c:	ff 75 14             	pushl  0x14(%ebp)
  80158f:	ff 75 10             	pushl  0x10(%ebp)
  801592:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	68 22 15 80 00       	push   $0x801522
  80159b:	e8 80 fb ff ff       	call   801120 <vprintfmt>
  8015a0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8015b7:	83 c0 04             	add    $0x4,%eax
  8015ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c3:	50                   	push   %eax
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	ff 75 08             	pushl  0x8(%ebp)
  8015ca:	e8 89 ff ff ff       	call   801558 <vsnprintf>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e7:	eb 06                	jmp    8015ef <strlen+0x15>
		n++;
  8015e9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ec:	ff 45 08             	incl   0x8(%ebp)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	84 c0                	test   %al,%al
  8015f6:	75 f1                	jne    8015e9 <strlen+0xf>
		n++;
	return n;
  8015f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 09                	jmp    801615 <strnlen+0x18>
		n++;
  80160c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80160f:	ff 45 08             	incl   0x8(%ebp)
  801612:	ff 4d 0c             	decl   0xc(%ebp)
  801615:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801619:	74 09                	je     801624 <strnlen+0x27>
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	84 c0                	test   %al,%al
  801622:	75 e8                	jne    80160c <strnlen+0xf>
		n++;
	return n;
  801624:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801635:	90                   	nop
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8d 50 01             	lea    0x1(%eax),%edx
  80163c:	89 55 08             	mov    %edx,0x8(%ebp)
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8d 4a 01             	lea    0x1(%edx),%ecx
  801645:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801648:	8a 12                	mov    (%edx),%dl
  80164a:	88 10                	mov    %dl,(%eax)
  80164c:	8a 00                	mov    (%eax),%al
  80164e:	84 c0                	test   %al,%al
  801650:	75 e4                	jne    801636 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801652:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801663:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166a:	eb 1f                	jmp    80168b <strncpy+0x34>
		*dst++ = *src;
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8d 50 01             	lea    0x1(%eax),%edx
  801672:	89 55 08             	mov    %edx,0x8(%ebp)
  801675:	8b 55 0c             	mov    0xc(%ebp),%edx
  801678:	8a 12                	mov    (%edx),%dl
  80167a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80167c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 03                	je     801688 <strncpy+0x31>
			src++;
  801685:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801688:	ff 45 fc             	incl   -0x4(%ebp)
  80168b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801691:	72 d9                	jb     80166c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801693:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a8:	74 30                	je     8016da <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016aa:	eb 16                	jmp    8016c2 <strlcpy+0x2a>
			*dst++ = *src++;
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8d 50 01             	lea    0x1(%eax),%edx
  8016b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016bb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016be:	8a 12                	mov    (%edx),%dl
  8016c0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c2:	ff 4d 10             	decl   0x10(%ebp)
  8016c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c9:	74 09                	je     8016d4 <strlcpy+0x3c>
  8016cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ce:	8a 00                	mov    (%eax),%al
  8016d0:	84 c0                	test   %al,%al
  8016d2:	75 d8                	jne    8016ac <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016da:	8b 55 08             	mov    0x8(%ebp),%edx
  8016dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e0:	29 c2                	sub    %eax,%edx
  8016e2:	89 d0                	mov    %edx,%eax
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016e9:	eb 06                	jmp    8016f1 <strcmp+0xb>
		p++, q++;
  8016eb:	ff 45 08             	incl   0x8(%ebp)
  8016ee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	8a 00                	mov    (%eax),%al
  8016f6:	84 c0                	test   %al,%al
  8016f8:	74 0e                	je     801708 <strcmp+0x22>
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	8a 10                	mov    (%eax),%dl
  8016ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801702:	8a 00                	mov    (%eax),%al
  801704:	38 c2                	cmp    %al,%dl
  801706:	74 e3                	je     8016eb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	8a 00                	mov    (%eax),%al
  80170d:	0f b6 d0             	movzbl %al,%edx
  801710:	8b 45 0c             	mov    0xc(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	0f b6 c0             	movzbl %al,%eax
  801718:	29 c2                	sub    %eax,%edx
  80171a:	89 d0                	mov    %edx,%eax
}
  80171c:	5d                   	pop    %ebp
  80171d:	c3                   	ret    

0080171e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801721:	eb 09                	jmp    80172c <strncmp+0xe>
		n--, p++, q++;
  801723:	ff 4d 10             	decl   0x10(%ebp)
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	74 17                	je     801749 <strncmp+0x2b>
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	8a 00                	mov    (%eax),%al
  801737:	84 c0                	test   %al,%al
  801739:	74 0e                	je     801749 <strncmp+0x2b>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 10                	mov    (%eax),%dl
  801740:	8b 45 0c             	mov    0xc(%ebp),%eax
  801743:	8a 00                	mov    (%eax),%al
  801745:	38 c2                	cmp    %al,%dl
  801747:	74 da                	je     801723 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	75 07                	jne    801756 <strncmp+0x38>
		return 0;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
  801754:	eb 14                	jmp    80176a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	0f b6 d0             	movzbl %al,%edx
  80175e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801761:	8a 00                	mov    (%eax),%al
  801763:	0f b6 c0             	movzbl %al,%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
}
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	8b 45 0c             	mov    0xc(%ebp),%eax
  801775:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801778:	eb 12                	jmp    80178c <strchr+0x20>
		if (*s == c)
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8a 00                	mov    (%eax),%al
  80177f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801782:	75 05                	jne    801789 <strchr+0x1d>
			return (char *) s;
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	eb 11                	jmp    80179a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801789:	ff 45 08             	incl   0x8(%ebp)
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	84 c0                	test   %al,%al
  801793:	75 e5                	jne    80177a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017a8:	eb 0d                	jmp    8017b7 <strfind+0x1b>
		if (*s == c)
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017b2:	74 0e                	je     8017c2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017b4:	ff 45 08             	incl   0x8(%ebp)
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	84 c0                	test   %al,%al
  8017be:	75 ea                	jne    8017aa <strfind+0xe>
  8017c0:	eb 01                	jmp    8017c3 <strfind+0x27>
		if (*s == c)
			break;
  8017c2:	90                   	nop
	return (char *) s;
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017da:	eb 0e                	jmp    8017ea <memset+0x22>
		*p++ = c;
  8017dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017df:	8d 50 01             	lea    0x1(%eax),%edx
  8017e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017ea:	ff 4d f8             	decl   -0x8(%ebp)
  8017ed:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f1:	79 e9                	jns    8017dc <memset+0x14>
		*p++ = c;

	return v;
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801801:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80180a:	eb 16                	jmp    801822 <memcpy+0x2a>
		*d++ = *s++;
  80180c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180f:	8d 50 01             	lea    0x1(%eax),%edx
  801812:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801815:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801818:	8d 4a 01             	lea    0x1(%edx),%ecx
  80181b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80181e:	8a 12                	mov    (%edx),%dl
  801820:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801822:	8b 45 10             	mov    0x10(%ebp),%eax
  801825:	8d 50 ff             	lea    -0x1(%eax),%edx
  801828:	89 55 10             	mov    %edx,0x10(%ebp)
  80182b:	85 c0                	test   %eax,%eax
  80182d:	75 dd                	jne    80180c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80183a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801849:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80184c:	73 50                	jae    80189e <memmove+0x6a>
  80184e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801851:	8b 45 10             	mov    0x10(%ebp),%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801859:	76 43                	jbe    80189e <memmove+0x6a>
		s += n;
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
  801864:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801867:	eb 10                	jmp    801879 <memmove+0x45>
			*--d = *--s;
  801869:	ff 4d f8             	decl   -0x8(%ebp)
  80186c:	ff 4d fc             	decl   -0x4(%ebp)
  80186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801872:	8a 10                	mov    (%eax),%dl
  801874:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801877:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80187f:	89 55 10             	mov    %edx,0x10(%ebp)
  801882:	85 c0                	test   %eax,%eax
  801884:	75 e3                	jne    801869 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801886:	eb 23                	jmp    8018ab <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801888:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188b:	8d 50 01             	lea    0x1(%eax),%edx
  80188e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801891:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801894:	8d 4a 01             	lea    0x1(%edx),%ecx
  801897:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80189a:	8a 12                	mov    (%edx),%dl
  80189c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80189e:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	75 dd                	jne    801888 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018c2:	eb 2a                	jmp    8018ee <memcmp+0x3e>
		if (*s1 != *s2)
  8018c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c7:	8a 10                	mov    (%eax),%dl
  8018c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	38 c2                	cmp    %al,%dl
  8018d0:	74 16                	je     8018e8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d5:	8a 00                	mov    (%eax),%al
  8018d7:	0f b6 d0             	movzbl %al,%edx
  8018da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dd:	8a 00                	mov    (%eax),%al
  8018df:	0f b6 c0             	movzbl %al,%eax
  8018e2:	29 c2                	sub    %eax,%edx
  8018e4:	89 d0                	mov    %edx,%eax
  8018e6:	eb 18                	jmp    801900 <memcmp+0x50>
		s1++, s2++;
  8018e8:	ff 45 fc             	incl   -0x4(%ebp)
  8018eb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018f4:	89 55 10             	mov    %edx,0x10(%ebp)
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	75 c9                	jne    8018c4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801908:	8b 55 08             	mov    0x8(%ebp),%edx
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801913:	eb 15                	jmp    80192a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8a 00                	mov    (%eax),%al
  80191a:	0f b6 d0             	movzbl %al,%edx
  80191d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801920:	0f b6 c0             	movzbl %al,%eax
  801923:	39 c2                	cmp    %eax,%edx
  801925:	74 0d                	je     801934 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801927:	ff 45 08             	incl   0x8(%ebp)
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801930:	72 e3                	jb     801915 <memfind+0x13>
  801932:	eb 01                	jmp    801935 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801934:	90                   	nop
	return (void *) s;
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801940:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801947:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80194e:	eb 03                	jmp    801953 <strtol+0x19>
		s++;
  801950:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	3c 20                	cmp    $0x20,%al
  80195a:	74 f4                	je     801950 <strtol+0x16>
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	8a 00                	mov    (%eax),%al
  801961:	3c 09                	cmp    $0x9,%al
  801963:	74 eb                	je     801950 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	8a 00                	mov    (%eax),%al
  80196a:	3c 2b                	cmp    $0x2b,%al
  80196c:	75 05                	jne    801973 <strtol+0x39>
		s++;
  80196e:	ff 45 08             	incl   0x8(%ebp)
  801971:	eb 13                	jmp    801986 <strtol+0x4c>
	else if (*s == '-')
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	8a 00                	mov    (%eax),%al
  801978:	3c 2d                	cmp    $0x2d,%al
  80197a:	75 0a                	jne    801986 <strtol+0x4c>
		s++, neg = 1;
  80197c:	ff 45 08             	incl   0x8(%ebp)
  80197f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801986:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198a:	74 06                	je     801992 <strtol+0x58>
  80198c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801990:	75 20                	jne    8019b2 <strtol+0x78>
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8a 00                	mov    (%eax),%al
  801997:	3c 30                	cmp    $0x30,%al
  801999:	75 17                	jne    8019b2 <strtol+0x78>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	40                   	inc    %eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 78                	cmp    $0x78,%al
  8019a3:	75 0d                	jne    8019b2 <strtol+0x78>
		s += 2, base = 16;
  8019a5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019a9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b0:	eb 28                	jmp    8019da <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b6:	75 15                	jne    8019cd <strtol+0x93>
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	8a 00                	mov    (%eax),%al
  8019bd:	3c 30                	cmp    $0x30,%al
  8019bf:	75 0c                	jne    8019cd <strtol+0x93>
		s++, base = 8;
  8019c1:	ff 45 08             	incl   0x8(%ebp)
  8019c4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019cb:	eb 0d                	jmp    8019da <strtol+0xa0>
	else if (base == 0)
  8019cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d1:	75 07                	jne    8019da <strtol+0xa0>
		base = 10;
  8019d3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8a 00                	mov    (%eax),%al
  8019df:	3c 2f                	cmp    $0x2f,%al
  8019e1:	7e 19                	jle    8019fc <strtol+0xc2>
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	3c 39                	cmp    $0x39,%al
  8019ea:	7f 10                	jg     8019fc <strtol+0xc2>
			dig = *s - '0';
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8a 00                	mov    (%eax),%al
  8019f1:	0f be c0             	movsbl %al,%eax
  8019f4:	83 e8 30             	sub    $0x30,%eax
  8019f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019fa:	eb 42                	jmp    801a3e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	8a 00                	mov    (%eax),%al
  801a01:	3c 60                	cmp    $0x60,%al
  801a03:	7e 19                	jle    801a1e <strtol+0xe4>
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8a 00                	mov    (%eax),%al
  801a0a:	3c 7a                	cmp    $0x7a,%al
  801a0c:	7f 10                	jg     801a1e <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	8a 00                	mov    (%eax),%al
  801a13:	0f be c0             	movsbl %al,%eax
  801a16:	83 e8 57             	sub    $0x57,%eax
  801a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a1c:	eb 20                	jmp    801a3e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	8a 00                	mov    (%eax),%al
  801a23:	3c 40                	cmp    $0x40,%al
  801a25:	7e 39                	jle    801a60 <strtol+0x126>
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	3c 5a                	cmp    $0x5a,%al
  801a2e:	7f 30                	jg     801a60 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	8a 00                	mov    (%eax),%al
  801a35:	0f be c0             	movsbl %al,%eax
  801a38:	83 e8 37             	sub    $0x37,%eax
  801a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a44:	7d 19                	jge    801a5f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a46:	ff 45 08             	incl   0x8(%ebp)
  801a49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a4c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a50:	89 c2                	mov    %eax,%edx
  801a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a55:	01 d0                	add    %edx,%eax
  801a57:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a5a:	e9 7b ff ff ff       	jmp    8019da <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a5f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a64:	74 08                	je     801a6e <strtol+0x134>
		*endptr = (char *) s;
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a72:	74 07                	je     801a7b <strtol+0x141>
  801a74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a77:	f7 d8                	neg    %eax
  801a79:	eb 03                	jmp    801a7e <strtol+0x144>
  801a7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <ltostr>:

void
ltostr(long value, char *str)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a98:	79 13                	jns    801aad <ltostr+0x2d>
	{
		neg = 1;
  801a9a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aa7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801aaa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801ab5:	99                   	cltd   
  801ab6:	f7 f9                	idiv   %ecx
  801ab8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801abb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abe:	8d 50 01             	lea    0x1(%eax),%edx
  801ac1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ac4:	89 c2                	mov    %eax,%edx
  801ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac9:	01 d0                	add    %edx,%eax
  801acb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ace:	83 c2 30             	add    $0x30,%edx
  801ad1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ad3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801adb:	f7 e9                	imul   %ecx
  801add:	c1 fa 02             	sar    $0x2,%edx
  801ae0:	89 c8                	mov    %ecx,%eax
  801ae2:	c1 f8 1f             	sar    $0x1f,%eax
  801ae5:	29 c2                	sub    %eax,%edx
  801ae7:	89 d0                	mov    %edx,%eax
  801ae9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801aec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801af0:	75 bb                	jne    801aad <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afc:	48                   	dec    %eax
  801afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b00:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b04:	74 3d                	je     801b43 <ltostr+0xc3>
		start = 1 ;
  801b06:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0d:	eb 34                	jmp    801b43 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b15:	01 d0                	add    %edx,%eax
  801b17:	8a 00                	mov    (%eax),%al
  801b19:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b22:	01 c2                	add    %eax,%edx
  801b24:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2a:	01 c8                	add    %ecx,%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b36:	01 c2                	add    %eax,%edx
  801b38:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3b:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b40:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b49:	7c c4                	jl     801b0f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b51:	01 d0                	add    %edx,%eax
  801b53:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b56:	90                   	nop
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b5f:	ff 75 08             	pushl  0x8(%ebp)
  801b62:	e8 73 fa ff ff       	call   8015da <strlen>
  801b67:	83 c4 04             	add    $0x4,%esp
  801b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	e8 65 fa ff ff       	call   8015da <strlen>
  801b75:	83 c4 04             	add    $0x4,%esp
  801b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b89:	eb 17                	jmp    801ba2 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b91:	01 c2                	add    %eax,%edx
  801b93:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	01 c8                	add    %ecx,%eax
  801b9b:	8a 00                	mov    (%eax),%al
  801b9d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b9f:	ff 45 fc             	incl   -0x4(%ebp)
  801ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ba8:	7c e1                	jl     801b8b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801baa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bb8:	eb 1f                	jmp    801bd9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbd:	8d 50 01             	lea    0x1(%eax),%edx
  801bc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc3:	89 c2                	mov    %eax,%edx
  801bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc8:	01 c2                	add    %eax,%edx
  801bca:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd0:	01 c8                	add    %ecx,%eax
  801bd2:	8a 00                	mov    (%eax),%al
  801bd4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd6:	ff 45 f8             	incl   -0x8(%ebp)
  801bd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bdc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bdf:	7c d9                	jl     801bba <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be4:	8b 45 10             	mov    0x10(%ebp),%eax
  801be7:	01 d0                	add    %edx,%eax
  801be9:	c6 00 00             	movb   $0x0,(%eax)
}
  801bec:	90                   	nop
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfe:	8b 00                	mov    (%eax),%eax
  801c00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c07:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0a:	01 d0                	add    %edx,%eax
  801c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c12:	eb 0c                	jmp    801c20 <strsplit+0x31>
			*string++ = 0;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	8d 50 01             	lea    0x1(%eax),%edx
  801c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	84 c0                	test   %al,%al
  801c27:	74 18                	je     801c41 <strsplit+0x52>
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	0f be c0             	movsbl %al,%eax
  801c31:	50                   	push   %eax
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	e8 32 fb ff ff       	call   80176c <strchr>
  801c3a:	83 c4 08             	add    $0x8,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	75 d3                	jne    801c14 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	8a 00                	mov    (%eax),%al
  801c46:	84 c0                	test   %al,%al
  801c48:	74 5a                	je     801ca4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4d:	8b 00                	mov    (%eax),%eax
  801c4f:	83 f8 0f             	cmp    $0xf,%eax
  801c52:	75 07                	jne    801c5b <strsplit+0x6c>
		{
			return 0;
  801c54:	b8 00 00 00 00       	mov    $0x0,%eax
  801c59:	eb 66                	jmp    801cc1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5e:	8b 00                	mov    (%eax),%eax
  801c60:	8d 48 01             	lea    0x1(%eax),%ecx
  801c63:	8b 55 14             	mov    0x14(%ebp),%edx
  801c66:	89 0a                	mov    %ecx,(%edx)
  801c68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c72:	01 c2                	add    %eax,%edx
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c79:	eb 03                	jmp    801c7e <strsplit+0x8f>
			string++;
  801c7b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	8a 00                	mov    (%eax),%al
  801c83:	84 c0                	test   %al,%al
  801c85:	74 8b                	je     801c12 <strsplit+0x23>
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	8a 00                	mov    (%eax),%al
  801c8c:	0f be c0             	movsbl %al,%eax
  801c8f:	50                   	push   %eax
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	e8 d4 fa ff ff       	call   80176c <strchr>
  801c98:	83 c4 08             	add    $0x8,%esp
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	74 dc                	je     801c7b <strsplit+0x8c>
			string++;
	}
  801c9f:	e9 6e ff ff ff       	jmp    801c12 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca8:	8b 00                	mov    (%eax),%eax
  801caa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb4:	01 d0                	add    %edx,%eax
  801cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	68 e8 30 80 00       	push   $0x8030e8
  801cd1:	68 3f 01 00 00       	push   $0x13f
  801cd6:	68 0a 31 80 00       	push   $0x80310a
  801cdb:	e8 a9 ef ff ff       	call   800c89 <_panic>

00801ce0 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	ff 75 08             	pushl  0x8(%ebp)
  801cec:	e8 ef 06 00 00       	call   8023e0 <sys_sbrk>
  801cf1:	83 c4 10             	add    $0x10,%esp
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801cfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d00:	75 07                	jne    801d09 <malloc+0x13>
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	eb 14                	jmp    801d1d <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 18 31 80 00       	push   $0x803118
  801d11:	6a 1b                	push   $0x1b
  801d13:	68 3d 31 80 00       	push   $0x80313d
  801d18:	e8 6c ef ff ff       	call   800c89 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	68 4c 31 80 00       	push   $0x80314c
  801d2d:	6a 29                	push   $0x29
  801d2f:	68 3d 31 80 00       	push   $0x80313d
  801d34:	e8 50 ef ff ff       	call   800c89 <_panic>

00801d39 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 18             	sub    $0x18,%esp
  801d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d42:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801d45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d49:	75 07                	jne    801d52 <smalloc+0x19>
  801d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d50:	eb 14                	jmp    801d66 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801d52:	83 ec 04             	sub    $0x4,%esp
  801d55:	68 70 31 80 00       	push   $0x803170
  801d5a:	6a 38                	push   $0x38
  801d5c:	68 3d 31 80 00       	push   $0x80313d
  801d61:	e8 23 ef ff ff       	call   800c89 <_panic>
	return NULL;
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d6e:	83 ec 04             	sub    $0x4,%esp
  801d71:	68 98 31 80 00       	push   $0x803198
  801d76:	6a 43                	push   $0x43
  801d78:	68 3d 31 80 00       	push   $0x80313d
  801d7d:	e8 07 ef ff ff       	call   800c89 <_panic>

00801d82 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	68 bc 31 80 00       	push   $0x8031bc
  801d90:	6a 5b                	push   $0x5b
  801d92:	68 3d 31 80 00       	push   $0x80313d
  801d97:	e8 ed ee ff ff       	call   800c89 <_panic>

00801d9c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	68 e0 31 80 00       	push   $0x8031e0
  801daa:	6a 72                	push   $0x72
  801dac:	68 3d 31 80 00       	push   $0x80313d
  801db1:	e8 d3 ee ff ff       	call   800c89 <_panic>

00801db6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	68 06 32 80 00       	push   $0x803206
  801dc4:	6a 7e                	push   $0x7e
  801dc6:	68 3d 31 80 00       	push   $0x80313d
  801dcb:	e8 b9 ee ff ff       	call   800c89 <_panic>

00801dd0 <shrink>:

}
void shrink(uint32 newSize)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dd6:	83 ec 04             	sub    $0x4,%esp
  801dd9:	68 06 32 80 00       	push   $0x803206
  801dde:	68 83 00 00 00       	push   $0x83
  801de3:	68 3d 31 80 00       	push   $0x80313d
  801de8:	e8 9c ee ff ff       	call   800c89 <_panic>

00801ded <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801df3:	83 ec 04             	sub    $0x4,%esp
  801df6:	68 06 32 80 00       	push   $0x803206
  801dfb:	68 88 00 00 00       	push   $0x88
  801e00:	68 3d 31 80 00       	push   $0x80313d
  801e05:	e8 7f ee ff ff       	call   800c89 <_panic>

00801e0a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	57                   	push   %edi
  801e0e:	56                   	push   %esi
  801e0f:	53                   	push   %ebx
  801e10:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e1f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e22:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e25:	cd 30                	int    $0x30
  801e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5e                   	pop    %esi
  801e32:	5f                   	pop    %edi
  801e33:	5d                   	pop    %ebp
  801e34:	c3                   	ret    

00801e35 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e41:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	52                   	push   %edx
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	50                   	push   %eax
  801e51:	6a 00                	push   $0x0
  801e53:	e8 b2 ff ff ff       	call   801e0a <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	90                   	nop
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_cgetc>:

int
sys_cgetc(void)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 02                	push   $0x2
  801e6d:	e8 98 ff ff ff       	call   801e0a <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 03                	push   $0x3
  801e86:	e8 7f ff ff ff       	call   801e0a <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	90                   	nop
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 04                	push   $0x4
  801ea0:	e8 65 ff ff ff       	call   801e0a <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	90                   	nop
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	52                   	push   %edx
  801ebb:	50                   	push   %eax
  801ebc:	6a 08                	push   $0x8
  801ebe:	e8 47 ff ff ff       	call   801e0a <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	56                   	push   %esi
  801ecc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ecd:	8b 75 18             	mov    0x18(%ebp),%esi
  801ed0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	56                   	push   %esi
  801edd:	53                   	push   %ebx
  801ede:	51                   	push   %ecx
  801edf:	52                   	push   %edx
  801ee0:	50                   	push   %eax
  801ee1:	6a 09                	push   $0x9
  801ee3:	e8 22 ff ff ff       	call   801e0a <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
}
  801eeb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eee:	5b                   	pop    %ebx
  801eef:	5e                   	pop    %esi
  801ef0:	5d                   	pop    %ebp
  801ef1:	c3                   	ret    

00801ef2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	52                   	push   %edx
  801f02:	50                   	push   %eax
  801f03:	6a 0a                	push   $0xa
  801f05:	e8 00 ff ff ff       	call   801e0a <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	6a 0b                	push   $0xb
  801f20:	e8 e5 fe ff ff       	call   801e0a <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 0c                	push   $0xc
  801f39:	e8 cc fe ff ff       	call   801e0a <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 0d                	push   $0xd
  801f52:	e8 b3 fe ff ff       	call   801e0a <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 0e                	push   $0xe
  801f6b:	e8 9a fe ff ff       	call   801e0a <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 0f                	push   $0xf
  801f84:	e8 81 fe ff ff       	call   801e0a <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	ff 75 08             	pushl  0x8(%ebp)
  801f9c:	6a 10                	push   $0x10
  801f9e:	e8 67 fe ff ff       	call   801e0a <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 11                	push   $0x11
  801fb7:	e8 4e fe ff ff       	call   801e0a <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	90                   	nop
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_cputc>:

void
sys_cputc(const char c)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	50                   	push   %eax
  801fdb:	6a 01                	push   $0x1
  801fdd:	e8 28 fe ff ff       	call   801e0a <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	90                   	nop
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 14                	push   $0x14
  801ff7:	e8 0e fe ff ff       	call   801e0a <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	90                   	nop
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	8b 45 10             	mov    0x10(%ebp),%eax
  80200b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80200e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802011:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	6a 00                	push   $0x0
  80201a:	51                   	push   %ecx
  80201b:	52                   	push   %edx
  80201c:	ff 75 0c             	pushl  0xc(%ebp)
  80201f:	50                   	push   %eax
  802020:	6a 15                	push   $0x15
  802022:	e8 e3 fd ff ff       	call   801e0a <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80202f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	52                   	push   %edx
  80203c:	50                   	push   %eax
  80203d:	6a 16                	push   $0x16
  80203f:	e8 c6 fd ff ff       	call   801e0a <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80204c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	51                   	push   %ecx
  80205a:	52                   	push   %edx
  80205b:	50                   	push   %eax
  80205c:	6a 17                	push   $0x17
  80205e:	e8 a7 fd ff ff       	call   801e0a <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80206b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	52                   	push   %edx
  802078:	50                   	push   %eax
  802079:	6a 18                	push   $0x18
  80207b:	e8 8a fd ff ff       	call   801e0a <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	6a 00                	push   $0x0
  80208d:	ff 75 14             	pushl  0x14(%ebp)
  802090:	ff 75 10             	pushl  0x10(%ebp)
  802093:	ff 75 0c             	pushl  0xc(%ebp)
  802096:	50                   	push   %eax
  802097:	6a 19                	push   $0x19
  802099:	e8 6c fd ff ff       	call   801e0a <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	50                   	push   %eax
  8020b2:	6a 1a                	push   $0x1a
  8020b4:	e8 51 fd ff ff       	call   801e0a <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	90                   	nop
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	50                   	push   %eax
  8020ce:	6a 1b                	push   $0x1b
  8020d0:	e8 35 fd ff ff       	call   801e0a <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 05                	push   $0x5
  8020e9:	e8 1c fd ff ff       	call   801e0a <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 06                	push   $0x6
  802102:	e8 03 fd ff ff       	call   801e0a <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 07                	push   $0x7
  80211b:	e8 ea fc ff ff       	call   801e0a <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_exit_env>:


void sys_exit_env(void)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 1c                	push   $0x1c
  802134:	e8 d1 fc ff ff       	call   801e0a <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
}
  80213c:	90                   	nop
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802145:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802148:	8d 50 04             	lea    0x4(%eax),%edx
  80214b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	52                   	push   %edx
  802155:	50                   	push   %eax
  802156:	6a 1d                	push   $0x1d
  802158:	e8 ad fc ff ff       	call   801e0a <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
	return result;
  802160:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802166:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802169:	89 01                	mov    %eax,(%ecx)
  80216b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	c9                   	leave  
  802172:	c2 04 00             	ret    $0x4

00802175 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	ff 75 10             	pushl  0x10(%ebp)
  80217f:	ff 75 0c             	pushl  0xc(%ebp)
  802182:	ff 75 08             	pushl  0x8(%ebp)
  802185:	6a 13                	push   $0x13
  802187:	e8 7e fc ff ff       	call   801e0a <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
	return ;
  80218f:	90                   	nop
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_rcr2>:
uint32 sys_rcr2()
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 1e                	push   $0x1e
  8021a1:	e8 64 fc ff ff       	call   801e0a <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	50                   	push   %eax
  8021c4:	6a 1f                	push   $0x1f
  8021c6:	e8 3f fc ff ff       	call   801e0a <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ce:	90                   	nop
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <rsttst>:
void rsttst()
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 21                	push   $0x21
  8021e0:	e8 25 fc ff ff       	call   801e0a <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e8:	90                   	nop
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8021fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021fe:	52                   	push   %edx
  8021ff:	50                   	push   %eax
  802200:	ff 75 10             	pushl  0x10(%ebp)
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	6a 20                	push   $0x20
  80220b:	e8 fa fb ff ff       	call   801e0a <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
	return ;
  802213:	90                   	nop
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <chktst>:
void chktst(uint32 n)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	ff 75 08             	pushl  0x8(%ebp)
  802224:	6a 22                	push   $0x22
  802226:	e8 df fb ff ff       	call   801e0a <syscall>
  80222b:	83 c4 18             	add    $0x18,%esp
	return ;
  80222e:	90                   	nop
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <inctst>:

void inctst()
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 23                	push   $0x23
  802240:	e8 c5 fb ff ff       	call   801e0a <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
	return ;
  802248:	90                   	nop
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <gettst>:
uint32 gettst()
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 24                	push   $0x24
  80225a:	e8 ab fb ff ff       	call   801e0a <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 25                	push   $0x25
  802276:	e8 8f fb ff ff       	call   801e0a <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
  80227e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802281:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802285:	75 07                	jne    80228e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802287:	b8 01 00 00 00       	mov    $0x1,%eax
  80228c:	eb 05                	jmp    802293 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 25                	push   $0x25
  8022a7:	e8 5e fb ff ff       	call   801e0a <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
  8022af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022b2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022b6:	75 07                	jne    8022bf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bd:	eb 05                	jmp    8022c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 25                	push   $0x25
  8022d8:	e8 2d fb ff ff       	call   801e0a <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
  8022e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022e3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022e7:	75 07                	jne    8022f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ee:	eb 05                	jmp    8022f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 25                	push   $0x25
  802309:	e8 fc fa ff ff       	call   801e0a <syscall>
  80230e:	83 c4 18             	add    $0x18,%esp
  802311:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802314:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802318:	75 07                	jne    802321 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80231a:	b8 01 00 00 00       	mov    $0x1,%eax
  80231f:	eb 05                	jmp    802326 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802321:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	ff 75 08             	pushl  0x8(%ebp)
  802336:	6a 26                	push   $0x26
  802338:	e8 cd fa ff ff       	call   801e0a <syscall>
  80233d:	83 c4 18             	add    $0x18,%esp
	return ;
  802340:	90                   	nop
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802347:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80234a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80234d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	53                   	push   %ebx
  802356:	51                   	push   %ecx
  802357:	52                   	push   %edx
  802358:	50                   	push   %eax
  802359:	6a 27                	push   $0x27
  80235b:	e8 aa fa ff ff       	call   801e0a <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
}
  802363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80236b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	52                   	push   %edx
  802378:	50                   	push   %eax
  802379:	6a 28                	push   $0x28
  80237b:	e8 8a fa ff ff       	call   801e0a <syscall>
  802380:	83 c4 18             	add    $0x18,%esp
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802388:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80238b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	6a 00                	push   $0x0
  802393:	51                   	push   %ecx
  802394:	ff 75 10             	pushl  0x10(%ebp)
  802397:	52                   	push   %edx
  802398:	50                   	push   %eax
  802399:	6a 29                	push   $0x29
  80239b:	e8 6a fa ff ff       	call   801e0a <syscall>
  8023a0:	83 c4 18             	add    $0x18,%esp
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	ff 75 10             	pushl  0x10(%ebp)
  8023af:	ff 75 0c             	pushl  0xc(%ebp)
  8023b2:	ff 75 08             	pushl  0x8(%ebp)
  8023b5:	6a 12                	push   $0x12
  8023b7:	e8 4e fa ff ff       	call   801e0a <syscall>
  8023bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023bf:	90                   	nop
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8023c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	52                   	push   %edx
  8023d2:	50                   	push   %eax
  8023d3:	6a 2a                	push   $0x2a
  8023d5:	e8 30 fa ff ff       	call   801e0a <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
	return;
  8023dd:	90                   	nop
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	50                   	push   %eax
  8023ef:	6a 2b                	push   $0x2b
  8023f1:	e8 14 fa ff ff       	call   801e0a <syscall>
  8023f6:	83 c4 18             	add    $0x18,%esp
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	ff 75 0c             	pushl  0xc(%ebp)
  802407:	ff 75 08             	pushl  0x8(%ebp)
  80240a:	6a 2c                	push   $0x2c
  80240c:	e8 f9 f9 ff ff       	call   801e0a <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
	return;
  802414:	90                   	nop
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	ff 75 0c             	pushl  0xc(%ebp)
  802423:	ff 75 08             	pushl  0x8(%ebp)
  802426:	6a 2d                	push   $0x2d
  802428:	e8 dd f9 ff ff       	call   801e0a <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
	return;
  802430:	90                   	nop
}
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	68 18 32 80 00       	push   $0x803218
  802441:	6a 09                	push   $0x9
  802443:	68 40 32 80 00       	push   $0x803240
  802448:	e8 3c e8 ff ff       	call   800c89 <_panic>

0080244d <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 50 32 80 00       	push   $0x803250
  80245b:	6a 10                	push   $0x10
  80245d:	68 40 32 80 00       	push   $0x803240
  802462:	e8 22 e8 ff ff       	call   800c89 <_panic>

00802467 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	68 78 32 80 00       	push   $0x803278
  802475:	6a 18                	push   $0x18
  802477:	68 40 32 80 00       	push   $0x803240
  80247c:	e8 08 e8 ff ff       	call   800c89 <_panic>

00802481 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  802487:	83 ec 04             	sub    $0x4,%esp
  80248a:	68 a0 32 80 00       	push   $0x8032a0
  80248f:	6a 20                	push   $0x20
  802491:	68 40 32 80 00       	push   $0x803240
  802496:	e8 ee e7 ff ff       	call   800c89 <_panic>

0080249b <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	8b 40 10             	mov    0x10(%eax),%eax
}
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    

008024a6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8024ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8024af:	89 d0                	mov    %edx,%eax
  8024b1:	c1 e0 02             	shl    $0x2,%eax
  8024b4:	01 d0                	add    %edx,%eax
  8024b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024bd:	01 d0                	add    %edx,%eax
  8024bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024c6:	01 d0                	add    %edx,%eax
  8024c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024cf:	01 d0                	add    %edx,%eax
  8024d1:	c1 e0 04             	shl    $0x4,%eax
  8024d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8024d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8024de:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8024e1:	83 ec 0c             	sub    $0xc,%esp
  8024e4:	50                   	push   %eax
  8024e5:	e8 55 fc ff ff       	call   80213f <sys_get_virtual_time>
  8024ea:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8024ed:	eb 41                	jmp    802530 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8024ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8024f2:	83 ec 0c             	sub    $0xc,%esp
  8024f5:	50                   	push   %eax
  8024f6:	e8 44 fc ff ff       	call   80213f <sys_get_virtual_time>
  8024fb:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8024fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802501:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802504:	29 c2                	sub    %eax,%edx
  802506:	89 d0                	mov    %edx,%eax
  802508:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80250b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80250e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802511:	89 d1                	mov    %edx,%ecx
  802513:	29 c1                	sub    %eax,%ecx
  802515:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251b:	39 c2                	cmp    %eax,%edx
  80251d:	0f 97 c0             	seta   %al
  802520:	0f b6 c0             	movzbl %al,%eax
  802523:	29 c1                	sub    %eax,%ecx
  802525:	89 c8                	mov    %ecx,%eax
  802527:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80252a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80252d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802536:	72 b7                	jb     8024ef <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802538:	90                   	nop
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802541:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802548:	eb 03                	jmp    80254d <busy_wait+0x12>
  80254a:	ff 45 fc             	incl   -0x4(%ebp)
  80254d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802550:	3b 45 08             	cmp    0x8(%ebp),%eax
  802553:	72 f5                	jb     80254a <busy_wait+0xf>
	return i;
  802555:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    
  80255a:	66 90                	xchg   %ax,%ax

0080255c <__udivdi3>:
  80255c:	55                   	push   %ebp
  80255d:	57                   	push   %edi
  80255e:	56                   	push   %esi
  80255f:	53                   	push   %ebx
  802560:	83 ec 1c             	sub    $0x1c,%esp
  802563:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802567:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80256b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80256f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802573:	89 ca                	mov    %ecx,%edx
  802575:	89 f8                	mov    %edi,%eax
  802577:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80257b:	85 f6                	test   %esi,%esi
  80257d:	75 2d                	jne    8025ac <__udivdi3+0x50>
  80257f:	39 cf                	cmp    %ecx,%edi
  802581:	77 65                	ja     8025e8 <__udivdi3+0x8c>
  802583:	89 fd                	mov    %edi,%ebp
  802585:	85 ff                	test   %edi,%edi
  802587:	75 0b                	jne    802594 <__udivdi3+0x38>
  802589:	b8 01 00 00 00       	mov    $0x1,%eax
  80258e:	31 d2                	xor    %edx,%edx
  802590:	f7 f7                	div    %edi
  802592:	89 c5                	mov    %eax,%ebp
  802594:	31 d2                	xor    %edx,%edx
  802596:	89 c8                	mov    %ecx,%eax
  802598:	f7 f5                	div    %ebp
  80259a:	89 c1                	mov    %eax,%ecx
  80259c:	89 d8                	mov    %ebx,%eax
  80259e:	f7 f5                	div    %ebp
  8025a0:	89 cf                	mov    %ecx,%edi
  8025a2:	89 fa                	mov    %edi,%edx
  8025a4:	83 c4 1c             	add    $0x1c,%esp
  8025a7:	5b                   	pop    %ebx
  8025a8:	5e                   	pop    %esi
  8025a9:	5f                   	pop    %edi
  8025aa:	5d                   	pop    %ebp
  8025ab:	c3                   	ret    
  8025ac:	39 ce                	cmp    %ecx,%esi
  8025ae:	77 28                	ja     8025d8 <__udivdi3+0x7c>
  8025b0:	0f bd fe             	bsr    %esi,%edi
  8025b3:	83 f7 1f             	xor    $0x1f,%edi
  8025b6:	75 40                	jne    8025f8 <__udivdi3+0x9c>
  8025b8:	39 ce                	cmp    %ecx,%esi
  8025ba:	72 0a                	jb     8025c6 <__udivdi3+0x6a>
  8025bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8025c0:	0f 87 9e 00 00 00    	ja     802664 <__udivdi3+0x108>
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cb:	89 fa                	mov    %edi,%edx
  8025cd:	83 c4 1c             	add    $0x1c,%esp
  8025d0:	5b                   	pop    %ebx
  8025d1:	5e                   	pop    %esi
  8025d2:	5f                   	pop    %edi
  8025d3:	5d                   	pop    %ebp
  8025d4:	c3                   	ret    
  8025d5:	8d 76 00             	lea    0x0(%esi),%esi
  8025d8:	31 ff                	xor    %edi,%edi
  8025da:	31 c0                	xor    %eax,%eax
  8025dc:	89 fa                	mov    %edi,%edx
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	89 d8                	mov    %ebx,%eax
  8025ea:	f7 f7                	div    %edi
  8025ec:	31 ff                	xor    %edi,%edi
  8025ee:	89 fa                	mov    %edi,%edx
  8025f0:	83 c4 1c             	add    $0x1c,%esp
  8025f3:	5b                   	pop    %ebx
  8025f4:	5e                   	pop    %esi
  8025f5:	5f                   	pop    %edi
  8025f6:	5d                   	pop    %ebp
  8025f7:	c3                   	ret    
  8025f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025fd:	89 eb                	mov    %ebp,%ebx
  8025ff:	29 fb                	sub    %edi,%ebx
  802601:	89 f9                	mov    %edi,%ecx
  802603:	d3 e6                	shl    %cl,%esi
  802605:	89 c5                	mov    %eax,%ebp
  802607:	88 d9                	mov    %bl,%cl
  802609:	d3 ed                	shr    %cl,%ebp
  80260b:	89 e9                	mov    %ebp,%ecx
  80260d:	09 f1                	or     %esi,%ecx
  80260f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802613:	89 f9                	mov    %edi,%ecx
  802615:	d3 e0                	shl    %cl,%eax
  802617:	89 c5                	mov    %eax,%ebp
  802619:	89 d6                	mov    %edx,%esi
  80261b:	88 d9                	mov    %bl,%cl
  80261d:	d3 ee                	shr    %cl,%esi
  80261f:	89 f9                	mov    %edi,%ecx
  802621:	d3 e2                	shl    %cl,%edx
  802623:	8b 44 24 08          	mov    0x8(%esp),%eax
  802627:	88 d9                	mov    %bl,%cl
  802629:	d3 e8                	shr    %cl,%eax
  80262b:	09 c2                	or     %eax,%edx
  80262d:	89 d0                	mov    %edx,%eax
  80262f:	89 f2                	mov    %esi,%edx
  802631:	f7 74 24 0c          	divl   0xc(%esp)
  802635:	89 d6                	mov    %edx,%esi
  802637:	89 c3                	mov    %eax,%ebx
  802639:	f7 e5                	mul    %ebp
  80263b:	39 d6                	cmp    %edx,%esi
  80263d:	72 19                	jb     802658 <__udivdi3+0xfc>
  80263f:	74 0b                	je     80264c <__udivdi3+0xf0>
  802641:	89 d8                	mov    %ebx,%eax
  802643:	31 ff                	xor    %edi,%edi
  802645:	e9 58 ff ff ff       	jmp    8025a2 <__udivdi3+0x46>
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802650:	89 f9                	mov    %edi,%ecx
  802652:	d3 e2                	shl    %cl,%edx
  802654:	39 c2                	cmp    %eax,%edx
  802656:	73 e9                	jae    802641 <__udivdi3+0xe5>
  802658:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80265b:	31 ff                	xor    %edi,%edi
  80265d:	e9 40 ff ff ff       	jmp    8025a2 <__udivdi3+0x46>
  802662:	66 90                	xchg   %ax,%ax
  802664:	31 c0                	xor    %eax,%eax
  802666:	e9 37 ff ff ff       	jmp    8025a2 <__udivdi3+0x46>
  80266b:	90                   	nop

0080266c <__umoddi3>:
  80266c:	55                   	push   %ebp
  80266d:	57                   	push   %edi
  80266e:	56                   	push   %esi
  80266f:	53                   	push   %ebx
  802670:	83 ec 1c             	sub    $0x1c,%esp
  802673:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802677:	8b 74 24 34          	mov    0x34(%esp),%esi
  80267b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80267f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802683:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802687:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80268b:	89 f3                	mov    %esi,%ebx
  80268d:	89 fa                	mov    %edi,%edx
  80268f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802693:	89 34 24             	mov    %esi,(%esp)
  802696:	85 c0                	test   %eax,%eax
  802698:	75 1a                	jne    8026b4 <__umoddi3+0x48>
  80269a:	39 f7                	cmp    %esi,%edi
  80269c:	0f 86 a2 00 00 00    	jbe    802744 <__umoddi3+0xd8>
  8026a2:	89 c8                	mov    %ecx,%eax
  8026a4:	89 f2                	mov    %esi,%edx
  8026a6:	f7 f7                	div    %edi
  8026a8:	89 d0                	mov    %edx,%eax
  8026aa:	31 d2                	xor    %edx,%edx
  8026ac:	83 c4 1c             	add    $0x1c,%esp
  8026af:	5b                   	pop    %ebx
  8026b0:	5e                   	pop    %esi
  8026b1:	5f                   	pop    %edi
  8026b2:	5d                   	pop    %ebp
  8026b3:	c3                   	ret    
  8026b4:	39 f0                	cmp    %esi,%eax
  8026b6:	0f 87 ac 00 00 00    	ja     802768 <__umoddi3+0xfc>
  8026bc:	0f bd e8             	bsr    %eax,%ebp
  8026bf:	83 f5 1f             	xor    $0x1f,%ebp
  8026c2:	0f 84 ac 00 00 00    	je     802774 <__umoddi3+0x108>
  8026c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8026cd:	29 ef                	sub    %ebp,%edi
  8026cf:	89 fe                	mov    %edi,%esi
  8026d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026d5:	89 e9                	mov    %ebp,%ecx
  8026d7:	d3 e0                	shl    %cl,%eax
  8026d9:	89 d7                	mov    %edx,%edi
  8026db:	89 f1                	mov    %esi,%ecx
  8026dd:	d3 ef                	shr    %cl,%edi
  8026df:	09 c7                	or     %eax,%edi
  8026e1:	89 e9                	mov    %ebp,%ecx
  8026e3:	d3 e2                	shl    %cl,%edx
  8026e5:	89 14 24             	mov    %edx,(%esp)
  8026e8:	89 d8                	mov    %ebx,%eax
  8026ea:	d3 e0                	shl    %cl,%eax
  8026ec:	89 c2                	mov    %eax,%edx
  8026ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026f2:	d3 e0                	shl    %cl,%eax
  8026f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026fc:	89 f1                	mov    %esi,%ecx
  8026fe:	d3 e8                	shr    %cl,%eax
  802700:	09 d0                	or     %edx,%eax
  802702:	d3 eb                	shr    %cl,%ebx
  802704:	89 da                	mov    %ebx,%edx
  802706:	f7 f7                	div    %edi
  802708:	89 d3                	mov    %edx,%ebx
  80270a:	f7 24 24             	mull   (%esp)
  80270d:	89 c6                	mov    %eax,%esi
  80270f:	89 d1                	mov    %edx,%ecx
  802711:	39 d3                	cmp    %edx,%ebx
  802713:	0f 82 87 00 00 00    	jb     8027a0 <__umoddi3+0x134>
  802719:	0f 84 91 00 00 00    	je     8027b0 <__umoddi3+0x144>
  80271f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802723:	29 f2                	sub    %esi,%edx
  802725:	19 cb                	sbb    %ecx,%ebx
  802727:	89 d8                	mov    %ebx,%eax
  802729:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80272d:	d3 e0                	shl    %cl,%eax
  80272f:	89 e9                	mov    %ebp,%ecx
  802731:	d3 ea                	shr    %cl,%edx
  802733:	09 d0                	or     %edx,%eax
  802735:	89 e9                	mov    %ebp,%ecx
  802737:	d3 eb                	shr    %cl,%ebx
  802739:	89 da                	mov    %ebx,%edx
  80273b:	83 c4 1c             	add    $0x1c,%esp
  80273e:	5b                   	pop    %ebx
  80273f:	5e                   	pop    %esi
  802740:	5f                   	pop    %edi
  802741:	5d                   	pop    %ebp
  802742:	c3                   	ret    
  802743:	90                   	nop
  802744:	89 fd                	mov    %edi,%ebp
  802746:	85 ff                	test   %edi,%edi
  802748:	75 0b                	jne    802755 <__umoddi3+0xe9>
  80274a:	b8 01 00 00 00       	mov    $0x1,%eax
  80274f:	31 d2                	xor    %edx,%edx
  802751:	f7 f7                	div    %edi
  802753:	89 c5                	mov    %eax,%ebp
  802755:	89 f0                	mov    %esi,%eax
  802757:	31 d2                	xor    %edx,%edx
  802759:	f7 f5                	div    %ebp
  80275b:	89 c8                	mov    %ecx,%eax
  80275d:	f7 f5                	div    %ebp
  80275f:	89 d0                	mov    %edx,%eax
  802761:	e9 44 ff ff ff       	jmp    8026aa <__umoddi3+0x3e>
  802766:	66 90                	xchg   %ax,%ax
  802768:	89 c8                	mov    %ecx,%eax
  80276a:	89 f2                	mov    %esi,%edx
  80276c:	83 c4 1c             	add    $0x1c,%esp
  80276f:	5b                   	pop    %ebx
  802770:	5e                   	pop    %esi
  802771:	5f                   	pop    %edi
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    
  802774:	3b 04 24             	cmp    (%esp),%eax
  802777:	72 06                	jb     80277f <__umoddi3+0x113>
  802779:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80277d:	77 0f                	ja     80278e <__umoddi3+0x122>
  80277f:	89 f2                	mov    %esi,%edx
  802781:	29 f9                	sub    %edi,%ecx
  802783:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802787:	89 14 24             	mov    %edx,(%esp)
  80278a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80278e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802792:	8b 14 24             	mov    (%esp),%edx
  802795:	83 c4 1c             	add    $0x1c,%esp
  802798:	5b                   	pop    %ebx
  802799:	5e                   	pop    %esi
  80279a:	5f                   	pop    %edi
  80279b:	5d                   	pop    %ebp
  80279c:	c3                   	ret    
  80279d:	8d 76 00             	lea    0x0(%esi),%esi
  8027a0:	2b 04 24             	sub    (%esp),%eax
  8027a3:	19 fa                	sbb    %edi,%edx
  8027a5:	89 d1                	mov    %edx,%ecx
  8027a7:	89 c6                	mov    %eax,%esi
  8027a9:	e9 71 ff ff ff       	jmp    80271f <__umoddi3+0xb3>
  8027ae:	66 90                	xchg   %ax,%ax
  8027b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8027b4:	72 ea                	jb     8027a0 <__umoddi3+0x134>
  8027b6:	89 d9                	mov    %ebx,%ecx
  8027b8:	e9 62 ff ff ff       	jmp    80271f <__umoddi3+0xb3>


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
  800044:	e8 a7 20 00 00       	call   8020f0 <sys_getenvid>
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
  80007c:	bb 52 2a 80 00       	mov    $0x802a52,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb 5c 2a 80 00       	mov    $0x802a5c,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb 68 2a 80 00       	mov    $0x802a68,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb 77 2a 80 00       	mov    $0x802a77,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb 86 2a 80 00       	mov    $0x802a86,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb 9b 2a 80 00       	mov    $0x802a9b,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb b0 2a 80 00       	mov    $0x802ab0,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb c1 2a 80 00       	mov    $0x802ac1,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb d2 2a 80 00       	mov    $0x802ad2,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb e3 2a 80 00       	mov    $0x802ae3,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb ec 2a 80 00       	mov    $0x802aec,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb f6 2a 80 00       	mov    $0x802af6,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb 01 2b 80 00       	mov    $0x802b01,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb 0d 2b 80 00       	mov    $0x802b0d,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb 17 2b 80 00       	mov    $0x802b17,%ebx
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
  8001f7:	bb 21 2b 80 00       	mov    $0x802b21,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb 2f 2b 80 00       	mov    $0x802b2f,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb 3e 2b 80 00       	mov    $0x802b3e,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb 45 2b 80 00       	mov    $0x802b45,%ebx
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
  800264:	e8 e6 1a 00 00       	call   801d4f <smalloc>
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
  800342:	e8 08 1a 00 00       	call   801d4f <smalloc>
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
  800364:	e8 e6 19 00 00       	call   801d4f <smalloc>
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
  800385:	e8 c5 19 00 00       	call   801d4f <smalloc>
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
  8003a6:	e8 a4 19 00 00       	call   801d4f <smalloc>
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
  8003c8:	e8 82 19 00 00       	call   801d4f <smalloc>
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
  8003ef:	e8 5b 19 00 00       	call   801d4f <smalloc>
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
  80040d:	e8 3d 19 00 00       	call   801d4f <smalloc>
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
  80042b:	e8 1f 19 00 00       	call   801d4f <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 06 19 00 00       	call   801d4f <smalloc>
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
  80046c:	e8 de 18 00 00       	call   801d4f <smalloc>
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
  800499:	e8 af 1f 00 00       	call   80244d <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 94 1f 00 00       	call   80244d <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 79 1f 00 00       	call   80244d <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 5e 1f 00 00       	call   80244d <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 43 1f 00 00       	call   80244d <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 28 1f 00 00       	call   80244d <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 0d 1f 00 00       	call   80244d <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 e0 27 80 00       	push   $0x8027e0
  800554:	e8 f6 17 00 00       	call   801d4f <smalloc>
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
  80057b:	bb 4c 2b 80 00       	mov    $0x802b4c,%ebx
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
  8005ae:	e8 e3 14 00 00       	call   801a96 <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ff fd ff ff    	lea    -0x201(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 31 fe ff ff    	lea    -0x1cf(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 36 fe ff ff    	lea    -0x1ca(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 9c 15 00 00       	call   801b6f <strcconcat>
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
  8005fc:	e8 4c 1e 00 00       	call   80244d <create_semaphore>
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
  800620:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800626:	a1 04 40 80 00       	mov    0x804004,%eax
  80062b:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800631:	89 c1                	mov    %eax,%ecx
  800633:	a1 04 40 80 00       	mov    0x804004,%eax
  800638:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80063e:	52                   	push   %edx
  80063f:	51                   	push   %ecx
  800640:	50                   	push   %eax
  800641:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800647:	50                   	push   %eax
  800648:	e8 4e 1a 00 00       	call   80209b <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 54 1a 00 00       	call   8020b9 <sys_run_env>
  800665:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800668:	a1 04 40 80 00       	mov    0x804004,%eax
  80066d:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800673:	a1 04 40 80 00       	mov    0x804004,%eax
  800678:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80067e:	89 c1                	mov    %eax,%ecx
  800680:	a1 04 40 80 00       	mov    0x804004,%eax
  800685:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80068b:	52                   	push   %edx
  80068c:	51                   	push   %ecx
  80068d:	50                   	push   %eax
  80068e:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800694:	50                   	push   %eax
  800695:	e8 01 1a 00 00       	call   80209b <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 07 1a 00 00       	call   8020b9 <sys_run_env>
  8006b2:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8006b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8006ba:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8006c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8006c5:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8006cb:	89 c1                	mov    %eax,%ecx
  8006cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8006d2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8006d8:	52                   	push   %edx
  8006d9:	51                   	push   %ecx
  8006da:	50                   	push   %eax
  8006db:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	e8 b4 19 00 00       	call   80209b <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 ba 19 00 00       	call   8020b9 <sys_run_env>
  8006ff:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800702:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800709:	eb 70                	jmp    80077b <_main+0x743>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80070b:	a1 04 40 80 00       	mov    0x804004,%eax
  800710:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800716:	a1 04 40 80 00       	mov    0x804004,%eax
  80071b:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	a1 04 40 80 00       	mov    0x804004,%eax
  800728:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80072e:	52                   	push   %edx
  80072f:	51                   	push   %ecx
  800730:	50                   	push   %eax
  800731:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	e8 5e 19 00 00       	call   80209b <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 f4 27 80 00       	push   $0x8027f4
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 3a 28 80 00       	push   $0x80283a
  800761:	e8 39 05 00 00       	call   800c9f <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 44 19 00 00       	call   8020b9 <sys_run_env>
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
  800795:	e8 e7 1c 00 00       	call   802481 <wait_semaphore>
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
  8007b0:	e8 0b 1d 00 00       	call   8024c0 <env_sleep>
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
  8007f6:	68 4c 28 80 00       	push   $0x80284c
  8007fb:	e8 5c 07 00 00       	call   800f5c <cprintf>
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
  80084e:	68 7c 28 80 00       	push   $0x80287c
  800853:	e8 04 07 00 00       	call   800f5c <cprintf>
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
  80088d:	68 ac 28 80 00       	push   $0x8028ac
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 3a 28 80 00       	push   $0x80283a
  80089c:	e8 fe 03 00 00       	call   800c9f <_panic>
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
  8008d0:	68 ac 28 80 00       	push   $0x8028ac
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 3a 28 80 00       	push   $0x80283a
  8008df:	e8 bb 03 00 00       	call   800c9f <_panic>
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
  800931:	68 ac 28 80 00       	push   $0x8028ac
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 3a 28 80 00       	push   $0x80283a
  800940:	e8 5a 03 00 00       	call   800c9f <_panic>
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
  80095e:	e8 52 1b 00 00       	call   8024b5 <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 d0 28 80 00       	push   $0x8028d0
  800970:	68 f0 28 80 00       	push   $0x8028f0
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 3a 28 80 00       	push   $0x80283a
  80097f:	e8 1b 03 00 00       	call   800c9f <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 23 1b 00 00       	call   8024b5 <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 08 29 80 00       	push   $0x802908
  80099f:	68 f0 28 80 00       	push   $0x8028f0
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 3a 28 80 00       	push   $0x80283a
  8009ae:	e8 ec 02 00 00       	call   800c9f <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 f4 1a 00 00       	call   8024b5 <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 28 29 80 00       	push   $0x802928
  8009ce:	68 f0 28 80 00       	push   $0x8028f0
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 3a 28 80 00       	push   $0x80283a
  8009dd:	e8 bd 02 00 00       	call   800c9f <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 c5 1a 00 00       	call   8024b5 <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 4c 29 80 00       	push   $0x80294c
  8009fd:	68 f0 28 80 00       	push   $0x8028f0
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 3a 28 80 00       	push   $0x80283a
  800a0c:	e8 8e 02 00 00       	call   800c9f <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 96 1a 00 00       	call   8024b5 <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 6e 29 80 00       	push   $0x80296e
  800a2c:	68 f0 28 80 00       	push   $0x8028f0
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 3a 28 80 00       	push   $0x80283a
  800a3b:	e8 5f 02 00 00       	call   800c9f <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 67 1a 00 00       	call   8024b5 <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 8c 29 80 00       	push   $0x80298c
  800a5b:	68 f0 28 80 00       	push   $0x8028f0
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 3a 28 80 00       	push   $0x80283a
  800a6a:	e8 30 02 00 00       	call   800c9f <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 38 1a 00 00       	call   8024b5 <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 b0 29 80 00       	push   $0x8029b0
  800a89:	68 f0 28 80 00       	push   $0x8028f0
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 3a 28 80 00       	push   $0x80283a
  800a98:	e8 02 02 00 00       	call   800c9f <_panic>

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
  800ac4:	e8 ec 19 00 00       	call   8024b5 <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 d8 29 80 00       	push   $0x8029d8
  800ad5:	68 f0 28 80 00       	push   $0x8028f0
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 3a 28 80 00       	push   $0x80283a
  800ae4:	e8 b6 01 00 00       	call   800c9f <_panic>
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
  800af7:	68 00 2a 80 00       	push   $0x802a00
  800afc:	e8 5b 04 00 00       	call   800f5c <cprintf>
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
  800b58:	e8 ac 15 00 00       	call   802109 <sys_getenvindex>
  800b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b63:	89 d0                	mov    %edx,%eax
  800b65:	c1 e0 06             	shl    $0x6,%eax
  800b68:	29 d0                	sub    %edx,%eax
  800b6a:	c1 e0 02             	shl    $0x2,%eax
  800b6d:	01 d0                	add    %edx,%eax
  800b6f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b76:	01 c8                	add    %ecx,%eax
  800b78:	c1 e0 03             	shl    $0x3,%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b84:	29 c2                	sub    %eax,%edx
  800b86:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800b8d:	89 c2                	mov    %eax,%edx
  800b8f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800b95:	a3 04 40 80 00       	mov    %eax,0x804004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b9a:	a1 04 40 80 00       	mov    0x804004,%eax
  800b9f:	8a 40 20             	mov    0x20(%eax),%al
  800ba2:	84 c0                	test   %al,%al
  800ba4:	74 0d                	je     800bb3 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800ba6:	a1 04 40 80 00       	mov    0x804004,%eax
  800bab:	83 c0 20             	add    $0x20,%eax
  800bae:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb7:	7e 0a                	jle    800bc3 <libmain+0x71>
		binaryname = argv[0];
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	ff 75 08             	pushl  0x8(%ebp)
  800bcc:	e8 67 f4 ff ff       	call   800038 <_main>
  800bd1:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800bd4:	e8 b4 12 00 00       	call   801e8d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800bd9:	83 ec 0c             	sub    $0xc,%esp
  800bdc:	68 84 2b 80 00       	push   $0x802b84
  800be1:	e8 76 03 00 00       	call   800f5c <cprintf>
  800be6:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800be9:	a1 04 40 80 00       	mov    0x804004,%eax
  800bee:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800bf4:	a1 04 40 80 00       	mov    0x804004,%eax
  800bf9:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800bff:	83 ec 04             	sub    $0x4,%esp
  800c02:	52                   	push   %edx
  800c03:	50                   	push   %eax
  800c04:	68 ac 2b 80 00       	push   $0x802bac
  800c09:	e8 4e 03 00 00       	call   800f5c <cprintf>
  800c0e:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c11:	a1 04 40 80 00       	mov    0x804004,%eax
  800c16:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800c1c:	a1 04 40 80 00       	mov    0x804004,%eax
  800c21:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800c27:	a1 04 40 80 00       	mov    0x804004,%eax
  800c2c:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800c32:	51                   	push   %ecx
  800c33:	52                   	push   %edx
  800c34:	50                   	push   %eax
  800c35:	68 d4 2b 80 00       	push   $0x802bd4
  800c3a:	e8 1d 03 00 00       	call   800f5c <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c42:	a1 04 40 80 00       	mov    0x804004,%eax
  800c47:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800c4d:	83 ec 08             	sub    $0x8,%esp
  800c50:	50                   	push   %eax
  800c51:	68 2c 2c 80 00       	push   $0x802c2c
  800c56:	e8 01 03 00 00       	call   800f5c <cprintf>
  800c5b:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c5e:	83 ec 0c             	sub    $0xc,%esp
  800c61:	68 84 2b 80 00       	push   $0x802b84
  800c66:	e8 f1 02 00 00       	call   800f5c <cprintf>
  800c6b:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800c6e:	e8 34 12 00 00       	call   801ea7 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800c73:	e8 19 00 00 00       	call   800c91 <exit>
}
  800c78:	90                   	nop
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c81:	83 ec 0c             	sub    $0xc,%esp
  800c84:	6a 00                	push   $0x0
  800c86:	e8 4a 14 00 00       	call   8020d5 <sys_destroy_env>
  800c8b:	83 c4 10             	add    $0x10,%esp
}
  800c8e:	90                   	nop
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <exit>:

void
exit(void)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c97:	e8 9f 14 00 00       	call   80213b <sys_exit_env>
}
  800c9c:	90                   	nop
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ca5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca8:	83 c0 04             	add    $0x4,%eax
  800cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800cae:	a1 24 40 80 00       	mov    0x804024,%eax
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	74 16                	je     800ccd <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cb7:	a1 24 40 80 00       	mov    0x804024,%eax
  800cbc:	83 ec 08             	sub    $0x8,%esp
  800cbf:	50                   	push   %eax
  800cc0:	68 40 2c 80 00       	push   $0x802c40
  800cc5:	e8 92 02 00 00       	call   800f5c <cprintf>
  800cca:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ccd:	a1 00 40 80 00       	mov    0x804000,%eax
  800cd2:	ff 75 0c             	pushl  0xc(%ebp)
  800cd5:	ff 75 08             	pushl  0x8(%ebp)
  800cd8:	50                   	push   %eax
  800cd9:	68 45 2c 80 00       	push   $0x802c45
  800cde:	e8 79 02 00 00       	call   800f5c <cprintf>
  800ce3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 f4             	pushl  -0xc(%ebp)
  800cef:	50                   	push   %eax
  800cf0:	e8 fc 01 00 00       	call   800ef1 <vcprintf>
  800cf5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800cf8:	83 ec 08             	sub    $0x8,%esp
  800cfb:	6a 00                	push   $0x0
  800cfd:	68 61 2c 80 00       	push   $0x802c61
  800d02:	e8 ea 01 00 00       	call   800ef1 <vcprintf>
  800d07:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d0a:	e8 82 ff ff ff       	call   800c91 <exit>

	// should not return here
	while (1) ;
  800d0f:	eb fe                	jmp    800d0f <_panic+0x70>

00800d11 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d17:	a1 04 40 80 00       	mov    0x804004,%eax
  800d1c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	39 c2                	cmp    %eax,%edx
  800d27:	74 14                	je     800d3d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d29:	83 ec 04             	sub    $0x4,%esp
  800d2c:	68 64 2c 80 00       	push   $0x802c64
  800d31:	6a 26                	push   $0x26
  800d33:	68 b0 2c 80 00       	push   $0x802cb0
  800d38:	e8 62 ff ff ff       	call   800c9f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d4b:	e9 c5 00 00 00       	jmp    800e15 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	01 d0                	add    %edx,%eax
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	85 c0                	test   %eax,%eax
  800d63:	75 08                	jne    800d6d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800d65:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d68:	e9 a5 00 00 00       	jmp    800e12 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800d6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d7b:	eb 69                	jmp    800de6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d7d:	a1 04 40 80 00       	mov    0x804004,%eax
  800d82:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800d88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d8b:	89 d0                	mov    %edx,%eax
  800d8d:	01 c0                	add    %eax,%eax
  800d8f:	01 d0                	add    %edx,%eax
  800d91:	c1 e0 03             	shl    $0x3,%eax
  800d94:	01 c8                	add    %ecx,%eax
  800d96:	8a 40 04             	mov    0x4(%eax),%al
  800d99:	84 c0                	test   %al,%al
  800d9b:	75 46                	jne    800de3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d9d:	a1 04 40 80 00       	mov    0x804004,%eax
  800da2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800da8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800dab:	89 d0                	mov    %edx,%eax
  800dad:	01 c0                	add    %eax,%eax
  800daf:	01 d0                	add    %edx,%eax
  800db1:	c1 e0 03             	shl    $0x3,%eax
  800db4:	01 c8                	add    %ecx,%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dbe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dc3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	01 c8                	add    %ecx,%eax
  800dd4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	75 09                	jne    800de3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800dda:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800de1:	eb 15                	jmp    800df8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800de3:	ff 45 e8             	incl   -0x18(%ebp)
  800de6:	a1 04 40 80 00       	mov    0x804004,%eax
  800deb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800df4:	39 c2                	cmp    %eax,%edx
  800df6:	77 85                	ja     800d7d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800df8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dfc:	75 14                	jne    800e12 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800dfe:	83 ec 04             	sub    $0x4,%esp
  800e01:	68 bc 2c 80 00       	push   $0x802cbc
  800e06:	6a 3a                	push   $0x3a
  800e08:	68 b0 2c 80 00       	push   $0x802cb0
  800e0d:	e8 8d fe ff ff       	call   800c9f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e12:	ff 45 f0             	incl   -0x10(%ebp)
  800e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e18:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e1b:	0f 8c 2f ff ff ff    	jl     800d50 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e28:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e2f:	eb 26                	jmp    800e57 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e31:	a1 04 40 80 00       	mov    0x804004,%eax
  800e36:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800e3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e3f:	89 d0                	mov    %edx,%eax
  800e41:	01 c0                	add    %eax,%eax
  800e43:	01 d0                	add    %edx,%eax
  800e45:	c1 e0 03             	shl    $0x3,%eax
  800e48:	01 c8                	add    %ecx,%eax
  800e4a:	8a 40 04             	mov    0x4(%eax),%al
  800e4d:	3c 01                	cmp    $0x1,%al
  800e4f:	75 03                	jne    800e54 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800e51:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e54:	ff 45 e0             	incl   -0x20(%ebp)
  800e57:	a1 04 40 80 00       	mov    0x804004,%eax
  800e5c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e65:	39 c2                	cmp    %eax,%edx
  800e67:	77 c8                	ja     800e31 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e6f:	74 14                	je     800e85 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800e71:	83 ec 04             	sub    $0x4,%esp
  800e74:	68 10 2d 80 00       	push   $0x802d10
  800e79:	6a 44                	push   $0x44
  800e7b:	68 b0 2c 80 00       	push   $0x802cb0
  800e80:	e8 1a fe ff ff       	call   800c9f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e85:	90                   	nop
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	8d 48 01             	lea    0x1(%eax),%ecx
  800e96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e99:	89 0a                	mov    %ecx,(%edx)
  800e9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9e:	88 d1                	mov    %dl,%cl
  800ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	8b 00                	mov    (%eax),%eax
  800eac:	3d ff 00 00 00       	cmp    $0xff,%eax
  800eb1:	75 2c                	jne    800edf <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eb3:	a0 08 40 80 00       	mov    0x804008,%al
  800eb8:	0f b6 c0             	movzbl %al,%eax
  800ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebe:	8b 12                	mov    (%edx),%edx
  800ec0:	89 d1                	mov    %edx,%ecx
  800ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec5:	83 c2 08             	add    $0x8,%edx
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	50                   	push   %eax
  800ecc:	51                   	push   %ecx
  800ecd:	52                   	push   %edx
  800ece:	e8 78 0f 00 00       	call   801e4b <sys_cputs>
  800ed3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	8b 40 04             	mov    0x4(%eax),%eax
  800ee5:	8d 50 01             	lea    0x1(%eax),%edx
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	89 50 04             	mov    %edx,0x4(%eax)
}
  800eee:	90                   	nop
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800efa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f01:	00 00 00 
	b.cnt = 0;
  800f04:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f0b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f0e:	ff 75 0c             	pushl  0xc(%ebp)
  800f11:	ff 75 08             	pushl  0x8(%ebp)
  800f14:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1a:	50                   	push   %eax
  800f1b:	68 88 0e 80 00       	push   $0x800e88
  800f20:	e8 11 02 00 00       	call   801136 <vprintfmt>
  800f25:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f28:	a0 08 40 80 00       	mov    0x804008,%al
  800f2d:	0f b6 c0             	movzbl %al,%eax
  800f30:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f36:	83 ec 04             	sub    $0x4,%esp
  800f39:	50                   	push   %eax
  800f3a:	52                   	push   %edx
  800f3b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f41:	83 c0 08             	add    $0x8,%eax
  800f44:	50                   	push   %eax
  800f45:	e8 01 0f 00 00       	call   801e4b <sys_cputs>
  800f4a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f4d:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
	return b.cnt;
  800f54:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f62:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
	va_start(ap, fmt);
  800f69:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	ff 75 f4             	pushl  -0xc(%ebp)
  800f78:	50                   	push   %eax
  800f79:	e8 73 ff ff ff       	call   800ef1 <vcprintf>
  800f7e:	83 c4 10             	add    $0x10,%esp
  800f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800f8f:	e8 f9 0e 00 00       	call   801e8d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800f94:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa3:	50                   	push   %eax
  800fa4:	e8 48 ff ff ff       	call   800ef1 <vcprintf>
  800fa9:	83 c4 10             	add    $0x10,%esp
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800faf:	e8 f3 0e 00 00       	call   801ea7 <sys_unlock_cons>
	return cnt;
  800fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    

00800fb9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	53                   	push   %ebx
  800fbd:	83 ec 14             	sub    $0x14,%esp
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fcc:	8b 45 18             	mov    0x18(%ebp),%eax
  800fcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd7:	77 55                	ja     80102e <printnum+0x75>
  800fd9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fdc:	72 05                	jb     800fe3 <printnum+0x2a>
  800fde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe1:	77 4b                	ja     80102e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fe3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fe6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fe9:	8b 45 18             	mov    0x18(%ebp),%eax
  800fec:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff1:	52                   	push   %edx
  800ff2:	50                   	push   %eax
  800ff3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ff9:	e8 76 15 00 00       	call   802574 <__udivdi3>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	83 ec 04             	sub    $0x4,%esp
  801004:	ff 75 20             	pushl  0x20(%ebp)
  801007:	53                   	push   %ebx
  801008:	ff 75 18             	pushl  0x18(%ebp)
  80100b:	52                   	push   %edx
  80100c:	50                   	push   %eax
  80100d:	ff 75 0c             	pushl  0xc(%ebp)
  801010:	ff 75 08             	pushl  0x8(%ebp)
  801013:	e8 a1 ff ff ff       	call   800fb9 <printnum>
  801018:	83 c4 20             	add    $0x20,%esp
  80101b:	eb 1a                	jmp    801037 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 0c             	pushl  0xc(%ebp)
  801023:	ff 75 20             	pushl  0x20(%ebp)
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	ff d0                	call   *%eax
  80102b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80102e:	ff 4d 1c             	decl   0x1c(%ebp)
  801031:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801035:	7f e6                	jg     80101d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801037:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80103a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801045:	53                   	push   %ebx
  801046:	51                   	push   %ecx
  801047:	52                   	push   %edx
  801048:	50                   	push   %eax
  801049:	e8 36 16 00 00       	call   802684 <__umoddi3>
  80104e:	83 c4 10             	add    $0x10,%esp
  801051:	05 74 2f 80 00       	add    $0x802f74,%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 ec 08             	sub    $0x8,%esp
  80105e:	ff 75 0c             	pushl  0xc(%ebp)
  801061:	50                   	push   %eax
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
}
  80106a:	90                   	nop
  80106b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801073:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801077:	7e 1c                	jle    801095 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8b 00                	mov    (%eax),%eax
  80107e:	8d 50 08             	lea    0x8(%eax),%edx
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	89 10                	mov    %edx,(%eax)
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8b 00                	mov    (%eax),%eax
  80108b:	83 e8 08             	sub    $0x8,%eax
  80108e:	8b 50 04             	mov    0x4(%eax),%edx
  801091:	8b 00                	mov    (%eax),%eax
  801093:	eb 40                	jmp    8010d5 <getuint+0x65>
	else if (lflag)
  801095:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801099:	74 1e                	je     8010b9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8b 00                	mov    (%eax),%eax
  8010a0:	8d 50 04             	lea    0x4(%eax),%edx
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	89 10                	mov    %edx,(%eax)
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 00                	mov    (%eax),%eax
  8010b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b7:	eb 1c                	jmp    8010d5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8b 00                	mov    (%eax),%eax
  8010be:	8d 50 04             	lea    0x4(%eax),%edx
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	89 10                	mov    %edx,(%eax)
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8b 00                	mov    (%eax),%eax
  8010cb:	83 e8 04             	sub    $0x4,%eax
  8010ce:	8b 00                	mov    (%eax),%eax
  8010d0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010de:	7e 1c                	jle    8010fc <getint+0x25>
		return va_arg(*ap, long long);
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8b 00                	mov    (%eax),%eax
  8010e5:	8d 50 08             	lea    0x8(%eax),%edx
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 10                	mov    %edx,(%eax)
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8b 00                	mov    (%eax),%eax
  8010f2:	83 e8 08             	sub    $0x8,%eax
  8010f5:	8b 50 04             	mov    0x4(%eax),%edx
  8010f8:	8b 00                	mov    (%eax),%eax
  8010fa:	eb 38                	jmp    801134 <getint+0x5d>
	else if (lflag)
  8010fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801100:	74 1a                	je     80111c <getint+0x45>
		return va_arg(*ap, long);
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8b 00                	mov    (%eax),%eax
  801107:	8d 50 04             	lea    0x4(%eax),%edx
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	89 10                	mov    %edx,(%eax)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8b 00                	mov    (%eax),%eax
  801114:	83 e8 04             	sub    $0x4,%eax
  801117:	8b 00                	mov    (%eax),%eax
  801119:	99                   	cltd   
  80111a:	eb 18                	jmp    801134 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 50 04             	lea    0x4(%eax),%edx
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	89 10                	mov    %edx,(%eax)
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8b 00                	mov    (%eax),%eax
  80112e:	83 e8 04             	sub    $0x4,%eax
  801131:	8b 00                	mov    (%eax),%eax
  801133:	99                   	cltd   
}
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    

00801136 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80113e:	eb 17                	jmp    801157 <vprintfmt+0x21>
			if (ch == '\0')
  801140:	85 db                	test   %ebx,%ebx
  801142:	0f 84 c1 03 00 00    	je     801509 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	ff 75 0c             	pushl  0xc(%ebp)
  80114e:	53                   	push   %ebx
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	ff d0                	call   *%eax
  801154:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	8d 50 01             	lea    0x1(%eax),%edx
  80115d:	89 55 10             	mov    %edx,0x10(%ebp)
  801160:	8a 00                	mov    (%eax),%al
  801162:	0f b6 d8             	movzbl %al,%ebx
  801165:	83 fb 25             	cmp    $0x25,%ebx
  801168:	75 d6                	jne    801140 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80116e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801175:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80117c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801183:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80118a:	8b 45 10             	mov    0x10(%ebp),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	89 55 10             	mov    %edx,0x10(%ebp)
  801193:	8a 00                	mov    (%eax),%al
  801195:	0f b6 d8             	movzbl %al,%ebx
  801198:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80119b:	83 f8 5b             	cmp    $0x5b,%eax
  80119e:	0f 87 3d 03 00 00    	ja     8014e1 <vprintfmt+0x3ab>
  8011a4:	8b 04 85 98 2f 80 00 	mov    0x802f98(,%eax,4),%eax
  8011ab:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011ad:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011b1:	eb d7                	jmp    80118a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011b7:	eb d1                	jmp    80118a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011c3:	89 d0                	mov    %edx,%eax
  8011c5:	c1 e0 02             	shl    $0x2,%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	01 c0                	add    %eax,%eax
  8011cc:	01 d8                	add    %ebx,%eax
  8011ce:	83 e8 30             	sub    $0x30,%eax
  8011d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011dc:	83 fb 2f             	cmp    $0x2f,%ebx
  8011df:	7e 3e                	jle    80121f <vprintfmt+0xe9>
  8011e1:	83 fb 39             	cmp    $0x39,%ebx
  8011e4:	7f 39                	jg     80121f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011e9:	eb d5                	jmp    8011c0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ee:	83 c0 04             	add    $0x4,%eax
  8011f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f7:	83 e8 04             	sub    $0x4,%eax
  8011fa:	8b 00                	mov    (%eax),%eax
  8011fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011ff:	eb 1f                	jmp    801220 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801201:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801205:	79 83                	jns    80118a <vprintfmt+0x54>
				width = 0;
  801207:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80120e:	e9 77 ff ff ff       	jmp    80118a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801213:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80121a:	e9 6b ff ff ff       	jmp    80118a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80121f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801220:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801224:	0f 89 60 ff ff ff    	jns    80118a <vprintfmt+0x54>
				width = precision, precision = -1;
  80122a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801230:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801237:	e9 4e ff ff ff       	jmp    80118a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80123c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80123f:	e9 46 ff ff ff       	jmp    80118a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	83 c0 04             	add    $0x4,%eax
  80124a:	89 45 14             	mov    %eax,0x14(%ebp)
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	83 e8 04             	sub    $0x4,%eax
  801253:	8b 00                	mov    (%eax),%eax
  801255:	83 ec 08             	sub    $0x8,%esp
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	50                   	push   %eax
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	ff d0                	call   *%eax
  801261:	83 c4 10             	add    $0x10,%esp
			break;
  801264:	e9 9b 02 00 00       	jmp    801504 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801269:	8b 45 14             	mov    0x14(%ebp),%eax
  80126c:	83 c0 04             	add    $0x4,%eax
  80126f:	89 45 14             	mov    %eax,0x14(%ebp)
  801272:	8b 45 14             	mov    0x14(%ebp),%eax
  801275:	83 e8 04             	sub    $0x4,%eax
  801278:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80127a:	85 db                	test   %ebx,%ebx
  80127c:	79 02                	jns    801280 <vprintfmt+0x14a>
				err = -err;
  80127e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801280:	83 fb 64             	cmp    $0x64,%ebx
  801283:	7f 0b                	jg     801290 <vprintfmt+0x15a>
  801285:	8b 34 9d e0 2d 80 00 	mov    0x802de0(,%ebx,4),%esi
  80128c:	85 f6                	test   %esi,%esi
  80128e:	75 19                	jne    8012a9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801290:	53                   	push   %ebx
  801291:	68 85 2f 80 00       	push   $0x802f85
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	ff 75 08             	pushl  0x8(%ebp)
  80129c:	e8 70 02 00 00       	call   801511 <printfmt>
  8012a1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012a4:	e9 5b 02 00 00       	jmp    801504 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012a9:	56                   	push   %esi
  8012aa:	68 8e 2f 80 00       	push   $0x802f8e
  8012af:	ff 75 0c             	pushl  0xc(%ebp)
  8012b2:	ff 75 08             	pushl  0x8(%ebp)
  8012b5:	e8 57 02 00 00       	call   801511 <printfmt>
  8012ba:	83 c4 10             	add    $0x10,%esp
			break;
  8012bd:	e9 42 02 00 00       	jmp    801504 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c5:	83 c0 04             	add    $0x4,%eax
  8012c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ce:	83 e8 04             	sub    $0x4,%eax
  8012d1:	8b 30                	mov    (%eax),%esi
  8012d3:	85 f6                	test   %esi,%esi
  8012d5:	75 05                	jne    8012dc <vprintfmt+0x1a6>
				p = "(null)";
  8012d7:	be 91 2f 80 00       	mov    $0x802f91,%esi
			if (width > 0 && padc != '-')
  8012dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e0:	7e 6d                	jle    80134f <vprintfmt+0x219>
  8012e2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012e6:	74 67                	je     80134f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	50                   	push   %eax
  8012ef:	56                   	push   %esi
  8012f0:	e8 1e 03 00 00       	call   801613 <strnlen>
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012fb:	eb 16                	jmp    801313 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012fd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	50                   	push   %eax
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	ff d0                	call   *%eax
  80130d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801310:	ff 4d e4             	decl   -0x1c(%ebp)
  801313:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801317:	7f e4                	jg     8012fd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801319:	eb 34                	jmp    80134f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80131b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80131f:	74 1c                	je     80133d <vprintfmt+0x207>
  801321:	83 fb 1f             	cmp    $0x1f,%ebx
  801324:	7e 05                	jle    80132b <vprintfmt+0x1f5>
  801326:	83 fb 7e             	cmp    $0x7e,%ebx
  801329:	7e 12                	jle    80133d <vprintfmt+0x207>
					putch('?', putdat);
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	6a 3f                	push   $0x3f
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	ff d0                	call   *%eax
  801338:	83 c4 10             	add    $0x10,%esp
  80133b:	eb 0f                	jmp    80134c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80133d:	83 ec 08             	sub    $0x8,%esp
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	53                   	push   %ebx
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	ff d0                	call   *%eax
  801349:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80134c:	ff 4d e4             	decl   -0x1c(%ebp)
  80134f:	89 f0                	mov    %esi,%eax
  801351:	8d 70 01             	lea    0x1(%eax),%esi
  801354:	8a 00                	mov    (%eax),%al
  801356:	0f be d8             	movsbl %al,%ebx
  801359:	85 db                	test   %ebx,%ebx
  80135b:	74 24                	je     801381 <vprintfmt+0x24b>
  80135d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801361:	78 b8                	js     80131b <vprintfmt+0x1e5>
  801363:	ff 4d e0             	decl   -0x20(%ebp)
  801366:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136a:	79 af                	jns    80131b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80136c:	eb 13                	jmp    801381 <vprintfmt+0x24b>
				putch(' ', putdat);
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	6a 20                	push   $0x20
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	ff d0                	call   *%eax
  80137b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80137e:	ff 4d e4             	decl   -0x1c(%ebp)
  801381:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801385:	7f e7                	jg     80136e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801387:	e9 78 01 00 00       	jmp    801504 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	ff 75 e8             	pushl  -0x18(%ebp)
  801392:	8d 45 14             	lea    0x14(%ebp),%eax
  801395:	50                   	push   %eax
  801396:	e8 3c fd ff ff       	call   8010d7 <getint>
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8013a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013aa:	85 d2                	test   %edx,%edx
  8013ac:	79 23                	jns    8013d1 <vprintfmt+0x29b>
				putch('-', putdat);
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	ff 75 0c             	pushl  0xc(%ebp)
  8013b4:	6a 2d                	push   $0x2d
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	ff d0                	call   *%eax
  8013bb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	f7 d8                	neg    %eax
  8013c6:	83 d2 00             	adc    $0x0,%edx
  8013c9:	f7 da                	neg    %edx
  8013cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013d1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013d8:	e9 bc 00 00 00       	jmp    801499 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8013e6:	50                   	push   %eax
  8013e7:	e8 84 fc ff ff       	call   801070 <getuint>
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013f5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013fc:	e9 98 00 00 00       	jmp    801499 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	6a 58                	push   $0x58
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	ff d0                	call   *%eax
  80140e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801411:	83 ec 08             	sub    $0x8,%esp
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	6a 58                	push   $0x58
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	ff d0                	call   *%eax
  80141e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	ff 75 0c             	pushl  0xc(%ebp)
  801427:	6a 58                	push   $0x58
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	ff d0                	call   *%eax
  80142e:	83 c4 10             	add    $0x10,%esp
			break;
  801431:	e9 ce 00 00 00       	jmp    801504 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	ff 75 0c             	pushl  0xc(%ebp)
  80143c:	6a 30                	push   $0x30
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	ff d0                	call   *%eax
  801443:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	ff 75 0c             	pushl  0xc(%ebp)
  80144c:	6a 78                	push   $0x78
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	ff d0                	call   *%eax
  801453:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801456:	8b 45 14             	mov    0x14(%ebp),%eax
  801459:	83 c0 04             	add    $0x4,%eax
  80145c:	89 45 14             	mov    %eax,0x14(%ebp)
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	83 e8 04             	sub    $0x4,%eax
  801465:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801467:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801471:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801478:	eb 1f                	jmp    801499 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80147a:	83 ec 08             	sub    $0x8,%esp
  80147d:	ff 75 e8             	pushl  -0x18(%ebp)
  801480:	8d 45 14             	lea    0x14(%ebp),%eax
  801483:	50                   	push   %eax
  801484:	e8 e7 fb ff ff       	call   801070 <getuint>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80148f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801492:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801499:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80149d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	52                   	push   %edx
  8014a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a7:	50                   	push   %eax
  8014a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8014ae:	ff 75 0c             	pushl  0xc(%ebp)
  8014b1:	ff 75 08             	pushl  0x8(%ebp)
  8014b4:	e8 00 fb ff ff       	call   800fb9 <printnum>
  8014b9:	83 c4 20             	add    $0x20,%esp
			break;
  8014bc:	eb 46                	jmp    801504 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	ff 75 0c             	pushl  0xc(%ebp)
  8014c4:	53                   	push   %ebx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	ff d0                	call   *%eax
  8014ca:	83 c4 10             	add    $0x10,%esp
			break;
  8014cd:	eb 35                	jmp    801504 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8014cf:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
			break;
  8014d6:	eb 2c                	jmp    801504 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8014d8:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
			break;
  8014df:	eb 23                	jmp    801504 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014e1:	83 ec 08             	sub    $0x8,%esp
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	6a 25                	push   $0x25
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	ff d0                	call   *%eax
  8014ee:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014f1:	ff 4d 10             	decl   0x10(%ebp)
  8014f4:	eb 03                	jmp    8014f9 <vprintfmt+0x3c3>
  8014f6:	ff 4d 10             	decl   0x10(%ebp)
  8014f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fc:	48                   	dec    %eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	3c 25                	cmp    $0x25,%al
  801501:	75 f3                	jne    8014f6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801503:	90                   	nop
		}
	}
  801504:	e9 35 fc ff ff       	jmp    80113e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801509:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80150a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80150d:	5b                   	pop    %ebx
  80150e:	5e                   	pop    %esi
  80150f:	5d                   	pop    %ebp
  801510:	c3                   	ret    

00801511 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801517:	8d 45 10             	lea    0x10(%ebp),%eax
  80151a:	83 c0 04             	add    $0x4,%eax
  80151d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801520:	8b 45 10             	mov    0x10(%ebp),%eax
  801523:	ff 75 f4             	pushl  -0xc(%ebp)
  801526:	50                   	push   %eax
  801527:	ff 75 0c             	pushl  0xc(%ebp)
  80152a:	ff 75 08             	pushl  0x8(%ebp)
  80152d:	e8 04 fc ff ff       	call   801136 <vprintfmt>
  801532:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801535:	90                   	nop
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80153b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153e:	8b 40 08             	mov    0x8(%eax),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80154a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154d:	8b 10                	mov    (%eax),%edx
  80154f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801552:	8b 40 04             	mov    0x4(%eax),%eax
  801555:	39 c2                	cmp    %eax,%edx
  801557:	73 12                	jae    80156b <sprintputch+0x33>
		*b->buf++ = ch;
  801559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	8d 48 01             	lea    0x1(%eax),%ecx
  801561:	8b 55 0c             	mov    0xc(%ebp),%edx
  801564:	89 0a                	mov    %ecx,(%edx)
  801566:	8b 55 08             	mov    0x8(%ebp),%edx
  801569:	88 10                	mov    %dl,(%eax)
}
  80156b:	90                   	nop
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    

0080156e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80157a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801588:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80158f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801593:	74 06                	je     80159b <vsnprintf+0x2d>
  801595:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801599:	7f 07                	jg     8015a2 <vsnprintf+0x34>
		return -E_INVAL;
  80159b:	b8 03 00 00 00       	mov    $0x3,%eax
  8015a0:	eb 20                	jmp    8015c2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8015a2:	ff 75 14             	pushl  0x14(%ebp)
  8015a5:	ff 75 10             	pushl  0x10(%ebp)
  8015a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015ab:	50                   	push   %eax
  8015ac:	68 38 15 80 00       	push   $0x801538
  8015b1:	e8 80 fb ff ff       	call   801136 <vprintfmt>
  8015b6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8015cd:	83 c0 04             	add    $0x4,%eax
  8015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d9:	50                   	push   %eax
  8015da:	ff 75 0c             	pushl  0xc(%ebp)
  8015dd:	ff 75 08             	pushl  0x8(%ebp)
  8015e0:	e8 89 ff ff ff       	call   80156e <vsnprintf>
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015fd:	eb 06                	jmp    801605 <strlen+0x15>
		n++;
  8015ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801602:	ff 45 08             	incl   0x8(%ebp)
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	8a 00                	mov    (%eax),%al
  80160a:	84 c0                	test   %al,%al
  80160c:	75 f1                	jne    8015ff <strlen+0xf>
		n++;
	return n;
  80160e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801619:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801620:	eb 09                	jmp    80162b <strnlen+0x18>
		n++;
  801622:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801625:	ff 45 08             	incl   0x8(%ebp)
  801628:	ff 4d 0c             	decl   0xc(%ebp)
  80162b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162f:	74 09                	je     80163a <strnlen+0x27>
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	84 c0                	test   %al,%al
  801638:	75 e8                	jne    801622 <strnlen+0xf>
		n++;
	return n;
  80163a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80164b:	90                   	nop
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
  801662:	8a 00                	mov    (%eax),%al
  801664:	84 c0                	test   %al,%al
  801666:	75 e4                	jne    80164c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801668:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801679:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801680:	eb 1f                	jmp    8016a1 <strncpy+0x34>
		*dst++ = *src;
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8d 50 01             	lea    0x1(%eax),%edx
  801688:	89 55 08             	mov    %edx,0x8(%ebp)
  80168b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168e:	8a 12                	mov    (%edx),%dl
  801690:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	84 c0                	test   %al,%al
  801699:	74 03                	je     80169e <strncpy+0x31>
			src++;
  80169b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80169e:	ff 45 fc             	incl   -0x4(%ebp)
  8016a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016a7:	72 d9                	jb     801682 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8016a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016be:	74 30                	je     8016f0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016c0:	eb 16                	jmp    8016d8 <strlcpy+0x2a>
			*dst++ = *src++;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8d 50 01             	lea    0x1(%eax),%edx
  8016c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016d4:	8a 12                	mov    (%edx),%dl
  8016d6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016d8:	ff 4d 10             	decl   0x10(%ebp)
  8016db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016df:	74 09                	je     8016ea <strlcpy+0x3c>
  8016e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	84 c0                	test   %al,%al
  8016e8:	75 d8                	jne    8016c2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f6:	29 c2                	sub    %eax,%edx
  8016f8:	89 d0                	mov    %edx,%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ff:	eb 06                	jmp    801707 <strcmp+0xb>
		p++, q++;
  801701:	ff 45 08             	incl   0x8(%ebp)
  801704:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	84 c0                	test   %al,%al
  80170e:	74 0e                	je     80171e <strcmp+0x22>
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8a 10                	mov    (%eax),%dl
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	38 c2                	cmp    %al,%dl
  80171c:	74 e3                	je     801701 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	0f b6 d0             	movzbl %al,%edx
  801726:	8b 45 0c             	mov    0xc(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 c0             	movzbl %al,%eax
  80172e:	29 c2                	sub    %eax,%edx
  801730:	89 d0                	mov    %edx,%eax
}
  801732:	5d                   	pop    %ebp
  801733:	c3                   	ret    

00801734 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801737:	eb 09                	jmp    801742 <strncmp+0xe>
		n--, p++, q++;
  801739:	ff 4d 10             	decl   0x10(%ebp)
  80173c:	ff 45 08             	incl   0x8(%ebp)
  80173f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801742:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801746:	74 17                	je     80175f <strncmp+0x2b>
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	84 c0                	test   %al,%al
  80174f:	74 0e                	je     80175f <strncmp+0x2b>
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8a 10                	mov    (%eax),%dl
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	38 c2                	cmp    %al,%dl
  80175d:	74 da                	je     801739 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80175f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801763:	75 07                	jne    80176c <strncmp+0x38>
		return 0;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	eb 14                	jmp    801780 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8a 00                	mov    (%eax),%al
  801771:	0f b6 d0             	movzbl %al,%edx
  801774:	8b 45 0c             	mov    0xc(%ebp),%eax
  801777:	8a 00                	mov    (%eax),%al
  801779:	0f b6 c0             	movzbl %al,%eax
  80177c:	29 c2                	sub    %eax,%edx
  80177e:	89 d0                	mov    %edx,%eax
}
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80178e:	eb 12                	jmp    8017a2 <strchr+0x20>
		if (*s == c)
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801798:	75 05                	jne    80179f <strchr+0x1d>
			return (char *) s;
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	eb 11                	jmp    8017b0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80179f:	ff 45 08             	incl   0x8(%ebp)
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8a 00                	mov    (%eax),%al
  8017a7:	84 c0                	test   %al,%al
  8017a9:	75 e5                	jne    801790 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017be:	eb 0d                	jmp    8017cd <strfind+0x1b>
		if (*s == c)
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8a 00                	mov    (%eax),%al
  8017c5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017c8:	74 0e                	je     8017d8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017ca:	ff 45 08             	incl   0x8(%ebp)
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	84 c0                	test   %al,%al
  8017d4:	75 ea                	jne    8017c0 <strfind+0xe>
  8017d6:	eb 01                	jmp    8017d9 <strfind+0x27>
		if (*s == c)
			break;
  8017d8:	90                   	nop
	return (char *) s;
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017f0:	eb 0e                	jmp    801800 <memset+0x22>
		*p++ = c;
  8017f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f5:	8d 50 01             	lea    0x1(%eax),%edx
  8017f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801800:	ff 4d f8             	decl   -0x8(%ebp)
  801803:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801807:	79 e9                	jns    8017f2 <memset+0x14>
		*p++ = c;

	return v;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801820:	eb 16                	jmp    801838 <memcpy+0x2a>
		*d++ = *s++;
  801822:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801825:	8d 50 01             	lea    0x1(%eax),%edx
  801828:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80182b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801831:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801834:	8a 12                	mov    (%edx),%dl
  801836:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801838:	8b 45 10             	mov    0x10(%ebp),%eax
  80183b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80183e:	89 55 10             	mov    %edx,0x10(%ebp)
  801841:	85 c0                	test   %eax,%eax
  801843:	75 dd                	jne    801822 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801850:	8b 45 0c             	mov    0xc(%ebp),%eax
  801853:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80185c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801862:	73 50                	jae    8018b4 <memmove+0x6a>
  801864:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	01 d0                	add    %edx,%eax
  80186c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80186f:	76 43                	jbe    8018b4 <memmove+0x6a>
		s += n;
  801871:	8b 45 10             	mov    0x10(%ebp),%eax
  801874:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801877:	8b 45 10             	mov    0x10(%ebp),%eax
  80187a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80187d:	eb 10                	jmp    80188f <memmove+0x45>
			*--d = *--s;
  80187f:	ff 4d f8             	decl   -0x8(%ebp)
  801882:	ff 4d fc             	decl   -0x4(%ebp)
  801885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801888:	8a 10                	mov    (%eax),%dl
  80188a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	8d 50 ff             	lea    -0x1(%eax),%edx
  801895:	89 55 10             	mov    %edx,0x10(%ebp)
  801898:	85 c0                	test   %eax,%eax
  80189a:	75 e3                	jne    80187f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80189c:	eb 23                	jmp    8018c1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80189e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a1:	8d 50 01             	lea    0x1(%eax),%edx
  8018a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018ad:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018b0:	8a 12                	mov    (%edx),%dl
  8018b2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	75 dd                	jne    80189e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018d8:	eb 2a                	jmp    801904 <memcmp+0x3e>
		if (*s1 != *s2)
  8018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018dd:	8a 10                	mov    (%eax),%dl
  8018df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	38 c2                	cmp    %al,%dl
  8018e6:	74 16                	je     8018fe <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	0f b6 d0             	movzbl %al,%edx
  8018f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f b6 c0             	movzbl %al,%eax
  8018f8:	29 c2                	sub    %eax,%edx
  8018fa:	89 d0                	mov    %edx,%eax
  8018fc:	eb 18                	jmp    801916 <memcmp+0x50>
		s1++, s2++;
  8018fe:	ff 45 fc             	incl   -0x4(%ebp)
  801901:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801904:	8b 45 10             	mov    0x10(%ebp),%eax
  801907:	8d 50 ff             	lea    -0x1(%eax),%edx
  80190a:	89 55 10             	mov    %edx,0x10(%ebp)
  80190d:	85 c0                	test   %eax,%eax
  80190f:	75 c9                	jne    8018da <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801911:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80191e:	8b 55 08             	mov    0x8(%ebp),%edx
  801921:	8b 45 10             	mov    0x10(%ebp),%eax
  801924:	01 d0                	add    %edx,%eax
  801926:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801929:	eb 15                	jmp    801940 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	0f b6 d0             	movzbl %al,%edx
  801933:	8b 45 0c             	mov    0xc(%ebp),%eax
  801936:	0f b6 c0             	movzbl %al,%eax
  801939:	39 c2                	cmp    %eax,%edx
  80193b:	74 0d                	je     80194a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80193d:	ff 45 08             	incl   0x8(%ebp)
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801946:	72 e3                	jb     80192b <memfind+0x13>
  801948:	eb 01                	jmp    80194b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80194a:	90                   	nop
	return (void *) s;
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801956:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80195d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801964:	eb 03                	jmp    801969 <strtol+0x19>
		s++;
  801966:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	8a 00                	mov    (%eax),%al
  80196e:	3c 20                	cmp    $0x20,%al
  801970:	74 f4                	je     801966 <strtol+0x16>
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	8a 00                	mov    (%eax),%al
  801977:	3c 09                	cmp    $0x9,%al
  801979:	74 eb                	je     801966 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	8a 00                	mov    (%eax),%al
  801980:	3c 2b                	cmp    $0x2b,%al
  801982:	75 05                	jne    801989 <strtol+0x39>
		s++;
  801984:	ff 45 08             	incl   0x8(%ebp)
  801987:	eb 13                	jmp    80199c <strtol+0x4c>
	else if (*s == '-')
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	8a 00                	mov    (%eax),%al
  80198e:	3c 2d                	cmp    $0x2d,%al
  801990:	75 0a                	jne    80199c <strtol+0x4c>
		s++, neg = 1;
  801992:	ff 45 08             	incl   0x8(%ebp)
  801995:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80199c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019a0:	74 06                	je     8019a8 <strtol+0x58>
  8019a2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019a6:	75 20                	jne    8019c8 <strtol+0x78>
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8a 00                	mov    (%eax),%al
  8019ad:	3c 30                	cmp    $0x30,%al
  8019af:	75 17                	jne    8019c8 <strtol+0x78>
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	40                   	inc    %eax
  8019b5:	8a 00                	mov    (%eax),%al
  8019b7:	3c 78                	cmp    $0x78,%al
  8019b9:	75 0d                	jne    8019c8 <strtol+0x78>
		s += 2, base = 16;
  8019bb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019bf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019c6:	eb 28                	jmp    8019f0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019cc:	75 15                	jne    8019e3 <strtol+0x93>
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	8a 00                	mov    (%eax),%al
  8019d3:	3c 30                	cmp    $0x30,%al
  8019d5:	75 0c                	jne    8019e3 <strtol+0x93>
		s++, base = 8;
  8019d7:	ff 45 08             	incl   0x8(%ebp)
  8019da:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019e1:	eb 0d                	jmp    8019f0 <strtol+0xa0>
	else if (base == 0)
  8019e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019e7:	75 07                	jne    8019f0 <strtol+0xa0>
		base = 10;
  8019e9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	3c 2f                	cmp    $0x2f,%al
  8019f7:	7e 19                	jle    801a12 <strtol+0xc2>
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	8a 00                	mov    (%eax),%al
  8019fe:	3c 39                	cmp    $0x39,%al
  801a00:	7f 10                	jg     801a12 <strtol+0xc2>
			dig = *s - '0';
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	0f be c0             	movsbl %al,%eax
  801a0a:	83 e8 30             	sub    $0x30,%eax
  801a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a10:	eb 42                	jmp    801a54 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	8a 00                	mov    (%eax),%al
  801a17:	3c 60                	cmp    $0x60,%al
  801a19:	7e 19                	jle    801a34 <strtol+0xe4>
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	8a 00                	mov    (%eax),%al
  801a20:	3c 7a                	cmp    $0x7a,%al
  801a22:	7f 10                	jg     801a34 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	0f be c0             	movsbl %al,%eax
  801a2c:	83 e8 57             	sub    $0x57,%eax
  801a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a32:	eb 20                	jmp    801a54 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	8a 00                	mov    (%eax),%al
  801a39:	3c 40                	cmp    $0x40,%al
  801a3b:	7e 39                	jle    801a76 <strtol+0x126>
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	3c 5a                	cmp    $0x5a,%al
  801a44:	7f 30                	jg     801a76 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8a 00                	mov    (%eax),%al
  801a4b:	0f be c0             	movsbl %al,%eax
  801a4e:	83 e8 37             	sub    $0x37,%eax
  801a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a57:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a5a:	7d 19                	jge    801a75 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a5c:	ff 45 08             	incl   0x8(%ebp)
  801a5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a62:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a66:	89 c2                	mov    %eax,%edx
  801a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6b:	01 d0                	add    %edx,%eax
  801a6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a70:	e9 7b ff ff ff       	jmp    8019f0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a75:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a7a:	74 08                	je     801a84 <strtol+0x134>
		*endptr = (char *) s;
  801a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a82:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a84:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a88:	74 07                	je     801a91 <strtol+0x141>
  801a8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a8d:	f7 d8                	neg    %eax
  801a8f:	eb 03                	jmp    801a94 <strtol+0x144>
  801a91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <ltostr>:

void
ltostr(long value, char *str)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801aa3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801aaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aae:	79 13                	jns    801ac3 <ltostr+0x2d>
	{
		neg = 1;
  801ab0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aba:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801abd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ac0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801acb:	99                   	cltd   
  801acc:	f7 f9                	idiv   %ecx
  801ace:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ad1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad4:	8d 50 01             	lea    0x1(%eax),%edx
  801ad7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ada:	89 c2                	mov    %eax,%edx
  801adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adf:	01 d0                	add    %edx,%eax
  801ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ae4:	83 c2 30             	add    $0x30,%edx
  801ae7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ae9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801af1:	f7 e9                	imul   %ecx
  801af3:	c1 fa 02             	sar    $0x2,%edx
  801af6:	89 c8                	mov    %ecx,%eax
  801af8:	c1 f8 1f             	sar    $0x1f,%eax
  801afb:	29 c2                	sub    %eax,%edx
  801afd:	89 d0                	mov    %edx,%eax
  801aff:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b06:	75 bb                	jne    801ac3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b12:	48                   	dec    %eax
  801b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b16:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b1a:	74 3d                	je     801b59 <ltostr+0xc3>
		start = 1 ;
  801b1c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b23:	eb 34                	jmp    801b59 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2b:	01 d0                	add    %edx,%eax
  801b2d:	8a 00                	mov    (%eax),%al
  801b2f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c2                	add    %eax,%edx
  801b3a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b40:	01 c8                	add    %ecx,%eax
  801b42:	8a 00                	mov    (%eax),%al
  801b44:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	01 c2                	add    %eax,%edx
  801b4e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b51:	88 02                	mov    %al,(%edx)
		start++ ;
  801b53:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b56:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b5f:	7c c4                	jl     801b25 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b61:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b67:	01 d0                	add    %edx,%eax
  801b69:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b75:	ff 75 08             	pushl  0x8(%ebp)
  801b78:	e8 73 fa ff ff       	call   8015f0 <strlen>
  801b7d:	83 c4 04             	add    $0x4,%esp
  801b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	e8 65 fa ff ff       	call   8015f0 <strlen>
  801b8b:	83 c4 04             	add    $0x4,%esp
  801b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b9f:	eb 17                	jmp    801bb8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801ba1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba7:	01 c2                	add    %eax,%edx
  801ba9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	01 c8                	add    %ecx,%eax
  801bb1:	8a 00                	mov    (%eax),%al
  801bb3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bb5:	ff 45 fc             	incl   -0x4(%ebp)
  801bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bbe:	7c e1                	jl     801ba1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bc7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bce:	eb 1f                	jmp    801bef <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd3:	8d 50 01             	lea    0x1(%eax),%edx
  801bd6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bd9:	89 c2                	mov    %eax,%edx
  801bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bde:	01 c2                	add    %eax,%edx
  801be0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be6:	01 c8                	add    %ecx,%eax
  801be8:	8a 00                	mov    (%eax),%al
  801bea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bec:	ff 45 f8             	incl   -0x8(%ebp)
  801bef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bf2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bf5:	7c d9                	jl     801bd0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801bf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfd:	01 d0                	add    %edx,%eax
  801bff:	c6 00 00             	movb   $0x0,(%eax)
}
  801c02:	90                   	nop
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c08:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c11:	8b 45 14             	mov    0x14(%ebp),%eax
  801c14:	8b 00                	mov    (%eax),%eax
  801c16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c20:	01 d0                	add    %edx,%eax
  801c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c28:	eb 0c                	jmp    801c36 <strsplit+0x31>
			*string++ = 0;
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	8d 50 01             	lea    0x1(%eax),%edx
  801c30:	89 55 08             	mov    %edx,0x8(%ebp)
  801c33:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	8a 00                	mov    (%eax),%al
  801c3b:	84 c0                	test   %al,%al
  801c3d:	74 18                	je     801c57 <strsplit+0x52>
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	8a 00                	mov    (%eax),%al
  801c44:	0f be c0             	movsbl %al,%eax
  801c47:	50                   	push   %eax
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	e8 32 fb ff ff       	call   801782 <strchr>
  801c50:	83 c4 08             	add    $0x8,%esp
  801c53:	85 c0                	test   %eax,%eax
  801c55:	75 d3                	jne    801c2a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	8a 00                	mov    (%eax),%al
  801c5c:	84 c0                	test   %al,%al
  801c5e:	74 5a                	je     801cba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c60:	8b 45 14             	mov    0x14(%ebp),%eax
  801c63:	8b 00                	mov    (%eax),%eax
  801c65:	83 f8 0f             	cmp    $0xf,%eax
  801c68:	75 07                	jne    801c71 <strsplit+0x6c>
		{
			return 0;
  801c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6f:	eb 66                	jmp    801cd7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c71:	8b 45 14             	mov    0x14(%ebp),%eax
  801c74:	8b 00                	mov    (%eax),%eax
  801c76:	8d 48 01             	lea    0x1(%eax),%ecx
  801c79:	8b 55 14             	mov    0x14(%ebp),%edx
  801c7c:	89 0a                	mov    %ecx,(%edx)
  801c7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c85:	8b 45 10             	mov    0x10(%ebp),%eax
  801c88:	01 c2                	add    %eax,%edx
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c8f:	eb 03                	jmp    801c94 <strsplit+0x8f>
			string++;
  801c91:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	8a 00                	mov    (%eax),%al
  801c99:	84 c0                	test   %al,%al
  801c9b:	74 8b                	je     801c28 <strsplit+0x23>
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	8a 00                	mov    (%eax),%al
  801ca2:	0f be c0             	movsbl %al,%eax
  801ca5:	50                   	push   %eax
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	e8 d4 fa ff ff       	call   801782 <strchr>
  801cae:	83 c4 08             	add    $0x8,%esp
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	74 dc                	je     801c91 <strsplit+0x8c>
			string++;
	}
  801cb5:	e9 6e ff ff ff       	jmp    801c28 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cbb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbe:	8b 00                	mov    (%eax),%eax
  801cc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cca:	01 d0                	add    %edx,%eax
  801ccc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801cdf:	83 ec 04             	sub    $0x4,%esp
  801ce2:	68 08 31 80 00       	push   $0x803108
  801ce7:	68 3f 01 00 00       	push   $0x13f
  801cec:	68 2a 31 80 00       	push   $0x80312a
  801cf1:	e8 a9 ef ff ff       	call   800c9f <_panic>

00801cf6 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	e8 ef 06 00 00       	call   8023f6 <sys_sbrk>
  801d07:	83 c4 10             	add    $0x10,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d16:	75 07                	jne    801d1f <malloc+0x13>
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	eb 14                	jmp    801d33 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801d1f:	83 ec 04             	sub    $0x4,%esp
  801d22:	68 38 31 80 00       	push   $0x803138
  801d27:	6a 1b                	push   $0x1b
  801d29:	68 5d 31 80 00       	push   $0x80315d
  801d2e:	e8 6c ef ff ff       	call   800c9f <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d3b:	83 ec 04             	sub    $0x4,%esp
  801d3e:	68 6c 31 80 00       	push   $0x80316c
  801d43:	6a 29                	push   $0x29
  801d45:	68 5d 31 80 00       	push   $0x80315d
  801d4a:	e8 50 ef ff ff       	call   800c9f <_panic>

00801d4f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 18             	sub    $0x18,%esp
  801d55:	8b 45 10             	mov    0x10(%ebp),%eax
  801d58:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801d5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d5f:	75 07                	jne    801d68 <smalloc+0x19>
  801d61:	b8 00 00 00 00       	mov    $0x0,%eax
  801d66:	eb 14                	jmp    801d7c <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801d68:	83 ec 04             	sub    $0x4,%esp
  801d6b:	68 90 31 80 00       	push   $0x803190
  801d70:	6a 38                	push   $0x38
  801d72:	68 5d 31 80 00       	push   $0x80315d
  801d77:	e8 23 ef ff ff       	call   800c9f <_panic>
	return NULL;
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	68 b8 31 80 00       	push   $0x8031b8
  801d8c:	6a 43                	push   $0x43
  801d8e:	68 5d 31 80 00       	push   $0x80315d
  801d93:	e8 07 ef ff ff       	call   800c9f <_panic>

00801d98 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	68 dc 31 80 00       	push   $0x8031dc
  801da6:	6a 5b                	push   $0x5b
  801da8:	68 5d 31 80 00       	push   $0x80315d
  801dad:	e8 ed ee ff ff       	call   800c9f <_panic>

00801db2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801db8:	83 ec 04             	sub    $0x4,%esp
  801dbb:	68 00 32 80 00       	push   $0x803200
  801dc0:	6a 72                	push   $0x72
  801dc2:	68 5d 31 80 00       	push   $0x80315d
  801dc7:	e8 d3 ee ff ff       	call   800c9f <_panic>

00801dcc <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dd2:	83 ec 04             	sub    $0x4,%esp
  801dd5:	68 26 32 80 00       	push   $0x803226
  801dda:	6a 7e                	push   $0x7e
  801ddc:	68 5d 31 80 00       	push   $0x80315d
  801de1:	e8 b9 ee ff ff       	call   800c9f <_panic>

00801de6 <shrink>:

}
void shrink(uint32 newSize)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dec:	83 ec 04             	sub    $0x4,%esp
  801def:	68 26 32 80 00       	push   $0x803226
  801df4:	68 83 00 00 00       	push   $0x83
  801df9:	68 5d 31 80 00       	push   $0x80315d
  801dfe:	e8 9c ee ff ff       	call   800c9f <_panic>

00801e03 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	68 26 32 80 00       	push   $0x803226
  801e11:	68 88 00 00 00       	push   $0x88
  801e16:	68 5d 31 80 00       	push   $0x80315d
  801e1b:	e8 7f ee ff ff       	call   800c9f <_panic>

00801e20 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	57                   	push   %edi
  801e24:	56                   	push   %esi
  801e25:	53                   	push   %ebx
  801e26:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e35:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e38:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e3b:	cd 30                	int    $0x30
  801e3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	5b                   	pop    %ebx
  801e47:	5e                   	pop    %esi
  801e48:	5f                   	pop    %edi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    

00801e4b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	8b 45 10             	mov    0x10(%ebp),%eax
  801e54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e57:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	52                   	push   %edx
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	50                   	push   %eax
  801e67:	6a 00                	push   $0x0
  801e69:	e8 b2 ff ff ff       	call   801e20 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	90                   	nop
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 02                	push   $0x2
  801e83:	e8 98 ff ff ff       	call   801e20 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 03                	push   $0x3
  801e9c:	e8 7f ff ff ff       	call   801e20 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	90                   	nop
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 04                	push   $0x4
  801eb6:	e8 65 ff ff ff       	call   801e20 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	90                   	nop
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	6a 08                	push   $0x8
  801ed4:	e8 47 ff ff ff       	call   801e20 <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	56                   	push   %esi
  801ee2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ee3:	8b 75 18             	mov    0x18(%ebp),%esi
  801ee6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	56                   	push   %esi
  801ef3:	53                   	push   %ebx
  801ef4:	51                   	push   %ecx
  801ef5:	52                   	push   %edx
  801ef6:	50                   	push   %eax
  801ef7:	6a 09                	push   $0x9
  801ef9:	e8 22 ff ff ff       	call   801e20 <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
}
  801f01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f04:	5b                   	pop    %ebx
  801f05:	5e                   	pop    %esi
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    

00801f08 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	52                   	push   %edx
  801f18:	50                   	push   %eax
  801f19:	6a 0a                	push   $0xa
  801f1b:	e8 00 ff ff ff       	call   801e20 <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	6a 0b                	push   $0xb
  801f36:	e8 e5 fe ff ff       	call   801e20 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 0c                	push   $0xc
  801f4f:	e8 cc fe ff ff       	call   801e20 <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 0d                	push   $0xd
  801f68:	e8 b3 fe ff ff       	call   801e20 <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 0e                	push   $0xe
  801f81:	e8 9a fe ff ff       	call   801e20 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 0f                	push   $0xf
  801f9a:	e8 81 fe ff ff       	call   801e20 <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	ff 75 08             	pushl  0x8(%ebp)
  801fb2:	6a 10                	push   $0x10
  801fb4:	e8 67 fe ff ff       	call   801e20 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 11                	push   $0x11
  801fcd:	e8 4e fe ff ff       	call   801e20 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	90                   	nop
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_cputc>:

void
sys_cputc(const char c)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fe4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	50                   	push   %eax
  801ff1:	6a 01                	push   $0x1
  801ff3:	e8 28 fe ff ff       	call   801e20 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	90                   	nop
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 14                	push   $0x14
  80200d:	e8 0e fe ff ff       	call   801e20 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
}
  802015:	90                   	nop
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	8b 45 10             	mov    0x10(%ebp),%eax
  802021:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802024:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802027:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	6a 00                	push   $0x0
  802030:	51                   	push   %ecx
  802031:	52                   	push   %edx
  802032:	ff 75 0c             	pushl  0xc(%ebp)
  802035:	50                   	push   %eax
  802036:	6a 15                	push   $0x15
  802038:	e8 e3 fd ff ff       	call   801e20 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	52                   	push   %edx
  802052:	50                   	push   %eax
  802053:	6a 16                	push   $0x16
  802055:	e8 c6 fd ff ff       	call   801e20 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802062:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802065:	8b 55 0c             	mov    0xc(%ebp),%edx
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	51                   	push   %ecx
  802070:	52                   	push   %edx
  802071:	50                   	push   %eax
  802072:	6a 17                	push   $0x17
  802074:	e8 a7 fd ff ff       	call   801e20 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802081:	8b 55 0c             	mov    0xc(%ebp),%edx
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	52                   	push   %edx
  80208e:	50                   	push   %eax
  80208f:	6a 18                	push   $0x18
  802091:	e8 8a fd ff ff       	call   801e20 <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	6a 00                	push   $0x0
  8020a3:	ff 75 14             	pushl  0x14(%ebp)
  8020a6:	ff 75 10             	pushl  0x10(%ebp)
  8020a9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ac:	50                   	push   %eax
  8020ad:	6a 19                	push   $0x19
  8020af:	e8 6c fd ff ff       	call   801e20 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	50                   	push   %eax
  8020c8:	6a 1a                	push   $0x1a
  8020ca:	e8 51 fd ff ff       	call   801e20 <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	50                   	push   %eax
  8020e4:	6a 1b                	push   $0x1b
  8020e6:	e8 35 fd ff ff       	call   801e20 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 05                	push   $0x5
  8020ff:	e8 1c fd ff ff       	call   801e20 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 06                	push   $0x6
  802118:	e8 03 fd ff ff       	call   801e20 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 07                	push   $0x7
  802131:	e8 ea fc ff ff       	call   801e20 <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_exit_env>:


void sys_exit_env(void)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 1c                	push   $0x1c
  80214a:	e8 d1 fc ff ff       	call   801e20 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	90                   	nop
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80215b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80215e:	8d 50 04             	lea    0x4(%eax),%edx
  802161:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	52                   	push   %edx
  80216b:	50                   	push   %eax
  80216c:	6a 1d                	push   $0x1d
  80216e:	e8 ad fc ff ff       	call   801e20 <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
	return result;
  802176:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802179:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80217c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217f:	89 01                	mov    %eax,(%ecx)
  802181:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	c9                   	leave  
  802188:	c2 04 00             	ret    $0x4

0080218b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	ff 75 10             	pushl  0x10(%ebp)
  802195:	ff 75 0c             	pushl  0xc(%ebp)
  802198:	ff 75 08             	pushl  0x8(%ebp)
  80219b:	6a 13                	push   $0x13
  80219d:	e8 7e fc ff ff       	call   801e20 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a5:	90                   	nop
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 1e                	push   $0x1e
  8021b7:	e8 64 fc ff ff       	call   801e20 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 04             	sub    $0x4,%esp
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021cd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	50                   	push   %eax
  8021da:	6a 1f                	push   $0x1f
  8021dc:	e8 3f fc ff ff       	call   801e20 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e4:	90                   	nop
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <rsttst>:
void rsttst()
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 21                	push   $0x21
  8021f6:	e8 25 fc ff ff       	call   801e20 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fe:	90                   	nop
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	8b 45 14             	mov    0x14(%ebp),%eax
  80220a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80220d:	8b 55 18             	mov    0x18(%ebp),%edx
  802210:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802214:	52                   	push   %edx
  802215:	50                   	push   %eax
  802216:	ff 75 10             	pushl  0x10(%ebp)
  802219:	ff 75 0c             	pushl  0xc(%ebp)
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	6a 20                	push   $0x20
  802221:	e8 fa fb ff ff       	call   801e20 <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
	return ;
  802229:	90                   	nop
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <chktst>:
void chktst(uint32 n)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	ff 75 08             	pushl  0x8(%ebp)
  80223a:	6a 22                	push   $0x22
  80223c:	e8 df fb ff ff       	call   801e20 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
	return ;
  802244:	90                   	nop
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <inctst>:

void inctst()
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 23                	push   $0x23
  802256:	e8 c5 fb ff ff       	call   801e20 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
	return ;
  80225e:	90                   	nop
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <gettst>:
uint32 gettst()
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 24                	push   $0x24
  802270:	e8 ab fb ff ff       	call   801e20 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 25                	push   $0x25
  80228c:	e8 8f fb ff ff       	call   801e20 <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
  802294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802297:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80229b:	75 07                	jne    8022a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80229d:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a2:	eb 05                	jmp    8022a9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 25                	push   $0x25
  8022bd:	e8 5e fb ff ff       	call   801e20 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
  8022c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022c8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022cc:	75 07                	jne    8022d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d3:	eb 05                	jmp    8022da <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 25                	push   $0x25
  8022ee:	e8 2d fb ff ff       	call   801e20 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
  8022f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022f9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022fd:	75 07                	jne    802306 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802304:	eb 05                	jmp    80230b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 25                	push   $0x25
  80231f:	e8 fc fa ff ff       	call   801e20 <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
  802327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80232a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80232e:	75 07                	jne    802337 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802330:	b8 01 00 00 00       	mov    $0x1,%eax
  802335:	eb 05                	jmp    80233c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	ff 75 08             	pushl  0x8(%ebp)
  80234c:	6a 26                	push   $0x26
  80234e:	e8 cd fa ff ff       	call   801e20 <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
	return ;
  802356:	90                   	nop
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80235d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802360:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802363:	8b 55 0c             	mov    0xc(%ebp),%edx
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	6a 00                	push   $0x0
  80236b:	53                   	push   %ebx
  80236c:	51                   	push   %ecx
  80236d:	52                   	push   %edx
  80236e:	50                   	push   %eax
  80236f:	6a 27                	push   $0x27
  802371:	e8 aa fa ff ff       	call   801e20 <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
}
  802379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802381:	8b 55 0c             	mov    0xc(%ebp),%edx
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	52                   	push   %edx
  80238e:	50                   	push   %eax
  80238f:	6a 28                	push   $0x28
  802391:	e8 8a fa ff ff       	call   801e20 <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80239e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	6a 00                	push   $0x0
  8023a9:	51                   	push   %ecx
  8023aa:	ff 75 10             	pushl  0x10(%ebp)
  8023ad:	52                   	push   %edx
  8023ae:	50                   	push   %eax
  8023af:	6a 29                	push   $0x29
  8023b1:	e8 6a fa ff ff       	call   801e20 <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	ff 75 10             	pushl  0x10(%ebp)
  8023c5:	ff 75 0c             	pushl  0xc(%ebp)
  8023c8:	ff 75 08             	pushl  0x8(%ebp)
  8023cb:	6a 12                	push   $0x12
  8023cd:	e8 4e fa ff ff       	call   801e20 <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d5:	90                   	nop
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8023db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	52                   	push   %edx
  8023e8:	50                   	push   %eax
  8023e9:	6a 2a                	push   $0x2a
  8023eb:	e8 30 fa ff ff       	call   801e20 <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
	return;
  8023f3:	90                   	nop
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8023fc:	83 ec 04             	sub    $0x4,%esp
  8023ff:	68 36 32 80 00       	push   $0x803236
  802404:	68 2e 01 00 00       	push   $0x12e
  802409:	68 4a 32 80 00       	push   $0x80324a
  80240e:	e8 8c e8 ff ff       	call   800c9f <_panic>

00802413 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	68 36 32 80 00       	push   $0x803236
  802421:	68 35 01 00 00       	push   $0x135
  802426:	68 4a 32 80 00       	push   $0x80324a
  80242b:	e8 6f e8 ff ff       	call   800c9f <_panic>

00802430 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802436:	83 ec 04             	sub    $0x4,%esp
  802439:	68 36 32 80 00       	push   $0x803236
  80243e:	68 3b 01 00 00       	push   $0x13b
  802443:	68 4a 32 80 00       	push   $0x80324a
  802448:	e8 52 e8 ff ff       	call   800c9f <_panic>

0080244d <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 58 32 80 00       	push   $0x803258
  80245b:	6a 09                	push   $0x9
  80245d:	68 80 32 80 00       	push   $0x803280
  802462:	e8 38 e8 ff ff       	call   800c9f <_panic>

00802467 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	68 90 32 80 00       	push   $0x803290
  802475:	6a 10                	push   $0x10
  802477:	68 80 32 80 00       	push   $0x803280
  80247c:	e8 1e e8 ff ff       	call   800c9f <_panic>

00802481 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  802487:	83 ec 04             	sub    $0x4,%esp
  80248a:	68 b8 32 80 00       	push   $0x8032b8
  80248f:	6a 18                	push   $0x18
  802491:	68 80 32 80 00       	push   $0x803280
  802496:	e8 04 e8 ff ff       	call   800c9f <_panic>

0080249b <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8024a1:	83 ec 04             	sub    $0x4,%esp
  8024a4:	68 e0 32 80 00       	push   $0x8032e0
  8024a9:	6a 20                	push   $0x20
  8024ab:	68 80 32 80 00       	push   $0x803280
  8024b0:	e8 ea e7 ff ff       	call   800c9f <_panic>

008024b5 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	8b 40 10             	mov    0x10(%eax),%eax
}
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    

008024c0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8024c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c9:	89 d0                	mov    %edx,%eax
  8024cb:	c1 e0 02             	shl    $0x2,%eax
  8024ce:	01 d0                	add    %edx,%eax
  8024d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024d7:	01 d0                	add    %edx,%eax
  8024d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024e0:	01 d0                	add    %edx,%eax
  8024e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	c1 e0 04             	shl    $0x4,%eax
  8024ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8024f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8024f8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8024fb:	83 ec 0c             	sub    $0xc,%esp
  8024fe:	50                   	push   %eax
  8024ff:	e8 51 fc ff ff       	call   802155 <sys_get_virtual_time>
  802504:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802507:	eb 41                	jmp    80254a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802509:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80250c:	83 ec 0c             	sub    $0xc,%esp
  80250f:	50                   	push   %eax
  802510:	e8 40 fc ff ff       	call   802155 <sys_get_virtual_time>
  802515:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802518:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80251b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251e:	29 c2                	sub    %eax,%edx
  802520:	89 d0                	mov    %edx,%eax
  802522:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802525:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252b:	89 d1                	mov    %edx,%ecx
  80252d:	29 c1                	sub    %eax,%ecx
  80252f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802535:	39 c2                	cmp    %eax,%edx
  802537:	0f 97 c0             	seta   %al
  80253a:	0f b6 c0             	movzbl %al,%eax
  80253d:	29 c1                	sub    %eax,%ecx
  80253f:	89 c8                	mov    %ecx,%eax
  802541:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802544:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802547:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802550:	72 b7                	jb     802509 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802552:	90                   	nop
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80255b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802562:	eb 03                	jmp    802567 <busy_wait+0x12>
  802564:	ff 45 fc             	incl   -0x4(%ebp)
  802567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80256a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256d:	72 f5                	jb     802564 <busy_wait+0xf>
	return i;
  80256f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <__udivdi3>:
  802574:	55                   	push   %ebp
  802575:	57                   	push   %edi
  802576:	56                   	push   %esi
  802577:	53                   	push   %ebx
  802578:	83 ec 1c             	sub    $0x1c,%esp
  80257b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80257f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802583:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802587:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80258b:	89 ca                	mov    %ecx,%edx
  80258d:	89 f8                	mov    %edi,%eax
  80258f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802593:	85 f6                	test   %esi,%esi
  802595:	75 2d                	jne    8025c4 <__udivdi3+0x50>
  802597:	39 cf                	cmp    %ecx,%edi
  802599:	77 65                	ja     802600 <__udivdi3+0x8c>
  80259b:	89 fd                	mov    %edi,%ebp
  80259d:	85 ff                	test   %edi,%edi
  80259f:	75 0b                	jne    8025ac <__udivdi3+0x38>
  8025a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a6:	31 d2                	xor    %edx,%edx
  8025a8:	f7 f7                	div    %edi
  8025aa:	89 c5                	mov    %eax,%ebp
  8025ac:	31 d2                	xor    %edx,%edx
  8025ae:	89 c8                	mov    %ecx,%eax
  8025b0:	f7 f5                	div    %ebp
  8025b2:	89 c1                	mov    %eax,%ecx
  8025b4:	89 d8                	mov    %ebx,%eax
  8025b6:	f7 f5                	div    %ebp
  8025b8:	89 cf                	mov    %ecx,%edi
  8025ba:	89 fa                	mov    %edi,%edx
  8025bc:	83 c4 1c             	add    $0x1c,%esp
  8025bf:	5b                   	pop    %ebx
  8025c0:	5e                   	pop    %esi
  8025c1:	5f                   	pop    %edi
  8025c2:	5d                   	pop    %ebp
  8025c3:	c3                   	ret    
  8025c4:	39 ce                	cmp    %ecx,%esi
  8025c6:	77 28                	ja     8025f0 <__udivdi3+0x7c>
  8025c8:	0f bd fe             	bsr    %esi,%edi
  8025cb:	83 f7 1f             	xor    $0x1f,%edi
  8025ce:	75 40                	jne    802610 <__udivdi3+0x9c>
  8025d0:	39 ce                	cmp    %ecx,%esi
  8025d2:	72 0a                	jb     8025de <__udivdi3+0x6a>
  8025d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8025d8:	0f 87 9e 00 00 00    	ja     80267c <__udivdi3+0x108>
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e3:	89 fa                	mov    %edi,%edx
  8025e5:	83 c4 1c             	add    $0x1c,%esp
  8025e8:	5b                   	pop    %ebx
  8025e9:	5e                   	pop    %esi
  8025ea:	5f                   	pop    %edi
  8025eb:	5d                   	pop    %ebp
  8025ec:	c3                   	ret    
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	31 ff                	xor    %edi,%edi
  8025f2:	31 c0                	xor    %eax,%eax
  8025f4:	89 fa                	mov    %edi,%edx
  8025f6:	83 c4 1c             	add    $0x1c,%esp
  8025f9:	5b                   	pop    %ebx
  8025fa:	5e                   	pop    %esi
  8025fb:	5f                   	pop    %edi
  8025fc:	5d                   	pop    %ebp
  8025fd:	c3                   	ret    
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	89 d8                	mov    %ebx,%eax
  802602:	f7 f7                	div    %edi
  802604:	31 ff                	xor    %edi,%edi
  802606:	89 fa                	mov    %edi,%edx
  802608:	83 c4 1c             	add    $0x1c,%esp
  80260b:	5b                   	pop    %ebx
  80260c:	5e                   	pop    %esi
  80260d:	5f                   	pop    %edi
  80260e:	5d                   	pop    %ebp
  80260f:	c3                   	ret    
  802610:	bd 20 00 00 00       	mov    $0x20,%ebp
  802615:	89 eb                	mov    %ebp,%ebx
  802617:	29 fb                	sub    %edi,%ebx
  802619:	89 f9                	mov    %edi,%ecx
  80261b:	d3 e6                	shl    %cl,%esi
  80261d:	89 c5                	mov    %eax,%ebp
  80261f:	88 d9                	mov    %bl,%cl
  802621:	d3 ed                	shr    %cl,%ebp
  802623:	89 e9                	mov    %ebp,%ecx
  802625:	09 f1                	or     %esi,%ecx
  802627:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80262b:	89 f9                	mov    %edi,%ecx
  80262d:	d3 e0                	shl    %cl,%eax
  80262f:	89 c5                	mov    %eax,%ebp
  802631:	89 d6                	mov    %edx,%esi
  802633:	88 d9                	mov    %bl,%cl
  802635:	d3 ee                	shr    %cl,%esi
  802637:	89 f9                	mov    %edi,%ecx
  802639:	d3 e2                	shl    %cl,%edx
  80263b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80263f:	88 d9                	mov    %bl,%cl
  802641:	d3 e8                	shr    %cl,%eax
  802643:	09 c2                	or     %eax,%edx
  802645:	89 d0                	mov    %edx,%eax
  802647:	89 f2                	mov    %esi,%edx
  802649:	f7 74 24 0c          	divl   0xc(%esp)
  80264d:	89 d6                	mov    %edx,%esi
  80264f:	89 c3                	mov    %eax,%ebx
  802651:	f7 e5                	mul    %ebp
  802653:	39 d6                	cmp    %edx,%esi
  802655:	72 19                	jb     802670 <__udivdi3+0xfc>
  802657:	74 0b                	je     802664 <__udivdi3+0xf0>
  802659:	89 d8                	mov    %ebx,%eax
  80265b:	31 ff                	xor    %edi,%edi
  80265d:	e9 58 ff ff ff       	jmp    8025ba <__udivdi3+0x46>
  802662:	66 90                	xchg   %ax,%ax
  802664:	8b 54 24 08          	mov    0x8(%esp),%edx
  802668:	89 f9                	mov    %edi,%ecx
  80266a:	d3 e2                	shl    %cl,%edx
  80266c:	39 c2                	cmp    %eax,%edx
  80266e:	73 e9                	jae    802659 <__udivdi3+0xe5>
  802670:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802673:	31 ff                	xor    %edi,%edi
  802675:	e9 40 ff ff ff       	jmp    8025ba <__udivdi3+0x46>
  80267a:	66 90                	xchg   %ax,%ax
  80267c:	31 c0                	xor    %eax,%eax
  80267e:	e9 37 ff ff ff       	jmp    8025ba <__udivdi3+0x46>
  802683:	90                   	nop

00802684 <__umoddi3>:
  802684:	55                   	push   %ebp
  802685:	57                   	push   %edi
  802686:	56                   	push   %esi
  802687:	53                   	push   %ebx
  802688:	83 ec 1c             	sub    $0x1c,%esp
  80268b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80268f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802697:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80269b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80269f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026a3:	89 f3                	mov    %esi,%ebx
  8026a5:	89 fa                	mov    %edi,%edx
  8026a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026ab:	89 34 24             	mov    %esi,(%esp)
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	75 1a                	jne    8026cc <__umoddi3+0x48>
  8026b2:	39 f7                	cmp    %esi,%edi
  8026b4:	0f 86 a2 00 00 00    	jbe    80275c <__umoddi3+0xd8>
  8026ba:	89 c8                	mov    %ecx,%eax
  8026bc:	89 f2                	mov    %esi,%edx
  8026be:	f7 f7                	div    %edi
  8026c0:	89 d0                	mov    %edx,%eax
  8026c2:	31 d2                	xor    %edx,%edx
  8026c4:	83 c4 1c             	add    $0x1c,%esp
  8026c7:	5b                   	pop    %ebx
  8026c8:	5e                   	pop    %esi
  8026c9:	5f                   	pop    %edi
  8026ca:	5d                   	pop    %ebp
  8026cb:	c3                   	ret    
  8026cc:	39 f0                	cmp    %esi,%eax
  8026ce:	0f 87 ac 00 00 00    	ja     802780 <__umoddi3+0xfc>
  8026d4:	0f bd e8             	bsr    %eax,%ebp
  8026d7:	83 f5 1f             	xor    $0x1f,%ebp
  8026da:	0f 84 ac 00 00 00    	je     80278c <__umoddi3+0x108>
  8026e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8026e5:	29 ef                	sub    %ebp,%edi
  8026e7:	89 fe                	mov    %edi,%esi
  8026e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ed:	89 e9                	mov    %ebp,%ecx
  8026ef:	d3 e0                	shl    %cl,%eax
  8026f1:	89 d7                	mov    %edx,%edi
  8026f3:	89 f1                	mov    %esi,%ecx
  8026f5:	d3 ef                	shr    %cl,%edi
  8026f7:	09 c7                	or     %eax,%edi
  8026f9:	89 e9                	mov    %ebp,%ecx
  8026fb:	d3 e2                	shl    %cl,%edx
  8026fd:	89 14 24             	mov    %edx,(%esp)
  802700:	89 d8                	mov    %ebx,%eax
  802702:	d3 e0                	shl    %cl,%eax
  802704:	89 c2                	mov    %eax,%edx
  802706:	8b 44 24 08          	mov    0x8(%esp),%eax
  80270a:	d3 e0                	shl    %cl,%eax
  80270c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802710:	8b 44 24 08          	mov    0x8(%esp),%eax
  802714:	89 f1                	mov    %esi,%ecx
  802716:	d3 e8                	shr    %cl,%eax
  802718:	09 d0                	or     %edx,%eax
  80271a:	d3 eb                	shr    %cl,%ebx
  80271c:	89 da                	mov    %ebx,%edx
  80271e:	f7 f7                	div    %edi
  802720:	89 d3                	mov    %edx,%ebx
  802722:	f7 24 24             	mull   (%esp)
  802725:	89 c6                	mov    %eax,%esi
  802727:	89 d1                	mov    %edx,%ecx
  802729:	39 d3                	cmp    %edx,%ebx
  80272b:	0f 82 87 00 00 00    	jb     8027b8 <__umoddi3+0x134>
  802731:	0f 84 91 00 00 00    	je     8027c8 <__umoddi3+0x144>
  802737:	8b 54 24 04          	mov    0x4(%esp),%edx
  80273b:	29 f2                	sub    %esi,%edx
  80273d:	19 cb                	sbb    %ecx,%ebx
  80273f:	89 d8                	mov    %ebx,%eax
  802741:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802745:	d3 e0                	shl    %cl,%eax
  802747:	89 e9                	mov    %ebp,%ecx
  802749:	d3 ea                	shr    %cl,%edx
  80274b:	09 d0                	or     %edx,%eax
  80274d:	89 e9                	mov    %ebp,%ecx
  80274f:	d3 eb                	shr    %cl,%ebx
  802751:	89 da                	mov    %ebx,%edx
  802753:	83 c4 1c             	add    $0x1c,%esp
  802756:	5b                   	pop    %ebx
  802757:	5e                   	pop    %esi
  802758:	5f                   	pop    %edi
  802759:	5d                   	pop    %ebp
  80275a:	c3                   	ret    
  80275b:	90                   	nop
  80275c:	89 fd                	mov    %edi,%ebp
  80275e:	85 ff                	test   %edi,%edi
  802760:	75 0b                	jne    80276d <__umoddi3+0xe9>
  802762:	b8 01 00 00 00       	mov    $0x1,%eax
  802767:	31 d2                	xor    %edx,%edx
  802769:	f7 f7                	div    %edi
  80276b:	89 c5                	mov    %eax,%ebp
  80276d:	89 f0                	mov    %esi,%eax
  80276f:	31 d2                	xor    %edx,%edx
  802771:	f7 f5                	div    %ebp
  802773:	89 c8                	mov    %ecx,%eax
  802775:	f7 f5                	div    %ebp
  802777:	89 d0                	mov    %edx,%eax
  802779:	e9 44 ff ff ff       	jmp    8026c2 <__umoddi3+0x3e>
  80277e:	66 90                	xchg   %ax,%ax
  802780:	89 c8                	mov    %ecx,%eax
  802782:	89 f2                	mov    %esi,%edx
  802784:	83 c4 1c             	add    $0x1c,%esp
  802787:	5b                   	pop    %ebx
  802788:	5e                   	pop    %esi
  802789:	5f                   	pop    %edi
  80278a:	5d                   	pop    %ebp
  80278b:	c3                   	ret    
  80278c:	3b 04 24             	cmp    (%esp),%eax
  80278f:	72 06                	jb     802797 <__umoddi3+0x113>
  802791:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802795:	77 0f                	ja     8027a6 <__umoddi3+0x122>
  802797:	89 f2                	mov    %esi,%edx
  802799:	29 f9                	sub    %edi,%ecx
  80279b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80279f:	89 14 24             	mov    %edx,(%esp)
  8027a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027aa:	8b 14 24             	mov    (%esp),%edx
  8027ad:	83 c4 1c             	add    $0x1c,%esp
  8027b0:	5b                   	pop    %ebx
  8027b1:	5e                   	pop    %esi
  8027b2:	5f                   	pop    %edi
  8027b3:	5d                   	pop    %ebp
  8027b4:	c3                   	ret    
  8027b5:	8d 76 00             	lea    0x0(%esi),%esi
  8027b8:	2b 04 24             	sub    (%esp),%eax
  8027bb:	19 fa                	sbb    %edi,%edx
  8027bd:	89 d1                	mov    %edx,%ecx
  8027bf:	89 c6                	mov    %eax,%esi
  8027c1:	e9 71 ff ff ff       	jmp    802737 <__umoddi3+0xb3>
  8027c6:	66 90                	xchg   %ax,%ax
  8027c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8027cc:	72 ea                	jb     8027b8 <__umoddi3+0x134>
  8027ce:	89 d9                	mov    %ebx,%ecx
  8027d0:	e9 62 ff ff ff       	jmp    802737 <__umoddi3+0xb3>

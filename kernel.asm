
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 90 9e 11 80       	mov    $0x80119e90,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 58 c5 10 80       	mov    $0x8010c558,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 84 10 80       	push   $0x80108400
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 05 53 00 00       	call   80105360 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 98 0c 11 80       	mov    $0x80110c98,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 ec 0c 11 80 98 	movl   $0x80110c98,0x80110cec
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 f0 0c 11 80 98 	movl   $0x80110c98,0x80110cf0
80100074:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 58             	mov    %eax,0x58(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 54 98 0c 11 80 	movl   $0x80110c98,0x54(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 84 10 80       	push   $0x80108407
80100097:	50                   	push   %eax
80100098:	e8 93 51 00 00       	call   80105230 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 f0 0c 11 80       	mov    0x80110cf0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 60 02 00 00    	lea    0x260(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 54             	mov    %ebx,0x54(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d f0 0c 11 80    	mov    %ebx,0x80110cf0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 38 0a 11 80    	cmp    $0x80110a38,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 67 54 00 00       	call   80105550 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d f0 0c 11 80    	mov    0x80110cf0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 98 0c 11 80    	cmp    $0x80110c98,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 58             	mov    0x58(%ebx),%ebx
80100103:	81 fb 98 0c 11 80    	cmp    $0x80110c98,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 50 01          	addl   $0x1,0x50(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d ec 0c 11 80    	mov    0x80110cec,%ebx
80100126:	81 fb 98 0c 11 80    	cmp    $0x80110c98,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100133:	81 fb 98 0c 11 80    	cmp    $0x80110c98,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 50             	mov    0x50(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 79 53 00 00       	call   801054e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 50 00 00       	call   80105270 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 84 10 80       	push   $0x8010840e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 4d 51 00 00       	call   80105310 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 84 10 80       	push   $0x8010841f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 51 00 00       	call   80105310 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 bc 50 00 00       	call   801052d0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 30 53 00 00       	call   80105550 <acquire>
  b->refcnt--;
80100220:	8b 43 50             	mov    0x50(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 50             	mov    %eax,0x50(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 58             	mov    0x58(%ebx),%eax
80100233:	8b 53 54             	mov    0x54(%ebx),%edx
80100236:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev->next = b->next;
80100239:	8b 43 54             	mov    0x54(%ebx),%eax
8010023c:	8b 53 58             	mov    0x58(%ebx),%edx
8010023f:	89 50 58             	mov    %edx,0x58(%eax)
    b->next = bcache.head.next;
80100242:	a1 f0 0c 11 80       	mov    0x80110cf0,%eax
    b->prev = &bcache.head;
80100247:	c7 43 54 98 0c 11 80 	movl   $0x80110c98,0x54(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 58             	mov    %eax,0x58(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 f0 0c 11 80       	mov    0x80110cf0,%eax
80100256:	89 58 54             	mov    %ebx,0x54(%eax)
    bcache.head.next = b;
80100259:	89 1d f0 0c 11 80    	mov    %ebx,0x80110cf0
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 6f 52 00 00       	jmp    801054e0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 84 10 80       	push   $0x80108426
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 a0 0f 11 80 	movl   $0x80110fa0,(%esp)
801002a0:	e8 ab 52 00 00       	call   80105550 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 80 0f 11 80       	mov    0x80110f80,%eax
801002b5:	3b 05 84 0f 11 80    	cmp    0x80110f84,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 a0 0f 11 80       	push   $0x80110fa0
801002c8:	68 80 0f 11 80       	push   $0x80110f80
801002cd:	e8 4e 45 00 00       	call   80104820 <sleep>
    while(input.r == input.w){
801002d2:	a1 80 0f 11 80       	mov    0x80110f80,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 84 0f 11 80    	cmp    0x80110f84,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 37 00 00       	call   80103a60 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 a0 0f 11 80       	push   $0x80110fa0
801002f6:	e8 e5 51 00 00       	call   801054e0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 80 0f 11 80    	mov    %edx,0x80110f80
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 00 0f 11 80 	movsbl -0x7feef100(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 a0 0f 11 80       	push   $0x80110fa0
8010034c:	e8 8f 51 00 00       	call   801054e0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 80 0f 11 80       	mov    %eax,0x80110f80
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 d8 0f 11 80 00 	movl   $0x0,0x80110fd8
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 84 10 80       	push   $0x8010842d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 be 8a 10 80 	movl   $0x80108abe,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 4f 00 00       	call   80105390 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 84 10 80       	push   $0x80108441
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 dc 0f 11 80 01 	movl   $0x1,0x80110fdc
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 f1 6a 00 00       	call   80106f10 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 06 6a 00 00       	call   80106f10 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 fa 69 00 00       	call   80106f10 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ee 69 00 00       	call   80106f10 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 ea 51 00 00       	call   80105740 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 35 51 00 00       	call   801056a0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 45 84 10 80       	push   $0x80108445
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 a0 0f 11 80 	movl   $0x80110fa0,(%esp)
801005ab:	e8 a0 4f 00 00       	call   80105550 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 dc 0f 11 80    	mov    0x80110fdc,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 a0 0f 11 80       	push   $0x80110fa0
801005e4:	e8 f7 4e 00 00       	call   801054e0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 70 84 10 80 	movzbl -0x7fef7b90(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 dc 0f 11 80    	mov    0x80110fdc,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 d8 0f 11 80       	mov    0x80110fd8,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 dc 0f 11 80    	mov    0x80110fdc,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d dc 0f 11 80    	mov    0x80110fdc,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 dc 0f 11 80       	mov    0x80110fdc,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 a0 0f 11 80       	push   $0x80110fa0
801007e8:	e8 63 4d 00 00       	call   80105550 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d dc 0f 11 80    	mov    0x80110fdc,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 dc 0f 11 80    	mov    0x80110fdc,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 58 84 10 80       	mov    $0x80108458,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 a0 0f 11 80       	push   $0x80110fa0
8010085b:	e8 80 4c 00 00       	call   801054e0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 5f 84 10 80       	push   $0x8010845f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 a0 0f 11 80       	push   $0x80110fa0
80100893:	e8 b8 4c 00 00       	call   80105550 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 88 0f 11 80       	mov    0x80110f88,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 80 0f 11 80    	sub    0x80110f80,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 dc 0f 11 80    	mov    0x80110fdc,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 88 0f 11 80    	mov    %ecx,0x80110f88
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 00 0f 11 80    	mov    %bl,-0x7feef100(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 80 0f 11 80       	mov    0x80110f80,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 88 0f 11 80    	cmp    %eax,0x80110f88
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 88 0f 11 80       	mov    0x80110f88,%eax
80100945:	39 05 84 0f 11 80    	cmp    %eax,0x80110f84
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 00 0f 11 80 0a 	cmpb   $0xa,-0x7feef100(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 dc 0f 11 80    	mov    0x80110fdc,%edx
        input.e--;
8010096c:	a3 88 0f 11 80       	mov    %eax,0x80110f88
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 88 0f 11 80       	mov    0x80110f88,%eax
80100985:	3b 05 84 0f 11 80    	cmp    0x80110f84,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 88 0f 11 80       	mov    %eax,0x80110f88
  if(panicked){
80100999:	a1 dc 0f 11 80       	mov    0x80110fdc,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 88 0f 11 80       	mov    0x80110f88,%eax
801009b7:	3b 05 84 0f 11 80    	cmp    0x80110f84,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 a0 0f 11 80       	push   $0x80110fa0
801009d0:	e8 0b 4b 00 00       	call   801054e0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 ad 3f 00 00       	jmp    801049c0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 00 0f 11 80 0a 	movb   $0xa,-0x7feef100(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 88 0f 11 80       	mov    0x80110f88,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 84 0f 11 80       	mov    %eax,0x80110f84
          wakeup(&input.r);
80100a3f:	68 80 0f 11 80       	push   $0x80110f80
80100a44:	e8 97 3e 00 00       	call   801048e0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 68 84 10 80       	push   $0x80108468
80100a6b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a70:	e8 eb 48 00 00       	call   80105360 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 8c 19 11 80 90 	movl   $0x80100590,0x8011198c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 88 19 11 80 80 	movl   $0x80100280,0x80111988
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 d8 0f 11 80 01 	movl   $0x1,0x80110fd8
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 9f 2f 00 00       	call   80103a60 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 67 75 00 00       	call   801080a0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 18 73 00 00       	call   80107ec0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 f2 71 00 00       	call   80107dd0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 00 74 00 00       	call   80108020 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 59 72 00 00       	call   80107ec0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 b8 74 00 00       	call   80108140 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 c8 4b 00 00       	call   801058a0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 b4 4b 00 00       	call   801058a0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 13 76 00 00       	call   80108310 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 0a 73 00 00       	call   80108020 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 a8 75 00 00       	call   80108310 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 ba 4a 00 00       	call   80105860 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 6e 6e 00 00       	call   80107c40 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 46 72 00 00       	call   80108020 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 81 84 10 80       	push   $0x80108481
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 8d 84 10 80       	push   $0x8010848d
80100e1b:	68 e0 0f 11 80       	push   $0x80110fe0
80100e20:	e8 3b 45 00 00       	call   80105360 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 18 10 11 80       	mov    $0x80111018,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e41:	e8 0a 47 00 00       	call   80105550 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 78 19 11 80    	cmp    $0x80111978,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e71:	e8 6a 46 00 00       	call   801054e0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 e0 0f 11 80       	push   $0x80110fe0
80100e8a:	e8 51 46 00 00       	call   801054e0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 e0 0f 11 80       	push   $0x80110fe0
80100eaf:	e8 9c 46 00 00       	call   80105550 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 e0 0f 11 80       	push   $0x80110fe0
80100ecc:	e8 0f 46 00 00       	call   801054e0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 94 84 10 80       	push   $0x80108494
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 e0 0f 11 80       	push   $0x80110fe0
80100f01:	e8 4a 46 00 00       	call   80105550 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 9f 45 00 00       	call   801054e0 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 6d 45 00 00       	jmp    801054e0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 9c 84 10 80       	push   $0x8010849c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 a6 84 10 80       	push   $0x801084a6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 af 84 10 80       	push   $0x801084af
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 b5 84 10 80       	push   $0x801084b5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 18 37 11 80    	add    0x80113718,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 60       	movzbl 0x60(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 60          	mov    %al,0x60(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 bf 84 10 80       	push   $0x801084bf
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d 00 37 11 80    	mov    0x80113700,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 18 37 11 80    	add    0x80113718,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 00 37 11 80       	mov    0x80113700,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 60       	movzbl 0x60(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 00 37 11 80    	cmp    %eax,0x80113700
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 d2 84 10 80       	push   $0x801084d2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 60          	mov    %dl,0x60(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 60             	lea    0x60(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 76 43 00 00       	call   801056a0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 18 1a 11 80       	mov    $0x80111a18,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
8010136a:	e8 e1 41 00 00       	call   80105550 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010138a:	81 fb 00 37 11 80    	cmp    $0x80113700,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 94 00 00 00    	add    $0x94,%ebx
801013a9:	81 fb 00 37 11 80    	cmp    $0x80113700,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
  release(&icache.lock);
801013d2:	68 e0 19 11 80       	push   $0x801119e0
801013d7:	e8 04 41 00 00       	call   801054e0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 d6 40 00 00       	call   801054e0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010141d:	81 fb 00 37 11 80    	cmp    $0x80113700,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 e8 84 10 80       	push   $0x801084e8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a0 00 00 00    	ja     80101510 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 60          	lea    0x60(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 18             	lea    0x18(%edx),%ebx
801014f3:	8b 3c 98             	mov    (%eax,%ebx,4),%edi
801014f6:	85 ff                	test   %edi,%edi
801014f8:	75 a6                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fa:	8b 00                	mov    (%eax),%eax
801014fc:	e8 3f fd ff ff       	call   80101240 <balloc>
80101501:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
80101504:	89 c7                	mov    %eax,%edi
}
80101506:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101509:	5b                   	pop    %ebx
8010150a:	89 f8                	mov    %edi,%eax
8010150c:	5e                   	pop    %esi
8010150d:	5f                   	pop    %edi
8010150e:	5d                   	pop    %ebp
8010150f:	c3                   	ret    
  panic("bmap: out of range");
80101510:	83 ec 0c             	sub    $0xc,%esp
80101513:	68 f8 84 10 80       	push   $0x801084f8
80101518:	e8 63 ee ff ff       	call   80100380 <panic>
8010151d:	8d 76 00             	lea    0x0(%esi),%esi

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 60             	lea    0x60(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 fa 41 00 00       	call   80105740 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb 24 1a 11 80       	mov    $0x80111a24,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 0b 85 10 80       	push   $0x8010850b
80101571:	68 e0 19 11 80       	push   $0x801119e0
80101576:	e8 e5 3d 00 00       	call   80105360 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 12 85 10 80       	push   $0x80108512
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 94 00 00 00    	add    $0x94,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 9c 3c 00 00       	call   80105230 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb 0c 37 11 80    	cmp    $0x8011370c,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 60             	lea    0x60(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 00 37 11 80       	push   $0x80113700
801015bc:	e8 7f 41 00 00       	call   80105740 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 18 37 11 80    	push   0x80113718
801015cf:	ff 35 14 37 11 80    	push   0x80113714
801015d5:	ff 35 10 37 11 80    	push   0x80113710
801015db:	ff 35 0c 37 11 80    	push   0x8011370c
801015e1:	ff 35 08 37 11 80    	push   0x80113708
801015e7:	ff 35 04 37 11 80    	push   0x80113704
801015ed:	ff 35 00 37 11 80    	push   0x80113700
801015f3:	68 78 85 10 80       	push   $0x80108578
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d 08 37 11 80 01 	cmpl   $0x1,0x80113708
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d 08 37 11 80    	cmp    0x80113708,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 14 37 11 80    	add    0x80113714,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 60          	lea    0x60(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 0d 40 00 00       	call   801056a0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 18 85 10 80       	push   $0x80108518
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 60             	add    $0x60,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 14 37 11 80    	add    0x80113714,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a0             	push   -0x60(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 0a 40 00 00       	call   80105740 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 e0 19 11 80       	push   $0x801119e0
8010175f:	e8 ec 3d 00 00       	call   80105550 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010176f:	e8 6c 3d 00 00       	call   801054e0 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 c9 3a 00 00       	call   80105270 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 50             	mov    0x50(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 14 37 11 80    	add    0x80113714,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 58          	mov    %dx,0x58(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 5a          	mov    %dx,0x5a(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 5c             	mov    %edx,0x5c(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 60             	lea    0x60(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 23 3f 00 00       	call   80105740 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 54 00       	cmpw   $0x0,0x54(%ebx)
    ip->valid = 1;
8010182d:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 30 85 10 80       	push   $0x80108530
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 2a 85 10 80       	push   $0x8010852a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 98 3a 00 00       	call   80105310 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 3c 3a 00 00       	jmp    801052d0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 3f 85 10 80       	push   $0x8010853f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 ab 39 00 00       	call   80105270 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 50             	mov    0x50(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 f1 39 00 00       	call   801052d0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018e6:	e8 65 3c 00 00       	call   80105550 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 db 3b 00 00       	jmp    801054e0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 e0 19 11 80       	push   $0x801119e0
80101910:	e8 3b 3c 00 00       	call   80105550 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010191f:	e8 bc 3b 00 00       	call   801054e0 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 90 00 00 00    	lea    0x90(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 60             	lea    0x60(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 54          	mov    %ax,0x54(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 60 02 00 00    	lea    0x260(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 60             	lea    0x60(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 e8 38 00 00       	call   80105310 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 91 38 00 00       	call   801052d0 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 3f 85 10 80       	push   $0x8010853f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 54          	movzwl 0x54(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 5a          	movzwl 0x5a(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 5c             	mov    0x5c(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 5c             	mov    0x5c(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 60          	lea    0x60(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 04 3c 00 00       	call   80105740 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 5c             	cmp    0x5c(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 60          	lea    0x60(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 08 3b 00 00       	call   80105740 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 5c             	cmp    0x5c(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 5c             	mov    %esi,0x5c(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 dd 3a 00 00       	call   801057b0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 7e 3a 00 00       	call   801057b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 59 85 10 80       	push   $0x80108559
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 47 85 10 80       	push   $0x80108547
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 b1 1c 00 00       	call   80103a60 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 e0 19 11 80       	push   $0x801119e0
80101dba:	e8 91 37 00 00       	call   80105550 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dca:	e8 11 37 00 00       	call   801054e0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 14 39 00 00       	call   80105740 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 7f 34 00 00       	call   80105310 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 1d 34 00 00       	call   801052d0 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 60 38 00 00       	call   80105740 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 e0 33 00 00       	call   80105310 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 81 33 00 00       	call   801052d0 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 9e 33 00 00       	call   80105310 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 7b 33 00 00       	call   80105310 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 24 33 00 00       	call   801052d0 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 3f 85 10 80       	push   $0x8010853f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 5c             	mov    0x5c(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 be 37 00 00       	call   80105800 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 68 85 10 80       	push   $0x80108568
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 96 8d 10 80       	push   $0x80108d96
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 60             	lea    0x60(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 d4 85 10 80       	push   $0x801085d4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 cb 85 10 80       	push   $0x801085cb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 e6 85 10 80       	push   $0x801085e6
801021cb:	68 40 37 11 80       	push   $0x80113740
801021d0:	e8 8b 31 00 00       	call   80105360 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 c4 38 11 80       	mov    0x801138c4,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 20 37 11 80 01 	movl   $0x1,0x80113720
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 40 37 11 80       	push   $0x80113740
8010224e:	e8 fd 32 00 00       	call   80105550 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d 24 37 11 80    	mov    0x80113724,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 5c             	mov    0x5c(%ebx),%eax
80102263:	a3 24 37 11 80       	mov    %eax,0x80113724

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 60             	lea    0x60(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 2e 26 00 00       	call   801048e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 24 37 11 80       	mov    0x80113724,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 40 37 11 80       	push   $0x80113740
801022cb:	e8 10 32 00 00       	call   801054e0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 1d 30 00 00       	call   80105310 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 20 37 11 80       	mov    0x80113720,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 40 37 11 80       	push   $0x80113740
80102328:	e8 23 32 00 00       	call   80105550 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 24 37 11 80       	mov    0x80113724,%eax
  b->qnext = 0;
80102332:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 5c             	mov    0x5c(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 5c             	add    $0x5c,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d 24 37 11 80    	cmp    %ebx,0x80113724
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 40 37 11 80       	push   $0x80113740
80102368:	53                   	push   %ebx
80102369:	e8 b2 24 00 00       	call   80104820 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 40 37 11 80 	movl   $0x80113740,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 55 31 00 00       	jmp    801054e0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba 24 37 11 80       	mov    $0x80113724,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 15 86 10 80       	push   $0x80108615
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 00 86 10 80       	push   $0x80108600
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ea 85 10 80       	push   $0x801085ea
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 78 37 11 80 00 	movl   $0xfec00000,0x80113778
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 78 37 11 80    	mov    0x80113778,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 78 37 11 80    	mov    0x80113778,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 c0 38 11 80 	movzbl 0x801138c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 34 86 10 80       	push   $0x80108634
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 78 37 11 80    	mov    0x80113778,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 78 37 11 80    	mov    0x80113778,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 78 37 11 80    	mov    0x80113778,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 78 37 11 80    	mov    0x80113778,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 78 37 11 80    	mov    0x80113778,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 78 37 11 80       	mov    0x80113778,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 90 9e 11 80    	cmp    $0x80119e90,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 a9 31 00 00       	call   801056a0 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 b8 37 11 80    	mov    0x801137b8,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 bc 37 11 80       	mov    0x801137bc,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 b8 37 11 80       	mov    0x801137b8,%eax
  kmem.freelist = r;
80102510:	89 1d bc 37 11 80    	mov    %ebx,0x801137bc
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 80 37 11 80       	push   $0x80113780
80102528:	e8 23 30 00 00       	call   80105550 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 80 37 11 80 	movl   $0x80113780,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 98 2f 00 00       	jmp    801054e0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 66 86 10 80       	push   $0x80108666
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 b8 37 11 80 01 	movl   $0x1,0x801137b8
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 6c 86 10 80       	push   $0x8010866c
80102620:	68 80 37 11 80       	push   $0x80113780
80102625:	e8 36 2d 00 00       	call   80105360 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 b8 37 11 80 00 	movl   $0x0,0x801137b8
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 b8 37 11 80       	mov    0x801137b8,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 bc 37 11 80       	mov    0x801137bc,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 bc 37 11 80    	mov    %edx,0x801137bc
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 80 37 11 80       	push   $0x80113780
801026b3:	e8 98 2e 00 00       	call   80105550 <acquire>
  r = kmem.freelist;
801026b8:	a1 bc 37 11 80       	mov    0x801137bc,%eax
  if(kmem.use_lock)
801026bd:	8b 15 b8 37 11 80    	mov    0x801137b8,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d bc 37 11 80    	mov    %ecx,0x801137bc
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 80 37 11 80       	push   $0x80113780
801026e1:	e8 fa 2d 00 00       	call   801054e0 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d c0 37 11 80    	mov    0x801137c0,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 a0 87 10 80 	movzbl -0x7fef7860(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 a0 86 10 80 	movzbl -0x7fef7960(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 c0 37 11 80    	mov    %edx,0x801137c0
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 80 86 10 80 	mov    -0x7fef7980(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d c0 37 11 80    	mov    %ebx,0x801137c0
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 a0 87 10 80 	movzbl -0x7fef7860(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 c0 37 11 80       	mov    %eax,0x801137c0
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 c4 37 11 80       	mov    0x801137c4,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 c4 37 11 80       	mov    0x801137c4,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 c4 37 11 80       	mov    0x801137c4,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 c4 37 11 80       	mov    0x801137c4,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 f4 2b 00 00       	call   801056f0 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d 2c 38 11 80    	mov    0x8011382c,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 18 38 11 80       	mov    0x80113818,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 28 38 11 80    	push   0x80113828
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd 30 38 11 80 	push   -0x7feec7d0(,%edi,4)
80102c04:	ff 35 28 38 11 80    	push   0x80113828
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 60             	lea    0x60(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 60             	lea    0x60(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 17 2b 00 00       	call   80105740 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d 2c 38 11 80    	cmp    %edi,0x8011382c
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 18 38 11 80    	push   0x80113818
80102c6d:	ff 35 28 38 11 80    	push   0x80113828
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 2c 38 11 80       	mov    0x8011382c,%eax
80102c82:	89 43 60             	mov    %eax,0x60(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 30 38 11 80 	mov    -0x7feec7d0(,%edx,4),%ecx
80102c97:	89 4c 93 64          	mov    %ecx,0x64(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 a0 88 10 80       	push   $0x801088a0
80102ccf:	68 e0 37 11 80       	push   $0x801137e0
80102cd4:	e8 87 26 00 00       	call   80105360 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d 28 38 11 80    	mov    %ebx,0x80113828
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 18 38 11 80       	mov    %eax,0x80113818
  log.size = sb.nlog;
80102cf7:	89 15 1c 38 11 80    	mov    %edx,0x8011381c
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 60             	mov    0x60(%eax),%ebx
80102d0b:	89 1d 2c 38 11 80    	mov    %ebx,0x8011382c
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 64          	mov    0x64(%eax,%edx,4),%ecx
80102d24:	89 0c 95 30 38 11 80 	mov    %ecx,-0x7feec7d0(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 2c 38 11 80 00 	movl   $0x0,0x8011382c
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 e0 37 11 80       	push   $0x801137e0
80102d6b:	e8 e0 27 00 00       	call   80105550 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 e0 37 11 80       	push   $0x801137e0
80102d80:	68 e0 37 11 80       	push   $0x801137e0
80102d85:	e8 96 1a 00 00       	call   80104820 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 24 38 11 80       	mov    0x80113824,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 20 38 11 80       	mov    0x80113820,%eax
80102d9b:	8b 15 2c 38 11 80    	mov    0x8011382c,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 20 38 11 80       	mov    %eax,0x80113820
      release(&log.lock);
80102db7:	68 e0 37 11 80       	push   $0x801137e0
80102dbc:	e8 1f 27 00 00       	call   801054e0 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 e0 37 11 80       	push   $0x801137e0
80102dde:	e8 6d 27 00 00       	call   80105550 <acquire>
  log.outstanding -= 1;
80102de3:	a1 20 38 11 80       	mov    0x80113820,%eax
  if(log.committing)
80102de8:	8b 35 24 38 11 80    	mov    0x80113824,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d 20 38 11 80    	mov    %ebx,0x80113820
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 24 38 11 80 01 	movl   $0x1,0x80113824
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 e0 37 11 80       	push   $0x801137e0
80102e1c:	e8 bf 26 00 00       	call   801054e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d 2c 38 11 80    	mov    0x8011382c,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 e0 37 11 80       	push   $0x801137e0
80102e36:	e8 15 27 00 00       	call   80105550 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 e0 37 11 80 	movl   $0x801137e0,(%esp)
    log.committing = 0;
80102e42:	c7 05 24 38 11 80 00 	movl   $0x0,0x80113824
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 8f 1a 00 00       	call   801048e0 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 e0 37 11 80 	movl   $0x801137e0,(%esp)
80102e58:	e8 83 26 00 00       	call   801054e0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 18 38 11 80       	mov    0x80113818,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 28 38 11 80    	push   0x80113828
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d 30 38 11 80 	push   -0x7feec7d0(,%ebx,4)
80102e94:	ff 35 28 38 11 80    	push   0x80113828
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 60             	lea    0x60(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 60             	lea    0x60(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 87 28 00 00       	call   80105740 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d 2c 38 11 80    	cmp    0x8011382c,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 2c 38 11 80 00 	movl   $0x0,0x8011382c
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 e0 37 11 80       	push   $0x801137e0
80102f08:	e8 d3 19 00 00       	call   801048e0 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 e0 37 11 80 	movl   $0x801137e0,(%esp)
80102f14:	e8 c7 25 00 00       	call   801054e0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 a4 88 10 80       	push   $0x801088a4
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 2c 38 11 80    	mov    0x8011382c,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 1c 38 11 80       	mov    0x8011381c,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 20 38 11 80       	mov    0x80113820,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 e0 37 11 80       	push   $0x801137e0
80102f76:	e8 d5 25 00 00       	call   80105550 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 2c 38 11 80    	mov    0x8011382c,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 30 38 11 80 	cmp    %ecx,-0x7feec7d0(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 30 38 11 80 	mov    %ecx,-0x7feec7d0(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 e0 37 11 80 	movl   $0x801137e0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 26 25 00 00       	jmp    801054e0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 30 38 11 80 	mov    %ecx,-0x7feec7d0(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 2c 38 11 80    	mov    %edx,0x8011382c
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 30 38 11 80       	mov    %eax,0x80113830
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 b3 88 10 80       	push   $0x801088b3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 c9 88 10 80       	push   $0x801088c9
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 34 0a 00 00       	call   80103a40 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 2d 0a 00 00       	call   80103a40 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 e4 88 10 80       	push   $0x801088e4
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 19 3b 00 00       	call   80106b40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 b4 09 00 00       	call   801039e0 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 71 12 00 00       	call   801042b0 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 e5 4b 00 00       	call   80107c30 <switchkvm>
  seginit();
8010304b:	e8 50 4b 00 00       	call   80107ba0 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 90 9e 11 80       	push   $0x80119e90
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 9a 50 00 00       	call   80108120 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 0b 4b 00 00       	call   80107ba0 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 87 3d 00 00       	call   80106e30 <uartinit>
  pinit();         // process table
801030a9:	e8 12 09 00 00       	call   801039c0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 0d 3a 00 00       	call   80106ac0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c c4 10 80       	push   $0x8010c48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 67 26 00 00       	call   80105740 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 c4 38 11 80 b0 	imul   $0xb0,0x801138c4,%eax
801030e3:	00 00 00 
801030e6:	05 e0 38 11 80       	add    $0x801138e0,%eax
801030eb:	3d e0 38 11 80       	cmp    $0x801138e0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb e0 38 11 80       	mov    $0x801138e0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 c4 38 11 80 b0 	imul   $0xb0,0x801138c4,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 e0 38 11 80       	add    $0x801138e0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 c2 08 00 00       	call   801039e0 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010313b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 09 09 00 00       	call   80103a90 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 f8 88 10 80       	push   $0x801088f8
801031c3:	56                   	push   %esi
801031c4:	e8 27 25 00 00       	call   801056f0 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 fd 88 10 80       	push   $0x801088fd
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 6c 24 00 00       	call   801056f0 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 c4 37 11 80       	mov    %eax,0x801137c4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d c0 38 11 80    	mov    %cl,0x801138c0
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d c4 38 11 80    	mov    0x801138c4,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d c4 38 11 80    	mov    %ecx,0x801138c4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f e0 38 11 80    	mov    %bl,-0x7feec720(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 02 89 10 80       	push   $0x80108902
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 f8 88 10 80       	push   $0x801088f8
801033c7:	53                   	push   %ebx
801033c8:	e8 23 23 00 00       	call   801056f0 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 1c 89 10 80       	push   $0x8010891c
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 44 02 00 00 01 	movl   $0x1,0x244(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 3b 89 10 80       	push   $0x8010893b
801034a8:	50                   	push   %eax
801034a9:	e8 b2 1e 00 00       	call   80105360 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 0c 20 00 00       	call   80105550 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 44 02 00 00 00 	movl   $0x0,0x244(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 7c 13 00 00       	call   801048e0 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 44 02 00 00    	mov    0x244(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 57 1f 00 00       	jmp    801054e0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 47 1f 00 00       	call   801054e0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 3c 02 00 00    	lea    0x23c(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 17 13 00 00       	call   801048e0 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 6e 1f 00 00       	call   80105550 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 3c 02 00 00    	mov    0x23c(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 3c 02 00 00    	lea    0x23c(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 33 04 00 00       	call   80103a60 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 a3 12 00 00       	call   801048e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 da 11 00 00       	call   80104820 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010364c:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 6f 1e 00 00       	call   801054e0 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 3c 02 00 00    	mov    %ecx,0x23c(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 38          	mov    %al,0x38(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 21 12 00 00       	call   801048e0 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 19 1e 00 00       	call   801054e0 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 38 02 00 00    	lea    0x238(%esi),%ebx
801036e6:	e8 65 1e 00 00       	call   80105550 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 3c 02 00 00    	cmp    %eax,0x23c(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 5b 03 00 00       	call   80103a60 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 06 11 00 00       	call   80104820 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 3c 02 00 00    	mov    0x23c(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 44 02 00 00    	mov    0x244(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 38 02 00 00    	mov    %ecx,0x238(%esi)
8010374e:	0f b6 44 06 38       	movzbl 0x38(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103764:	3b 86 3c 02 00 00    	cmp    0x23c(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 3c 02 00 00    	lea    0x23c(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 65 11 00 00       	call   801048e0 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 5d 1d 00 00       	call   801054e0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 42 1d 00 00       	call   801054e0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 18 45 11 80       	mov    $0x80114518,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 e0 44 11 80       	push   $0x801144e0
801037c1:	e8 8a 1d 00 00       	call   80105550 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 04 01 00 00    	add    $0x104,%ebx
801037d6:	81 fb 18 86 11 80    	cmp    $0x80118618,%ebx
801037dc:	0f 84 d6 00 00 00    	je     801038b8 <allocproc+0x108>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	8b 0d 04 c0 10 80    	mov    0x8010c004,%ecx
  p->state = EMBRYO;
801037ef:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 100/p->pid;
  p->queue = (p->pid == 0 || p->pid == 1 || p->pid == 2) ? 1 : 2;     //FCFS
  p->exec_cycle = 0;
801037f6:	c7 83 f4 00 00 00 00 	movl   $0x0,0xf4(%ebx)
801037fd:	00 00 00 
  p->pid = nextpid++;
80103800:	8d 41 01             	lea    0x1(%ecx),%eax
80103803:	89 4b 10             	mov    %ecx,0x10(%ebx)
80103806:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  p->priority = 100/p->pid;
8010380b:	b8 64 00 00 00       	mov    $0x64,%eax
  p->last_cpu_time = 0;
80103810:	c7 83 fc 00 00 00 00 	movl   $0x0,0xfc(%ebx)
80103817:	00 00 00 
  p->priority = 100/p->pid;
8010381a:	99                   	cltd   
8010381b:	f7 f9                	idiv   %ecx
  p->exec_cycle_ratio = 1;
8010381d:	c7 83 f8 00 00 00 01 	movl   $0x1,0xf8(%ebx)
80103824:	00 00 00 
  p->arrival_time_ratio = 1;
80103827:	c7 83 f0 00 00 00 01 	movl   $0x1,0xf0(%ebx)
8010382e:	00 00 00 
  p->priority_ratio = 1;
80103831:	c7 83 ec 00 00 00 01 	movl   $0x1,0xec(%ebx)
80103838:	00 00 00 
  p->priority = 100/p->pid;
8010383b:	89 83 e8 00 00 00    	mov    %eax,0xe8(%ebx)
  p->queue = (p->pid == 0 || p->pid == 1 || p->pid == 2) ? 1 : 2;     //FCFS
80103841:	31 c0                	xor    %eax,%eax
80103843:	83 f9 02             	cmp    $0x2,%ecx
80103846:	0f 97 c0             	seta   %al
  p->creation_time = ticks;
  // unlock me!
  release(&ptable.lock);
80103849:	83 ec 0c             	sub    $0xc,%esp
  p->queue = (p->pid == 0 || p->pid == 1 || p->pid == 2) ? 1 : 2;     //FCFS
8010384c:	83 c0 01             	add    $0x1,%eax
8010384f:	89 83 e0 00 00 00    	mov    %eax,0xe0(%ebx)
  p->creation_time = ticks;
80103855:	a1 20 86 11 80       	mov    0x80118620,%eax
8010385a:	89 83 e4 00 00 00    	mov    %eax,0xe4(%ebx)
  release(&ptable.lock);
80103860:	68 e0 44 11 80       	push   $0x801144e0
80103865:	e8 76 1c 00 00       	call   801054e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010386a:	e8 11 ee ff ff       	call   80102680 <kalloc>
8010386f:	83 c4 10             	add    $0x10,%esp
80103872:	89 43 08             	mov    %eax,0x8(%ebx)
80103875:	85 c0                	test   %eax,%eax
80103877:	74 58                	je     801038d1 <allocproc+0x121>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103879:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010387f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103882:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103887:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010388a:	c7 40 14 ad 6a 10 80 	movl   $0x80106aad,0x14(%eax)
  p->context = (struct context*)sp;
80103891:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103894:	6a 14                	push   $0x14
80103896:	6a 00                	push   $0x0
80103898:	50                   	push   %eax
80103899:	e8 02 1e 00 00       	call   801056a0 <memset>
  p->context->eip = (uint)forkret;
8010389e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038a1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038a4:	c7 40 10 f0 38 10 80 	movl   $0x801038f0,0x10(%eax)
}
801038ab:	89 d8                	mov    %ebx,%eax
801038ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b0:	c9                   	leave  
801038b1:	c3                   	ret    
801038b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038b8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038bb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038bd:	68 e0 44 11 80       	push   $0x801144e0
801038c2:	e8 19 1c 00 00       	call   801054e0 <release>
}
801038c7:	89 d8                	mov    %ebx,%eax
  return 0;
801038c9:	83 c4 10             	add    $0x10,%esp
}
801038cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038cf:	c9                   	leave  
801038d0:	c3                   	ret    
    p->state = UNUSED;
801038d1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038d8:	31 db                	xor    %ebx,%ebx
}
801038da:	89 d8                	mov    %ebx,%eax
801038dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038df:	c9                   	leave  
801038e0:	c3                   	ret    
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ef:	90                   	nop

801038f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038f6:	68 e0 44 11 80       	push   $0x801144e0
801038fb:	e8 e0 1b 00 00       	call   801054e0 <release>

  if (first) {
80103900:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	85 c0                	test   %eax,%eax
8010390a:	75 04                	jne    80103910 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010390c:	c9                   	leave  
8010390d:	c3                   	ret    
8010390e:	66 90                	xchg   %ax,%ax
    first = 0;
80103910:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103917:	00 00 00 
    iinit(ROOTDEV);
8010391a:	83 ec 0c             	sub    $0xc,%esp
8010391d:	6a 01                	push   $0x1
8010391f:	e8 3c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010392b:	e8 90 f3 ff ff       	call   80102cc0 <initlog>
}
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	c9                   	leave  
80103934:	c3                   	ret    
80103935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103940 <compareStrings>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	56                   	push   %esi
80103944:	8b 45 08             	mov    0x8(%ebp),%eax
80103947:	53                   	push   %ebx
80103948:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    while (*x != '\0' || *y != '\0') {
8010394b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010394f:	90                   	nop
80103950:	0f b6 10             	movzbl (%eax),%edx
        if (*x == *y) {
80103953:	0f b6 0b             	movzbl (%ebx),%ecx
    while (*x != '\0' || *y != '\0') {
80103956:	84 d2                	test   %dl,%dl
80103958:	75 56                	jne    801039b0 <compareStrings+0x70>
8010395a:	84 c9                	test   %cl,%cl
8010395c:	0f 94 c1             	sete   %cl
8010395f:	0f b6 c9             	movzbl %cl,%ecx
80103962:	89 ce                	mov    %ecx,%esi
    cprintf("%s", x);
80103964:	83 ec 08             	sub    $0x8,%esp
80103967:	50                   	push   %eax
80103968:	68 1a 8a 10 80       	push   $0x80108a1a
8010396d:	e8 2e cd ff ff       	call   801006a0 <cprintf>
    cprintf("/n");
80103972:	c7 04 24 40 89 10 80 	movl   $0x80108940,(%esp)
80103979:	e8 22 cd ff ff       	call   801006a0 <cprintf>
    cprintf("%s", y);
8010397e:	58                   	pop    %eax
8010397f:	5a                   	pop    %edx
80103980:	53                   	push   %ebx
80103981:	68 1a 8a 10 80       	push   $0x80108a1a
80103986:	e8 15 cd ff ff       	call   801006a0 <cprintf>
    cprintf("/n");
8010398b:	c7 04 24 40 89 10 80 	movl   $0x80108940,(%esp)
80103992:	e8 09 cd ff ff       	call   801006a0 <cprintf>
    cprintf("%d", flag);
80103997:	59                   	pop    %ecx
80103998:	5b                   	pop    %ebx
80103999:	56                   	push   %esi
8010399a:	68 43 89 10 80       	push   $0x80108943
8010399f:	e8 fc cc ff ff       	call   801006a0 <cprintf>
}
801039a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039a7:	89 f0                	mov    %esi,%eax
801039a9:	5b                   	pop    %ebx
801039aa:	5e                   	pop    %esi
801039ab:	5d                   	pop    %ebp
801039ac:	c3                   	ret    
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
        if (*x == *y) {
801039b0:	38 ca                	cmp    %cl,%dl
801039b2:	75 08                	jne    801039bc <compareStrings+0x7c>
            x++;
801039b4:	83 c0 01             	add    $0x1,%eax
            y++;
801039b7:	83 c3 01             	add    $0x1,%ebx
801039ba:	eb 94                	jmp    80103950 <compareStrings+0x10>
            flag = 0;
801039bc:	31 f6                	xor    %esi,%esi
801039be:	eb a4                	jmp    80103964 <compareStrings+0x24>

801039c0 <pinit>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039c6:	68 46 89 10 80       	push   $0x80108946
801039cb:	68 e0 44 11 80       	push   $0x801144e0
801039d0:	e8 8b 19 00 00       	call   80105360 <initlock>
}
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	c9                   	leave  
801039d9:	c3                   	ret    
801039da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039e0 <mycpu>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	56                   	push   %esi
801039e4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039e5:	9c                   	pushf  
801039e6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039e7:	f6 c4 02             	test   $0x2,%ah
801039ea:	75 46                	jne    80103a32 <mycpu+0x52>
  apicid = lapicid();
801039ec:	e8 ff ee ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039f1:	8b 35 c4 38 11 80    	mov    0x801138c4,%esi
801039f7:	85 f6                	test   %esi,%esi
801039f9:	7e 2a                	jle    80103a25 <mycpu+0x45>
801039fb:	31 d2                	xor    %edx,%edx
801039fd:	eb 08                	jmp    80103a07 <mycpu+0x27>
801039ff:	90                   	nop
80103a00:	83 c2 01             	add    $0x1,%edx
80103a03:	39 f2                	cmp    %esi,%edx
80103a05:	74 1e                	je     80103a25 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a07:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a0d:	0f b6 99 e0 38 11 80 	movzbl -0x7feec720(%ecx),%ebx
80103a14:	39 c3                	cmp    %eax,%ebx
80103a16:	75 e8                	jne    80103a00 <mycpu+0x20>
}
80103a18:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a1b:	8d 81 e0 38 11 80    	lea    -0x7feec720(%ecx),%eax
}
80103a21:	5b                   	pop    %ebx
80103a22:	5e                   	pop    %esi
80103a23:	5d                   	pop    %ebp
80103a24:	c3                   	ret    
  panic("unknown apicid\n");
80103a25:	83 ec 0c             	sub    $0xc,%esp
80103a28:	68 4d 89 10 80       	push   $0x8010894d
80103a2d:	e8 4e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a32:	83 ec 0c             	sub    $0xc,%esp
80103a35:	68 48 8b 10 80       	push   $0x80108b48
80103a3a:	e8 41 c9 ff ff       	call   80100380 <panic>
80103a3f:	90                   	nop

80103a40 <cpuid>:
cpuid() {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a46:	e8 95 ff ff ff       	call   801039e0 <mycpu>
}
80103a4b:	c9                   	leave  
  return mycpu()-cpus;
80103a4c:	2d e0 38 11 80       	sub    $0x801138e0,%eax
80103a51:	c1 f8 04             	sar    $0x4,%eax
80103a54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a5a:	c3                   	ret    
80103a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a5f:	90                   	nop

80103a60 <myproc>:
myproc(void) {
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a67:	e8 84 19 00 00       	call   801053f0 <pushcli>
  c = mycpu();
80103a6c:	e8 6f ff ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103a71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a77:	e8 c4 19 00 00       	call   80105440 <popcli>
}
80103a7c:	89 d8                	mov    %ebx,%eax
80103a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a81:	c9                   	leave  
80103a82:	c3                   	ret    
80103a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a90 <userinit>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a97:	e8 14 fd ff ff       	call   801037b0 <allocproc>
80103a9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a9e:	a3 18 86 11 80       	mov    %eax,0x80118618
  if((p->pgdir = setupkvm()) == 0)
80103aa3:	e8 f8 45 00 00       	call   801080a0 <setupkvm>
80103aa8:	89 43 04             	mov    %eax,0x4(%ebx)
80103aab:	85 c0                	test   %eax,%eax
80103aad:	0f 84 db 00 00 00    	je     80103b8e <userinit+0xfe>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ab3:	83 ec 04             	sub    $0x4,%esp
80103ab6:	68 2c 00 00 00       	push   $0x2c
80103abb:	68 60 c4 10 80       	push   $0x8010c460
80103ac0:	50                   	push   %eax
80103ac1:	e8 8a 42 00 00       	call   80107d50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ac6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ac9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103acf:	6a 4c                	push   $0x4c
80103ad1:	6a 00                	push   $0x0
80103ad3:	ff 73 18             	push   0x18(%ebx)
80103ad6:	e8 c5 1b 00 00       	call   801056a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103adb:	8b 43 18             	mov    0x18(%ebx),%eax
80103ade:	ba 1b 00 00 00       	mov    $0x1b,%edx
80103ae3:	83 c4 10             	add    $0x10,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ae6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aeb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aef:	8b 43 18             	mov    0x18(%ebx),%eax
80103af2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103af6:	8b 43 18             	mov    0x18(%ebx),%eax
80103af9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103afd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b01:	8b 43 18             	mov    0x18(%ebx),%eax
80103b04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b0f:	8d 93 e0 00 00 00    	lea    0xe0(%ebx),%edx
80103b15:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b1f:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b26:	8b 43 18             	mov    0x18(%ebx),%eax
80103b29:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  for(int k=0; k < 25; k++)
80103b30:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103b33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b37:	90                   	nop
  	p->syscnt[k] = 0;
80103b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int k=0; k < 25; k++)
80103b3e:	83 c0 04             	add    $0x4,%eax
80103b41:	39 c2                	cmp    %eax,%edx
80103b43:	75 f3                	jne    80103b38 <userinit+0xa8>
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b45:	83 ec 04             	sub    $0x4,%esp
80103b48:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b4b:	6a 10                	push   $0x10
80103b4d:	68 76 89 10 80       	push   $0x80108976
80103b52:	50                   	push   %eax
80103b53:	e8 08 1d 00 00       	call   80105860 <safestrcpy>
  p->cwd = namei("/");
80103b58:	c7 04 24 7f 89 10 80 	movl   $0x8010897f,(%esp)
80103b5f:	e8 3c e5 ff ff       	call   801020a0 <namei>
80103b64:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b67:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
80103b6e:	e8 dd 19 00 00       	call   80105550 <acquire>
  p->state = RUNNABLE;
80103b73:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b7a:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
80103b81:	e8 5a 19 00 00       	call   801054e0 <release>
}
80103b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b89:	83 c4 10             	add    $0x10,%esp
80103b8c:	c9                   	leave  
80103b8d:	c3                   	ret    
    panic("userinit: out of memory?");
80103b8e:	83 ec 0c             	sub    $0xc,%esp
80103b91:	68 5d 89 10 80       	push   $0x8010895d
80103b96:	e8 e5 c7 ff ff       	call   80100380 <panic>
80103b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop

80103ba0 <growproc>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
80103ba5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ba8:	e8 43 18 00 00       	call   801053f0 <pushcli>
  c = mycpu();
80103bad:	e8 2e fe ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103bb2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bb8:	e8 83 18 00 00       	call   80105440 <popcli>
  sz = curproc->sz;
80103bbd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bbf:	85 f6                	test   %esi,%esi
80103bc1:	7f 1d                	jg     80103be0 <growproc+0x40>
  } else if(n < 0){
80103bc3:	75 3b                	jne    80103c00 <growproc+0x60>
  switchuvm(curproc);
80103bc5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bc8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bca:	53                   	push   %ebx
80103bcb:	e8 70 40 00 00       	call   80107c40 <switchuvm>
  return 0;
80103bd0:	83 c4 10             	add    $0x10,%esp
80103bd3:	31 c0                	xor    %eax,%eax
}
80103bd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bd8:	5b                   	pop    %ebx
80103bd9:	5e                   	pop    %esi
80103bda:	5d                   	pop    %ebp
80103bdb:	c3                   	ret    
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103be0:	83 ec 04             	sub    $0x4,%esp
80103be3:	01 c6                	add    %eax,%esi
80103be5:	56                   	push   %esi
80103be6:	50                   	push   %eax
80103be7:	ff 73 04             	push   0x4(%ebx)
80103bea:	e8 d1 42 00 00       	call   80107ec0 <allocuvm>
80103bef:	83 c4 10             	add    $0x10,%esp
80103bf2:	85 c0                	test   %eax,%eax
80103bf4:	75 cf                	jne    80103bc5 <growproc+0x25>
      return -1;
80103bf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bfb:	eb d8                	jmp    80103bd5 <growproc+0x35>
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c00:	83 ec 04             	sub    $0x4,%esp
80103c03:	01 c6                	add    %eax,%esi
80103c05:	56                   	push   %esi
80103c06:	50                   	push   %eax
80103c07:	ff 73 04             	push   0x4(%ebx)
80103c0a:	e8 e1 43 00 00       	call   80107ff0 <deallocuvm>
80103c0f:	83 c4 10             	add    $0x10,%esp
80103c12:	85 c0                	test   %eax,%eax
80103c14:	75 af                	jne    80103bc5 <growproc+0x25>
80103c16:	eb de                	jmp    80103bf6 <growproc+0x56>
80103c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c1f:	90                   	nop

80103c20 <fork>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c29:	e8 c2 17 00 00       	call   801053f0 <pushcli>
  c = mycpu();
80103c2e:	e8 ad fd ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103c33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c39:	e8 02 18 00 00       	call   80105440 <popcli>
  if((np = allocproc()) == 0){
80103c3e:	e8 6d fb ff ff       	call   801037b0 <allocproc>
80103c43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c46:	85 c0                	test   %eax,%eax
80103c48:	0f 84 b7 00 00 00    	je     80103d05 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c4e:	83 ec 08             	sub    $0x8,%esp
80103c51:	ff 33                	push   (%ebx)
80103c53:	89 c7                	mov    %eax,%edi
80103c55:	ff 73 04             	push   0x4(%ebx)
80103c58:	e8 33 45 00 00       	call   80108190 <copyuvm>
80103c5d:	83 c4 10             	add    $0x10,%esp
80103c60:	89 47 04             	mov    %eax,0x4(%edi)
80103c63:	85 c0                	test   %eax,%eax
80103c65:	0f 84 a1 00 00 00    	je     80103d0c <fork+0xec>
  np->sz = curproc->sz;
80103c6b:	8b 03                	mov    (%ebx),%eax
80103c6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c75:	89 c8                	mov    %ecx,%eax
80103c77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c86:	8b 40 18             	mov    0x18(%eax),%eax
80103c89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c94:	85 c0                	test   %eax,%eax
80103c96:	74 13                	je     80103cab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c98:	83 ec 0c             	sub    $0xc,%esp
80103c9b:	50                   	push   %eax
80103c9c:	e8 ff d1 ff ff       	call   80100ea0 <filedup>
80103ca1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ca4:	83 c4 10             	add    $0x10,%esp
80103ca7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cab:	83 c6 01             	add    $0x1,%esi
80103cae:	83 fe 10             	cmp    $0x10,%esi
80103cb1:	75 dd                	jne    80103c90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103cb3:	83 ec 0c             	sub    $0xc,%esp
80103cb6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cbc:	e8 8f da ff ff       	call   80101750 <idup>
80103cc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ccd:	6a 10                	push   $0x10
80103ccf:	53                   	push   %ebx
80103cd0:	50                   	push   %eax
80103cd1:	e8 8a 1b 00 00       	call   80105860 <safestrcpy>
  pid = np->pid;
80103cd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103cd9:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
80103ce0:	e8 6b 18 00 00       	call   80105550 <acquire>
  np->state = RUNNABLE;
80103ce5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103cec:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
80103cf3:	e8 e8 17 00 00       	call   801054e0 <release>
  return pid;
80103cf8:	83 c4 10             	add    $0x10,%esp
}
80103cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cfe:	89 d8                	mov    %ebx,%eax
80103d00:	5b                   	pop    %ebx
80103d01:	5e                   	pop    %esi
80103d02:	5f                   	pop    %edi
80103d03:	5d                   	pop    %ebp
80103d04:	c3                   	ret    
    return -1;
80103d05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d0a:	eb ef                	jmp    80103cfb <fork+0xdb>
    kfree(np->kstack);
80103d0c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d0f:	83 ec 0c             	sub    $0xc,%esp
80103d12:	ff 73 08             	push   0x8(%ebx)
80103d15:	e8 a6 e7 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103d1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d21:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d24:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d30:	eb c9                	jmp    80103cfb <fork+0xdb>
80103d32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d40 <round>:
int round(float num){
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	83 ec 08             	sub    $0x8,%esp
  if(num - (int)(num) <= 0.5)
80103d46:	d9 7d fe             	fnstcw -0x2(%ebp)
int round(float num){
80103d49:	d9 45 08             	flds   0x8(%ebp)
  if(num - (int)(num) <= 0.5)
80103d4c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
80103d50:	80 cc 0c             	or     $0xc,%ah
80103d53:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103d57:	d9 6d fc             	fldcw  -0x4(%ebp)
80103d5a:	db 55 f8             	fistl  -0x8(%ebp)
80103d5d:	d9 6d fe             	fldcw  -0x2(%ebp)
80103d60:	db 45 f8             	fildl  -0x8(%ebp)
80103d63:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103d66:	de e9                	fsubrp %st,%st(1)
80103d68:	d9 05 6c 8c 10 80    	flds   0x80108c6c
}
80103d6e:	c9                   	leave  
  return (int)(num) + 1;
80103d6f:	df e9                	fucomip %st(1),%st
80103d71:	dd d8                	fstp   %st(0)
80103d73:	83 d0 00             	adc    $0x0,%eax
}
80103d76:	c3                   	ret    
80103d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7e:	66 90                	xchg   %ax,%ax

80103d80 <get_state_string>:
{
80103d80:	55                   	push   %ebp
80103d81:	b8 bf 8a 10 80       	mov    $0x80108abf,%eax
80103d86:	89 e5                	mov    %esp,%ebp
80103d88:	8b 55 08             	mov    0x8(%ebp),%edx
80103d8b:	83 fa 05             	cmp    $0x5,%edx
80103d8e:	77 07                	ja     80103d97 <get_state_string+0x17>
80103d90:	8b 04 95 3c 8c 10 80 	mov    -0x7fef73c4(,%edx,4),%eax
}
80103d97:	5d                   	pop    %ebp
80103d98:	c3                   	ret    
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <get_queue_string>:
{
80103da0:	55                   	push   %ebp
80103da1:	b8 81 89 10 80       	mov    $0x80108981,%eax
80103da6:	89 e5                	mov    %esp,%ebp
80103da8:	8b 55 08             	mov    0x8(%ebp),%edx
  if (queue == 1)
80103dab:	83 fa 01             	cmp    $0x1,%edx
80103dae:	74 10                	je     80103dc0 <get_queue_string+0x20>
    return "BJF";
80103db0:	83 fa 02             	cmp    $0x2,%edx
80103db3:	b8 84 89 10 80       	mov    $0x80108984,%eax
80103db8:	ba 89 89 10 80       	mov    $0x80108989,%edx
80103dbd:	0f 45 c2             	cmovne %edx,%eax
}
80103dc0:	5d                   	pop    %ebp
80103dc1:	c3                   	ret    
80103dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dd0 <get_rank>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	83 ec 10             	sub    $0x10,%esp
80103dd6:	8b 45 08             	mov    0x8(%ebp),%eax
             + p->exec_cycle * p->exec_cycle_ratio;
80103dd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int rank = p->priority * p->priority_ratio
80103de0:	8b 90 e8 00 00 00    	mov    0xe8(%eax),%edx
             + p->creation_time * p->arrival_time_ratio
80103de6:	8b 88 e4 00 00 00    	mov    0xe4(%eax),%ecx
  int rank = p->priority * p->priority_ratio
80103dec:	0f af 90 ec 00 00 00 	imul   0xec(%eax),%edx
             + p->creation_time * p->arrival_time_ratio
80103df3:	0f af 88 f0 00 00 00 	imul   0xf0(%eax),%ecx
80103dfa:	01 ca                	add    %ecx,%edx
             + p->exec_cycle * p->exec_cycle_ratio;
80103dfc:	89 55 f0             	mov    %edx,-0x10(%ebp)
80103dff:	df 6d f0             	fildll -0x10(%ebp)
80103e02:	db 80 f8 00 00 00    	fildl  0xf8(%eax)
80103e08:	d8 88 f4 00 00 00    	fmuls  0xf4(%eax)
  int rank = p->priority * p->priority_ratio
80103e0e:	d9 7d fe             	fnstcw -0x2(%ebp)
80103e11:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
             + p->exec_cycle * p->exec_cycle_ratio;
80103e15:	de c1                	faddp  %st,%st(1)
  int rank = p->priority * p->priority_ratio
80103e17:	80 cc 0c             	or     $0xc,%ah
80103e1a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103e1e:	d9 6d fc             	fldcw  -0x4(%ebp)
80103e21:	db 5d f0             	fistpl -0x10(%ebp)
80103e24:	d9 6d fe             	fldcw  -0x2(%ebp)
80103e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e2a:	c9                   	leave  
80103e2b:	c3                   	ret    
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e30 <print_procs>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
    for(int i=0; i<15-strlen(p->name); i++)
80103e34:	bf 0f 00 00 00       	mov    $0xf,%edi
{
80103e39:	56                   	push   %esi
80103e3a:	53                   	push   %ebx
80103e3b:	bb 84 45 11 80       	mov    $0x80114584,%ebx
80103e40:	83 ec 28             	sub    $0x28,%esp
  cprintf("name          pid          state          queue_lvl      exec_cycle*10     arrival_time      rank           priority    ratios(priority,arrival_time,exec_cycle)");
80103e43:	68 70 8b 10 80       	push   $0x80108b70
80103e48:	e8 53 c8 ff ff       	call   801006a0 <cprintf>
  cprintf("\n");
80103e4d:	c7 04 24 be 8a 10 80 	movl   $0x80108abe,(%esp)
80103e54:	e8 47 c8 ff ff       	call   801006a0 <cprintf>
  acquire(&ptable.lock);
80103e59:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
80103e60:	e8 eb 16 00 00       	call   80105550 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e65:	83 c4 10             	add    $0x10,%esp
80103e68:	eb 18                	jmp    80103e82 <print_procs+0x52>
80103e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e70:	81 c3 04 01 00 00    	add    $0x104,%ebx
80103e76:	81 fb 84 86 11 80    	cmp    $0x80118684,%ebx
80103e7c:	0f 84 1b 02 00 00    	je     8010409d <print_procs+0x26d>
    if (p->state == UNUSED)
80103e82:	8b 4b a0             	mov    -0x60(%ebx),%ecx
80103e85:	85 c9                	test   %ecx,%ecx
80103e87:	74 e7                	je     80103e70 <print_procs+0x40>
    cprintf(p->name);
80103e89:	83 ec 0c             	sub    $0xc,%esp
    for(int i=0; i<15-strlen(p->name); i++)
80103e8c:	31 f6                	xor    %esi,%esi
    cprintf(p->name);
80103e8e:	53                   	push   %ebx
80103e8f:	e8 0c c8 ff ff       	call   801006a0 <cprintf>
    for(int i=0; i<15-strlen(p->name); i++)
80103e94:	83 c4 10             	add    $0x10,%esp
80103e97:	eb 1a                	jmp    80103eb3 <print_procs+0x83>
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf(" ");
80103ea0:	83 ec 0c             	sub    $0xc,%esp
    for(int i=0; i<15-strlen(p->name); i++)
80103ea3:	83 c6 01             	add    $0x1,%esi
      cprintf(" ");
80103ea6:	68 9c 89 10 80       	push   $0x8010899c
80103eab:	e8 f0 c7 ff ff       	call   801006a0 <cprintf>
    for(int i=0; i<15-strlen(p->name); i++)
80103eb0:	83 c4 10             	add    $0x10,%esp
80103eb3:	83 ec 0c             	sub    $0xc,%esp
80103eb6:	53                   	push   %ebx
80103eb7:	e8 e4 19 00 00       	call   801058a0 <strlen>
80103ebc:	83 c4 10             	add    $0x10,%esp
80103ebf:	89 c2                	mov    %eax,%edx
80103ec1:	89 f8                	mov    %edi,%eax
80103ec3:	29 d0                	sub    %edx,%eax
80103ec5:	39 f0                	cmp    %esi,%eax
80103ec7:	7f d7                	jg     80103ea0 <print_procs+0x70>
    cprintf("%d", p->pid);
80103ec9:	83 ec 08             	sub    $0x8,%esp
80103ecc:	ff 73 a4             	push   -0x5c(%ebx)
80103ecf:	68 43 89 10 80       	push   $0x80108943
80103ed4:	e8 c7 c7 ff ff       	call   801006a0 <cprintf>
    cprintf("           ");
80103ed9:	c7 04 24 92 89 10 80 	movl   $0x80108992,(%esp)
80103ee0:	e8 bb c7 ff ff       	call   801006a0 <cprintf>
    cprintf(get_state_string(p->state));
80103ee5:	8b 53 a0             	mov    -0x60(%ebx),%edx
  if (state == 0) {
80103ee8:	83 c4 10             	add    $0x10,%esp
    cprintf(get_state_string(p->state));
80103eeb:	b8 bf 8a 10 80       	mov    $0x80108abf,%eax
80103ef0:	83 fa 05             	cmp    $0x5,%edx
80103ef3:	77 07                	ja     80103efc <print_procs+0xcc>
80103ef5:	8b 04 95 3c 8c 10 80 	mov    -0x7fef73c4(,%edx,4),%eax
80103efc:	83 ec 0c             	sub    $0xc,%esp
80103eff:	50                   	push   %eax
80103f00:	e8 9b c7 ff ff       	call   801006a0 <cprintf>
    cprintf("           ");
80103f05:	c7 04 24 92 89 10 80 	movl   $0x80108992,(%esp)
80103f0c:	e8 8f c7 ff ff       	call   801006a0 <cprintf>
    cprintf(get_queue_string(p->queue));
80103f11:	8b 53 74             	mov    0x74(%ebx),%edx
  if (queue == 1)
80103f14:	83 c4 10             	add    $0x10,%esp
    return "RR";
80103f17:	b8 81 89 10 80       	mov    $0x80108981,%eax
  if (queue == 1)
80103f1c:	83 fa 01             	cmp    $0x1,%edx
80103f1f:	74 10                	je     80103f31 <print_procs+0x101>
    return "BJF";
80103f21:	83 fa 02             	cmp    $0x2,%edx
80103f24:	b8 84 89 10 80       	mov    $0x80108984,%eax
80103f29:	ba 89 89 10 80       	mov    $0x80108989,%edx
80103f2e:	0f 45 c2             	cmovne %edx,%eax
    cprintf(get_queue_string(p->queue));
80103f31:	83 ec 0c             	sub    $0xc,%esp
80103f34:	50                   	push   %eax
80103f35:	e8 66 c7 ff ff       	call   801006a0 <cprintf>
    cprintf("             ");
80103f3a:	c7 04 24 90 89 10 80 	movl   $0x80108990,(%esp)
80103f41:	e8 5a c7 ff ff       	call   801006a0 <cprintf>
    cprintf("%d", round(p->exec_cycle * 10));
80103f46:	d9 05 70 8c 10 80    	flds   0x80108c70
  if(num - (int)(num) <= 0.5)
80103f4c:	5a                   	pop    %edx
80103f4d:	d9 7d e6             	fnstcw -0x1a(%ebp)
    cprintf("%d", round(p->exec_cycle * 10));
80103f50:	d8 8b 88 00 00 00    	fmuls  0x88(%ebx)
  if(num - (int)(num) <= 0.5)
80103f56:	59                   	pop    %ecx
80103f57:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103f5b:	80 cc 0c             	or     $0xc,%ah
80103f5e:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103f62:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f65:	db 55 d8             	fistl  -0x28(%ebp)
80103f68:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103f6b:	db 45 d8             	fildl  -0x28(%ebp)
80103f6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103f71:	de e9                	fsubrp %st,%st(1)
80103f73:	d9 05 6c 8c 10 80    	flds   0x80108c6c
  return (int)(num) + 1;
80103f79:	df e9                	fucomip %st(1),%st
80103f7b:	dd d8                	fstp   %st(0)
80103f7d:	83 d0 00             	adc    $0x0,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f80:	81 c3 04 01 00 00    	add    $0x104,%ebx
    cprintf("%d", round(p->exec_cycle * 10));
80103f86:	50                   	push   %eax
80103f87:	68 43 89 10 80       	push   $0x80108943
80103f8c:	e8 0f c7 ff ff       	call   801006a0 <cprintf>
    cprintf("                ");
80103f91:	c7 04 24 8d 89 10 80 	movl   $0x8010898d,(%esp)
80103f98:	e8 03 c7 ff ff       	call   801006a0 <cprintf>
    cprintf("%d", p->creation_time);
80103f9d:	5e                   	pop    %esi
80103f9e:	58                   	pop    %eax
80103f9f:	ff b3 74 ff ff ff    	push   -0x8c(%ebx)
80103fa5:	68 43 89 10 80       	push   $0x80108943
80103faa:	e8 f1 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("           ");
80103faf:	c7 04 24 92 89 10 80 	movl   $0x80108992,(%esp)
80103fb6:	e8 e5 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("%d", get_rank(p));
80103fbb:	58                   	pop    %eax
80103fbc:	5a                   	pop    %edx
             + p->exec_cycle * p->exec_cycle_ratio;
80103fbd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  int rank = p->priority * p->priority_ratio
80103fc4:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103fc7:	8b 83 78 ff ff ff    	mov    -0x88(%ebx),%eax
             + p->creation_time * p->arrival_time_ratio
80103fcd:	8b 93 74 ff ff ff    	mov    -0x8c(%ebx),%edx
  int rank = p->priority * p->priority_ratio
80103fd3:	0f af 83 7c ff ff ff 	imul   -0x84(%ebx),%eax
             + p->creation_time * p->arrival_time_ratio
80103fda:	0f af 53 80          	imul   -0x80(%ebx),%edx
80103fde:	01 d0                	add    %edx,%eax
             + p->exec_cycle * p->exec_cycle_ratio;
80103fe0:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103fe3:	df 6d d8             	fildll -0x28(%ebp)
80103fe6:	db 43 88             	fildl  -0x78(%ebx)
80103fe9:	d8 4b 84             	fmuls  -0x7c(%ebx)
  int rank = p->priority * p->priority_ratio
80103fec:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103ff0:	80 cc 0c             	or     $0xc,%ah
             + p->exec_cycle * p->exec_cycle_ratio;
80103ff3:	de c1                	faddp  %st,%st(1)
  int rank = p->priority * p->priority_ratio
80103ff5:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103ff9:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103ffc:	db 5d d8             	fistpl -0x28(%ebp)
80103fff:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104002:	8b 45 d8             	mov    -0x28(%ebp),%eax
    cprintf("%d", get_rank(p));
80104005:	50                   	push   %eax
80104006:	68 43 89 10 80       	push   $0x80108943
8010400b:	e8 90 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("          ");
80104010:	c7 04 24 93 89 10 80 	movl   $0x80108993,(%esp)
80104017:	e8 84 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("%d",p->priority);
8010401c:	59                   	pop    %ecx
8010401d:	5e                   	pop    %esi
8010401e:	ff b3 78 ff ff ff    	push   -0x88(%ebx)
80104024:	68 43 89 10 80       	push   $0x80108943
80104029:	e8 72 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("                ");
8010402e:	c7 04 24 8d 89 10 80 	movl   $0x8010898d,(%esp)
80104035:	e8 66 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("%d", p->arrival_time_ratio);
8010403a:	58                   	pop    %eax
8010403b:	5a                   	pop    %edx
8010403c:	ff 73 80             	push   -0x80(%ebx)
8010403f:	68 43 89 10 80       	push   $0x80108943
80104044:	e8 57 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("-");
80104049:	c7 04 24 9e 89 10 80 	movl   $0x8010899e,(%esp)
80104050:	e8 4b c6 ff ff       	call   801006a0 <cprintf>
    cprintf("%d",p->exec_cycle_ratio);
80104055:	59                   	pop    %ecx
80104056:	5e                   	pop    %esi
80104057:	ff 73 88             	push   -0x78(%ebx)
8010405a:	68 43 89 10 80       	push   $0x80108943
8010405f:	e8 3c c6 ff ff       	call   801006a0 <cprintf>
    cprintf("-");
80104064:	c7 04 24 9e 89 10 80 	movl   $0x8010899e,(%esp)
8010406b:	e8 30 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("%d",p->priority_ratio);
80104070:	58                   	pop    %eax
80104071:	5a                   	pop    %edx
80104072:	ff b3 7c ff ff ff    	push   -0x84(%ebx)
80104078:	68 43 89 10 80       	push   $0x80108943
8010407d:	e8 1e c6 ff ff       	call   801006a0 <cprintf>
    cprintf("\n");
80104082:	c7 04 24 be 8a 10 80 	movl   $0x80108abe,(%esp)
80104089:	e8 12 c6 ff ff       	call   801006a0 <cprintf>
8010408e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104091:	81 fb 84 86 11 80    	cmp    $0x80118684,%ebx
80104097:	0f 85 e5 fd ff ff    	jne    80103e82 <print_procs+0x52>
  release(&ptable.lock);
8010409d:	83 ec 0c             	sub    $0xc,%esp
801040a0:	68 e0 44 11 80       	push   $0x801144e0
801040a5:	e8 36 14 00 00       	call   801054e0 <release>
}
801040aa:	83 c4 10             	add    $0x10,%esp
801040ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b0:	5b                   	pop    %ebx
801040b1:	5e                   	pop    %esi
801040b2:	5f                   	pop    %edi
801040b3:	5d                   	pop    %ebp
801040b4:	c3                   	ret    
801040b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040c0 <find_RR>:
{
801040c0:	55                   	push   %ebp
  int max_proc = -100000;
801040c1:	b9 60 79 fe ff       	mov    $0xfffe7960,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c6:	b8 18 45 11 80       	mov    $0x80114518,%eax
{
801040cb:	89 e5                	mov    %esp,%ebp
801040cd:	56                   	push   %esi
  struct proc *best = 0;
801040ce:	31 f6                	xor    %esi,%esi
{
801040d0:	53                   	push   %ebx
  int now = ticks;
801040d1:	8b 1d 20 86 11 80    	mov    0x80118620,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040de:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE || p->queue != 1)
801040e0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801040e4:	75 1a                	jne    80104100 <find_RR+0x40>
801040e6:	83 b8 e0 00 00 00 01 	cmpl   $0x1,0xe0(%eax)
801040ed:	75 11                	jne    80104100 <find_RR+0x40>
      if(now - p->last_cpu_time > max_proc){
801040ef:	89 da                	mov    %ebx,%edx
801040f1:	2b 90 fc 00 00 00    	sub    0xfc(%eax),%edx
801040f7:	39 ca                	cmp    %ecx,%edx
801040f9:	7e 05                	jle    80104100 <find_RR+0x40>
801040fb:	89 d1                	mov    %edx,%ecx
801040fd:	89 c6                	mov    %eax,%esi
801040ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104100:	05 04 01 00 00       	add    $0x104,%eax
80104105:	3d 18 86 11 80       	cmp    $0x80118618,%eax
8010410a:	75 d4                	jne    801040e0 <find_RR+0x20>
}
8010410c:	89 f0                	mov    %esi,%eax
8010410e:	5b                   	pop    %ebx
8010410f:	5e                   	pop    %esi
80104110:	5d                   	pop    %ebp
80104111:	c3                   	ret    
80104112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <find_FCFS>:
{
80104120:	55                   	push   %ebp
  int first = 2e9;
80104121:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104126:	b8 18 45 11 80       	mov    $0x80114518,%eax
{
8010412b:	89 e5                	mov    %esp,%ebp
8010412d:	53                   	push   %ebx
  struct proc *first_proc = 0;
8010412e:	31 db                	xor    %ebx,%ebx
      if (p->state != RUNNABLE || p->queue != 2)
80104130:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104134:	75 1a                	jne    80104150 <find_FCFS+0x30>
80104136:	83 b8 e0 00 00 00 02 	cmpl   $0x2,0xe0(%eax)
8010413d:	75 11                	jne    80104150 <find_FCFS+0x30>
      if (p->creation_time < first)
8010413f:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
80104145:	39 ca                	cmp    %ecx,%edx
80104147:	73 07                	jae    80104150 <find_FCFS+0x30>
        first = p->creation_time;
80104149:	89 d1                	mov    %edx,%ecx
8010414b:	89 c3                	mov    %eax,%ebx
8010414d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104150:	05 04 01 00 00       	add    $0x104,%eax
80104155:	3d 18 86 11 80       	cmp    $0x80118618,%eax
8010415a:	75 d4                	jne    80104130 <find_FCFS+0x10>
}
8010415c:	89 d8                	mov    %ebx,%eax
8010415e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104161:	c9                   	leave  
80104162:	c3                   	ret    
80104163:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104170 <find_BJF>:
{
80104170:	55                   	push   %ebp
  int min_rank = 1000000;
80104171:	b9 40 42 0f 00       	mov    $0xf4240,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104176:	b8 18 45 11 80       	mov    $0x80114518,%eax
{
8010417b:	89 e5                	mov    %esp,%ebp
8010417d:	56                   	push   %esi
8010417e:	53                   	push   %ebx
  struct proc* min_proc = 0;
8010417f:	31 db                	xor    %ebx,%ebx
{
80104181:	83 ec 10             	sub    $0x10,%esp
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->queue != 3)
80104188:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010418c:	75 62                	jne    801041f0 <find_BJF+0x80>
8010418e:	83 b8 e0 00 00 00 03 	cmpl   $0x3,0xe0(%eax)
80104195:	75 59                	jne    801041f0 <find_BJF+0x80>
  int rank = p->priority * p->priority_ratio
80104197:	8b 90 e8 00 00 00    	mov    0xe8(%eax),%edx
             + p->creation_time * p->arrival_time_ratio
8010419d:	8b b0 e4 00 00 00    	mov    0xe4(%eax),%esi
             + p->exec_cycle * p->exec_cycle_ratio;
801041a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int rank = p->priority * p->priority_ratio
801041aa:	0f af 90 ec 00 00 00 	imul   0xec(%eax),%edx
             + p->creation_time * p->arrival_time_ratio
801041b1:	0f af b0 f0 00 00 00 	imul   0xf0(%eax),%esi
801041b8:	01 f2                	add    %esi,%edx
             + p->exec_cycle * p->exec_cycle_ratio;
801041ba:	89 55 e8             	mov    %edx,-0x18(%ebp)
801041bd:	df 6d e8             	fildll -0x18(%ebp)
801041c0:	db 80 f8 00 00 00    	fildl  0xf8(%eax)
801041c6:	d8 88 f4 00 00 00    	fmuls  0xf4(%eax)
  int rank = p->priority * p->priority_ratio
801041cc:	d9 7d f6             	fnstcw -0xa(%ebp)
801041cf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
             + p->exec_cycle * p->exec_cycle_ratio;
801041d3:	de c1                	faddp  %st,%st(1)
  int rank = p->priority * p->priority_ratio
801041d5:	80 ce 0c             	or     $0xc,%dh
801041d8:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
801041dc:	d9 6d f4             	fldcw  -0xc(%ebp)
801041df:	db 5d e8             	fistpl -0x18(%ebp)
801041e2:	d9 6d f6             	fldcw  -0xa(%ebp)
801041e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    if (get_rank(p) < min_rank){
801041e8:	39 ca                	cmp    %ecx,%edx
801041ea:	7d 04                	jge    801041f0 <find_BJF+0x80>
801041ec:	89 d1                	mov    %edx,%ecx
801041ee:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801041f0:	05 04 01 00 00       	add    $0x104,%eax
801041f5:	3d 18 86 11 80       	cmp    $0x80118618,%eax
801041fa:	75 8c                	jne    80104188 <find_BJF+0x18>
}
801041fc:	83 c4 10             	add    $0x10,%esp
801041ff:	89 d8                	mov    %ebx,%eax
80104201:	5b                   	pop    %ebx
80104202:	5e                   	pop    %esi
80104203:	5d                   	pop    %ebp
80104204:	c3                   	ret    
80104205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104210 <move_queues>:
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104210:	b8 18 45 11 80       	mov    $0x80114518,%eax
80104215:	eb 15                	jmp    8010422c <move_queues+0x1c>
80104217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421e:	66 90                	xchg   %ax,%ax
80104220:	05 04 01 00 00       	add    $0x104,%eax
80104225:	3d 18 86 11 80       	cmp    $0x80118618,%eax
8010422a:	74 3b                	je     80104267 <move_queues+0x57>
    if (p->state == RUNNABLE && p->age > 8000){
8010422c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104230:	75 ee                	jne    80104220 <move_queues+0x10>
80104232:	81 b8 00 01 00 00 40 	cmpl   $0x1f40,0x100(%eax)
80104239:	1f 00 00 
8010423c:	7e e2                	jle    80104220 <move_queues+0x10>
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
8010423e:	8b 90 e0 00 00 00    	mov    0xe0(%eax),%edx
80104244:	31 c9                	xor    %ecx,%ecx
      p->age = 0;
80104246:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
8010424d:	00 00 00 
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
80104250:	83 fa 01             	cmp    $0x1,%edx
80104253:	0f 95 c1             	setne  %cl
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104256:	05 04 01 00 00       	add    $0x104,%eax
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
8010425b:	29 ca                	sub    %ecx,%edx
8010425d:	89 50 dc             	mov    %edx,-0x24(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104260:	3d 18 86 11 80       	cmp    $0x80118618,%eax
80104265:	75 c5                	jne    8010422c <move_queues+0x1c>
}
80104267:	c3                   	ret    
80104268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426f:	90                   	nop

80104270 <update_age>:
{
80104270:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104271:	b8 18 45 11 80       	mov    $0x80114518,%eax
{
80104276:	89 e5                	mov    %esp,%ebp
80104278:	8b 55 0c             	mov    0xc(%ebp),%edx
8010427b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010427f:	90                   	nop
    if (p->state == RUNNABLE){
80104280:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104284:	75 06                	jne    8010428c <update_age+0x1c>
      p->age += cycles;
80104286:	01 90 00 01 00 00    	add    %edx,0x100(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
8010428c:	05 04 01 00 00       	add    $0x104,%eax
80104291:	3d 18 86 11 80       	cmp    $0x80118618,%eax
80104296:	75 e8                	jne    80104280 <update_age+0x10>
  p_exec->age = 0;
80104298:	8b 45 08             	mov    0x8(%ebp),%eax
8010429b:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
801042a2:	00 00 00 
}
801042a5:	5d                   	pop    %ebp
801042a6:	c3                   	ret    
801042a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ae:	66 90                	xchg   %ax,%ax

801042b0 <scheduler>:
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	57                   	push   %edi
801042b4:	56                   	push   %esi
801042b5:	53                   	push   %ebx
801042b6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801042b9:	e8 22 f7 ff ff       	call   801039e0 <mycpu>
  c->proc = 0;
801042be:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042c5:	00 00 00 
  struct cpu *c = mycpu();
801042c8:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801042ca:	8d 40 04             	lea    0x4(%eax),%eax
801042cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
801042d0:	fb                   	sti    
    acquire(&ptable.lock);
801042d1:	83 ec 0c             	sub    $0xc,%esp
  struct proc *best = 0;
801042d4:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
801042d6:	68 e0 44 11 80       	push   $0x801144e0
801042db:	e8 70 12 00 00       	call   80105550 <acquire>
    tick1 = ticks;
801042e0:	8b 35 20 86 11 80    	mov    0x80118620,%esi
  int now = ticks;
801042e6:	83 c4 10             	add    $0x10,%esp
  int max_proc = -100000;
801042e9:	b9 60 79 fe ff       	mov    $0xfffe7960,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ee:	b8 18 45 11 80       	mov    $0x80114518,%eax
801042f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f7:	90                   	nop
      if(p->state != RUNNABLE || p->queue != 1)
801042f8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801042fc:	75 22                	jne    80104320 <scheduler+0x70>
801042fe:	83 b8 e0 00 00 00 01 	cmpl   $0x1,0xe0(%eax)
80104305:	75 19                	jne    80104320 <scheduler+0x70>
      if(now - p->last_cpu_time > max_proc){
80104307:	89 f2                	mov    %esi,%edx
80104309:	2b 90 fc 00 00 00    	sub    0xfc(%eax),%edx
8010430f:	39 ca                	cmp    %ecx,%edx
80104311:	7e 0d                	jle    80104320 <scheduler+0x70>
80104313:	89 d1                	mov    %edx,%ecx
80104315:	89 c7                	mov    %eax,%edi
80104317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104320:	05 04 01 00 00       	add    $0x104,%eax
80104325:	3d 18 86 11 80       	cmp    $0x80118618,%eax
8010432a:	75 cc                	jne    801042f8 <scheduler+0x48>
    if (p == 0)
8010432c:	85 ff                	test   %edi,%edi
8010432e:	0f 84 cd 00 00 00    	je     80104401 <scheduler+0x151>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104334:	b8 18 45 11 80       	mov    $0x80114518,%eax
80104339:	eb 11                	jmp    8010434c <scheduler+0x9c>
8010433b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010433f:	90                   	nop
80104340:	05 04 01 00 00       	add    $0x104,%eax
80104345:	3d 18 86 11 80       	cmp    $0x80118618,%eax
8010434a:	74 3b                	je     80104387 <scheduler+0xd7>
    if (p->state == RUNNABLE && p->age > 8000){
8010434c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104350:	75 ee                	jne    80104340 <scheduler+0x90>
80104352:	81 b8 00 01 00 00 40 	cmpl   $0x1f40,0x100(%eax)
80104359:	1f 00 00 
8010435c:	7e e2                	jle    80104340 <scheduler+0x90>
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
8010435e:	8b 90 e0 00 00 00    	mov    0xe0(%eax),%edx
80104364:	31 c9                	xor    %ecx,%ecx
      p->age = 0;
80104366:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
8010436d:	00 00 00 
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
80104370:	83 fa 01             	cmp    $0x1,%edx
80104373:	0f 95 c1             	setne  %cl
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104376:	05 04 01 00 00       	add    $0x104,%eax
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
8010437b:	29 ca                	sub    %ecx,%edx
8010437d:	89 50 dc             	mov    %edx,-0x24(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104380:	3d 18 86 11 80       	cmp    $0x80118618,%eax
80104385:	75 c5                	jne    8010434c <scheduler+0x9c>
    switchuvm(p);
80104387:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
8010438a:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
    switchuvm(p);
80104390:	57                   	push   %edi
80104391:	e8 aa 38 00 00       	call   80107c40 <switchuvm>
    p->state = RUNNING;
80104396:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
    swtch(&(c->scheduler), p->context);
8010439d:	58                   	pop    %eax
8010439e:	5a                   	pop    %edx
8010439f:	ff 77 1c             	push   0x1c(%edi)
801043a2:	ff 75 e4             	push   -0x1c(%ebp)
801043a5:	e8 11 15 00 00       	call   801058bb <swtch>
    switchkvm();
801043aa:	e8 81 38 00 00       	call   80107c30 <switchkvm>
    update_age(p, tick2-tick1);
801043af:	8b 15 20 86 11 80    	mov    0x80118620,%edx
801043b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801043b8:	b8 18 45 11 80       	mov    $0x80114518,%eax
    update_age(p, tick2-tick1);
801043bd:	29 f2                	sub    %esi,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801043bf:	90                   	nop
    if (p->state == RUNNABLE){
801043c0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043c4:	75 06                	jne    801043cc <scheduler+0x11c>
      p->age += cycles;
801043c6:	01 90 00 01 00 00    	add    %edx,0x100(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801043cc:	05 04 01 00 00       	add    $0x104,%eax
801043d1:	3d 18 86 11 80       	cmp    $0x80118618,%eax
801043d6:	75 e8                	jne    801043c0 <scheduler+0x110>
  p_exec->age = 0;
801043d8:	c7 87 00 01 00 00 00 	movl   $0x0,0x100(%edi)
801043df:	00 00 00 
    c->proc = 0;
801043e2:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801043e9:	00 00 00 
    release(&ptable.lock);
801043ec:	83 ec 0c             	sub    $0xc,%esp
801043ef:	68 e0 44 11 80       	push   $0x801144e0
801043f4:	e8 e7 10 00 00       	call   801054e0 <release>
801043f9:	83 c4 10             	add    $0x10,%esp
801043fc:	e9 cf fe ff ff       	jmp    801042d0 <scheduler+0x20>
  int first = 2e9;
80104401:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104406:	b8 18 45 11 80       	mov    $0x80114518,%eax
8010440b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010440f:	90                   	nop
      if (p->state != RUNNABLE || p->queue != 2)
80104410:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104414:	75 1a                	jne    80104430 <scheduler+0x180>
80104416:	83 b8 e0 00 00 00 02 	cmpl   $0x2,0xe0(%eax)
8010441d:	75 11                	jne    80104430 <scheduler+0x180>
      if (p->creation_time < first)
8010441f:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
80104425:	39 ca                	cmp    %ecx,%edx
80104427:	73 07                	jae    80104430 <scheduler+0x180>
        first = p->creation_time;
80104429:	89 d1                	mov    %edx,%ecx
8010442b:	89 c7                	mov    %eax,%edi
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104430:	05 04 01 00 00       	add    $0x104,%eax
80104435:	3d 18 86 11 80       	cmp    $0x80118618,%eax
8010443a:	75 d4                	jne    80104410 <scheduler+0x160>
    if (p == 0)
8010443c:	85 ff                	test   %edi,%edi
8010443e:	0f 85 f0 fe ff ff    	jne    80104334 <scheduler+0x84>
      p = find_BJF();
80104444:	e8 27 fd ff ff       	call   80104170 <find_BJF>
80104449:	89 c7                	mov    %eax,%edi
    if (p == 0) {
8010444b:	85 c0                	test   %eax,%eax
8010444d:	74 9d                	je     801043ec <scheduler+0x13c>
8010444f:	e9 e0 fe ff ff       	jmp    80104334 <scheduler+0x84>
80104454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010445f:	90                   	nop

80104460 <sched>:
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
  pushcli();
80104465:	e8 86 0f 00 00       	call   801053f0 <pushcli>
  c = mycpu();
8010446a:	e8 71 f5 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
8010446f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104475:	e8 c6 0f 00 00       	call   80105440 <popcli>
  if(!holding(&ptable.lock))
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	68 e0 44 11 80       	push   $0x801144e0
80104482:	e8 19 10 00 00       	call   801054a0 <holding>
80104487:	83 c4 10             	add    $0x10,%esp
8010448a:	85 c0                	test   %eax,%eax
8010448c:	74 4f                	je     801044dd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010448e:	e8 4d f5 ff ff       	call   801039e0 <mycpu>
80104493:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010449a:	75 68                	jne    80104504 <sched+0xa4>
  if(p->state == RUNNING)
8010449c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801044a0:	74 55                	je     801044f7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044a2:	9c                   	pushf  
801044a3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044a4:	f6 c4 02             	test   $0x2,%ah
801044a7:	75 41                	jne    801044ea <sched+0x8a>
  intena = mycpu()->intena;
801044a9:	e8 32 f5 ff ff       	call   801039e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801044ae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801044b1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801044b7:	e8 24 f5 ff ff       	call   801039e0 <mycpu>
801044bc:	83 ec 08             	sub    $0x8,%esp
801044bf:	ff 70 04             	push   0x4(%eax)
801044c2:	53                   	push   %ebx
801044c3:	e8 f3 13 00 00       	call   801058bb <swtch>
  mycpu()->intena = intena;
801044c8:	e8 13 f5 ff ff       	call   801039e0 <mycpu>
}
801044cd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801044d0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801044d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044d9:	5b                   	pop    %ebx
801044da:	5e                   	pop    %esi
801044db:	5d                   	pop    %ebp
801044dc:	c3                   	ret    
    panic("sched ptable.lock");
801044dd:	83 ec 0c             	sub    $0xc,%esp
801044e0:	68 a0 89 10 80       	push   $0x801089a0
801044e5:	e8 96 be ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801044ea:	83 ec 0c             	sub    $0xc,%esp
801044ed:	68 cc 89 10 80       	push   $0x801089cc
801044f2:	e8 89 be ff ff       	call   80100380 <panic>
    panic("sched running");
801044f7:	83 ec 0c             	sub    $0xc,%esp
801044fa:	68 be 89 10 80       	push   $0x801089be
801044ff:	e8 7c be ff ff       	call   80100380 <panic>
    panic("sched locks");
80104504:	83 ec 0c             	sub    $0xc,%esp
80104507:	68 b2 89 10 80       	push   $0x801089b2
8010450c:	e8 6f be ff ff       	call   80100380 <panic>
80104511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451f:	90                   	nop

80104520 <exit>:
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	53                   	push   %ebx
80104526:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104529:	e8 32 f5 ff ff       	call   80103a60 <myproc>
  if(curproc == initproc)
8010452e:	39 05 18 86 11 80    	cmp    %eax,0x80118618
80104534:	0f 84 07 01 00 00    	je     80104641 <exit+0x121>
8010453a:	89 c3                	mov    %eax,%ebx
8010453c:	8d 70 28             	lea    0x28(%eax),%esi
8010453f:	8d 78 68             	lea    0x68(%eax),%edi
80104542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104548:	8b 06                	mov    (%esi),%eax
8010454a:	85 c0                	test   %eax,%eax
8010454c:	74 12                	je     80104560 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010454e:	83 ec 0c             	sub    $0xc,%esp
80104551:	50                   	push   %eax
80104552:	e8 99 c9 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104557:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010455d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104560:	83 c6 04             	add    $0x4,%esi
80104563:	39 f7                	cmp    %esi,%edi
80104565:	75 e1                	jne    80104548 <exit+0x28>
  begin_op();
80104567:	e8 f4 e7 ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
8010456c:	83 ec 0c             	sub    $0xc,%esp
8010456f:	ff 73 68             	push   0x68(%ebx)
80104572:	e8 39 d3 ff ff       	call   801018b0 <iput>
  end_op();
80104577:	e8 54 e8 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
8010457c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104583:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
8010458a:	e8 c1 0f 00 00       	call   80105550 <acquire>
  wakeup1(curproc->parent);
8010458f:	8b 53 14             	mov    0x14(%ebx),%edx
80104592:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104595:	b8 18 45 11 80       	mov    $0x80114518,%eax
8010459a:	eb 10                	jmp    801045ac <exit+0x8c>
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045a0:	05 04 01 00 00       	add    $0x104,%eax
801045a5:	3d 18 86 11 80       	cmp    $0x80118618,%eax
801045aa:	74 1e                	je     801045ca <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
801045ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045b0:	75 ee                	jne    801045a0 <exit+0x80>
801045b2:	3b 50 20             	cmp    0x20(%eax),%edx
801045b5:	75 e9                	jne    801045a0 <exit+0x80>
      p->state = RUNNABLE;
801045b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045be:	05 04 01 00 00       	add    $0x104,%eax
801045c3:	3d 18 86 11 80       	cmp    $0x80118618,%eax
801045c8:	75 e2                	jne    801045ac <exit+0x8c>
      p->parent = initproc;
801045ca:	8b 0d 18 86 11 80    	mov    0x80118618,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d0:	ba 18 45 11 80       	mov    $0x80114518,%edx
801045d5:	eb 17                	jmp    801045ee <exit+0xce>
801045d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045de:	66 90                	xchg   %ax,%ax
801045e0:	81 c2 04 01 00 00    	add    $0x104,%edx
801045e6:	81 fa 18 86 11 80    	cmp    $0x80118618,%edx
801045ec:	74 3a                	je     80104628 <exit+0x108>
    if(p->parent == curproc){
801045ee:	39 5a 14             	cmp    %ebx,0x14(%edx)
801045f1:	75 ed                	jne    801045e0 <exit+0xc0>
      if(p->state == ZOMBIE)
801045f3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801045f7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801045fa:	75 e4                	jne    801045e0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045fc:	b8 18 45 11 80       	mov    $0x80114518,%eax
80104601:	eb 11                	jmp    80104614 <exit+0xf4>
80104603:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104607:	90                   	nop
80104608:	05 04 01 00 00       	add    $0x104,%eax
8010460d:	3d 18 86 11 80       	cmp    $0x80118618,%eax
80104612:	74 cc                	je     801045e0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104614:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104618:	75 ee                	jne    80104608 <exit+0xe8>
8010461a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010461d:	75 e9                	jne    80104608 <exit+0xe8>
      p->state = RUNNABLE;
8010461f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104626:	eb e0                	jmp    80104608 <exit+0xe8>
  curproc->state = ZOMBIE;
80104628:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010462f:	e8 2c fe ff ff       	call   80104460 <sched>
  panic("zombie exit");
80104634:	83 ec 0c             	sub    $0xc,%esp
80104637:	68 ed 89 10 80       	push   $0x801089ed
8010463c:	e8 3f bd ff ff       	call   80100380 <panic>
    panic("init exiting");
80104641:	83 ec 0c             	sub    $0xc,%esp
80104644:	68 e0 89 10 80       	push   $0x801089e0
80104649:	e8 32 bd ff ff       	call   80100380 <panic>
8010464e:	66 90                	xchg   %ax,%ax

80104650 <wait>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
  pushcli();
80104655:	e8 96 0d 00 00       	call   801053f0 <pushcli>
  c = mycpu();
8010465a:	e8 81 f3 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
8010465f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104665:	e8 d6 0d 00 00       	call   80105440 <popcli>
  acquire(&ptable.lock);
8010466a:	83 ec 0c             	sub    $0xc,%esp
8010466d:	68 e0 44 11 80       	push   $0x801144e0
80104672:	e8 d9 0e 00 00       	call   80105550 <acquire>
80104677:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010467a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010467c:	bb 18 45 11 80       	mov    $0x80114518,%ebx
80104681:	eb 13                	jmp    80104696 <wait+0x46>
80104683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104687:	90                   	nop
80104688:	81 c3 04 01 00 00    	add    $0x104,%ebx
8010468e:	81 fb 18 86 11 80    	cmp    $0x80118618,%ebx
80104694:	74 1e                	je     801046b4 <wait+0x64>
      if(p->parent != curproc)
80104696:	39 73 14             	cmp    %esi,0x14(%ebx)
80104699:	75 ed                	jne    80104688 <wait+0x38>
      if(p->state == ZOMBIE){
8010469b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010469f:	74 5f                	je     80104700 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a1:	81 c3 04 01 00 00    	add    $0x104,%ebx
      havekids = 1;
801046a7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ac:	81 fb 18 86 11 80    	cmp    $0x80118618,%ebx
801046b2:	75 e2                	jne    80104696 <wait+0x46>
    if(!havekids || curproc->killed){
801046b4:	85 c0                	test   %eax,%eax
801046b6:	0f 84 9a 00 00 00    	je     80104756 <wait+0x106>
801046bc:	8b 46 24             	mov    0x24(%esi),%eax
801046bf:	85 c0                	test   %eax,%eax
801046c1:	0f 85 8f 00 00 00    	jne    80104756 <wait+0x106>
  pushcli();
801046c7:	e8 24 0d 00 00       	call   801053f0 <pushcli>
  c = mycpu();
801046cc:	e8 0f f3 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
801046d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046d7:	e8 64 0d 00 00       	call   80105440 <popcli>
  if(p == 0)
801046dc:	85 db                	test   %ebx,%ebx
801046de:	0f 84 89 00 00 00    	je     8010476d <wait+0x11d>
  p->chan = chan;
801046e4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801046e7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046ee:	e8 6d fd ff ff       	call   80104460 <sched>
  p->chan = 0;
801046f3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801046fa:	e9 7b ff ff ff       	jmp    8010467a <wait+0x2a>
801046ff:	90                   	nop
        kfree(p->kstack);
80104700:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104703:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104706:	ff 73 08             	push   0x8(%ebx)
80104709:	e8 b2 dd ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010470e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104715:	5a                   	pop    %edx
80104716:	ff 73 04             	push   0x4(%ebx)
80104719:	e8 02 39 00 00       	call   80108020 <freevm>
        p->pid = 0;
8010471e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104725:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010472c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104730:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104737:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010473e:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
80104745:	e8 96 0d 00 00       	call   801054e0 <release>
        return pid;
8010474a:	83 c4 10             	add    $0x10,%esp
}
8010474d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104750:	89 f0                	mov    %esi,%eax
80104752:	5b                   	pop    %ebx
80104753:	5e                   	pop    %esi
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
      release(&ptable.lock);
80104756:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104759:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010475e:	68 e0 44 11 80       	push   $0x801144e0
80104763:	e8 78 0d 00 00       	call   801054e0 <release>
      return -1;
80104768:	83 c4 10             	add    $0x10,%esp
8010476b:	eb e0                	jmp    8010474d <wait+0xfd>
    panic("sleep");
8010476d:	83 ec 0c             	sub    $0xc,%esp
80104770:	68 f9 89 10 80       	push   $0x801089f9
80104775:	e8 06 bc ff ff       	call   80100380 <panic>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <yield>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80104785:	83 ec 0c             	sub    $0xc,%esp
80104788:	68 e0 44 11 80       	push   $0x801144e0
8010478d:	e8 be 0d 00 00       	call   80105550 <acquire>
  pushcli();
80104792:	e8 59 0c 00 00       	call   801053f0 <pushcli>
  c = mycpu();
80104797:	e8 44 f2 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
8010479c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047a2:	e8 99 0c 00 00       	call   80105440 <popcli>
  myproc()->last_cpu_time = ticks;
801047a7:	8b 35 20 86 11 80    	mov    0x80118620,%esi
  myproc()->state = RUNNABLE;
801047ad:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
801047b4:	e8 37 0c 00 00       	call   801053f0 <pushcli>
  c = mycpu();
801047b9:	e8 22 f2 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
801047be:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047c4:	e8 77 0c 00 00       	call   80105440 <popcli>
  myproc()->last_cpu_time = ticks;
801047c9:	89 b3 fc 00 00 00    	mov    %esi,0xfc(%ebx)
  pushcli();
801047cf:	e8 1c 0c 00 00       	call   801053f0 <pushcli>
  c = mycpu();
801047d4:	e8 07 f2 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
801047d9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047df:	e8 5c 0c 00 00       	call   80105440 <popcli>
  myproc()->exec_cycle += 0.1;
801047e4:	dd 05 78 8c 10 80    	fldl   0x80108c78
801047ea:	d8 83 f4 00 00 00    	fadds  0xf4(%ebx)
801047f0:	d9 9b f4 00 00 00    	fstps  0xf4(%ebx)
  sched();
801047f6:	e8 65 fc ff ff       	call   80104460 <sched>
  release(&ptable.lock);
801047fb:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
80104802:	e8 d9 0c 00 00       	call   801054e0 <release>
}
80104807:	83 c4 10             	add    $0x10,%esp
8010480a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010480d:	5b                   	pop    %ebx
8010480e:	5e                   	pop    %esi
8010480f:	5d                   	pop    %ebp
80104810:	c3                   	ret    
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop

80104820 <sleep>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	83 ec 0c             	sub    $0xc,%esp
80104829:	8b 7d 08             	mov    0x8(%ebp),%edi
8010482c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010482f:	e8 bc 0b 00 00       	call   801053f0 <pushcli>
  c = mycpu();
80104834:	e8 a7 f1 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80104839:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010483f:	e8 fc 0b 00 00       	call   80105440 <popcli>
  if(p == 0)
80104844:	85 db                	test   %ebx,%ebx
80104846:	0f 84 87 00 00 00    	je     801048d3 <sleep+0xb3>
  if(lk == 0)
8010484c:	85 f6                	test   %esi,%esi
8010484e:	74 76                	je     801048c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104850:	81 fe e0 44 11 80    	cmp    $0x801144e0,%esi
80104856:	74 50                	je     801048a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	68 e0 44 11 80       	push   $0x801144e0
80104860:	e8 eb 0c 00 00       	call   80105550 <acquire>
    release(lk);
80104865:	89 34 24             	mov    %esi,(%esp)
80104868:	e8 73 0c 00 00       	call   801054e0 <release>
  p->chan = chan;
8010486d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104870:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104877:	e8 e4 fb ff ff       	call   80104460 <sched>
  p->chan = 0;
8010487c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104883:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
8010488a:	e8 51 0c 00 00       	call   801054e0 <release>
    acquire(lk);
8010488f:	89 75 08             	mov    %esi,0x8(%ebp)
80104892:	83 c4 10             	add    $0x10,%esp
}
80104895:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104898:	5b                   	pop    %ebx
80104899:	5e                   	pop    %esi
8010489a:	5f                   	pop    %edi
8010489b:	5d                   	pop    %ebp
    acquire(lk);
8010489c:	e9 af 0c 00 00       	jmp    80105550 <acquire>
801048a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801048a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048b2:	e8 a9 fb ff ff       	call   80104460 <sched>
  p->chan = 0;
801048b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801048be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c1:	5b                   	pop    %ebx
801048c2:	5e                   	pop    %esi
801048c3:	5f                   	pop    %edi
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
    panic("sleep without lk");
801048c6:	83 ec 0c             	sub    $0xc,%esp
801048c9:	68 ff 89 10 80       	push   $0x801089ff
801048ce:	e8 ad ba ff ff       	call   80100380 <panic>
    panic("sleep");
801048d3:	83 ec 0c             	sub    $0xc,%esp
801048d6:	68 f9 89 10 80       	push   $0x801089f9
801048db:	e8 a0 ba ff ff       	call   80100380 <panic>

801048e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 10             	sub    $0x10,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048ea:	68 e0 44 11 80       	push   $0x801144e0
801048ef:	e8 5c 0c 00 00       	call   80105550 <acquire>
801048f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048f7:	b8 18 45 11 80       	mov    $0x80114518,%eax
801048fc:	eb 0e                	jmp    8010490c <wakeup+0x2c>
801048fe:	66 90                	xchg   %ax,%ax
80104900:	05 04 01 00 00       	add    $0x104,%eax
80104905:	3d 18 86 11 80       	cmp    $0x80118618,%eax
8010490a:	74 1e                	je     8010492a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010490c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104910:	75 ee                	jne    80104900 <wakeup+0x20>
80104912:	3b 58 20             	cmp    0x20(%eax),%ebx
80104915:	75 e9                	jne    80104900 <wakeup+0x20>
      p->state = RUNNABLE;
80104917:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010491e:	05 04 01 00 00       	add    $0x104,%eax
80104923:	3d 18 86 11 80       	cmp    $0x80118618,%eax
80104928:	75 e2                	jne    8010490c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010492a:	c7 45 08 e0 44 11 80 	movl   $0x801144e0,0x8(%ebp)
}
80104931:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104934:	c9                   	leave  
  release(&ptable.lock);
80104935:	e9 a6 0b 00 00       	jmp    801054e0 <release>
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104940 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 10             	sub    $0x10,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010494a:	68 e0 44 11 80       	push   $0x801144e0
8010494f:	e8 fc 0b 00 00       	call   80105550 <acquire>
80104954:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104957:	b8 18 45 11 80       	mov    $0x80114518,%eax
8010495c:	eb 0e                	jmp    8010496c <kill+0x2c>
8010495e:	66 90                	xchg   %ax,%ax
80104960:	05 04 01 00 00       	add    $0x104,%eax
80104965:	3d 18 86 11 80       	cmp    $0x80118618,%eax
8010496a:	74 34                	je     801049a0 <kill+0x60>
    if(p->pid == pid){
8010496c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010496f:	75 ef                	jne    80104960 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104971:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104975:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010497c:	75 07                	jne    80104985 <kill+0x45>
        p->state = RUNNABLE;
8010497e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104985:	83 ec 0c             	sub    $0xc,%esp
80104988:	68 e0 44 11 80       	push   $0x801144e0
8010498d:	e8 4e 0b 00 00       	call   801054e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104995:	83 c4 10             	add    $0x10,%esp
80104998:	31 c0                	xor    %eax,%eax
}
8010499a:	c9                   	leave  
8010499b:	c3                   	ret    
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801049a0:	83 ec 0c             	sub    $0xc,%esp
801049a3:	68 e0 44 11 80       	push   $0x801144e0
801049a8:	e8 33 0b 00 00       	call   801054e0 <release>
}
801049ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801049b0:	83 c4 10             	add    $0x10,%esp
801049b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049b8:	c9                   	leave  
801049b9:	c3                   	ret    
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801049c8:	53                   	push   %ebx
801049c9:	bb 84 45 11 80       	mov    $0x80114584,%ebx
801049ce:	83 ec 3c             	sub    $0x3c,%esp
801049d1:	eb 27                	jmp    801049fa <procdump+0x3a>
801049d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049d7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801049d8:	83 ec 0c             	sub    $0xc,%esp
801049db:	68 be 8a 10 80       	push   $0x80108abe
801049e0:	e8 bb bc ff ff       	call   801006a0 <cprintf>
801049e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049e8:	81 c3 04 01 00 00    	add    $0x104,%ebx
801049ee:	81 fb 84 86 11 80    	cmp    $0x80118684,%ebx
801049f4:	0f 84 7e 00 00 00    	je     80104a78 <procdump+0xb8>
    if(p->state == UNUSED)
801049fa:	8b 43 a0             	mov    -0x60(%ebx),%eax
801049fd:	85 c0                	test   %eax,%eax
801049ff:	74 e7                	je     801049e8 <procdump+0x28>
      state = "???";
80104a01:	ba 10 8a 10 80       	mov    $0x80108a10,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a06:	83 f8 05             	cmp    $0x5,%eax
80104a09:	77 11                	ja     80104a1c <procdump+0x5c>
80104a0b:	8b 14 85 54 8c 10 80 	mov    -0x7fef73ac(,%eax,4),%edx
      state = "???";
80104a12:	b8 10 8a 10 80       	mov    $0x80108a10,%eax
80104a17:	85 d2                	test   %edx,%edx
80104a19:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104a1c:	53                   	push   %ebx
80104a1d:	52                   	push   %edx
80104a1e:	ff 73 a4             	push   -0x5c(%ebx)
80104a21:	68 14 8a 10 80       	push   $0x80108a14
80104a26:	e8 75 bc ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104a2b:	83 c4 10             	add    $0x10,%esp
80104a2e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104a32:	75 a4                	jne    801049d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a34:	83 ec 08             	sub    $0x8,%esp
80104a37:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a3a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a3d:	50                   	push   %eax
80104a3e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a41:	8b 40 0c             	mov    0xc(%eax),%eax
80104a44:	83 c0 08             	add    $0x8,%eax
80104a47:	50                   	push   %eax
80104a48:	e8 43 09 00 00       	call   80105390 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a4d:	83 c4 10             	add    $0x10,%esp
80104a50:	8b 17                	mov    (%edi),%edx
80104a52:	85 d2                	test   %edx,%edx
80104a54:	74 82                	je     801049d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104a56:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104a59:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104a5c:	52                   	push   %edx
80104a5d:	68 41 84 10 80       	push   $0x80108441
80104a62:	e8 39 bc ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a67:	83 c4 10             	add    $0x10,%esp
80104a6a:	39 fe                	cmp    %edi,%esi
80104a6c:	75 e2                	jne    80104a50 <procdump+0x90>
80104a6e:	e9 65 ff ff ff       	jmp    801049d8 <procdump+0x18>
80104a73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a77:	90                   	nop
  }
}
80104a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a7b:	5b                   	pop    %ebx
80104a7c:	5e                   	pop    %esi
80104a7d:	5f                   	pop    %edi
80104a7e:	5d                   	pop    %ebp
80104a7f:	c3                   	ret    

80104a80 <find_next_prime_number>:

int 
find_next_prime_number(int n)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
  int is_prime = 0;
  int temp = 1; 
  while(!is_prime){
80104a84:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8e:	66 90                	xchg   %ax,%ax
      n++;
80104a90:	83 c3 01             	add    $0x1,%ebx
      temp = 1;
      int i;
      for( i=2; i <= n/i; i++){
80104a93:	83 fb 03             	cmp    $0x3,%ebx
80104a96:	7e 20                	jle    80104ab8 <find_next_prime_number+0x38>
          if( n%i == 0 ){
80104a98:	f6 c3 01             	test   $0x1,%bl
80104a9b:	74 f3                	je     80104a90 <find_next_prime_number+0x10>
      for( i=2; i <= n/i; i++){
80104a9d:	b9 02 00 00 00       	mov    $0x2,%ecx
80104aa2:	eb 08                	jmp    80104aac <find_next_prime_number+0x2c>
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if( n%i == 0 ){
80104aa8:	85 d2                	test   %edx,%edx
80104aaa:	74 e4                	je     80104a90 <find_next_prime_number+0x10>
      for( i=2; i <= n/i; i++){
80104aac:	89 d8                	mov    %ebx,%eax
80104aae:	83 c1 01             	add    $0x1,%ecx
80104ab1:	99                   	cltd   
80104ab2:	f7 f9                	idiv   %ecx
80104ab4:	39 c8                	cmp    %ecx,%eax
80104ab6:	7d f0                	jge    80104aa8 <find_next_prime_number+0x28>
          } 
      }
      if(temp) is_prime = 1;
  }
  return n;
}
80104ab8:	89 d8                	mov    %ebx,%eax
80104aba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104abd:	c9                   	leave  
80104abe:	c3                   	ret    
80104abf:	90                   	nop

80104ac0 <get_most_caller>:

int 
get_most_caller(int sys_num)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
  struct proc *p;
  int pid_max = -1;
  int cnt_max = -1;
80104ac4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
{
80104ac9:	56                   	push   %esi
80104aca:	53                   	push   %ebx
80104acb:	bb 84 45 11 80       	mov    $0x80114584,%ebx
80104ad0:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80104ad3:	68 e0 44 11 80       	push   $0x801144e0
80104ad8:	e8 73 0a 00 00       	call   80105550 <acquire>
  cprintf("Kernel: The list of onging processes:\n");
80104add:	c7 04 24 14 8c 10 80 	movl   $0x80108c14,(%esp)
80104ae4:	e8 b7 bb ff ff       	call   801006a0 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    int * sys_cnt = p->syscnt;
    int cnt = *(sys_cnt+sys_num-1);
80104ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  int pid_max = -1;
80104aec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80104af3:	83 c4 10             	add    $0x10,%esp
    int cnt = *(sys_cnt+sys_num-1);
80104af6:	8d 0c 85 fc ff ff ff 	lea    -0x4(,%eax,4),%ecx
80104afd:	eb 1b                	jmp    80104b1a <get_most_caller+0x5a>
80104aff:	90                   	nop
    if(p->pid !=0)
      cprintf("     pid=%d, name: %s \n",p->pid, p->name);
    if(cnt >= cnt_max){
80104b00:	39 fe                	cmp    %edi,%esi
80104b02:	7c 08                	jl     80104b0c <get_most_caller+0x4c>
      cnt_max = cnt;
      pid_max = p->pid;
80104b04:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104b07:	89 f7                	mov    %esi,%edi
80104b09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0c:	81 c3 04 01 00 00    	add    $0x104,%ebx
80104b12:	81 fb 84 86 11 80    	cmp    $0x80118684,%ebx
80104b18:	74 26                	je     80104b40 <get_most_caller+0x80>
    if(p->pid !=0)
80104b1a:	8b 43 a4             	mov    -0x5c(%ebx),%eax
    int cnt = *(sys_cnt+sys_num-1);
80104b1d:	8b 74 0b 10          	mov    0x10(%ebx,%ecx,1),%esi
    if(p->pid !=0)
80104b21:	85 c0                	test   %eax,%eax
80104b23:	74 db                	je     80104b00 <get_most_caller+0x40>
      cprintf("     pid=%d, name: %s \n",p->pid, p->name);
80104b25:	83 ec 04             	sub    $0x4,%esp
80104b28:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104b2b:	53                   	push   %ebx
80104b2c:	50                   	push   %eax
80104b2d:	68 1d 8a 10 80       	push   $0x80108a1d
80104b32:	e8 69 bb ff ff       	call   801006a0 <cprintf>
80104b37:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104b3a:	83 c4 10             	add    $0x10,%esp
80104b3d:	eb c1                	jmp    80104b00 <get_most_caller+0x40>
80104b3f:	90                   	nop
    }

  }
  release(&ptable.lock);
80104b40:	83 ec 0c             	sub    $0xc,%esp
80104b43:	68 e0 44 11 80       	push   $0x801144e0
80104b48:	e8 93 09 00 00       	call   801054e0 <release>
  return pid_max;
}
80104b4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b53:	5b                   	pop    %ebx
80104b54:	5e                   	pop    %esi
80104b55:	5f                   	pop    %edi
80104b56:	5d                   	pop    %ebp
80104b57:	c3                   	ret    
80104b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop

80104b60 <set_queue>:

void
set_queue(int pid, int new_queue)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 75 0c             	mov    0xc(%ebp),%esi
80104b68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  acquire(&ptable.lock);
80104b6b:	83 ec 0c             	sub    $0xc,%esp
80104b6e:	68 e0 44 11 80       	push   $0x801144e0
80104b73:	e8 d8 09 00 00       	call   80105550 <acquire>
80104b78:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b7b:	b8 18 45 11 80       	mov    $0x80114518,%eax
    if(p->pid == pid)
80104b80:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b83:	75 06                	jne    80104b8b <set_queue+0x2b>
      p->queue = new_queue;
80104b85:	89 b0 e0 00 00 00    	mov    %esi,0xe0(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b8b:	05 04 01 00 00       	add    $0x104,%eax
80104b90:	3d 18 86 11 80       	cmp    $0x80118618,%eax
80104b95:	75 e9                	jne    80104b80 <set_queue+0x20>
  }
  release(&ptable.lock);
80104b97:	c7 45 08 e0 44 11 80 	movl   $0x801144e0,0x8(%ebp)
}
80104b9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ba1:	5b                   	pop    %ebx
80104ba2:	5e                   	pop    %esi
80104ba3:	5d                   	pop    %ebp
  release(&ptable.lock);
80104ba4:	e9 37 09 00 00       	jmp    801054e0 <release>
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <set_global_bjf_params>:

void 
set_global_bjf_params(int p_ratio, int a_ratio, int e_ratio)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 18             	sub    $0x18,%esp
80104bb9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p;
  acquire(&ptable.lock);
80104bbf:	68 e0 44 11 80       	push   $0x801144e0
{
80104bc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  acquire(&ptable.lock);
80104bc7:	e8 84 09 00 00       	call   80105550 <acquire>
80104bcc:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bcf:	b8 18 45 11 80       	mov    $0x80114518,%eax
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->arrival_time_ratio = a_ratio;
80104bd8:	89 b0 f0 00 00 00    	mov    %esi,0xf0(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bde:	05 04 01 00 00       	add    $0x104,%eax
    p->exec_cycle_ratio = e_ratio;
80104be3:	89 58 f4             	mov    %ebx,-0xc(%eax)
    p->priority_ratio = p_ratio;
80104be6:	89 78 e8             	mov    %edi,-0x18(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104be9:	3d 18 86 11 80       	cmp    $0x80118618,%eax
80104bee:	75 e8                	jne    80104bd8 <set_global_bjf_params+0x28>
  }
  release(&ptable.lock);
80104bf0:	c7 45 08 e0 44 11 80 	movl   $0x801144e0,0x8(%ebp)
}
80104bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bfa:	5b                   	pop    %ebx
80104bfb:	5e                   	pop    %esi
80104bfc:	5f                   	pop    %edi
80104bfd:	5d                   	pop    %ebp
  release(&ptable.lock);
80104bfe:	e9 dd 08 00 00       	jmp    801054e0 <release>
80104c03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c10 <set_bjf_params>:

void 
set_bjf_params(int pid, int p_ratio, int a_ratio, int e_ratio)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	57                   	push   %edi
80104c14:	56                   	push   %esi
80104c15:	53                   	push   %ebx
80104c16:	83 ec 28             	sub    $0x28,%esp
80104c19:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c1f:	8b 7d 10             	mov    0x10(%ebp),%edi
80104c22:	8b 75 14             	mov    0x14(%ebp),%esi
  struct proc *p;
  acquire(&ptable.lock);
80104c25:	68 e0 44 11 80       	push   $0x801144e0
{
80104c2a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&ptable.lock);
80104c2d:	e8 1e 09 00 00       	call   80105550 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&ptable.lock);
80104c35:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c38:	b8 18 45 11 80       	mov    $0x80114518,%eax
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->pid == pid){
80104c40:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c43:	75 12                	jne    80104c57 <set_bjf_params+0x47>
      p->arrival_time_ratio = a_ratio;
80104c45:	89 b8 f0 00 00 00    	mov    %edi,0xf0(%eax)
      p->exec_cycle_ratio = e_ratio;
80104c4b:	89 b0 f8 00 00 00    	mov    %esi,0xf8(%eax)
      p->priority_ratio = p_ratio;
80104c51:	89 90 ec 00 00 00    	mov    %edx,0xec(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c57:	05 04 01 00 00       	add    $0x104,%eax
80104c5c:	3d 18 86 11 80       	cmp    $0x80118618,%eax
80104c61:	75 dd                	jne    80104c40 <set_bjf_params+0x30>
    }
  }
  release(&ptable.lock);
80104c63:	c7 45 08 e0 44 11 80 	movl   $0x801144e0,0x8(%ebp)
}
80104c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c6d:	5b                   	pop    %ebx
80104c6e:	5e                   	pop    %esi
80104c6f:	5f                   	pop    %edi
80104c70:	5d                   	pop    %ebp
  release(&ptable.lock);
80104c71:	e9 6a 08 00 00       	jmp    801054e0 <release>
80104c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi

80104c80 <add_to_sem_queue>:

// Process must have acquired lock before
// calling these two functions
void 
add_to_sem_queue(int i, struct proc* proc)
{
80104c80:	55                   	push   %ebp
  for (int j = 0; j < NPROC; j++) {
80104c81:	31 c0                	xor    %eax,%eax
{
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c88:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
80104c8b:	c1 e2 06             	shl    $0x6,%edx
80104c8e:	eb 08                	jmp    80104c98 <add_to_sem_queue+0x18>
  for (int j = 0; j < NPROC; j++) {
80104c90:	83 c0 01             	add    $0x1,%eax
80104c93:	83 f8 40             	cmp    $0x40,%eax
80104c96:	74 1e                	je     80104cb6 <add_to_sem_queue+0x36>
    if (semaphores[i].queue[j] == 0) {
80104c98:	83 bc 82 a0 3e 11 80 	cmpl   $0x0,-0x7feec160(%edx,%eax,4)
80104c9f:	00 
80104ca0:	75 ee                	jne    80104c90 <add_to_sem_queue+0x10>
      semaphores[i].queue[j] = proc;
80104ca2:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
80104ca5:	c1 e2 04             	shl    $0x4,%edx
80104ca8:	8d 44 10 10          	lea    0x10(%eax,%edx,1),%eax
80104cac:	8b 55 0c             	mov    0xc(%ebp),%edx
80104caf:	89 14 85 60 3e 11 80 	mov    %edx,-0x7feec1a0(,%eax,4)
      return;
    }
  }
}
80104cb6:	5d                   	pop    %ebp
80104cb7:	c3                   	ret    
80104cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbf:	90                   	nop

80104cc0 <pop_sem_queue>:

struct proc*
pop_sem_queue(int i)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	8b 75 08             	mov    0x8(%ebp),%esi
80104cc8:	53                   	push   %ebx
  struct proc* p = 0;
  int j = 0;

  if (semaphores[i].queue[0] == 0)
80104cc9:	8d 0c b6             	lea    (%esi,%esi,4),%ecx
80104ccc:	c1 e1 06             	shl    $0x6,%ecx
80104ccf:	8b b9 a0 3e 11 80    	mov    -0x7feec160(%ecx),%edi
80104cd5:	85 ff                	test   %edi,%edi
80104cd7:	74 38                	je     80104d11 <pop_sem_queue+0x51>
    return 0;
  
  p = semaphores[i].queue[0];

  for (j = 0; j < NPROC - 1; j++) {
80104cd9:	31 c0                	xor    %eax,%eax
80104cdb:	eb 0f                	jmp    80104cec <pop_sem_queue+0x2c>
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
    if (semaphores[i].queue[j+1] != 0)
      semaphores[i].queue[j] = semaphores[i].queue[j+1];
80104ce0:	89 94 81 9c 3e 11 80 	mov    %edx,-0x7feec164(%ecx,%eax,4)
  for (j = 0; j < NPROC - 1; j++) {
80104ce7:	83 f8 3f             	cmp    $0x3f,%eax
80104cea:	74 25                	je     80104d11 <pop_sem_queue+0x51>
    if (semaphores[i].queue[j+1] != 0)
80104cec:	89 c3                	mov    %eax,%ebx
80104cee:	83 c0 01             	add    $0x1,%eax
80104cf1:	8b 94 81 a0 3e 11 80 	mov    -0x7feec160(%ecx,%eax,4),%edx
80104cf8:	85 d2                	test   %edx,%edx
80104cfa:	75 e4                	jne    80104ce0 <pop_sem_queue+0x20>
    else {
      semaphores[i].queue[j] = 0;
80104cfc:	8d 04 b6             	lea    (%esi,%esi,4),%eax
80104cff:	c1 e0 04             	shl    $0x4,%eax
80104d02:	8d 44 03 10          	lea    0x10(%ebx,%eax,1),%eax
80104d06:	c7 04 85 60 3e 11 80 	movl   $0x0,-0x7feec1a0(,%eax,4)
80104d0d:	00 00 00 00 
      break;
    }
  }

  return p;
}
80104d11:	5b                   	pop    %ebx
80104d12:	89 f8                	mov    %edi,%eax
80104d14:	5e                   	pop    %esi
80104d15:	5f                   	pop    %edi
80104d16:	5d                   	pop    %ebp
80104d17:	c3                   	ret    
80104d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop

80104d20 <sem_init>:

int
sem_init(int i, int v) 
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	83 ec 10             	sub    $0x10,%esp
80104d26:	8b 55 08             	mov    0x8(%ebp),%edx
  semaphores[i].max_procs = v;
80104d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d2c:	8d 04 92             	lea    (%edx,%edx,4),%eax
  // if (i == 1)
  //   semaphores[i].curr_procs = 5;
  // else
    semaphores[i].curr_procs = 0;
  
  initlock(&(semaphores[i].lock), (char*)i + '0');
80104d2f:	83 c2 30             	add    $0x30,%edx
  semaphores[i].max_procs = v;
80104d32:	c1 e0 06             	shl    $0x6,%eax
  initlock(&(semaphores[i].lock), (char*)i + '0');
80104d35:	52                   	push   %edx
  semaphores[i].max_procs = v;
80104d36:	89 88 60 3e 11 80    	mov    %ecx,-0x7feec1a0(%eax)
    semaphores[i].curr_procs = 0;
80104d3c:	c7 80 64 3e 11 80 00 	movl   $0x0,-0x7feec19c(%eax)
80104d43:	00 00 00 
  initlock(&(semaphores[i].lock), (char*)i + '0');
80104d46:	05 68 3e 11 80       	add    $0x80113e68,%eax
80104d4b:	50                   	push   %eax
80104d4c:	e8 0f 06 00 00       	call   80105360 <initlock>
  
  return 1;
}
80104d51:	b8 01 00 00 00       	mov    $0x1,%eax
80104d56:	c9                   	leave  
80104d57:	c3                   	ret    
80104d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop

80104d60 <sem_acquire>:

int 
sem_acquire(int i)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
80104d65:	53                   	push   %ebx
80104d66:	83 ec 1c             	sub    $0x1c,%esp
80104d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d6c:	e8 7f 06 00 00       	call   801053f0 <pushcli>
  c = mycpu();
80104d71:	e8 6a ec ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80104d76:	8d 3c 9b             	lea    (%ebx,%ebx,4),%edi
80104d79:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d7f:	c1 e7 06             	shl    $0x6,%edi
  struct proc* p = myproc();
  acquire(&(semaphores[i].lock));
80104d82:	8d b7 68 3e 11 80    	lea    -0x7feec198(%edi),%esi
  p = c->proc;
80104d88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
80104d8b:	e8 b0 06 00 00       	call   80105440 <popcli>
  acquire(&(semaphores[i].lock));
80104d90:	83 ec 0c             	sub    $0xc,%esp
80104d93:	56                   	push   %esi
80104d94:	e8 b7 07 00 00       	call   80105550 <acquire>
  if (semaphores[i].curr_procs < semaphores[i].max_procs) {
80104d99:	8b 87 64 3e 11 80    	mov    -0x7feec19c(%edi),%eax
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	3b 87 60 3e 11 80    	cmp    -0x7feec1a0(%edi),%eax
80104da8:	7d 26                	jge    80104dd0 <sem_acquire+0x70>
    semaphores[i].curr_procs += 1;
80104daa:	83 c0 01             	add    $0x1,%eax
    add_to_sem_queue(i, p);
    cprintf("Process %d going to sleep\n", p->pid);
    sleep(p, &(semaphores[i].lock));
    semaphores[i].curr_procs += 1;
  }
  release(&(semaphores[i].lock));
80104dad:	83 ec 0c             	sub    $0xc,%esp
    semaphores[i].curr_procs += 1;
80104db0:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
  release(&(semaphores[i].lock));
80104db3:	56                   	push   %esi
    semaphores[i].curr_procs += 1;
80104db4:	c1 e1 06             	shl    $0x6,%ecx
80104db7:	89 81 64 3e 11 80    	mov    %eax,-0x7feec19c(%ecx)
  release(&(semaphores[i].lock));
80104dbd:	e8 1e 07 00 00       	call   801054e0 <release>

  return 1;
}
80104dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dca:	5b                   	pop    %ebx
80104dcb:	5e                   	pop    %esi
80104dcc:	5f                   	pop    %edi
80104dcd:	5d                   	pop    %ebp
80104dce:	c3                   	ret    
80104dcf:	90                   	nop
  for (int j = 0; j < NPROC; j++) {
80104dd0:	31 c0                	xor    %eax,%eax
80104dd2:	eb 0c                	jmp    80104de0 <sem_acquire+0x80>
80104dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dd8:	83 c0 01             	add    $0x1,%eax
80104ddb:	83 f8 40             	cmp    $0x40,%eax
80104dde:	74 1f                	je     80104dff <sem_acquire+0x9f>
    if (semaphores[i].queue[j] == 0) {
80104de0:	8b 8c 87 a0 3e 11 80 	mov    -0x7feec160(%edi,%eax,4),%ecx
80104de7:	85 c9                	test   %ecx,%ecx
80104de9:	75 ed                	jne    80104dd8 <sem_acquire+0x78>
      semaphores[i].queue[j] = proc;
80104deb:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
80104dee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104df1:	c1 e1 04             	shl    $0x4,%ecx
80104df4:	8d 44 08 10          	lea    0x10(%eax,%ecx,1),%eax
80104df8:	89 14 85 60 3e 11 80 	mov    %edx,-0x7feec1a0(,%eax,4)
    cprintf("Process %d going to sleep\n", p->pid);
80104dff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104e02:	83 ec 08             	sub    $0x8,%esp
80104e05:	ff 77 10             	push   0x10(%edi)
80104e08:	68 35 8a 10 80       	push   $0x80108a35
80104e0d:	e8 8e b8 ff ff       	call   801006a0 <cprintf>
    sleep(p, &(semaphores[i].lock));
80104e12:	58                   	pop    %eax
80104e13:	5a                   	pop    %edx
80104e14:	56                   	push   %esi
80104e15:	57                   	push   %edi
80104e16:	e8 05 fa ff ff       	call   80104820 <sleep>
    semaphores[i].curr_procs += 1;
80104e1b:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
80104e1e:	83 c4 10             	add    $0x10,%esp
80104e21:	c1 e0 06             	shl    $0x6,%eax
80104e24:	8b 80 64 3e 11 80    	mov    -0x7feec19c(%eax),%eax
80104e2a:	83 c0 01             	add    $0x1,%eax
80104e2d:	e9 7b ff ff ff       	jmp    80104dad <sem_acquire+0x4d>
80104e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e40 <sem_release>:

int 
sem_release(int i)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	53                   	push   %ebx
80104e46:	83 ec 18             	sub    $0x18,%esp
80104e49:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc* p = 0;
  acquire(&(semaphores[i].lock));
80104e4c:	8d 1c b6             	lea    (%esi,%esi,4),%ebx
80104e4f:	c1 e3 06             	shl    $0x6,%ebx
80104e52:	8d bb 68 3e 11 80    	lea    -0x7feec198(%ebx),%edi
80104e58:	57                   	push   %edi
80104e59:	e8 f2 06 00 00       	call   80105550 <acquire>
  
  semaphores[i].curr_procs -= 1;
  p = pop_sem_queue(i);
80104e5e:	89 34 24             	mov    %esi,(%esp)
  semaphores[i].curr_procs -= 1;
80104e61:	83 ab 64 3e 11 80 01 	subl   $0x1,-0x7feec19c(%ebx)
  p = pop_sem_queue(i);
80104e68:	e8 53 fe ff ff       	call   80104cc0 <pop_sem_queue>
  release(&(semaphores[i].lock));
80104e6d:	89 3c 24             	mov    %edi,(%esp)
  p = pop_sem_queue(i);
80104e70:	89 c3                	mov    %eax,%ebx
  release(&(semaphores[i].lock));
80104e72:	e8 69 06 00 00       	call   801054e0 <release>
  if (p != 0) {
80104e77:	83 c4 10             	add    $0x10,%esp
80104e7a:	85 db                	test   %ebx,%ebx
80104e7c:	74 72                	je     80104ef0 <sem_release+0xb0>
    cprintf("Process %d is waking up\n", p->pid);
80104e7e:	83 ec 08             	sub    $0x8,%esp
80104e81:	ff 73 10             	push   0x10(%ebx)
80104e84:	68 50 8a 10 80       	push   $0x80108a50
80104e89:	e8 12 b8 ff ff       	call   801006a0 <cprintf>
  acquire(&ptable.lock);
80104e8e:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
80104e95:	e8 b6 06 00 00       	call   80105550 <acquire>
80104e9a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e9d:	ba 18 45 11 80       	mov    $0x80114518,%edx
80104ea2:	eb 12                	jmp    80104eb6 <sem_release+0x76>
80104ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ea8:	81 c2 04 01 00 00    	add    $0x104,%edx
80104eae:	81 fa 18 86 11 80    	cmp    $0x80118618,%edx
80104eb4:	74 2a                	je     80104ee0 <sem_release+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80104eb6:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80104eba:	75 ec                	jne    80104ea8 <sem_release+0x68>
80104ebc:	3b 5a 20             	cmp    0x20(%edx),%ebx
80104ebf:	75 e7                	jne    80104ea8 <sem_release+0x68>
      p->state = RUNNABLE;
80104ec1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ec8:	81 c2 04 01 00 00    	add    $0x104,%edx
80104ece:	81 fa 18 86 11 80    	cmp    $0x80118618,%edx
80104ed4:	75 e0                	jne    80104eb6 <sem_release+0x76>
80104ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
80104ee3:	68 e0 44 11 80       	push   $0x801144e0
80104ee8:	e8 f3 05 00 00       	call   801054e0 <release>
}
80104eed:	83 c4 10             	add    $0x10,%esp
    wakeup(p);
  }
  
  return 1;
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef3:	b8 01 00 00 00       	mov    $0x1,%eax
80104ef8:	5b                   	pop    %ebx
80104ef9:	5e                   	pop    %esi
80104efa:	5f                   	pop    %edi
80104efb:	5d                   	pop    %ebp
80104efc:	c3                   	ret    
80104efd:	8d 76 00             	lea    0x0(%esi),%esi

80104f00 <first_func>:

int first_func(int n)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	53                   	push   %ebx
80104f04:	83 ec 04             	sub    $0x4,%esp
80104f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f0a:	eb 18                	jmp    80104f24 <first_func+0x24>
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (n == 0){
        cprintf("first func done\n");
        release(&reentrant_lock);
        return 1;
    }
    cprintf("first func run number %d \n",n);
80104f10:	83 ec 08             	sub    $0x8,%esp
80104f13:	53                   	push   %ebx
    temp--;
80104f14:	83 eb 01             	sub    $0x1,%ebx
    cprintf("first func run number %d \n",n);
80104f17:	68 7a 8a 10 80       	push   $0x80108a7a
80104f1c:	e8 7f b7 ff ff       	call   801006a0 <cprintf>
    return first_func(temp);
80104f21:	83 c4 10             	add    $0x10,%esp
    acquire(&reentrant_lock);
80104f24:	83 ec 0c             	sub    $0xc,%esp
80104f27:	68 a0 44 11 80       	push   $0x801144a0
80104f2c:	e8 1f 06 00 00       	call   80105550 <acquire>
    if (n == 0){
80104f31:	83 c4 10             	add    $0x10,%esp
80104f34:	85 db                	test   %ebx,%ebx
80104f36:	75 d8                	jne    80104f10 <first_func+0x10>
        cprintf("first func done\n");
80104f38:	83 ec 0c             	sub    $0xc,%esp
80104f3b:	68 69 8a 10 80       	push   $0x80108a69
80104f40:	e8 5b b7 ff ff       	call   801006a0 <cprintf>
        release(&reentrant_lock);
80104f45:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80104f4c:	e8 8f 05 00 00       	call   801054e0 <release>
    
}
80104f51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f54:	b8 01 00 00 00       	mov    $0x1,%eax
80104f59:	c9                   	leave  
80104f5a:	c3                   	ret    
80104f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f5f:	90                   	nop

80104f60 <second_func>:


int second_func(int n)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
80104f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f6a:	eb 18                	jmp    80104f84 <second_func+0x24>
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (n == 0){
        cprintf("second func done\n");
        release(&reentrant_lock);
        return 1;
    }
    cprintf("sec func run number %d \n",n);
80104f70:	83 ec 08             	sub    $0x8,%esp
80104f73:	53                   	push   %ebx
    temp--;
80104f74:	83 eb 01             	sub    $0x1,%ebx
    cprintf("sec func run number %d \n",n);
80104f77:	68 a7 8a 10 80       	push   $0x80108aa7
80104f7c:	e8 1f b7 ff ff       	call   801006a0 <cprintf>
    return second_func(temp);
80104f81:	83 c4 10             	add    $0x10,%esp
    acquire(&reentrant_lock);
80104f84:	83 ec 0c             	sub    $0xc,%esp
80104f87:	68 a0 44 11 80       	push   $0x801144a0
80104f8c:	e8 bf 05 00 00       	call   80105550 <acquire>
    if (n == 0){
80104f91:	83 c4 10             	add    $0x10,%esp
80104f94:	85 db                	test   %ebx,%ebx
80104f96:	75 d8                	jne    80104f70 <second_func+0x10>
        cprintf("second func done\n");
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	68 95 8a 10 80       	push   $0x80108a95
80104fa0:	e8 fb b6 ff ff       	call   801006a0 <cprintf>
        release(&reentrant_lock);
80104fa5:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80104fac:	e8 2f 05 00 00       	call   801054e0 <release>
    
}
80104fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb4:	b8 01 00 00 00       	mov    $0x1,%eax
80104fb9:	c9                   	leave  
80104fba:	c3                   	ret    
80104fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fbf:	90                   	nop

80104fc0 <initlock_rl>:

void
initlock_rl()
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	53                   	push   %ebx
    acquire(&reentrant_lock);
80104fc4:	bb 0a 00 00 00       	mov    $0xa,%ebx
{
80104fc9:	83 ec 0c             	sub    $0xc,%esp
  //cprintf("reentrant mutex test\n");
  initlock(&reentrant_lock,"reentrant_lock");
80104fcc:	68 c0 8a 10 80       	push   $0x80108ac0
80104fd1:	68 a0 44 11 80       	push   $0x801144a0
80104fd6:	e8 85 03 00 00       	call   80105360 <initlock>
  cprintf("lock initiated\n");
80104fdb:	c7 04 24 cf 8a 10 80 	movl   $0x80108acf,(%esp)
80104fe2:	e8 b9 b6 ff ff       	call   801006a0 <cprintf>
    acquire(&reentrant_lock);
80104fe7:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80104fee:	e8 5d 05 00 00       	call   80105550 <acquire>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("first func run number %d \n",n);
80105000:	83 ec 08             	sub    $0x8,%esp
80105003:	53                   	push   %ebx
    temp--;
80105004:	83 eb 01             	sub    $0x1,%ebx
    cprintf("first func run number %d \n",n);
80105007:	68 7a 8a 10 80       	push   $0x80108a7a
8010500c:	e8 8f b6 ff ff       	call   801006a0 <cprintf>
    acquire(&reentrant_lock);
80105011:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80105018:	e8 33 05 00 00       	call   80105550 <acquire>
    if (n == 0){
8010501d:	83 c4 10             	add    $0x10,%esp
80105020:	85 db                	test   %ebx,%ebx
80105022:	75 dc                	jne    80105000 <initlock_rl+0x40>
        cprintf("first func done\n");
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	68 69 8a 10 80       	push   $0x80108a69
8010502c:	e8 6f b6 ff ff       	call   801006a0 <cprintf>
        release(&reentrant_lock);
80105031:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80105038:	e8 a3 04 00 00       	call   801054e0 <release>
  
  first_func(10);
  
}
8010503d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105040:	c9                   	leave  
80105041:	c3                   	ret    
80105042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105050 <acquire_rl>:

void 
acquire_rl()
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	53                   	push   %ebx
    acquire(&reentrant_lock);
80105054:	bb 0a 00 00 00       	mov    $0xa,%ebx
{
80105059:	83 ec 10             	sub    $0x10,%esp
    acquire(&reentrant_lock);
8010505c:	68 a0 44 11 80       	push   $0x801144a0
80105061:	e8 ea 04 00 00       	call   80105550 <acquire>
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("sec func run number %d \n",n);
80105070:	83 ec 08             	sub    $0x8,%esp
80105073:	53                   	push   %ebx
    temp--;
80105074:	83 eb 01             	sub    $0x1,%ebx
    cprintf("sec func run number %d \n",n);
80105077:	68 a7 8a 10 80       	push   $0x80108aa7
8010507c:	e8 1f b6 ff ff       	call   801006a0 <cprintf>
    acquire(&reentrant_lock);
80105081:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
80105088:	e8 c3 04 00 00       	call   80105550 <acquire>
    if (n == 0){
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 db                	test   %ebx,%ebx
80105092:	75 dc                	jne    80105070 <acquire_rl+0x20>
        cprintf("second func done\n");
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	68 95 8a 10 80       	push   $0x80108a95
8010509c:	e8 ff b5 ff ff       	call   801006a0 <cprintf>
        release(&reentrant_lock);
801050a1:	c7 04 24 a0 44 11 80 	movl   $0x801144a0,(%esp)
801050a8:	e8 33 04 00 00       	call   801054e0 <release>
  second_func(10);
}
801050ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050b0:	c9                   	leave  
801050b1:	c3                   	ret    
801050b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050c0 <release_rl>:

void
release_rl()
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	83 ec 14             	sub    $0x14,%esp
  release(&reentrant_lock);
801050c6:	68 a0 44 11 80       	push   $0x801144a0
801050cb:	e8 10 04 00 00       	call   801054e0 <release>
  cprintf("lock released\n");
801050d0:	c7 04 24 df 8a 10 80 	movl   $0x80108adf,(%esp)
801050d7:	e8 c4 b5 ff ff       	call   801006a0 <cprintf>
}
801050dc:	83 c4 10             	add    $0x10,%esp
801050df:	c9                   	leave  
801050e0:	c3                   	ret    
801050e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ef:	90                   	nop

801050f0 <wait_for_process>:


int
wait_for_process(int proc_pid)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	56                   	push   %esi
801050f5:	53                   	push   %ebx
801050f6:	83 ec 0c             	sub    $0xc,%esp
801050f9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801050fc:	e8 ef 02 00 00       	call   801053f0 <pushcli>
  c = mycpu();
80105101:	e8 da e8 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80105106:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010510c:	e8 2f 03 00 00       	call   80105440 <popcli>
  struct proc *p;
  struct proc *curproc = myproc();
  int exist=0;
  acquire(&ptable.lock);
80105111:	83 ec 0c             	sub    $0xc,%esp
80105114:	68 e0 44 11 80       	push   $0x801144e0
80105119:	e8 32 04 00 00       	call   80105550 <acquire>
8010511e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    exist=0;
80105121:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105123:	bb 18 45 11 80       	mov    $0x80114518,%ebx
80105128:	eb 14                	jmp    8010513e <wait_for_process+0x4e>
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105130:	81 c3 04 01 00 00    	add    $0x104,%ebx
80105136:	81 fb 18 86 11 80    	cmp    $0x80118618,%ebx
8010513c:	74 1e                	je     8010515c <wait_for_process+0x6c>
      if(p->pid == proc_pid)
8010513e:	39 73 10             	cmp    %esi,0x10(%ebx)
80105141:	75 ed                	jne    80105130 <wait_for_process+0x40>
        exist = 1;
      if(p->state == ZOMBIE && p->pid == proc_pid){
80105143:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80105147:	74 67                	je     801051b0 <wait_for_process+0xc0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105149:	81 c3 04 01 00 00    	add    $0x104,%ebx
        exist = 1;
8010514f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105154:	81 fb 18 86 11 80    	cmp    $0x80118618,%ebx
8010515a:	75 e2                	jne    8010513e <wait_for_process+0x4e>
        p->state = UNUSED;
        release(&ptable.lock);
        return proc_pid;
      }
    }
    if(!exist || curproc->killed){
8010515c:	85 c0                	test   %eax,%eax
8010515e:	0f 84 a0 00 00 00    	je     80105204 <wait_for_process+0x114>
80105164:	8b 47 24             	mov    0x24(%edi),%eax
80105167:	85 c0                	test   %eax,%eax
80105169:	0f 85 95 00 00 00    	jne    80105204 <wait_for_process+0x114>
  pushcli();
8010516f:	e8 7c 02 00 00       	call   801053f0 <pushcli>
  c = mycpu();
80105174:	e8 67 e8 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80105179:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010517f:	e8 bc 02 00 00       	call   80105440 <popcli>
  if(p == 0)
80105184:	85 db                	test   %ebx,%ebx
80105186:	0f 84 8f 00 00 00    	je     8010521b <wait_for_process+0x12b>
  p->chan = chan;
8010518c:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010518f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105196:	e8 c5 f2 ff ff       	call   80104460 <sched>
  p->chan = 0;
8010519b:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801051a2:	e9 7a ff ff ff       	jmp    80105121 <wait_for_process+0x31>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	ff 73 08             	push   0x8(%ebx)
801051b6:	e8 05 d3 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801051bb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801051c2:	5a                   	pop    %edx
801051c3:	ff 73 04             	push   0x4(%ebx)
801051c6:	e8 55 2e 00 00       	call   80108020 <freevm>
        p->pid = 0;
801051cb:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801051d2:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801051d9:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801051dd:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801051e4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801051eb:	c7 04 24 e0 44 11 80 	movl   $0x801144e0,(%esp)
801051f2:	e8 e9 02 00 00       	call   801054e0 <release>
        return proc_pid;
801051f7:	83 c4 10             	add    $0x10,%esp
801051fa:	89 f0                	mov    %esi,%eax
      return -1;
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
801051fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ff:	5b                   	pop    %ebx
80105200:	5e                   	pop    %esi
80105201:	5f                   	pop    %edi
80105202:	5d                   	pop    %ebp
80105203:	c3                   	ret    
      release(&ptable.lock);
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	68 e0 44 11 80       	push   $0x801144e0
8010520c:	e8 cf 02 00 00       	call   801054e0 <release>
      return -1;
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105219:	eb e1                	jmp    801051fc <wait_for_process+0x10c>
    panic("sleep");
8010521b:	83 ec 0c             	sub    $0xc,%esp
8010521e:	68 f9 89 10 80       	push   $0x801089f9
80105223:	e8 58 b1 ff ff       	call   80100380 <panic>
80105228:	66 90                	xchg   %ax,%ax
8010522a:	66 90                	xchg   %ax,%ax
8010522c:	66 90                	xchg   %ax,%ax
8010522e:	66 90                	xchg   %ax,%ax

80105230 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	53                   	push   %ebx
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010523a:	68 80 8c 10 80       	push   $0x80108c80
8010523f:	8d 43 04             	lea    0x4(%ebx),%eax
80105242:	50                   	push   %eax
80105243:	e8 18 01 00 00       	call   80105360 <initlock>
  lk->name = name;
80105248:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010524b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105251:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105254:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  lk->name = name;
8010525b:	89 43 3c             	mov    %eax,0x3c(%ebx)
}
8010525e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105261:	c9                   	leave  
80105262:	c3                   	ret    
80105263:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105270 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
80105275:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105278:	8d 73 04             	lea    0x4(%ebx),%esi
8010527b:	83 ec 0c             	sub    $0xc,%esp
8010527e:	56                   	push   %esi
8010527f:	e8 cc 02 00 00       	call   80105550 <acquire>
  while (lk->locked) {
80105284:	8b 13                	mov    (%ebx),%edx
80105286:	83 c4 10             	add    $0x10,%esp
80105289:	85 d2                	test   %edx,%edx
8010528b:	74 16                	je     801052a3 <acquiresleep+0x33>
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105290:	83 ec 08             	sub    $0x8,%esp
80105293:	56                   	push   %esi
80105294:	53                   	push   %ebx
80105295:	e8 86 f5 ff ff       	call   80104820 <sleep>
  while (lk->locked) {
8010529a:	8b 03                	mov    (%ebx),%eax
8010529c:	83 c4 10             	add    $0x10,%esp
8010529f:	85 c0                	test   %eax,%eax
801052a1:	75 ed                	jne    80105290 <acquiresleep+0x20>
  }
  lk->locked = 1;
801052a3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801052a9:	e8 b2 e7 ff ff       	call   80103a60 <myproc>
801052ae:	8b 40 10             	mov    0x10(%eax),%eax
801052b1:	89 43 40             	mov    %eax,0x40(%ebx)
  release(&lk->lk);
801052b4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801052b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052ba:	5b                   	pop    %ebx
801052bb:	5e                   	pop    %esi
801052bc:	5d                   	pop    %ebp
  release(&lk->lk);
801052bd:	e9 1e 02 00 00       	jmp    801054e0 <release>
801052c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
801052d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801052d8:	8d 73 04             	lea    0x4(%ebx),%esi
801052db:	83 ec 0c             	sub    $0xc,%esp
801052de:	56                   	push   %esi
801052df:	e8 6c 02 00 00       	call   80105550 <acquire>
  lk->locked = 0;
801052e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801052ea:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
  wakeup(lk);
801052f1:	89 1c 24             	mov    %ebx,(%esp)
801052f4:	e8 e7 f5 ff ff       	call   801048e0 <wakeup>
  release(&lk->lk);
801052f9:	89 75 08             	mov    %esi,0x8(%ebp)
801052fc:	83 c4 10             	add    $0x10,%esp
}
801052ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105302:	5b                   	pop    %ebx
80105303:	5e                   	pop    %esi
80105304:	5d                   	pop    %ebp
  release(&lk->lk);
80105305:	e9 d6 01 00 00       	jmp    801054e0 <release>
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105310 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	31 ff                	xor    %edi,%edi
80105316:	56                   	push   %esi
80105317:	53                   	push   %ebx
80105318:	83 ec 18             	sub    $0x18,%esp
8010531b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010531e:	8d 73 04             	lea    0x4(%ebx),%esi
80105321:	56                   	push   %esi
80105322:	e8 29 02 00 00       	call   80105550 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105327:	8b 03                	mov    (%ebx),%eax
80105329:	83 c4 10             	add    $0x10,%esp
8010532c:	85 c0                	test   %eax,%eax
8010532e:	75 18                	jne    80105348 <holdingsleep+0x38>
  release(&lk->lk);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	56                   	push   %esi
80105334:	e8 a7 01 00 00       	call   801054e0 <release>
  return r;
}
80105339:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010533c:	89 f8                	mov    %edi,%eax
8010533e:	5b                   	pop    %ebx
8010533f:	5e                   	pop    %esi
80105340:	5f                   	pop    %edi
80105341:	5d                   	pop    %ebp
80105342:	c3                   	ret    
80105343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105347:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105348:	8b 5b 40             	mov    0x40(%ebx),%ebx
8010534b:	e8 10 e7 ff ff       	call   80103a60 <myproc>
80105350:	39 58 10             	cmp    %ebx,0x10(%eax)
80105353:	0f 94 c0             	sete   %al
80105356:	0f b6 c0             	movzbl %al,%eax
80105359:	89 c7                	mov    %eax,%edi
8010535b:	eb d3                	jmp    80105330 <holdingsleep+0x20>
8010535d:	66 90                	xchg   %ax,%ax
8010535f:	90                   	nop

80105360 <initlock>:
#include "spinlock.h"
#include <stddef.h>

void
initlock(struct spinlock *lk, char *name)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105366:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010536f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105372:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  lk->lock_holder_pid = -1;
80105379:	c7 40 34 ff ff ff ff 	movl   $0xffffffff,0x34(%eax)
}
80105380:	5d                   	pop    %ebp
80105381:	c3                   	ret    
80105382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105390 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105390:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105391:	31 d2                	xor    %edx,%edx
{
80105393:	89 e5                	mov    %esp,%ebp
80105395:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105396:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105399:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010539c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010539f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801053a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801053ac:	77 1a                	ja     801053c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801053ae:	8b 58 04             	mov    0x4(%eax),%ebx
801053b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801053b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801053b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801053b9:	83 fa 0a             	cmp    $0xa,%edx
801053bc:	75 e2                	jne    801053a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801053be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053c1:	c9                   	leave  
801053c2:	c3                   	ret    
801053c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053c7:	90                   	nop
  for(; i < 10; i++)
801053c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801053cb:	8d 51 28             	lea    0x28(%ecx),%edx
801053ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801053d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801053d6:	83 c0 04             	add    $0x4,%eax
801053d9:	39 d0                	cmp    %edx,%eax
801053db:	75 f3                	jne    801053d0 <getcallerpcs+0x40>
}
801053dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053e0:	c9                   	leave  
801053e1:	c3                   	ret    
801053e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	53                   	push   %ebx
801053f4:	83 ec 04             	sub    $0x4,%esp
801053f7:	9c                   	pushf  
801053f8:	5b                   	pop    %ebx
  asm volatile("cli");
801053f9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801053fa:	e8 e1 e5 ff ff       	call   801039e0 <mycpu>
801053ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105405:	85 c0                	test   %eax,%eax
80105407:	74 17                	je     80105420 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105409:	e8 d2 e5 ff ff       	call   801039e0 <mycpu>
8010540e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105415:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105418:	c9                   	leave  
80105419:	c3                   	ret    
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105420:	e8 bb e5 ff ff       	call   801039e0 <mycpu>
80105425:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010542b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105431:	eb d6                	jmp    80105409 <pushcli+0x19>
80105433:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105440 <popcli>:

void
popcli(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105446:	9c                   	pushf  
80105447:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105448:	f6 c4 02             	test   $0x2,%ah
8010544b:	75 35                	jne    80105482 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010544d:	e8 8e e5 ff ff       	call   801039e0 <mycpu>
80105452:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105459:	78 34                	js     8010548f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010545b:	e8 80 e5 ff ff       	call   801039e0 <mycpu>
80105460:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105466:	85 d2                	test   %edx,%edx
80105468:	74 06                	je     80105470 <popcli+0x30>
    sti();
}
8010546a:	c9                   	leave  
8010546b:	c3                   	ret    
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105470:	e8 6b e5 ff ff       	call   801039e0 <mycpu>
80105475:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010547b:	85 c0                	test   %eax,%eax
8010547d:	74 eb                	je     8010546a <popcli+0x2a>
  asm volatile("sti");
8010547f:	fb                   	sti    
}
80105480:	c9                   	leave  
80105481:	c3                   	ret    
    panic("popcli - interruptible");
80105482:	83 ec 0c             	sub    $0xc,%esp
80105485:	68 8b 8c 10 80       	push   $0x80108c8b
8010548a:	e8 f1 ae ff ff       	call   80100380 <panic>
    panic("popcli");
8010548f:	83 ec 0c             	sub    $0xc,%esp
80105492:	68 a2 8c 10 80       	push   $0x80108ca2
80105497:	e8 e4 ae ff ff       	call   80100380 <panic>
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <holding>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	53                   	push   %ebx
801054a5:	8b 75 08             	mov    0x8(%ebp),%esi
801054a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801054aa:	e8 41 ff ff ff       	call   801053f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801054af:	8b 06                	mov    (%esi),%eax
801054b1:	85 c0                	test   %eax,%eax
801054b3:	75 0b                	jne    801054c0 <holding+0x20>
  popcli();
801054b5:	e8 86 ff ff ff       	call   80105440 <popcli>
}
801054ba:	89 d8                	mov    %ebx,%eax
801054bc:	5b                   	pop    %ebx
801054bd:	5e                   	pop    %esi
801054be:	5d                   	pop    %ebp
801054bf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801054c0:	8b 5e 08             	mov    0x8(%esi),%ebx
801054c3:	e8 18 e5 ff ff       	call   801039e0 <mycpu>
801054c8:	39 c3                	cmp    %eax,%ebx
801054ca:	0f 94 c3             	sete   %bl
  popcli();
801054cd:	e8 6e ff ff ff       	call   80105440 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801054d2:	0f b6 db             	movzbl %bl,%ebx
}
801054d5:	89 d8                	mov    %ebx,%eax
801054d7:	5b                   	pop    %ebx
801054d8:	5e                   	pop    %esi
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop

801054e0 <release>:
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
801054e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801054e8:	e8 03 ff ff ff       	call   801053f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801054ed:	8b 03                	mov    (%ebx),%eax
801054ef:	85 c0                	test   %eax,%eax
801054f1:	75 15                	jne    80105508 <release+0x28>
  popcli();
801054f3:	e8 48 ff ff ff       	call   80105440 <popcli>
    panic("release");
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	68 a9 8c 10 80       	push   $0x80108ca9
80105500:	e8 7b ae ff ff       	call   80100380 <panic>
80105505:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105508:	8b 73 08             	mov    0x8(%ebx),%esi
8010550b:	e8 d0 e4 ff ff       	call   801039e0 <mycpu>
80105510:	39 c6                	cmp    %eax,%esi
80105512:	75 df                	jne    801054f3 <release+0x13>
  popcli();
80105514:	e8 27 ff ff ff       	call   80105440 <popcli>
  lk->pcs[0] = 0;
80105519:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105520:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  lk->lock_holder_pid = -1;
80105527:	c7 43 34 ff ff ff ff 	movl   $0xffffffff,0x34(%ebx)
  __sync_synchronize();
8010552e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105533:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105539:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010553c:	5b                   	pop    %ebx
8010553d:	5e                   	pop    %esi
8010553e:	5d                   	pop    %ebp
  popcli();
8010553f:	e9 fc fe ff ff       	jmp    80105440 <popcli>
80105544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop

80105550 <acquire>:
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
80105555:	bb 01 00 00 00       	mov    $0x1,%ebx
  pushcli(); // disable interrupts to avoid deadlock.
8010555a:	e8 91 fe ff ff       	call   801053f0 <pushcli>
  if (myproc() != NULL)
8010555f:	e8 fc e4 ff ff       	call   80103a60 <myproc>
80105564:	85 c0                	test   %eax,%eax
80105566:	74 08                	je     80105570 <acquire+0x20>
    cur_proc_pid = myproc()->pid;
80105568:	e8 f3 e4 ff ff       	call   80103a60 <myproc>
8010556d:	8b 58 10             	mov    0x10(%eax),%ebx
  if (holding(lk) && lk->lock_holder_pid == cur_proc_pid)
80105570:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105573:	e8 78 fe ff ff       	call   801053f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105578:	8b 16                	mov    (%esi),%edx
8010557a:	85 d2                	test   %edx,%edx
8010557c:	0f 85 8e 00 00 00    	jne    80105610 <acquire+0xc0>
  popcli();
80105582:	e8 b9 fe ff ff       	call   80105440 <popcli>
  if(holding(lk) && lk->lock_holder_pid != cur_proc_pid)
80105587:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010558a:	e8 61 fe ff ff       	call   801053f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010558f:	8b 06                	mov    (%esi),%eax
80105591:	85 c0                	test   %eax,%eax
80105593:	0f 85 cf 00 00 00    	jne    80105668 <acquire+0x118>
  popcli();
80105599:	e8 a2 fe ff ff       	call   80105440 <popcli>
  while(xchg(&lk->locked, 1) != 0)
8010559e:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
801055a1:	b9 01 00 00 00       	mov    $0x1,%ecx
801055a6:	eb 0b                	jmp    801055b3 <acquire+0x63>
801055a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
  lk-> lock_holder_pid = cur_proc_pid;
801055b0:	8b 55 08             	mov    0x8(%ebp),%edx
801055b3:	89 c8                	mov    %ecx,%eax
801055b5:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
801055b8:	85 c0                	test   %eax,%eax
801055ba:	75 f4                	jne    801055b0 <acquire+0x60>
  lk-> lock_holder_pid = cur_proc_pid;
801055bc:	8b 45 08             	mov    0x8(%ebp),%eax
801055bf:	89 58 34             	mov    %ebx,0x34(%eax)
  __sync_synchronize();
801055c2:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801055c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055ca:	e8 11 e4 ff ff       	call   801039e0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801055cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801055d2:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801055d4:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801055d7:	31 c0                	xor    %eax,%eax
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801055e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801055e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801055ec:	77 52                	ja     80105640 <acquire+0xf0>
    pcs[i] = ebp[1];     // saved %eip
801055ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801055f1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801055f5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801055f8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801055fa:	83 f8 0a             	cmp    $0xa,%eax
801055fd:	75 e1                	jne    801055e0 <acquire+0x90>
}
801055ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105602:	5b                   	pop    %ebx
80105603:	5e                   	pop    %esi
80105604:	5d                   	pop    %ebp
80105605:	c3                   	ret    
80105606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560d:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105610:	8b 76 08             	mov    0x8(%esi),%esi
80105613:	e8 c8 e3 ff ff       	call   801039e0 <mycpu>
80105618:	39 c6                	cmp    %eax,%esi
8010561a:	0f 85 62 ff ff ff    	jne    80105582 <acquire+0x32>
  popcli();
80105620:	e8 1b fe ff ff       	call   80105440 <popcli>
  if (holding(lk) && lk->lock_holder_pid == cur_proc_pid)
80105625:	8b 75 08             	mov    0x8(%ebp),%esi
80105628:	39 5e 34             	cmp    %ebx,0x34(%esi)
8010562b:	0f 85 59 ff ff ff    	jne    8010558a <acquire+0x3a>
    popcli();
80105631:	e8 0a fe ff ff       	call   80105440 <popcli>
    return;
80105636:	eb c7                	jmp    801055ff <acquire+0xaf>
80105638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop
  for(; i < 10; i++)
80105640:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80105644:	8d 51 34             	lea    0x34(%ecx),%edx
80105647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105656:	83 c0 04             	add    $0x4,%eax
80105659:	39 d0                	cmp    %edx,%eax
8010565b:	75 f3                	jne    80105650 <acquire+0x100>
}
8010565d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105660:	5b                   	pop    %ebx
80105661:	5e                   	pop    %esi
80105662:	5d                   	pop    %ebp
80105663:	c3                   	ret    
80105664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105668:	8b 76 08             	mov    0x8(%esi),%esi
8010566b:	e8 70 e3 ff ff       	call   801039e0 <mycpu>
80105670:	39 c6                	cmp    %eax,%esi
80105672:	0f 85 21 ff ff ff    	jne    80105599 <acquire+0x49>
  popcli();
80105678:	e8 c3 fd ff ff       	call   80105440 <popcli>
  if(holding(lk) && lk->lock_holder_pid != cur_proc_pid)
8010567d:	8b 55 08             	mov    0x8(%ebp),%edx
80105680:	39 5a 34             	cmp    %ebx,0x34(%edx)
80105683:	0f 84 18 ff ff ff    	je     801055a1 <acquire+0x51>
    panic("acquire");
80105689:	83 ec 0c             	sub    $0xc,%esp
8010568c:	68 b1 8c 10 80       	push   $0x80108cb1
80105691:	e8 ea ac ff ff       	call   80100380 <panic>
80105696:	66 90                	xchg   %ax,%ax
80105698:	66 90                	xchg   %ax,%ax
8010569a:	66 90                	xchg   %ax,%ax
8010569c:	66 90                	xchg   %ax,%ax
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	8b 55 08             	mov    0x8(%ebp),%edx
801056a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801056aa:	53                   	push   %ebx
801056ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801056ae:	89 d7                	mov    %edx,%edi
801056b0:	09 cf                	or     %ecx,%edi
801056b2:	83 e7 03             	and    $0x3,%edi
801056b5:	75 29                	jne    801056e0 <memset+0x40>
    c &= 0xFF;
801056b7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801056ba:	c1 e0 18             	shl    $0x18,%eax
801056bd:	89 fb                	mov    %edi,%ebx
801056bf:	c1 e9 02             	shr    $0x2,%ecx
801056c2:	c1 e3 10             	shl    $0x10,%ebx
801056c5:	09 d8                	or     %ebx,%eax
801056c7:	09 f8                	or     %edi,%eax
801056c9:	c1 e7 08             	shl    $0x8,%edi
801056cc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801056ce:	89 d7                	mov    %edx,%edi
801056d0:	fc                   	cld    
801056d1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801056d3:	5b                   	pop    %ebx
801056d4:	89 d0                	mov    %edx,%eax
801056d6:	5f                   	pop    %edi
801056d7:	5d                   	pop    %ebp
801056d8:	c3                   	ret    
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801056e0:	89 d7                	mov    %edx,%edi
801056e2:	fc                   	cld    
801056e3:	f3 aa                	rep stos %al,%es:(%edi)
801056e5:	5b                   	pop    %ebx
801056e6:	89 d0                	mov    %edx,%eax
801056e8:	5f                   	pop    %edi
801056e9:	5d                   	pop    %ebp
801056ea:	c3                   	ret    
801056eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop

801056f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	56                   	push   %esi
801056f4:	8b 75 10             	mov    0x10(%ebp),%esi
801056f7:	8b 55 08             	mov    0x8(%ebp),%edx
801056fa:	53                   	push   %ebx
801056fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801056fe:	85 f6                	test   %esi,%esi
80105700:	74 2e                	je     80105730 <memcmp+0x40>
80105702:	01 c6                	add    %eax,%esi
80105704:	eb 14                	jmp    8010571a <memcmp+0x2a>
80105706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105710:	83 c0 01             	add    $0x1,%eax
80105713:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105716:	39 f0                	cmp    %esi,%eax
80105718:	74 16                	je     80105730 <memcmp+0x40>
    if(*s1 != *s2)
8010571a:	0f b6 0a             	movzbl (%edx),%ecx
8010571d:	0f b6 18             	movzbl (%eax),%ebx
80105720:	38 d9                	cmp    %bl,%cl
80105722:	74 ec                	je     80105710 <memcmp+0x20>
      return *s1 - *s2;
80105724:	0f b6 c1             	movzbl %cl,%eax
80105727:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105729:	5b                   	pop    %ebx
8010572a:	5e                   	pop    %esi
8010572b:	5d                   	pop    %ebp
8010572c:	c3                   	ret    
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
80105730:	5b                   	pop    %ebx
  return 0;
80105731:	31 c0                	xor    %eax,%eax
}
80105733:	5e                   	pop    %esi
80105734:	5d                   	pop    %ebp
80105735:	c3                   	ret    
80105736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573d:	8d 76 00             	lea    0x0(%esi),%esi

80105740 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	8b 55 08             	mov    0x8(%ebp),%edx
80105747:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010574a:	56                   	push   %esi
8010574b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010574e:	39 d6                	cmp    %edx,%esi
80105750:	73 26                	jae    80105778 <memmove+0x38>
80105752:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105755:	39 fa                	cmp    %edi,%edx
80105757:	73 1f                	jae    80105778 <memmove+0x38>
80105759:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010575c:	85 c9                	test   %ecx,%ecx
8010575e:	74 0c                	je     8010576c <memmove+0x2c>
      *--d = *--s;
80105760:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105764:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105767:	83 e8 01             	sub    $0x1,%eax
8010576a:	73 f4                	jae    80105760 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010576c:	5e                   	pop    %esi
8010576d:	89 d0                	mov    %edx,%eax
8010576f:	5f                   	pop    %edi
80105770:	5d                   	pop    %ebp
80105771:	c3                   	ret    
80105772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105778:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010577b:	89 d7                	mov    %edx,%edi
8010577d:	85 c9                	test   %ecx,%ecx
8010577f:	74 eb                	je     8010576c <memmove+0x2c>
80105781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105788:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105789:	39 c6                	cmp    %eax,%esi
8010578b:	75 fb                	jne    80105788 <memmove+0x48>
}
8010578d:	5e                   	pop    %esi
8010578e:	89 d0                	mov    %edx,%eax
80105790:	5f                   	pop    %edi
80105791:	5d                   	pop    %ebp
80105792:	c3                   	ret    
80105793:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801057a0:	eb 9e                	jmp    80105740 <memmove>
801057a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	56                   	push   %esi
801057b4:	8b 75 10             	mov    0x10(%ebp),%esi
801057b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057ba:	53                   	push   %ebx
801057bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801057be:	85 f6                	test   %esi,%esi
801057c0:	74 2e                	je     801057f0 <strncmp+0x40>
801057c2:	01 d6                	add    %edx,%esi
801057c4:	eb 18                	jmp    801057de <strncmp+0x2e>
801057c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
801057d0:	38 d8                	cmp    %bl,%al
801057d2:	75 14                	jne    801057e8 <strncmp+0x38>
    n--, p++, q++;
801057d4:	83 c2 01             	add    $0x1,%edx
801057d7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801057da:	39 f2                	cmp    %esi,%edx
801057dc:	74 12                	je     801057f0 <strncmp+0x40>
801057de:	0f b6 01             	movzbl (%ecx),%eax
801057e1:	0f b6 1a             	movzbl (%edx),%ebx
801057e4:	84 c0                	test   %al,%al
801057e6:	75 e8                	jne    801057d0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801057e8:	29 d8                	sub    %ebx,%eax
}
801057ea:	5b                   	pop    %ebx
801057eb:	5e                   	pop    %esi
801057ec:	5d                   	pop    %ebp
801057ed:	c3                   	ret    
801057ee:	66 90                	xchg   %ax,%ax
801057f0:	5b                   	pop    %ebx
    return 0;
801057f1:	31 c0                	xor    %eax,%eax
}
801057f3:	5e                   	pop    %esi
801057f4:	5d                   	pop    %ebp
801057f5:	c3                   	ret    
801057f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fd:	8d 76 00             	lea    0x0(%esi),%esi

80105800 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
80105805:	8b 75 08             	mov    0x8(%ebp),%esi
80105808:	53                   	push   %ebx
80105809:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010580c:	89 f0                	mov    %esi,%eax
8010580e:	eb 15                	jmp    80105825 <strncpy+0x25>
80105810:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105814:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105817:	83 c0 01             	add    $0x1,%eax
8010581a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010581e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105821:	84 d2                	test   %dl,%dl
80105823:	74 09                	je     8010582e <strncpy+0x2e>
80105825:	89 cb                	mov    %ecx,%ebx
80105827:	83 e9 01             	sub    $0x1,%ecx
8010582a:	85 db                	test   %ebx,%ebx
8010582c:	7f e2                	jg     80105810 <strncpy+0x10>
    ;
  while(n-- > 0)
8010582e:	89 c2                	mov    %eax,%edx
80105830:	85 c9                	test   %ecx,%ecx
80105832:	7e 17                	jle    8010584b <strncpy+0x4b>
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105838:	83 c2 01             	add    $0x1,%edx
8010583b:	89 c1                	mov    %eax,%ecx
8010583d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105841:	29 d1                	sub    %edx,%ecx
80105843:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105847:	85 c9                	test   %ecx,%ecx
80105849:	7f ed                	jg     80105838 <strncpy+0x38>
  return os;
}
8010584b:	5b                   	pop    %ebx
8010584c:	89 f0                	mov    %esi,%eax
8010584e:	5e                   	pop    %esi
8010584f:	5f                   	pop    %edi
80105850:	5d                   	pop    %ebp
80105851:	c3                   	ret    
80105852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105860 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	56                   	push   %esi
80105864:	8b 55 10             	mov    0x10(%ebp),%edx
80105867:	8b 75 08             	mov    0x8(%ebp),%esi
8010586a:	53                   	push   %ebx
8010586b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010586e:	85 d2                	test   %edx,%edx
80105870:	7e 25                	jle    80105897 <safestrcpy+0x37>
80105872:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105876:	89 f2                	mov    %esi,%edx
80105878:	eb 16                	jmp    80105890 <safestrcpy+0x30>
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105880:	0f b6 08             	movzbl (%eax),%ecx
80105883:	83 c0 01             	add    $0x1,%eax
80105886:	83 c2 01             	add    $0x1,%edx
80105889:	88 4a ff             	mov    %cl,-0x1(%edx)
8010588c:	84 c9                	test   %cl,%cl
8010588e:	74 04                	je     80105894 <safestrcpy+0x34>
80105890:	39 d8                	cmp    %ebx,%eax
80105892:	75 ec                	jne    80105880 <safestrcpy+0x20>
    ;
  *s = 0;
80105894:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105897:	89 f0                	mov    %esi,%eax
80105899:	5b                   	pop    %ebx
8010589a:	5e                   	pop    %esi
8010589b:	5d                   	pop    %ebp
8010589c:	c3                   	ret    
8010589d:	8d 76 00             	lea    0x0(%esi),%esi

801058a0 <strlen>:

int
strlen(const char *s)
{
801058a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801058a1:	31 c0                	xor    %eax,%eax
{
801058a3:	89 e5                	mov    %esp,%ebp
801058a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801058a8:	80 3a 00             	cmpb   $0x0,(%edx)
801058ab:	74 0c                	je     801058b9 <strlen+0x19>
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
801058b0:	83 c0 01             	add    $0x1,%eax
801058b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801058b7:	75 f7                	jne    801058b0 <strlen+0x10>
    ;
  return n;
}
801058b9:	5d                   	pop    %ebp
801058ba:	c3                   	ret    

801058bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801058bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801058bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801058c3:	55                   	push   %ebp
  pushl %ebx
801058c4:	53                   	push   %ebx
  pushl %esi
801058c5:	56                   	push   %esi
  pushl %edi
801058c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801058c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801058c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801058cb:	5f                   	pop    %edi
  popl %esi
801058cc:	5e                   	pop    %esi
  popl %ebx
801058cd:	5b                   	pop    %ebx
  popl %ebp
801058ce:	5d                   	pop    %ebp
  ret
801058cf:	c3                   	ret    

801058d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
801058d4:	83 ec 04             	sub    $0x4,%esp
801058d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801058da:	e8 81 e1 ff ff       	call   80103a60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801058df:	8b 00                	mov    (%eax),%eax
801058e1:	39 d8                	cmp    %ebx,%eax
801058e3:	76 1b                	jbe    80105900 <fetchint+0x30>
801058e5:	8d 53 04             	lea    0x4(%ebx),%edx
801058e8:	39 d0                	cmp    %edx,%eax
801058ea:	72 14                	jb     80105900 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801058ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ef:	8b 13                	mov    (%ebx),%edx
801058f1:	89 10                	mov    %edx,(%eax)
  return 0;
801058f3:	31 c0                	xor    %eax,%eax
}
801058f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058f8:	c9                   	leave  
801058f9:	c3                   	ret    
801058fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105905:	eb ee                	jmp    801058f5 <fetchint+0x25>
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
80105914:	83 ec 04             	sub    $0x4,%esp
80105917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010591a:	e8 41 e1 ff ff       	call   80103a60 <myproc>

  if(addr >= curproc->sz)
8010591f:	39 18                	cmp    %ebx,(%eax)
80105921:	76 2d                	jbe    80105950 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105923:	8b 55 0c             	mov    0xc(%ebp),%edx
80105926:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105928:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010592a:	39 d3                	cmp    %edx,%ebx
8010592c:	73 22                	jae    80105950 <fetchstr+0x40>
8010592e:	89 d8                	mov    %ebx,%eax
80105930:	eb 0d                	jmp    8010593f <fetchstr+0x2f>
80105932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105938:	83 c0 01             	add    $0x1,%eax
8010593b:	39 c2                	cmp    %eax,%edx
8010593d:	76 11                	jbe    80105950 <fetchstr+0x40>
    if(*s == 0)
8010593f:	80 38 00             	cmpb   $0x0,(%eax)
80105942:	75 f4                	jne    80105938 <fetchstr+0x28>
      return s - *pp;
80105944:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105949:	c9                   	leave  
8010594a:	c3                   	ret    
8010594b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010594f:	90                   	nop
80105950:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105953:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105958:	c9                   	leave  
80105959:	c3                   	ret    
8010595a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105960 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	56                   	push   %esi
80105964:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105965:	e8 f6 e0 ff ff       	call   80103a60 <myproc>
8010596a:	8b 55 08             	mov    0x8(%ebp),%edx
8010596d:	8b 40 18             	mov    0x18(%eax),%eax
80105970:	8b 40 44             	mov    0x44(%eax),%eax
80105973:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105976:	e8 e5 e0 ff ff       	call   80103a60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010597b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010597e:	8b 00                	mov    (%eax),%eax
80105980:	39 c6                	cmp    %eax,%esi
80105982:	73 1c                	jae    801059a0 <argint+0x40>
80105984:	8d 53 08             	lea    0x8(%ebx),%edx
80105987:	39 d0                	cmp    %edx,%eax
80105989:	72 15                	jb     801059a0 <argint+0x40>
  *ip = *(int*)(addr);
8010598b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010598e:	8b 53 04             	mov    0x4(%ebx),%edx
80105991:	89 10                	mov    %edx,(%eax)
  return 0;
80105993:	31 c0                	xor    %eax,%eax
}
80105995:	5b                   	pop    %ebx
80105996:	5e                   	pop    %esi
80105997:	5d                   	pop    %ebp
80105998:	c3                   	ret    
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801059a5:	eb ee                	jmp    80105995 <argint+0x35>
801059a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
801059b6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801059b9:	e8 a2 e0 ff ff       	call   80103a60 <myproc>
801059be:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801059c0:	e8 9b e0 ff ff       	call   80103a60 <myproc>
801059c5:	8b 55 08             	mov    0x8(%ebp),%edx
801059c8:	8b 40 18             	mov    0x18(%eax),%eax
801059cb:	8b 40 44             	mov    0x44(%eax),%eax
801059ce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801059d1:	e8 8a e0 ff ff       	call   80103a60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801059d6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801059d9:	8b 00                	mov    (%eax),%eax
801059db:	39 c7                	cmp    %eax,%edi
801059dd:	73 31                	jae    80105a10 <argptr+0x60>
801059df:	8d 4b 08             	lea    0x8(%ebx),%ecx
801059e2:	39 c8                	cmp    %ecx,%eax
801059e4:	72 2a                	jb     80105a10 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801059e6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801059e9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801059ec:	85 d2                	test   %edx,%edx
801059ee:	78 20                	js     80105a10 <argptr+0x60>
801059f0:	8b 16                	mov    (%esi),%edx
801059f2:	39 c2                	cmp    %eax,%edx
801059f4:	76 1a                	jbe    80105a10 <argptr+0x60>
801059f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801059f9:	01 c3                	add    %eax,%ebx
801059fb:	39 da                	cmp    %ebx,%edx
801059fd:	72 11                	jb     80105a10 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801059ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a02:	89 02                	mov    %eax,(%edx)
  return 0;
80105a04:	31 c0                	xor    %eax,%eax
}
80105a06:	83 c4 0c             	add    $0xc,%esp
80105a09:	5b                   	pop    %ebx
80105a0a:	5e                   	pop    %esi
80105a0b:	5f                   	pop    %edi
80105a0c:	5d                   	pop    %ebp
80105a0d:	c3                   	ret    
80105a0e:	66 90                	xchg   %ax,%ax
    return -1;
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a15:	eb ef                	jmp    80105a06 <argptr+0x56>
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	56                   	push   %esi
80105a24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105a25:	e8 36 e0 ff ff       	call   80103a60 <myproc>
80105a2a:	8b 55 08             	mov    0x8(%ebp),%edx
80105a2d:	8b 40 18             	mov    0x18(%eax),%eax
80105a30:	8b 40 44             	mov    0x44(%eax),%eax
80105a33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105a36:	e8 25 e0 ff ff       	call   80103a60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105a3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105a3e:	8b 00                	mov    (%eax),%eax
80105a40:	39 c6                	cmp    %eax,%esi
80105a42:	73 44                	jae    80105a88 <argstr+0x68>
80105a44:	8d 53 08             	lea    0x8(%ebx),%edx
80105a47:	39 d0                	cmp    %edx,%eax
80105a49:	72 3d                	jb     80105a88 <argstr+0x68>
  *ip = *(int*)(addr);
80105a4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105a4e:	e8 0d e0 ff ff       	call   80103a60 <myproc>
  if(addr >= curproc->sz)
80105a53:	3b 18                	cmp    (%eax),%ebx
80105a55:	73 31                	jae    80105a88 <argstr+0x68>
  *pp = (char*)addr;
80105a57:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105a5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105a5e:	39 d3                	cmp    %edx,%ebx
80105a60:	73 26                	jae    80105a88 <argstr+0x68>
80105a62:	89 d8                	mov    %ebx,%eax
80105a64:	eb 11                	jmp    80105a77 <argstr+0x57>
80105a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi
80105a70:	83 c0 01             	add    $0x1,%eax
80105a73:	39 c2                	cmp    %eax,%edx
80105a75:	76 11                	jbe    80105a88 <argstr+0x68>
    if(*s == 0)
80105a77:	80 38 00             	cmpb   $0x0,(%eax)
80105a7a:	75 f4                	jne    80105a70 <argstr+0x50>
      return s - *pp;
80105a7c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105a7e:	5b                   	pop    %ebx
80105a7f:	5e                   	pop    %esi
80105a80:	5d                   	pop    %ebp
80105a81:	c3                   	ret    
80105a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a88:	5b                   	pop    %ebx
    return -1;
80105a89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a8e:	5e                   	pop    %esi
80105a8f:	5d                   	pop    %ebp
80105a90:	c3                   	ret    
80105a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop

80105aa0 <syscall>:
[SYS_release_rl]               sys_release_rl,
};

void
syscall(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
80105aa4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105aa7:	e8 b4 df ff ff       	call   80103a60 <myproc>
80105aac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105aae:	8b 40 18             	mov    0x18(%eax),%eax
80105ab1:	8b 40 1c             	mov    0x1c(%eax),%eax
  int *cntsys = curproc -> syscnt;
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105ab4:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ab7:	83 fa 22             	cmp    $0x22,%edx
80105aba:	77 24                	ja     80105ae0 <syscall+0x40>
80105abc:	8b 14 85 e0 8c 10 80 	mov    -0x7fef7320(,%eax,4),%edx
80105ac3:	85 d2                	test   %edx,%edx
80105ac5:	74 19                	je     80105ae0 <syscall+0x40>
    *(cntsys + num -1 ) = *(cntsys+num-1)+1;
80105ac7:	83 44 83 78 01       	addl   $0x1,0x78(%ebx,%eax,4)
    curproc->tf->eax = syscalls[num]();
80105acc:	ff d2                	call   *%edx
80105ace:	89 c2                	mov    %eax,%edx
80105ad0:	8b 43 18             	mov    0x18(%ebx),%eax
80105ad3:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad9:	c9                   	leave  
80105ada:	c3                   	ret    
80105adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop
    cprintf("%d %s: unknown sys call %d\n",
80105ae0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105ae1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105ae4:	50                   	push   %eax
80105ae5:	ff 73 10             	push   0x10(%ebx)
80105ae8:	68 b9 8c 10 80       	push   $0x80108cb9
80105aed:	e8 ae ab ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105af2:	8b 43 18             	mov    0x18(%ebx),%eax
80105af5:	83 c4 10             	add    $0x10,%esp
80105af8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b02:	c9                   	leave  
80105b03:	c3                   	ret    
80105b04:	66 90                	xchg   %ax,%ax
80105b06:	66 90                	xchg   %ax,%ax
80105b08:	66 90                	xchg   %ax,%ax
80105b0a:	66 90                	xchg   %ax,%ax
80105b0c:	66 90                	xchg   %ax,%ax
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105b15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105b18:	53                   	push   %ebx
80105b19:	83 ec 34             	sub    $0x34,%esp
80105b1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105b22:	57                   	push   %edi
80105b23:	50                   	push   %eax
{
80105b24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105b27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105b2a:	e8 91 c5 ff ff       	call   801020c0 <nameiparent>
80105b2f:	83 c4 10             	add    $0x10,%esp
80105b32:	85 c0                	test   %eax,%eax
80105b34:	0f 84 46 01 00 00    	je     80105c80 <create+0x170>
    return 0;
  ilock(dp);
80105b3a:	83 ec 0c             	sub    $0xc,%esp
80105b3d:	89 c3                	mov    %eax,%ebx
80105b3f:	50                   	push   %eax
80105b40:	e8 3b bc ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105b45:	83 c4 0c             	add    $0xc,%esp
80105b48:	6a 00                	push   $0x0
80105b4a:	57                   	push   %edi
80105b4b:	53                   	push   %ebx
80105b4c:	e8 8f c1 ff ff       	call   80101ce0 <dirlookup>
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	89 c6                	mov    %eax,%esi
80105b56:	85 c0                	test   %eax,%eax
80105b58:	74 56                	je     80105bb0 <create+0xa0>
    iunlockput(dp);
80105b5a:	83 ec 0c             	sub    $0xc,%esp
80105b5d:	53                   	push   %ebx
80105b5e:	e8 ad be ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105b63:	89 34 24             	mov    %esi,(%esp)
80105b66:	e8 15 bc ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105b6b:	83 c4 10             	add    $0x10,%esp
80105b6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105b73:	75 1b                	jne    80105b90 <create+0x80>
80105b75:	66 83 7e 54 02       	cmpw   $0x2,0x54(%esi)
80105b7a:	75 14                	jne    80105b90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b7f:	89 f0                	mov    %esi,%eax
80105b81:	5b                   	pop    %ebx
80105b82:	5e                   	pop    %esi
80105b83:	5f                   	pop    %edi
80105b84:	5d                   	pop    %ebp
80105b85:	c3                   	ret    
80105b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	56                   	push   %esi
    return 0;
80105b94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105b96:	e8 75 be ff ff       	call   80101a10 <iunlockput>
    return 0;
80105b9b:	83 c4 10             	add    $0x10,%esp
}
80105b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba1:	89 f0                	mov    %esi,%eax
80105ba3:	5b                   	pop    %ebx
80105ba4:	5e                   	pop    %esi
80105ba5:	5f                   	pop    %edi
80105ba6:	5d                   	pop    %ebp
80105ba7:	c3                   	ret    
80105ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105baf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105bb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105bb4:	83 ec 08             	sub    $0x8,%esp
80105bb7:	50                   	push   %eax
80105bb8:	ff 33                	push   (%ebx)
80105bba:	e8 51 ba ff ff       	call   80101610 <ialloc>
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	89 c6                	mov    %eax,%esi
80105bc4:	85 c0                	test   %eax,%eax
80105bc6:	0f 84 cd 00 00 00    	je     80105c99 <create+0x189>
  ilock(ip);
80105bcc:	83 ec 0c             	sub    $0xc,%esp
80105bcf:	50                   	push   %eax
80105bd0:	e8 ab bb ff ff       	call   80101780 <ilock>
  ip->major = major;
80105bd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105bd9:	66 89 46 56          	mov    %ax,0x56(%esi)
  ip->minor = minor;
80105bdd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105be1:	66 89 46 58          	mov    %ax,0x58(%esi)
  ip->nlink = 1;
80105be5:	b8 01 00 00 00       	mov    $0x1,%eax
80105bea:	66 89 46 5a          	mov    %ax,0x5a(%esi)
  iupdate(ip);
80105bee:	89 34 24             	mov    %esi,(%esp)
80105bf1:	e8 da ba ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105bfe:	74 30                	je     80105c30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105c00:	83 ec 04             	sub    $0x4,%esp
80105c03:	ff 76 04             	push   0x4(%esi)
80105c06:	57                   	push   %edi
80105c07:	53                   	push   %ebx
80105c08:	e8 d3 c3 ff ff       	call   80101fe0 <dirlink>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	85 c0                	test   %eax,%eax
80105c12:	78 78                	js     80105c8c <create+0x17c>
  iunlockput(dp);
80105c14:	83 ec 0c             	sub    $0xc,%esp
80105c17:	53                   	push   %ebx
80105c18:	e8 f3 bd ff ff       	call   80101a10 <iunlockput>
  return ip;
80105c1d:	83 c4 10             	add    $0x10,%esp
}
80105c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c23:	89 f0                	mov    %esi,%eax
80105c25:	5b                   	pop    %ebx
80105c26:	5e                   	pop    %esi
80105c27:	5f                   	pop    %edi
80105c28:	5d                   	pop    %ebp
80105c29:	c3                   	ret    
80105c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105c30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105c33:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
    iupdate(dp);
80105c38:	53                   	push   %ebx
80105c39:	e8 92 ba ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105c3e:	83 c4 0c             	add    $0xc,%esp
80105c41:	ff 76 04             	push   0x4(%esi)
80105c44:	68 8c 8d 10 80       	push   $0x80108d8c
80105c49:	56                   	push   %esi
80105c4a:	e8 91 c3 ff ff       	call   80101fe0 <dirlink>
80105c4f:	83 c4 10             	add    $0x10,%esp
80105c52:	85 c0                	test   %eax,%eax
80105c54:	78 18                	js     80105c6e <create+0x15e>
80105c56:	83 ec 04             	sub    $0x4,%esp
80105c59:	ff 73 04             	push   0x4(%ebx)
80105c5c:	68 8b 8d 10 80       	push   $0x80108d8b
80105c61:	56                   	push   %esi
80105c62:	e8 79 c3 ff ff       	call   80101fe0 <dirlink>
80105c67:	83 c4 10             	add    $0x10,%esp
80105c6a:	85 c0                	test   %eax,%eax
80105c6c:	79 92                	jns    80105c00 <create+0xf0>
      panic("create dots");
80105c6e:	83 ec 0c             	sub    $0xc,%esp
80105c71:	68 7f 8d 10 80       	push   $0x80108d7f
80105c76:	e8 05 a7 ff ff       	call   80100380 <panic>
80105c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
}
80105c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105c83:	31 f6                	xor    %esi,%esi
}
80105c85:	5b                   	pop    %ebx
80105c86:	89 f0                	mov    %esi,%eax
80105c88:	5e                   	pop    %esi
80105c89:	5f                   	pop    %edi
80105c8a:	5d                   	pop    %ebp
80105c8b:	c3                   	ret    
    panic("create: dirlink");
80105c8c:	83 ec 0c             	sub    $0xc,%esp
80105c8f:	68 8e 8d 10 80       	push   $0x80108d8e
80105c94:	e8 e7 a6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105c99:	83 ec 0c             	sub    $0xc,%esp
80105c9c:	68 70 8d 10 80       	push   $0x80108d70
80105ca1:	e8 da a6 ff ff       	call   80100380 <panic>
80105ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cad:	8d 76 00             	lea    0x0(%esi),%esi

80105cb0 <sys_dup>:
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	56                   	push   %esi
80105cb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105cb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105cbb:	50                   	push   %eax
80105cbc:	6a 00                	push   $0x0
80105cbe:	e8 9d fc ff ff       	call   80105960 <argint>
80105cc3:	83 c4 10             	add    $0x10,%esp
80105cc6:	85 c0                	test   %eax,%eax
80105cc8:	78 36                	js     80105d00 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105cca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105cce:	77 30                	ja     80105d00 <sys_dup+0x50>
80105cd0:	e8 8b dd ff ff       	call   80103a60 <myproc>
80105cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105cdc:	85 f6                	test   %esi,%esi
80105cde:	74 20                	je     80105d00 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105ce0:	e8 7b dd ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ce5:	31 db                	xor    %ebx,%ebx
80105ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105cf0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105cf4:	85 d2                	test   %edx,%edx
80105cf6:	74 18                	je     80105d10 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105cf8:	83 c3 01             	add    $0x1,%ebx
80105cfb:	83 fb 10             	cmp    $0x10,%ebx
80105cfe:	75 f0                	jne    80105cf0 <sys_dup+0x40>
}
80105d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105d03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105d08:	89 d8                	mov    %ebx,%eax
80105d0a:	5b                   	pop    %ebx
80105d0b:	5e                   	pop    %esi
80105d0c:	5d                   	pop    %ebp
80105d0d:	c3                   	ret    
80105d0e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105d10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105d13:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105d17:	56                   	push   %esi
80105d18:	e8 83 b1 ff ff       	call   80100ea0 <filedup>
  return fd;
80105d1d:	83 c4 10             	add    $0x10,%esp
}
80105d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d23:	89 d8                	mov    %ebx,%eax
80105d25:	5b                   	pop    %ebx
80105d26:	5e                   	pop    %esi
80105d27:	5d                   	pop    %ebp
80105d28:	c3                   	ret    
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_read>:
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	56                   	push   %esi
80105d34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105d35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105d38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105d3b:	53                   	push   %ebx
80105d3c:	6a 00                	push   $0x0
80105d3e:	e8 1d fc ff ff       	call   80105960 <argint>
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	85 c0                	test   %eax,%eax
80105d48:	78 5e                	js     80105da8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105d4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105d4e:	77 58                	ja     80105da8 <sys_read+0x78>
80105d50:	e8 0b dd ff ff       	call   80103a60 <myproc>
80105d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105d5c:	85 f6                	test   %esi,%esi
80105d5e:	74 48                	je     80105da8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d60:	83 ec 08             	sub    $0x8,%esp
80105d63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d66:	50                   	push   %eax
80105d67:	6a 02                	push   $0x2
80105d69:	e8 f2 fb ff ff       	call   80105960 <argint>
80105d6e:	83 c4 10             	add    $0x10,%esp
80105d71:	85 c0                	test   %eax,%eax
80105d73:	78 33                	js     80105da8 <sys_read+0x78>
80105d75:	83 ec 04             	sub    $0x4,%esp
80105d78:	ff 75 f0             	push   -0x10(%ebp)
80105d7b:	53                   	push   %ebx
80105d7c:	6a 01                	push   $0x1
80105d7e:	e8 2d fc ff ff       	call   801059b0 <argptr>
80105d83:	83 c4 10             	add    $0x10,%esp
80105d86:	85 c0                	test   %eax,%eax
80105d88:	78 1e                	js     80105da8 <sys_read+0x78>
  return fileread(f, p, n);
80105d8a:	83 ec 04             	sub    $0x4,%esp
80105d8d:	ff 75 f0             	push   -0x10(%ebp)
80105d90:	ff 75 f4             	push   -0xc(%ebp)
80105d93:	56                   	push   %esi
80105d94:	e8 87 b2 ff ff       	call   80101020 <fileread>
80105d99:	83 c4 10             	add    $0x10,%esp
}
80105d9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d9f:	5b                   	pop    %ebx
80105da0:	5e                   	pop    %esi
80105da1:	5d                   	pop    %ebp
80105da2:	c3                   	ret    
80105da3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105da7:	90                   	nop
    return -1;
80105da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dad:	eb ed                	jmp    80105d9c <sys_read+0x6c>
80105daf:	90                   	nop

80105db0 <sys_write>:
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	56                   	push   %esi
80105db4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105db5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105db8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105dbb:	53                   	push   %ebx
80105dbc:	6a 00                	push   $0x0
80105dbe:	e8 9d fb ff ff       	call   80105960 <argint>
80105dc3:	83 c4 10             	add    $0x10,%esp
80105dc6:	85 c0                	test   %eax,%eax
80105dc8:	78 5e                	js     80105e28 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105dca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105dce:	77 58                	ja     80105e28 <sys_write+0x78>
80105dd0:	e8 8b dc ff ff       	call   80103a60 <myproc>
80105dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105ddc:	85 f6                	test   %esi,%esi
80105dde:	74 48                	je     80105e28 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105de0:	83 ec 08             	sub    $0x8,%esp
80105de3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105de6:	50                   	push   %eax
80105de7:	6a 02                	push   $0x2
80105de9:	e8 72 fb ff ff       	call   80105960 <argint>
80105dee:	83 c4 10             	add    $0x10,%esp
80105df1:	85 c0                	test   %eax,%eax
80105df3:	78 33                	js     80105e28 <sys_write+0x78>
80105df5:	83 ec 04             	sub    $0x4,%esp
80105df8:	ff 75 f0             	push   -0x10(%ebp)
80105dfb:	53                   	push   %ebx
80105dfc:	6a 01                	push   $0x1
80105dfe:	e8 ad fb ff ff       	call   801059b0 <argptr>
80105e03:	83 c4 10             	add    $0x10,%esp
80105e06:	85 c0                	test   %eax,%eax
80105e08:	78 1e                	js     80105e28 <sys_write+0x78>
  return filewrite(f, p, n);
80105e0a:	83 ec 04             	sub    $0x4,%esp
80105e0d:	ff 75 f0             	push   -0x10(%ebp)
80105e10:	ff 75 f4             	push   -0xc(%ebp)
80105e13:	56                   	push   %esi
80105e14:	e8 97 b2 ff ff       	call   801010b0 <filewrite>
80105e19:	83 c4 10             	add    $0x10,%esp
}
80105e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e1f:	5b                   	pop    %ebx
80105e20:	5e                   	pop    %esi
80105e21:	5d                   	pop    %ebp
80105e22:	c3                   	ret    
80105e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e27:	90                   	nop
    return -1;
80105e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2d:	eb ed                	jmp    80105e1c <sys_write+0x6c>
80105e2f:	90                   	nop

80105e30 <sys_close>:
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	56                   	push   %esi
80105e34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105e3b:	50                   	push   %eax
80105e3c:	6a 00                	push   $0x0
80105e3e:	e8 1d fb ff ff       	call   80105960 <argint>
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	85 c0                	test   %eax,%eax
80105e48:	78 3e                	js     80105e88 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105e4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105e4e:	77 38                	ja     80105e88 <sys_close+0x58>
80105e50:	e8 0b dc ff ff       	call   80103a60 <myproc>
80105e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e58:	8d 5a 08             	lea    0x8(%edx),%ebx
80105e5b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105e5f:	85 f6                	test   %esi,%esi
80105e61:	74 25                	je     80105e88 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105e63:	e8 f8 db ff ff       	call   80103a60 <myproc>
  fileclose(f);
80105e68:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105e6b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105e72:	00 
  fileclose(f);
80105e73:	56                   	push   %esi
80105e74:	e8 77 b0 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105e79:	83 c4 10             	add    $0x10,%esp
80105e7c:	31 c0                	xor    %eax,%eax
}
80105e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e81:	5b                   	pop    %ebx
80105e82:	5e                   	pop    %esi
80105e83:	5d                   	pop    %ebp
80105e84:	c3                   	ret    
80105e85:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8d:	eb ef                	jmp    80105e7e <sys_close+0x4e>
80105e8f:	90                   	nop

80105e90 <sys_fstat>:
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	56                   	push   %esi
80105e94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105e95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105e98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105e9b:	53                   	push   %ebx
80105e9c:	6a 00                	push   $0x0
80105e9e:	e8 bd fa ff ff       	call   80105960 <argint>
80105ea3:	83 c4 10             	add    $0x10,%esp
80105ea6:	85 c0                	test   %eax,%eax
80105ea8:	78 46                	js     80105ef0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105eaa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105eae:	77 40                	ja     80105ef0 <sys_fstat+0x60>
80105eb0:	e8 ab db ff ff       	call   80103a60 <myproc>
80105eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105eb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105ebc:	85 f6                	test   %esi,%esi
80105ebe:	74 30                	je     80105ef0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ec0:	83 ec 04             	sub    $0x4,%esp
80105ec3:	6a 14                	push   $0x14
80105ec5:	53                   	push   %ebx
80105ec6:	6a 01                	push   $0x1
80105ec8:	e8 e3 fa ff ff       	call   801059b0 <argptr>
80105ecd:	83 c4 10             	add    $0x10,%esp
80105ed0:	85 c0                	test   %eax,%eax
80105ed2:	78 1c                	js     80105ef0 <sys_fstat+0x60>
  return filestat(f, st);
80105ed4:	83 ec 08             	sub    $0x8,%esp
80105ed7:	ff 75 f4             	push   -0xc(%ebp)
80105eda:	56                   	push   %esi
80105edb:	e8 f0 b0 ff ff       	call   80100fd0 <filestat>
80105ee0:	83 c4 10             	add    $0x10,%esp
}
80105ee3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ee6:	5b                   	pop    %ebx
80105ee7:	5e                   	pop    %esi
80105ee8:	5d                   	pop    %ebp
80105ee9:	c3                   	ret    
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef5:	eb ec                	jmp    80105ee3 <sys_fstat+0x53>
80105ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efe:	66 90                	xchg   %ax,%ax

80105f00 <sys_link>:
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	57                   	push   %edi
80105f04:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105f05:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105f08:	53                   	push   %ebx
80105f09:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105f0c:	50                   	push   %eax
80105f0d:	6a 00                	push   $0x0
80105f0f:	e8 0c fb ff ff       	call   80105a20 <argstr>
80105f14:	83 c4 10             	add    $0x10,%esp
80105f17:	85 c0                	test   %eax,%eax
80105f19:	0f 88 fb 00 00 00    	js     8010601a <sys_link+0x11a>
80105f1f:	83 ec 08             	sub    $0x8,%esp
80105f22:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105f25:	50                   	push   %eax
80105f26:	6a 01                	push   $0x1
80105f28:	e8 f3 fa ff ff       	call   80105a20 <argstr>
80105f2d:	83 c4 10             	add    $0x10,%esp
80105f30:	85 c0                	test   %eax,%eax
80105f32:	0f 88 e2 00 00 00    	js     8010601a <sys_link+0x11a>
  begin_op();
80105f38:	e8 23 ce ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80105f3d:	83 ec 0c             	sub    $0xc,%esp
80105f40:	ff 75 d4             	push   -0x2c(%ebp)
80105f43:	e8 58 c1 ff ff       	call   801020a0 <namei>
80105f48:	83 c4 10             	add    $0x10,%esp
80105f4b:	89 c3                	mov    %eax,%ebx
80105f4d:	85 c0                	test   %eax,%eax
80105f4f:	0f 84 e4 00 00 00    	je     80106039 <sys_link+0x139>
  ilock(ip);
80105f55:	83 ec 0c             	sub    $0xc,%esp
80105f58:	50                   	push   %eax
80105f59:	e8 22 b8 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80105f5e:	83 c4 10             	add    $0x10,%esp
80105f61:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105f66:	0f 84 b5 00 00 00    	je     80106021 <sys_link+0x121>
  iupdate(ip);
80105f6c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105f6f:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105f74:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105f77:	53                   	push   %ebx
80105f78:	e8 53 b7 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105f7d:	89 1c 24             	mov    %ebx,(%esp)
80105f80:	e8 db b8 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105f85:	58                   	pop    %eax
80105f86:	5a                   	pop    %edx
80105f87:	57                   	push   %edi
80105f88:	ff 75 d0             	push   -0x30(%ebp)
80105f8b:	e8 30 c1 ff ff       	call   801020c0 <nameiparent>
80105f90:	83 c4 10             	add    $0x10,%esp
80105f93:	89 c6                	mov    %eax,%esi
80105f95:	85 c0                	test   %eax,%eax
80105f97:	74 5b                	je     80105ff4 <sys_link+0xf4>
  ilock(dp);
80105f99:	83 ec 0c             	sub    $0xc,%esp
80105f9c:	50                   	push   %eax
80105f9d:	e8 de b7 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105fa2:	8b 03                	mov    (%ebx),%eax
80105fa4:	83 c4 10             	add    $0x10,%esp
80105fa7:	39 06                	cmp    %eax,(%esi)
80105fa9:	75 3d                	jne    80105fe8 <sys_link+0xe8>
80105fab:	83 ec 04             	sub    $0x4,%esp
80105fae:	ff 73 04             	push   0x4(%ebx)
80105fb1:	57                   	push   %edi
80105fb2:	56                   	push   %esi
80105fb3:	e8 28 c0 ff ff       	call   80101fe0 <dirlink>
80105fb8:	83 c4 10             	add    $0x10,%esp
80105fbb:	85 c0                	test   %eax,%eax
80105fbd:	78 29                	js     80105fe8 <sys_link+0xe8>
  iunlockput(dp);
80105fbf:	83 ec 0c             	sub    $0xc,%esp
80105fc2:	56                   	push   %esi
80105fc3:	e8 48 ba ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105fc8:	89 1c 24             	mov    %ebx,(%esp)
80105fcb:	e8 e0 b8 ff ff       	call   801018b0 <iput>
  end_op();
80105fd0:	e8 fb cd ff ff       	call   80102dd0 <end_op>
  return 0;
80105fd5:	83 c4 10             	add    $0x10,%esp
80105fd8:	31 c0                	xor    %eax,%eax
}
80105fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fdd:	5b                   	pop    %ebx
80105fde:	5e                   	pop    %esi
80105fdf:	5f                   	pop    %edi
80105fe0:	5d                   	pop    %ebp
80105fe1:	c3                   	ret    
80105fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105fe8:	83 ec 0c             	sub    $0xc,%esp
80105feb:	56                   	push   %esi
80105fec:	e8 1f ba ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105ff1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	53                   	push   %ebx
80105ff8:	e8 83 b7 ff ff       	call   80101780 <ilock>
  ip->nlink--;
80105ffd:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
80106002:	89 1c 24             	mov    %ebx,(%esp)
80106005:	e8 c6 b6 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010600a:	89 1c 24             	mov    %ebx,(%esp)
8010600d:	e8 fe b9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106012:	e8 b9 cd ff ff       	call   80102dd0 <end_op>
  return -1;
80106017:	83 c4 10             	add    $0x10,%esp
8010601a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601f:	eb b9                	jmp    80105fda <sys_link+0xda>
    iunlockput(ip);
80106021:	83 ec 0c             	sub    $0xc,%esp
80106024:	53                   	push   %ebx
80106025:	e8 e6 b9 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010602a:	e8 a1 cd ff ff       	call   80102dd0 <end_op>
    return -1;
8010602f:	83 c4 10             	add    $0x10,%esp
80106032:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106037:	eb a1                	jmp    80105fda <sys_link+0xda>
    end_op();
80106039:	e8 92 cd ff ff       	call   80102dd0 <end_op>
    return -1;
8010603e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106043:	eb 95                	jmp    80105fda <sys_link+0xda>
80106045:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106050 <sys_unlink>:
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	57                   	push   %edi
80106054:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106055:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106058:	53                   	push   %ebx
80106059:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010605c:	50                   	push   %eax
8010605d:	6a 00                	push   $0x0
8010605f:	e8 bc f9 ff ff       	call   80105a20 <argstr>
80106064:	83 c4 10             	add    $0x10,%esp
80106067:	85 c0                	test   %eax,%eax
80106069:	0f 88 7a 01 00 00    	js     801061e9 <sys_unlink+0x199>
  begin_op();
8010606f:	e8 ec cc ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106074:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106077:	83 ec 08             	sub    $0x8,%esp
8010607a:	53                   	push   %ebx
8010607b:	ff 75 c0             	push   -0x40(%ebp)
8010607e:	e8 3d c0 ff ff       	call   801020c0 <nameiparent>
80106083:	83 c4 10             	add    $0x10,%esp
80106086:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106089:	85 c0                	test   %eax,%eax
8010608b:	0f 84 62 01 00 00    	je     801061f3 <sys_unlink+0x1a3>
  ilock(dp);
80106091:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106094:	83 ec 0c             	sub    $0xc,%esp
80106097:	57                   	push   %edi
80106098:	e8 e3 b6 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010609d:	58                   	pop    %eax
8010609e:	5a                   	pop    %edx
8010609f:	68 8c 8d 10 80       	push   $0x80108d8c
801060a4:	53                   	push   %ebx
801060a5:	e8 16 bc ff ff       	call   80101cc0 <namecmp>
801060aa:	83 c4 10             	add    $0x10,%esp
801060ad:	85 c0                	test   %eax,%eax
801060af:	0f 84 fb 00 00 00    	je     801061b0 <sys_unlink+0x160>
801060b5:	83 ec 08             	sub    $0x8,%esp
801060b8:	68 8b 8d 10 80       	push   $0x80108d8b
801060bd:	53                   	push   %ebx
801060be:	e8 fd bb ff ff       	call   80101cc0 <namecmp>
801060c3:	83 c4 10             	add    $0x10,%esp
801060c6:	85 c0                	test   %eax,%eax
801060c8:	0f 84 e2 00 00 00    	je     801061b0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801060ce:	83 ec 04             	sub    $0x4,%esp
801060d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801060d4:	50                   	push   %eax
801060d5:	53                   	push   %ebx
801060d6:	57                   	push   %edi
801060d7:	e8 04 bc ff ff       	call   80101ce0 <dirlookup>
801060dc:	83 c4 10             	add    $0x10,%esp
801060df:	89 c3                	mov    %eax,%ebx
801060e1:	85 c0                	test   %eax,%eax
801060e3:	0f 84 c7 00 00 00    	je     801061b0 <sys_unlink+0x160>
  ilock(ip);
801060e9:	83 ec 0c             	sub    $0xc,%esp
801060ec:	50                   	push   %eax
801060ed:	e8 8e b6 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801060f2:	83 c4 10             	add    $0x10,%esp
801060f5:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
801060fa:	0f 8e 1c 01 00 00    	jle    8010621c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106100:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80106105:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106108:	74 66                	je     80106170 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010610a:	83 ec 04             	sub    $0x4,%esp
8010610d:	6a 10                	push   $0x10
8010610f:	6a 00                	push   $0x0
80106111:	57                   	push   %edi
80106112:	e8 89 f5 ff ff       	call   801056a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106117:	6a 10                	push   $0x10
80106119:	ff 75 c4             	push   -0x3c(%ebp)
8010611c:	57                   	push   %edi
8010611d:	ff 75 b4             	push   -0x4c(%ebp)
80106120:	e8 6b ba ff ff       	call   80101b90 <writei>
80106125:	83 c4 20             	add    $0x20,%esp
80106128:	83 f8 10             	cmp    $0x10,%eax
8010612b:	0f 85 de 00 00 00    	jne    8010620f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80106131:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80106136:	0f 84 94 00 00 00    	je     801061d0 <sys_unlink+0x180>
  iunlockput(dp);
8010613c:	83 ec 0c             	sub    $0xc,%esp
8010613f:	ff 75 b4             	push   -0x4c(%ebp)
80106142:	e8 c9 b8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80106147:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
  iupdate(ip);
8010614c:	89 1c 24             	mov    %ebx,(%esp)
8010614f:	e8 7c b5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80106154:	89 1c 24             	mov    %ebx,(%esp)
80106157:	e8 b4 b8 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010615c:	e8 6f cc ff ff       	call   80102dd0 <end_op>
  return 0;
80106161:	83 c4 10             	add    $0x10,%esp
80106164:	31 c0                	xor    %eax,%eax
}
80106166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106169:	5b                   	pop    %ebx
8010616a:	5e                   	pop    %esi
8010616b:	5f                   	pop    %edi
8010616c:	5d                   	pop    %ebp
8010616d:	c3                   	ret    
8010616e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106170:	83 7b 5c 20          	cmpl   $0x20,0x5c(%ebx)
80106174:	76 94                	jbe    8010610a <sys_unlink+0xba>
80106176:	be 20 00 00 00       	mov    $0x20,%esi
8010617b:	eb 0b                	jmp    80106188 <sys_unlink+0x138>
8010617d:	8d 76 00             	lea    0x0(%esi),%esi
80106180:	83 c6 10             	add    $0x10,%esi
80106183:	3b 73 5c             	cmp    0x5c(%ebx),%esi
80106186:	73 82                	jae    8010610a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106188:	6a 10                	push   $0x10
8010618a:	56                   	push   %esi
8010618b:	57                   	push   %edi
8010618c:	53                   	push   %ebx
8010618d:	e8 fe b8 ff ff       	call   80101a90 <readi>
80106192:	83 c4 10             	add    $0x10,%esp
80106195:	83 f8 10             	cmp    $0x10,%eax
80106198:	75 68                	jne    80106202 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010619a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010619f:	74 df                	je     80106180 <sys_unlink+0x130>
    iunlockput(ip);
801061a1:	83 ec 0c             	sub    $0xc,%esp
801061a4:	53                   	push   %ebx
801061a5:	e8 66 b8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801061aa:	83 c4 10             	add    $0x10,%esp
801061ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801061b0:	83 ec 0c             	sub    $0xc,%esp
801061b3:	ff 75 b4             	push   -0x4c(%ebp)
801061b6:	e8 55 b8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801061bb:	e8 10 cc ff ff       	call   80102dd0 <end_op>
  return -1;
801061c0:	83 c4 10             	add    $0x10,%esp
801061c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c8:	eb 9c                	jmp    80106166 <sys_unlink+0x116>
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801061d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801061d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801061d6:	66 83 68 5a 01       	subw   $0x1,0x5a(%eax)
    iupdate(dp);
801061db:	50                   	push   %eax
801061dc:	e8 ef b4 ff ff       	call   801016d0 <iupdate>
801061e1:	83 c4 10             	add    $0x10,%esp
801061e4:	e9 53 ff ff ff       	jmp    8010613c <sys_unlink+0xec>
    return -1;
801061e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ee:	e9 73 ff ff ff       	jmp    80106166 <sys_unlink+0x116>
    end_op();
801061f3:	e8 d8 cb ff ff       	call   80102dd0 <end_op>
    return -1;
801061f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061fd:	e9 64 ff ff ff       	jmp    80106166 <sys_unlink+0x116>
      panic("isdirempty: readi");
80106202:	83 ec 0c             	sub    $0xc,%esp
80106205:	68 b0 8d 10 80       	push   $0x80108db0
8010620a:	e8 71 a1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010620f:	83 ec 0c             	sub    $0xc,%esp
80106212:	68 c2 8d 10 80       	push   $0x80108dc2
80106217:	e8 64 a1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010621c:	83 ec 0c             	sub    $0xc,%esp
8010621f:	68 9e 8d 10 80       	push   $0x80108d9e
80106224:	e8 57 a1 ff ff       	call   80100380 <panic>
80106229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106230 <sys_open>:

int
sys_open(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	57                   	push   %edi
80106234:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106235:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106238:	53                   	push   %ebx
80106239:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010623c:	50                   	push   %eax
8010623d:	6a 00                	push   $0x0
8010623f:	e8 dc f7 ff ff       	call   80105a20 <argstr>
80106244:	83 c4 10             	add    $0x10,%esp
80106247:	85 c0                	test   %eax,%eax
80106249:	0f 88 8e 00 00 00    	js     801062dd <sys_open+0xad>
8010624f:	83 ec 08             	sub    $0x8,%esp
80106252:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106255:	50                   	push   %eax
80106256:	6a 01                	push   $0x1
80106258:	e8 03 f7 ff ff       	call   80105960 <argint>
8010625d:	83 c4 10             	add    $0x10,%esp
80106260:	85 c0                	test   %eax,%eax
80106262:	78 79                	js     801062dd <sys_open+0xad>
    return -1;

  begin_op();
80106264:	e8 f7 ca ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80106269:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010626d:	75 79                	jne    801062e8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010626f:	83 ec 0c             	sub    $0xc,%esp
80106272:	ff 75 e0             	push   -0x20(%ebp)
80106275:	e8 26 be ff ff       	call   801020a0 <namei>
8010627a:	83 c4 10             	add    $0x10,%esp
8010627d:	89 c6                	mov    %eax,%esi
8010627f:	85 c0                	test   %eax,%eax
80106281:	0f 84 7e 00 00 00    	je     80106305 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106287:	83 ec 0c             	sub    $0xc,%esp
8010628a:	50                   	push   %eax
8010628b:	e8 f0 b4 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106290:	83 c4 10             	add    $0x10,%esp
80106293:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
80106298:	0f 84 c2 00 00 00    	je     80106360 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010629e:	e8 8d ab ff ff       	call   80100e30 <filealloc>
801062a3:	89 c7                	mov    %eax,%edi
801062a5:	85 c0                	test   %eax,%eax
801062a7:	74 23                	je     801062cc <sys_open+0x9c>
  struct proc *curproc = myproc();
801062a9:	e8 b2 d7 ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801062ae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801062b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801062b4:	85 d2                	test   %edx,%edx
801062b6:	74 60                	je     80106318 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801062b8:	83 c3 01             	add    $0x1,%ebx
801062bb:	83 fb 10             	cmp    $0x10,%ebx
801062be:	75 f0                	jne    801062b0 <sys_open+0x80>
    if(f)
      fileclose(f);
801062c0:	83 ec 0c             	sub    $0xc,%esp
801062c3:	57                   	push   %edi
801062c4:	e8 27 ac ff ff       	call   80100ef0 <fileclose>
801062c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801062cc:	83 ec 0c             	sub    $0xc,%esp
801062cf:	56                   	push   %esi
801062d0:	e8 3b b7 ff ff       	call   80101a10 <iunlockput>
    end_op();
801062d5:	e8 f6 ca ff ff       	call   80102dd0 <end_op>
    return -1;
801062da:	83 c4 10             	add    $0x10,%esp
801062dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062e2:	eb 6d                	jmp    80106351 <sys_open+0x121>
801062e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801062ee:	31 c9                	xor    %ecx,%ecx
801062f0:	ba 02 00 00 00       	mov    $0x2,%edx
801062f5:	6a 00                	push   $0x0
801062f7:	e8 14 f8 ff ff       	call   80105b10 <create>
    if(ip == 0){
801062fc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801062ff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106301:	85 c0                	test   %eax,%eax
80106303:	75 99                	jne    8010629e <sys_open+0x6e>
      end_op();
80106305:	e8 c6 ca ff ff       	call   80102dd0 <end_op>
      return -1;
8010630a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010630f:	eb 40                	jmp    80106351 <sys_open+0x121>
80106311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106318:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010631b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010631f:	56                   	push   %esi
80106320:	e8 3b b5 ff ff       	call   80101860 <iunlock>
  end_op();
80106325:	e8 a6 ca ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010632a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106333:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106336:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106339:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010633b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106342:	f7 d0                	not    %eax
80106344:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106347:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010634a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010634d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106354:	89 d8                	mov    %ebx,%eax
80106356:	5b                   	pop    %ebx
80106357:	5e                   	pop    %esi
80106358:	5f                   	pop    %edi
80106359:	5d                   	pop    %ebp
8010635a:	c3                   	ret    
8010635b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010635f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106360:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106363:	85 c9                	test   %ecx,%ecx
80106365:	0f 84 33 ff ff ff    	je     8010629e <sys_open+0x6e>
8010636b:	e9 5c ff ff ff       	jmp    801062cc <sys_open+0x9c>

80106370 <sys_mkdir>:

int
sys_mkdir(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106376:	e8 e5 c9 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010637b:	83 ec 08             	sub    $0x8,%esp
8010637e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106381:	50                   	push   %eax
80106382:	6a 00                	push   $0x0
80106384:	e8 97 f6 ff ff       	call   80105a20 <argstr>
80106389:	83 c4 10             	add    $0x10,%esp
8010638c:	85 c0                	test   %eax,%eax
8010638e:	78 30                	js     801063c0 <sys_mkdir+0x50>
80106390:	83 ec 0c             	sub    $0xc,%esp
80106393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106396:	31 c9                	xor    %ecx,%ecx
80106398:	ba 01 00 00 00       	mov    $0x1,%edx
8010639d:	6a 00                	push   $0x0
8010639f:	e8 6c f7 ff ff       	call   80105b10 <create>
801063a4:	83 c4 10             	add    $0x10,%esp
801063a7:	85 c0                	test   %eax,%eax
801063a9:	74 15                	je     801063c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801063ab:	83 ec 0c             	sub    $0xc,%esp
801063ae:	50                   	push   %eax
801063af:	e8 5c b6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801063b4:	e8 17 ca ff ff       	call   80102dd0 <end_op>
  return 0;
801063b9:	83 c4 10             	add    $0x10,%esp
801063bc:	31 c0                	xor    %eax,%eax
}
801063be:	c9                   	leave  
801063bf:	c3                   	ret    
    end_op();
801063c0:	e8 0b ca ff ff       	call   80102dd0 <end_op>
    return -1;
801063c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063ca:	c9                   	leave  
801063cb:	c3                   	ret    
801063cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063d0 <sys_mknod>:

int
sys_mknod(void)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801063d6:	e8 85 c9 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
801063db:	83 ec 08             	sub    $0x8,%esp
801063de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063e1:	50                   	push   %eax
801063e2:	6a 00                	push   $0x0
801063e4:	e8 37 f6 ff ff       	call   80105a20 <argstr>
801063e9:	83 c4 10             	add    $0x10,%esp
801063ec:	85 c0                	test   %eax,%eax
801063ee:	78 60                	js     80106450 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801063f0:	83 ec 08             	sub    $0x8,%esp
801063f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063f6:	50                   	push   %eax
801063f7:	6a 01                	push   $0x1
801063f9:	e8 62 f5 ff ff       	call   80105960 <argint>
  if((argstr(0, &path)) < 0 ||
801063fe:	83 c4 10             	add    $0x10,%esp
80106401:	85 c0                	test   %eax,%eax
80106403:	78 4b                	js     80106450 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106405:	83 ec 08             	sub    $0x8,%esp
80106408:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010640b:	50                   	push   %eax
8010640c:	6a 02                	push   $0x2
8010640e:	e8 4d f5 ff ff       	call   80105960 <argint>
     argint(1, &major) < 0 ||
80106413:	83 c4 10             	add    $0x10,%esp
80106416:	85 c0                	test   %eax,%eax
80106418:	78 36                	js     80106450 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010641a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010641e:	83 ec 0c             	sub    $0xc,%esp
80106421:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106425:	ba 03 00 00 00       	mov    $0x3,%edx
8010642a:	50                   	push   %eax
8010642b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010642e:	e8 dd f6 ff ff       	call   80105b10 <create>
     argint(2, &minor) < 0 ||
80106433:	83 c4 10             	add    $0x10,%esp
80106436:	85 c0                	test   %eax,%eax
80106438:	74 16                	je     80106450 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010643a:	83 ec 0c             	sub    $0xc,%esp
8010643d:	50                   	push   %eax
8010643e:	e8 cd b5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106443:	e8 88 c9 ff ff       	call   80102dd0 <end_op>
  return 0;
80106448:	83 c4 10             	add    $0x10,%esp
8010644b:	31 c0                	xor    %eax,%eax
}
8010644d:	c9                   	leave  
8010644e:	c3                   	ret    
8010644f:	90                   	nop
    end_op();
80106450:	e8 7b c9 ff ff       	call   80102dd0 <end_op>
    return -1;
80106455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010645a:	c9                   	leave  
8010645b:	c3                   	ret    
8010645c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106460 <sys_chdir>:

int
sys_chdir(void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	56                   	push   %esi
80106464:	53                   	push   %ebx
80106465:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106468:	e8 f3 d5 ff ff       	call   80103a60 <myproc>
8010646d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010646f:	e8 ec c8 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106474:	83 ec 08             	sub    $0x8,%esp
80106477:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010647a:	50                   	push   %eax
8010647b:	6a 00                	push   $0x0
8010647d:	e8 9e f5 ff ff       	call   80105a20 <argstr>
80106482:	83 c4 10             	add    $0x10,%esp
80106485:	85 c0                	test   %eax,%eax
80106487:	78 77                	js     80106500 <sys_chdir+0xa0>
80106489:	83 ec 0c             	sub    $0xc,%esp
8010648c:	ff 75 f4             	push   -0xc(%ebp)
8010648f:	e8 0c bc ff ff       	call   801020a0 <namei>
80106494:	83 c4 10             	add    $0x10,%esp
80106497:	89 c3                	mov    %eax,%ebx
80106499:	85 c0                	test   %eax,%eax
8010649b:	74 63                	je     80106500 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010649d:	83 ec 0c             	sub    $0xc,%esp
801064a0:	50                   	push   %eax
801064a1:	e8 da b2 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801064a6:	83 c4 10             	add    $0x10,%esp
801064a9:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
801064ae:	75 30                	jne    801064e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	53                   	push   %ebx
801064b4:	e8 a7 b3 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801064b9:	58                   	pop    %eax
801064ba:	ff 76 68             	push   0x68(%esi)
801064bd:	e8 ee b3 ff ff       	call   801018b0 <iput>
  end_op();
801064c2:	e8 09 c9 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
801064c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801064ca:	83 c4 10             	add    $0x10,%esp
801064cd:	31 c0                	xor    %eax,%eax
}
801064cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801064d2:	5b                   	pop    %ebx
801064d3:	5e                   	pop    %esi
801064d4:	5d                   	pop    %ebp
801064d5:	c3                   	ret    
801064d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801064e0:	83 ec 0c             	sub    $0xc,%esp
801064e3:	53                   	push   %ebx
801064e4:	e8 27 b5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801064e9:	e8 e2 c8 ff ff       	call   80102dd0 <end_op>
    return -1;
801064ee:	83 c4 10             	add    $0x10,%esp
801064f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064f6:	eb d7                	jmp    801064cf <sys_chdir+0x6f>
801064f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ff:	90                   	nop
    end_op();
80106500:	e8 cb c8 ff ff       	call   80102dd0 <end_op>
    return -1;
80106505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010650a:	eb c3                	jmp    801064cf <sys_chdir+0x6f>
8010650c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106510 <sys_exec>:

int
sys_exec(void)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	57                   	push   %edi
80106514:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106515:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010651b:	53                   	push   %ebx
8010651c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106522:	50                   	push   %eax
80106523:	6a 00                	push   $0x0
80106525:	e8 f6 f4 ff ff       	call   80105a20 <argstr>
8010652a:	83 c4 10             	add    $0x10,%esp
8010652d:	85 c0                	test   %eax,%eax
8010652f:	0f 88 87 00 00 00    	js     801065bc <sys_exec+0xac>
80106535:	83 ec 08             	sub    $0x8,%esp
80106538:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010653e:	50                   	push   %eax
8010653f:	6a 01                	push   $0x1
80106541:	e8 1a f4 ff ff       	call   80105960 <argint>
80106546:	83 c4 10             	add    $0x10,%esp
80106549:	85 c0                	test   %eax,%eax
8010654b:	78 6f                	js     801065bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010654d:	83 ec 04             	sub    $0x4,%esp
80106550:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106556:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106558:	68 80 00 00 00       	push   $0x80
8010655d:	6a 00                	push   $0x0
8010655f:	56                   	push   %esi
80106560:	e8 3b f1 ff ff       	call   801056a0 <memset>
80106565:	83 c4 10             	add    $0x10,%esp
80106568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010656f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106570:	83 ec 08             	sub    $0x8,%esp
80106573:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106579:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106580:	50                   	push   %eax
80106581:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106587:	01 f8                	add    %edi,%eax
80106589:	50                   	push   %eax
8010658a:	e8 41 f3 ff ff       	call   801058d0 <fetchint>
8010658f:	83 c4 10             	add    $0x10,%esp
80106592:	85 c0                	test   %eax,%eax
80106594:	78 26                	js     801065bc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106596:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010659c:	85 c0                	test   %eax,%eax
8010659e:	74 30                	je     801065d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801065a0:	83 ec 08             	sub    $0x8,%esp
801065a3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801065a6:	52                   	push   %edx
801065a7:	50                   	push   %eax
801065a8:	e8 63 f3 ff ff       	call   80105910 <fetchstr>
801065ad:	83 c4 10             	add    $0x10,%esp
801065b0:	85 c0                	test   %eax,%eax
801065b2:	78 08                	js     801065bc <sys_exec+0xac>
  for(i=0;; i++){
801065b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801065b7:	83 fb 20             	cmp    $0x20,%ebx
801065ba:	75 b4                	jne    80106570 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801065bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801065bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065c4:	5b                   	pop    %ebx
801065c5:	5e                   	pop    %esi
801065c6:	5f                   	pop    %edi
801065c7:	5d                   	pop    %ebp
801065c8:	c3                   	ret    
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801065d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801065d7:	00 00 00 00 
  return exec(path, argv);
801065db:	83 ec 08             	sub    $0x8,%esp
801065de:	56                   	push   %esi
801065df:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801065e5:	e8 c6 a4 ff ff       	call   80100ab0 <exec>
801065ea:	83 c4 10             	add    $0x10,%esp
}
801065ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065f0:	5b                   	pop    %ebx
801065f1:	5e                   	pop    %esi
801065f2:	5f                   	pop    %edi
801065f3:	5d                   	pop    %ebp
801065f4:	c3                   	ret    
801065f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106600 <sys_pipe>:

int
sys_pipe(void)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106605:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106608:	53                   	push   %ebx
80106609:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010660c:	6a 08                	push   $0x8
8010660e:	50                   	push   %eax
8010660f:	6a 00                	push   $0x0
80106611:	e8 9a f3 ff ff       	call   801059b0 <argptr>
80106616:	83 c4 10             	add    $0x10,%esp
80106619:	85 c0                	test   %eax,%eax
8010661b:	78 4a                	js     80106667 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010661d:	83 ec 08             	sub    $0x8,%esp
80106620:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106623:	50                   	push   %eax
80106624:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106627:	50                   	push   %eax
80106628:	e8 03 ce ff ff       	call   80103430 <pipealloc>
8010662d:	83 c4 10             	add    $0x10,%esp
80106630:	85 c0                	test   %eax,%eax
80106632:	78 33                	js     80106667 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106634:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106637:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106639:	e8 22 d4 ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010663e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106640:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106644:	85 f6                	test   %esi,%esi
80106646:	74 28                	je     80106670 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106648:	83 c3 01             	add    $0x1,%ebx
8010664b:	83 fb 10             	cmp    $0x10,%ebx
8010664e:	75 f0                	jne    80106640 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106650:	83 ec 0c             	sub    $0xc,%esp
80106653:	ff 75 e0             	push   -0x20(%ebp)
80106656:	e8 95 a8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010665b:	58                   	pop    %eax
8010665c:	ff 75 e4             	push   -0x1c(%ebp)
8010665f:	e8 8c a8 ff ff       	call   80100ef0 <fileclose>
    return -1;
80106664:	83 c4 10             	add    $0x10,%esp
80106667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010666c:	eb 53                	jmp    801066c1 <sys_pipe+0xc1>
8010666e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106670:	8d 73 08             	lea    0x8(%ebx),%esi
80106673:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106677:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010667a:	e8 e1 d3 ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010667f:	31 d2                	xor    %edx,%edx
80106681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106688:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010668c:	85 c9                	test   %ecx,%ecx
8010668e:	74 20                	je     801066b0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106690:	83 c2 01             	add    $0x1,%edx
80106693:	83 fa 10             	cmp    $0x10,%edx
80106696:	75 f0                	jne    80106688 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106698:	e8 c3 d3 ff ff       	call   80103a60 <myproc>
8010669d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801066a4:	00 
801066a5:	eb a9                	jmp    80106650 <sys_pipe+0x50>
801066a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801066b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801066b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801066b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801066b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801066bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801066bf:	31 c0                	xor    %eax,%eax
}
801066c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066c4:	5b                   	pop    %ebx
801066c5:	5e                   	pop    %esi
801066c6:	5f                   	pop    %edi
801066c7:	5d                   	pop    %ebp
801066c8:	c3                   	ret    
801066c9:	66 90                	xchg   %ax,%ax
801066cb:	66 90                	xchg   %ax,%ax
801066cd:	66 90                	xchg   %ax,%ax
801066cf:	90                   	nop

801066d0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801066d0:	e9 4b d5 ff ff       	jmp    80103c20 <fork>
801066d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066e0 <sys_exit>:
}

int
sys_exit(void)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801066e6:	e8 35 de ff ff       	call   80104520 <exit>
  return 0;  // not reached
}
801066eb:	31 c0                	xor    %eax,%eax
801066ed:	c9                   	leave  
801066ee:	c3                   	ret    
801066ef:	90                   	nop

801066f0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801066f0:	e9 5b df ff ff       	jmp    80104650 <wait>
801066f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106700 <sys_kill>:
}

int
sys_kill(void)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106706:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106709:	50                   	push   %eax
8010670a:	6a 00                	push   $0x0
8010670c:	e8 4f f2 ff ff       	call   80105960 <argint>
80106711:	83 c4 10             	add    $0x10,%esp
80106714:	85 c0                	test   %eax,%eax
80106716:	78 18                	js     80106730 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106718:	83 ec 0c             	sub    $0xc,%esp
8010671b:	ff 75 f4             	push   -0xc(%ebp)
8010671e:	e8 1d e2 ff ff       	call   80104940 <kill>
80106723:	83 c4 10             	add    $0x10,%esp
}
80106726:	c9                   	leave  
80106727:	c3                   	ret    
80106728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010672f:	90                   	nop
80106730:	c9                   	leave  
    return -1;
80106731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106736:	c3                   	ret    
80106737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010673e:	66 90                	xchg   %ax,%ax

80106740 <sys_getpid>:

int
sys_getpid(void)
{
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106746:	e8 15 d3 ff ff       	call   80103a60 <myproc>
8010674b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010674e:	c9                   	leave  
8010674f:	c3                   	ret    

80106750 <sys_sbrk>:

int
sys_sbrk(void)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106754:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106757:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010675a:	50                   	push   %eax
8010675b:	6a 00                	push   $0x0
8010675d:	e8 fe f1 ff ff       	call   80105960 <argint>
80106762:	83 c4 10             	add    $0x10,%esp
80106765:	85 c0                	test   %eax,%eax
80106767:	78 27                	js     80106790 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106769:	e8 f2 d2 ff ff       	call   80103a60 <myproc>
  if(growproc(n) < 0)
8010676e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106771:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106773:	ff 75 f4             	push   -0xc(%ebp)
80106776:	e8 25 d4 ff ff       	call   80103ba0 <growproc>
8010677b:	83 c4 10             	add    $0x10,%esp
8010677e:	85 c0                	test   %eax,%eax
80106780:	78 0e                	js     80106790 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106782:	89 d8                	mov    %ebx,%eax
80106784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106787:	c9                   	leave  
80106788:	c3                   	ret    
80106789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106790:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106795:	eb eb                	jmp    80106782 <sys_sbrk+0x32>
80106797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010679e:	66 90                	xchg   %ax,%ax

801067a0 <sys_sleep>:

int
sys_sleep(void)
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801067a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801067a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801067aa:	50                   	push   %eax
801067ab:	6a 00                	push   $0x0
801067ad:	e8 ae f1 ff ff       	call   80105960 <argint>
801067b2:	83 c4 10             	add    $0x10,%esp
801067b5:	85 c0                	test   %eax,%eax
801067b7:	0f 88 8a 00 00 00    	js     80106847 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801067bd:	83 ec 0c             	sub    $0xc,%esp
801067c0:	68 40 86 11 80       	push   $0x80118640
801067c5:	e8 86 ed ff ff       	call   80105550 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801067ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801067cd:	8b 1d 20 86 11 80    	mov    0x80118620,%ebx
  while(ticks - ticks0 < n){
801067d3:	83 c4 10             	add    $0x10,%esp
801067d6:	85 d2                	test   %edx,%edx
801067d8:	75 27                	jne    80106801 <sys_sleep+0x61>
801067da:	eb 54                	jmp    80106830 <sys_sleep+0x90>
801067dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801067e0:	83 ec 08             	sub    $0x8,%esp
801067e3:	68 40 86 11 80       	push   $0x80118640
801067e8:	68 20 86 11 80       	push   $0x80118620
801067ed:	e8 2e e0 ff ff       	call   80104820 <sleep>
  while(ticks - ticks0 < n){
801067f2:	a1 20 86 11 80       	mov    0x80118620,%eax
801067f7:	83 c4 10             	add    $0x10,%esp
801067fa:	29 d8                	sub    %ebx,%eax
801067fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801067ff:	73 2f                	jae    80106830 <sys_sleep+0x90>
    if(myproc()->killed){
80106801:	e8 5a d2 ff ff       	call   80103a60 <myproc>
80106806:	8b 40 24             	mov    0x24(%eax),%eax
80106809:	85 c0                	test   %eax,%eax
8010680b:	74 d3                	je     801067e0 <sys_sleep+0x40>
      release(&tickslock);
8010680d:	83 ec 0c             	sub    $0xc,%esp
80106810:	68 40 86 11 80       	push   $0x80118640
80106815:	e8 c6 ec ff ff       	call   801054e0 <release>
  }
  release(&tickslock);
  return 0;
}
8010681a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010681d:	83 c4 10             	add    $0x10,%esp
80106820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106825:	c9                   	leave  
80106826:	c3                   	ret    
80106827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010682e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106830:	83 ec 0c             	sub    $0xc,%esp
80106833:	68 40 86 11 80       	push   $0x80118640
80106838:	e8 a3 ec ff ff       	call   801054e0 <release>
  return 0;
8010683d:	83 c4 10             	add    $0x10,%esp
80106840:	31 c0                	xor    %eax,%eax
}
80106842:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106845:	c9                   	leave  
80106846:	c3                   	ret    
    return -1;
80106847:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684c:	eb f4                	jmp    80106842 <sys_sleep+0xa2>
8010684e:	66 90                	xchg   %ax,%ax

80106850 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	53                   	push   %ebx
80106854:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106857:	68 40 86 11 80       	push   $0x80118640
8010685c:	e8 ef ec ff ff       	call   80105550 <acquire>
  xticks = ticks;
80106861:	8b 1d 20 86 11 80    	mov    0x80118620,%ebx
  release(&tickslock);
80106867:	c7 04 24 40 86 11 80 	movl   $0x80118640,(%esp)
8010686e:	e8 6d ec ff ff       	call   801054e0 <release>
  return xticks;
}
80106873:	89 d8                	mov    %ebx,%eax
80106875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106878:	c9                   	leave  
80106879:	c3                   	ret    
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106880 <sys_find_next_prime_number>:

int
sys_find_next_prime_number(void)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	53                   	push   %ebx
80106884:	83 ec 04             	sub    $0x4,%esp
  int number = myproc()->tf->ebx; //register after eax
80106887:	e8 d4 d1 ff ff       	call   80103a60 <myproc>
  cprintf("Kernel: sys_find_next_prime_num() called for number %d\n", number);
8010688c:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; //register after eax
8010688f:	8b 40 18             	mov    0x18(%eax),%eax
80106892:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("Kernel: sys_find_next_prime_num() called for number %d\n", number);
80106895:	53                   	push   %ebx
80106896:	68 d4 8d 10 80       	push   $0x80108dd4
8010689b:	e8 00 9e ff ff       	call   801006a0 <cprintf>
  return find_next_prime_number(number);
801068a0:	89 1c 24             	mov    %ebx,(%esp)
801068a3:	e8 d8 e1 ff ff       	call   80104a80 <find_next_prime_number>
}
801068a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801068ab:	c9                   	leave  
801068ac:	c3                   	ret    
801068ad:	8d 76 00             	lea    0x0(%esi),%esi

801068b0 <sys_get_call_count>:

int 
sys_get_call_count(void)
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	53                   	push   %ebx
801068b4:	83 ec 14             	sub    $0x14,%esp
  int  *cnt;
  int sys_num;
  struct proc *curproc = myproc();
801068b7:	e8 a4 d1 ff ff       	call   80103a60 <myproc>
  argint(0, &sys_num);
801068bc:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801068bf:	89 c3                	mov    %eax,%ebx
  argint(0, &sys_num);
801068c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068c4:	50                   	push   %eax
801068c5:	6a 00                	push   $0x0
801068c7:	e8 94 f0 ff ff       	call   80105960 <argint>
  cnt = curproc->syscnt;
  return *(cnt+sys_num-1);
801068cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068cf:	8b 44 83 78          	mov    0x78(%ebx,%eax,4),%eax
}
801068d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801068d6:	c9                   	leave  
801068d7:	c3                   	ret    
801068d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068df:	90                   	nop

801068e0 <sys_get_most_caller>:

int
sys_get_most_caller(void)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 20             	sub    $0x20,%esp
  int sys_num;
  argint(0, &sys_num);
801068e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068e9:	50                   	push   %eax
801068ea:	6a 00                	push   $0x0
801068ec:	e8 6f f0 ff ff       	call   80105960 <argint>
  return get_most_caller(sys_num);
801068f1:	58                   	pop    %eax
801068f2:	ff 75 f4             	push   -0xc(%ebp)
801068f5:	e8 c6 e1 ff ff       	call   80104ac0 <get_most_caller>
}
801068fa:	c9                   	leave  
801068fb:	c3                   	ret    
801068fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106900 <sys_wait_for_process>:

int 
sys_wait_for_process(void)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	83 ec 20             	sub    $0x20,%esp
  int pid;
  argint(0, &pid);
80106906:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106909:	50                   	push   %eax
8010690a:	6a 00                	push   $0x0
8010690c:	e8 4f f0 ff ff       	call   80105960 <argint>
  return wait_for_process(pid);
80106911:	58                   	pop    %eax
80106912:	ff 75 f4             	push   -0xc(%ebp)
80106915:	e8 d6 e7 ff ff       	call   801050f0 <wait_for_process>

}
8010691a:	c9                   	leave  
8010691b:	c3                   	ret    
8010691c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106920 <sys_set_queue>:

void
sys_set_queue(void)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	83 ec 20             	sub    $0x20,%esp
  int pid, new_queue;
  argint(0, &pid);
80106926:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106929:	50                   	push   %eax
8010692a:	6a 00                	push   $0x0
8010692c:	e8 2f f0 ff ff       	call   80105960 <argint>
  argint(1, &new_queue);
80106931:	58                   	pop    %eax
80106932:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106935:	5a                   	pop    %edx
80106936:	50                   	push   %eax
80106937:	6a 01                	push   $0x1
80106939:	e8 22 f0 ff ff       	call   80105960 <argint>
  set_queue(pid, new_queue);
8010693e:	59                   	pop    %ecx
8010693f:	58                   	pop    %eax
80106940:	ff 75 f4             	push   -0xc(%ebp)
80106943:	ff 75 f0             	push   -0x10(%ebp)
80106946:	e8 15 e2 ff ff       	call   80104b60 <set_queue>
}
8010694b:	83 c4 10             	add    $0x10,%esp
8010694e:	c9                   	leave  
8010694f:	c3                   	ret    

80106950 <sys_print_procs>:

void
sys_print_procs(void)
{
  print_procs();
80106950:	e9 db d4 ff ff       	jmp    80103e30 <print_procs>
80106955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010695c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106960 <sys_set_global_bjf_params>:
}

void
sys_set_global_bjf_params(void)
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	83 ec 20             	sub    $0x20,%esp
  int p_ratio, a_ratio, e_ratio;
  argint(0, &p_ratio);
80106966:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106969:	50                   	push   %eax
8010696a:	6a 00                	push   $0x0
8010696c:	e8 ef ef ff ff       	call   80105960 <argint>
  argint(1, &a_ratio);
80106971:	58                   	pop    %eax
80106972:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106975:	5a                   	pop    %edx
80106976:	50                   	push   %eax
80106977:	6a 01                	push   $0x1
80106979:	e8 e2 ef ff ff       	call   80105960 <argint>
  argint(2, &e_ratio);
8010697e:	59                   	pop    %ecx
8010697f:	58                   	pop    %eax
80106980:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106983:	50                   	push   %eax
80106984:	6a 02                	push   $0x2
80106986:	e8 d5 ef ff ff       	call   80105960 <argint>
  set_global_bjf_params(p_ratio, a_ratio, e_ratio);
8010698b:	83 c4 0c             	add    $0xc,%esp
8010698e:	ff 75 f4             	push   -0xc(%ebp)
80106991:	ff 75 f0             	push   -0x10(%ebp)
80106994:	ff 75 ec             	push   -0x14(%ebp)
80106997:	e8 14 e2 ff ff       	call   80104bb0 <set_global_bjf_params>
}
8010699c:	83 c4 10             	add    $0x10,%esp
8010699f:	c9                   	leave  
801069a0:	c3                   	ret    
801069a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069af:	90                   	nop

801069b0 <sys_set_bjf_params>:

void
sys_set_bjf_params(void)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	83 ec 20             	sub    $0x20,%esp
  int pid, p_ratio, a_ratio, e_ratio;
  argint(0, &pid);
801069b6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069b9:	50                   	push   %eax
801069ba:	6a 00                	push   $0x0
801069bc:	e8 9f ef ff ff       	call   80105960 <argint>
  argint(1, &p_ratio);
801069c1:	58                   	pop    %eax
801069c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069c5:	5a                   	pop    %edx
801069c6:	50                   	push   %eax
801069c7:	6a 01                	push   $0x1
801069c9:	e8 92 ef ff ff       	call   80105960 <argint>
  argint(2, &a_ratio);
801069ce:	59                   	pop    %ecx
801069cf:	58                   	pop    %eax
801069d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069d3:	50                   	push   %eax
801069d4:	6a 02                	push   $0x2
801069d6:	e8 85 ef ff ff       	call   80105960 <argint>
  argint(3, &e_ratio);
801069db:	58                   	pop    %eax
801069dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069df:	5a                   	pop    %edx
801069e0:	50                   	push   %eax
801069e1:	6a 03                	push   $0x3
801069e3:	e8 78 ef ff ff       	call   80105960 <argint>
  set_bjf_params(pid, p_ratio, a_ratio, e_ratio);
801069e8:	ff 75 f4             	push   -0xc(%ebp)
801069eb:	ff 75 f0             	push   -0x10(%ebp)
801069ee:	ff 75 ec             	push   -0x14(%ebp)
801069f1:	ff 75 e8             	push   -0x18(%ebp)
801069f4:	e8 17 e2 ff ff       	call   80104c10 <set_bjf_params>
}
801069f9:	83 c4 20             	add    $0x20,%esp
801069fc:	c9                   	leave  
801069fd:	c3                   	ret    
801069fe:	66 90                	xchg   %ax,%ax

80106a00 <sys_sem_init>:

int
sys_sem_init(void) 
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	83 ec 20             	sub    $0x20,%esp
  int i, v;
  argint(0, &i);
80106a06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a09:	50                   	push   %eax
80106a0a:	6a 00                	push   $0x0
80106a0c:	e8 4f ef ff ff       	call   80105960 <argint>
  argint(1, &v);
80106a11:	58                   	pop    %eax
80106a12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a15:	5a                   	pop    %edx
80106a16:	50                   	push   %eax
80106a17:	6a 01                	push   $0x1
80106a19:	e8 42 ef ff ff       	call   80105960 <argint>

  return sem_init(i, v);
80106a1e:	59                   	pop    %ecx
80106a1f:	58                   	pop    %eax
80106a20:	ff 75 f4             	push   -0xc(%ebp)
80106a23:	ff 75 f0             	push   -0x10(%ebp)
80106a26:	e8 f5 e2 ff ff       	call   80104d20 <sem_init>
}
80106a2b:	c9                   	leave  
80106a2c:	c3                   	ret    
80106a2d:	8d 76 00             	lea    0x0(%esi),%esi

80106a30 <sys_sem_acquire>:

int
sys_sem_acquire(void) 
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	83 ec 20             	sub    $0x20,%esp
  int i;
  argint(0, &i);
80106a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a39:	50                   	push   %eax
80106a3a:	6a 00                	push   $0x0
80106a3c:	e8 1f ef ff ff       	call   80105960 <argint>

  return sem_acquire(i);
80106a41:	58                   	pop    %eax
80106a42:	ff 75 f4             	push   -0xc(%ebp)
80106a45:	e8 16 e3 ff ff       	call   80104d60 <sem_acquire>
}
80106a4a:	c9                   	leave  
80106a4b:	c3                   	ret    
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a50 <sys_sem_release>:

int
sys_sem_release(void) 
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	83 ec 20             	sub    $0x20,%esp
  int i;
  argint(0, &i);
80106a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a59:	50                   	push   %eax
80106a5a:	6a 00                	push   $0x0
80106a5c:	e8 ff ee ff ff       	call   80105960 <argint>

  return sem_release(i);
80106a61:	58                   	pop    %eax
80106a62:	ff 75 f4             	push   -0xc(%ebp)
80106a65:	e8 d6 e3 ff ff       	call   80104e40 <sem_release>
}
80106a6a:	c9                   	leave  
80106a6b:	c3                   	ret    
80106a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a70 <sys_initlock_rl>:

void
sys_initlock_rl(void)
{
  initlock_rl();
80106a70:	e9 4b e5 ff ff       	jmp    80104fc0 <initlock_rl>
80106a75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a80 <sys_acquire_rl>:
}

void
sys_acquire_rl(void)
{
  acquire_rl();
80106a80:	e9 cb e5 ff ff       	jmp    80105050 <acquire_rl>
80106a85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a90 <sys_release_rl>:
}

void
sys_release_rl(void)
{
  release_rl();
80106a90:	e9 2b e6 ff ff       	jmp    801050c0 <release_rl>

80106a95 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a95:	1e                   	push   %ds
  pushl %es
80106a96:	06                   	push   %es
  pushl %fs
80106a97:	0f a0                	push   %fs
  pushl %gs
80106a99:	0f a8                	push   %gs
  pushal
80106a9b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106a9c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106aa0:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106aa2:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106aa4:	54                   	push   %esp
  call trap
80106aa5:	e8 c6 00 00 00       	call   80106b70 <trap>
  addl $4, %esp
80106aaa:	83 c4 04             	add    $0x4,%esp

80106aad <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106aad:	61                   	popa   
  popl %gs
80106aae:	0f a9                	pop    %gs
  popl %fs
80106ab0:	0f a1                	pop    %fs
  popl %es
80106ab2:	07                   	pop    %es
  popl %ds
80106ab3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106ab4:	83 c4 08             	add    $0x8,%esp
  iret
80106ab7:	cf                   	iret   
80106ab8:	66 90                	xchg   %ax,%ax
80106aba:	66 90                	xchg   %ax,%ax
80106abc:	66 90                	xchg   %ax,%ax
80106abe:	66 90                	xchg   %ax,%ax

80106ac0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106ac0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106ac1:	31 c0                	xor    %eax,%eax
{
80106ac3:	89 e5                	mov    %esp,%ebp
80106ac5:	83 ec 08             	sub    $0x8,%esp
80106ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106acf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106ad0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106ad7:	c7 04 c5 82 86 11 80 	movl   $0x8e000008,-0x7fee797e(,%eax,8)
80106ade:	08 00 00 8e 
80106ae2:	66 89 14 c5 80 86 11 	mov    %dx,-0x7fee7980(,%eax,8)
80106ae9:	80 
80106aea:	c1 ea 10             	shr    $0x10,%edx
80106aed:	66 89 14 c5 86 86 11 	mov    %dx,-0x7fee797a(,%eax,8)
80106af4:	80 
  for(i = 0; i < 256; i++)
80106af5:	83 c0 01             	add    $0x1,%eax
80106af8:	3d 00 01 00 00       	cmp    $0x100,%eax
80106afd:	75 d1                	jne    80106ad0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106aff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b02:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106b07:	c7 05 82 88 11 80 08 	movl   $0xef000008,0x80118882
80106b0e:	00 00 ef 
  initlock(&tickslock, "time");
80106b11:	68 0c 8e 10 80       	push   $0x80108e0c
80106b16:	68 40 86 11 80       	push   $0x80118640
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b1b:	66 a3 80 88 11 80    	mov    %ax,0x80118880
80106b21:	c1 e8 10             	shr    $0x10,%eax
80106b24:	66 a3 86 88 11 80    	mov    %ax,0x80118886
  initlock(&tickslock, "time");
80106b2a:	e8 31 e8 ff ff       	call   80105360 <initlock>
}
80106b2f:	83 c4 10             	add    $0x10,%esp
80106b32:	c9                   	leave  
80106b33:	c3                   	ret    
80106b34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b3f:	90                   	nop

80106b40 <idtinit>:

void
idtinit(void)
{
80106b40:	55                   	push   %ebp
  pd[0] = size-1;
80106b41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106b46:	89 e5                	mov    %esp,%ebp
80106b48:	83 ec 10             	sub    $0x10,%esp
80106b4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106b4f:	b8 80 86 11 80       	mov    $0x80118680,%eax
80106b54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106b58:	c1 e8 10             	shr    $0x10,%eax
80106b5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106b5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106b62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106b65:	c9                   	leave  
80106b66:	c3                   	ret    
80106b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6e:	66 90                	xchg   %ax,%ax

80106b70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	83 ec 1c             	sub    $0x1c,%esp
80106b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106b7c:	8b 43 30             	mov    0x30(%ebx),%eax
80106b7f:	83 f8 40             	cmp    $0x40,%eax
80106b82:	0f 84 68 01 00 00    	je     80106cf0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106b88:	83 e8 20             	sub    $0x20,%eax
80106b8b:	83 f8 1f             	cmp    $0x1f,%eax
80106b8e:	0f 87 8c 00 00 00    	ja     80106c20 <trap+0xb0>
80106b94:	ff 24 85 b4 8e 10 80 	jmp    *-0x7fef714c(,%eax,4)
80106b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b9f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106ba0:	e8 9b b6 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106ba5:	e8 66 bd ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106baa:	e8 b1 ce ff ff       	call   80103a60 <myproc>
80106baf:	85 c0                	test   %eax,%eax
80106bb1:	74 1d                	je     80106bd0 <trap+0x60>
80106bb3:	e8 a8 ce ff ff       	call   80103a60 <myproc>
80106bb8:	8b 50 24             	mov    0x24(%eax),%edx
80106bbb:	85 d2                	test   %edx,%edx
80106bbd:	74 11                	je     80106bd0 <trap+0x60>
80106bbf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106bc3:	83 e0 03             	and    $0x3,%eax
80106bc6:	66 83 f8 03          	cmp    $0x3,%ax
80106bca:	0f 84 e8 01 00 00    	je     80106db8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106bd0:	e8 8b ce ff ff       	call   80103a60 <myproc>
80106bd5:	85 c0                	test   %eax,%eax
80106bd7:	74 0f                	je     80106be8 <trap+0x78>
80106bd9:	e8 82 ce ff ff       	call   80103a60 <myproc>
80106bde:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106be2:	0f 84 b8 00 00 00    	je     80106ca0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106be8:	e8 73 ce ff ff       	call   80103a60 <myproc>
80106bed:	85 c0                	test   %eax,%eax
80106bef:	74 1d                	je     80106c0e <trap+0x9e>
80106bf1:	e8 6a ce ff ff       	call   80103a60 <myproc>
80106bf6:	8b 40 24             	mov    0x24(%eax),%eax
80106bf9:	85 c0                	test   %eax,%eax
80106bfb:	74 11                	je     80106c0e <trap+0x9e>
80106bfd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106c01:	83 e0 03             	and    $0x3,%eax
80106c04:	66 83 f8 03          	cmp    $0x3,%ax
80106c08:	0f 84 0f 01 00 00    	je     80106d1d <trap+0x1ad>
    exit();
}
80106c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c11:	5b                   	pop    %ebx
80106c12:	5e                   	pop    %esi
80106c13:	5f                   	pop    %edi
80106c14:	5d                   	pop    %ebp
80106c15:	c3                   	ret    
80106c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106c20:	e8 3b ce ff ff       	call   80103a60 <myproc>
80106c25:	8b 7b 38             	mov    0x38(%ebx),%edi
80106c28:	85 c0                	test   %eax,%eax
80106c2a:	0f 84 a2 01 00 00    	je     80106dd2 <trap+0x262>
80106c30:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106c34:	0f 84 98 01 00 00    	je     80106dd2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106c3a:	0f 20 d1             	mov    %cr2,%ecx
80106c3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c40:	e8 fb cd ff ff       	call   80103a40 <cpuid>
80106c45:	8b 73 30             	mov    0x30(%ebx),%esi
80106c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c4b:	8b 43 34             	mov    0x34(%ebx),%eax
80106c4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106c51:	e8 0a ce ff ff       	call   80103a60 <myproc>
80106c56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c59:	e8 02 ce ff ff       	call   80103a60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106c61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106c64:	51                   	push   %ecx
80106c65:	57                   	push   %edi
80106c66:	52                   	push   %edx
80106c67:	ff 75 e4             	push   -0x1c(%ebp)
80106c6a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106c6b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106c6e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c71:	56                   	push   %esi
80106c72:	ff 70 10             	push   0x10(%eax)
80106c75:	68 70 8e 10 80       	push   $0x80108e70
80106c7a:	e8 21 9a ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80106c7f:	83 c4 20             	add    $0x20,%esp
80106c82:	e8 d9 cd ff ff       	call   80103a60 <myproc>
80106c87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c8e:	e8 cd cd ff ff       	call   80103a60 <myproc>
80106c93:	85 c0                	test   %eax,%eax
80106c95:	0f 85 18 ff ff ff    	jne    80106bb3 <trap+0x43>
80106c9b:	e9 30 ff ff ff       	jmp    80106bd0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106ca0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106ca4:	0f 85 3e ff ff ff    	jne    80106be8 <trap+0x78>
    yield();
80106caa:	e8 d1 da ff ff       	call   80104780 <yield>
80106caf:	e9 34 ff ff ff       	jmp    80106be8 <trap+0x78>
80106cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106cb8:	8b 7b 38             	mov    0x38(%ebx),%edi
80106cbb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106cbf:	e8 7c cd ff ff       	call   80103a40 <cpuid>
80106cc4:	57                   	push   %edi
80106cc5:	56                   	push   %esi
80106cc6:	50                   	push   %eax
80106cc7:	68 18 8e 10 80       	push   $0x80108e18
80106ccc:	e8 cf 99 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106cd1:	e8 3a bc ff ff       	call   80102910 <lapiceoi>
    break;
80106cd6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106cd9:	e8 82 cd ff ff       	call   80103a60 <myproc>
80106cde:	85 c0                	test   %eax,%eax
80106ce0:	0f 85 cd fe ff ff    	jne    80106bb3 <trap+0x43>
80106ce6:	e9 e5 fe ff ff       	jmp    80106bd0 <trap+0x60>
80106ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cef:	90                   	nop
    if(myproc()->killed)
80106cf0:	e8 6b cd ff ff       	call   80103a60 <myproc>
80106cf5:	8b 70 24             	mov    0x24(%eax),%esi
80106cf8:	85 f6                	test   %esi,%esi
80106cfa:	0f 85 c8 00 00 00    	jne    80106dc8 <trap+0x258>
    myproc()->tf = tf;
80106d00:	e8 5b cd ff ff       	call   80103a60 <myproc>
80106d05:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106d08:	e8 93 ed ff ff       	call   80105aa0 <syscall>
    if(myproc()->killed)
80106d0d:	e8 4e cd ff ff       	call   80103a60 <myproc>
80106d12:	8b 48 24             	mov    0x24(%eax),%ecx
80106d15:	85 c9                	test   %ecx,%ecx
80106d17:	0f 84 f1 fe ff ff    	je     80106c0e <trap+0x9e>
}
80106d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d20:	5b                   	pop    %ebx
80106d21:	5e                   	pop    %esi
80106d22:	5f                   	pop    %edi
80106d23:	5d                   	pop    %ebp
      exit();
80106d24:	e9 f7 d7 ff ff       	jmp    80104520 <exit>
80106d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106d30:	e8 3b 02 00 00       	call   80106f70 <uartintr>
    lapiceoi();
80106d35:	e8 d6 bb ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d3a:	e8 21 cd ff ff       	call   80103a60 <myproc>
80106d3f:	85 c0                	test   %eax,%eax
80106d41:	0f 85 6c fe ff ff    	jne    80106bb3 <trap+0x43>
80106d47:	e9 84 fe ff ff       	jmp    80106bd0 <trap+0x60>
80106d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106d50:	e8 7b ba ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106d55:	e8 b6 bb ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d5a:	e8 01 cd ff ff       	call   80103a60 <myproc>
80106d5f:	85 c0                	test   %eax,%eax
80106d61:	0f 85 4c fe ff ff    	jne    80106bb3 <trap+0x43>
80106d67:	e9 64 fe ff ff       	jmp    80106bd0 <trap+0x60>
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106d70:	e8 cb cc ff ff       	call   80103a40 <cpuid>
80106d75:	85 c0                	test   %eax,%eax
80106d77:	0f 85 28 fe ff ff    	jne    80106ba5 <trap+0x35>
      acquire(&tickslock);
80106d7d:	83 ec 0c             	sub    $0xc,%esp
80106d80:	68 40 86 11 80       	push   $0x80118640
80106d85:	e8 c6 e7 ff ff       	call   80105550 <acquire>
      wakeup(&ticks);
80106d8a:	c7 04 24 20 86 11 80 	movl   $0x80118620,(%esp)
      ticks++;
80106d91:	83 05 20 86 11 80 01 	addl   $0x1,0x80118620
      wakeup(&ticks);
80106d98:	e8 43 db ff ff       	call   801048e0 <wakeup>
      release(&tickslock);
80106d9d:	c7 04 24 40 86 11 80 	movl   $0x80118640,(%esp)
80106da4:	e8 37 e7 ff ff       	call   801054e0 <release>
80106da9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106dac:	e9 f4 fd ff ff       	jmp    80106ba5 <trap+0x35>
80106db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106db8:	e8 63 d7 ff ff       	call   80104520 <exit>
80106dbd:	e9 0e fe ff ff       	jmp    80106bd0 <trap+0x60>
80106dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106dc8:	e8 53 d7 ff ff       	call   80104520 <exit>
80106dcd:	e9 2e ff ff ff       	jmp    80106d00 <trap+0x190>
80106dd2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dd5:	e8 66 cc ff ff       	call   80103a40 <cpuid>
80106dda:	83 ec 0c             	sub    $0xc,%esp
80106ddd:	56                   	push   %esi
80106dde:	57                   	push   %edi
80106ddf:	50                   	push   %eax
80106de0:	ff 73 30             	push   0x30(%ebx)
80106de3:	68 3c 8e 10 80       	push   $0x80108e3c
80106de8:	e8 b3 98 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106ded:	83 c4 14             	add    $0x14,%esp
80106df0:	68 11 8e 10 80       	push   $0x80108e11
80106df5:	e8 86 95 ff ff       	call   80100380 <panic>
80106dfa:	66 90                	xchg   %ax,%ax
80106dfc:	66 90                	xchg   %ax,%ax
80106dfe:	66 90                	xchg   %ax,%ax

80106e00 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106e00:	a1 80 8e 11 80       	mov    0x80118e80,%eax
80106e05:	85 c0                	test   %eax,%eax
80106e07:	74 17                	je     80106e20 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e09:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e0e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106e0f:	a8 01                	test   $0x1,%al
80106e11:	74 0d                	je     80106e20 <uartgetc+0x20>
80106e13:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e18:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106e19:	0f b6 c0             	movzbl %al,%eax
80106e1c:	c3                   	ret    
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e25:	c3                   	ret    
80106e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi

80106e30 <uartinit>:
{
80106e30:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e31:	31 c9                	xor    %ecx,%ecx
80106e33:	89 c8                	mov    %ecx,%eax
80106e35:	89 e5                	mov    %esp,%ebp
80106e37:	57                   	push   %edi
80106e38:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106e3d:	56                   	push   %esi
80106e3e:	89 fa                	mov    %edi,%edx
80106e40:	53                   	push   %ebx
80106e41:	83 ec 1c             	sub    $0x1c,%esp
80106e44:	ee                   	out    %al,(%dx)
80106e45:	be fb 03 00 00       	mov    $0x3fb,%esi
80106e4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106e4f:	89 f2                	mov    %esi,%edx
80106e51:	ee                   	out    %al,(%dx)
80106e52:	b8 0c 00 00 00       	mov    $0xc,%eax
80106e57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e5c:	ee                   	out    %al,(%dx)
80106e5d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106e62:	89 c8                	mov    %ecx,%eax
80106e64:	89 da                	mov    %ebx,%edx
80106e66:	ee                   	out    %al,(%dx)
80106e67:	b8 03 00 00 00       	mov    $0x3,%eax
80106e6c:	89 f2                	mov    %esi,%edx
80106e6e:	ee                   	out    %al,(%dx)
80106e6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106e74:	89 c8                	mov    %ecx,%eax
80106e76:	ee                   	out    %al,(%dx)
80106e77:	b8 01 00 00 00       	mov    $0x1,%eax
80106e7c:	89 da                	mov    %ebx,%edx
80106e7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e84:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106e85:	3c ff                	cmp    $0xff,%al
80106e87:	74 78                	je     80106f01 <uartinit+0xd1>
  uart = 1;
80106e89:	c7 05 80 8e 11 80 01 	movl   $0x1,0x80118e80
80106e90:	00 00 00 
80106e93:	89 fa                	mov    %edi,%edx
80106e95:	ec                   	in     (%dx),%al
80106e96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e9b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106e9c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106e9f:	bf 34 8f 10 80       	mov    $0x80108f34,%edi
80106ea4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106ea9:	6a 00                	push   $0x0
80106eab:	6a 04                	push   $0x4
80106ead:	e8 ce b5 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106eb2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106eb6:	83 c4 10             	add    $0x10,%esp
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106ec0:	a1 80 8e 11 80       	mov    0x80118e80,%eax
80106ec5:	bb 80 00 00 00       	mov    $0x80,%ebx
80106eca:	85 c0                	test   %eax,%eax
80106ecc:	75 14                	jne    80106ee2 <uartinit+0xb2>
80106ece:	eb 23                	jmp    80106ef3 <uartinit+0xc3>
    microdelay(10);
80106ed0:	83 ec 0c             	sub    $0xc,%esp
80106ed3:	6a 0a                	push   $0xa
80106ed5:	e8 56 ba ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106eda:	83 c4 10             	add    $0x10,%esp
80106edd:	83 eb 01             	sub    $0x1,%ebx
80106ee0:	74 07                	je     80106ee9 <uartinit+0xb9>
80106ee2:	89 f2                	mov    %esi,%edx
80106ee4:	ec                   	in     (%dx),%al
80106ee5:	a8 20                	test   $0x20,%al
80106ee7:	74 e7                	je     80106ed0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ee9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106eed:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ef2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106ef3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106ef7:	83 c7 01             	add    $0x1,%edi
80106efa:	88 45 e7             	mov    %al,-0x19(%ebp)
80106efd:	84 c0                	test   %al,%al
80106eff:	75 bf                	jne    80106ec0 <uartinit+0x90>
}
80106f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f04:	5b                   	pop    %ebx
80106f05:	5e                   	pop    %esi
80106f06:	5f                   	pop    %edi
80106f07:	5d                   	pop    %ebp
80106f08:	c3                   	ret    
80106f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f10 <uartputc>:
  if(!uart)
80106f10:	a1 80 8e 11 80       	mov    0x80118e80,%eax
80106f15:	85 c0                	test   %eax,%eax
80106f17:	74 47                	je     80106f60 <uartputc+0x50>
{
80106f19:	55                   	push   %ebp
80106f1a:	89 e5                	mov    %esp,%ebp
80106f1c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106f22:	53                   	push   %ebx
80106f23:	bb 80 00 00 00       	mov    $0x80,%ebx
80106f28:	eb 18                	jmp    80106f42 <uartputc+0x32>
80106f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106f30:	83 ec 0c             	sub    $0xc,%esp
80106f33:	6a 0a                	push   $0xa
80106f35:	e8 f6 b9 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f3a:	83 c4 10             	add    $0x10,%esp
80106f3d:	83 eb 01             	sub    $0x1,%ebx
80106f40:	74 07                	je     80106f49 <uartputc+0x39>
80106f42:	89 f2                	mov    %esi,%edx
80106f44:	ec                   	in     (%dx),%al
80106f45:	a8 20                	test   $0x20,%al
80106f47:	74 e7                	je     80106f30 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f49:	8b 45 08             	mov    0x8(%ebp),%eax
80106f4c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106f51:	ee                   	out    %al,(%dx)
}
80106f52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5d                   	pop    %ebp
80106f58:	c3                   	ret    
80106f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f60:	c3                   	ret    
80106f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f6f:	90                   	nop

80106f70 <uartintr>:

void
uartintr(void)
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106f76:	68 00 6e 10 80       	push   $0x80106e00
80106f7b:	e8 00 99 ff ff       	call   80100880 <consoleintr>
}
80106f80:	83 c4 10             	add    $0x10,%esp
80106f83:	c9                   	leave  
80106f84:	c3                   	ret    

80106f85 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $0
80106f87:	6a 00                	push   $0x0
  jmp alltraps
80106f89:	e9 07 fb ff ff       	jmp    80106a95 <alltraps>

80106f8e <vector1>:
.globl vector1
vector1:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $1
80106f90:	6a 01                	push   $0x1
  jmp alltraps
80106f92:	e9 fe fa ff ff       	jmp    80106a95 <alltraps>

80106f97 <vector2>:
.globl vector2
vector2:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $2
80106f99:	6a 02                	push   $0x2
  jmp alltraps
80106f9b:	e9 f5 fa ff ff       	jmp    80106a95 <alltraps>

80106fa0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106fa0:	6a 00                	push   $0x0
  pushl $3
80106fa2:	6a 03                	push   $0x3
  jmp alltraps
80106fa4:	e9 ec fa ff ff       	jmp    80106a95 <alltraps>

80106fa9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106fa9:	6a 00                	push   $0x0
  pushl $4
80106fab:	6a 04                	push   $0x4
  jmp alltraps
80106fad:	e9 e3 fa ff ff       	jmp    80106a95 <alltraps>

80106fb2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $5
80106fb4:	6a 05                	push   $0x5
  jmp alltraps
80106fb6:	e9 da fa ff ff       	jmp    80106a95 <alltraps>

80106fbb <vector6>:
.globl vector6
vector6:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $6
80106fbd:	6a 06                	push   $0x6
  jmp alltraps
80106fbf:	e9 d1 fa ff ff       	jmp    80106a95 <alltraps>

80106fc4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106fc4:	6a 00                	push   $0x0
  pushl $7
80106fc6:	6a 07                	push   $0x7
  jmp alltraps
80106fc8:	e9 c8 fa ff ff       	jmp    80106a95 <alltraps>

80106fcd <vector8>:
.globl vector8
vector8:
  pushl $8
80106fcd:	6a 08                	push   $0x8
  jmp alltraps
80106fcf:	e9 c1 fa ff ff       	jmp    80106a95 <alltraps>

80106fd4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106fd4:	6a 00                	push   $0x0
  pushl $9
80106fd6:	6a 09                	push   $0x9
  jmp alltraps
80106fd8:	e9 b8 fa ff ff       	jmp    80106a95 <alltraps>

80106fdd <vector10>:
.globl vector10
vector10:
  pushl $10
80106fdd:	6a 0a                	push   $0xa
  jmp alltraps
80106fdf:	e9 b1 fa ff ff       	jmp    80106a95 <alltraps>

80106fe4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106fe4:	6a 0b                	push   $0xb
  jmp alltraps
80106fe6:	e9 aa fa ff ff       	jmp    80106a95 <alltraps>

80106feb <vector12>:
.globl vector12
vector12:
  pushl $12
80106feb:	6a 0c                	push   $0xc
  jmp alltraps
80106fed:	e9 a3 fa ff ff       	jmp    80106a95 <alltraps>

80106ff2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ff2:	6a 0d                	push   $0xd
  jmp alltraps
80106ff4:	e9 9c fa ff ff       	jmp    80106a95 <alltraps>

80106ff9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ff9:	6a 0e                	push   $0xe
  jmp alltraps
80106ffb:	e9 95 fa ff ff       	jmp    80106a95 <alltraps>

80107000 <vector15>:
.globl vector15
vector15:
  pushl $0
80107000:	6a 00                	push   $0x0
  pushl $15
80107002:	6a 0f                	push   $0xf
  jmp alltraps
80107004:	e9 8c fa ff ff       	jmp    80106a95 <alltraps>

80107009 <vector16>:
.globl vector16
vector16:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $16
8010700b:	6a 10                	push   $0x10
  jmp alltraps
8010700d:	e9 83 fa ff ff       	jmp    80106a95 <alltraps>

80107012 <vector17>:
.globl vector17
vector17:
  pushl $17
80107012:	6a 11                	push   $0x11
  jmp alltraps
80107014:	e9 7c fa ff ff       	jmp    80106a95 <alltraps>

80107019 <vector18>:
.globl vector18
vector18:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $18
8010701b:	6a 12                	push   $0x12
  jmp alltraps
8010701d:	e9 73 fa ff ff       	jmp    80106a95 <alltraps>

80107022 <vector19>:
.globl vector19
vector19:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $19
80107024:	6a 13                	push   $0x13
  jmp alltraps
80107026:	e9 6a fa ff ff       	jmp    80106a95 <alltraps>

8010702b <vector20>:
.globl vector20
vector20:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $20
8010702d:	6a 14                	push   $0x14
  jmp alltraps
8010702f:	e9 61 fa ff ff       	jmp    80106a95 <alltraps>

80107034 <vector21>:
.globl vector21
vector21:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $21
80107036:	6a 15                	push   $0x15
  jmp alltraps
80107038:	e9 58 fa ff ff       	jmp    80106a95 <alltraps>

8010703d <vector22>:
.globl vector22
vector22:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $22
8010703f:	6a 16                	push   $0x16
  jmp alltraps
80107041:	e9 4f fa ff ff       	jmp    80106a95 <alltraps>

80107046 <vector23>:
.globl vector23
vector23:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $23
80107048:	6a 17                	push   $0x17
  jmp alltraps
8010704a:	e9 46 fa ff ff       	jmp    80106a95 <alltraps>

8010704f <vector24>:
.globl vector24
vector24:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $24
80107051:	6a 18                	push   $0x18
  jmp alltraps
80107053:	e9 3d fa ff ff       	jmp    80106a95 <alltraps>

80107058 <vector25>:
.globl vector25
vector25:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $25
8010705a:	6a 19                	push   $0x19
  jmp alltraps
8010705c:	e9 34 fa ff ff       	jmp    80106a95 <alltraps>

80107061 <vector26>:
.globl vector26
vector26:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $26
80107063:	6a 1a                	push   $0x1a
  jmp alltraps
80107065:	e9 2b fa ff ff       	jmp    80106a95 <alltraps>

8010706a <vector27>:
.globl vector27
vector27:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $27
8010706c:	6a 1b                	push   $0x1b
  jmp alltraps
8010706e:	e9 22 fa ff ff       	jmp    80106a95 <alltraps>

80107073 <vector28>:
.globl vector28
vector28:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $28
80107075:	6a 1c                	push   $0x1c
  jmp alltraps
80107077:	e9 19 fa ff ff       	jmp    80106a95 <alltraps>

8010707c <vector29>:
.globl vector29
vector29:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $29
8010707e:	6a 1d                	push   $0x1d
  jmp alltraps
80107080:	e9 10 fa ff ff       	jmp    80106a95 <alltraps>

80107085 <vector30>:
.globl vector30
vector30:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $30
80107087:	6a 1e                	push   $0x1e
  jmp alltraps
80107089:	e9 07 fa ff ff       	jmp    80106a95 <alltraps>

8010708e <vector31>:
.globl vector31
vector31:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $31
80107090:	6a 1f                	push   $0x1f
  jmp alltraps
80107092:	e9 fe f9 ff ff       	jmp    80106a95 <alltraps>

80107097 <vector32>:
.globl vector32
vector32:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $32
80107099:	6a 20                	push   $0x20
  jmp alltraps
8010709b:	e9 f5 f9 ff ff       	jmp    80106a95 <alltraps>

801070a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $33
801070a2:	6a 21                	push   $0x21
  jmp alltraps
801070a4:	e9 ec f9 ff ff       	jmp    80106a95 <alltraps>

801070a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $34
801070ab:	6a 22                	push   $0x22
  jmp alltraps
801070ad:	e9 e3 f9 ff ff       	jmp    80106a95 <alltraps>

801070b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $35
801070b4:	6a 23                	push   $0x23
  jmp alltraps
801070b6:	e9 da f9 ff ff       	jmp    80106a95 <alltraps>

801070bb <vector36>:
.globl vector36
vector36:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $36
801070bd:	6a 24                	push   $0x24
  jmp alltraps
801070bf:	e9 d1 f9 ff ff       	jmp    80106a95 <alltraps>

801070c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $37
801070c6:	6a 25                	push   $0x25
  jmp alltraps
801070c8:	e9 c8 f9 ff ff       	jmp    80106a95 <alltraps>

801070cd <vector38>:
.globl vector38
vector38:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $38
801070cf:	6a 26                	push   $0x26
  jmp alltraps
801070d1:	e9 bf f9 ff ff       	jmp    80106a95 <alltraps>

801070d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $39
801070d8:	6a 27                	push   $0x27
  jmp alltraps
801070da:	e9 b6 f9 ff ff       	jmp    80106a95 <alltraps>

801070df <vector40>:
.globl vector40
vector40:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $40
801070e1:	6a 28                	push   $0x28
  jmp alltraps
801070e3:	e9 ad f9 ff ff       	jmp    80106a95 <alltraps>

801070e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $41
801070ea:	6a 29                	push   $0x29
  jmp alltraps
801070ec:	e9 a4 f9 ff ff       	jmp    80106a95 <alltraps>

801070f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $42
801070f3:	6a 2a                	push   $0x2a
  jmp alltraps
801070f5:	e9 9b f9 ff ff       	jmp    80106a95 <alltraps>

801070fa <vector43>:
.globl vector43
vector43:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $43
801070fc:	6a 2b                	push   $0x2b
  jmp alltraps
801070fe:	e9 92 f9 ff ff       	jmp    80106a95 <alltraps>

80107103 <vector44>:
.globl vector44
vector44:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $44
80107105:	6a 2c                	push   $0x2c
  jmp alltraps
80107107:	e9 89 f9 ff ff       	jmp    80106a95 <alltraps>

8010710c <vector45>:
.globl vector45
vector45:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $45
8010710e:	6a 2d                	push   $0x2d
  jmp alltraps
80107110:	e9 80 f9 ff ff       	jmp    80106a95 <alltraps>

80107115 <vector46>:
.globl vector46
vector46:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $46
80107117:	6a 2e                	push   $0x2e
  jmp alltraps
80107119:	e9 77 f9 ff ff       	jmp    80106a95 <alltraps>

8010711e <vector47>:
.globl vector47
vector47:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $47
80107120:	6a 2f                	push   $0x2f
  jmp alltraps
80107122:	e9 6e f9 ff ff       	jmp    80106a95 <alltraps>

80107127 <vector48>:
.globl vector48
vector48:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $48
80107129:	6a 30                	push   $0x30
  jmp alltraps
8010712b:	e9 65 f9 ff ff       	jmp    80106a95 <alltraps>

80107130 <vector49>:
.globl vector49
vector49:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $49
80107132:	6a 31                	push   $0x31
  jmp alltraps
80107134:	e9 5c f9 ff ff       	jmp    80106a95 <alltraps>

80107139 <vector50>:
.globl vector50
vector50:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $50
8010713b:	6a 32                	push   $0x32
  jmp alltraps
8010713d:	e9 53 f9 ff ff       	jmp    80106a95 <alltraps>

80107142 <vector51>:
.globl vector51
vector51:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $51
80107144:	6a 33                	push   $0x33
  jmp alltraps
80107146:	e9 4a f9 ff ff       	jmp    80106a95 <alltraps>

8010714b <vector52>:
.globl vector52
vector52:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $52
8010714d:	6a 34                	push   $0x34
  jmp alltraps
8010714f:	e9 41 f9 ff ff       	jmp    80106a95 <alltraps>

80107154 <vector53>:
.globl vector53
vector53:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $53
80107156:	6a 35                	push   $0x35
  jmp alltraps
80107158:	e9 38 f9 ff ff       	jmp    80106a95 <alltraps>

8010715d <vector54>:
.globl vector54
vector54:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $54
8010715f:	6a 36                	push   $0x36
  jmp alltraps
80107161:	e9 2f f9 ff ff       	jmp    80106a95 <alltraps>

80107166 <vector55>:
.globl vector55
vector55:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $55
80107168:	6a 37                	push   $0x37
  jmp alltraps
8010716a:	e9 26 f9 ff ff       	jmp    80106a95 <alltraps>

8010716f <vector56>:
.globl vector56
vector56:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $56
80107171:	6a 38                	push   $0x38
  jmp alltraps
80107173:	e9 1d f9 ff ff       	jmp    80106a95 <alltraps>

80107178 <vector57>:
.globl vector57
vector57:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $57
8010717a:	6a 39                	push   $0x39
  jmp alltraps
8010717c:	e9 14 f9 ff ff       	jmp    80106a95 <alltraps>

80107181 <vector58>:
.globl vector58
vector58:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $58
80107183:	6a 3a                	push   $0x3a
  jmp alltraps
80107185:	e9 0b f9 ff ff       	jmp    80106a95 <alltraps>

8010718a <vector59>:
.globl vector59
vector59:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $59
8010718c:	6a 3b                	push   $0x3b
  jmp alltraps
8010718e:	e9 02 f9 ff ff       	jmp    80106a95 <alltraps>

80107193 <vector60>:
.globl vector60
vector60:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $60
80107195:	6a 3c                	push   $0x3c
  jmp alltraps
80107197:	e9 f9 f8 ff ff       	jmp    80106a95 <alltraps>

8010719c <vector61>:
.globl vector61
vector61:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $61
8010719e:	6a 3d                	push   $0x3d
  jmp alltraps
801071a0:	e9 f0 f8 ff ff       	jmp    80106a95 <alltraps>

801071a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $62
801071a7:	6a 3e                	push   $0x3e
  jmp alltraps
801071a9:	e9 e7 f8 ff ff       	jmp    80106a95 <alltraps>

801071ae <vector63>:
.globl vector63
vector63:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $63
801071b0:	6a 3f                	push   $0x3f
  jmp alltraps
801071b2:	e9 de f8 ff ff       	jmp    80106a95 <alltraps>

801071b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $64
801071b9:	6a 40                	push   $0x40
  jmp alltraps
801071bb:	e9 d5 f8 ff ff       	jmp    80106a95 <alltraps>

801071c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $65
801071c2:	6a 41                	push   $0x41
  jmp alltraps
801071c4:	e9 cc f8 ff ff       	jmp    80106a95 <alltraps>

801071c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $66
801071cb:	6a 42                	push   $0x42
  jmp alltraps
801071cd:	e9 c3 f8 ff ff       	jmp    80106a95 <alltraps>

801071d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $67
801071d4:	6a 43                	push   $0x43
  jmp alltraps
801071d6:	e9 ba f8 ff ff       	jmp    80106a95 <alltraps>

801071db <vector68>:
.globl vector68
vector68:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $68
801071dd:	6a 44                	push   $0x44
  jmp alltraps
801071df:	e9 b1 f8 ff ff       	jmp    80106a95 <alltraps>

801071e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $69
801071e6:	6a 45                	push   $0x45
  jmp alltraps
801071e8:	e9 a8 f8 ff ff       	jmp    80106a95 <alltraps>

801071ed <vector70>:
.globl vector70
vector70:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $70
801071ef:	6a 46                	push   $0x46
  jmp alltraps
801071f1:	e9 9f f8 ff ff       	jmp    80106a95 <alltraps>

801071f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $71
801071f8:	6a 47                	push   $0x47
  jmp alltraps
801071fa:	e9 96 f8 ff ff       	jmp    80106a95 <alltraps>

801071ff <vector72>:
.globl vector72
vector72:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $72
80107201:	6a 48                	push   $0x48
  jmp alltraps
80107203:	e9 8d f8 ff ff       	jmp    80106a95 <alltraps>

80107208 <vector73>:
.globl vector73
vector73:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $73
8010720a:	6a 49                	push   $0x49
  jmp alltraps
8010720c:	e9 84 f8 ff ff       	jmp    80106a95 <alltraps>

80107211 <vector74>:
.globl vector74
vector74:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $74
80107213:	6a 4a                	push   $0x4a
  jmp alltraps
80107215:	e9 7b f8 ff ff       	jmp    80106a95 <alltraps>

8010721a <vector75>:
.globl vector75
vector75:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $75
8010721c:	6a 4b                	push   $0x4b
  jmp alltraps
8010721e:	e9 72 f8 ff ff       	jmp    80106a95 <alltraps>

80107223 <vector76>:
.globl vector76
vector76:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $76
80107225:	6a 4c                	push   $0x4c
  jmp alltraps
80107227:	e9 69 f8 ff ff       	jmp    80106a95 <alltraps>

8010722c <vector77>:
.globl vector77
vector77:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $77
8010722e:	6a 4d                	push   $0x4d
  jmp alltraps
80107230:	e9 60 f8 ff ff       	jmp    80106a95 <alltraps>

80107235 <vector78>:
.globl vector78
vector78:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $78
80107237:	6a 4e                	push   $0x4e
  jmp alltraps
80107239:	e9 57 f8 ff ff       	jmp    80106a95 <alltraps>

8010723e <vector79>:
.globl vector79
vector79:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $79
80107240:	6a 4f                	push   $0x4f
  jmp alltraps
80107242:	e9 4e f8 ff ff       	jmp    80106a95 <alltraps>

80107247 <vector80>:
.globl vector80
vector80:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $80
80107249:	6a 50                	push   $0x50
  jmp alltraps
8010724b:	e9 45 f8 ff ff       	jmp    80106a95 <alltraps>

80107250 <vector81>:
.globl vector81
vector81:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $81
80107252:	6a 51                	push   $0x51
  jmp alltraps
80107254:	e9 3c f8 ff ff       	jmp    80106a95 <alltraps>

80107259 <vector82>:
.globl vector82
vector82:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $82
8010725b:	6a 52                	push   $0x52
  jmp alltraps
8010725d:	e9 33 f8 ff ff       	jmp    80106a95 <alltraps>

80107262 <vector83>:
.globl vector83
vector83:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $83
80107264:	6a 53                	push   $0x53
  jmp alltraps
80107266:	e9 2a f8 ff ff       	jmp    80106a95 <alltraps>

8010726b <vector84>:
.globl vector84
vector84:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $84
8010726d:	6a 54                	push   $0x54
  jmp alltraps
8010726f:	e9 21 f8 ff ff       	jmp    80106a95 <alltraps>

80107274 <vector85>:
.globl vector85
vector85:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $85
80107276:	6a 55                	push   $0x55
  jmp alltraps
80107278:	e9 18 f8 ff ff       	jmp    80106a95 <alltraps>

8010727d <vector86>:
.globl vector86
vector86:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $86
8010727f:	6a 56                	push   $0x56
  jmp alltraps
80107281:	e9 0f f8 ff ff       	jmp    80106a95 <alltraps>

80107286 <vector87>:
.globl vector87
vector87:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $87
80107288:	6a 57                	push   $0x57
  jmp alltraps
8010728a:	e9 06 f8 ff ff       	jmp    80106a95 <alltraps>

8010728f <vector88>:
.globl vector88
vector88:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $88
80107291:	6a 58                	push   $0x58
  jmp alltraps
80107293:	e9 fd f7 ff ff       	jmp    80106a95 <alltraps>

80107298 <vector89>:
.globl vector89
vector89:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $89
8010729a:	6a 59                	push   $0x59
  jmp alltraps
8010729c:	e9 f4 f7 ff ff       	jmp    80106a95 <alltraps>

801072a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $90
801072a3:	6a 5a                	push   $0x5a
  jmp alltraps
801072a5:	e9 eb f7 ff ff       	jmp    80106a95 <alltraps>

801072aa <vector91>:
.globl vector91
vector91:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $91
801072ac:	6a 5b                	push   $0x5b
  jmp alltraps
801072ae:	e9 e2 f7 ff ff       	jmp    80106a95 <alltraps>

801072b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $92
801072b5:	6a 5c                	push   $0x5c
  jmp alltraps
801072b7:	e9 d9 f7 ff ff       	jmp    80106a95 <alltraps>

801072bc <vector93>:
.globl vector93
vector93:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $93
801072be:	6a 5d                	push   $0x5d
  jmp alltraps
801072c0:	e9 d0 f7 ff ff       	jmp    80106a95 <alltraps>

801072c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $94
801072c7:	6a 5e                	push   $0x5e
  jmp alltraps
801072c9:	e9 c7 f7 ff ff       	jmp    80106a95 <alltraps>

801072ce <vector95>:
.globl vector95
vector95:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $95
801072d0:	6a 5f                	push   $0x5f
  jmp alltraps
801072d2:	e9 be f7 ff ff       	jmp    80106a95 <alltraps>

801072d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $96
801072d9:	6a 60                	push   $0x60
  jmp alltraps
801072db:	e9 b5 f7 ff ff       	jmp    80106a95 <alltraps>

801072e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $97
801072e2:	6a 61                	push   $0x61
  jmp alltraps
801072e4:	e9 ac f7 ff ff       	jmp    80106a95 <alltraps>

801072e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $98
801072eb:	6a 62                	push   $0x62
  jmp alltraps
801072ed:	e9 a3 f7 ff ff       	jmp    80106a95 <alltraps>

801072f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $99
801072f4:	6a 63                	push   $0x63
  jmp alltraps
801072f6:	e9 9a f7 ff ff       	jmp    80106a95 <alltraps>

801072fb <vector100>:
.globl vector100
vector100:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $100
801072fd:	6a 64                	push   $0x64
  jmp alltraps
801072ff:	e9 91 f7 ff ff       	jmp    80106a95 <alltraps>

80107304 <vector101>:
.globl vector101
vector101:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $101
80107306:	6a 65                	push   $0x65
  jmp alltraps
80107308:	e9 88 f7 ff ff       	jmp    80106a95 <alltraps>

8010730d <vector102>:
.globl vector102
vector102:
  pushl $0
8010730d:	6a 00                	push   $0x0
  pushl $102
8010730f:	6a 66                	push   $0x66
  jmp alltraps
80107311:	e9 7f f7 ff ff       	jmp    80106a95 <alltraps>

80107316 <vector103>:
.globl vector103
vector103:
  pushl $0
80107316:	6a 00                	push   $0x0
  pushl $103
80107318:	6a 67                	push   $0x67
  jmp alltraps
8010731a:	e9 76 f7 ff ff       	jmp    80106a95 <alltraps>

8010731f <vector104>:
.globl vector104
vector104:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $104
80107321:	6a 68                	push   $0x68
  jmp alltraps
80107323:	e9 6d f7 ff ff       	jmp    80106a95 <alltraps>

80107328 <vector105>:
.globl vector105
vector105:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $105
8010732a:	6a 69                	push   $0x69
  jmp alltraps
8010732c:	e9 64 f7 ff ff       	jmp    80106a95 <alltraps>

80107331 <vector106>:
.globl vector106
vector106:
  pushl $0
80107331:	6a 00                	push   $0x0
  pushl $106
80107333:	6a 6a                	push   $0x6a
  jmp alltraps
80107335:	e9 5b f7 ff ff       	jmp    80106a95 <alltraps>

8010733a <vector107>:
.globl vector107
vector107:
  pushl $0
8010733a:	6a 00                	push   $0x0
  pushl $107
8010733c:	6a 6b                	push   $0x6b
  jmp alltraps
8010733e:	e9 52 f7 ff ff       	jmp    80106a95 <alltraps>

80107343 <vector108>:
.globl vector108
vector108:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $108
80107345:	6a 6c                	push   $0x6c
  jmp alltraps
80107347:	e9 49 f7 ff ff       	jmp    80106a95 <alltraps>

8010734c <vector109>:
.globl vector109
vector109:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $109
8010734e:	6a 6d                	push   $0x6d
  jmp alltraps
80107350:	e9 40 f7 ff ff       	jmp    80106a95 <alltraps>

80107355 <vector110>:
.globl vector110
vector110:
  pushl $0
80107355:	6a 00                	push   $0x0
  pushl $110
80107357:	6a 6e                	push   $0x6e
  jmp alltraps
80107359:	e9 37 f7 ff ff       	jmp    80106a95 <alltraps>

8010735e <vector111>:
.globl vector111
vector111:
  pushl $0
8010735e:	6a 00                	push   $0x0
  pushl $111
80107360:	6a 6f                	push   $0x6f
  jmp alltraps
80107362:	e9 2e f7 ff ff       	jmp    80106a95 <alltraps>

80107367 <vector112>:
.globl vector112
vector112:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $112
80107369:	6a 70                	push   $0x70
  jmp alltraps
8010736b:	e9 25 f7 ff ff       	jmp    80106a95 <alltraps>

80107370 <vector113>:
.globl vector113
vector113:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $113
80107372:	6a 71                	push   $0x71
  jmp alltraps
80107374:	e9 1c f7 ff ff       	jmp    80106a95 <alltraps>

80107379 <vector114>:
.globl vector114
vector114:
  pushl $0
80107379:	6a 00                	push   $0x0
  pushl $114
8010737b:	6a 72                	push   $0x72
  jmp alltraps
8010737d:	e9 13 f7 ff ff       	jmp    80106a95 <alltraps>

80107382 <vector115>:
.globl vector115
vector115:
  pushl $0
80107382:	6a 00                	push   $0x0
  pushl $115
80107384:	6a 73                	push   $0x73
  jmp alltraps
80107386:	e9 0a f7 ff ff       	jmp    80106a95 <alltraps>

8010738b <vector116>:
.globl vector116
vector116:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $116
8010738d:	6a 74                	push   $0x74
  jmp alltraps
8010738f:	e9 01 f7 ff ff       	jmp    80106a95 <alltraps>

80107394 <vector117>:
.globl vector117
vector117:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $117
80107396:	6a 75                	push   $0x75
  jmp alltraps
80107398:	e9 f8 f6 ff ff       	jmp    80106a95 <alltraps>

8010739d <vector118>:
.globl vector118
vector118:
  pushl $0
8010739d:	6a 00                	push   $0x0
  pushl $118
8010739f:	6a 76                	push   $0x76
  jmp alltraps
801073a1:	e9 ef f6 ff ff       	jmp    80106a95 <alltraps>

801073a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801073a6:	6a 00                	push   $0x0
  pushl $119
801073a8:	6a 77                	push   $0x77
  jmp alltraps
801073aa:	e9 e6 f6 ff ff       	jmp    80106a95 <alltraps>

801073af <vector120>:
.globl vector120
vector120:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $120
801073b1:	6a 78                	push   $0x78
  jmp alltraps
801073b3:	e9 dd f6 ff ff       	jmp    80106a95 <alltraps>

801073b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801073b8:	6a 00                	push   $0x0
  pushl $121
801073ba:	6a 79                	push   $0x79
  jmp alltraps
801073bc:	e9 d4 f6 ff ff       	jmp    80106a95 <alltraps>

801073c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801073c1:	6a 00                	push   $0x0
  pushl $122
801073c3:	6a 7a                	push   $0x7a
  jmp alltraps
801073c5:	e9 cb f6 ff ff       	jmp    80106a95 <alltraps>

801073ca <vector123>:
.globl vector123
vector123:
  pushl $0
801073ca:	6a 00                	push   $0x0
  pushl $123
801073cc:	6a 7b                	push   $0x7b
  jmp alltraps
801073ce:	e9 c2 f6 ff ff       	jmp    80106a95 <alltraps>

801073d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $124
801073d5:	6a 7c                	push   $0x7c
  jmp alltraps
801073d7:	e9 b9 f6 ff ff       	jmp    80106a95 <alltraps>

801073dc <vector125>:
.globl vector125
vector125:
  pushl $0
801073dc:	6a 00                	push   $0x0
  pushl $125
801073de:	6a 7d                	push   $0x7d
  jmp alltraps
801073e0:	e9 b0 f6 ff ff       	jmp    80106a95 <alltraps>

801073e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801073e5:	6a 00                	push   $0x0
  pushl $126
801073e7:	6a 7e                	push   $0x7e
  jmp alltraps
801073e9:	e9 a7 f6 ff ff       	jmp    80106a95 <alltraps>

801073ee <vector127>:
.globl vector127
vector127:
  pushl $0
801073ee:	6a 00                	push   $0x0
  pushl $127
801073f0:	6a 7f                	push   $0x7f
  jmp alltraps
801073f2:	e9 9e f6 ff ff       	jmp    80106a95 <alltraps>

801073f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $128
801073f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801073fe:	e9 92 f6 ff ff       	jmp    80106a95 <alltraps>

80107403 <vector129>:
.globl vector129
vector129:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $129
80107405:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010740a:	e9 86 f6 ff ff       	jmp    80106a95 <alltraps>

8010740f <vector130>:
.globl vector130
vector130:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $130
80107411:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107416:	e9 7a f6 ff ff       	jmp    80106a95 <alltraps>

8010741b <vector131>:
.globl vector131
vector131:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $131
8010741d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107422:	e9 6e f6 ff ff       	jmp    80106a95 <alltraps>

80107427 <vector132>:
.globl vector132
vector132:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $132
80107429:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010742e:	e9 62 f6 ff ff       	jmp    80106a95 <alltraps>

80107433 <vector133>:
.globl vector133
vector133:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $133
80107435:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010743a:	e9 56 f6 ff ff       	jmp    80106a95 <alltraps>

8010743f <vector134>:
.globl vector134
vector134:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $134
80107441:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107446:	e9 4a f6 ff ff       	jmp    80106a95 <alltraps>

8010744b <vector135>:
.globl vector135
vector135:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $135
8010744d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107452:	e9 3e f6 ff ff       	jmp    80106a95 <alltraps>

80107457 <vector136>:
.globl vector136
vector136:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $136
80107459:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010745e:	e9 32 f6 ff ff       	jmp    80106a95 <alltraps>

80107463 <vector137>:
.globl vector137
vector137:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $137
80107465:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010746a:	e9 26 f6 ff ff       	jmp    80106a95 <alltraps>

8010746f <vector138>:
.globl vector138
vector138:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $138
80107471:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107476:	e9 1a f6 ff ff       	jmp    80106a95 <alltraps>

8010747b <vector139>:
.globl vector139
vector139:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $139
8010747d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107482:	e9 0e f6 ff ff       	jmp    80106a95 <alltraps>

80107487 <vector140>:
.globl vector140
vector140:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $140
80107489:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010748e:	e9 02 f6 ff ff       	jmp    80106a95 <alltraps>

80107493 <vector141>:
.globl vector141
vector141:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $141
80107495:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010749a:	e9 f6 f5 ff ff       	jmp    80106a95 <alltraps>

8010749f <vector142>:
.globl vector142
vector142:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $142
801074a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801074a6:	e9 ea f5 ff ff       	jmp    80106a95 <alltraps>

801074ab <vector143>:
.globl vector143
vector143:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $143
801074ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801074b2:	e9 de f5 ff ff       	jmp    80106a95 <alltraps>

801074b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $144
801074b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801074be:	e9 d2 f5 ff ff       	jmp    80106a95 <alltraps>

801074c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $145
801074c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801074ca:	e9 c6 f5 ff ff       	jmp    80106a95 <alltraps>

801074cf <vector146>:
.globl vector146
vector146:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $146
801074d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801074d6:	e9 ba f5 ff ff       	jmp    80106a95 <alltraps>

801074db <vector147>:
.globl vector147
vector147:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $147
801074dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801074e2:	e9 ae f5 ff ff       	jmp    80106a95 <alltraps>

801074e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $148
801074e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801074ee:	e9 a2 f5 ff ff       	jmp    80106a95 <alltraps>

801074f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $149
801074f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801074fa:	e9 96 f5 ff ff       	jmp    80106a95 <alltraps>

801074ff <vector150>:
.globl vector150
vector150:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $150
80107501:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107506:	e9 8a f5 ff ff       	jmp    80106a95 <alltraps>

8010750b <vector151>:
.globl vector151
vector151:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $151
8010750d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107512:	e9 7e f5 ff ff       	jmp    80106a95 <alltraps>

80107517 <vector152>:
.globl vector152
vector152:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $152
80107519:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010751e:	e9 72 f5 ff ff       	jmp    80106a95 <alltraps>

80107523 <vector153>:
.globl vector153
vector153:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $153
80107525:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010752a:	e9 66 f5 ff ff       	jmp    80106a95 <alltraps>

8010752f <vector154>:
.globl vector154
vector154:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $154
80107531:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107536:	e9 5a f5 ff ff       	jmp    80106a95 <alltraps>

8010753b <vector155>:
.globl vector155
vector155:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $155
8010753d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107542:	e9 4e f5 ff ff       	jmp    80106a95 <alltraps>

80107547 <vector156>:
.globl vector156
vector156:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $156
80107549:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010754e:	e9 42 f5 ff ff       	jmp    80106a95 <alltraps>

80107553 <vector157>:
.globl vector157
vector157:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $157
80107555:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010755a:	e9 36 f5 ff ff       	jmp    80106a95 <alltraps>

8010755f <vector158>:
.globl vector158
vector158:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $158
80107561:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107566:	e9 2a f5 ff ff       	jmp    80106a95 <alltraps>

8010756b <vector159>:
.globl vector159
vector159:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $159
8010756d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107572:	e9 1e f5 ff ff       	jmp    80106a95 <alltraps>

80107577 <vector160>:
.globl vector160
vector160:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $160
80107579:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010757e:	e9 12 f5 ff ff       	jmp    80106a95 <alltraps>

80107583 <vector161>:
.globl vector161
vector161:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $161
80107585:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010758a:	e9 06 f5 ff ff       	jmp    80106a95 <alltraps>

8010758f <vector162>:
.globl vector162
vector162:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $162
80107591:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107596:	e9 fa f4 ff ff       	jmp    80106a95 <alltraps>

8010759b <vector163>:
.globl vector163
vector163:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $163
8010759d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801075a2:	e9 ee f4 ff ff       	jmp    80106a95 <alltraps>

801075a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $164
801075a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801075ae:	e9 e2 f4 ff ff       	jmp    80106a95 <alltraps>

801075b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $165
801075b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801075ba:	e9 d6 f4 ff ff       	jmp    80106a95 <alltraps>

801075bf <vector166>:
.globl vector166
vector166:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $166
801075c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801075c6:	e9 ca f4 ff ff       	jmp    80106a95 <alltraps>

801075cb <vector167>:
.globl vector167
vector167:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $167
801075cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801075d2:	e9 be f4 ff ff       	jmp    80106a95 <alltraps>

801075d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $168
801075d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801075de:	e9 b2 f4 ff ff       	jmp    80106a95 <alltraps>

801075e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $169
801075e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801075ea:	e9 a6 f4 ff ff       	jmp    80106a95 <alltraps>

801075ef <vector170>:
.globl vector170
vector170:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $170
801075f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801075f6:	e9 9a f4 ff ff       	jmp    80106a95 <alltraps>

801075fb <vector171>:
.globl vector171
vector171:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $171
801075fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107602:	e9 8e f4 ff ff       	jmp    80106a95 <alltraps>

80107607 <vector172>:
.globl vector172
vector172:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $172
80107609:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010760e:	e9 82 f4 ff ff       	jmp    80106a95 <alltraps>

80107613 <vector173>:
.globl vector173
vector173:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $173
80107615:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010761a:	e9 76 f4 ff ff       	jmp    80106a95 <alltraps>

8010761f <vector174>:
.globl vector174
vector174:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $174
80107621:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107626:	e9 6a f4 ff ff       	jmp    80106a95 <alltraps>

8010762b <vector175>:
.globl vector175
vector175:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $175
8010762d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107632:	e9 5e f4 ff ff       	jmp    80106a95 <alltraps>

80107637 <vector176>:
.globl vector176
vector176:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $176
80107639:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010763e:	e9 52 f4 ff ff       	jmp    80106a95 <alltraps>

80107643 <vector177>:
.globl vector177
vector177:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $177
80107645:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010764a:	e9 46 f4 ff ff       	jmp    80106a95 <alltraps>

8010764f <vector178>:
.globl vector178
vector178:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $178
80107651:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107656:	e9 3a f4 ff ff       	jmp    80106a95 <alltraps>

8010765b <vector179>:
.globl vector179
vector179:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $179
8010765d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107662:	e9 2e f4 ff ff       	jmp    80106a95 <alltraps>

80107667 <vector180>:
.globl vector180
vector180:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $180
80107669:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010766e:	e9 22 f4 ff ff       	jmp    80106a95 <alltraps>

80107673 <vector181>:
.globl vector181
vector181:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $181
80107675:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010767a:	e9 16 f4 ff ff       	jmp    80106a95 <alltraps>

8010767f <vector182>:
.globl vector182
vector182:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $182
80107681:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107686:	e9 0a f4 ff ff       	jmp    80106a95 <alltraps>

8010768b <vector183>:
.globl vector183
vector183:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $183
8010768d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107692:	e9 fe f3 ff ff       	jmp    80106a95 <alltraps>

80107697 <vector184>:
.globl vector184
vector184:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $184
80107699:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010769e:	e9 f2 f3 ff ff       	jmp    80106a95 <alltraps>

801076a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $185
801076a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801076aa:	e9 e6 f3 ff ff       	jmp    80106a95 <alltraps>

801076af <vector186>:
.globl vector186
vector186:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $186
801076b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801076b6:	e9 da f3 ff ff       	jmp    80106a95 <alltraps>

801076bb <vector187>:
.globl vector187
vector187:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $187
801076bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801076c2:	e9 ce f3 ff ff       	jmp    80106a95 <alltraps>

801076c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $188
801076c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801076ce:	e9 c2 f3 ff ff       	jmp    80106a95 <alltraps>

801076d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $189
801076d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801076da:	e9 b6 f3 ff ff       	jmp    80106a95 <alltraps>

801076df <vector190>:
.globl vector190
vector190:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $190
801076e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801076e6:	e9 aa f3 ff ff       	jmp    80106a95 <alltraps>

801076eb <vector191>:
.globl vector191
vector191:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $191
801076ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801076f2:	e9 9e f3 ff ff       	jmp    80106a95 <alltraps>

801076f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $192
801076f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801076fe:	e9 92 f3 ff ff       	jmp    80106a95 <alltraps>

80107703 <vector193>:
.globl vector193
vector193:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $193
80107705:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010770a:	e9 86 f3 ff ff       	jmp    80106a95 <alltraps>

8010770f <vector194>:
.globl vector194
vector194:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $194
80107711:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107716:	e9 7a f3 ff ff       	jmp    80106a95 <alltraps>

8010771b <vector195>:
.globl vector195
vector195:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $195
8010771d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107722:	e9 6e f3 ff ff       	jmp    80106a95 <alltraps>

80107727 <vector196>:
.globl vector196
vector196:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $196
80107729:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010772e:	e9 62 f3 ff ff       	jmp    80106a95 <alltraps>

80107733 <vector197>:
.globl vector197
vector197:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $197
80107735:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010773a:	e9 56 f3 ff ff       	jmp    80106a95 <alltraps>

8010773f <vector198>:
.globl vector198
vector198:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $198
80107741:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107746:	e9 4a f3 ff ff       	jmp    80106a95 <alltraps>

8010774b <vector199>:
.globl vector199
vector199:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $199
8010774d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107752:	e9 3e f3 ff ff       	jmp    80106a95 <alltraps>

80107757 <vector200>:
.globl vector200
vector200:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $200
80107759:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010775e:	e9 32 f3 ff ff       	jmp    80106a95 <alltraps>

80107763 <vector201>:
.globl vector201
vector201:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $201
80107765:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010776a:	e9 26 f3 ff ff       	jmp    80106a95 <alltraps>

8010776f <vector202>:
.globl vector202
vector202:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $202
80107771:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107776:	e9 1a f3 ff ff       	jmp    80106a95 <alltraps>

8010777b <vector203>:
.globl vector203
vector203:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $203
8010777d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107782:	e9 0e f3 ff ff       	jmp    80106a95 <alltraps>

80107787 <vector204>:
.globl vector204
vector204:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $204
80107789:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010778e:	e9 02 f3 ff ff       	jmp    80106a95 <alltraps>

80107793 <vector205>:
.globl vector205
vector205:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $205
80107795:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010779a:	e9 f6 f2 ff ff       	jmp    80106a95 <alltraps>

8010779f <vector206>:
.globl vector206
vector206:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $206
801077a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801077a6:	e9 ea f2 ff ff       	jmp    80106a95 <alltraps>

801077ab <vector207>:
.globl vector207
vector207:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $207
801077ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801077b2:	e9 de f2 ff ff       	jmp    80106a95 <alltraps>

801077b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $208
801077b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801077be:	e9 d2 f2 ff ff       	jmp    80106a95 <alltraps>

801077c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $209
801077c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801077ca:	e9 c6 f2 ff ff       	jmp    80106a95 <alltraps>

801077cf <vector210>:
.globl vector210
vector210:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $210
801077d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801077d6:	e9 ba f2 ff ff       	jmp    80106a95 <alltraps>

801077db <vector211>:
.globl vector211
vector211:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $211
801077dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801077e2:	e9 ae f2 ff ff       	jmp    80106a95 <alltraps>

801077e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $212
801077e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801077ee:	e9 a2 f2 ff ff       	jmp    80106a95 <alltraps>

801077f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $213
801077f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801077fa:	e9 96 f2 ff ff       	jmp    80106a95 <alltraps>

801077ff <vector214>:
.globl vector214
vector214:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $214
80107801:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107806:	e9 8a f2 ff ff       	jmp    80106a95 <alltraps>

8010780b <vector215>:
.globl vector215
vector215:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $215
8010780d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107812:	e9 7e f2 ff ff       	jmp    80106a95 <alltraps>

80107817 <vector216>:
.globl vector216
vector216:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $216
80107819:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010781e:	e9 72 f2 ff ff       	jmp    80106a95 <alltraps>

80107823 <vector217>:
.globl vector217
vector217:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $217
80107825:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010782a:	e9 66 f2 ff ff       	jmp    80106a95 <alltraps>

8010782f <vector218>:
.globl vector218
vector218:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $218
80107831:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107836:	e9 5a f2 ff ff       	jmp    80106a95 <alltraps>

8010783b <vector219>:
.globl vector219
vector219:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $219
8010783d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107842:	e9 4e f2 ff ff       	jmp    80106a95 <alltraps>

80107847 <vector220>:
.globl vector220
vector220:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $220
80107849:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010784e:	e9 42 f2 ff ff       	jmp    80106a95 <alltraps>

80107853 <vector221>:
.globl vector221
vector221:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $221
80107855:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010785a:	e9 36 f2 ff ff       	jmp    80106a95 <alltraps>

8010785f <vector222>:
.globl vector222
vector222:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $222
80107861:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107866:	e9 2a f2 ff ff       	jmp    80106a95 <alltraps>

8010786b <vector223>:
.globl vector223
vector223:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $223
8010786d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107872:	e9 1e f2 ff ff       	jmp    80106a95 <alltraps>

80107877 <vector224>:
.globl vector224
vector224:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $224
80107879:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010787e:	e9 12 f2 ff ff       	jmp    80106a95 <alltraps>

80107883 <vector225>:
.globl vector225
vector225:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $225
80107885:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010788a:	e9 06 f2 ff ff       	jmp    80106a95 <alltraps>

8010788f <vector226>:
.globl vector226
vector226:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $226
80107891:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107896:	e9 fa f1 ff ff       	jmp    80106a95 <alltraps>

8010789b <vector227>:
.globl vector227
vector227:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $227
8010789d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801078a2:	e9 ee f1 ff ff       	jmp    80106a95 <alltraps>

801078a7 <vector228>:
.globl vector228
vector228:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $228
801078a9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801078ae:	e9 e2 f1 ff ff       	jmp    80106a95 <alltraps>

801078b3 <vector229>:
.globl vector229
vector229:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $229
801078b5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801078ba:	e9 d6 f1 ff ff       	jmp    80106a95 <alltraps>

801078bf <vector230>:
.globl vector230
vector230:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $230
801078c1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801078c6:	e9 ca f1 ff ff       	jmp    80106a95 <alltraps>

801078cb <vector231>:
.globl vector231
vector231:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $231
801078cd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801078d2:	e9 be f1 ff ff       	jmp    80106a95 <alltraps>

801078d7 <vector232>:
.globl vector232
vector232:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $232
801078d9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801078de:	e9 b2 f1 ff ff       	jmp    80106a95 <alltraps>

801078e3 <vector233>:
.globl vector233
vector233:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $233
801078e5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801078ea:	e9 a6 f1 ff ff       	jmp    80106a95 <alltraps>

801078ef <vector234>:
.globl vector234
vector234:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $234
801078f1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801078f6:	e9 9a f1 ff ff       	jmp    80106a95 <alltraps>

801078fb <vector235>:
.globl vector235
vector235:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $235
801078fd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107902:	e9 8e f1 ff ff       	jmp    80106a95 <alltraps>

80107907 <vector236>:
.globl vector236
vector236:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $236
80107909:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010790e:	e9 82 f1 ff ff       	jmp    80106a95 <alltraps>

80107913 <vector237>:
.globl vector237
vector237:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $237
80107915:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010791a:	e9 76 f1 ff ff       	jmp    80106a95 <alltraps>

8010791f <vector238>:
.globl vector238
vector238:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $238
80107921:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107926:	e9 6a f1 ff ff       	jmp    80106a95 <alltraps>

8010792b <vector239>:
.globl vector239
vector239:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $239
8010792d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107932:	e9 5e f1 ff ff       	jmp    80106a95 <alltraps>

80107937 <vector240>:
.globl vector240
vector240:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $240
80107939:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010793e:	e9 52 f1 ff ff       	jmp    80106a95 <alltraps>

80107943 <vector241>:
.globl vector241
vector241:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $241
80107945:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010794a:	e9 46 f1 ff ff       	jmp    80106a95 <alltraps>

8010794f <vector242>:
.globl vector242
vector242:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $242
80107951:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107956:	e9 3a f1 ff ff       	jmp    80106a95 <alltraps>

8010795b <vector243>:
.globl vector243
vector243:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $243
8010795d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107962:	e9 2e f1 ff ff       	jmp    80106a95 <alltraps>

80107967 <vector244>:
.globl vector244
vector244:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $244
80107969:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010796e:	e9 22 f1 ff ff       	jmp    80106a95 <alltraps>

80107973 <vector245>:
.globl vector245
vector245:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $245
80107975:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010797a:	e9 16 f1 ff ff       	jmp    80106a95 <alltraps>

8010797f <vector246>:
.globl vector246
vector246:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $246
80107981:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107986:	e9 0a f1 ff ff       	jmp    80106a95 <alltraps>

8010798b <vector247>:
.globl vector247
vector247:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $247
8010798d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107992:	e9 fe f0 ff ff       	jmp    80106a95 <alltraps>

80107997 <vector248>:
.globl vector248
vector248:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $248
80107999:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010799e:	e9 f2 f0 ff ff       	jmp    80106a95 <alltraps>

801079a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $249
801079a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801079aa:	e9 e6 f0 ff ff       	jmp    80106a95 <alltraps>

801079af <vector250>:
.globl vector250
vector250:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $250
801079b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801079b6:	e9 da f0 ff ff       	jmp    80106a95 <alltraps>

801079bb <vector251>:
.globl vector251
vector251:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $251
801079bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801079c2:	e9 ce f0 ff ff       	jmp    80106a95 <alltraps>

801079c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $252
801079c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801079ce:	e9 c2 f0 ff ff       	jmp    80106a95 <alltraps>

801079d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801079d3:	6a 00                	push   $0x0
  pushl $253
801079d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801079da:	e9 b6 f0 ff ff       	jmp    80106a95 <alltraps>

801079df <vector254>:
.globl vector254
vector254:
  pushl $0
801079df:	6a 00                	push   $0x0
  pushl $254
801079e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801079e6:	e9 aa f0 ff ff       	jmp    80106a95 <alltraps>

801079eb <vector255>:
.globl vector255
vector255:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $255
801079ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801079f2:	e9 9e f0 ff ff       	jmp    80106a95 <alltraps>
801079f7:	66 90                	xchg   %ax,%ax
801079f9:	66 90                	xchg   %ax,%ax
801079fb:	66 90                	xchg   %ax,%ax
801079fd:	66 90                	xchg   %ax,%ax
801079ff:	90                   	nop

80107a00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107a06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80107a0c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a12:	83 ec 1c             	sub    $0x1c,%esp
80107a15:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a18:	39 d3                	cmp    %edx,%ebx
80107a1a:	73 49                	jae    80107a65 <deallocuvm.part.0+0x65>
80107a1c:	89 c7                	mov    %eax,%edi
80107a1e:	eb 0c                	jmp    80107a2c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a20:	83 c0 01             	add    $0x1,%eax
80107a23:	c1 e0 16             	shl    $0x16,%eax
80107a26:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107a28:	39 da                	cmp    %ebx,%edx
80107a2a:	76 39                	jbe    80107a65 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80107a2c:	89 d8                	mov    %ebx,%eax
80107a2e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107a31:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107a34:	f6 c1 01             	test   $0x1,%cl
80107a37:	74 e7                	je     80107a20 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107a39:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a3b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a41:	c1 ee 0a             	shr    $0xa,%esi
80107a44:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107a4a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107a51:	85 f6                	test   %esi,%esi
80107a53:	74 cb                	je     80107a20 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107a55:	8b 06                	mov    (%esi),%eax
80107a57:	a8 01                	test   $0x1,%al
80107a59:	75 15                	jne    80107a70 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80107a5b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a61:	39 da                	cmp    %ebx,%edx
80107a63:	77 c7                	ja     80107a2c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a6b:	5b                   	pop    %ebx
80107a6c:	5e                   	pop    %esi
80107a6d:	5f                   	pop    %edi
80107a6e:	5d                   	pop    %ebp
80107a6f:	c3                   	ret    
      if(pa == 0)
80107a70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a75:	74 25                	je     80107a9c <deallocuvm.part.0+0x9c>
      kfree(v);
80107a77:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107a7a:	05 00 00 00 80       	add    $0x80000000,%eax
80107a7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a82:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107a88:	50                   	push   %eax
80107a89:	e8 32 aa ff ff       	call   801024c0 <kfree>
      *pte = 0;
80107a8e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107a94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a97:	83 c4 10             	add    $0x10,%esp
80107a9a:	eb 8c                	jmp    80107a28 <deallocuvm.part.0+0x28>
        panic("kfree");
80107a9c:	83 ec 0c             	sub    $0xc,%esp
80107a9f:	68 66 86 10 80       	push   $0x80108666
80107aa4:	e8 d7 88 ff ff       	call   80100380 <panic>
80107aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ab0 <mappages>:
{
80107ab0:	55                   	push   %ebp
80107ab1:	89 e5                	mov    %esp,%ebp
80107ab3:	57                   	push   %edi
80107ab4:	56                   	push   %esi
80107ab5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107ab6:	89 d3                	mov    %edx,%ebx
80107ab8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107abe:	83 ec 1c             	sub    $0x1c,%esp
80107ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ac4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107ac8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107acd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad3:	29 d8                	sub    %ebx,%eax
80107ad5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ad8:	eb 3d                	jmp    80107b17 <mappages+0x67>
80107ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107ae0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ae2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107ae7:	c1 ea 0a             	shr    $0xa,%edx
80107aea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107af0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107af7:	85 c0                	test   %eax,%eax
80107af9:	74 75                	je     80107b70 <mappages+0xc0>
    if(*pte & PTE_P)
80107afb:	f6 00 01             	testb  $0x1,(%eax)
80107afe:	0f 85 86 00 00 00    	jne    80107b8a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107b04:	0b 75 0c             	or     0xc(%ebp),%esi
80107b07:	83 ce 01             	or     $0x1,%esi
80107b0a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107b0c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80107b0f:	74 6f                	je     80107b80 <mappages+0xd0>
    a += PGSIZE;
80107b11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107b17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107b1a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b1d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107b20:	89 d8                	mov    %ebx,%eax
80107b22:	c1 e8 16             	shr    $0x16,%eax
80107b25:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107b28:	8b 07                	mov    (%edi),%eax
80107b2a:	a8 01                	test   $0x1,%al
80107b2c:	75 b2                	jne    80107ae0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b2e:	e8 4d ab ff ff       	call   80102680 <kalloc>
80107b33:	85 c0                	test   %eax,%eax
80107b35:	74 39                	je     80107b70 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107b37:	83 ec 04             	sub    $0x4,%esp
80107b3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107b3d:	68 00 10 00 00       	push   $0x1000
80107b42:	6a 00                	push   $0x0
80107b44:	50                   	push   %eax
80107b45:	e8 56 db ff ff       	call   801056a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107b4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107b4d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107b50:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107b56:	83 c8 07             	or     $0x7,%eax
80107b59:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107b5b:	89 d8                	mov    %ebx,%eax
80107b5d:	c1 e8 0a             	shr    $0xa,%eax
80107b60:	25 fc 0f 00 00       	and    $0xffc,%eax
80107b65:	01 d0                	add    %edx,%eax
80107b67:	eb 92                	jmp    80107afb <mappages+0x4b>
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b78:	5b                   	pop    %ebx
80107b79:	5e                   	pop    %esi
80107b7a:	5f                   	pop    %edi
80107b7b:	5d                   	pop    %ebp
80107b7c:	c3                   	ret    
80107b7d:	8d 76 00             	lea    0x0(%esi),%esi
80107b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b83:	31 c0                	xor    %eax,%eax
}
80107b85:	5b                   	pop    %ebx
80107b86:	5e                   	pop    %esi
80107b87:	5f                   	pop    %edi
80107b88:	5d                   	pop    %ebp
80107b89:	c3                   	ret    
      panic("remap");
80107b8a:	83 ec 0c             	sub    $0xc,%esp
80107b8d:	68 3c 8f 10 80       	push   $0x80108f3c
80107b92:	e8 e9 87 ff ff       	call   80100380 <panic>
80107b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b9e:	66 90                	xchg   %ax,%ax

80107ba0 <seginit>:
{
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107ba6:	e8 95 be ff ff       	call   80103a40 <cpuid>
  pd[0] = size-1;
80107bab:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107bb0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107bb6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107bba:	c7 80 58 39 11 80 ff 	movl   $0xffff,-0x7feec6a8(%eax)
80107bc1:	ff 00 00 
80107bc4:	c7 80 5c 39 11 80 00 	movl   $0xcf9a00,-0x7feec6a4(%eax)
80107bcb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107bce:	c7 80 60 39 11 80 ff 	movl   $0xffff,-0x7feec6a0(%eax)
80107bd5:	ff 00 00 
80107bd8:	c7 80 64 39 11 80 00 	movl   $0xcf9200,-0x7feec69c(%eax)
80107bdf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107be2:	c7 80 68 39 11 80 ff 	movl   $0xffff,-0x7feec698(%eax)
80107be9:	ff 00 00 
80107bec:	c7 80 6c 39 11 80 00 	movl   $0xcffa00,-0x7feec694(%eax)
80107bf3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107bf6:	c7 80 70 39 11 80 ff 	movl   $0xffff,-0x7feec690(%eax)
80107bfd:	ff 00 00 
80107c00:	c7 80 74 39 11 80 00 	movl   $0xcff200,-0x7feec68c(%eax)
80107c07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107c0a:	05 50 39 11 80       	add    $0x80113950,%eax
  pd[1] = (uint)p;
80107c0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107c13:	c1 e8 10             	shr    $0x10,%eax
80107c16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107c1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107c1d:	0f 01 10             	lgdtl  (%eax)
}
80107c20:	c9                   	leave  
80107c21:	c3                   	ret    
80107c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107c30:	a1 84 8e 11 80       	mov    0x80118e84,%eax
80107c35:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c3a:	0f 22 d8             	mov    %eax,%cr3
}
80107c3d:	c3                   	ret    
80107c3e:	66 90                	xchg   %ax,%ax

80107c40 <switchuvm>:
{
80107c40:	55                   	push   %ebp
80107c41:	89 e5                	mov    %esp,%ebp
80107c43:	57                   	push   %edi
80107c44:	56                   	push   %esi
80107c45:	53                   	push   %ebx
80107c46:	83 ec 1c             	sub    $0x1c,%esp
80107c49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107c4c:	85 f6                	test   %esi,%esi
80107c4e:	0f 84 cb 00 00 00    	je     80107d1f <switchuvm+0xdf>
  if(p->kstack == 0)
80107c54:	8b 46 08             	mov    0x8(%esi),%eax
80107c57:	85 c0                	test   %eax,%eax
80107c59:	0f 84 da 00 00 00    	je     80107d39 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107c5f:	8b 46 04             	mov    0x4(%esi),%eax
80107c62:	85 c0                	test   %eax,%eax
80107c64:	0f 84 c2 00 00 00    	je     80107d2c <switchuvm+0xec>
  pushcli();
80107c6a:	e8 81 d7 ff ff       	call   801053f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107c6f:	e8 6c bd ff ff       	call   801039e0 <mycpu>
80107c74:	89 c3                	mov    %eax,%ebx
80107c76:	e8 65 bd ff ff       	call   801039e0 <mycpu>
80107c7b:	89 c7                	mov    %eax,%edi
80107c7d:	e8 5e bd ff ff       	call   801039e0 <mycpu>
80107c82:	83 c7 08             	add    $0x8,%edi
80107c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c88:	e8 53 bd ff ff       	call   801039e0 <mycpu>
80107c8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107c90:	ba 67 00 00 00       	mov    $0x67,%edx
80107c95:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107c9c:	83 c0 08             	add    $0x8,%eax
80107c9f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107ca6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107cab:	83 c1 08             	add    $0x8,%ecx
80107cae:	c1 e8 18             	shr    $0x18,%eax
80107cb1:	c1 e9 10             	shr    $0x10,%ecx
80107cb4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107cba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107cc0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107cc5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107ccc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107cd1:	e8 0a bd ff ff       	call   801039e0 <mycpu>
80107cd6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107cdd:	e8 fe bc ff ff       	call   801039e0 <mycpu>
80107ce2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107ce6:	8b 5e 08             	mov    0x8(%esi),%ebx
80107ce9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107cef:	e8 ec bc ff ff       	call   801039e0 <mycpu>
80107cf4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107cf7:	e8 e4 bc ff ff       	call   801039e0 <mycpu>
80107cfc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107d00:	b8 28 00 00 00       	mov    $0x28,%eax
80107d05:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107d08:	8b 46 04             	mov    0x4(%esi),%eax
80107d0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d10:	0f 22 d8             	mov    %eax,%cr3
}
80107d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d16:	5b                   	pop    %ebx
80107d17:	5e                   	pop    %esi
80107d18:	5f                   	pop    %edi
80107d19:	5d                   	pop    %ebp
  popcli();
80107d1a:	e9 21 d7 ff ff       	jmp    80105440 <popcli>
    panic("switchuvm: no process");
80107d1f:	83 ec 0c             	sub    $0xc,%esp
80107d22:	68 42 8f 10 80       	push   $0x80108f42
80107d27:	e8 54 86 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107d2c:	83 ec 0c             	sub    $0xc,%esp
80107d2f:	68 6d 8f 10 80       	push   $0x80108f6d
80107d34:	e8 47 86 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107d39:	83 ec 0c             	sub    $0xc,%esp
80107d3c:	68 58 8f 10 80       	push   $0x80108f58
80107d41:	e8 3a 86 ff ff       	call   80100380 <panic>
80107d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d4d:	8d 76 00             	lea    0x0(%esi),%esi

80107d50 <inituvm>:
{
80107d50:	55                   	push   %ebp
80107d51:	89 e5                	mov    %esp,%ebp
80107d53:	57                   	push   %edi
80107d54:	56                   	push   %esi
80107d55:	53                   	push   %ebx
80107d56:	83 ec 1c             	sub    $0x1c,%esp
80107d59:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d5c:	8b 75 10             	mov    0x10(%ebp),%esi
80107d5f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107d62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107d65:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107d6b:	77 4b                	ja     80107db8 <inituvm+0x68>
  mem = kalloc();
80107d6d:	e8 0e a9 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107d72:	83 ec 04             	sub    $0x4,%esp
80107d75:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107d7a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107d7c:	6a 00                	push   $0x0
80107d7e:	50                   	push   %eax
80107d7f:	e8 1c d9 ff ff       	call   801056a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107d84:	58                   	pop    %eax
80107d85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d8b:	5a                   	pop    %edx
80107d8c:	6a 06                	push   $0x6
80107d8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d93:	31 d2                	xor    %edx,%edx
80107d95:	50                   	push   %eax
80107d96:	89 f8                	mov    %edi,%eax
80107d98:	e8 13 fd ff ff       	call   80107ab0 <mappages>
  memmove(mem, init, sz);
80107d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107da0:	89 75 10             	mov    %esi,0x10(%ebp)
80107da3:	83 c4 10             	add    $0x10,%esp
80107da6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107da9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107daf:	5b                   	pop    %ebx
80107db0:	5e                   	pop    %esi
80107db1:	5f                   	pop    %edi
80107db2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107db3:	e9 88 d9 ff ff       	jmp    80105740 <memmove>
    panic("inituvm: more than a page");
80107db8:	83 ec 0c             	sub    $0xc,%esp
80107dbb:	68 81 8f 10 80       	push   $0x80108f81
80107dc0:	e8 bb 85 ff ff       	call   80100380 <panic>
80107dc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107dd0 <loaduvm>:
{
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
80107dd3:	57                   	push   %edi
80107dd4:	56                   	push   %esi
80107dd5:	53                   	push   %ebx
80107dd6:	83 ec 1c             	sub    $0x1c,%esp
80107dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ddc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107ddf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107de4:	0f 85 bb 00 00 00    	jne    80107ea5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107dea:	01 f0                	add    %esi,%eax
80107dec:	89 f3                	mov    %esi,%ebx
80107dee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107df1:	8b 45 14             	mov    0x14(%ebp),%eax
80107df4:	01 f0                	add    %esi,%eax
80107df6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107df9:	85 f6                	test   %esi,%esi
80107dfb:	0f 84 87 00 00 00    	je     80107e88 <loaduvm+0xb8>
80107e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107e0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107e0e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107e10:	89 c2                	mov    %eax,%edx
80107e12:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107e15:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107e18:	f6 c2 01             	test   $0x1,%dl
80107e1b:	75 13                	jne    80107e30 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107e1d:	83 ec 0c             	sub    $0xc,%esp
80107e20:	68 9b 8f 10 80       	push   $0x80108f9b
80107e25:	e8 56 85 ff ff       	call   80100380 <panic>
80107e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107e30:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e33:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107e39:	25 fc 0f 00 00       	and    $0xffc,%eax
80107e3e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107e45:	85 c0                	test   %eax,%eax
80107e47:	74 d4                	je     80107e1d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107e49:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107e4e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107e53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107e58:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107e5e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e61:	29 d9                	sub    %ebx,%ecx
80107e63:	05 00 00 00 80       	add    $0x80000000,%eax
80107e68:	57                   	push   %edi
80107e69:	51                   	push   %ecx
80107e6a:	50                   	push   %eax
80107e6b:	ff 75 10             	push   0x10(%ebp)
80107e6e:	e8 1d 9c ff ff       	call   80101a90 <readi>
80107e73:	83 c4 10             	add    $0x10,%esp
80107e76:	39 f8                	cmp    %edi,%eax
80107e78:	75 1e                	jne    80107e98 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107e7a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107e80:	89 f0                	mov    %esi,%eax
80107e82:	29 d8                	sub    %ebx,%eax
80107e84:	39 c6                	cmp    %eax,%esi
80107e86:	77 80                	ja     80107e08 <loaduvm+0x38>
}
80107e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107e8b:	31 c0                	xor    %eax,%eax
}
80107e8d:	5b                   	pop    %ebx
80107e8e:	5e                   	pop    %esi
80107e8f:	5f                   	pop    %edi
80107e90:	5d                   	pop    %ebp
80107e91:	c3                   	ret    
80107e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ea0:	5b                   	pop    %ebx
80107ea1:	5e                   	pop    %esi
80107ea2:	5f                   	pop    %edi
80107ea3:	5d                   	pop    %ebp
80107ea4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107ea5:	83 ec 0c             	sub    $0xc,%esp
80107ea8:	68 3c 90 10 80       	push   $0x8010903c
80107ead:	e8 ce 84 ff ff       	call   80100380 <panic>
80107eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ec0 <allocuvm>:
{
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	57                   	push   %edi
80107ec4:	56                   	push   %esi
80107ec5:	53                   	push   %ebx
80107ec6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107ec9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107ecc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107ecf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ed2:	85 c0                	test   %eax,%eax
80107ed4:	0f 88 b6 00 00 00    	js     80107f90 <allocuvm+0xd0>
  if(newsz < oldsz)
80107eda:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107ee0:	0f 82 9a 00 00 00    	jb     80107f80 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107ee6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107eec:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107ef2:	39 75 10             	cmp    %esi,0x10(%ebp)
80107ef5:	77 44                	ja     80107f3b <allocuvm+0x7b>
80107ef7:	e9 87 00 00 00       	jmp    80107f83 <allocuvm+0xc3>
80107efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107f00:	83 ec 04             	sub    $0x4,%esp
80107f03:	68 00 10 00 00       	push   $0x1000
80107f08:	6a 00                	push   $0x0
80107f0a:	50                   	push   %eax
80107f0b:	e8 90 d7 ff ff       	call   801056a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107f10:	58                   	pop    %eax
80107f11:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f17:	5a                   	pop    %edx
80107f18:	6a 06                	push   $0x6
80107f1a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f1f:	89 f2                	mov    %esi,%edx
80107f21:	50                   	push   %eax
80107f22:	89 f8                	mov    %edi,%eax
80107f24:	e8 87 fb ff ff       	call   80107ab0 <mappages>
80107f29:	83 c4 10             	add    $0x10,%esp
80107f2c:	85 c0                	test   %eax,%eax
80107f2e:	78 78                	js     80107fa8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107f30:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107f36:	39 75 10             	cmp    %esi,0x10(%ebp)
80107f39:	76 48                	jbe    80107f83 <allocuvm+0xc3>
    mem = kalloc();
80107f3b:	e8 40 a7 ff ff       	call   80102680 <kalloc>
80107f40:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107f42:	85 c0                	test   %eax,%eax
80107f44:	75 ba                	jne    80107f00 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107f46:	83 ec 0c             	sub    $0xc,%esp
80107f49:	68 b9 8f 10 80       	push   $0x80108fb9
80107f4e:	e8 4d 87 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f56:	83 c4 10             	add    $0x10,%esp
80107f59:	39 45 10             	cmp    %eax,0x10(%ebp)
80107f5c:	74 32                	je     80107f90 <allocuvm+0xd0>
80107f5e:	8b 55 10             	mov    0x10(%ebp),%edx
80107f61:	89 c1                	mov    %eax,%ecx
80107f63:	89 f8                	mov    %edi,%eax
80107f65:	e8 96 fa ff ff       	call   80107a00 <deallocuvm.part.0>
      return 0;
80107f6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f77:	5b                   	pop    %ebx
80107f78:	5e                   	pop    %esi
80107f79:	5f                   	pop    %edi
80107f7a:	5d                   	pop    %ebp
80107f7b:	c3                   	ret    
80107f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107f80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107f83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f89:	5b                   	pop    %ebx
80107f8a:	5e                   	pop    %esi
80107f8b:	5f                   	pop    %edi
80107f8c:	5d                   	pop    %ebp
80107f8d:	c3                   	ret    
80107f8e:	66 90                	xchg   %ax,%ax
    return 0;
80107f90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f9d:	5b                   	pop    %ebx
80107f9e:	5e                   	pop    %esi
80107f9f:	5f                   	pop    %edi
80107fa0:	5d                   	pop    %ebp
80107fa1:	c3                   	ret    
80107fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107fa8:	83 ec 0c             	sub    $0xc,%esp
80107fab:	68 d1 8f 10 80       	push   $0x80108fd1
80107fb0:	e8 eb 86 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fb8:	83 c4 10             	add    $0x10,%esp
80107fbb:	39 45 10             	cmp    %eax,0x10(%ebp)
80107fbe:	74 0c                	je     80107fcc <allocuvm+0x10c>
80107fc0:	8b 55 10             	mov    0x10(%ebp),%edx
80107fc3:	89 c1                	mov    %eax,%ecx
80107fc5:	89 f8                	mov    %edi,%eax
80107fc7:	e8 34 fa ff ff       	call   80107a00 <deallocuvm.part.0>
      kfree(mem);
80107fcc:	83 ec 0c             	sub    $0xc,%esp
80107fcf:	53                   	push   %ebx
80107fd0:	e8 eb a4 ff ff       	call   801024c0 <kfree>
      return 0;
80107fd5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107fdc:	83 c4 10             	add    $0x10,%esp
}
80107fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fe2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fe5:	5b                   	pop    %ebx
80107fe6:	5e                   	pop    %esi
80107fe7:	5f                   	pop    %edi
80107fe8:	5d                   	pop    %ebp
80107fe9:	c3                   	ret    
80107fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ff0 <deallocuvm>:
{
80107ff0:	55                   	push   %ebp
80107ff1:	89 e5                	mov    %esp,%ebp
80107ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ff6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107ffc:	39 d1                	cmp    %edx,%ecx
80107ffe:	73 10                	jae    80108010 <deallocuvm+0x20>
}
80108000:	5d                   	pop    %ebp
80108001:	e9 fa f9 ff ff       	jmp    80107a00 <deallocuvm.part.0>
80108006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010800d:	8d 76 00             	lea    0x0(%esi),%esi
80108010:	89 d0                	mov    %edx,%eax
80108012:	5d                   	pop    %ebp
80108013:	c3                   	ret    
80108014:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010801b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010801f:	90                   	nop

80108020 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108020:	55                   	push   %ebp
80108021:	89 e5                	mov    %esp,%ebp
80108023:	57                   	push   %edi
80108024:	56                   	push   %esi
80108025:	53                   	push   %ebx
80108026:	83 ec 0c             	sub    $0xc,%esp
80108029:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010802c:	85 f6                	test   %esi,%esi
8010802e:	74 59                	je     80108089 <freevm+0x69>
  if(newsz >= oldsz)
80108030:	31 c9                	xor    %ecx,%ecx
80108032:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108037:	89 f0                	mov    %esi,%eax
80108039:	89 f3                	mov    %esi,%ebx
8010803b:	e8 c0 f9 ff ff       	call   80107a00 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108040:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108046:	eb 0f                	jmp    80108057 <freevm+0x37>
80108048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010804f:	90                   	nop
80108050:	83 c3 04             	add    $0x4,%ebx
80108053:	39 df                	cmp    %ebx,%edi
80108055:	74 23                	je     8010807a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108057:	8b 03                	mov    (%ebx),%eax
80108059:	a8 01                	test   $0x1,%al
8010805b:	74 f3                	je     80108050 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010805d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108062:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108065:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108068:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010806d:	50                   	push   %eax
8010806e:	e8 4d a4 ff ff       	call   801024c0 <kfree>
80108073:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108076:	39 df                	cmp    %ebx,%edi
80108078:	75 dd                	jne    80108057 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010807a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010807d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108080:	5b                   	pop    %ebx
80108081:	5e                   	pop    %esi
80108082:	5f                   	pop    %edi
80108083:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108084:	e9 37 a4 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80108089:	83 ec 0c             	sub    $0xc,%esp
8010808c:	68 ed 8f 10 80       	push   $0x80108fed
80108091:	e8 ea 82 ff ff       	call   80100380 <panic>
80108096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010809d:	8d 76 00             	lea    0x0(%esi),%esi

801080a0 <setupkvm>:
{
801080a0:	55                   	push   %ebp
801080a1:	89 e5                	mov    %esp,%ebp
801080a3:	56                   	push   %esi
801080a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801080a5:	e8 d6 a5 ff ff       	call   80102680 <kalloc>
801080aa:	89 c6                	mov    %eax,%esi
801080ac:	85 c0                	test   %eax,%eax
801080ae:	74 42                	je     801080f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801080b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801080b3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
801080b8:	68 00 10 00 00       	push   $0x1000
801080bd:	6a 00                	push   $0x0
801080bf:	50                   	push   %eax
801080c0:	e8 db d5 ff ff       	call   801056a0 <memset>
801080c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801080c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801080cb:	83 ec 08             	sub    $0x8,%esp
801080ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801080d1:	ff 73 0c             	push   0xc(%ebx)
801080d4:	8b 13                	mov    (%ebx),%edx
801080d6:	50                   	push   %eax
801080d7:	29 c1                	sub    %eax,%ecx
801080d9:	89 f0                	mov    %esi,%eax
801080db:	e8 d0 f9 ff ff       	call   80107ab0 <mappages>
801080e0:	83 c4 10             	add    $0x10,%esp
801080e3:	85 c0                	test   %eax,%eax
801080e5:	78 19                	js     80108100 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801080e7:	83 c3 10             	add    $0x10,%ebx
801080ea:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801080f0:	75 d6                	jne    801080c8 <setupkvm+0x28>
}
801080f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080f5:	89 f0                	mov    %esi,%eax
801080f7:	5b                   	pop    %ebx
801080f8:	5e                   	pop    %esi
801080f9:	5d                   	pop    %ebp
801080fa:	c3                   	ret    
801080fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801080ff:	90                   	nop
      freevm(pgdir);
80108100:	83 ec 0c             	sub    $0xc,%esp
80108103:	56                   	push   %esi
      return 0;
80108104:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108106:	e8 15 ff ff ff       	call   80108020 <freevm>
      return 0;
8010810b:	83 c4 10             	add    $0x10,%esp
}
8010810e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108111:	89 f0                	mov    %esi,%eax
80108113:	5b                   	pop    %ebx
80108114:	5e                   	pop    %esi
80108115:	5d                   	pop    %ebp
80108116:	c3                   	ret    
80108117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010811e:	66 90                	xchg   %ax,%ax

80108120 <kvmalloc>:
{
80108120:	55                   	push   %ebp
80108121:	89 e5                	mov    %esp,%ebp
80108123:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108126:	e8 75 ff ff ff       	call   801080a0 <setupkvm>
8010812b:	a3 84 8e 11 80       	mov    %eax,0x80118e84
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108130:	05 00 00 00 80       	add    $0x80000000,%eax
80108135:	0f 22 d8             	mov    %eax,%cr3
}
80108138:	c9                   	leave  
80108139:	c3                   	ret    
8010813a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108140 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108140:	55                   	push   %ebp
80108141:	89 e5                	mov    %esp,%ebp
80108143:	83 ec 08             	sub    $0x8,%esp
80108146:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108149:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010814c:	89 c1                	mov    %eax,%ecx
8010814e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108151:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108154:	f6 c2 01             	test   $0x1,%dl
80108157:	75 17                	jne    80108170 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108159:	83 ec 0c             	sub    $0xc,%esp
8010815c:	68 fe 8f 10 80       	push   $0x80108ffe
80108161:	e8 1a 82 ff ff       	call   80100380 <panic>
80108166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010816d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108170:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108173:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108179:	25 fc 0f 00 00       	and    $0xffc,%eax
8010817e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108185:	85 c0                	test   %eax,%eax
80108187:	74 d0                	je     80108159 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108189:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010818c:	c9                   	leave  
8010818d:	c3                   	ret    
8010818e:	66 90                	xchg   %ax,%ax

80108190 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108190:	55                   	push   %ebp
80108191:	89 e5                	mov    %esp,%ebp
80108193:	57                   	push   %edi
80108194:	56                   	push   %esi
80108195:	53                   	push   %ebx
80108196:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108199:	e8 02 ff ff ff       	call   801080a0 <setupkvm>
8010819e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801081a1:	85 c0                	test   %eax,%eax
801081a3:	0f 84 bd 00 00 00    	je     80108266 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801081a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801081ac:	85 c9                	test   %ecx,%ecx
801081ae:	0f 84 b2 00 00 00    	je     80108266 <copyuvm+0xd6>
801081b4:	31 f6                	xor    %esi,%esi
801081b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801081c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801081c3:	89 f0                	mov    %esi,%eax
801081c5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801081c8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801081cb:	a8 01                	test   $0x1,%al
801081cd:	75 11                	jne    801081e0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801081cf:	83 ec 0c             	sub    $0xc,%esp
801081d2:	68 08 90 10 80       	push   $0x80109008
801081d7:	e8 a4 81 ff ff       	call   80100380 <panic>
801081dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801081e0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801081e7:	c1 ea 0a             	shr    $0xa,%edx
801081ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801081f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801081f7:	85 c0                	test   %eax,%eax
801081f9:	74 d4                	je     801081cf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801081fb:	8b 00                	mov    (%eax),%eax
801081fd:	a8 01                	test   $0x1,%al
801081ff:	0f 84 9f 00 00 00    	je     801082a4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108205:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108207:	25 ff 0f 00 00       	and    $0xfff,%eax
8010820c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010820f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108215:	e8 66 a4 ff ff       	call   80102680 <kalloc>
8010821a:	89 c3                	mov    %eax,%ebx
8010821c:	85 c0                	test   %eax,%eax
8010821e:	74 64                	je     80108284 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108220:	83 ec 04             	sub    $0x4,%esp
80108223:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108229:	68 00 10 00 00       	push   $0x1000
8010822e:	57                   	push   %edi
8010822f:	50                   	push   %eax
80108230:	e8 0b d5 ff ff       	call   80105740 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108235:	58                   	pop    %eax
80108236:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010823c:	5a                   	pop    %edx
8010823d:	ff 75 e4             	push   -0x1c(%ebp)
80108240:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108245:	89 f2                	mov    %esi,%edx
80108247:	50                   	push   %eax
80108248:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010824b:	e8 60 f8 ff ff       	call   80107ab0 <mappages>
80108250:	83 c4 10             	add    $0x10,%esp
80108253:	85 c0                	test   %eax,%eax
80108255:	78 21                	js     80108278 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108257:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010825d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108260:	0f 87 5a ff ff ff    	ja     801081c0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108266:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108269:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010826c:	5b                   	pop    %ebx
8010826d:	5e                   	pop    %esi
8010826e:	5f                   	pop    %edi
8010826f:	5d                   	pop    %ebp
80108270:	c3                   	ret    
80108271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108278:	83 ec 0c             	sub    $0xc,%esp
8010827b:	53                   	push   %ebx
8010827c:	e8 3f a2 ff ff       	call   801024c0 <kfree>
      goto bad;
80108281:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108284:	83 ec 0c             	sub    $0xc,%esp
80108287:	ff 75 e0             	push   -0x20(%ebp)
8010828a:	e8 91 fd ff ff       	call   80108020 <freevm>
  return 0;
8010828f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108296:	83 c4 10             	add    $0x10,%esp
}
80108299:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010829c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010829f:	5b                   	pop    %ebx
801082a0:	5e                   	pop    %esi
801082a1:	5f                   	pop    %edi
801082a2:	5d                   	pop    %ebp
801082a3:	c3                   	ret    
      panic("copyuvm: page not present");
801082a4:	83 ec 0c             	sub    $0xc,%esp
801082a7:	68 22 90 10 80       	push   $0x80109022
801082ac:	e8 cf 80 ff ff       	call   80100380 <panic>
801082b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082bf:	90                   	nop

801082c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801082c0:	55                   	push   %ebp
801082c1:	89 e5                	mov    %esp,%ebp
801082c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801082c6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801082c9:	89 c1                	mov    %eax,%ecx
801082cb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801082ce:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801082d1:	f6 c2 01             	test   $0x1,%dl
801082d4:	0f 84 00 01 00 00    	je     801083da <uva2ka.cold>
  return &pgtab[PTX(va)];
801082da:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801082dd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801082e3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801082e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801082e9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801082f0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801082f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801082f7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801082fa:	05 00 00 00 80       	add    $0x80000000,%eax
801082ff:	83 fa 05             	cmp    $0x5,%edx
80108302:	ba 00 00 00 00       	mov    $0x0,%edx
80108307:	0f 45 c2             	cmovne %edx,%eax
}
8010830a:	c3                   	ret    
8010830b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010830f:	90                   	nop

80108310 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108310:	55                   	push   %ebp
80108311:	89 e5                	mov    %esp,%ebp
80108313:	57                   	push   %edi
80108314:	56                   	push   %esi
80108315:	53                   	push   %ebx
80108316:	83 ec 0c             	sub    $0xc,%esp
80108319:	8b 75 14             	mov    0x14(%ebp),%esi
8010831c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010831f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108322:	85 f6                	test   %esi,%esi
80108324:	75 51                	jne    80108377 <copyout+0x67>
80108326:	e9 a5 00 00 00       	jmp    801083d0 <copyout+0xc0>
8010832b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010832f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108330:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108336:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010833c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108342:	74 75                	je     801083b9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108344:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108346:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108349:	29 c3                	sub    %eax,%ebx
8010834b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108351:	39 f3                	cmp    %esi,%ebx
80108353:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108356:	29 f8                	sub    %edi,%eax
80108358:	83 ec 04             	sub    $0x4,%esp
8010835b:	01 c1                	add    %eax,%ecx
8010835d:	53                   	push   %ebx
8010835e:	52                   	push   %edx
8010835f:	51                   	push   %ecx
80108360:	e8 db d3 ff ff       	call   80105740 <memmove>
    len -= n;
    buf += n;
80108365:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108368:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010836e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108371:	01 da                	add    %ebx,%edx
  while(len > 0){
80108373:	29 de                	sub    %ebx,%esi
80108375:	74 59                	je     801083d0 <copyout+0xc0>
  if(*pde & PTE_P){
80108377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010837a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010837c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010837e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108381:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108387:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010838a:	f6 c1 01             	test   $0x1,%cl
8010838d:	0f 84 4e 00 00 00    	je     801083e1 <copyout.cold>
  return &pgtab[PTX(va)];
80108393:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108395:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010839b:	c1 eb 0c             	shr    $0xc,%ebx
8010839e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801083a4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801083ab:	89 d9                	mov    %ebx,%ecx
801083ad:	83 e1 05             	and    $0x5,%ecx
801083b0:	83 f9 05             	cmp    $0x5,%ecx
801083b3:	0f 84 77 ff ff ff    	je     80108330 <copyout+0x20>
  }
  return 0;
}
801083b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801083bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801083c1:	5b                   	pop    %ebx
801083c2:	5e                   	pop    %esi
801083c3:	5f                   	pop    %edi
801083c4:	5d                   	pop    %ebp
801083c5:	c3                   	ret    
801083c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083cd:	8d 76 00             	lea    0x0(%esi),%esi
801083d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801083d3:	31 c0                	xor    %eax,%eax
}
801083d5:	5b                   	pop    %ebx
801083d6:	5e                   	pop    %esi
801083d7:	5f                   	pop    %edi
801083d8:	5d                   	pop    %ebp
801083d9:	c3                   	ret    

801083da <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801083da:	a1 00 00 00 00       	mov    0x0,%eax
801083df:	0f 0b                	ud2    

801083e1 <copyout.cold>:
801083e1:	a1 00 00 00 00       	mov    0x0,%eax
801083e6:	0f 0b                	ud2    

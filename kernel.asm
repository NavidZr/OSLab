
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 c0 7d 10 80       	push   $0x80107dc0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 c1 4e 00 00       	call   80104f20 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 7d 10 80       	push   $0x80107dc7
80100097:	50                   	push   %eax
80100098:	e8 43 4d 00 00       	call   80104de0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
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
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 b3 4f 00 00       	call   801050a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 f9 4f 00 00       	call   80105160 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 4c 00 00       	call   80104e20 <acquiresleep>
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
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 7d 10 80       	push   $0x80107dce
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 f9 4c 00 00       	call   80104ec0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 7d 10 80       	push   $0x80107ddf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 b8 4c 00 00       	call   80104ec0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 68 4c 00 00       	call   80104e80 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 7c 4e 00 00       	call   801050a0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 eb 4e 00 00       	jmp    80105160 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 7d 10 80       	push   $0x80107de6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 ea 4d 00 00       	call   801050a0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 36 44 00 00       	call   80104720 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 41 37 00 00       	call   80103a40 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 4d 4e 00 00       	call   80105160 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 f6 4d 00 00       	call   80105160 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 7d 10 80       	push   $0x80107ded
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 22 84 10 80 	movl   $0x80108422,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 5f 4b 00 00       	call   80104f40 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 7e 10 80       	push   $0x80107e01
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 91 65 00 00       	call   801069c0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 a6 64 00 00       	call   801069c0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 9a 64 00 00       	call   801069c0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 8e 64 00 00       	call   801069c0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ea 4c 00 00       	call   80105250 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 35 4c 00 00       	call   801051b0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 7e 10 80       	push   $0x80107e05
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 30 7e 10 80 	movzbl -0x7fef81d0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 3c 4a 00 00       	call   801050a0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 c4 4a 00 00       	call   80105160 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 18 7e 10 80       	mov    $0x80107e18,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 de 48 00 00       	call   801050a0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 33 49 00 00       	call   80105160 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 7e 10 80       	push   $0x80107e1f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 24 48 00 00       	call   801050a0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 8c 47 00 00       	call   80105160 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 dc 3f 00 00       	jmp    801049e0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 bb 3e 00 00       	call   801048e0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 28 7e 10 80       	push   $0x80107e28
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 d7 44 00 00       	call   80104f20 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 ab 2f 00 00       	call   80103a40 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 90 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 b8 22 00 00       	call   80102da0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 1f 70 00 00       	call   80107b30 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 d8 6d 00 00       	call   80107950 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 d2 6c 00 00       	call   80107880 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 c0 6e 00 00       	call   80107ab0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 7a 21 00 00       	call   80102da0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 19 6d 00 00       	call   80107950 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 78 6f 00 00       	call   80107bd0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 08 47 00 00       	call   801053b0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 f5 46 00 00       	call   801053b0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 70 00 00       	call   80107d30 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ca 6d 00 00       	call   80107ab0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 f8 6f 00 00       	call   80107d30 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 fa 45 00 00       	call   80105370 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 4e 69 00 00       	call   801076f0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 06 6d 00 00       	call   80107ab0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 41 7e 10 80       	push   $0x80107e41
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 4d 7e 10 80       	push   $0x80107e4d
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 27 41 00 00       	call   80104f20 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 0f 11 80       	push   $0x80110fc0
80100e15:	e8 86 42 00 00       	call   801050a0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 1a 43 00 00       	call   80105160 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 01 43 00 00       	call   80105160 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e83:	e8 18 42 00 00       	call   801050a0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea0:	e8 bb 42 00 00       	call   80105160 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 54 7e 10 80       	push   $0x80107e54
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed5:	e8 c6 41 00 00       	call   801050a0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 4b 42 00 00       	call   80105160 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 1d 42 00 00       	jmp    80105160 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 82 25 00 00       	call   80103500 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 5c 7e 10 80       	push   $0x80107e5c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 36 26 00 00       	jmp    801036a0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 66 7e 10 80       	push   $0x80107e66
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 aa 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 11 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 4a 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 6f 7e 10 80       	push   $0x80107e6f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 0a 24 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 75 7e 10 80       	push   $0x80107e75
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 0e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 7f 7e 10 80       	push   $0x80107e7f
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 92 7e 10 80       	push   $0x80107e92
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 1e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 96 3e 00 00       	call   801051b0 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 ee 1b 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 19 11 80       	push   $0x801119e0
8010135a:	e8 41 3d 00 00       	call   801050a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 19 11 80       	push   $0x801119e0
801013c7:	e8 94 3d 00 00       	call   80105160 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 66 3d 00 00       	call   80105160 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 a8 7e 10 80       	push   $0x80107ea8
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 66 1a 00 00       	call   80102f10 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 b8 7e 10 80       	push   $0x80107eb8
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 26 3d 00 00       	call   80105250 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 cb 7e 10 80       	push   $0x80107ecb
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 c1 39 00 00       	call   80104f20 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 d2 7e 10 80       	push   $0x80107ed2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 64 38 00 00       	call   80104de0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 19 11 80       	push   $0x801119c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 19 11 80    	pushl  0x801119d8
8010159d:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015a3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015a9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015af:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015b5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015bb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015c1:	68 38 7f 10 80       	push   $0x80107f38
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 4d 3b 00 00       	call   801051b0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 d8 7e 10 80       	push   $0x80107ed8
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 46 3b 00 00       	call   80105250 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 fe 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 19 11 80       	push   $0x801119e0
80101743:	e8 58 39 00 00       	call   801050a0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 08 3a 00 00       	call   80105160 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 95 36 00 00       	call   80104e20 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 53 3a 00 00       	call   80105250 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 f0 7e 10 80       	push   $0x80107ef0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ea 7e 10 80       	push   $0x80107eea
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 64 36 00 00       	call   80104ec0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 08 36 00 00       	jmp    80104e80 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 ff 7e 10 80       	push   $0x80107eff
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 77 35 00 00       	call   80104e20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 bd 35 00 00       	call   80104e80 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 d1 37 00 00       	call   801050a0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 77 38 00 00       	jmp    80105160 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 a3 37 00 00       	call   801050a0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 54 38 00 00       	call   80105160 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 44 37 00 00       	call   80105250 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 48 36 00 00       	call   80105250 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 19 36 00 00       	call   801052c0 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 b6 35 00 00       	call   801052c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 19 7f 10 80       	push   $0x80107f19
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 07 7f 10 80       	push   $0x80107f07
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 b1 1c 00 00       	call   80103a40 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 ff 32 00 00       	call   801050a0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 af 33 00 00       	call   80105160 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 34 34 00 00       	call   80105250 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 a8 33 00 00       	call   80105250 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 36 33 00 00       	call   80105310 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 28 7f 10 80       	push   $0x80107f28
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 7e 86 10 80       	push   $0x8010867e
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 94 7f 10 80       	push   $0x80107f94
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 8b 7f 10 80       	push   $0x80107f8b
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 a6 7f 10 80       	push   $0x80107fa6
8010215f:	68 80 b5 10 80       	push   $0x8010b580
80102164:	e8 b7 2d 00 00       	call   80104f20 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 b5 10 80       	push   $0x8010b580
801021f2:	e8 a9 2e 00 00       	call   801050a0 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 8e 26 00 00       	call   801048e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 b5 10 80       	push   $0x8010b580
8010226b:	e8 f0 2e 00 00       	call   80105160 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 29 2c 00 00       	call   80104ec0 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 b5 10 80       	push   $0x8010b580
801022cc:	e8 cf 2d 00 00       	call   801050a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 b5 10 80       	push   $0x8010b580
80102318:	53                   	push   %ebx
80102319:	e8 02 24 00 00       	call   80104720 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 25 2e 00 00       	jmp    80105160 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 d5 7f 10 80       	push   $0x80107fd5
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 c0 7f 10 80       	push   $0x80107fc0
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 aa 7f 10 80       	push   $0x80107faa
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 f4 7f 10 80       	push   $0x80107ff4
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb a8 86 11 80    	cmp    $0x801186a8,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 05 2d 00 00       	call   801051b0 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 78 36 11 80       	mov    0x80113678,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024c4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 40 36 11 80       	push   $0x80113640
801024e0:	e8 bb 2b 00 00       	call   801050a0 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 60 2c 00 00       	jmp    80105160 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 26 80 10 80       	push   $0x80108026
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 2c 80 10 80       	push   $0x8010802c
80102574:	68 40 36 11 80       	push   $0x80113640
80102579:	e8 a2 29 00 00       	call   80104f20 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 74 36 11 80       	mov    0x80113674,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 40 36 11 80       	push   $0x80113640
80102663:	e8 38 2a 00 00       	call   801050a0 <acquire>
  r = kmem.freelist;
80102668:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010266d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 40 36 11 80       	push   $0x80113640
80102691:	e8 ca 2a 00 00       	call   80105160 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	ba 64 00 00 00       	mov    $0x64,%edx
801026a9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026aa:	a8 01                	test   $0x1,%al
801026ac:	0f 84 be 00 00 00    	je     80102770 <kbdgetc+0xd0>
{
801026b2:	55                   	push   %ebp
801026b3:	ba 60 00 00 00       	mov    $0x60,%edx
801026b8:	89 e5                	mov    %esp,%ebp
801026ba:	53                   	push   %ebx
801026bb:	ec                   	in     (%dx),%al
  return data;
801026bc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026c2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026c5:	3c e0                	cmp    $0xe0,%al
801026c7:	74 57                	je     80102720 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c9:	89 d9                	mov    %ebx,%ecx
801026cb:	83 e1 40             	and    $0x40,%ecx
801026ce:	84 c0                	test   %al,%al
801026d0:	78 5e                	js     80102730 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026d2:	85 c9                	test   %ecx,%ecx
801026d4:	74 09                	je     801026df <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026d6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026d9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026dc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026df:	0f b6 8a 60 81 10 80 	movzbl -0x7fef7ea0(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 60 80 10 80 	movzbl -0x7fef7fa0(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 40 80 10 80 	mov    -0x7fef7fc0(,%eax,4),%eax
80102706:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010270a:	74 0b                	je     80102717 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010270c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010270f:	83 fa 19             	cmp    $0x19,%edx
80102712:	77 44                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102714:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102717:	5b                   	pop    %ebx
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102720:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102723:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102725:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 c9                	test   %ecx,%ecx
80102735:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102738:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010273a:	0f b6 8a 60 81 10 80 	movzbl -0x7fef7ea0(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010275e:	5b                   	pop    %ebx
8010275f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102760:	83 f9 1a             	cmp    $0x1a,%ecx
80102763:	0f 42 c2             	cmovb  %edx,%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
    return -1;
80102770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <kbdintr>:

void
kbdintr(void)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010278a:	68 a0 26 10 80       	push   $0x801026a0
8010278f:	e8 cc e0 ff ff       	call   80100860 <consoleintr>
}
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	c9                   	leave  
80102798:	c3                   	ret    
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027a4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 c7 00 00 00    	je     80102878 <lapicinit+0xd8>
  lapic[index] = value;
801027b1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027b8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027be:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027c5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027d2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027df:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027e2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ec:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027f9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ff:	8b 50 30             	mov    0x30(%eax),%edx
80102802:	c1 ea 10             	shr    $0x10,%edx
80102805:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010280b:	75 73                	jne    80102880 <lapicinit+0xe0>
  lapic[index] = value;
8010280d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010283b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102848:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102855:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102860:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102866:	80 e6 10             	and    $0x10,%dh
80102869:	75 f5                	jne    80102860 <lapicinit+0xc0>
  lapic[index] = value;
8010286b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102872:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102880:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102887:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010288d:	e9 7b ff ff ff       	jmp    8010280d <lapicinit+0x6d>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <lapicid>:

int
lapicid(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028a4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	74 0b                	je     801028b8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
801028b0:	c1 e8 18             	shr    $0x18,%eax
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
}
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028c4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0d                	je     801028da <lapiceoi+0x1a>
  lapic[index] = value;
801028cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028e0:	f3 0f 1e fb          	endbr32 
}
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028fa:	ba 70 00 00 00       	mov    $0x70,%edx
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	53                   	push   %ebx
80102902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102905:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102908:	ee                   	out    %al,(%dx)
80102909:	b8 0a 00 00 00       	mov    $0xa,%eax
8010290e:	ba 71 00 00 00       	mov    $0x71,%edx
80102913:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102914:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102916:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102919:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010291f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102921:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102924:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102926:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102929:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010292c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102932:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102937:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102940:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102947:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102954:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102963:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102972:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102975:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010297b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010297f:	5d                   	pop    %ebp
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	b8 0b 00 00 00       	mov    $0xb,%eax
8010299a:	ba 70 00 00 00       	mov    $0x70,%edx
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	83 ec 4c             	sub    $0x4c,%esp
801029a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ad:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ae:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c0:	31 c0                	xor    %eax,%eax
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d0:	89 da                	mov    %ebx,%edx
801029d2:	b8 02 00 00 00       	mov    $0x2,%eax
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	89 ca                	mov    %ecx,%edx
801029da:	ec                   	in     (%dx),%al
801029db:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029de:	89 da                	mov    %ebx,%edx
801029e0:	b8 04 00 00 00       	mov    $0x4,%eax
801029e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e6:	89 ca                	mov    %ecx,%edx
801029e8:	ec                   	in     (%dx),%al
801029e9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 07 00 00 00       	mov    $0x7,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
801029f7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	b8 08 00 00 00       	mov    $0x8,%eax
80102a01:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a07:	89 da                	mov    %ebx,%edx
80102a09:	b8 09 00 00 00       	mov    $0x9,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a1f:	84 c0                	test   %al,%al
80102a21:	78 9d                	js     801029c0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a23:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a27:	89 fa                	mov    %edi,%edx
80102a29:	0f b6 fa             	movzbl %dl,%edi
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a31:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a40:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a44:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a4a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a4e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a51:	31 c0                	xor    %eax,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a5f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al
80102a68:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6b:	89 da                	mov    %ebx,%edx
80102a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a81:	b8 07 00 00 00       	mov    $0x7,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	89 da                	mov    %ebx,%edx
80102a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a92:	b8 08 00 00 00       	mov    $0x8,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 da                	mov    %ebx,%edx
80102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aa3:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aaf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab8:	6a 18                	push   $0x18
80102aba:	50                   	push   %eax
80102abb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102abe:	50                   	push   %eax
80102abf:	e8 3c 27 00 00       	call   80105200 <memcmp>
80102ac4:	83 c4 10             	add    $0x10,%esp
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	0f 85 f1 fe ff ff    	jne    801029c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102acf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ad3:	75 78                	jne    80102b4d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b4d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b50:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b53:	89 06                	mov    %eax,(%esi)
80102b55:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b58:	89 46 04             	mov    %eax,0x4(%esi)
80102b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b5e:	89 46 08             	mov    %eax,0x8(%esi)
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 46 0c             	mov    %eax,0xc(%esi)
80102b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b6a:	89 46 10             	mov    %eax,0x10(%esi)
80102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b70:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b73:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7d:	5b                   	pop    %ebx
80102b7e:	5e                   	pop    %esi
80102b7f:	5f                   	pop    %edi
80102b80:	5d                   	pop    %ebp
80102b81:	c3                   	ret    
80102b82:	66 90                	xchg   %ax,%ax
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102bd4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 57 26 00 00       	call   80105250 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c3d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	53                   	push   %ebx
80102c98:	83 ec 2c             	sub    $0x2c,%esp
80102c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9e:	68 60 82 10 80       	push   $0x80108260
80102ca3:	68 80 36 11 80       	push   $0x80113680
80102ca8:	e8 73 22 00 00       	call   80104f20 <initlock>
  readsb(dev, &sb);
80102cad:	58                   	pop    %eax
80102cae:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb1:	5a                   	pop    %edx
80102cb2:	50                   	push   %eax
80102cb3:	53                   	push   %ebx
80102cb4:	e8 47 e8 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cbc:	59                   	pop    %ecx
  log.dev = dev;
80102cbd:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102ccb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d1                	cmp    %edx,%ecx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d3a:	68 80 36 11 80       	push   $0x80113680
80102d3f:	e8 5c 23 00 00       	call   801050a0 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 80 36 11 80       	push   $0x80113680
80102d58:	68 80 36 11 80       	push   $0x80113680
80102d5d:	e8 be 19 00 00       	call   80104720 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d73:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d7f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d82:	83 fa 1e             	cmp    $0x1e,%edx
80102d85:	7f c9                	jg     80102d50 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d8a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102d8f:	68 80 36 11 80       	push   $0x80113680
80102d94:	e8 c7 23 00 00       	call   80105160 <release>
      break;
    }
  }
}
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	57                   	push   %edi
80102da8:	56                   	push   %esi
80102da9:	53                   	push   %ebx
80102daa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dad:	68 80 36 11 80       	push   $0x80113680
80102db2:	e8 e9 22 00 00       	call   801050a0 <acquire>
  log.outstanding -= 1;
80102db7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102dbc:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 80 36 11 80       	push   $0x80113680
80102df0:	e8 6b 23 00 00       	call   80105160 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 80 36 11 80       	push   $0x80113680
80102e0a:	e8 91 22 00 00       	call   801050a0 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e16:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 bb 1a 00 00       	call   801048e0 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e2c:	e8 2f 23 00 00       	call   80105160 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e64:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 c7 23 00 00       	call   80105250 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 80 36 11 80       	push   $0x80113680
80102ed8:	e8 03 1a 00 00       	call   801048e0 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ee4:	e8 77 22 00 00       	call   80105160 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 64 82 10 80       	push   $0x80108264
80102efc:	e8 8f d4 ff ff       	call   80100390 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f1b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 80 36 11 80       	push   $0x80113680
80102f52:	e8 49 21 00 00       	call   801050a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f5d:	83 c4 10             	add    $0x10,%esp
80102f60:	85 d2                	test   %edx,%edx
80102f62:	7e 4e                	jle    80102fb2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f67:	31 c0                	xor    %eax,%eax
80102f69:	eb 0c                	jmp    80102f77 <log_write+0x67>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 c6 21 00 00       	jmp    80105160 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 73 82 10 80       	push   $0x80108273
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 89 82 10 80       	push   $0x80108289
80102fd3:	e8 b8 d3 ff ff       	call   80100390 <panic>
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 34 0a 00 00       	call   80103a20 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 2d 0a 00 00       	call   80103a20 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 a4 82 10 80       	push   $0x801082a4
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 f9 35 00 00       	call   80106600 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 a4 09 00 00       	call   801039b0 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 b1 12 00 00       	call   801042d0 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 a1 46 00 00       	call   801076d0 <switchkvm>
  seginit();
8010302f:	e8 0c 46 00 00       	call   80107640 <seginit>
  lapicinit();
80103034:	e8 67 f7 ff ff       	call   801027a0 <lapicinit>
  mpmain();
80103039:	e8 a2 ff ff ff       	call   80102fe0 <mpmain>
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103048:	83 e4 f0             	and    $0xfffffff0,%esp
8010304b:	ff 71 fc             	pushl  -0x4(%ecx)
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	53                   	push   %ebx
80103052:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103053:	83 ec 08             	sub    $0x8,%esp
80103056:	68 00 00 40 80       	push   $0x80400000
8010305b:	68 a8 86 11 80       	push   $0x801186a8
80103060:	e8 fb f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103065:	e8 46 4b 00 00       	call   80107bb0 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 81 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 c7 45 00 00       	call   80107640 <seginit>
  picinit();       // disable pic
80103079:	e8 52 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 73 38 00 00       	call   80106900 <uartinit>
  pinit();         // process table
8010308d:	e8 fe 08 00 00       	call   80103990 <pinit>
  tvinit();        // trap vectors
80103092:	e8 e9 34 00 00       	call   80106580 <tvinit>
  binit();         // buffer cache
80103097:	e8 a4 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010309c:	e8 3f dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030a1:	e8 aa f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a6:	83 c4 0c             	add    $0xc,%esp
801030a9:	68 8a 00 00 00       	push   $0x8a
801030ae:	68 8c b4 10 80       	push   $0x8010b48c
801030b3:	68 00 70 00 80       	push   $0x80007000
801030b8:	e8 93 21 00 00       	call   80105250 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030bd:	83 c4 10             	add    $0x10,%esp
801030c0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030c7:	00 00 00 
801030ca:	05 80 37 11 80       	add    $0x80113780,%eax
801030cf:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801030d4:	76 7a                	jbe    80103150 <main+0x110>
801030d6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801030db:	eb 1c                	jmp    801030f9 <main+0xb9>
801030dd:	8d 76 00             	lea    0x0(%esi),%esi
801030e0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030e7:	00 00 00 
801030ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030f0:	05 80 37 11 80       	add    $0x80113780,%eax
801030f5:	39 c3                	cmp    %eax,%ebx
801030f7:	73 57                	jae    80103150 <main+0x110>
    if(c == mycpu())  // We've started already.
801030f9:	e8 b2 08 00 00       	call   801039b0 <mycpu>
801030fe:	39 c3                	cmp    %eax,%ebx
80103100:	74 de                	je     801030e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103102:	e8 29 f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103107:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010310a:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
80103111:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103114:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010311b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010311e:	05 00 10 00 00       	add    $0x1000,%eax
80103123:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103128:	0f b6 03             	movzbl (%ebx),%eax
8010312b:	68 00 70 00 00       	push   $0x7000
80103130:	50                   	push   %eax
80103131:	e8 ba f7 ff ff       	call   801028f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103136:	83 c4 10             	add    $0x10,%esp
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	74 f6                	je     80103140 <main+0x100>
8010314a:	eb 94                	jmp    801030e0 <main+0xa0>
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103150:	83 ec 08             	sub    $0x8,%esp
80103153:	68 00 00 00 8e       	push   $0x8e000000
80103158:	68 00 00 40 80       	push   $0x80400000
8010315d:	e8 6e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
80103162:	e8 09 09 00 00       	call   80103a70 <userinit>
  mpmain();        // finish this processor's setup
80103167:	e8 74 fe ff ff       	call   80102fe0 <mpmain>
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103175:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010317b:	53                   	push   %ebx
  e = addr+len;
8010317c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010317f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103182:	39 de                	cmp    %ebx,%esi
80103184:	72 10                	jb     80103196 <mpsearch1+0x26>
80103186:	eb 50                	jmp    801031d8 <mpsearch1+0x68>
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	89 fe                	mov    %edi,%esi
80103192:	39 fb                	cmp    %edi,%ebx
80103194:	76 42                	jbe    801031d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103196:	83 ec 04             	sub    $0x4,%esp
80103199:	8d 7e 10             	lea    0x10(%esi),%edi
8010319c:	6a 04                	push   $0x4
8010319e:	68 b8 82 10 80       	push   $0x801082b8
801031a3:	56                   	push   %esi
801031a4:	e8 57 20 00 00       	call   80105200 <memcmp>
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	85 c0                	test   %eax,%eax
801031ae:	75 e0                	jne    80103190 <mpsearch1+0x20>
801031b0:	89 f2                	mov    %esi,%edx
801031b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031b8:	0f b6 0a             	movzbl (%edx),%ecx
801031bb:	83 c2 01             	add    $0x1,%edx
801031be:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031c0:	39 fa                	cmp    %edi,%edx
801031c2:	75 f4                	jne    801031b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c4:	84 c0                	test   %al,%al
801031c6:	75 c8                	jne    80103190 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cb:	89 f0                	mov    %esi,%eax
801031cd:	5b                   	pop    %ebx
801031ce:	5e                   	pop    %esi
801031cf:	5f                   	pop    %edi
801031d0:	5d                   	pop    %ebp
801031d1:	c3                   	ret    
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031db:	31 f6                	xor    %esi,%esi
}
801031dd:	5b                   	pop    %ebx
801031de:	89 f0                	mov    %esi,%eax
801031e0:	5e                   	pop    %esi
801031e1:	5f                   	pop    %edi
801031e2:	5d                   	pop    %ebp
801031e3:	c3                   	ret    
801031e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop

801031f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	57                   	push   %edi
801031f8:	56                   	push   %esi
801031f9:	53                   	push   %ebx
801031fa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031fd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103204:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010320b:	c1 e0 08             	shl    $0x8,%eax
8010320e:	09 d0                	or     %edx,%eax
80103210:	c1 e0 04             	shl    $0x4,%eax
80103213:	75 1b                	jne    80103230 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103215:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010321c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103223:	c1 e0 08             	shl    $0x8,%eax
80103226:	09 d0                	or     %edx,%eax
80103228:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010322b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103230:	ba 00 04 00 00       	mov    $0x400,%edx
80103235:	e8 36 ff ff ff       	call   80103170 <mpsearch1>
8010323a:	89 c6                	mov    %eax,%esi
8010323c:	85 c0                	test   %eax,%eax
8010323e:	0f 84 4c 01 00 00    	je     80103390 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103244:	8b 5e 04             	mov    0x4(%esi),%ebx
80103247:	85 db                	test   %ebx,%ebx
80103249:	0f 84 61 01 00 00    	je     801033b0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103252:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103258:	6a 04                	push   $0x4
8010325a:	68 bd 82 10 80       	push   $0x801082bd
8010325f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103263:	e8 98 1f 00 00       	call   80105200 <memcmp>
80103268:	83 c4 10             	add    $0x10,%esp
8010326b:	85 c0                	test   %eax,%eax
8010326d:	0f 85 3d 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103273:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010327a:	3c 01                	cmp    $0x1,%al
8010327c:	74 08                	je     80103286 <mpinit+0x96>
8010327e:	3c 04                	cmp    $0x4,%al
80103280:	0f 85 2a 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103286:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010328d:	66 85 d2             	test   %dx,%dx
80103290:	74 26                	je     801032b8 <mpinit+0xc8>
80103292:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103295:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103297:	31 d2                	xor    %edx,%edx
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032a0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032a7:	83 c0 01             	add    $0x1,%eax
801032aa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032ac:	39 f8                	cmp    %edi,%eax
801032ae:	75 f0                	jne    801032a0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032b0:	84 d2                	test   %dl,%dl
801032b2:	0f 85 f8 00 00 00    	jne    801033b0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032be:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032c9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032d0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032d8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop
801032e0:	39 c2                	cmp    %eax,%edx
801032e2:	76 15                	jbe    801032f9 <mpinit+0x109>
    switch(*p){
801032e4:	0f b6 08             	movzbl (%eax),%ecx
801032e7:	80 f9 02             	cmp    $0x2,%cl
801032ea:	74 5c                	je     80103348 <mpinit+0x158>
801032ec:	77 42                	ja     80103330 <mpinit+0x140>
801032ee:	84 c9                	test   %cl,%cl
801032f0:	74 6e                	je     80103360 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f5:	39 c2                	cmp    %eax,%edx
801032f7:	77 eb                	ja     801032e4 <mpinit+0xf4>
801032f9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032fc:	85 db                	test   %ebx,%ebx
801032fe:	0f 84 b9 00 00 00    	je     801033bd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103304:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103308:	74 15                	je     8010331f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010330a:	b8 70 00 00 00       	mov    $0x70,%eax
8010330f:	ba 22 00 00 00       	mov    $0x22,%edx
80103314:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103315:	ba 23 00 00 00       	mov    $0x23,%edx
8010331a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010331b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331e:	ee                   	out    %al,(%dx)
  }
}
8010331f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103322:	5b                   	pop    %ebx
80103323:	5e                   	pop    %esi
80103324:	5f                   	pop    %edi
80103325:	5d                   	pop    %ebp
80103326:	c3                   	ret    
80103327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103330:	83 e9 03             	sub    $0x3,%ecx
80103333:	80 f9 01             	cmp    $0x1,%cl
80103336:	76 ba                	jbe    801032f2 <mpinit+0x102>
80103338:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010333f:	eb 9f                	jmp    801032e0 <mpinit+0xf0>
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103348:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010334c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010334f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103355:	eb 89                	jmp    801032e0 <mpinit+0xf0>
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103360:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 54 ff ff ff       	jmp    801032e0 <mpinit+0xf0>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103390:	ba 00 00 01 00       	mov    $0x10000,%edx
80103395:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010339a:	e8 d1 fd ff ff       	call   80103170 <mpsearch1>
8010339f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033a1:	85 c0                	test   %eax,%eax
801033a3:	0f 85 9b fe ff ff    	jne    80103244 <mpinit+0x54>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 c2 82 10 80       	push   $0x801082c2
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 dc 82 10 80       	push   $0x801082dc
801033c5:	e8 c6 cf ff ff       	call   80100390 <panic>
801033ca:	66 90                	xchg   %ax,%ax
801033cc:	66 90                	xchg   %ax,%ax
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d9:	ba 21 00 00 00       	mov    $0x21,%edx
801033de:	ee                   	out    %al,(%dx)
801033df:	ba a1 00 00 00       	mov    $0xa1,%edx
801033e4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033e5:	c3                   	ret    
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	55                   	push   %ebp
801033f5:	89 e5                	mov    %esp,%ebp
801033f7:	57                   	push   %edi
801033f8:	56                   	push   %esi
801033f9:	53                   	push   %ebx
801033fa:	83 ec 0c             	sub    $0xc,%esp
801033fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103400:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103403:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103409:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010340f:	e8 ec d9 ff ff       	call   80100e00 <filealloc>
80103414:	89 03                	mov    %eax,(%ebx)
80103416:	85 c0                	test   %eax,%eax
80103418:	0f 84 ac 00 00 00    	je     801034ca <pipealloc+0xda>
8010341e:	e8 dd d9 ff ff       	call   80100e00 <filealloc>
80103423:	89 06                	mov    %eax,(%esi)
80103425:	85 c0                	test   %eax,%eax
80103427:	0f 84 8b 00 00 00    	je     801034b8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010342d:	e8 fe f1 ff ff       	call   80102630 <kalloc>
80103432:	89 c7                	mov    %eax,%edi
80103434:	85 c0                	test   %eax,%eax
80103436:	0f 84 b4 00 00 00    	je     801034f0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010343c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103443:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103446:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103449:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103450:	00 00 00 
  p->nwrite = 0;
80103453:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010345a:	00 00 00 
  p->nread = 0;
8010345d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103464:	00 00 00 
  initlock(&p->lock, "pipe");
80103467:	68 fb 82 10 80       	push   $0x801082fb
8010346c:	50                   	push   %eax
8010346d:	e8 ae 1a 00 00       	call   80104f20 <initlock>
  (*f0)->type = FD_PIPE;
80103472:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103474:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103477:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010347d:	8b 03                	mov    (%ebx),%eax
8010347f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103483:	8b 03                	mov    (%ebx),%eax
80103485:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103489:	8b 03                	mov    (%ebx),%eax
8010348b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
80103490:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103496:	8b 06                	mov    (%esi),%eax
80103498:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010349c:	8b 06                	mov    (%esi),%eax
8010349e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034aa:	31 c0                	xor    %eax,%eax
}
801034ac:	5b                   	pop    %ebx
801034ad:	5e                   	pop    %esi
801034ae:	5f                   	pop    %edi
801034af:	5d                   	pop    %ebp
801034b0:	c3                   	ret    
801034b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034b8:	8b 03                	mov    (%ebx),%eax
801034ba:	85 c0                	test   %eax,%eax
801034bc:	74 1e                	je     801034dc <pipealloc+0xec>
    fileclose(*f0);
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	50                   	push   %eax
801034c2:	e8 f9 d9 ff ff       	call   80100ec0 <fileclose>
801034c7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 0c                	je     801034dc <pipealloc+0xec>
    fileclose(*f1);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	50                   	push   %eax
801034d4:	e8 e7 d9 ff ff       	call   80100ec0 <fileclose>
801034d9:	83 c4 10             	add    $0x10,%esp
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	75 c8                	jne    801034be <pipealloc+0xce>
801034f6:	eb d2                	jmp    801034ca <pipealloc+0xda>
801034f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	56                   	push   %esi
80103508:	53                   	push   %ebx
80103509:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010350c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	53                   	push   %ebx
80103513:	e8 88 1b 00 00       	call   801050a0 <acquire>
  if(writable){
80103518:	83 c4 10             	add    $0x10,%esp
8010351b:	85 f6                	test   %esi,%esi
8010351d:	74 41                	je     80103560 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103528:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352f:	00 00 00 
    wakeup(&p->nread);
80103532:	50                   	push   %eax
80103533:	e8 a8 13 00 00       	call   801048e0 <wakeup>
80103538:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010353b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103541:	85 d2                	test   %edx,%edx
80103543:	75 0a                	jne    8010354f <pipeclose+0x4f>
80103545:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	74 31                	je     80103580 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103555:	5b                   	pop    %ebx
80103556:	5e                   	pop    %esi
80103557:	5d                   	pop    %ebp
    release(&p->lock);
80103558:	e9 03 1c 00 00       	jmp    80105160 <release>
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103569:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103570:	00 00 00 
    wakeup(&p->nwrite);
80103573:	50                   	push   %eax
80103574:	e8 67 13 00 00       	call   801048e0 <wakeup>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	eb bd                	jmp    8010353b <pipeclose+0x3b>
8010357e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 d7 1b 00 00       	call   80105160 <release>
    kfree((char*)p);
80103589:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010358c:	83 c4 10             	add    $0x10,%esp
}
8010358f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103592:	5b                   	pop    %ebx
80103593:	5e                   	pop    %esi
80103594:	5d                   	pop    %ebp
    kfree((char*)p);
80103595:	e9 d6 ee ff ff       	jmp    80102470 <kfree>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	57                   	push   %edi
801035a8:	56                   	push   %esi
801035a9:	53                   	push   %ebx
801035aa:	83 ec 28             	sub    $0x28,%esp
801035ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035b0:	53                   	push   %ebx
801035b1:	e8 ea 1a 00 00       	call   801050a0 <acquire>
  for(i = 0; i < n; i++){
801035b6:	8b 45 10             	mov    0x10(%ebp),%eax
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	85 c0                	test   %eax,%eax
801035be:	0f 8e bc 00 00 00    	jle    80103680 <pipewrite+0xe0>
801035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035c7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035cd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035d6:	03 45 10             	add    0x10(%ebp),%eax
801035d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035dc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e8:	89 ca                	mov    %ecx,%edx
801035ea:	05 00 02 00 00       	add    $0x200,%eax
801035ef:	39 c1                	cmp    %eax,%ecx
801035f1:	74 3b                	je     8010362e <pipewrite+0x8e>
801035f3:	eb 63                	jmp    80103658 <pipewrite+0xb8>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
801035f8:	e8 43 04 00 00       	call   80103a40 <myproc>
801035fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 d3 12 00 00       	call   801048e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 0a 11 00 00       	call   80104720 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103616:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010361c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	05 00 02 00 00       	add    $0x200,%eax
8010362a:	39 c2                	cmp    %eax,%edx
8010362c:	75 2a                	jne    80103658 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010362e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c0                	jne    801035f8 <pipewrite+0x58>
        release(&p->lock);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	53                   	push   %ebx
8010363c:	e8 1f 1b 00 00       	call   80105160 <release>
        return -1;
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010365b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010365e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103664:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010366a:	0f b6 06             	movzbl (%esi),%eax
8010366d:	83 c6 01             	add    $0x1,%esi
80103670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103673:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103677:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367a:	0f 85 5c ff ff ff    	jne    801035dc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103689:	50                   	push   %eax
8010368a:	e8 51 12 00 00       	call   801048e0 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 c9 1a 00 00       	call   80105160 <release>
  return n;
80103697:	8b 45 10             	mov    0x10(%ebp),%eax
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	eb aa                	jmp    80103649 <pipewrite+0xa9>
8010369f:	90                   	nop

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	f3 0f 1e fb          	endbr32 
801036a4:	55                   	push   %ebp
801036a5:	89 e5                	mov    %esp,%ebp
801036a7:	57                   	push   %edi
801036a8:	56                   	push   %esi
801036a9:	53                   	push   %ebx
801036aa:	83 ec 18             	sub    $0x18,%esp
801036ad:	8b 75 08             	mov    0x8(%ebp),%esi
801036b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036b3:	56                   	push   %esi
801036b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ba:	e8 e1 19 00 00       	call   801050a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ce:	74 33                	je     80103703 <piperead+0x63>
801036d0:	eb 3b                	jmp    8010370d <piperead+0x6d>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036d8:	e8 63 03 00 00       	call   80103a40 <myproc>
801036dd:	8b 48 24             	mov    0x24(%eax),%ecx
801036e0:	85 c9                	test   %ecx,%ecx
801036e2:	0f 85 88 00 00 00    	jne    80103770 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e8:	83 ec 08             	sub    $0x8,%esp
801036eb:	56                   	push   %esi
801036ec:	53                   	push   %ebx
801036ed:	e8 2e 10 00 00       	call   80104720 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036f2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103701:	75 0a                	jne    8010370d <piperead+0x6d>
80103703:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103709:	85 c0                	test   %eax,%eax
8010370b:	75 cb                	jne    801036d8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010370d:	8b 55 10             	mov    0x10(%ebp),%edx
80103710:	31 db                	xor    %ebx,%ebx
80103712:	85 d2                	test   %edx,%edx
80103714:	7f 28                	jg     8010373e <piperead+0x9e>
80103716:	eb 34                	jmp    8010374c <piperead+0xac>
80103718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103720:	8d 48 01             	lea    0x1(%eax),%ecx
80103723:	25 ff 01 00 00       	and    $0x1ff,%eax
80103728:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010372e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103733:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103736:	83 c3 01             	add    $0x1,%ebx
80103739:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010373c:	74 0e                	je     8010374c <piperead+0xac>
    if(p->nread == p->nwrite)
8010373e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103744:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010374a:	75 d4                	jne    80103720 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010374c:	83 ec 0c             	sub    $0xc,%esp
8010374f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103755:	50                   	push   %eax
80103756:	e8 85 11 00 00       	call   801048e0 <wakeup>
  release(&p->lock);
8010375b:	89 34 24             	mov    %esi,(%esp)
8010375e:	e8 fd 19 00 00       	call   80105160 <release>
  return i;
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103769:	89 d8                	mov    %ebx,%eax
8010376b:	5b                   	pop    %ebx
8010376c:	5e                   	pop    %esi
8010376d:	5f                   	pop    %edi
8010376e:	5d                   	pop    %ebp
8010376f:	c3                   	ret    
      release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103773:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103778:	56                   	push   %esi
80103779:	e8 e2 19 00 00       	call   80105160 <release>
      return -1;
8010377e:	83 c4 10             	add    $0x10,%esp
}
80103781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103784:	89 d8                	mov    %ebx,%eax
80103786:	5b                   	pop    %ebx
80103787:	5e                   	pop    %esi
80103788:	5f                   	pop    %edi
80103789:	5d                   	pop    %ebp
8010378a:	c3                   	ret    
8010378b:	66 90                	xchg   %ax,%ax
8010378d:	66 90                	xchg   %ax,%ax
8010378f:	90                   	nop

80103790 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103794:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80103799:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010379c:	68 20 3d 11 80       	push   $0x80113d20
801037a1:	e8 fa 18 00 00       	call   801050a0 <acquire>
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	eb 17                	jmp    801037c2 <allocproc+0x32>
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b0:	81 c3 04 01 00 00    	add    $0x104,%ebx
801037b6:	81 fb 54 7e 11 80    	cmp    $0x80117e54,%ebx
801037bc:	0f 84 ce 00 00 00    	je     80103890 <allocproc+0x100>
    if(p->state == UNUSED)
801037c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037c5:	85 c0                	test   %eax,%eax
801037c7:	75 e7                	jne    801037b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037c9:	8b 0d 04 b0 10 80    	mov    0x8010b004,%ecx
  p->exec_cycle_ratio = 1;
  p->arrival_time_ratio = 1;
  p->priority_ratio = 1;
  p->creation_time = ticks;
  // unlock me!
  release(&ptable.lock);
801037cf:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037d2:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->queue = (p->pid == 0 || p->pid == 1 || p->pid == 2) ? 1 : 1;     //FCFS
801037d9:	c7 83 e0 00 00 00 01 	movl   $0x1,0xe0(%ebx)
801037e0:	00 00 00 
  p->pid = nextpid++;
801037e3:	8d 41 01             	lea    0x1(%ecx),%eax
801037e6:	89 4b 10             	mov    %ecx,0x10(%ebx)
801037e9:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  p->priority = 100/p->pid;
801037ee:	b8 64 00 00 00       	mov    $0x64,%eax
  p->exec_cycle = 0;
801037f3:	c7 83 f4 00 00 00 00 	movl   $0x0,0xf4(%ebx)
801037fa:	00 00 00 
  p->priority = 100/p->pid;
801037fd:	99                   	cltd   
801037fe:	f7 f9                	idiv   %ecx
  p->last_cpu_time = 0;
80103800:	c7 83 fc 00 00 00 00 	movl   $0x0,0xfc(%ebx)
80103807:	00 00 00 
  p->exec_cycle_ratio = 1;
8010380a:	c7 83 f8 00 00 00 01 	movl   $0x1,0xf8(%ebx)
80103811:	00 00 00 
  p->arrival_time_ratio = 1;
80103814:	c7 83 f0 00 00 00 01 	movl   $0x1,0xf0(%ebx)
8010381b:	00 00 00 
  p->priority_ratio = 1;
8010381e:	c7 83 ec 00 00 00 01 	movl   $0x1,0xec(%ebx)
80103825:	00 00 00 
  p->priority = 100/p->pid;
80103828:	89 83 e8 00 00 00    	mov    %eax,0xe8(%ebx)
  p->creation_time = ticks;
8010382e:	a1 a0 86 11 80       	mov    0x801186a0,%eax
80103833:	89 83 e4 00 00 00    	mov    %eax,0xe4(%ebx)
  release(&ptable.lock);
80103839:	68 20 3d 11 80       	push   $0x80113d20
8010383e:	e8 1d 19 00 00       	call   80105160 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103843:	e8 e8 ed ff ff       	call   80102630 <kalloc>
80103848:	83 c4 10             	add    $0x10,%esp
8010384b:	89 43 08             	mov    %eax,0x8(%ebx)
8010384e:	85 c0                	test   %eax,%eax
80103850:	74 57                	je     801038a9 <allocproc+0x119>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103852:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103858:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010385b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103860:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103863:	c7 40 14 6a 65 10 80 	movl   $0x8010656a,0x14(%eax)
  p->context = (struct context*)sp;
8010386a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010386d:	6a 14                	push   $0x14
8010386f:	6a 00                	push   $0x0
80103871:	50                   	push   %eax
80103872:	e8 39 19 00 00       	call   801051b0 <memset>
  p->context->eip = (uint)forkret;
80103877:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010387a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010387d:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)
}
80103884:	89 d8                	mov    %ebx,%eax
80103886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103889:	c9                   	leave  
8010388a:	c3                   	ret    
8010388b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop
  release(&ptable.lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103893:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103895:	68 20 3d 11 80       	push   $0x80113d20
8010389a:	e8 c1 18 00 00       	call   80105160 <release>
}
8010389f:	89 d8                	mov    %ebx,%eax
  return 0;
801038a1:	83 c4 10             	add    $0x10,%esp
}
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
    p->state = UNUSED;
801038a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038b0:	31 db                	xor    %ebx,%ebx
}
801038b2:	89 d8                	mov    %ebx,%eax
801038b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b7:	c9                   	leave  
801038b8:	c3                   	ret    
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038ca:	68 20 3d 11 80       	push   $0x80113d20
801038cf:	e8 8c 18 00 00       	call   80105160 <release>

  if (first) {
801038d4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	85 c0                	test   %eax,%eax
801038de:	75 08                	jne    801038e8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038e0:	c9                   	leave  
801038e1:	c3                   	ret    
801038e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038e8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038ef:	00 00 00 
    iinit(ROOTDEV);
801038f2:	83 ec 0c             	sub    $0xc,%esp
801038f5:	6a 01                	push   $0x1
801038f7:	e8 44 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103903:	e8 88 f3 ff ff       	call   80102c90 <initlog>
}
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	c9                   	leave  
8010390c:	c3                   	ret    
8010390d:	8d 76 00             	lea    0x0(%esi),%esi

80103910 <compareStrings>:
{
80103910:	f3 0f 1e fb          	endbr32 
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	56                   	push   %esi
80103918:	8b 45 08             	mov    0x8(%ebp),%eax
8010391b:	53                   	push   %ebx
8010391c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    while (*x != '\0' || *y != '\0') {
8010391f:	90                   	nop
80103920:	0f b6 10             	movzbl (%eax),%edx
80103923:	0f b6 0b             	movzbl (%ebx),%ecx
80103926:	84 d2                	test   %dl,%dl
80103928:	75 56                	jne    80103980 <compareStrings+0x70>
8010392a:	84 c9                	test   %cl,%cl
8010392c:	0f 94 c1             	sete   %cl
8010392f:	0f b6 c9             	movzbl %cl,%ecx
80103932:	89 ce                	mov    %ecx,%esi
    cprintf("%s", x);
80103934:	83 ec 08             	sub    $0x8,%esp
80103937:	50                   	push   %eax
80103938:	68 09 84 10 80       	push   $0x80108409
8010393d:	e8 6e cd ff ff       	call   801006b0 <cprintf>
    cprintf("/n");
80103942:	c7 04 24 00 83 10 80 	movl   $0x80108300,(%esp)
80103949:	e8 62 cd ff ff       	call   801006b0 <cprintf>
    cprintf("%s", y);
8010394e:	58                   	pop    %eax
8010394f:	5a                   	pop    %edx
80103950:	53                   	push   %ebx
80103951:	68 09 84 10 80       	push   $0x80108409
80103956:	e8 55 cd ff ff       	call   801006b0 <cprintf>
    cprintf("/n");
8010395b:	c7 04 24 00 83 10 80 	movl   $0x80108300,(%esp)
80103962:	e8 49 cd ff ff       	call   801006b0 <cprintf>
    cprintf("%d", flag);
80103967:	59                   	pop    %ecx
80103968:	5b                   	pop    %ebx
80103969:	56                   	push   %esi
8010396a:	68 03 83 10 80       	push   $0x80108303
8010396f:	e8 3c cd ff ff       	call   801006b0 <cprintf>
}
80103974:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103977:	89 f0                	mov    %esi,%eax
80103979:	5b                   	pop    %ebx
8010397a:	5e                   	pop    %esi
8010397b:	5d                   	pop    %ebp
8010397c:	c3                   	ret    
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
        if (*x == *y) {
80103980:	38 ca                	cmp    %cl,%dl
80103982:	75 08                	jne    8010398c <compareStrings+0x7c>
            x++;
80103984:	83 c0 01             	add    $0x1,%eax
            y++;
80103987:	83 c3 01             	add    $0x1,%ebx
8010398a:	eb 94                	jmp    80103920 <compareStrings+0x10>
            flag = 0;
8010398c:	31 f6                	xor    %esi,%esi
8010398e:	eb a4                	jmp    80103934 <compareStrings+0x24>

80103990 <pinit>:
{
80103990:	f3 0f 1e fb          	endbr32 
80103994:	55                   	push   %ebp
80103995:	89 e5                	mov    %esp,%ebp
80103997:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010399a:	68 06 83 10 80       	push   $0x80108306
8010399f:	68 20 3d 11 80       	push   $0x80113d20
801039a4:	e8 77 15 00 00       	call   80104f20 <initlock>
}
801039a9:	83 c4 10             	add    $0x10,%esp
801039ac:	c9                   	leave  
801039ad:	c3                   	ret    
801039ae:	66 90                	xchg   %ax,%ax

801039b0 <mycpu>:
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	56                   	push   %esi
801039b8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039b9:	9c                   	pushf  
801039ba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039bb:	f6 c4 02             	test   $0x2,%ah
801039be:	75 4a                	jne    80103a0a <mycpu+0x5a>
  apicid = lapicid();
801039c0:	e8 db ee ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039c5:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
801039cb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801039cd:	85 f6                	test   %esi,%esi
801039cf:	7e 2c                	jle    801039fd <mycpu+0x4d>
801039d1:	31 d2                	xor    %edx,%edx
801039d3:	eb 0a                	jmp    801039df <mycpu+0x2f>
801039d5:	8d 76 00             	lea    0x0(%esi),%esi
801039d8:	83 c2 01             	add    $0x1,%edx
801039db:	39 f2                	cmp    %esi,%edx
801039dd:	74 1e                	je     801039fd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801039df:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039e5:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
801039ec:	39 d8                	cmp    %ebx,%eax
801039ee:	75 e8                	jne    801039d8 <mycpu+0x28>
}
801039f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039f3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
801039f9:	5b                   	pop    %ebx
801039fa:	5e                   	pop    %esi
801039fb:	5d                   	pop    %ebp
801039fc:	c3                   	ret    
  panic("unknown apicid\n");
801039fd:	83 ec 0c             	sub    $0xc,%esp
80103a00:	68 0d 83 10 80       	push   $0x8010830d
80103a05:	e8 86 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a0a:	83 ec 0c             	sub    $0xc,%esp
80103a0d:	68 50 84 10 80       	push   $0x80108450
80103a12:	e8 79 c9 ff ff       	call   80100390 <panic>
80103a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1e:	66 90                	xchg   %ax,%ax

80103a20 <cpuid>:
cpuid() {
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a2a:	e8 81 ff ff ff       	call   801039b0 <mycpu>
}
80103a2f:	c9                   	leave  
  return mycpu()-cpus;
80103a30:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103a35:	c1 f8 04             	sar    $0x4,%eax
80103a38:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a3e:	c3                   	ret    
80103a3f:	90                   	nop

80103a40 <myproc>:
myproc(void) {
80103a40:	f3 0f 1e fb          	endbr32 
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	53                   	push   %ebx
80103a48:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a4b:	e8 50 15 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
80103a50:	e8 5b ff ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103a55:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a5b:	e8 90 15 00 00       	call   80104ff0 <popcli>
}
80103a60:	83 c4 04             	add    $0x4,%esp
80103a63:	89 d8                	mov    %ebx,%eax
80103a65:	5b                   	pop    %ebx
80103a66:	5d                   	pop    %ebp
80103a67:	c3                   	ret    
80103a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop

80103a70 <userinit>:
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	53                   	push   %ebx
80103a78:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a7b:	e8 10 fd ff ff       	call   80103790 <allocproc>
80103a80:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a82:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a87:	e8 a4 40 00 00       	call   80107b30 <setupkvm>
80103a8c:	89 43 04             	mov    %eax,0x4(%ebx)
80103a8f:	85 c0                	test   %eax,%eax
80103a91:	0f 84 df 00 00 00    	je     80103b76 <userinit+0x106>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a97:	83 ec 04             	sub    $0x4,%esp
80103a9a:	68 2c 00 00 00       	push   $0x2c
80103a9f:	68 60 b4 10 80       	push   $0x8010b460
80103aa4:	50                   	push   %eax
80103aa5:	e8 56 3d 00 00       	call   80107800 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103aaa:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103aad:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ab3:	6a 4c                	push   $0x4c
80103ab5:	6a 00                	push   $0x0
80103ab7:	ff 73 18             	pushl  0x18(%ebx)
80103aba:	e8 f1 16 00 00       	call   801051b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac2:	ba 1b 00 00 00       	mov    $0x1b,%edx
80103ac7:	83 c4 10             	add    $0x10,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aca:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103acf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ad3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ada:	8b 43 18             	mov    0x18(%ebx),%eax
80103add:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ae1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ae5:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103aec:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103af0:	8b 43 18             	mov    0x18(%ebx),%eax
80103af3:	8d 93 e0 00 00 00    	lea    0xe0(%ebx),%edx
80103af9:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b00:	8b 43 18             	mov    0x18(%ebx),%eax
80103b03:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b0a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b0d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  for(int k=0; k < 25; k++)
80103b14:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1e:	66 90                	xchg   %ax,%ax
  	p->syscnt[k] = 0;
80103b20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int k=0; k < 25; k++)
80103b26:	83 c0 04             	add    $0x4,%eax
80103b29:	39 c2                	cmp    %eax,%edx
80103b2b:	75 f3                	jne    80103b20 <userinit+0xb0>
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b2d:	83 ec 04             	sub    $0x4,%esp
80103b30:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b33:	6a 10                	push   $0x10
80103b35:	68 36 83 10 80       	push   $0x80108336
80103b3a:	50                   	push   %eax
80103b3b:	e8 30 18 00 00       	call   80105370 <safestrcpy>
  p->cwd = namei("/");
80103b40:	c7 04 24 3f 83 10 80 	movl   $0x8010833f,(%esp)
80103b47:	e8 e4 e4 ff ff       	call   80102030 <namei>
80103b4c:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b4f:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103b56:	e8 45 15 00 00       	call   801050a0 <acquire>
  p->state = RUNNABLE;
80103b5b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b62:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103b69:	e8 f2 15 00 00       	call   80105160 <release>
}
80103b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	c9                   	leave  
80103b75:	c3                   	ret    
    panic("userinit: out of memory?");
80103b76:	83 ec 0c             	sub    $0xc,%esp
80103b79:	68 1d 83 10 80       	push   $0x8010831d
80103b7e:	e8 0d c8 ff ff       	call   80100390 <panic>
80103b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b90 <growproc>:
{
80103b90:	f3 0f 1e fb          	endbr32 
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	56                   	push   %esi
80103b98:	53                   	push   %ebx
80103b99:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b9c:	e8 ff 13 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
80103ba1:	e8 0a fe ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103ba6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bac:	e8 3f 14 00 00       	call   80104ff0 <popcli>
  sz = curproc->sz;
80103bb1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bb3:	85 f6                	test   %esi,%esi
80103bb5:	7f 19                	jg     80103bd0 <growproc+0x40>
  } else if(n < 0){
80103bb7:	75 37                	jne    80103bf0 <growproc+0x60>
  switchuvm(curproc);
80103bb9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bbc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bbe:	53                   	push   %ebx
80103bbf:	e8 2c 3b 00 00       	call   801076f0 <switchuvm>
  return 0;
80103bc4:	83 c4 10             	add    $0x10,%esp
80103bc7:	31 c0                	xor    %eax,%eax
}
80103bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bcc:	5b                   	pop    %ebx
80103bcd:	5e                   	pop    %esi
80103bce:	5d                   	pop    %ebp
80103bcf:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bd0:	83 ec 04             	sub    $0x4,%esp
80103bd3:	01 c6                	add    %eax,%esi
80103bd5:	56                   	push   %esi
80103bd6:	50                   	push   %eax
80103bd7:	ff 73 04             	pushl  0x4(%ebx)
80103bda:	e8 71 3d 00 00       	call   80107950 <allocuvm>
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	85 c0                	test   %eax,%eax
80103be4:	75 d3                	jne    80103bb9 <growproc+0x29>
      return -1;
80103be6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103beb:	eb dc                	jmp    80103bc9 <growproc+0x39>
80103bed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bf0:	83 ec 04             	sub    $0x4,%esp
80103bf3:	01 c6                	add    %eax,%esi
80103bf5:	56                   	push   %esi
80103bf6:	50                   	push   %eax
80103bf7:	ff 73 04             	pushl  0x4(%ebx)
80103bfa:	e8 81 3e 00 00       	call   80107a80 <deallocuvm>
80103bff:	83 c4 10             	add    $0x10,%esp
80103c02:	85 c0                	test   %eax,%eax
80103c04:	75 b3                	jne    80103bb9 <growproc+0x29>
80103c06:	eb de                	jmp    80103be6 <growproc+0x56>
80103c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c0f:	90                   	nop

80103c10 <fork>:
{
80103c10:	f3 0f 1e fb          	endbr32 
80103c14:	55                   	push   %ebp
80103c15:	89 e5                	mov    %esp,%ebp
80103c17:	57                   	push   %edi
80103c18:	56                   	push   %esi
80103c19:	53                   	push   %ebx
80103c1a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c1d:	e8 7e 13 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
80103c22:	e8 89 fd ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103c27:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c2d:	e8 be 13 00 00       	call   80104ff0 <popcli>
  if((np = allocproc()) == 0){
80103c32:	e8 59 fb ff ff       	call   80103790 <allocproc>
80103c37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c3a:	85 c0                	test   %eax,%eax
80103c3c:	0f 84 bb 00 00 00    	je     80103cfd <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c42:	83 ec 08             	sub    $0x8,%esp
80103c45:	ff 33                	pushl  (%ebx)
80103c47:	89 c7                	mov    %eax,%edi
80103c49:	ff 73 04             	pushl  0x4(%ebx)
80103c4c:	e8 af 3f 00 00       	call   80107c00 <copyuvm>
80103c51:	83 c4 10             	add    $0x10,%esp
80103c54:	89 47 04             	mov    %eax,0x4(%edi)
80103c57:	85 c0                	test   %eax,%eax
80103c59:	0f 84 a5 00 00 00    	je     80103d04 <fork+0xf4>
  np->sz = curproc->sz;
80103c5f:	8b 03                	mov    (%ebx),%eax
80103c61:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c64:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c66:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c69:	89 c8                	mov    %ecx,%eax
80103c6b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c6e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c73:	8b 73 18             	mov    0x18(%ebx),%esi
80103c76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c78:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c7a:	8b 40 18             	mov    0x18(%eax),%eax
80103c7d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c88:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c8c:	85 c0                	test   %eax,%eax
80103c8e:	74 13                	je     80103ca3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c90:	83 ec 0c             	sub    $0xc,%esp
80103c93:	50                   	push   %eax
80103c94:	e8 d7 d1 ff ff       	call   80100e70 <filedup>
80103c99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c9c:	83 c4 10             	add    $0x10,%esp
80103c9f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ca3:	83 c6 01             	add    $0x1,%esi
80103ca6:	83 fe 10             	cmp    $0x10,%esi
80103ca9:	75 dd                	jne    80103c88 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103cab:	83 ec 0c             	sub    $0xc,%esp
80103cae:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cb1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cb4:	e8 77 da ff ff       	call   80101730 <idup>
80103cb9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cbc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cbf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cc2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103cc5:	6a 10                	push   $0x10
80103cc7:	53                   	push   %ebx
80103cc8:	50                   	push   %eax
80103cc9:	e8 a2 16 00 00       	call   80105370 <safestrcpy>
  pid = np->pid;
80103cce:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103cd1:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cd8:	e8 c3 13 00 00       	call   801050a0 <acquire>
  np->state = RUNNABLE;
80103cdd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103ce4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ceb:	e8 70 14 00 00       	call   80105160 <release>
  return pid;
80103cf0:	83 c4 10             	add    $0x10,%esp
}
80103cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cf6:	89 d8                	mov    %ebx,%eax
80103cf8:	5b                   	pop    %ebx
80103cf9:	5e                   	pop    %esi
80103cfa:	5f                   	pop    %edi
80103cfb:	5d                   	pop    %ebp
80103cfc:	c3                   	ret    
    return -1;
80103cfd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d02:	eb ef                	jmp    80103cf3 <fork+0xe3>
    kfree(np->kstack);
80103d04:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d07:	83 ec 0c             	sub    $0xc,%esp
80103d0a:	ff 73 08             	pushl  0x8(%ebx)
80103d0d:	e8 5e e7 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103d12:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d19:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d1c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d28:	eb c9                	jmp    80103cf3 <fork+0xe3>
80103d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d30 <round>:
int round(float num){
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	83 ec 08             	sub    $0x8,%esp
  if(num - (int)(num) <= 0.5)
80103d3a:	d9 7d fe             	fnstcw -0x2(%ebp)
int round(float num){
80103d3d:	d9 45 08             	flds   0x8(%ebp)
  if(num - (int)(num) <= 0.5)
80103d40:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
80103d44:	80 cc 0c             	or     $0xc,%ah
80103d47:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103d4b:	d9 6d fc             	fldcw  -0x4(%ebp)
80103d4e:	db 55 f8             	fistl  -0x8(%ebp)
80103d51:	d9 6d fe             	fldcw  -0x2(%ebp)
80103d54:	db 45 f8             	fildl  -0x8(%ebp)
80103d57:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103d5a:	de e9                	fsubrp %st,%st(1)
80103d5c:	d9 05 5c 85 10 80    	flds   0x8010855c
}
80103d62:	c9                   	leave  
  return (int)(num) + 1;
80103d63:	df e9                	fucomip %st(1),%st
80103d65:	dd d8                	fstp   %st(0)
80103d67:	83 d0 00             	adc    $0x0,%eax
}
80103d6a:	c3                   	ret    
80103d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d6f:	90                   	nop

80103d70 <get_state_string>:
{
80103d70:	f3 0f 1e fb          	endbr32 
80103d74:	55                   	push   %ebp
    return "UNUSED";
80103d75:	b8 50 83 10 80       	mov    $0x80108350,%eax
{
80103d7a:	89 e5                	mov    %esp,%ebp
80103d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  if (state == 0) {
80103d7f:	85 d2                	test   %edx,%edx
80103d81:	74 38                	je     80103dbb <get_state_string+0x4b>
    return "EMBRYO";
80103d83:	b8 57 83 10 80       	mov    $0x80108357,%eax
  else if (state == 1) {
80103d88:	83 fa 01             	cmp    $0x1,%edx
80103d8b:	74 2e                	je     80103dbb <get_state_string+0x4b>
    return "SLEEPING";
80103d8d:	b8 67 83 10 80       	mov    $0x80108367,%eax
  else if (state == 2) {
80103d92:	83 fa 02             	cmp    $0x2,%edx
80103d95:	74 24                	je     80103dbb <get_state_string+0x4b>
    return "RUNNABLE";
80103d97:	b8 5e 83 10 80       	mov    $0x8010835e,%eax
  else if (state == 3) {
80103d9c:	83 fa 03             	cmp    $0x3,%edx
80103d9f:	74 1a                	je     80103dbb <get_state_string+0x4b>
    return "RUNNING";
80103da1:	b8 41 83 10 80       	mov    $0x80108341,%eax
  else if (state == 4) {
80103da6:	83 fa 04             	cmp    $0x4,%edx
80103da9:	74 10                	je     80103dbb <get_state_string+0x4b>
    return "";
80103dab:	83 fa 05             	cmp    $0x5,%edx
80103dae:	b8 49 83 10 80       	mov    $0x80108349,%eax
80103db3:	ba 23 84 10 80       	mov    $0x80108423,%edx
80103db8:	0f 45 c2             	cmovne %edx,%eax
}
80103dbb:	5d                   	pop    %ebp
80103dbc:	c3                   	ret    
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi

80103dc0 <get_queue_string>:
{
80103dc0:	f3 0f 1e fb          	endbr32 
80103dc4:	55                   	push   %ebp
80103dc5:	b8 70 83 10 80       	mov    $0x80108370,%eax
80103dca:	89 e5                	mov    %esp,%ebp
80103dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  if (queue == 1)
80103dcf:	83 fa 01             	cmp    $0x1,%edx
80103dd2:	74 10                	je     80103de4 <get_queue_string+0x24>
    return "BJF";
80103dd4:	83 fa 02             	cmp    $0x2,%edx
80103dd7:	b8 73 83 10 80       	mov    $0x80108373,%eax
80103ddc:	ba 78 83 10 80       	mov    $0x80108378,%edx
80103de1:	0f 45 c2             	cmovne %edx,%eax
}
80103de4:	5d                   	pop    %ebp
80103de5:	c3                   	ret    
80103de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ded:	8d 76 00             	lea    0x0(%esi),%esi

80103df0 <get_rank>:
{
80103df0:	f3 0f 1e fb          	endbr32 
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	83 ec 10             	sub    $0x10,%esp
80103dfa:	8b 45 08             	mov    0x8(%ebp),%eax
             + p->exec_cycle * p->exec_cycle_ratio;
80103dfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int rank = p->priority * p->priority_ratio
80103e04:	8b 90 e8 00 00 00    	mov    0xe8(%eax),%edx
80103e0a:	8b 88 ec 00 00 00    	mov    0xec(%eax),%ecx
80103e10:	0f af ca             	imul   %edx,%ecx
             + p->creation_time * p->arrival_time_ratio
80103e13:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
80103e19:	0f af 90 f0 00 00 00 	imul   0xf0(%eax),%edx
80103e20:	01 ca                	add    %ecx,%edx
             + p->exec_cycle * p->exec_cycle_ratio;
80103e22:	89 55 f0             	mov    %edx,-0x10(%ebp)
80103e25:	df 6d f0             	fildll -0x10(%ebp)
80103e28:	db 80 f8 00 00 00    	fildl  0xf8(%eax)
80103e2e:	d8 88 f4 00 00 00    	fmuls  0xf4(%eax)
  int rank = p->priority * p->priority_ratio
80103e34:	d9 7d fe             	fnstcw -0x2(%ebp)
80103e37:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
             + p->exec_cycle * p->exec_cycle_ratio;
80103e3b:	de c1                	faddp  %st,%st(1)
  int rank = p->priority * p->priority_ratio
80103e3d:	80 cc 0c             	or     $0xc,%ah
80103e40:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103e44:	d9 6d fc             	fldcw  -0x4(%ebp)
80103e47:	db 5d f0             	fistpl -0x10(%ebp)
80103e4a:	d9 6d fe             	fldcw  -0x2(%ebp)
80103e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e50:	c9                   	leave  
80103e51:	c3                   	ret    
80103e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e60 <print_procs>:
{
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	57                   	push   %edi
80103e68:	56                   	push   %esi
80103e69:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6a:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80103e6f:	83 ec 28             	sub    $0x28,%esp
  cprintf("name          pid          state          queue_lvl      exec_cycle*10     arrival_time      rank           priority    ratios(priority,arrival_time,exec_cycle)");
80103e72:	68 78 84 10 80       	push   $0x80108478
80103e77:	e8 34 c8 ff ff       	call   801006b0 <cprintf>
  cprintf("\n");
80103e7c:	c7 04 24 22 84 10 80 	movl   $0x80108422,(%esp)
80103e83:	e8 28 c8 ff ff       	call   801006b0 <cprintf>
  acquire(&ptable.lock);
80103e88:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e8f:	e8 0c 12 00 00       	call   801050a0 <acquire>
80103e94:	83 c4 10             	add    $0x10,%esp
80103e97:	eb 19                	jmp    80103eb2 <print_procs+0x52>
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea0:	81 c3 04 01 00 00    	add    $0x104,%ebx
80103ea6:	81 fb 54 7e 11 80    	cmp    $0x80117e54,%ebx
80103eac:	0f 84 00 02 00 00    	je     801040b2 <print_procs+0x252>
    if (p->state == UNUSED)
80103eb2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103eb5:	85 c0                	test   %eax,%eax
80103eb7:	74 e7                	je     80103ea0 <print_procs+0x40>
    cprintf(p->name);
80103eb9:	83 ec 0c             	sub    $0xc,%esp
80103ebc:	8d 7b 6c             	lea    0x6c(%ebx),%edi
    for(int i=0; i<15-strlen(p->name); i++)
80103ebf:	31 f6                	xor    %esi,%esi
    cprintf(p->name);
80103ec1:	57                   	push   %edi
80103ec2:	e8 e9 c7 ff ff       	call   801006b0 <cprintf>
    for(int i=0; i<15-strlen(p->name); i++)
80103ec7:	83 c4 10             	add    $0x10,%esp
80103eca:	eb 17                	jmp    80103ee3 <print_procs+0x83>
80103ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf(" ");
80103ed0:	83 ec 0c             	sub    $0xc,%esp
    for(int i=0; i<15-strlen(p->name); i++)
80103ed3:	83 c6 01             	add    $0x1,%esi
      cprintf(" ");
80103ed6:	68 8b 83 10 80       	push   $0x8010838b
80103edb:	e8 d0 c7 ff ff       	call   801006b0 <cprintf>
    for(int i=0; i<15-strlen(p->name); i++)
80103ee0:	83 c4 10             	add    $0x10,%esp
80103ee3:	83 ec 0c             	sub    $0xc,%esp
80103ee6:	57                   	push   %edi
80103ee7:	e8 c4 14 00 00       	call   801053b0 <strlen>
80103eec:	b9 0f 00 00 00       	mov    $0xf,%ecx
80103ef1:	83 c4 10             	add    $0x10,%esp
80103ef4:	29 c1                	sub    %eax,%ecx
80103ef6:	39 f1                	cmp    %esi,%ecx
80103ef8:	7f d6                	jg     80103ed0 <print_procs+0x70>
    cprintf("%d", p->pid);
80103efa:	83 ec 08             	sub    $0x8,%esp
80103efd:	ff 73 10             	pushl  0x10(%ebx)
80103f00:	68 03 83 10 80       	push   $0x80108303
80103f05:	e8 a6 c7 ff ff       	call   801006b0 <cprintf>
    cprintf("           ");
80103f0a:	c7 04 24 81 83 10 80 	movl   $0x80108381,(%esp)
80103f11:	e8 9a c7 ff ff       	call   801006b0 <cprintf>
    cprintf(get_state_string(p->state));
80103f16:	5f                   	pop    %edi
80103f17:	ff 73 0c             	pushl  0xc(%ebx)
80103f1a:	e8 51 fe ff ff       	call   80103d70 <get_state_string>
80103f1f:	89 04 24             	mov    %eax,(%esp)
80103f22:	e8 89 c7 ff ff       	call   801006b0 <cprintf>
    cprintf("           ");
80103f27:	c7 04 24 81 83 10 80 	movl   $0x80108381,(%esp)
80103f2e:	e8 7d c7 ff ff       	call   801006b0 <cprintf>
    cprintf(get_queue_string(p->queue));
80103f33:	8b 93 e0 00 00 00    	mov    0xe0(%ebx),%edx
  if (queue == 1)
80103f39:	83 c4 10             	add    $0x10,%esp
    return "RR";
80103f3c:	b8 70 83 10 80       	mov    $0x80108370,%eax
  if (queue == 1)
80103f41:	83 fa 01             	cmp    $0x1,%edx
80103f44:	74 10                	je     80103f56 <print_procs+0xf6>
    return "BJF";
80103f46:	83 fa 02             	cmp    $0x2,%edx
80103f49:	b8 73 83 10 80       	mov    $0x80108373,%eax
80103f4e:	ba 78 83 10 80       	mov    $0x80108378,%edx
80103f53:	0f 45 c2             	cmovne %edx,%eax
    cprintf(get_queue_string(p->queue));
80103f56:	83 ec 0c             	sub    $0xc,%esp
80103f59:	50                   	push   %eax
80103f5a:	e8 51 c7 ff ff       	call   801006b0 <cprintf>
    cprintf("             ");
80103f5f:	c7 04 24 7f 83 10 80 	movl   $0x8010837f,(%esp)
80103f66:	e8 45 c7 ff ff       	call   801006b0 <cprintf>
    cprintf("%d", round(p->exec_cycle * 10));
80103f6b:	d9 05 60 85 10 80    	flds   0x80108560
  if(num - (int)(num) <= 0.5)
80103f71:	5a                   	pop    %edx
80103f72:	d9 7d e6             	fnstcw -0x1a(%ebp)
    cprintf("%d", round(p->exec_cycle * 10));
80103f75:	d8 8b f4 00 00 00    	fmuls  0xf4(%ebx)
  if(num - (int)(num) <= 0.5)
80103f7b:	59                   	pop    %ecx
80103f7c:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103f80:	80 cc 0c             	or     $0xc,%ah
80103f83:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103f87:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f8a:	db 55 d8             	fistl  -0x28(%ebp)
80103f8d:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103f90:	db 45 d8             	fildl  -0x28(%ebp)
80103f93:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103f96:	de e9                	fsubrp %st,%st(1)
80103f98:	d9 05 5c 85 10 80    	flds   0x8010855c
  return (int)(num) + 1;
80103f9e:	df e9                	fucomip %st(1),%st
80103fa0:	dd d8                	fstp   %st(0)
80103fa2:	83 d0 00             	adc    $0x0,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa5:	81 c3 04 01 00 00    	add    $0x104,%ebx
    cprintf("%d", round(p->exec_cycle * 10));
80103fab:	50                   	push   %eax
80103fac:	68 03 83 10 80       	push   $0x80108303
80103fb1:	e8 fa c6 ff ff       	call   801006b0 <cprintf>
    cprintf("                ");
80103fb6:	c7 04 24 7c 83 10 80 	movl   $0x8010837c,(%esp)
80103fbd:	e8 ee c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d", p->creation_time);
80103fc2:	5e                   	pop    %esi
80103fc3:	5f                   	pop    %edi
80103fc4:	ff 73 e0             	pushl  -0x20(%ebx)
80103fc7:	68 03 83 10 80       	push   $0x80108303
80103fcc:	e8 df c6 ff ff       	call   801006b0 <cprintf>
    cprintf("           ");
80103fd1:	c7 04 24 81 83 10 80 	movl   $0x80108381,(%esp)
80103fd8:	e8 d3 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d", get_rank(p));
80103fdd:	58                   	pop    %eax
  int rank = p->priority * p->priority_ratio
80103fde:	8b 43 e8             	mov    -0x18(%ebx),%eax
             + p->exec_cycle * p->exec_cycle_ratio;
80103fe1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  int rank = p->priority * p->priority_ratio
80103fe8:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103feb:	0f af 43 e4          	imul   -0x1c(%ebx),%eax
    cprintf("%d", get_rank(p));
80103fef:	5a                   	pop    %edx
  int rank = p->priority * p->priority_ratio
80103ff0:	89 c2                	mov    %eax,%edx
             + p->creation_time * p->arrival_time_ratio
80103ff2:	8b 43 e0             	mov    -0x20(%ebx),%eax
80103ff5:	0f af 43 ec          	imul   -0x14(%ebx),%eax
80103ff9:	01 d0                	add    %edx,%eax
             + p->exec_cycle * p->exec_cycle_ratio;
80103ffb:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103ffe:	df 6d d8             	fildll -0x28(%ebp)
80104001:	db 43 f4             	fildl  -0xc(%ebx)
80104004:	d8 4b f0             	fmuls  -0x10(%ebx)
  int rank = p->priority * p->priority_ratio
80104007:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010400b:	80 cc 0c             	or     $0xc,%ah
             + p->exec_cycle * p->exec_cycle_ratio;
8010400e:	de c1                	faddp  %st,%st(1)
  int rank = p->priority * p->priority_ratio
80104010:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104014:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104017:	db 5d d8             	fistpl -0x28(%ebp)
8010401a:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010401d:	8b 45 d8             	mov    -0x28(%ebp),%eax
    cprintf("%d", get_rank(p));
80104020:	50                   	push   %eax
80104021:	68 03 83 10 80       	push   $0x80108303
80104026:	e8 85 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("          ");
8010402b:	c7 04 24 82 83 10 80 	movl   $0x80108382,(%esp)
80104032:	e8 79 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d",p->priority);
80104037:	59                   	pop    %ecx
80104038:	5e                   	pop    %esi
80104039:	ff 73 e4             	pushl  -0x1c(%ebx)
8010403c:	68 03 83 10 80       	push   $0x80108303
80104041:	e8 6a c6 ff ff       	call   801006b0 <cprintf>
    cprintf("                ");
80104046:	c7 04 24 7c 83 10 80 	movl   $0x8010837c,(%esp)
8010404d:	e8 5e c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d", p->arrival_time_ratio);
80104052:	5f                   	pop    %edi
80104053:	58                   	pop    %eax
80104054:	ff 73 ec             	pushl  -0x14(%ebx)
80104057:	68 03 83 10 80       	push   $0x80108303
8010405c:	e8 4f c6 ff ff       	call   801006b0 <cprintf>
    cprintf("-");
80104061:	c7 04 24 8d 83 10 80 	movl   $0x8010838d,(%esp)
80104068:	e8 43 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d",p->exec_cycle_ratio);
8010406d:	58                   	pop    %eax
8010406e:	5a                   	pop    %edx
8010406f:	ff 73 f4             	pushl  -0xc(%ebx)
80104072:	68 03 83 10 80       	push   $0x80108303
80104077:	e8 34 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("-");
8010407c:	c7 04 24 8d 83 10 80 	movl   $0x8010838d,(%esp)
80104083:	e8 28 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d",p->priority_ratio);
80104088:	59                   	pop    %ecx
80104089:	5e                   	pop    %esi
8010408a:	ff 73 e8             	pushl  -0x18(%ebx)
8010408d:	68 03 83 10 80       	push   $0x80108303
80104092:	e8 19 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("\n");
80104097:	c7 04 24 22 84 10 80 	movl   $0x80108422,(%esp)
8010409e:	e8 0d c6 ff ff       	call   801006b0 <cprintf>
801040a3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040a6:	81 fb 54 7e 11 80    	cmp    $0x80117e54,%ebx
801040ac:	0f 85 00 fe ff ff    	jne    80103eb2 <print_procs+0x52>
  release(&ptable.lock);
801040b2:	83 ec 0c             	sub    $0xc,%esp
801040b5:	68 20 3d 11 80       	push   $0x80113d20
801040ba:	e8 a1 10 00 00       	call   80105160 <release>
}
801040bf:	83 c4 10             	add    $0x10,%esp
801040c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c5:	5b                   	pop    %ebx
801040c6:	5e                   	pop    %esi
801040c7:	5f                   	pop    %edi
801040c8:	5d                   	pop    %ebp
801040c9:	c3                   	ret    
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040d0 <find_RR>:
{
801040d0:	f3 0f 1e fb          	endbr32 
801040d4:	55                   	push   %ebp
  int max_proc = -100000;
801040d5:	b9 60 79 fe ff       	mov    $0xfffe7960,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040da:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
801040df:	89 e5                	mov    %esp,%ebp
801040e1:	56                   	push   %esi
  struct proc *best = 0;
801040e2:	31 f6                	xor    %esi,%esi
{
801040e4:	53                   	push   %ebx
  int now = ticks;
801040e5:	8b 1d a0 86 11 80    	mov    0x801186a0,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop
      if(p->state != RUNNABLE || p->queue != 1)
801040f0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801040f4:	75 1a                	jne    80104110 <find_RR+0x40>
801040f6:	83 b8 e0 00 00 00 01 	cmpl   $0x1,0xe0(%eax)
801040fd:	75 11                	jne    80104110 <find_RR+0x40>
      if(now - p->last_cpu_time > max_proc){
801040ff:	89 da                	mov    %ebx,%edx
80104101:	2b 90 fc 00 00 00    	sub    0xfc(%eax),%edx
80104107:	39 ca                	cmp    %ecx,%edx
80104109:	7e 05                	jle    80104110 <find_RR+0x40>
8010410b:	89 d1                	mov    %edx,%ecx
8010410d:	89 c6                	mov    %eax,%esi
8010410f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104110:	05 04 01 00 00       	add    $0x104,%eax
80104115:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
8010411a:	75 d4                	jne    801040f0 <find_RR+0x20>
}
8010411c:	89 f0                	mov    %esi,%eax
8010411e:	5b                   	pop    %ebx
8010411f:	5e                   	pop    %esi
80104120:	5d                   	pop    %ebp
80104121:	c3                   	ret    
80104122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <find_FCFS>:
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
  int first = 2e9;
80104135:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413a:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010413f:	89 e5                	mov    %esp,%ebp
80104141:	53                   	push   %ebx
  struct proc *first_proc = 0;
80104142:	31 db                	xor    %ebx,%ebx
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (p->state != RUNNABLE || p->queue != 2)
80104148:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010414c:	75 1a                	jne    80104168 <find_FCFS+0x38>
8010414e:	83 b8 e0 00 00 00 02 	cmpl   $0x2,0xe0(%eax)
80104155:	75 11                	jne    80104168 <find_FCFS+0x38>
      if (p->creation_time < first)
80104157:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
8010415d:	39 ca                	cmp    %ecx,%edx
8010415f:	73 07                	jae    80104168 <find_FCFS+0x38>
        first = p->creation_time;
80104161:	89 d1                	mov    %edx,%ecx
80104163:	89 c3                	mov    %eax,%ebx
80104165:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104168:	05 04 01 00 00       	add    $0x104,%eax
8010416d:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104172:	75 d4                	jne    80104148 <find_FCFS+0x18>
}
80104174:	89 d8                	mov    %ebx,%eax
80104176:	5b                   	pop    %ebx
80104177:	5d                   	pop    %ebp
80104178:	c3                   	ret    
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104180 <find_BJF>:
{
80104180:	f3 0f 1e fb          	endbr32 
80104184:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104185:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010418a:	89 e5                	mov    %esp,%ebp
8010418c:	56                   	push   %esi
  struct proc* min_proc = 0;
8010418d:	31 f6                	xor    %esi,%esi
{
8010418f:	53                   	push   %ebx
  int min_rank = 1000000;
80104190:	bb 40 42 0f 00       	mov    $0xf4240,%ebx
{
80104195:	83 ec 10             	sub    $0x10,%esp
80104198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419f:	90                   	nop
    if (p->state != RUNNABLE || p->queue != 3)
801041a0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801041a4:	75 6a                	jne    80104210 <find_BJF+0x90>
801041a6:	83 b8 e0 00 00 00 03 	cmpl   $0x3,0xe0(%eax)
801041ad:	75 61                	jne    80104210 <find_BJF+0x90>
  int rank = p->priority * p->priority_ratio
801041af:	8b 90 ec 00 00 00    	mov    0xec(%eax),%edx
801041b5:	8b 88 e8 00 00 00    	mov    0xe8(%eax),%ecx
             + p->exec_cycle * p->exec_cycle_ratio;
801041bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int rank = p->priority * p->priority_ratio
801041c2:	0f af ca             	imul   %edx,%ecx
             + p->creation_time * p->arrival_time_ratio
801041c5:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
801041cb:	0f af 90 f0 00 00 00 	imul   0xf0(%eax),%edx
801041d2:	01 ca                	add    %ecx,%edx
             + p->exec_cycle * p->exec_cycle_ratio;
801041d4:	89 55 e8             	mov    %edx,-0x18(%ebp)
801041d7:	df 6d e8             	fildll -0x18(%ebp)
801041da:	db 80 f8 00 00 00    	fildl  0xf8(%eax)
801041e0:	d8 88 f4 00 00 00    	fmuls  0xf4(%eax)
  int rank = p->priority * p->priority_ratio
801041e6:	d9 7d f6             	fnstcw -0xa(%ebp)
801041e9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
             + p->exec_cycle * p->exec_cycle_ratio;
801041ed:	de c1                	faddp  %st,%st(1)
  int rank = p->priority * p->priority_ratio
801041ef:	80 ce 0c             	or     $0xc,%dh
801041f2:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
801041f6:	d9 6d f4             	fldcw  -0xc(%ebp)
801041f9:	db 5d e8             	fistpl -0x18(%ebp)
801041fc:	d9 6d f6             	fldcw  -0xa(%ebp)
801041ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
    if (get_rank(p) < min_rank){
80104202:	39 da                	cmp    %ebx,%edx
80104204:	7d 0a                	jge    80104210 <find_BJF+0x90>
80104206:	89 d3                	mov    %edx,%ebx
80104208:	89 c6                	mov    %eax,%esi
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104210:	05 04 01 00 00       	add    $0x104,%eax
80104215:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
8010421a:	75 84                	jne    801041a0 <find_BJF+0x20>
}
8010421c:	83 c4 10             	add    $0x10,%esp
8010421f:	89 f0                	mov    %esi,%eax
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5d                   	pop    %ebp
80104224:	c3                   	ret    
80104225:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104230 <move_queues>:
{
80104230:	f3 0f 1e fb          	endbr32 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104234:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104239:	eb 11                	jmp    8010424c <move_queues+0x1c>
8010423b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010423f:	90                   	nop
80104240:	05 04 01 00 00       	add    $0x104,%eax
80104245:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
8010424a:	74 3b                	je     80104287 <move_queues+0x57>
    if (p->state == RUNNABLE && p->age > 8000){
8010424c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104250:	75 ee                	jne    80104240 <move_queues+0x10>
80104252:	81 b8 00 01 00 00 40 	cmpl   $0x1f40,0x100(%eax)
80104259:	1f 00 00 
8010425c:	7e e2                	jle    80104240 <move_queues+0x10>
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
8010425e:	8b 90 e0 00 00 00    	mov    0xe0(%eax),%edx
80104264:	31 c9                	xor    %ecx,%ecx
      p->age = 0;
80104266:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
8010426d:	00 00 00 
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
80104270:	83 fa 01             	cmp    $0x1,%edx
80104273:	0f 95 c1             	setne  %cl
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104276:	05 04 01 00 00       	add    $0x104,%eax
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
8010427b:	29 ca                	sub    %ecx,%edx
8010427d:	89 50 dc             	mov    %edx,-0x24(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104280:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104285:	75 c5                	jne    8010424c <move_queues+0x1c>
}
80104287:	c3                   	ret    
80104288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428f:	90                   	nop

80104290 <update_age>:
{
80104290:	f3 0f 1e fb          	endbr32 
80104294:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104295:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010429a:	89 e5                	mov    %esp,%ebp
8010429c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010429f:	90                   	nop
    if (p->state == RUNNABLE){
801042a0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801042a4:	75 06                	jne    801042ac <update_age+0x1c>
      p->age += cycles;
801042a6:	01 90 00 01 00 00    	add    %edx,0x100(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801042ac:	05 04 01 00 00       	add    $0x104,%eax
801042b1:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
801042b6:	75 e8                	jne    801042a0 <update_age+0x10>
  p_exec->age = 0;
801042b8:	8b 45 08             	mov    0x8(%ebp),%eax
801042bb:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
801042c2:	00 00 00 
}
801042c5:	5d                   	pop    %ebp
801042c6:	c3                   	ret    
801042c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ce:	66 90                	xchg   %ax,%ax

801042d0 <scheduler>:
{
801042d0:	f3 0f 1e fb          	endbr32 
801042d4:	55                   	push   %ebp
801042d5:	89 e5                	mov    %esp,%ebp
801042d7:	57                   	push   %edi
801042d8:	56                   	push   %esi
801042d9:	53                   	push   %ebx
801042da:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801042dd:	e8 ce f6 ff ff       	call   801039b0 <mycpu>
  c->proc = 0;
801042e2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042e9:	00 00 00 
  struct cpu *c = mycpu();
801042ec:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801042ee:	8d 40 04             	lea    0x4(%eax),%eax
801042f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801042f8:	fb                   	sti    
    acquire(&ptable.lock);
801042f9:	83 ec 0c             	sub    $0xc,%esp
  struct proc *best = 0;
801042fc:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
801042fe:	68 20 3d 11 80       	push   $0x80113d20
80104303:	e8 98 0d 00 00       	call   801050a0 <acquire>
    tick1 = ticks;
80104308:	8b 35 a0 86 11 80    	mov    0x801186a0,%esi
  int now = ticks;
8010430e:	83 c4 10             	add    $0x10,%esp
  int max_proc = -100000;
80104311:	b9 60 79 fe ff       	mov    $0xfffe7960,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104316:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010431b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010431f:	90                   	nop
      if(p->state != RUNNABLE || p->queue != 1)
80104320:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104324:	75 1a                	jne    80104340 <scheduler+0x70>
80104326:	83 ba e0 00 00 00 01 	cmpl   $0x1,0xe0(%edx)
8010432d:	75 11                	jne    80104340 <scheduler+0x70>
      if(now - p->last_cpu_time > max_proc){
8010432f:	89 f0                	mov    %esi,%eax
80104331:	2b 82 fc 00 00 00    	sub    0xfc(%edx),%eax
80104337:	39 c8                	cmp    %ecx,%eax
80104339:	7e 05                	jle    80104340 <scheduler+0x70>
8010433b:	89 c1                	mov    %eax,%ecx
8010433d:	89 d7                	mov    %edx,%edi
8010433f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104340:	81 c2 04 01 00 00    	add    $0x104,%edx
80104346:	81 fa 54 7e 11 80    	cmp    $0x80117e54,%edx
8010434c:	75 d2                	jne    80104320 <scheduler+0x50>
    if (p == 0)
8010434e:	85 ff                	test   %edi,%edi
80104350:	0f 84 d5 00 00 00    	je     8010442b <scheduler+0x15b>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104356:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010435b:	eb 11                	jmp    8010436e <scheduler+0x9e>
8010435d:	8d 76 00             	lea    0x0(%esi),%esi
80104360:	81 c2 04 01 00 00    	add    $0x104,%edx
80104366:	81 fa 54 7e 11 80    	cmp    $0x80117e54,%edx
8010436c:	74 3d                	je     801043ab <scheduler+0xdb>
    if (p->state == RUNNABLE && p->age > 8000){
8010436e:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80104372:	75 ec                	jne    80104360 <scheduler+0x90>
80104374:	81 ba 00 01 00 00 40 	cmpl   $0x1f40,0x100(%edx)
8010437b:	1f 00 00 
8010437e:	7e e0                	jle    80104360 <scheduler+0x90>
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
80104380:	8b 82 e0 00 00 00    	mov    0xe0(%edx),%eax
80104386:	31 c9                	xor    %ecx,%ecx
      p->age = 0;
80104388:	c7 82 00 01 00 00 00 	movl   $0x0,0x100(%edx)
8010438f:	00 00 00 
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
80104392:	83 f8 01             	cmp    $0x1,%eax
80104395:	0f 95 c1             	setne  %cl
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104398:	81 c2 04 01 00 00    	add    $0x104,%edx
      p->queue = (p->queue == 1) ? 1 : (p->queue-1);
8010439e:	29 c8                	sub    %ecx,%eax
801043a0:	89 42 dc             	mov    %eax,-0x24(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801043a3:	81 fa 54 7e 11 80    	cmp    $0x80117e54,%edx
801043a9:	75 c3                	jne    8010436e <scheduler+0x9e>
    switchuvm(p);
801043ab:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
801043ae:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
    switchuvm(p);
801043b4:	57                   	push   %edi
801043b5:	e8 36 33 00 00       	call   801076f0 <switchuvm>
    p->state = RUNNING;
801043ba:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
    swtch(&(c->scheduler), p->context);
801043c1:	58                   	pop    %eax
801043c2:	5a                   	pop    %edx
801043c3:	ff 77 1c             	pushl  0x1c(%edi)
801043c6:	ff 75 e4             	pushl  -0x1c(%ebp)
801043c9:	e8 05 10 00 00       	call   801053d3 <swtch>
    switchkvm();
801043ce:	e8 fd 32 00 00       	call   801076d0 <switchkvm>
    update_age(p, tick2-tick1);
801043d3:	a1 a0 86 11 80       	mov    0x801186a0,%eax
801043d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801043db:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
    update_age(p, tick2-tick1);
801043e0:	29 f0                	sub    %esi,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801043e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state == RUNNABLE){
801043e8:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801043ec:	75 06                	jne    801043f4 <scheduler+0x124>
      p->age += cycles;
801043ee:	01 82 00 01 00 00    	add    %eax,0x100(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801043f4:	81 c2 04 01 00 00    	add    $0x104,%edx
801043fa:	81 fa 54 7e 11 80    	cmp    $0x80117e54,%edx
80104400:	75 e6                	jne    801043e8 <scheduler+0x118>
  p_exec->age = 0;
80104402:	c7 87 00 01 00 00 00 	movl   $0x0,0x100(%edi)
80104409:	00 00 00 
    c->proc = 0;
8010440c:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104413:	00 00 00 
    release(&ptable.lock);
80104416:	83 ec 0c             	sub    $0xc,%esp
80104419:	68 20 3d 11 80       	push   $0x80113d20
8010441e:	e8 3d 0d 00 00       	call   80105160 <release>
80104423:	83 c4 10             	add    $0x10,%esp
80104426:	e9 cd fe ff ff       	jmp    801042f8 <scheduler+0x28>
  int first = 2e9;
8010442b:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104430:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104435:	8d 76 00             	lea    0x0(%esi),%esi
      if (p->state != RUNNABLE || p->queue != 2)
80104438:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010443c:	75 1a                	jne    80104458 <scheduler+0x188>
8010443e:	83 b8 e0 00 00 00 02 	cmpl   $0x2,0xe0(%eax)
80104445:	75 11                	jne    80104458 <scheduler+0x188>
      if (p->creation_time < first)
80104447:	8b 90 e4 00 00 00    	mov    0xe4(%eax),%edx
8010444d:	39 ca                	cmp    %ecx,%edx
8010444f:	73 07                	jae    80104458 <scheduler+0x188>
        first = p->creation_time;
80104451:	89 d1                	mov    %edx,%ecx
80104453:	89 c7                	mov    %eax,%edi
80104455:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104458:	05 04 01 00 00       	add    $0x104,%eax
8010445d:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104462:	75 d4                	jne    80104438 <scheduler+0x168>
    if (p == 0)
80104464:	85 ff                	test   %edi,%edi
80104466:	0f 85 ea fe ff ff    	jne    80104356 <scheduler+0x86>
      p = find_BJF();
8010446c:	e8 0f fd ff ff       	call   80104180 <find_BJF>
80104471:	89 c7                	mov    %eax,%edi
    if (p == 0) {
80104473:	85 c0                	test   %eax,%eax
80104475:	74 9f                	je     80104416 <scheduler+0x146>
80104477:	e9 da fe ff ff       	jmp    80104356 <scheduler+0x86>
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <sched>:
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	56                   	push   %esi
80104488:	53                   	push   %ebx
  pushcli();
80104489:	e8 12 0b 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
8010448e:	e8 1d f5 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104493:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104499:	e8 52 0b 00 00       	call   80104ff0 <popcli>
  if(!holding(&ptable.lock))
8010449e:	83 ec 0c             	sub    $0xc,%esp
801044a1:	68 20 3d 11 80       	push   $0x80113d20
801044a6:	e8 a5 0b 00 00       	call   80105050 <holding>
801044ab:	83 c4 10             	add    $0x10,%esp
801044ae:	85 c0                	test   %eax,%eax
801044b0:	74 4f                	je     80104501 <sched+0x81>
  if(mycpu()->ncli != 1)
801044b2:	e8 f9 f4 ff ff       	call   801039b0 <mycpu>
801044b7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801044be:	75 68                	jne    80104528 <sched+0xa8>
  if(p->state == RUNNING)
801044c0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801044c4:	74 55                	je     8010451b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044c6:	9c                   	pushf  
801044c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044c8:	f6 c4 02             	test   $0x2,%ah
801044cb:	75 41                	jne    8010450e <sched+0x8e>
  intena = mycpu()->intena;
801044cd:	e8 de f4 ff ff       	call   801039b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801044d2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801044d5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801044db:	e8 d0 f4 ff ff       	call   801039b0 <mycpu>
801044e0:	83 ec 08             	sub    $0x8,%esp
801044e3:	ff 70 04             	pushl  0x4(%eax)
801044e6:	53                   	push   %ebx
801044e7:	e8 e7 0e 00 00       	call   801053d3 <swtch>
  mycpu()->intena = intena;
801044ec:	e8 bf f4 ff ff       	call   801039b0 <mycpu>
}
801044f1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801044f4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801044fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044fd:	5b                   	pop    %ebx
801044fe:	5e                   	pop    %esi
801044ff:	5d                   	pop    %ebp
80104500:	c3                   	ret    
    panic("sched ptable.lock");
80104501:	83 ec 0c             	sub    $0xc,%esp
80104504:	68 8f 83 10 80       	push   $0x8010838f
80104509:	e8 82 be ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010450e:	83 ec 0c             	sub    $0xc,%esp
80104511:	68 bb 83 10 80       	push   $0x801083bb
80104516:	e8 75 be ff ff       	call   80100390 <panic>
    panic("sched running");
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	68 ad 83 10 80       	push   $0x801083ad
80104523:	e8 68 be ff ff       	call   80100390 <panic>
    panic("sched locks");
80104528:	83 ec 0c             	sub    $0xc,%esp
8010452b:	68 a1 83 10 80       	push   $0x801083a1
80104530:	e8 5b be ff ff       	call   80100390 <panic>
80104535:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <exit>:
{
80104540:	f3 0f 1e fb          	endbr32 
80104544:	55                   	push   %ebp
80104545:	89 e5                	mov    %esp,%ebp
80104547:	57                   	push   %edi
80104548:	56                   	push   %esi
80104549:	53                   	push   %ebx
8010454a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010454d:	e8 4e 0a 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
80104552:	e8 59 f4 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104557:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010455d:	e8 8e 0a 00 00       	call   80104ff0 <popcli>
  if(curproc == initproc)
80104562:	8d 5e 28             	lea    0x28(%esi),%ebx
80104565:	8d 7e 68             	lea    0x68(%esi),%edi
80104568:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010456e:	0f 84 fd 00 00 00    	je     80104671 <exit+0x131>
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104578:	8b 03                	mov    (%ebx),%eax
8010457a:	85 c0                	test   %eax,%eax
8010457c:	74 12                	je     80104590 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010457e:	83 ec 0c             	sub    $0xc,%esp
80104581:	50                   	push   %eax
80104582:	e8 39 c9 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104587:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010458d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104590:	83 c3 04             	add    $0x4,%ebx
80104593:	39 df                	cmp    %ebx,%edi
80104595:	75 e1                	jne    80104578 <exit+0x38>
  begin_op();
80104597:	e8 94 e7 ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
8010459c:	83 ec 0c             	sub    $0xc,%esp
8010459f:	ff 76 68             	pushl  0x68(%esi)
801045a2:	e8 e9 d2 ff ff       	call   80101890 <iput>
  end_op();
801045a7:	e8 f4 e7 ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
801045ac:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801045b3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801045ba:	e8 e1 0a 00 00       	call   801050a0 <acquire>
  wakeup1(curproc->parent);
801045bf:	8b 56 14             	mov    0x14(%esi),%edx
801045c2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045c5:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801045ca:	eb 10                	jmp    801045dc <exit+0x9c>
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d0:	05 04 01 00 00       	add    $0x104,%eax
801045d5:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
801045da:	74 1e                	je     801045fa <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
801045dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045e0:	75 ee                	jne    801045d0 <exit+0x90>
801045e2:	3b 50 20             	cmp    0x20(%eax),%edx
801045e5:	75 e9                	jne    801045d0 <exit+0x90>
      p->state = RUNNABLE;
801045e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045ee:	05 04 01 00 00       	add    $0x104,%eax
801045f3:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
801045f8:	75 e2                	jne    801045dc <exit+0x9c>
      p->parent = initproc;
801045fa:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104600:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104605:	eb 17                	jmp    8010461e <exit+0xde>
80104607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460e:	66 90                	xchg   %ax,%ax
80104610:	81 c2 04 01 00 00    	add    $0x104,%edx
80104616:	81 fa 54 7e 11 80    	cmp    $0x80117e54,%edx
8010461c:	74 3a                	je     80104658 <exit+0x118>
    if(p->parent == curproc){
8010461e:	39 72 14             	cmp    %esi,0x14(%edx)
80104621:	75 ed                	jne    80104610 <exit+0xd0>
      if(p->state == ZOMBIE)
80104623:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104627:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010462a:	75 e4                	jne    80104610 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010462c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104631:	eb 11                	jmp    80104644 <exit+0x104>
80104633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104637:	90                   	nop
80104638:	05 04 01 00 00       	add    $0x104,%eax
8010463d:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104642:	74 cc                	je     80104610 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104644:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104648:	75 ee                	jne    80104638 <exit+0xf8>
8010464a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010464d:	75 e9                	jne    80104638 <exit+0xf8>
      p->state = RUNNABLE;
8010464f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104656:	eb e0                	jmp    80104638 <exit+0xf8>
  curproc->state = ZOMBIE;
80104658:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010465f:	e8 1c fe ff ff       	call   80104480 <sched>
  panic("zombie exit");
80104664:	83 ec 0c             	sub    $0xc,%esp
80104667:	68 dc 83 10 80       	push   $0x801083dc
8010466c:	e8 1f bd ff ff       	call   80100390 <panic>
    panic("init exiting");
80104671:	83 ec 0c             	sub    $0xc,%esp
80104674:	68 cf 83 10 80       	push   $0x801083cf
80104679:	e8 12 bd ff ff       	call   80100390 <panic>
8010467e:	66 90                	xchg   %ax,%ax

80104680 <yield>:
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	56                   	push   %esi
80104688:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80104689:	83 ec 0c             	sub    $0xc,%esp
8010468c:	68 20 3d 11 80       	push   $0x80113d20
80104691:	e8 0a 0a 00 00       	call   801050a0 <acquire>
  pushcli();
80104696:	e8 05 09 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
8010469b:	e8 10 f3 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801046a0:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046a6:	e8 45 09 00 00       	call   80104ff0 <popcli>
  myproc()->last_cpu_time = ticks;
801046ab:	8b 35 a0 86 11 80    	mov    0x801186a0,%esi
  myproc()->state = RUNNABLE;
801046b1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
801046b8:	e8 e3 08 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
801046bd:	e8 ee f2 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801046c2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046c8:	e8 23 09 00 00       	call   80104ff0 <popcli>
  myproc()->last_cpu_time = ticks;
801046cd:	89 b3 fc 00 00 00    	mov    %esi,0xfc(%ebx)
  pushcli();
801046d3:	e8 c8 08 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
801046d8:	e8 d3 f2 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801046dd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046e3:	e8 08 09 00 00       	call   80104ff0 <popcli>
  myproc()->exec_cycle += 0.1;
801046e8:	dd 05 68 85 10 80    	fldl   0x80108568
801046ee:	d8 83 f4 00 00 00    	fadds  0xf4(%ebx)
801046f4:	d9 9b f4 00 00 00    	fstps  0xf4(%ebx)
  sched();
801046fa:	e8 81 fd ff ff       	call   80104480 <sched>
  release(&ptable.lock);
801046ff:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104706:	e8 55 0a 00 00       	call   80105160 <release>
}
8010470b:	83 c4 10             	add    $0x10,%esp
8010470e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104711:	5b                   	pop    %ebx
80104712:	5e                   	pop    %esi
80104713:	5d                   	pop    %ebp
80104714:	c3                   	ret    
80104715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <sleep>:
{
80104720:	f3 0f 1e fb          	endbr32 
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
80104727:	57                   	push   %edi
80104728:	56                   	push   %esi
80104729:	53                   	push   %ebx
8010472a:	83 ec 0c             	sub    $0xc,%esp
8010472d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104730:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104733:	e8 68 08 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
80104738:	e8 73 f2 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
8010473d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104743:	e8 a8 08 00 00       	call   80104ff0 <popcli>
  if(p == 0)
80104748:	85 db                	test   %ebx,%ebx
8010474a:	0f 84 83 00 00 00    	je     801047d3 <sleep+0xb3>
  if(lk == 0)
80104750:	85 f6                	test   %esi,%esi
80104752:	74 72                	je     801047c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104754:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010475a:	74 4c                	je     801047a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010475c:	83 ec 0c             	sub    $0xc,%esp
8010475f:	68 20 3d 11 80       	push   $0x80113d20
80104764:	e8 37 09 00 00       	call   801050a0 <acquire>
    release(lk);
80104769:	89 34 24             	mov    %esi,(%esp)
8010476c:	e8 ef 09 00 00       	call   80105160 <release>
  p->chan = chan;
80104771:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104774:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010477b:	e8 00 fd ff ff       	call   80104480 <sched>
  p->chan = 0;
80104780:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104787:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010478e:	e8 cd 09 00 00       	call   80105160 <release>
    acquire(lk);
80104793:	89 75 08             	mov    %esi,0x8(%ebp)
80104796:	83 c4 10             	add    $0x10,%esp
}
80104799:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010479c:	5b                   	pop    %ebx
8010479d:	5e                   	pop    %esi
8010479e:	5f                   	pop    %edi
8010479f:	5d                   	pop    %ebp
    acquire(lk);
801047a0:	e9 fb 08 00 00       	jmp    801050a0 <acquire>
801047a5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801047a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047b2:	e8 c9 fc ff ff       	call   80104480 <sched>
  p->chan = 0;
801047b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801047be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047c1:	5b                   	pop    %ebx
801047c2:	5e                   	pop    %esi
801047c3:	5f                   	pop    %edi
801047c4:	5d                   	pop    %ebp
801047c5:	c3                   	ret    
    panic("sleep without lk");
801047c6:	83 ec 0c             	sub    $0xc,%esp
801047c9:	68 ee 83 10 80       	push   $0x801083ee
801047ce:	e8 bd bb ff ff       	call   80100390 <panic>
    panic("sleep");
801047d3:	83 ec 0c             	sub    $0xc,%esp
801047d6:	68 e8 83 10 80       	push   $0x801083e8
801047db:	e8 b0 bb ff ff       	call   80100390 <panic>

801047e0 <wait>:
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	56                   	push   %esi
801047e8:	53                   	push   %ebx
  pushcli();
801047e9:	e8 b2 07 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
801047ee:	e8 bd f1 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801047f3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047f9:	e8 f2 07 00 00       	call   80104ff0 <popcli>
  acquire(&ptable.lock);
801047fe:	83 ec 0c             	sub    $0xc,%esp
80104801:	68 20 3d 11 80       	push   $0x80113d20
80104806:	e8 95 08 00 00       	call   801050a0 <acquire>
8010480b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010480e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104810:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104815:	eb 17                	jmp    8010482e <wait+0x4e>
80104817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481e:	66 90                	xchg   %ax,%ax
80104820:	81 c3 04 01 00 00    	add    $0x104,%ebx
80104826:	81 fb 54 7e 11 80    	cmp    $0x80117e54,%ebx
8010482c:	74 1e                	je     8010484c <wait+0x6c>
      if(p->parent != curproc)
8010482e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104831:	75 ed                	jne    80104820 <wait+0x40>
      if(p->state == ZOMBIE){
80104833:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104837:	74 37                	je     80104870 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104839:	81 c3 04 01 00 00    	add    $0x104,%ebx
      havekids = 1;
8010483f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104844:	81 fb 54 7e 11 80    	cmp    $0x80117e54,%ebx
8010484a:	75 e2                	jne    8010482e <wait+0x4e>
    if(!havekids || curproc->killed){
8010484c:	85 c0                	test   %eax,%eax
8010484e:	74 76                	je     801048c6 <wait+0xe6>
80104850:	8b 46 24             	mov    0x24(%esi),%eax
80104853:	85 c0                	test   %eax,%eax
80104855:	75 6f                	jne    801048c6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104857:	83 ec 08             	sub    $0x8,%esp
8010485a:	68 20 3d 11 80       	push   $0x80113d20
8010485f:	56                   	push   %esi
80104860:	e8 bb fe ff ff       	call   80104720 <sleep>
    havekids = 0;
80104865:	83 c4 10             	add    $0x10,%esp
80104868:	eb a4                	jmp    8010480e <wait+0x2e>
8010486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104870:	83 ec 0c             	sub    $0xc,%esp
80104873:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104876:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104879:	e8 f2 db ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
8010487e:	5a                   	pop    %edx
8010487f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104882:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104889:	e8 22 32 00 00       	call   80107ab0 <freevm>
        release(&ptable.lock);
8010488e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104895:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010489c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801048a3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801048a7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801048ae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801048b5:	e8 a6 08 00 00       	call   80105160 <release>
        return pid;
801048ba:	83 c4 10             	add    $0x10,%esp
}
801048bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048c0:	89 f0                	mov    %esi,%eax
801048c2:	5b                   	pop    %ebx
801048c3:	5e                   	pop    %esi
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
      release(&ptable.lock);
801048c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801048ce:	68 20 3d 11 80       	push   $0x80113d20
801048d3:	e8 88 08 00 00       	call   80105160 <release>
      return -1;
801048d8:	83 c4 10             	add    $0x10,%esp
801048db:	eb e0                	jmp    801048bd <wait+0xdd>
801048dd:	8d 76 00             	lea    0x0(%esi),%esi

801048e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048e0:	f3 0f 1e fb          	endbr32 
801048e4:	55                   	push   %ebp
801048e5:	89 e5                	mov    %esp,%ebp
801048e7:	53                   	push   %ebx
801048e8:	83 ec 10             	sub    $0x10,%esp
801048eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048ee:	68 20 3d 11 80       	push   $0x80113d20
801048f3:	e8 a8 07 00 00       	call   801050a0 <acquire>
801048f8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048fb:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104900:	eb 12                	jmp    80104914 <wakeup+0x34>
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104908:	05 04 01 00 00       	add    $0x104,%eax
8010490d:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104912:	74 1e                	je     80104932 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104914:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104918:	75 ee                	jne    80104908 <wakeup+0x28>
8010491a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010491d:	75 e9                	jne    80104908 <wakeup+0x28>
      p->state = RUNNABLE;
8010491f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104926:	05 04 01 00 00       	add    $0x104,%eax
8010492b:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104930:	75 e2                	jne    80104914 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104932:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104939:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010493c:	c9                   	leave  
  release(&ptable.lock);
8010493d:	e9 1e 08 00 00       	jmp    80105160 <release>
80104942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104950 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	53                   	push   %ebx
80104958:	83 ec 10             	sub    $0x10,%esp
8010495b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010495e:	68 20 3d 11 80       	push   $0x80113d20
80104963:	e8 38 07 00 00       	call   801050a0 <acquire>
80104968:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010496b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104970:	eb 12                	jmp    80104984 <kill+0x34>
80104972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104978:	05 04 01 00 00       	add    $0x104,%eax
8010497d:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104982:	74 34                	je     801049b8 <kill+0x68>
    if(p->pid == pid){
80104984:	39 58 10             	cmp    %ebx,0x10(%eax)
80104987:	75 ef                	jne    80104978 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104989:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010498d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104994:	75 07                	jne    8010499d <kill+0x4d>
        p->state = RUNNABLE;
80104996:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010499d:	83 ec 0c             	sub    $0xc,%esp
801049a0:	68 20 3d 11 80       	push   $0x80113d20
801049a5:	e8 b6 07 00 00       	call   80105160 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801049aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801049ad:	83 c4 10             	add    $0x10,%esp
801049b0:	31 c0                	xor    %eax,%eax
}
801049b2:	c9                   	leave  
801049b3:	c3                   	ret    
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801049b8:	83 ec 0c             	sub    $0xc,%esp
801049bb:	68 20 3d 11 80       	push   $0x80113d20
801049c0:	e8 9b 07 00 00       	call   80105160 <release>
}
801049c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801049c8:	83 c4 10             	add    $0x10,%esp
801049cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049d0:	c9                   	leave  
801049d1:	c3                   	ret    
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	57                   	push   %edi
801049e8:	56                   	push   %esi
801049e9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801049ec:	53                   	push   %ebx
801049ed:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801049f2:	83 ec 3c             	sub    $0x3c,%esp
801049f5:	eb 2b                	jmp    80104a22 <procdump+0x42>
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a00:	83 ec 0c             	sub    $0xc,%esp
80104a03:	68 22 84 10 80       	push   $0x80108422
80104a08:	e8 a3 bc ff ff       	call   801006b0 <cprintf>
80104a0d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a10:	81 c3 04 01 00 00    	add    $0x104,%ebx
80104a16:	81 fb c0 7e 11 80    	cmp    $0x80117ec0,%ebx
80104a1c:	0f 84 8e 00 00 00    	je     80104ab0 <procdump+0xd0>
    if(p->state == UNUSED)
80104a22:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a25:	85 c0                	test   %eax,%eax
80104a27:	74 e7                	je     80104a10 <procdump+0x30>
      state = "???";
80104a29:	ba ff 83 10 80       	mov    $0x801083ff,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a2e:	83 f8 05             	cmp    $0x5,%eax
80104a31:	77 11                	ja     80104a44 <procdump+0x64>
80104a33:	8b 14 85 44 85 10 80 	mov    -0x7fef7abc(,%eax,4),%edx
      state = "???";
80104a3a:	b8 ff 83 10 80       	mov    $0x801083ff,%eax
80104a3f:	85 d2                	test   %edx,%edx
80104a41:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104a44:	53                   	push   %ebx
80104a45:	52                   	push   %edx
80104a46:	ff 73 a4             	pushl  -0x5c(%ebx)
80104a49:	68 03 84 10 80       	push   $0x80108403
80104a4e:	e8 5d bc ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104a53:	83 c4 10             	add    $0x10,%esp
80104a56:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104a5a:	75 a4                	jne    80104a00 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a5c:	83 ec 08             	sub    $0x8,%esp
80104a5f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a62:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a65:	50                   	push   %eax
80104a66:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a69:	8b 40 0c             	mov    0xc(%eax),%eax
80104a6c:	83 c0 08             	add    $0x8,%eax
80104a6f:	50                   	push   %eax
80104a70:	e8 cb 04 00 00       	call   80104f40 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a75:	83 c4 10             	add    $0x10,%esp
80104a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7f:	90                   	nop
80104a80:	8b 17                	mov    (%edi),%edx
80104a82:	85 d2                	test   %edx,%edx
80104a84:	0f 84 76 ff ff ff    	je     80104a00 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104a8a:	83 ec 08             	sub    $0x8,%esp
80104a8d:	83 c7 04             	add    $0x4,%edi
80104a90:	52                   	push   %edx
80104a91:	68 01 7e 10 80       	push   $0x80107e01
80104a96:	e8 15 bc ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a9b:	83 c4 10             	add    $0x10,%esp
80104a9e:	39 fe                	cmp    %edi,%esi
80104aa0:	75 de                	jne    80104a80 <procdump+0xa0>
80104aa2:	e9 59 ff ff ff       	jmp    80104a00 <procdump+0x20>
80104aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aae:	66 90                	xchg   %ax,%ax
  }
}
80104ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ab3:	5b                   	pop    %ebx
80104ab4:	5e                   	pop    %esi
80104ab5:	5f                   	pop    %edi
80104ab6:	5d                   	pop    %ebp
80104ab7:	c3                   	ret    
80104ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abf:	90                   	nop

80104ac0 <find_next_prime_number>:

int 
find_next_prime_number(int n)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	53                   	push   %ebx
  int is_prime = 0;
  int temp = 1; 
  while(!is_prime){
80104ac8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104acf:	90                   	nop
      n++;
80104ad0:	83 c3 01             	add    $0x1,%ebx
      temp = 1;
      int i;
      for( i=2; i <= n/i; i++){
80104ad3:	83 fb 03             	cmp    $0x3,%ebx
80104ad6:	7e 20                	jle    80104af8 <find_next_prime_number+0x38>
          if( n%i == 0 ){
80104ad8:	f6 c3 01             	test   $0x1,%bl
80104adb:	74 f3                	je     80104ad0 <find_next_prime_number+0x10>
      for( i=2; i <= n/i; i++){
80104add:	b9 02 00 00 00       	mov    $0x2,%ecx
80104ae2:	eb 08                	jmp    80104aec <find_next_prime_number+0x2c>
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if( n%i == 0 ){
80104ae8:	85 d2                	test   %edx,%edx
80104aea:	74 e4                	je     80104ad0 <find_next_prime_number+0x10>
      for( i=2; i <= n/i; i++){
80104aec:	89 d8                	mov    %ebx,%eax
80104aee:	83 c1 01             	add    $0x1,%ecx
80104af1:	99                   	cltd   
80104af2:	f7 f9                	idiv   %ecx
80104af4:	39 c8                	cmp    %ecx,%eax
80104af6:	7d f0                	jge    80104ae8 <find_next_prime_number+0x28>
          } 
      }
      if(temp) is_prime = 1;
  }
  return n;
}
80104af8:	89 d8                	mov    %ebx,%eax
80104afa:	5b                   	pop    %ebx
80104afb:	5d                   	pop    %ebp
80104afc:	c3                   	ret    
80104afd:	8d 76 00             	lea    0x0(%esi),%esi

80104b00 <get_most_caller>:

int 
get_most_caller(int sys_num)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	57                   	push   %edi
  struct proc *p;
  int pid_max = -1;
  int cnt_max = -1;
80104b08:	bf ff ff ff ff       	mov    $0xffffffff,%edi
{
80104b0d:	56                   	push   %esi
80104b0e:	53                   	push   %ebx
  acquire(&ptable.lock);
  cprintf("Kernel: The list of onging processes:\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0f:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80104b14:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80104b17:	68 20 3d 11 80       	push   $0x80113d20
80104b1c:	e8 7f 05 00 00       	call   801050a0 <acquire>
  cprintf("Kernel: The list of onging processes:\n");
80104b21:	c7 04 24 1c 85 10 80 	movl   $0x8010851c,(%esp)
80104b28:	e8 83 bb ff ff       	call   801006b0 <cprintf>
    int * sys_cnt = p->syscnt;
    int cnt = *(sys_cnt+sys_num-1);
80104b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  int pid_max = -1;
80104b30:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    int cnt = *(sys_cnt+sys_num-1);
80104b37:	83 c4 10             	add    $0x10,%esp
80104b3a:	8d 14 85 fc ff ff ff 	lea    -0x4(,%eax,4),%edx
80104b41:	eb 1f                	jmp    80104b62 <get_most_caller+0x62>
80104b43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b47:	90                   	nop
    if(p->pid !=0)
      cprintf("     pid=%d, name: %s \n",p->pid, p->name);
    if(cnt >= cnt_max){
80104b48:	39 fe                	cmp    %edi,%esi
80104b4a:	7c 08                	jl     80104b54 <get_most_caller+0x54>
      cnt_max = cnt;
      pid_max = p->pid;
80104b4c:	8b 43 10             	mov    0x10(%ebx),%eax
80104b4f:	89 f7                	mov    %esi,%edi
80104b51:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b54:	81 c3 04 01 00 00    	add    $0x104,%ebx
80104b5a:	81 fb 54 7e 11 80    	cmp    $0x80117e54,%ebx
80104b60:	74 2e                	je     80104b90 <get_most_caller+0x90>
    if(p->pid !=0)
80104b62:	8b 43 10             	mov    0x10(%ebx),%eax
    int cnt = *(sys_cnt+sys_num-1);
80104b65:	8b 74 13 7c          	mov    0x7c(%ebx,%edx,1),%esi
    if(p->pid !=0)
80104b69:	85 c0                	test   %eax,%eax
80104b6b:	74 db                	je     80104b48 <get_most_caller+0x48>
      cprintf("     pid=%d, name: %s \n",p->pid, p->name);
80104b6d:	83 ec 04             	sub    $0x4,%esp
80104b70:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
80104b73:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104b76:	51                   	push   %ecx
80104b77:	50                   	push   %eax
80104b78:	68 0c 84 10 80       	push   $0x8010840c
80104b7d:	e8 2e bb ff ff       	call   801006b0 <cprintf>
80104b82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b85:	83 c4 10             	add    $0x10,%esp
80104b88:	eb be                	jmp    80104b48 <get_most_caller+0x48>
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }

  }
  release(&ptable.lock);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	68 20 3d 11 80       	push   $0x80113d20
80104b98:	e8 c3 05 00 00       	call   80105160 <release>
  return pid_max;
}
80104b9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba3:	5b                   	pop    %ebx
80104ba4:	5e                   	pop    %esi
80104ba5:	5f                   	pop    %edi
80104ba6:	5d                   	pop    %ebp
80104ba7:	c3                   	ret    
80104ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop

80104bb0 <set_queue>:

void
set_queue(int pid, int new_queue)
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	56                   	push   %esi
80104bb8:	53                   	push   %ebx
80104bb9:	8b 75 0c             	mov    0xc(%ebp),%esi
80104bbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  acquire(&ptable.lock);
80104bbf:	83 ec 0c             	sub    $0xc,%esp
80104bc2:	68 20 3d 11 80       	push   $0x80113d20
80104bc7:	e8 d4 04 00 00       	call   801050a0 <acquire>
80104bcc:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bcf:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->pid == pid)
80104bd8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bdb:	75 06                	jne    80104be3 <set_queue+0x33>
      p->queue = new_queue;
80104bdd:	89 b0 e0 00 00 00    	mov    %esi,0xe0(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104be3:	05 04 01 00 00       	add    $0x104,%eax
80104be8:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104bed:	75 e9                	jne    80104bd8 <set_queue+0x28>
  }
  release(&ptable.lock);
80104bef:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104bf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5d                   	pop    %ebp
  release(&ptable.lock);
80104bfc:	e9 5f 05 00 00       	jmp    80105160 <release>
80104c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c0f:	90                   	nop

80104c10 <set_global_bjf_params>:

void 
set_global_bjf_params(int p_ratio, int a_ratio, int e_ratio)
{
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
80104c17:	57                   	push   %edi
80104c18:	56                   	push   %esi
80104c19:	53                   	push   %ebx
80104c1a:	83 ec 18             	sub    $0x18,%esp
80104c1d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104c20:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p;
  acquire(&ptable.lock);
80104c23:	68 20 3d 11 80       	push   $0x80113d20
{
80104c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  acquire(&ptable.lock);
80104c2b:	e8 70 04 00 00       	call   801050a0 <acquire>
80104c30:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c33:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop
    p->arrival_time_ratio = a_ratio;
80104c40:	89 b0 f0 00 00 00    	mov    %esi,0xf0(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c46:	05 04 01 00 00       	add    $0x104,%eax
    p->exec_cycle_ratio = e_ratio;
80104c4b:	89 58 f4             	mov    %ebx,-0xc(%eax)
    p->priority_ratio = p_ratio;
80104c4e:	89 78 e8             	mov    %edi,-0x18(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c51:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104c56:	75 e8                	jne    80104c40 <set_global_bjf_params+0x30>
  }
  release(&ptable.lock);
80104c58:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c62:	5b                   	pop    %ebx
80104c63:	5e                   	pop    %esi
80104c64:	5f                   	pop    %edi
80104c65:	5d                   	pop    %ebp
  release(&ptable.lock);
80104c66:	e9 f5 04 00 00       	jmp    80105160 <release>
80104c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop

80104c70 <set_bjf_params>:

void 
set_bjf_params(int pid, int p_ratio, int a_ratio, int e_ratio)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	57                   	push   %edi
80104c78:	56                   	push   %esi
80104c79:	53                   	push   %ebx
80104c7a:	83 ec 28             	sub    $0x28,%esp
80104c7d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c80:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c83:	8b 7d 10             	mov    0x10(%ebp),%edi
80104c86:	8b 75 14             	mov    0x14(%ebp),%esi
  struct proc *p;
  acquire(&ptable.lock);
80104c89:	68 20 3d 11 80       	push   $0x80113d20
{
80104c8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&ptable.lock);
80104c91:	e8 0a 04 00 00       	call   801050a0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&ptable.lock);
80104c99:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c9c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->pid == pid){
80104ca8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104cab:	75 12                	jne    80104cbf <set_bjf_params+0x4f>
      p->arrival_time_ratio = a_ratio;
80104cad:	89 b8 f0 00 00 00    	mov    %edi,0xf0(%eax)
      p->exec_cycle_ratio = e_ratio;
80104cb3:	89 b0 f8 00 00 00    	mov    %esi,0xf8(%eax)
      p->priority_ratio = p_ratio;
80104cb9:	89 90 ec 00 00 00    	mov    %edx,0xec(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cbf:	05 04 01 00 00       	add    $0x104,%eax
80104cc4:	3d 54 7e 11 80       	cmp    $0x80117e54,%eax
80104cc9:	75 dd                	jne    80104ca8 <set_bjf_params+0x38>
    }
  }
  release(&ptable.lock);
80104ccb:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cd5:	5b                   	pop    %ebx
80104cd6:	5e                   	pop    %esi
80104cd7:	5f                   	pop    %edi
80104cd8:	5d                   	pop    %ebp
  release(&ptable.lock);
80104cd9:	e9 82 04 00 00       	jmp    80105160 <release>
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <wait_for_process>:


int
wait_for_process(int proc_pid)
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	57                   	push   %edi
80104ce8:	56                   	push   %esi
80104ce9:	53                   	push   %ebx
80104cea:	83 ec 0c             	sub    $0xc,%esp
80104ced:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104cf0:	e8 ab 02 00 00       	call   80104fa0 <pushcli>
  c = mycpu();
80104cf5:	e8 b6 ec ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104cfa:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104d00:	e8 eb 02 00 00       	call   80104ff0 <popcli>
  struct proc *p;
  struct proc *curproc = myproc();
  int exist=0;
  acquire(&ptable.lock);
80104d05:	83 ec 0c             	sub    $0xc,%esp
80104d08:	68 20 3d 11 80       	push   $0x80113d20
80104d0d:	e8 8e 03 00 00       	call   801050a0 <acquire>
80104d12:	83 c4 10             	add    $0x10,%esp
  for(;;){
    exist=0;
80104d15:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d17:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104d1c:	eb 10                	jmp    80104d2e <wait_for_process+0x4e>
80104d1e:	66 90                	xchg   %ax,%ax
80104d20:	81 c3 04 01 00 00    	add    $0x104,%ebx
80104d26:	81 fb 54 7e 11 80    	cmp    $0x80117e54,%ebx
80104d2c:	74 1e                	je     80104d4c <wait_for_process+0x6c>
      if(p->pid == proc_pid)
80104d2e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104d31:	75 ed                	jne    80104d20 <wait_for_process+0x40>
        exist = 1;
      if(p->state == ZOMBIE && p->pid == proc_pid){
80104d33:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104d37:	74 37                	je     80104d70 <wait_for_process+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d39:	81 c3 04 01 00 00    	add    $0x104,%ebx
        exist = 1;
80104d3f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d44:	81 fb 54 7e 11 80    	cmp    $0x80117e54,%ebx
80104d4a:	75 e2                	jne    80104d2e <wait_for_process+0x4e>
        p->state = UNUSED;
        release(&ptable.lock);
        return proc_pid;
      }
    }
    if(!exist || curproc->killed){
80104d4c:	85 c0                	test   %eax,%eax
80104d4e:	74 74                	je     80104dc4 <wait_for_process+0xe4>
80104d50:	8b 47 24             	mov    0x24(%edi),%eax
80104d53:	85 c0                	test   %eax,%eax
80104d55:	75 6d                	jne    80104dc4 <wait_for_process+0xe4>
      release(&ptable.lock);
      return -1;
    }

    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104d57:	83 ec 08             	sub    $0x8,%esp
80104d5a:	68 20 3d 11 80       	push   $0x80113d20
80104d5f:	57                   	push   %edi
80104d60:	e8 bb f9 ff ff       	call   80104720 <sleep>
    exist=0;
80104d65:	83 c4 10             	add    $0x10,%esp
80104d68:	eb ab                	jmp    80104d15 <wait_for_process+0x35>
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	ff 73 08             	pushl  0x8(%ebx)
80104d76:	e8 f5 d6 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
80104d7b:	5a                   	pop    %edx
80104d7c:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104d7f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104d86:	e8 25 2d 00 00       	call   80107ab0 <freevm>
        release(&ptable.lock);
80104d8b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104d92:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104d99:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104da0:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104da4:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104dab:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104db2:	e8 a9 03 00 00       	call   80105160 <release>
        return proc_pid;
80104db7:	83 c4 10             	add    $0x10,%esp
80104dba:	89 f0                	mov    %esi,%eax
  }
80104dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dbf:	5b                   	pop    %ebx
80104dc0:	5e                   	pop    %esi
80104dc1:	5f                   	pop    %edi
80104dc2:	5d                   	pop    %ebp
80104dc3:	c3                   	ret    
      release(&ptable.lock);
80104dc4:	83 ec 0c             	sub    $0xc,%esp
80104dc7:	68 20 3d 11 80       	push   $0x80113d20
80104dcc:	e8 8f 03 00 00       	call   80105160 <release>
      return -1;
80104dd1:	83 c4 10             	add    $0x10,%esp
80104dd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd9:	eb e1                	jmp    80104dbc <wait_for_process+0xdc>
80104ddb:	66 90                	xchg   %ax,%ax
80104ddd:	66 90                	xchg   %ax,%ax
80104ddf:	90                   	nop

80104de0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	53                   	push   %ebx
80104de8:	83 ec 0c             	sub    $0xc,%esp
80104deb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104dee:	68 70 85 10 80       	push   $0x80108570
80104df3:	8d 43 04             	lea    0x4(%ebx),%eax
80104df6:	50                   	push   %eax
80104df7:	e8 24 01 00 00       	call   80104f20 <initlock>
  lk->name = name;
80104dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104dff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104e05:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104e08:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104e0f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104e12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e15:	c9                   	leave  
80104e16:	c3                   	ret    
80104e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	56                   	push   %esi
80104e28:	53                   	push   %ebx
80104e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e2c:	8d 73 04             	lea    0x4(%ebx),%esi
80104e2f:	83 ec 0c             	sub    $0xc,%esp
80104e32:	56                   	push   %esi
80104e33:	e8 68 02 00 00       	call   801050a0 <acquire>
  while (lk->locked) {
80104e38:	8b 13                	mov    (%ebx),%edx
80104e3a:	83 c4 10             	add    $0x10,%esp
80104e3d:	85 d2                	test   %edx,%edx
80104e3f:	74 1a                	je     80104e5b <acquiresleep+0x3b>
80104e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104e48:	83 ec 08             	sub    $0x8,%esp
80104e4b:	56                   	push   %esi
80104e4c:	53                   	push   %ebx
80104e4d:	e8 ce f8 ff ff       	call   80104720 <sleep>
  while (lk->locked) {
80104e52:	8b 03                	mov    (%ebx),%eax
80104e54:	83 c4 10             	add    $0x10,%esp
80104e57:	85 c0                	test   %eax,%eax
80104e59:	75 ed                	jne    80104e48 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104e5b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104e61:	e8 da eb ff ff       	call   80103a40 <myproc>
80104e66:	8b 40 10             	mov    0x10(%eax),%eax
80104e69:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104e6c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104e6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e72:	5b                   	pop    %ebx
80104e73:	5e                   	pop    %esi
80104e74:	5d                   	pop    %ebp
  release(&lk->lk);
80104e75:	e9 e6 02 00 00       	jmp    80105160 <release>
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	56                   	push   %esi
80104e88:	53                   	push   %ebx
80104e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e8c:	8d 73 04             	lea    0x4(%ebx),%esi
80104e8f:	83 ec 0c             	sub    $0xc,%esp
80104e92:	56                   	push   %esi
80104e93:	e8 08 02 00 00       	call   801050a0 <acquire>
  lk->locked = 0;
80104e98:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104e9e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ea5:	89 1c 24             	mov    %ebx,(%esp)
80104ea8:	e8 33 fa ff ff       	call   801048e0 <wakeup>
  release(&lk->lk);
80104ead:	89 75 08             	mov    %esi,0x8(%ebp)
80104eb0:	83 c4 10             	add    $0x10,%esp
}
80104eb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb6:	5b                   	pop    %ebx
80104eb7:	5e                   	pop    %esi
80104eb8:	5d                   	pop    %ebp
  release(&lk->lk);
80104eb9:	e9 a2 02 00 00       	jmp    80105160 <release>
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104ec0:	f3 0f 1e fb          	endbr32 
80104ec4:	55                   	push   %ebp
80104ec5:	89 e5                	mov    %esp,%ebp
80104ec7:	57                   	push   %edi
80104ec8:	31 ff                	xor    %edi,%edi
80104eca:	56                   	push   %esi
80104ecb:	53                   	push   %ebx
80104ecc:	83 ec 18             	sub    $0x18,%esp
80104ecf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ed2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ed5:	56                   	push   %esi
80104ed6:	e8 c5 01 00 00       	call   801050a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104edb:	8b 03                	mov    (%ebx),%eax
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	75 1c                	jne    80104f00 <holdingsleep+0x40>
  release(&lk->lk);
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	56                   	push   %esi
80104ee8:	e8 73 02 00 00       	call   80105160 <release>
  return r;
}
80104eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef0:	89 f8                	mov    %edi,%eax
80104ef2:	5b                   	pop    %ebx
80104ef3:	5e                   	pop    %esi
80104ef4:	5f                   	pop    %edi
80104ef5:	5d                   	pop    %ebp
80104ef6:	c3                   	ret    
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104f00:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104f03:	e8 38 eb ff ff       	call   80103a40 <myproc>
80104f08:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f0b:	0f 94 c0             	sete   %al
80104f0e:	0f b6 c0             	movzbl %al,%eax
80104f11:	89 c7                	mov    %eax,%edi
80104f13:	eb cf                	jmp    80104ee4 <holdingsleep+0x24>
80104f15:	66 90                	xchg   %ax,%ax
80104f17:	66 90                	xchg   %ax,%ax
80104f19:	66 90                	xchg   %ax,%ax
80104f1b:	66 90                	xchg   %ax,%ax
80104f1d:	66 90                	xchg   %ax,%ax
80104f1f:	90                   	nop

80104f20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104f2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104f33:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104f36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f3d:	5d                   	pop    %ebp
80104f3e:	c3                   	ret    
80104f3f:	90                   	nop

80104f40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f45:	31 d2                	xor    %edx,%edx
{
80104f47:	89 e5                	mov    %esp,%ebp
80104f49:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104f4a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104f50:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f57:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f58:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104f5e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f64:	77 1a                	ja     80104f80 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f66:	8b 58 04             	mov    0x4(%eax),%ebx
80104f69:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104f6c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104f6f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f71:	83 fa 0a             	cmp    $0xa,%edx
80104f74:	75 e2                	jne    80104f58 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104f76:	5b                   	pop    %ebx
80104f77:	5d                   	pop    %ebp
80104f78:	c3                   	ret    
80104f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104f80:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104f83:	8d 51 28             	lea    0x28(%ecx),%edx
80104f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104f90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f96:	83 c0 04             	add    $0x4,%eax
80104f99:	39 d0                	cmp    %edx,%eax
80104f9b:	75 f3                	jne    80104f90 <getcallerpcs+0x50>
}
80104f9d:	5b                   	pop    %ebx
80104f9e:	5d                   	pop    %ebp
80104f9f:	c3                   	ret    

80104fa0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	53                   	push   %ebx
80104fa8:	83 ec 04             	sub    $0x4,%esp
80104fab:	9c                   	pushf  
80104fac:	5b                   	pop    %ebx
  asm volatile("cli");
80104fad:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104fae:	e8 fd e9 ff ff       	call   801039b0 <mycpu>
80104fb3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104fb9:	85 c0                	test   %eax,%eax
80104fbb:	74 13                	je     80104fd0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104fbd:	e8 ee e9 ff ff       	call   801039b0 <mycpu>
80104fc2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104fc9:	83 c4 04             	add    $0x4,%esp
80104fcc:	5b                   	pop    %ebx
80104fcd:	5d                   	pop    %ebp
80104fce:	c3                   	ret    
80104fcf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104fd0:	e8 db e9 ff ff       	call   801039b0 <mycpu>
80104fd5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104fdb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104fe1:	eb da                	jmp    80104fbd <pushcli+0x1d>
80104fe3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ff0 <popcli>:

void
popcli(void)
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ffa:	9c                   	pushf  
80104ffb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ffc:	f6 c4 02             	test   $0x2,%ah
80104fff:	75 31                	jne    80105032 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105001:	e8 aa e9 ff ff       	call   801039b0 <mycpu>
80105006:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010500d:	78 30                	js     8010503f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010500f:	e8 9c e9 ff ff       	call   801039b0 <mycpu>
80105014:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010501a:	85 d2                	test   %edx,%edx
8010501c:	74 02                	je     80105020 <popcli+0x30>
    sti();
}
8010501e:	c9                   	leave  
8010501f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105020:	e8 8b e9 ff ff       	call   801039b0 <mycpu>
80105025:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010502b:	85 c0                	test   %eax,%eax
8010502d:	74 ef                	je     8010501e <popcli+0x2e>
  asm volatile("sti");
8010502f:	fb                   	sti    
}
80105030:	c9                   	leave  
80105031:	c3                   	ret    
    panic("popcli - interruptible");
80105032:	83 ec 0c             	sub    $0xc,%esp
80105035:	68 7b 85 10 80       	push   $0x8010857b
8010503a:	e8 51 b3 ff ff       	call   80100390 <panic>
    panic("popcli");
8010503f:	83 ec 0c             	sub    $0xc,%esp
80105042:	68 92 85 10 80       	push   $0x80108592
80105047:	e8 44 b3 ff ff       	call   80100390 <panic>
8010504c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105050 <holding>:
{
80105050:	f3 0f 1e fb          	endbr32 
80105054:	55                   	push   %ebp
80105055:	89 e5                	mov    %esp,%ebp
80105057:	56                   	push   %esi
80105058:	53                   	push   %ebx
80105059:	8b 75 08             	mov    0x8(%ebp),%esi
8010505c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010505e:	e8 3d ff ff ff       	call   80104fa0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105063:	8b 06                	mov    (%esi),%eax
80105065:	85 c0                	test   %eax,%eax
80105067:	75 0f                	jne    80105078 <holding+0x28>
  popcli();
80105069:	e8 82 ff ff ff       	call   80104ff0 <popcli>
}
8010506e:	89 d8                	mov    %ebx,%eax
80105070:	5b                   	pop    %ebx
80105071:	5e                   	pop    %esi
80105072:	5d                   	pop    %ebp
80105073:	c3                   	ret    
80105074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105078:	8b 5e 08             	mov    0x8(%esi),%ebx
8010507b:	e8 30 e9 ff ff       	call   801039b0 <mycpu>
80105080:	39 c3                	cmp    %eax,%ebx
80105082:	0f 94 c3             	sete   %bl
  popcli();
80105085:	e8 66 ff ff ff       	call   80104ff0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010508a:	0f b6 db             	movzbl %bl,%ebx
}
8010508d:	89 d8                	mov    %ebx,%eax
8010508f:	5b                   	pop    %ebx
80105090:	5e                   	pop    %esi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret    
80105093:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050a0 <acquire>:
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
801050a5:	89 e5                	mov    %esp,%ebp
801050a7:	56                   	push   %esi
801050a8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801050a9:	e8 f2 fe ff ff       	call   80104fa0 <pushcli>
  if(holding(lk))
801050ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050b1:	83 ec 0c             	sub    $0xc,%esp
801050b4:	53                   	push   %ebx
801050b5:	e8 96 ff ff ff       	call   80105050 <holding>
801050ba:	83 c4 10             	add    $0x10,%esp
801050bd:	85 c0                	test   %eax,%eax
801050bf:	0f 85 7f 00 00 00    	jne    80105144 <acquire+0xa4>
801050c5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801050c7:	ba 01 00 00 00       	mov    $0x1,%edx
801050cc:	eb 05                	jmp    801050d3 <acquire+0x33>
801050ce:	66 90                	xchg   %ax,%ax
801050d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050d3:	89 d0                	mov    %edx,%eax
801050d5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801050d8:	85 c0                	test   %eax,%eax
801050da:	75 f4                	jne    801050d0 <acquire+0x30>
  __sync_synchronize();
801050dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801050e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050e4:	e8 c7 e8 ff ff       	call   801039b0 <mycpu>
801050e9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801050ec:	89 e8                	mov    %ebp,%eax
801050ee:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050f0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801050f6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801050fc:	77 22                	ja     80105120 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801050fe:	8b 50 04             	mov    0x4(%eax),%edx
80105101:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105105:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105108:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010510a:	83 fe 0a             	cmp    $0xa,%esi
8010510d:	75 e1                	jne    801050f0 <acquire+0x50>
}
8010510f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105112:	5b                   	pop    %ebx
80105113:	5e                   	pop    %esi
80105114:	5d                   	pop    %ebp
80105115:	c3                   	ret    
80105116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105120:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105124:	83 c3 34             	add    $0x34,%ebx
80105127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105130:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105136:	83 c0 04             	add    $0x4,%eax
80105139:	39 d8                	cmp    %ebx,%eax
8010513b:	75 f3                	jne    80105130 <acquire+0x90>
}
8010513d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105140:	5b                   	pop    %ebx
80105141:	5e                   	pop    %esi
80105142:	5d                   	pop    %ebp
80105143:	c3                   	ret    
    panic("acquire");
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	68 99 85 10 80       	push   $0x80108599
8010514c:	e8 3f b2 ff ff       	call   80100390 <panic>
80105151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515f:	90                   	nop

80105160 <release>:
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	53                   	push   %ebx
80105168:	83 ec 10             	sub    $0x10,%esp
8010516b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010516e:	53                   	push   %ebx
8010516f:	e8 dc fe ff ff       	call   80105050 <holding>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	74 22                	je     8010519d <release+0x3d>
  lk->pcs[0] = 0;
8010517b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105182:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105189:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010518e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105197:	c9                   	leave  
  popcli();
80105198:	e9 53 fe ff ff       	jmp    80104ff0 <popcli>
    panic("release");
8010519d:	83 ec 0c             	sub    $0xc,%esp
801051a0:	68 a1 85 10 80       	push   $0x801085a1
801051a5:	e8 e6 b1 ff ff       	call   80100390 <panic>
801051aa:	66 90                	xchg   %ax,%ax
801051ac:	66 90                	xchg   %ax,%ax
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	57                   	push   %edi
801051b8:	8b 55 08             	mov    0x8(%ebp),%edx
801051bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801051be:	53                   	push   %ebx
801051bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801051c2:	89 d7                	mov    %edx,%edi
801051c4:	09 cf                	or     %ecx,%edi
801051c6:	83 e7 03             	and    $0x3,%edi
801051c9:	75 25                	jne    801051f0 <memset+0x40>
    c &= 0xFF;
801051cb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051ce:	c1 e0 18             	shl    $0x18,%eax
801051d1:	89 fb                	mov    %edi,%ebx
801051d3:	c1 e9 02             	shr    $0x2,%ecx
801051d6:	c1 e3 10             	shl    $0x10,%ebx
801051d9:	09 d8                	or     %ebx,%eax
801051db:	09 f8                	or     %edi,%eax
801051dd:	c1 e7 08             	shl    $0x8,%edi
801051e0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801051e2:	89 d7                	mov    %edx,%edi
801051e4:	fc                   	cld    
801051e5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801051e7:	5b                   	pop    %ebx
801051e8:	89 d0                	mov    %edx,%eax
801051ea:	5f                   	pop    %edi
801051eb:	5d                   	pop    %ebp
801051ec:	c3                   	ret    
801051ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801051f0:	89 d7                	mov    %edx,%edi
801051f2:	fc                   	cld    
801051f3:	f3 aa                	rep stos %al,%es:(%edi)
801051f5:	5b                   	pop    %ebx
801051f6:	89 d0                	mov    %edx,%eax
801051f8:	5f                   	pop    %edi
801051f9:	5d                   	pop    %ebp
801051fa:	c3                   	ret    
801051fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051ff:	90                   	nop

80105200 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	56                   	push   %esi
80105208:	8b 75 10             	mov    0x10(%ebp),%esi
8010520b:	8b 55 08             	mov    0x8(%ebp),%edx
8010520e:	53                   	push   %ebx
8010520f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105212:	85 f6                	test   %esi,%esi
80105214:	74 2a                	je     80105240 <memcmp+0x40>
80105216:	01 c6                	add    %eax,%esi
80105218:	eb 10                	jmp    8010522a <memcmp+0x2a>
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105220:	83 c0 01             	add    $0x1,%eax
80105223:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105226:	39 f0                	cmp    %esi,%eax
80105228:	74 16                	je     80105240 <memcmp+0x40>
    if(*s1 != *s2)
8010522a:	0f b6 0a             	movzbl (%edx),%ecx
8010522d:	0f b6 18             	movzbl (%eax),%ebx
80105230:	38 d9                	cmp    %bl,%cl
80105232:	74 ec                	je     80105220 <memcmp+0x20>
      return *s1 - *s2;
80105234:	0f b6 c1             	movzbl %cl,%eax
80105237:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105239:	5b                   	pop    %ebx
8010523a:	5e                   	pop    %esi
8010523b:	5d                   	pop    %ebp
8010523c:	c3                   	ret    
8010523d:	8d 76 00             	lea    0x0(%esi),%esi
80105240:	5b                   	pop    %ebx
  return 0;
80105241:	31 c0                	xor    %eax,%eax
}
80105243:	5e                   	pop    %esi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    
80105246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524d:	8d 76 00             	lea    0x0(%esi),%esi

80105250 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	57                   	push   %edi
80105258:	8b 55 08             	mov    0x8(%ebp),%edx
8010525b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010525e:	56                   	push   %esi
8010525f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105262:	39 d6                	cmp    %edx,%esi
80105264:	73 2a                	jae    80105290 <memmove+0x40>
80105266:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105269:	39 fa                	cmp    %edi,%edx
8010526b:	73 23                	jae    80105290 <memmove+0x40>
8010526d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105270:	85 c9                	test   %ecx,%ecx
80105272:	74 13                	je     80105287 <memmove+0x37>
80105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105278:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010527c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010527f:	83 e8 01             	sub    $0x1,%eax
80105282:	83 f8 ff             	cmp    $0xffffffff,%eax
80105285:	75 f1                	jne    80105278 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105287:	5e                   	pop    %esi
80105288:	89 d0                	mov    %edx,%eax
8010528a:	5f                   	pop    %edi
8010528b:	5d                   	pop    %ebp
8010528c:	c3                   	ret    
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105290:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105293:	89 d7                	mov    %edx,%edi
80105295:	85 c9                	test   %ecx,%ecx
80105297:	74 ee                	je     80105287 <memmove+0x37>
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801052a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801052a1:	39 f0                	cmp    %esi,%eax
801052a3:	75 fb                	jne    801052a0 <memmove+0x50>
}
801052a5:	5e                   	pop    %esi
801052a6:	89 d0                	mov    %edx,%eax
801052a8:	5f                   	pop    %edi
801052a9:	5d                   	pop    %ebp
801052aa:	c3                   	ret    
801052ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052af:	90                   	nop

801052b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052b0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801052b4:	eb 9a                	jmp    80105250 <memmove>
801052b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052bd:	8d 76 00             	lea    0x0(%esi),%esi

801052c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	56                   	push   %esi
801052c8:	8b 75 10             	mov    0x10(%ebp),%esi
801052cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052ce:	53                   	push   %ebx
801052cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801052d2:	85 f6                	test   %esi,%esi
801052d4:	74 32                	je     80105308 <strncmp+0x48>
801052d6:	01 c6                	add    %eax,%esi
801052d8:	eb 14                	jmp    801052ee <strncmp+0x2e>
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052e0:	38 da                	cmp    %bl,%dl
801052e2:	75 14                	jne    801052f8 <strncmp+0x38>
    n--, p++, q++;
801052e4:	83 c0 01             	add    $0x1,%eax
801052e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801052ea:	39 f0                	cmp    %esi,%eax
801052ec:	74 1a                	je     80105308 <strncmp+0x48>
801052ee:	0f b6 11             	movzbl (%ecx),%edx
801052f1:	0f b6 18             	movzbl (%eax),%ebx
801052f4:	84 d2                	test   %dl,%dl
801052f6:	75 e8                	jne    801052e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801052f8:	0f b6 c2             	movzbl %dl,%eax
801052fb:	29 d8                	sub    %ebx,%eax
}
801052fd:	5b                   	pop    %ebx
801052fe:	5e                   	pop    %esi
801052ff:	5d                   	pop    %ebp
80105300:	c3                   	ret    
80105301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105308:	5b                   	pop    %ebx
    return 0;
80105309:	31 c0                	xor    %eax,%eax
}
8010530b:	5e                   	pop    %esi
8010530c:	5d                   	pop    %ebp
8010530d:	c3                   	ret    
8010530e:	66 90                	xchg   %ax,%ax

80105310 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	57                   	push   %edi
80105318:	56                   	push   %esi
80105319:	8b 75 08             	mov    0x8(%ebp),%esi
8010531c:	53                   	push   %ebx
8010531d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105320:	89 f2                	mov    %esi,%edx
80105322:	eb 1b                	jmp    8010533f <strncpy+0x2f>
80105324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105328:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010532c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010532f:	83 c2 01             	add    $0x1,%edx
80105332:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105336:	89 f9                	mov    %edi,%ecx
80105338:	88 4a ff             	mov    %cl,-0x1(%edx)
8010533b:	84 c9                	test   %cl,%cl
8010533d:	74 09                	je     80105348 <strncpy+0x38>
8010533f:	89 c3                	mov    %eax,%ebx
80105341:	83 e8 01             	sub    $0x1,%eax
80105344:	85 db                	test   %ebx,%ebx
80105346:	7f e0                	jg     80105328 <strncpy+0x18>
    ;
  while(n-- > 0)
80105348:	89 d1                	mov    %edx,%ecx
8010534a:	85 c0                	test   %eax,%eax
8010534c:	7e 15                	jle    80105363 <strncpy+0x53>
8010534e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105350:	83 c1 01             	add    $0x1,%ecx
80105353:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105357:	89 c8                	mov    %ecx,%eax
80105359:	f7 d0                	not    %eax
8010535b:	01 d0                	add    %edx,%eax
8010535d:	01 d8                	add    %ebx,%eax
8010535f:	85 c0                	test   %eax,%eax
80105361:	7f ed                	jg     80105350 <strncpy+0x40>
  return os;
}
80105363:	5b                   	pop    %ebx
80105364:	89 f0                	mov    %esi,%eax
80105366:	5e                   	pop    %esi
80105367:	5f                   	pop    %edi
80105368:	5d                   	pop    %ebp
80105369:	c3                   	ret    
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105370 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105370:	f3 0f 1e fb          	endbr32 
80105374:	55                   	push   %ebp
80105375:	89 e5                	mov    %esp,%ebp
80105377:	56                   	push   %esi
80105378:	8b 55 10             	mov    0x10(%ebp),%edx
8010537b:	8b 75 08             	mov    0x8(%ebp),%esi
8010537e:	53                   	push   %ebx
8010537f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105382:	85 d2                	test   %edx,%edx
80105384:	7e 21                	jle    801053a7 <safestrcpy+0x37>
80105386:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010538a:	89 f2                	mov    %esi,%edx
8010538c:	eb 12                	jmp    801053a0 <safestrcpy+0x30>
8010538e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105390:	0f b6 08             	movzbl (%eax),%ecx
80105393:	83 c0 01             	add    $0x1,%eax
80105396:	83 c2 01             	add    $0x1,%edx
80105399:	88 4a ff             	mov    %cl,-0x1(%edx)
8010539c:	84 c9                	test   %cl,%cl
8010539e:	74 04                	je     801053a4 <safestrcpy+0x34>
801053a0:	39 d8                	cmp    %ebx,%eax
801053a2:	75 ec                	jne    80105390 <safestrcpy+0x20>
    ;
  *s = 0;
801053a4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801053a7:	89 f0                	mov    %esi,%eax
801053a9:	5b                   	pop    %ebx
801053aa:	5e                   	pop    %esi
801053ab:	5d                   	pop    %ebp
801053ac:	c3                   	ret    
801053ad:	8d 76 00             	lea    0x0(%esi),%esi

801053b0 <strlen>:

int
strlen(const char *s)
{
801053b0:	f3 0f 1e fb          	endbr32 
801053b4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801053b5:	31 c0                	xor    %eax,%eax
{
801053b7:	89 e5                	mov    %esp,%ebp
801053b9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801053bc:	80 3a 00             	cmpb   $0x0,(%edx)
801053bf:	74 10                	je     801053d1 <strlen+0x21>
801053c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053c8:	83 c0 01             	add    $0x1,%eax
801053cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801053cf:	75 f7                	jne    801053c8 <strlen+0x18>
    ;
  return n;
}
801053d1:	5d                   	pop    %ebp
801053d2:	c3                   	ret    

801053d3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801053d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801053d7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801053db:	55                   	push   %ebp
  pushl %ebx
801053dc:	53                   	push   %ebx
  pushl %esi
801053dd:	56                   	push   %esi
  pushl %edi
801053de:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801053df:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801053e1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801053e3:	5f                   	pop    %edi
  popl %esi
801053e4:	5e                   	pop    %esi
  popl %ebx
801053e5:	5b                   	pop    %ebx
  popl %ebp
801053e6:	5d                   	pop    %ebp
  ret
801053e7:	c3                   	ret    
801053e8:	66 90                	xchg   %ax,%ax
801053ea:	66 90                	xchg   %ax,%ax
801053ec:	66 90                	xchg   %ax,%ax
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801053f0:	f3 0f 1e fb          	endbr32 
801053f4:	55                   	push   %ebp
801053f5:	89 e5                	mov    %esp,%ebp
801053f7:	53                   	push   %ebx
801053f8:	83 ec 04             	sub    $0x4,%esp
801053fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801053fe:	e8 3d e6 ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105403:	8b 00                	mov    (%eax),%eax
80105405:	39 d8                	cmp    %ebx,%eax
80105407:	76 17                	jbe    80105420 <fetchint+0x30>
80105409:	8d 53 04             	lea    0x4(%ebx),%edx
8010540c:	39 d0                	cmp    %edx,%eax
8010540e:	72 10                	jb     80105420 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105410:	8b 45 0c             	mov    0xc(%ebp),%eax
80105413:	8b 13                	mov    (%ebx),%edx
80105415:	89 10                	mov    %edx,(%eax)
  return 0;
80105417:	31 c0                	xor    %eax,%eax
}
80105419:	83 c4 04             	add    $0x4,%esp
8010541c:	5b                   	pop    %ebx
8010541d:	5d                   	pop    %ebp
8010541e:	c3                   	ret    
8010541f:	90                   	nop
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105425:	eb f2                	jmp    80105419 <fetchint+0x29>
80105427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542e:	66 90                	xchg   %ax,%ax

80105430 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
80105437:	53                   	push   %ebx
80105438:	83 ec 04             	sub    $0x4,%esp
8010543b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010543e:	e8 fd e5 ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz)
80105443:	39 18                	cmp    %ebx,(%eax)
80105445:	76 31                	jbe    80105478 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105447:	8b 55 0c             	mov    0xc(%ebp),%edx
8010544a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010544c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010544e:	39 d3                	cmp    %edx,%ebx
80105450:	73 26                	jae    80105478 <fetchstr+0x48>
80105452:	89 d8                	mov    %ebx,%eax
80105454:	eb 11                	jmp    80105467 <fetchstr+0x37>
80105456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
80105460:	83 c0 01             	add    $0x1,%eax
80105463:	39 c2                	cmp    %eax,%edx
80105465:	76 11                	jbe    80105478 <fetchstr+0x48>
    if(*s == 0)
80105467:	80 38 00             	cmpb   $0x0,(%eax)
8010546a:	75 f4                	jne    80105460 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010546c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010546f:	29 d8                	sub    %ebx,%eax
}
80105471:	5b                   	pop    %ebx
80105472:	5d                   	pop    %ebp
80105473:	c3                   	ret    
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105478:	83 c4 04             	add    $0x4,%esp
    return -1;
8010547b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105480:	5b                   	pop    %ebx
80105481:	5d                   	pop    %ebp
80105482:	c3                   	ret    
80105483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105490 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	56                   	push   %esi
80105498:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105499:	e8 a2 e5 ff ff       	call   80103a40 <myproc>
8010549e:	8b 55 08             	mov    0x8(%ebp),%edx
801054a1:	8b 40 18             	mov    0x18(%eax),%eax
801054a4:	8b 40 44             	mov    0x44(%eax),%eax
801054a7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801054aa:	e8 91 e5 ff ff       	call   80103a40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054af:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054b2:	8b 00                	mov    (%eax),%eax
801054b4:	39 c6                	cmp    %eax,%esi
801054b6:	73 18                	jae    801054d0 <argint+0x40>
801054b8:	8d 53 08             	lea    0x8(%ebx),%edx
801054bb:	39 d0                	cmp    %edx,%eax
801054bd:	72 11                	jb     801054d0 <argint+0x40>
  *ip = *(int*)(addr);
801054bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c2:	8b 53 04             	mov    0x4(%ebx),%edx
801054c5:	89 10                	mov    %edx,(%eax)
  return 0;
801054c7:	31 c0                	xor    %eax,%eax
}
801054c9:	5b                   	pop    %ebx
801054ca:	5e                   	pop    %esi
801054cb:	5d                   	pop    %ebp
801054cc:	c3                   	ret    
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054d5:	eb f2                	jmp    801054c9 <argint+0x39>
801054d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054de:	66 90                	xchg   %ax,%ax

801054e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	56                   	push   %esi
801054e8:	53                   	push   %ebx
801054e9:	83 ec 10             	sub    $0x10,%esp
801054ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801054ef:	e8 4c e5 ff ff       	call   80103a40 <myproc>
 
  if(argint(n, &i) < 0)
801054f4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801054f7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801054f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054fc:	50                   	push   %eax
801054fd:	ff 75 08             	pushl  0x8(%ebp)
80105500:	e8 8b ff ff ff       	call   80105490 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105505:	83 c4 10             	add    $0x10,%esp
80105508:	85 c0                	test   %eax,%eax
8010550a:	78 24                	js     80105530 <argptr+0x50>
8010550c:	85 db                	test   %ebx,%ebx
8010550e:	78 20                	js     80105530 <argptr+0x50>
80105510:	8b 16                	mov    (%esi),%edx
80105512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105515:	39 c2                	cmp    %eax,%edx
80105517:	76 17                	jbe    80105530 <argptr+0x50>
80105519:	01 c3                	add    %eax,%ebx
8010551b:	39 da                	cmp    %ebx,%edx
8010551d:	72 11                	jb     80105530 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010551f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105522:	89 02                	mov    %eax,(%edx)
  return 0;
80105524:	31 c0                	xor    %eax,%eax
}
80105526:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105529:	5b                   	pop    %ebx
8010552a:	5e                   	pop    %esi
8010552b:	5d                   	pop    %ebp
8010552c:	c3                   	ret    
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105535:	eb ef                	jmp    80105526 <argptr+0x46>
80105537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010553e:	66 90                	xchg   %ax,%ax

80105540 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105540:	f3 0f 1e fb          	endbr32 
80105544:	55                   	push   %ebp
80105545:	89 e5                	mov    %esp,%ebp
80105547:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010554a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010554d:	50                   	push   %eax
8010554e:	ff 75 08             	pushl  0x8(%ebp)
80105551:	e8 3a ff ff ff       	call   80105490 <argint>
80105556:	83 c4 10             	add    $0x10,%esp
80105559:	85 c0                	test   %eax,%eax
8010555b:	78 13                	js     80105570 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010555d:	83 ec 08             	sub    $0x8,%esp
80105560:	ff 75 0c             	pushl  0xc(%ebp)
80105563:	ff 75 f4             	pushl  -0xc(%ebp)
80105566:	e8 c5 fe ff ff       	call   80105430 <fetchstr>
8010556b:	83 c4 10             	add    $0x10,%esp
}
8010556e:	c9                   	leave  
8010556f:	c3                   	ret    
80105570:	c9                   	leave  
    return -1;
80105571:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105576:	c3                   	ret    
80105577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557e:	66 90                	xchg   %ax,%ax

80105580 <syscall>:
[SYS_set_bjf_params]           sys_set_bjf_params,
};

void
syscall(void)
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
80105585:	89 e5                	mov    %esp,%ebp
80105587:	53                   	push   %ebx
80105588:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010558b:	e8 b0 e4 ff ff       	call   80103a40 <myproc>
80105590:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105592:	8b 40 18             	mov    0x18(%eax),%eax
80105595:	8b 40 1c             	mov    0x1c(%eax),%eax
  int *cntsys = curproc -> syscnt;
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105598:	8d 50 ff             	lea    -0x1(%eax),%edx
8010559b:	83 fa 1c             	cmp    $0x1c,%edx
8010559e:	77 20                	ja     801055c0 <syscall+0x40>
801055a0:	8b 14 85 e0 85 10 80 	mov    -0x7fef7a20(,%eax,4),%edx
801055a7:	85 d2                	test   %edx,%edx
801055a9:	74 15                	je     801055c0 <syscall+0x40>
    *(cntsys + num -1 ) = *(cntsys+num-1)+1;
801055ab:	83 44 83 78 01       	addl   $0x1,0x78(%ebx,%eax,4)
    curproc->tf->eax = syscalls[num]();
801055b0:	ff d2                	call   *%edx
801055b2:	89 c2                	mov    %eax,%edx
801055b4:	8b 43 18             	mov    0x18(%ebx),%eax
801055b7:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801055ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055bd:	c9                   	leave  
801055be:	c3                   	ret    
801055bf:	90                   	nop
    cprintf("%d %s: unknown sys call %d\n",
801055c0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801055c1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801055c4:	50                   	push   %eax
801055c5:	ff 73 10             	pushl  0x10(%ebx)
801055c8:	68 a9 85 10 80       	push   $0x801085a9
801055cd:	e8 de b0 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801055d2:	8b 43 18             	mov    0x18(%ebx),%eax
801055d5:	83 c4 10             	add    $0x10,%esp
801055d8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801055df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055e2:	c9                   	leave  
801055e3:	c3                   	ret    
801055e4:	66 90                	xchg   %ax,%ax
801055e6:	66 90                	xchg   %ax,%ax
801055e8:	66 90                	xchg   %ax,%ax
801055ea:	66 90                	xchg   %ax,%ax
801055ec:	66 90                	xchg   %ax,%ax
801055ee:	66 90                	xchg   %ax,%ax

801055f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	57                   	push   %edi
801055f4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055f5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801055f8:	53                   	push   %ebx
801055f9:	83 ec 34             	sub    $0x34,%esp
801055fc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801055ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105602:	57                   	push   %edi
80105603:	50                   	push   %eax
{
80105604:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105607:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010560a:	e8 41 ca ff ff       	call   80102050 <nameiparent>
8010560f:	83 c4 10             	add    $0x10,%esp
80105612:	85 c0                	test   %eax,%eax
80105614:	0f 84 46 01 00 00    	je     80105760 <create+0x170>
    return 0;
  ilock(dp);
8010561a:	83 ec 0c             	sub    $0xc,%esp
8010561d:	89 c3                	mov    %eax,%ebx
8010561f:	50                   	push   %eax
80105620:	e8 3b c1 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105625:	83 c4 0c             	add    $0xc,%esp
80105628:	6a 00                	push   $0x0
8010562a:	57                   	push   %edi
8010562b:	53                   	push   %ebx
8010562c:	e8 7f c6 ff ff       	call   80101cb0 <dirlookup>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	89 c6                	mov    %eax,%esi
80105636:	85 c0                	test   %eax,%eax
80105638:	74 56                	je     80105690 <create+0xa0>
    iunlockput(dp);
8010563a:	83 ec 0c             	sub    $0xc,%esp
8010563d:	53                   	push   %ebx
8010563e:	e8 bd c3 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105643:	89 34 24             	mov    %esi,(%esp)
80105646:	e8 15 c1 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010564b:	83 c4 10             	add    $0x10,%esp
8010564e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105653:	75 1b                	jne    80105670 <create+0x80>
80105655:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010565a:	75 14                	jne    80105670 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010565c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010565f:	89 f0                	mov    %esi,%eax
80105661:	5b                   	pop    %ebx
80105662:	5e                   	pop    %esi
80105663:	5f                   	pop    %edi
80105664:	5d                   	pop    %ebp
80105665:	c3                   	ret    
80105666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	56                   	push   %esi
    return 0;
80105674:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105676:	e8 85 c3 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010567b:	83 c4 10             	add    $0x10,%esp
}
8010567e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105681:	89 f0                	mov    %esi,%eax
80105683:	5b                   	pop    %ebx
80105684:	5e                   	pop    %esi
80105685:	5f                   	pop    %edi
80105686:	5d                   	pop    %ebp
80105687:	c3                   	ret    
80105688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105690:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105694:	83 ec 08             	sub    $0x8,%esp
80105697:	50                   	push   %eax
80105698:	ff 33                	pushl  (%ebx)
8010569a:	e8 41 bf ff ff       	call   801015e0 <ialloc>
8010569f:	83 c4 10             	add    $0x10,%esp
801056a2:	89 c6                	mov    %eax,%esi
801056a4:	85 c0                	test   %eax,%eax
801056a6:	0f 84 cd 00 00 00    	je     80105779 <create+0x189>
  ilock(ip);
801056ac:	83 ec 0c             	sub    $0xc,%esp
801056af:	50                   	push   %eax
801056b0:	e8 ab c0 ff ff       	call   80101760 <ilock>
  ip->major = major;
801056b5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801056b9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801056bd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801056c1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801056c5:	b8 01 00 00 00       	mov    $0x1,%eax
801056ca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801056ce:	89 34 24             	mov    %esi,(%esp)
801056d1:	e8 ca bf ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801056de:	74 30                	je     80105710 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801056e0:	83 ec 04             	sub    $0x4,%esp
801056e3:	ff 76 04             	pushl  0x4(%esi)
801056e6:	57                   	push   %edi
801056e7:	53                   	push   %ebx
801056e8:	e8 83 c8 ff ff       	call   80101f70 <dirlink>
801056ed:	83 c4 10             	add    $0x10,%esp
801056f0:	85 c0                	test   %eax,%eax
801056f2:	78 78                	js     8010576c <create+0x17c>
  iunlockput(dp);
801056f4:	83 ec 0c             	sub    $0xc,%esp
801056f7:	53                   	push   %ebx
801056f8:	e8 03 c3 ff ff       	call   80101a00 <iunlockput>
  return ip;
801056fd:	83 c4 10             	add    $0x10,%esp
}
80105700:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105703:	89 f0                	mov    %esi,%eax
80105705:	5b                   	pop    %ebx
80105706:	5e                   	pop    %esi
80105707:	5f                   	pop    %edi
80105708:	5d                   	pop    %ebp
80105709:	c3                   	ret    
8010570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105710:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105713:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105718:	53                   	push   %ebx
80105719:	e8 82 bf ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010571e:	83 c4 0c             	add    $0xc,%esp
80105721:	ff 76 04             	pushl  0x4(%esi)
80105724:	68 74 86 10 80       	push   $0x80108674
80105729:	56                   	push   %esi
8010572a:	e8 41 c8 ff ff       	call   80101f70 <dirlink>
8010572f:	83 c4 10             	add    $0x10,%esp
80105732:	85 c0                	test   %eax,%eax
80105734:	78 18                	js     8010574e <create+0x15e>
80105736:	83 ec 04             	sub    $0x4,%esp
80105739:	ff 73 04             	pushl  0x4(%ebx)
8010573c:	68 73 86 10 80       	push   $0x80108673
80105741:	56                   	push   %esi
80105742:	e8 29 c8 ff ff       	call   80101f70 <dirlink>
80105747:	83 c4 10             	add    $0x10,%esp
8010574a:	85 c0                	test   %eax,%eax
8010574c:	79 92                	jns    801056e0 <create+0xf0>
      panic("create dots");
8010574e:	83 ec 0c             	sub    $0xc,%esp
80105751:	68 67 86 10 80       	push   $0x80108667
80105756:	e8 35 ac ff ff       	call   80100390 <panic>
8010575b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010575f:	90                   	nop
}
80105760:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105763:	31 f6                	xor    %esi,%esi
}
80105765:	5b                   	pop    %ebx
80105766:	89 f0                	mov    %esi,%eax
80105768:	5e                   	pop    %esi
80105769:	5f                   	pop    %edi
8010576a:	5d                   	pop    %ebp
8010576b:	c3                   	ret    
    panic("create: dirlink");
8010576c:	83 ec 0c             	sub    $0xc,%esp
8010576f:	68 76 86 10 80       	push   $0x80108676
80105774:	e8 17 ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	68 58 86 10 80       	push   $0x80108658
80105781:	e8 0a ac ff ff       	call   80100390 <panic>
80105786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578d:	8d 76 00             	lea    0x0(%esi),%esi

80105790 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	56                   	push   %esi
80105794:	89 d6                	mov    %edx,%esi
80105796:	53                   	push   %ebx
80105797:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105799:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010579c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010579f:	50                   	push   %eax
801057a0:	6a 00                	push   $0x0
801057a2:	e8 e9 fc ff ff       	call   80105490 <argint>
801057a7:	83 c4 10             	add    $0x10,%esp
801057aa:	85 c0                	test   %eax,%eax
801057ac:	78 2a                	js     801057d8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057b2:	77 24                	ja     801057d8 <argfd.constprop.0+0x48>
801057b4:	e8 87 e2 ff ff       	call   80103a40 <myproc>
801057b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801057c0:	85 c0                	test   %eax,%eax
801057c2:	74 14                	je     801057d8 <argfd.constprop.0+0x48>
  if(pfd)
801057c4:	85 db                	test   %ebx,%ebx
801057c6:	74 02                	je     801057ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801057c8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801057ca:	89 06                	mov    %eax,(%esi)
  return 0;
801057cc:	31 c0                	xor    %eax,%eax
}
801057ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057d1:	5b                   	pop    %ebx
801057d2:	5e                   	pop    %esi
801057d3:	5d                   	pop    %ebp
801057d4:	c3                   	ret    
801057d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057dd:	eb ef                	jmp    801057ce <argfd.constprop.0+0x3e>
801057df:	90                   	nop

801057e0 <sys_dup>:
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801057e5:	31 c0                	xor    %eax,%eax
{
801057e7:	89 e5                	mov    %esp,%ebp
801057e9:	56                   	push   %esi
801057ea:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801057eb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801057ee:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801057f1:	e8 9a ff ff ff       	call   80105790 <argfd.constprop.0>
801057f6:	85 c0                	test   %eax,%eax
801057f8:	78 1e                	js     80105818 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801057fa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057fd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057ff:	e8 3c e2 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105808:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010580c:	85 d2                	test   %edx,%edx
8010580e:	74 20                	je     80105830 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105810:	83 c3 01             	add    $0x1,%ebx
80105813:	83 fb 10             	cmp    $0x10,%ebx
80105816:	75 f0                	jne    80105808 <sys_dup+0x28>
}
80105818:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010581b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105820:	89 d8                	mov    %ebx,%eax
80105822:	5b                   	pop    %ebx
80105823:	5e                   	pop    %esi
80105824:	5d                   	pop    %ebp
80105825:	c3                   	ret    
80105826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105830:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	ff 75 f4             	pushl  -0xc(%ebp)
8010583a:	e8 31 b6 ff ff       	call   80100e70 <filedup>
  return fd;
8010583f:	83 c4 10             	add    $0x10,%esp
}
80105842:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105845:	89 d8                	mov    %ebx,%eax
80105847:	5b                   	pop    %ebx
80105848:	5e                   	pop    %esi
80105849:	5d                   	pop    %ebp
8010584a:	c3                   	ret    
8010584b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop

80105850 <sys_read>:
{
80105850:	f3 0f 1e fb          	endbr32 
80105854:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105855:	31 c0                	xor    %eax,%eax
{
80105857:	89 e5                	mov    %esp,%ebp
80105859:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010585c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010585f:	e8 2c ff ff ff       	call   80105790 <argfd.constprop.0>
80105864:	85 c0                	test   %eax,%eax
80105866:	78 48                	js     801058b0 <sys_read+0x60>
80105868:	83 ec 08             	sub    $0x8,%esp
8010586b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010586e:	50                   	push   %eax
8010586f:	6a 02                	push   $0x2
80105871:	e8 1a fc ff ff       	call   80105490 <argint>
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	85 c0                	test   %eax,%eax
8010587b:	78 33                	js     801058b0 <sys_read+0x60>
8010587d:	83 ec 04             	sub    $0x4,%esp
80105880:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105883:	ff 75 f0             	pushl  -0x10(%ebp)
80105886:	50                   	push   %eax
80105887:	6a 01                	push   $0x1
80105889:	e8 52 fc ff ff       	call   801054e0 <argptr>
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	85 c0                	test   %eax,%eax
80105893:	78 1b                	js     801058b0 <sys_read+0x60>
  return fileread(f, p, n);
80105895:	83 ec 04             	sub    $0x4,%esp
80105898:	ff 75 f0             	pushl  -0x10(%ebp)
8010589b:	ff 75 f4             	pushl  -0xc(%ebp)
8010589e:	ff 75 ec             	pushl  -0x14(%ebp)
801058a1:	e8 4a b7 ff ff       	call   80100ff0 <fileread>
801058a6:	83 c4 10             	add    $0x10,%esp
}
801058a9:	c9                   	leave  
801058aa:	c3                   	ret    
801058ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058af:	90                   	nop
801058b0:	c9                   	leave  
    return -1;
801058b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b6:	c3                   	ret    
801058b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058be:	66 90                	xchg   %ax,%ax

801058c0 <sys_write>:
{
801058c0:	f3 0f 1e fb          	endbr32 
801058c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058c5:	31 c0                	xor    %eax,%eax
{
801058c7:	89 e5                	mov    %esp,%ebp
801058c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058cc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801058cf:	e8 bc fe ff ff       	call   80105790 <argfd.constprop.0>
801058d4:	85 c0                	test   %eax,%eax
801058d6:	78 48                	js     80105920 <sys_write+0x60>
801058d8:	83 ec 08             	sub    $0x8,%esp
801058db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058de:	50                   	push   %eax
801058df:	6a 02                	push   $0x2
801058e1:	e8 aa fb ff ff       	call   80105490 <argint>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	78 33                	js     80105920 <sys_write+0x60>
801058ed:	83 ec 04             	sub    $0x4,%esp
801058f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058f3:	ff 75 f0             	pushl  -0x10(%ebp)
801058f6:	50                   	push   %eax
801058f7:	6a 01                	push   $0x1
801058f9:	e8 e2 fb ff ff       	call   801054e0 <argptr>
801058fe:	83 c4 10             	add    $0x10,%esp
80105901:	85 c0                	test   %eax,%eax
80105903:	78 1b                	js     80105920 <sys_write+0x60>
  return filewrite(f, p, n);
80105905:	83 ec 04             	sub    $0x4,%esp
80105908:	ff 75 f0             	pushl  -0x10(%ebp)
8010590b:	ff 75 f4             	pushl  -0xc(%ebp)
8010590e:	ff 75 ec             	pushl  -0x14(%ebp)
80105911:	e8 7a b7 ff ff       	call   80101090 <filewrite>
80105916:	83 c4 10             	add    $0x10,%esp
}
80105919:	c9                   	leave  
8010591a:	c3                   	ret    
8010591b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
80105920:	c9                   	leave  
    return -1;
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105926:	c3                   	ret    
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax

80105930 <sys_close>:
{
80105930:	f3 0f 1e fb          	endbr32 
80105934:	55                   	push   %ebp
80105935:	89 e5                	mov    %esp,%ebp
80105937:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010593a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010593d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105940:	e8 4b fe ff ff       	call   80105790 <argfd.constprop.0>
80105945:	85 c0                	test   %eax,%eax
80105947:	78 27                	js     80105970 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105949:	e8 f2 e0 ff ff       	call   80103a40 <myproc>
8010594e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105951:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105954:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010595b:	00 
  fileclose(f);
8010595c:	ff 75 f4             	pushl  -0xc(%ebp)
8010595f:	e8 5c b5 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	31 c0                	xor    %eax,%eax
}
80105969:	c9                   	leave  
8010596a:	c3                   	ret    
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop
80105970:	c9                   	leave  
    return -1;
80105971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105976:	c3                   	ret    
80105977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597e:	66 90                	xchg   %ax,%ax

80105980 <sys_fstat>:
{
80105980:	f3 0f 1e fb          	endbr32 
80105984:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105985:	31 c0                	xor    %eax,%eax
{
80105987:	89 e5                	mov    %esp,%ebp
80105989:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010598c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010598f:	e8 fc fd ff ff       	call   80105790 <argfd.constprop.0>
80105994:	85 c0                	test   %eax,%eax
80105996:	78 30                	js     801059c8 <sys_fstat+0x48>
80105998:	83 ec 04             	sub    $0x4,%esp
8010599b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010599e:	6a 14                	push   $0x14
801059a0:	50                   	push   %eax
801059a1:	6a 01                	push   $0x1
801059a3:	e8 38 fb ff ff       	call   801054e0 <argptr>
801059a8:	83 c4 10             	add    $0x10,%esp
801059ab:	85 c0                	test   %eax,%eax
801059ad:	78 19                	js     801059c8 <sys_fstat+0x48>
  return filestat(f, st);
801059af:	83 ec 08             	sub    $0x8,%esp
801059b2:	ff 75 f4             	pushl  -0xc(%ebp)
801059b5:	ff 75 f0             	pushl  -0x10(%ebp)
801059b8:	e8 e3 b5 ff ff       	call   80100fa0 <filestat>
801059bd:	83 c4 10             	add    $0x10,%esp
}
801059c0:	c9                   	leave  
801059c1:	c3                   	ret    
801059c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059c8:	c9                   	leave  
    return -1;
801059c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059ce:	c3                   	ret    
801059cf:	90                   	nop

801059d0 <sys_link>:
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
801059d5:	89 e5                	mov    %esp,%ebp
801059d7:	57                   	push   %edi
801059d8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801059dc:	53                   	push   %ebx
801059dd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059e0:	50                   	push   %eax
801059e1:	6a 00                	push   $0x0
801059e3:	e8 58 fb ff ff       	call   80105540 <argstr>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	85 c0                	test   %eax,%eax
801059ed:	0f 88 ff 00 00 00    	js     80105af2 <sys_link+0x122>
801059f3:	83 ec 08             	sub    $0x8,%esp
801059f6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801059f9:	50                   	push   %eax
801059fa:	6a 01                	push   $0x1
801059fc:	e8 3f fb ff ff       	call   80105540 <argstr>
80105a01:	83 c4 10             	add    $0x10,%esp
80105a04:	85 c0                	test   %eax,%eax
80105a06:	0f 88 e6 00 00 00    	js     80105af2 <sys_link+0x122>
  begin_op();
80105a0c:	e8 1f d3 ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
80105a11:	83 ec 0c             	sub    $0xc,%esp
80105a14:	ff 75 d4             	pushl  -0x2c(%ebp)
80105a17:	e8 14 c6 ff ff       	call   80102030 <namei>
80105a1c:	83 c4 10             	add    $0x10,%esp
80105a1f:	89 c3                	mov    %eax,%ebx
80105a21:	85 c0                	test   %eax,%eax
80105a23:	0f 84 e8 00 00 00    	je     80105b11 <sys_link+0x141>
  ilock(ip);
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	50                   	push   %eax
80105a2d:	e8 2e bd ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a3a:	0f 84 b9 00 00 00    	je     80105af9 <sys_link+0x129>
  iupdate(ip);
80105a40:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105a43:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105a48:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a4b:	53                   	push   %ebx
80105a4c:	e8 4f bc ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105a51:	89 1c 24             	mov    %ebx,(%esp)
80105a54:	e8 e7 bd ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a59:	58                   	pop    %eax
80105a5a:	5a                   	pop    %edx
80105a5b:	57                   	push   %edi
80105a5c:	ff 75 d0             	pushl  -0x30(%ebp)
80105a5f:	e8 ec c5 ff ff       	call   80102050 <nameiparent>
80105a64:	83 c4 10             	add    $0x10,%esp
80105a67:	89 c6                	mov    %eax,%esi
80105a69:	85 c0                	test   %eax,%eax
80105a6b:	74 5f                	je     80105acc <sys_link+0xfc>
  ilock(dp);
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	50                   	push   %eax
80105a71:	e8 ea bc ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a76:	8b 03                	mov    (%ebx),%eax
80105a78:	83 c4 10             	add    $0x10,%esp
80105a7b:	39 06                	cmp    %eax,(%esi)
80105a7d:	75 41                	jne    80105ac0 <sys_link+0xf0>
80105a7f:	83 ec 04             	sub    $0x4,%esp
80105a82:	ff 73 04             	pushl  0x4(%ebx)
80105a85:	57                   	push   %edi
80105a86:	56                   	push   %esi
80105a87:	e8 e4 c4 ff ff       	call   80101f70 <dirlink>
80105a8c:	83 c4 10             	add    $0x10,%esp
80105a8f:	85 c0                	test   %eax,%eax
80105a91:	78 2d                	js     80105ac0 <sys_link+0xf0>
  iunlockput(dp);
80105a93:	83 ec 0c             	sub    $0xc,%esp
80105a96:	56                   	push   %esi
80105a97:	e8 64 bf ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80105a9c:	89 1c 24             	mov    %ebx,(%esp)
80105a9f:	e8 ec bd ff ff       	call   80101890 <iput>
  end_op();
80105aa4:	e8 f7 d2 ff ff       	call   80102da0 <end_op>
  return 0;
80105aa9:	83 c4 10             	add    $0x10,%esp
80105aac:	31 c0                	xor    %eax,%eax
}
80105aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab1:	5b                   	pop    %ebx
80105ab2:	5e                   	pop    %esi
80105ab3:	5f                   	pop    %edi
80105ab4:	5d                   	pop    %ebp
80105ab5:	c3                   	ret    
80105ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105abd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	56                   	push   %esi
80105ac4:	e8 37 bf ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105ac9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105acc:	83 ec 0c             	sub    $0xc,%esp
80105acf:	53                   	push   %ebx
80105ad0:	e8 8b bc ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105ad5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ada:	89 1c 24             	mov    %ebx,(%esp)
80105add:	e8 be bb ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105ae2:	89 1c 24             	mov    %ebx,(%esp)
80105ae5:	e8 16 bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105aea:	e8 b1 d2 ff ff       	call   80102da0 <end_op>
  return -1;
80105aef:	83 c4 10             	add    $0x10,%esp
80105af2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af7:	eb b5                	jmp    80105aae <sys_link+0xde>
    iunlockput(ip);
80105af9:	83 ec 0c             	sub    $0xc,%esp
80105afc:	53                   	push   %ebx
80105afd:	e8 fe be ff ff       	call   80101a00 <iunlockput>
    end_op();
80105b02:	e8 99 d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0f:	eb 9d                	jmp    80105aae <sys_link+0xde>
    end_op();
80105b11:	e8 8a d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1b:	eb 91                	jmp    80105aae <sys_link+0xde>
80105b1d:	8d 76 00             	lea    0x0(%esi),%esi

80105b20 <sys_unlink>:
{
80105b20:	f3 0f 1e fb          	endbr32 
80105b24:	55                   	push   %ebp
80105b25:	89 e5                	mov    %esp,%ebp
80105b27:	57                   	push   %edi
80105b28:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105b29:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b2c:	53                   	push   %ebx
80105b2d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105b30:	50                   	push   %eax
80105b31:	6a 00                	push   $0x0
80105b33:	e8 08 fa ff ff       	call   80105540 <argstr>
80105b38:	83 c4 10             	add    $0x10,%esp
80105b3b:	85 c0                	test   %eax,%eax
80105b3d:	0f 88 7d 01 00 00    	js     80105cc0 <sys_unlink+0x1a0>
  begin_op();
80105b43:	e8 e8 d1 ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b48:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105b4b:	83 ec 08             	sub    $0x8,%esp
80105b4e:	53                   	push   %ebx
80105b4f:	ff 75 c0             	pushl  -0x40(%ebp)
80105b52:	e8 f9 c4 ff ff       	call   80102050 <nameiparent>
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	89 c6                	mov    %eax,%esi
80105b5c:	85 c0                	test   %eax,%eax
80105b5e:	0f 84 66 01 00 00    	je     80105cca <sys_unlink+0x1aa>
  ilock(dp);
80105b64:	83 ec 0c             	sub    $0xc,%esp
80105b67:	50                   	push   %eax
80105b68:	e8 f3 bb ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b6d:	58                   	pop    %eax
80105b6e:	5a                   	pop    %edx
80105b6f:	68 74 86 10 80       	push   $0x80108674
80105b74:	53                   	push   %ebx
80105b75:	e8 16 c1 ff ff       	call   80101c90 <namecmp>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	0f 84 03 01 00 00    	je     80105c88 <sys_unlink+0x168>
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	68 73 86 10 80       	push   $0x80108673
80105b8d:	53                   	push   %ebx
80105b8e:	e8 fd c0 ff ff       	call   80101c90 <namecmp>
80105b93:	83 c4 10             	add    $0x10,%esp
80105b96:	85 c0                	test   %eax,%eax
80105b98:	0f 84 ea 00 00 00    	je     80105c88 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105b9e:	83 ec 04             	sub    $0x4,%esp
80105ba1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105ba4:	50                   	push   %eax
80105ba5:	53                   	push   %ebx
80105ba6:	56                   	push   %esi
80105ba7:	e8 04 c1 ff ff       	call   80101cb0 <dirlookup>
80105bac:	83 c4 10             	add    $0x10,%esp
80105baf:	89 c3                	mov    %eax,%ebx
80105bb1:	85 c0                	test   %eax,%eax
80105bb3:	0f 84 cf 00 00 00    	je     80105c88 <sys_unlink+0x168>
  ilock(ip);
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	50                   	push   %eax
80105bbd:	e8 9e bb ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105bc2:	83 c4 10             	add    $0x10,%esp
80105bc5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105bca:	0f 8e 23 01 00 00    	jle    80105cf3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bd5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105bd8:	74 66                	je     80105c40 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105bda:	83 ec 04             	sub    $0x4,%esp
80105bdd:	6a 10                	push   $0x10
80105bdf:	6a 00                	push   $0x0
80105be1:	57                   	push   %edi
80105be2:	e8 c9 f5 ff ff       	call   801051b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105be7:	6a 10                	push   $0x10
80105be9:	ff 75 c4             	pushl  -0x3c(%ebp)
80105bec:	57                   	push   %edi
80105bed:	56                   	push   %esi
80105bee:	e8 6d bf ff ff       	call   80101b60 <writei>
80105bf3:	83 c4 20             	add    $0x20,%esp
80105bf6:	83 f8 10             	cmp    $0x10,%eax
80105bf9:	0f 85 e7 00 00 00    	jne    80105ce6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80105bff:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c04:	0f 84 96 00 00 00    	je     80105ca0 <sys_unlink+0x180>
  iunlockput(dp);
80105c0a:	83 ec 0c             	sub    $0xc,%esp
80105c0d:	56                   	push   %esi
80105c0e:	e8 ed bd ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105c13:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c18:	89 1c 24             	mov    %ebx,(%esp)
80105c1b:	e8 80 ba ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105c20:	89 1c 24             	mov    %ebx,(%esp)
80105c23:	e8 d8 bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c28:	e8 73 d1 ff ff       	call   80102da0 <end_op>
  return 0;
80105c2d:	83 c4 10             	add    $0x10,%esp
80105c30:	31 c0                	xor    %eax,%eax
}
80105c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c35:	5b                   	pop    %ebx
80105c36:	5e                   	pop    %esi
80105c37:	5f                   	pop    %edi
80105c38:	5d                   	pop    %ebp
80105c39:	c3                   	ret    
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c40:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105c44:	76 94                	jbe    80105bda <sys_unlink+0xba>
80105c46:	ba 20 00 00 00       	mov    $0x20,%edx
80105c4b:	eb 0b                	jmp    80105c58 <sys_unlink+0x138>
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
80105c50:	83 c2 10             	add    $0x10,%edx
80105c53:	39 53 58             	cmp    %edx,0x58(%ebx)
80105c56:	76 82                	jbe    80105bda <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c58:	6a 10                	push   $0x10
80105c5a:	52                   	push   %edx
80105c5b:	57                   	push   %edi
80105c5c:	53                   	push   %ebx
80105c5d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105c60:	e8 fb bd ff ff       	call   80101a60 <readi>
80105c65:	83 c4 10             	add    $0x10,%esp
80105c68:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105c6b:	83 f8 10             	cmp    $0x10,%eax
80105c6e:	75 69                	jne    80105cd9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105c70:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105c75:	74 d9                	je     80105c50 <sys_unlink+0x130>
    iunlockput(ip);
80105c77:	83 ec 0c             	sub    $0xc,%esp
80105c7a:	53                   	push   %ebx
80105c7b:	e8 80 bd ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105c80:	83 c4 10             	add    $0x10,%esp
80105c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c87:	90                   	nop
  iunlockput(dp);
80105c88:	83 ec 0c             	sub    $0xc,%esp
80105c8b:	56                   	push   %esi
80105c8c:	e8 6f bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c91:	e8 0a d1 ff ff       	call   80102da0 <end_op>
  return -1;
80105c96:	83 c4 10             	add    $0x10,%esp
80105c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9e:	eb 92                	jmp    80105c32 <sys_unlink+0x112>
    iupdate(dp);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105ca3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105ca8:	56                   	push   %esi
80105ca9:	e8 f2 b9 ff ff       	call   801016a0 <iupdate>
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	e9 54 ff ff ff       	jmp    80105c0a <sys_unlink+0xea>
80105cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc5:	e9 68 ff ff ff       	jmp    80105c32 <sys_unlink+0x112>
    end_op();
80105cca:	e8 d1 d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105ccf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd4:	e9 59 ff ff ff       	jmp    80105c32 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105cd9:	83 ec 0c             	sub    $0xc,%esp
80105cdc:	68 98 86 10 80       	push   $0x80108698
80105ce1:	e8 aa a6 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105ce6:	83 ec 0c             	sub    $0xc,%esp
80105ce9:	68 aa 86 10 80       	push   $0x801086aa
80105cee:	e8 9d a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105cf3:	83 ec 0c             	sub    $0xc,%esp
80105cf6:	68 86 86 10 80       	push   $0x80108686
80105cfb:	e8 90 a6 ff ff       	call   80100390 <panic>

80105d00 <sys_open>:

int
sys_open(void)
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	57                   	push   %edi
80105d08:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d09:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105d0c:	53                   	push   %ebx
80105d0d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d10:	50                   	push   %eax
80105d11:	6a 00                	push   $0x0
80105d13:	e8 28 f8 ff ff       	call   80105540 <argstr>
80105d18:	83 c4 10             	add    $0x10,%esp
80105d1b:	85 c0                	test   %eax,%eax
80105d1d:	0f 88 8a 00 00 00    	js     80105dad <sys_open+0xad>
80105d23:	83 ec 08             	sub    $0x8,%esp
80105d26:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	6a 01                	push   $0x1
80105d2c:	e8 5f f7 ff ff       	call   80105490 <argint>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	85 c0                	test   %eax,%eax
80105d36:	78 75                	js     80105dad <sys_open+0xad>
    return -1;

  begin_op();
80105d38:	e8 f3 cf ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
80105d3d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105d41:	75 75                	jne    80105db8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105d43:	83 ec 0c             	sub    $0xc,%esp
80105d46:	ff 75 e0             	pushl  -0x20(%ebp)
80105d49:	e8 e2 c2 ff ff       	call   80102030 <namei>
80105d4e:	83 c4 10             	add    $0x10,%esp
80105d51:	89 c6                	mov    %eax,%esi
80105d53:	85 c0                	test   %eax,%eax
80105d55:	74 7e                	je     80105dd5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105d57:	83 ec 0c             	sub    $0xc,%esp
80105d5a:	50                   	push   %eax
80105d5b:	e8 00 ba ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d60:	83 c4 10             	add    $0x10,%esp
80105d63:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105d68:	0f 84 c2 00 00 00    	je     80105e30 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105d6e:	e8 8d b0 ff ff       	call   80100e00 <filealloc>
80105d73:	89 c7                	mov    %eax,%edi
80105d75:	85 c0                	test   %eax,%eax
80105d77:	74 23                	je     80105d9c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105d79:	e8 c2 dc ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d7e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105d80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105d84:	85 d2                	test   %edx,%edx
80105d86:	74 60                	je     80105de8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105d88:	83 c3 01             	add    $0x1,%ebx
80105d8b:	83 fb 10             	cmp    $0x10,%ebx
80105d8e:	75 f0                	jne    80105d80 <sys_open+0x80>
    if(f)
      fileclose(f);
80105d90:	83 ec 0c             	sub    $0xc,%esp
80105d93:	57                   	push   %edi
80105d94:	e8 27 b1 ff ff       	call   80100ec0 <fileclose>
80105d99:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105d9c:	83 ec 0c             	sub    $0xc,%esp
80105d9f:	56                   	push   %esi
80105da0:	e8 5b bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105da5:	e8 f6 cf ff ff       	call   80102da0 <end_op>
    return -1;
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105db2:	eb 6d                	jmp    80105e21 <sys_open+0x121>
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105db8:	83 ec 0c             	sub    $0xc,%esp
80105dbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dbe:	31 c9                	xor    %ecx,%ecx
80105dc0:	ba 02 00 00 00       	mov    $0x2,%edx
80105dc5:	6a 00                	push   $0x0
80105dc7:	e8 24 f8 ff ff       	call   801055f0 <create>
    if(ip == 0){
80105dcc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105dcf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105dd1:	85 c0                	test   %eax,%eax
80105dd3:	75 99                	jne    80105d6e <sys_open+0x6e>
      end_op();
80105dd5:	e8 c6 cf ff ff       	call   80102da0 <end_op>
      return -1;
80105dda:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ddf:	eb 40                	jmp    80105e21 <sys_open+0x121>
80105de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105de8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105deb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105def:	56                   	push   %esi
80105df0:	e8 4b ba ff ff       	call   80101840 <iunlock>
  end_op();
80105df5:	e8 a6 cf ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
80105dfa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e03:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e06:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105e09:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105e0b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e12:	f7 d0                	not    %eax
80105e14:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e17:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e1a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e1d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e24:	89 d8                	mov    %ebx,%eax
80105e26:	5b                   	pop    %ebx
80105e27:	5e                   	pop    %esi
80105e28:	5f                   	pop    %edi
80105e29:	5d                   	pop    %ebp
80105e2a:	c3                   	ret    
80105e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e30:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105e33:	85 c9                	test   %ecx,%ecx
80105e35:	0f 84 33 ff ff ff    	je     80105d6e <sys_open+0x6e>
80105e3b:	e9 5c ff ff ff       	jmp    80105d9c <sys_open+0x9c>

80105e40 <sys_mkdir>:

int
sys_mkdir(void)
{
80105e40:	f3 0f 1e fb          	endbr32 
80105e44:	55                   	push   %ebp
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e4a:	e8 e1 ce ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105e4f:	83 ec 08             	sub    $0x8,%esp
80105e52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e55:	50                   	push   %eax
80105e56:	6a 00                	push   $0x0
80105e58:	e8 e3 f6 ff ff       	call   80105540 <argstr>
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	85 c0                	test   %eax,%eax
80105e62:	78 34                	js     80105e98 <sys_mkdir+0x58>
80105e64:	83 ec 0c             	sub    $0xc,%esp
80105e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6a:	31 c9                	xor    %ecx,%ecx
80105e6c:	ba 01 00 00 00       	mov    $0x1,%edx
80105e71:	6a 00                	push   $0x0
80105e73:	e8 78 f7 ff ff       	call   801055f0 <create>
80105e78:	83 c4 10             	add    $0x10,%esp
80105e7b:	85 c0                	test   %eax,%eax
80105e7d:	74 19                	je     80105e98 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e7f:	83 ec 0c             	sub    $0xc,%esp
80105e82:	50                   	push   %eax
80105e83:	e8 78 bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105e88:	e8 13 cf ff ff       	call   80102da0 <end_op>
  return 0;
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	31 c0                	xor    %eax,%eax
}
80105e92:	c9                   	leave  
80105e93:	c3                   	ret    
80105e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105e98:	e8 03 cf ff ff       	call   80102da0 <end_op>
    return -1;
80105e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ea2:	c9                   	leave  
80105ea3:	c3                   	ret    
80105ea4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eaf:	90                   	nop

80105eb0 <sys_mknod>:

int
sys_mknod(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105eba:	e8 71 ce ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ebf:	83 ec 08             	sub    $0x8,%esp
80105ec2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ec5:	50                   	push   %eax
80105ec6:	6a 00                	push   $0x0
80105ec8:	e8 73 f6 ff ff       	call   80105540 <argstr>
80105ecd:	83 c4 10             	add    $0x10,%esp
80105ed0:	85 c0                	test   %eax,%eax
80105ed2:	78 64                	js     80105f38 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105ed4:	83 ec 08             	sub    $0x8,%esp
80105ed7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eda:	50                   	push   %eax
80105edb:	6a 01                	push   $0x1
80105edd:	e8 ae f5 ff ff       	call   80105490 <argint>
  if((argstr(0, &path)) < 0 ||
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	78 4f                	js     80105f38 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105ee9:	83 ec 08             	sub    $0x8,%esp
80105eec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eef:	50                   	push   %eax
80105ef0:	6a 02                	push   $0x2
80105ef2:	e8 99 f5 ff ff       	call   80105490 <argint>
     argint(1, &major) < 0 ||
80105ef7:	83 c4 10             	add    $0x10,%esp
80105efa:	85 c0                	test   %eax,%eax
80105efc:	78 3a                	js     80105f38 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105efe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105f02:	83 ec 0c             	sub    $0xc,%esp
80105f05:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105f09:	ba 03 00 00 00       	mov    $0x3,%edx
80105f0e:	50                   	push   %eax
80105f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f12:	e8 d9 f6 ff ff       	call   801055f0 <create>
     argint(2, &minor) < 0 ||
80105f17:	83 c4 10             	add    $0x10,%esp
80105f1a:	85 c0                	test   %eax,%eax
80105f1c:	74 1a                	je     80105f38 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f1e:	83 ec 0c             	sub    $0xc,%esp
80105f21:	50                   	push   %eax
80105f22:	e8 d9 ba ff ff       	call   80101a00 <iunlockput>
  end_op();
80105f27:	e8 74 ce ff ff       	call   80102da0 <end_op>
  return 0;
80105f2c:	83 c4 10             	add    $0x10,%esp
80105f2f:	31 c0                	xor    %eax,%eax
}
80105f31:	c9                   	leave  
80105f32:	c3                   	ret    
80105f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f37:	90                   	nop
    end_op();
80105f38:	e8 63 ce ff ff       	call   80102da0 <end_op>
    return -1;
80105f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f42:	c9                   	leave  
80105f43:	c3                   	ret    
80105f44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop

80105f50 <sys_chdir>:

int
sys_chdir(void)
{
80105f50:	f3 0f 1e fb          	endbr32 
80105f54:	55                   	push   %ebp
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	56                   	push   %esi
80105f58:	53                   	push   %ebx
80105f59:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105f5c:	e8 df da ff ff       	call   80103a40 <myproc>
80105f61:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105f63:	e8 c8 cd ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105f68:	83 ec 08             	sub    $0x8,%esp
80105f6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f6e:	50                   	push   %eax
80105f6f:	6a 00                	push   $0x0
80105f71:	e8 ca f5 ff ff       	call   80105540 <argstr>
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	85 c0                	test   %eax,%eax
80105f7b:	78 73                	js     80105ff0 <sys_chdir+0xa0>
80105f7d:	83 ec 0c             	sub    $0xc,%esp
80105f80:	ff 75 f4             	pushl  -0xc(%ebp)
80105f83:	e8 a8 c0 ff ff       	call   80102030 <namei>
80105f88:	83 c4 10             	add    $0x10,%esp
80105f8b:	89 c3                	mov    %eax,%ebx
80105f8d:	85 c0                	test   %eax,%eax
80105f8f:	74 5f                	je     80105ff0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105f91:	83 ec 0c             	sub    $0xc,%esp
80105f94:	50                   	push   %eax
80105f95:	e8 c6 b7 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105fa2:	75 2c                	jne    80105fd0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105fa4:	83 ec 0c             	sub    $0xc,%esp
80105fa7:	53                   	push   %ebx
80105fa8:	e8 93 b8 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105fad:	58                   	pop    %eax
80105fae:	ff 76 68             	pushl  0x68(%esi)
80105fb1:	e8 da b8 ff ff       	call   80101890 <iput>
  end_op();
80105fb6:	e8 e5 cd ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
80105fbb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105fbe:	83 c4 10             	add    $0x10,%esp
80105fc1:	31 c0                	xor    %eax,%eax
}
80105fc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fc6:	5b                   	pop    %ebx
80105fc7:	5e                   	pop    %esi
80105fc8:	5d                   	pop    %ebp
80105fc9:	c3                   	ret    
80105fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	53                   	push   %ebx
80105fd4:	e8 27 ba ff ff       	call   80101a00 <iunlockput>
    end_op();
80105fd9:	e8 c2 cd ff ff       	call   80102da0 <end_op>
    return -1;
80105fde:	83 c4 10             	add    $0x10,%esp
80105fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe6:	eb db                	jmp    80105fc3 <sys_chdir+0x73>
80105fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fef:	90                   	nop
    end_op();
80105ff0:	e8 ab cd ff ff       	call   80102da0 <end_op>
    return -1;
80105ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffa:	eb c7                	jmp    80105fc3 <sys_chdir+0x73>
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_exec>:

int
sys_exec(void)
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
80106005:	89 e5                	mov    %esp,%ebp
80106007:	57                   	push   %edi
80106008:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106009:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010600f:	53                   	push   %ebx
80106010:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106016:	50                   	push   %eax
80106017:	6a 00                	push   $0x0
80106019:	e8 22 f5 ff ff       	call   80105540 <argstr>
8010601e:	83 c4 10             	add    $0x10,%esp
80106021:	85 c0                	test   %eax,%eax
80106023:	0f 88 8b 00 00 00    	js     801060b4 <sys_exec+0xb4>
80106029:	83 ec 08             	sub    $0x8,%esp
8010602c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106032:	50                   	push   %eax
80106033:	6a 01                	push   $0x1
80106035:	e8 56 f4 ff ff       	call   80105490 <argint>
8010603a:	83 c4 10             	add    $0x10,%esp
8010603d:	85 c0                	test   %eax,%eax
8010603f:	78 73                	js     801060b4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106041:	83 ec 04             	sub    $0x4,%esp
80106044:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010604a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010604c:	68 80 00 00 00       	push   $0x80
80106051:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106057:	6a 00                	push   $0x0
80106059:	50                   	push   %eax
8010605a:	e8 51 f1 ff ff       	call   801051b0 <memset>
8010605f:	83 c4 10             	add    $0x10,%esp
80106062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106068:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010606e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106075:	83 ec 08             	sub    $0x8,%esp
80106078:	57                   	push   %edi
80106079:	01 f0                	add    %esi,%eax
8010607b:	50                   	push   %eax
8010607c:	e8 6f f3 ff ff       	call   801053f0 <fetchint>
80106081:	83 c4 10             	add    $0x10,%esp
80106084:	85 c0                	test   %eax,%eax
80106086:	78 2c                	js     801060b4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106088:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010608e:	85 c0                	test   %eax,%eax
80106090:	74 36                	je     801060c8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106092:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106098:	83 ec 08             	sub    $0x8,%esp
8010609b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010609e:	52                   	push   %edx
8010609f:	50                   	push   %eax
801060a0:	e8 8b f3 ff ff       	call   80105430 <fetchstr>
801060a5:	83 c4 10             	add    $0x10,%esp
801060a8:	85 c0                	test   %eax,%eax
801060aa:	78 08                	js     801060b4 <sys_exec+0xb4>
  for(i=0;; i++){
801060ac:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801060af:	83 fb 20             	cmp    $0x20,%ebx
801060b2:	75 b4                	jne    80106068 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801060b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801060b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060bc:	5b                   	pop    %ebx
801060bd:	5e                   	pop    %esi
801060be:	5f                   	pop    %edi
801060bf:	5d                   	pop    %ebp
801060c0:	c3                   	ret    
801060c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801060c8:	83 ec 08             	sub    $0x8,%esp
801060cb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801060d1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801060d8:	00 00 00 00 
  return exec(path, argv);
801060dc:	50                   	push   %eax
801060dd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801060e3:	e8 98 a9 ff ff       	call   80100a80 <exec>
801060e8:	83 c4 10             	add    $0x10,%esp
}
801060eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060ee:	5b                   	pop    %ebx
801060ef:	5e                   	pop    %esi
801060f0:	5f                   	pop    %edi
801060f1:	5d                   	pop    %ebp
801060f2:	c3                   	ret    
801060f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106100 <sys_pipe>:

int
sys_pipe(void)
{
80106100:	f3 0f 1e fb          	endbr32 
80106104:	55                   	push   %ebp
80106105:	89 e5                	mov    %esp,%ebp
80106107:	57                   	push   %edi
80106108:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106109:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010610c:	53                   	push   %ebx
8010610d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106110:	6a 08                	push   $0x8
80106112:	50                   	push   %eax
80106113:	6a 00                	push   $0x0
80106115:	e8 c6 f3 ff ff       	call   801054e0 <argptr>
8010611a:	83 c4 10             	add    $0x10,%esp
8010611d:	85 c0                	test   %eax,%eax
8010611f:	78 4e                	js     8010616f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106121:	83 ec 08             	sub    $0x8,%esp
80106124:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106127:	50                   	push   %eax
80106128:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010612b:	50                   	push   %eax
8010612c:	e8 bf d2 ff ff       	call   801033f0 <pipealloc>
80106131:	83 c4 10             	add    $0x10,%esp
80106134:	85 c0                	test   %eax,%eax
80106136:	78 37                	js     8010616f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106138:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010613b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010613d:	e8 fe d8 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106148:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010614c:	85 f6                	test   %esi,%esi
8010614e:	74 30                	je     80106180 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106150:	83 c3 01             	add    $0x1,%ebx
80106153:	83 fb 10             	cmp    $0x10,%ebx
80106156:	75 f0                	jne    80106148 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106158:	83 ec 0c             	sub    $0xc,%esp
8010615b:	ff 75 e0             	pushl  -0x20(%ebp)
8010615e:	e8 5d ad ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80106163:	58                   	pop    %eax
80106164:	ff 75 e4             	pushl  -0x1c(%ebp)
80106167:	e8 54 ad ff ff       	call   80100ec0 <fileclose>
    return -1;
8010616c:	83 c4 10             	add    $0x10,%esp
8010616f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106174:	eb 5b                	jmp    801061d1 <sys_pipe+0xd1>
80106176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106180:	8d 73 08             	lea    0x8(%ebx),%esi
80106183:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106187:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010618a:	e8 b1 d8 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010618f:	31 d2                	xor    %edx,%edx
80106191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106198:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010619c:	85 c9                	test   %ecx,%ecx
8010619e:	74 20                	je     801061c0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801061a0:	83 c2 01             	add    $0x1,%edx
801061a3:	83 fa 10             	cmp    $0x10,%edx
801061a6:	75 f0                	jne    80106198 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801061a8:	e8 93 d8 ff ff       	call   80103a40 <myproc>
801061ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801061b4:	00 
801061b5:	eb a1                	jmp    80106158 <sys_pipe+0x58>
801061b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801061c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801061c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801061c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801061cf:	31 c0                	xor    %eax,%eax
}
801061d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061d4:	5b                   	pop    %ebx
801061d5:	5e                   	pop    %esi
801061d6:	5f                   	pop    %edi
801061d7:	5d                   	pop    %ebp
801061d8:	c3                   	ret    
801061d9:	66 90                	xchg   %ax,%ax
801061db:	66 90                	xchg   %ax,%ax
801061dd:	66 90                	xchg   %ax,%ax
801061df:	90                   	nop

801061e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
  return fork();
801061e4:	e9 27 da ff ff       	jmp    80103c10 <fork>
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061f0 <sys_exit>:
}

int
sys_exit(void)
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	83 ec 08             	sub    $0x8,%esp
  exit();
801061fa:	e8 41 e3 ff ff       	call   80104540 <exit>
  return 0;  // not reached
}
801061ff:	31 c0                	xor    %eax,%eax
80106201:	c9                   	leave  
80106202:	c3                   	ret    
80106203:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106210 <sys_wait>:

int
sys_wait(void)
{
80106210:	f3 0f 1e fb          	endbr32 
  return wait();
80106214:	e9 c7 e5 ff ff       	jmp    801047e0 <wait>
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_kill>:
}

int
sys_kill(void)
{
80106220:	f3 0f 1e fb          	endbr32 
80106224:	55                   	push   %ebp
80106225:	89 e5                	mov    %esp,%ebp
80106227:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010622a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010622d:	50                   	push   %eax
8010622e:	6a 00                	push   $0x0
80106230:	e8 5b f2 ff ff       	call   80105490 <argint>
80106235:	83 c4 10             	add    $0x10,%esp
80106238:	85 c0                	test   %eax,%eax
8010623a:	78 14                	js     80106250 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010623c:	83 ec 0c             	sub    $0xc,%esp
8010623f:	ff 75 f4             	pushl  -0xc(%ebp)
80106242:	e8 09 e7 ff ff       	call   80104950 <kill>
80106247:	83 c4 10             	add    $0x10,%esp
}
8010624a:	c9                   	leave  
8010624b:	c3                   	ret    
8010624c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106250:	c9                   	leave  
    return -1;
80106251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106256:	c3                   	ret    
80106257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010625e:	66 90                	xchg   %ax,%ax

80106260 <sys_getpid>:

int
sys_getpid(void)
{
80106260:	f3 0f 1e fb          	endbr32 
80106264:	55                   	push   %ebp
80106265:	89 e5                	mov    %esp,%ebp
80106267:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010626a:	e8 d1 d7 ff ff       	call   80103a40 <myproc>
8010626f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106272:	c9                   	leave  
80106273:	c3                   	ret    
80106274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010627b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010627f:	90                   	nop

80106280 <sys_sbrk>:

int
sys_sbrk(void)
{
80106280:	f3 0f 1e fb          	endbr32 
80106284:	55                   	push   %ebp
80106285:	89 e5                	mov    %esp,%ebp
80106287:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106288:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010628b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010628e:	50                   	push   %eax
8010628f:	6a 00                	push   $0x0
80106291:	e8 fa f1 ff ff       	call   80105490 <argint>
80106296:	83 c4 10             	add    $0x10,%esp
80106299:	85 c0                	test   %eax,%eax
8010629b:	78 23                	js     801062c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010629d:	e8 9e d7 ff ff       	call   80103a40 <myproc>
  if(growproc(n) < 0)
801062a2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801062a5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801062a7:	ff 75 f4             	pushl  -0xc(%ebp)
801062aa:	e8 e1 d8 ff ff       	call   80103b90 <growproc>
801062af:	83 c4 10             	add    $0x10,%esp
801062b2:	85 c0                	test   %eax,%eax
801062b4:	78 0a                	js     801062c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801062b6:	89 d8                	mov    %ebx,%eax
801062b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062bb:	c9                   	leave  
801062bc:	c3                   	ret    
801062bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801062c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062c5:	eb ef                	jmp    801062b6 <sys_sbrk+0x36>
801062c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ce:	66 90                	xchg   %ax,%ax

801062d0 <sys_sleep>:

int
sys_sleep(void)
{
801062d0:	f3 0f 1e fb          	endbr32 
801062d4:	55                   	push   %ebp
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801062d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801062db:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801062de:	50                   	push   %eax
801062df:	6a 00                	push   $0x0
801062e1:	e8 aa f1 ff ff       	call   80105490 <argint>
801062e6:	83 c4 10             	add    $0x10,%esp
801062e9:	85 c0                	test   %eax,%eax
801062eb:	0f 88 86 00 00 00    	js     80106377 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801062f1:	83 ec 0c             	sub    $0xc,%esp
801062f4:	68 60 7e 11 80       	push   $0x80117e60
801062f9:	e8 a2 ed ff ff       	call   801050a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801062fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106301:	8b 1d a0 86 11 80    	mov    0x801186a0,%ebx
  while(ticks - ticks0 < n){
80106307:	83 c4 10             	add    $0x10,%esp
8010630a:	85 d2                	test   %edx,%edx
8010630c:	75 23                	jne    80106331 <sys_sleep+0x61>
8010630e:	eb 50                	jmp    80106360 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106310:	83 ec 08             	sub    $0x8,%esp
80106313:	68 60 7e 11 80       	push   $0x80117e60
80106318:	68 a0 86 11 80       	push   $0x801186a0
8010631d:	e8 fe e3 ff ff       	call   80104720 <sleep>
  while(ticks - ticks0 < n){
80106322:	a1 a0 86 11 80       	mov    0x801186a0,%eax
80106327:	83 c4 10             	add    $0x10,%esp
8010632a:	29 d8                	sub    %ebx,%eax
8010632c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010632f:	73 2f                	jae    80106360 <sys_sleep+0x90>
    if(myproc()->killed){
80106331:	e8 0a d7 ff ff       	call   80103a40 <myproc>
80106336:	8b 40 24             	mov    0x24(%eax),%eax
80106339:	85 c0                	test   %eax,%eax
8010633b:	74 d3                	je     80106310 <sys_sleep+0x40>
      release(&tickslock);
8010633d:	83 ec 0c             	sub    $0xc,%esp
80106340:	68 60 7e 11 80       	push   $0x80117e60
80106345:	e8 16 ee ff ff       	call   80105160 <release>
  }
  release(&tickslock);
  return 0;
}
8010634a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010634d:	83 c4 10             	add    $0x10,%esp
80106350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106355:	c9                   	leave  
80106356:	c3                   	ret    
80106357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010635e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106360:	83 ec 0c             	sub    $0xc,%esp
80106363:	68 60 7e 11 80       	push   $0x80117e60
80106368:	e8 f3 ed ff ff       	call   80105160 <release>
  return 0;
8010636d:	83 c4 10             	add    $0x10,%esp
80106370:	31 c0                	xor    %eax,%eax
}
80106372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106375:	c9                   	leave  
80106376:	c3                   	ret    
    return -1;
80106377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010637c:	eb f4                	jmp    80106372 <sys_sleep+0xa2>
8010637e:	66 90                	xchg   %ax,%ax

80106380 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106380:	f3 0f 1e fb          	endbr32 
80106384:	55                   	push   %ebp
80106385:	89 e5                	mov    %esp,%ebp
80106387:	53                   	push   %ebx
80106388:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010638b:	68 60 7e 11 80       	push   $0x80117e60
80106390:	e8 0b ed ff ff       	call   801050a0 <acquire>
  xticks = ticks;
80106395:	8b 1d a0 86 11 80    	mov    0x801186a0,%ebx
  release(&tickslock);
8010639b:	c7 04 24 60 7e 11 80 	movl   $0x80117e60,(%esp)
801063a2:	e8 b9 ed ff ff       	call   80105160 <release>
  return xticks;
}
801063a7:	89 d8                	mov    %ebx,%eax
801063a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063ac:	c9                   	leave  
801063ad:	c3                   	ret    
801063ae:	66 90                	xchg   %ax,%ax

801063b0 <sys_find_next_prime_number>:

int
sys_find_next_prime_number(void)
{
801063b0:	f3 0f 1e fb          	endbr32 
801063b4:	55                   	push   %ebp
801063b5:	89 e5                	mov    %esp,%ebp
801063b7:	53                   	push   %ebx
801063b8:	83 ec 04             	sub    $0x4,%esp
  int number = myproc()->tf->ebx; //register after eax
801063bb:	e8 80 d6 ff ff       	call   80103a40 <myproc>
  cprintf("Kernel: sys_find_next_prime_num() called for number %d\n", number);
801063c0:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; //register after eax
801063c3:	8b 40 18             	mov    0x18(%eax),%eax
801063c6:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("Kernel: sys_find_next_prime_num() called for number %d\n", number);
801063c9:	53                   	push   %ebx
801063ca:	68 bc 86 10 80       	push   $0x801086bc
801063cf:	e8 dc a2 ff ff       	call   801006b0 <cprintf>
  return find_next_prime_number(number);
801063d4:	89 1c 24             	mov    %ebx,(%esp)
801063d7:	e8 e4 e6 ff ff       	call   80104ac0 <find_next_prime_number>
}
801063dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063df:	c9                   	leave  
801063e0:	c3                   	ret    
801063e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ef:	90                   	nop

801063f0 <sys_get_call_count>:

int 
sys_get_call_count(void)
{
801063f0:	f3 0f 1e fb          	endbr32 
801063f4:	55                   	push   %ebp
801063f5:	89 e5                	mov    %esp,%ebp
801063f7:	53                   	push   %ebx
801063f8:	83 ec 14             	sub    $0x14,%esp
  int  *cnt;
  int sys_num;
  struct proc *curproc = myproc();
801063fb:	e8 40 d6 ff ff       	call   80103a40 <myproc>
  argint(0, &sys_num);
80106400:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80106403:	89 c3                	mov    %eax,%ebx
  argint(0, &sys_num);
80106405:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106408:	50                   	push   %eax
80106409:	6a 00                	push   $0x0
8010640b:	e8 80 f0 ff ff       	call   80105490 <argint>
  cnt = curproc->syscnt;
  return *(cnt+sys_num-1);
80106410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106413:	8b 44 83 78          	mov    0x78(%ebx,%eax,4),%eax
}
80106417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010641a:	c9                   	leave  
8010641b:	c3                   	ret    
8010641c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106420 <sys_get_most_caller>:

int
sys_get_most_caller(void)
{
80106420:	f3 0f 1e fb          	endbr32 
80106424:	55                   	push   %ebp
80106425:	89 e5                	mov    %esp,%ebp
80106427:	83 ec 20             	sub    $0x20,%esp
  int sys_num;
  argint(0, &sys_num);
8010642a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010642d:	50                   	push   %eax
8010642e:	6a 00                	push   $0x0
80106430:	e8 5b f0 ff ff       	call   80105490 <argint>
  return get_most_caller(sys_num);
80106435:	58                   	pop    %eax
80106436:	ff 75 f4             	pushl  -0xc(%ebp)
80106439:	e8 c2 e6 ff ff       	call   80104b00 <get_most_caller>
}
8010643e:	c9                   	leave  
8010643f:	c3                   	ret    

80106440 <sys_wait_for_process>:

int 
sys_wait_for_process(void)
{
80106440:	f3 0f 1e fb          	endbr32 
80106444:	55                   	push   %ebp
80106445:	89 e5                	mov    %esp,%ebp
80106447:	83 ec 20             	sub    $0x20,%esp
  int pid;
  argint(0, &pid);
8010644a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010644d:	50                   	push   %eax
8010644e:	6a 00                	push   $0x0
80106450:	e8 3b f0 ff ff       	call   80105490 <argint>
  return wait_for_process(pid);
80106455:	58                   	pop    %eax
80106456:	ff 75 f4             	pushl  -0xc(%ebp)
80106459:	e8 82 e8 ff ff       	call   80104ce0 <wait_for_process>

}
8010645e:	c9                   	leave  
8010645f:	c3                   	ret    

80106460 <sys_set_queue>:

void
sys_set_queue(void)
{
80106460:	f3 0f 1e fb          	endbr32 
80106464:	55                   	push   %ebp
80106465:	89 e5                	mov    %esp,%ebp
80106467:	83 ec 20             	sub    $0x20,%esp
  int pid, new_queue;
  argint(0, &pid);
8010646a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010646d:	50                   	push   %eax
8010646e:	6a 00                	push   $0x0
80106470:	e8 1b f0 ff ff       	call   80105490 <argint>
  argint(1, &new_queue);
80106475:	58                   	pop    %eax
80106476:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106479:	5a                   	pop    %edx
8010647a:	50                   	push   %eax
8010647b:	6a 01                	push   $0x1
8010647d:	e8 0e f0 ff ff       	call   80105490 <argint>
  set_queue(pid, new_queue);
80106482:	59                   	pop    %ecx
80106483:	58                   	pop    %eax
80106484:	ff 75 f4             	pushl  -0xc(%ebp)
80106487:	ff 75 f0             	pushl  -0x10(%ebp)
8010648a:	e8 21 e7 ff ff       	call   80104bb0 <set_queue>
}
8010648f:	83 c4 10             	add    $0x10,%esp
80106492:	c9                   	leave  
80106493:	c3                   	ret    
80106494:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010649b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010649f:	90                   	nop

801064a0 <sys_print_procs>:

void
sys_print_procs(void)
{
801064a0:	f3 0f 1e fb          	endbr32 
  print_procs();
801064a4:	e9 b7 d9 ff ff       	jmp    80103e60 <print_procs>
801064a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064b0 <sys_set_global_bjf_params>:
}

void
sys_set_global_bjf_params(void)
{
801064b0:	f3 0f 1e fb          	endbr32 
801064b4:	55                   	push   %ebp
801064b5:	89 e5                	mov    %esp,%ebp
801064b7:	83 ec 20             	sub    $0x20,%esp
  int p_ratio, a_ratio, e_ratio;
  argint(0, &p_ratio);
801064ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064bd:	50                   	push   %eax
801064be:	6a 00                	push   $0x0
801064c0:	e8 cb ef ff ff       	call   80105490 <argint>
  argint(1, &a_ratio);
801064c5:	58                   	pop    %eax
801064c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064c9:	5a                   	pop    %edx
801064ca:	50                   	push   %eax
801064cb:	6a 01                	push   $0x1
801064cd:	e8 be ef ff ff       	call   80105490 <argint>
  argint(2, &e_ratio);
801064d2:	59                   	pop    %ecx
801064d3:	58                   	pop    %eax
801064d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064d7:	50                   	push   %eax
801064d8:	6a 02                	push   $0x2
801064da:	e8 b1 ef ff ff       	call   80105490 <argint>
  set_global_bjf_params(p_ratio, a_ratio, e_ratio);
801064df:	83 c4 0c             	add    $0xc,%esp
801064e2:	ff 75 f4             	pushl  -0xc(%ebp)
801064e5:	ff 75 f0             	pushl  -0x10(%ebp)
801064e8:	ff 75 ec             	pushl  -0x14(%ebp)
801064eb:	e8 20 e7 ff ff       	call   80104c10 <set_global_bjf_params>
}
801064f0:	83 c4 10             	add    $0x10,%esp
801064f3:	c9                   	leave  
801064f4:	c3                   	ret    
801064f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106500 <sys_set_bjf_params>:

void
sys_set_bjf_params(void)
{
80106500:	f3 0f 1e fb          	endbr32 
80106504:	55                   	push   %ebp
80106505:	89 e5                	mov    %esp,%ebp
80106507:	83 ec 20             	sub    $0x20,%esp
  int pid, p_ratio, a_ratio, e_ratio;
  argint(0, &pid);
8010650a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010650d:	50                   	push   %eax
8010650e:	6a 00                	push   $0x0
80106510:	e8 7b ef ff ff       	call   80105490 <argint>
  argint(1, &p_ratio);
80106515:	58                   	pop    %eax
80106516:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106519:	5a                   	pop    %edx
8010651a:	50                   	push   %eax
8010651b:	6a 01                	push   $0x1
8010651d:	e8 6e ef ff ff       	call   80105490 <argint>
  argint(2, &a_ratio);
80106522:	59                   	pop    %ecx
80106523:	58                   	pop    %eax
80106524:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106527:	50                   	push   %eax
80106528:	6a 02                	push   $0x2
8010652a:	e8 61 ef ff ff       	call   80105490 <argint>
  argint(3, &e_ratio);
8010652f:	58                   	pop    %eax
80106530:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106533:	5a                   	pop    %edx
80106534:	50                   	push   %eax
80106535:	6a 03                	push   $0x3
80106537:	e8 54 ef ff ff       	call   80105490 <argint>
  set_bjf_params(pid, p_ratio, a_ratio, e_ratio);
8010653c:	ff 75 f4             	pushl  -0xc(%ebp)
8010653f:	ff 75 f0             	pushl  -0x10(%ebp)
80106542:	ff 75 ec             	pushl  -0x14(%ebp)
80106545:	ff 75 e8             	pushl  -0x18(%ebp)
80106548:	e8 23 e7 ff ff       	call   80104c70 <set_bjf_params>
8010654d:	83 c4 20             	add    $0x20,%esp
80106550:	c9                   	leave  
80106551:	c3                   	ret    

80106552 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106552:	1e                   	push   %ds
  pushl %es
80106553:	06                   	push   %es
  pushl %fs
80106554:	0f a0                	push   %fs
  pushl %gs
80106556:	0f a8                	push   %gs
  pushal
80106558:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106559:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010655d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010655f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106561:	54                   	push   %esp
  call trap
80106562:	e8 c9 00 00 00       	call   80106630 <trap>
  addl $4, %esp
80106567:	83 c4 04             	add    $0x4,%esp

8010656a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010656a:	61                   	popa   
  popl %gs
8010656b:	0f a9                	pop    %gs
  popl %fs
8010656d:	0f a1                	pop    %fs
  popl %es
8010656f:	07                   	pop    %es
  popl %ds
80106570:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106571:	83 c4 08             	add    $0x8,%esp
  iret
80106574:	cf                   	iret   
80106575:	66 90                	xchg   %ax,%ax
80106577:	66 90                	xchg   %ax,%ax
80106579:	66 90                	xchg   %ax,%ax
8010657b:	66 90                	xchg   %ax,%ax
8010657d:	66 90                	xchg   %ax,%ax
8010657f:	90                   	nop

80106580 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106580:	f3 0f 1e fb          	endbr32 
80106584:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106585:	31 c0                	xor    %eax,%eax
{
80106587:	89 e5                	mov    %esp,%ebp
80106589:	83 ec 08             	sub    $0x8,%esp
8010658c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106590:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106597:	c7 04 c5 a2 7e 11 80 	movl   $0x8e000008,-0x7fee815e(,%eax,8)
8010659e:	08 00 00 8e 
801065a2:	66 89 14 c5 a0 7e 11 	mov    %dx,-0x7fee8160(,%eax,8)
801065a9:	80 
801065aa:	c1 ea 10             	shr    $0x10,%edx
801065ad:	66 89 14 c5 a6 7e 11 	mov    %dx,-0x7fee815a(,%eax,8)
801065b4:	80 
  for(i = 0; i < 256; i++)
801065b5:	83 c0 01             	add    $0x1,%eax
801065b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801065bd:	75 d1                	jne    80106590 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801065bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065c2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801065c7:	c7 05 a2 80 11 80 08 	movl   $0xef000008,0x801180a2
801065ce:	00 00 ef 
  initlock(&tickslock, "time");
801065d1:	68 f4 86 10 80       	push   $0x801086f4
801065d6:	68 60 7e 11 80       	push   $0x80117e60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065db:	66 a3 a0 80 11 80    	mov    %ax,0x801180a0
801065e1:	c1 e8 10             	shr    $0x10,%eax
801065e4:	66 a3 a6 80 11 80    	mov    %ax,0x801180a6
  initlock(&tickslock, "time");
801065ea:	e8 31 e9 ff ff       	call   80104f20 <initlock>
}
801065ef:	83 c4 10             	add    $0x10,%esp
801065f2:	c9                   	leave  
801065f3:	c3                   	ret    
801065f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065ff:	90                   	nop

80106600 <idtinit>:

void
idtinit(void)
{
80106600:	f3 0f 1e fb          	endbr32 
80106604:	55                   	push   %ebp
  pd[0] = size-1;
80106605:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010660a:	89 e5                	mov    %esp,%ebp
8010660c:	83 ec 10             	sub    $0x10,%esp
8010660f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106613:	b8 a0 7e 11 80       	mov    $0x80117ea0,%eax
80106618:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010661c:	c1 e8 10             	shr    $0x10,%eax
8010661f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106623:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106626:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106629:	c9                   	leave  
8010662a:	c3                   	ret    
8010662b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010662f:	90                   	nop

80106630 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106630:	f3 0f 1e fb          	endbr32 
80106634:	55                   	push   %ebp
80106635:	89 e5                	mov    %esp,%ebp
80106637:	57                   	push   %edi
80106638:	56                   	push   %esi
80106639:	53                   	push   %ebx
8010663a:	83 ec 1c             	sub    $0x1c,%esp
8010663d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106640:	8b 43 30             	mov    0x30(%ebx),%eax
80106643:	83 f8 40             	cmp    $0x40,%eax
80106646:	0f 84 bc 01 00 00    	je     80106808 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010664c:	83 e8 20             	sub    $0x20,%eax
8010664f:	83 f8 1f             	cmp    $0x1f,%eax
80106652:	77 08                	ja     8010665c <trap+0x2c>
80106654:	3e ff 24 85 9c 87 10 	notrack jmp *-0x7fef7864(,%eax,4)
8010665b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010665c:	e8 df d3 ff ff       	call   80103a40 <myproc>
80106661:	8b 7b 38             	mov    0x38(%ebx),%edi
80106664:	85 c0                	test   %eax,%eax
80106666:	0f 84 eb 01 00 00    	je     80106857 <trap+0x227>
8010666c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106670:	0f 84 e1 01 00 00    	je     80106857 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106676:	0f 20 d1             	mov    %cr2,%ecx
80106679:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010667c:	e8 9f d3 ff ff       	call   80103a20 <cpuid>
80106681:	8b 73 30             	mov    0x30(%ebx),%esi
80106684:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106687:	8b 43 34             	mov    0x34(%ebx),%eax
8010668a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010668d:	e8 ae d3 ff ff       	call   80103a40 <myproc>
80106692:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106695:	e8 a6 d3 ff ff       	call   80103a40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010669a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010669d:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066a0:	51                   	push   %ecx
801066a1:	57                   	push   %edi
801066a2:	52                   	push   %edx
801066a3:	ff 75 e4             	pushl  -0x1c(%ebp)
801066a6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801066a7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801066aa:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ad:	56                   	push   %esi
801066ae:	ff 70 10             	pushl  0x10(%eax)
801066b1:	68 58 87 10 80       	push   $0x80108758
801066b6:	e8 f5 9f ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801066bb:	83 c4 20             	add    $0x20,%esp
801066be:	e8 7d d3 ff ff       	call   80103a40 <myproc>
801066c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066ca:	e8 71 d3 ff ff       	call   80103a40 <myproc>
801066cf:	85 c0                	test   %eax,%eax
801066d1:	74 1d                	je     801066f0 <trap+0xc0>
801066d3:	e8 68 d3 ff ff       	call   80103a40 <myproc>
801066d8:	8b 50 24             	mov    0x24(%eax),%edx
801066db:	85 d2                	test   %edx,%edx
801066dd:	74 11                	je     801066f0 <trap+0xc0>
801066df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801066e3:	83 e0 03             	and    $0x3,%eax
801066e6:	66 83 f8 03          	cmp    $0x3,%ax
801066ea:	0f 84 50 01 00 00    	je     80106840 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801066f0:	e8 4b d3 ff ff       	call   80103a40 <myproc>
801066f5:	85 c0                	test   %eax,%eax
801066f7:	74 0f                	je     80106708 <trap+0xd8>
801066f9:	e8 42 d3 ff ff       	call   80103a40 <myproc>
801066fe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106702:	0f 84 e8 00 00 00    	je     801067f0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106708:	e8 33 d3 ff ff       	call   80103a40 <myproc>
8010670d:	85 c0                	test   %eax,%eax
8010670f:	74 1d                	je     8010672e <trap+0xfe>
80106711:	e8 2a d3 ff ff       	call   80103a40 <myproc>
80106716:	8b 40 24             	mov    0x24(%eax),%eax
80106719:	85 c0                	test   %eax,%eax
8010671b:	74 11                	je     8010672e <trap+0xfe>
8010671d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106721:	83 e0 03             	and    $0x3,%eax
80106724:	66 83 f8 03          	cmp    $0x3,%ax
80106728:	0f 84 03 01 00 00    	je     80106831 <trap+0x201>
    exit();
}
8010672e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106731:	5b                   	pop    %ebx
80106732:	5e                   	pop    %esi
80106733:	5f                   	pop    %edi
80106734:	5d                   	pop    %ebp
80106735:	c3                   	ret    
    ideintr();
80106736:	e8 a5 ba ff ff       	call   801021e0 <ideintr>
    lapiceoi();
8010673b:	e8 80 c1 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106740:	e8 fb d2 ff ff       	call   80103a40 <myproc>
80106745:	85 c0                	test   %eax,%eax
80106747:	75 8a                	jne    801066d3 <trap+0xa3>
80106749:	eb a5                	jmp    801066f0 <trap+0xc0>
    if(cpuid() == 0){
8010674b:	e8 d0 d2 ff ff       	call   80103a20 <cpuid>
80106750:	85 c0                	test   %eax,%eax
80106752:	75 e7                	jne    8010673b <trap+0x10b>
      acquire(&tickslock);
80106754:	83 ec 0c             	sub    $0xc,%esp
80106757:	68 60 7e 11 80       	push   $0x80117e60
8010675c:	e8 3f e9 ff ff       	call   801050a0 <acquire>
      wakeup(&ticks);
80106761:	c7 04 24 a0 86 11 80 	movl   $0x801186a0,(%esp)
      ticks++;
80106768:	83 05 a0 86 11 80 01 	addl   $0x1,0x801186a0
      wakeup(&ticks);
8010676f:	e8 6c e1 ff ff       	call   801048e0 <wakeup>
      release(&tickslock);
80106774:	c7 04 24 60 7e 11 80 	movl   $0x80117e60,(%esp)
8010677b:	e8 e0 e9 ff ff       	call   80105160 <release>
80106780:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106783:	eb b6                	jmp    8010673b <trap+0x10b>
    kbdintr();
80106785:	e8 f6 bf ff ff       	call   80102780 <kbdintr>
    lapiceoi();
8010678a:	e8 31 c1 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010678f:	e8 ac d2 ff ff       	call   80103a40 <myproc>
80106794:	85 c0                	test   %eax,%eax
80106796:	0f 85 37 ff ff ff    	jne    801066d3 <trap+0xa3>
8010679c:	e9 4f ff ff ff       	jmp    801066f0 <trap+0xc0>
    uartintr();
801067a1:	e8 4a 02 00 00       	call   801069f0 <uartintr>
    lapiceoi();
801067a6:	e8 15 c1 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067ab:	e8 90 d2 ff ff       	call   80103a40 <myproc>
801067b0:	85 c0                	test   %eax,%eax
801067b2:	0f 85 1b ff ff ff    	jne    801066d3 <trap+0xa3>
801067b8:	e9 33 ff ff ff       	jmp    801066f0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067bd:	8b 7b 38             	mov    0x38(%ebx),%edi
801067c0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801067c4:	e8 57 d2 ff ff       	call   80103a20 <cpuid>
801067c9:	57                   	push   %edi
801067ca:	56                   	push   %esi
801067cb:	50                   	push   %eax
801067cc:	68 00 87 10 80       	push   $0x80108700
801067d1:	e8 da 9e ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801067d6:	e8 e5 c0 ff ff       	call   801028c0 <lapiceoi>
    break;
801067db:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067de:	e8 5d d2 ff ff       	call   80103a40 <myproc>
801067e3:	85 c0                	test   %eax,%eax
801067e5:	0f 85 e8 fe ff ff    	jne    801066d3 <trap+0xa3>
801067eb:	e9 00 ff ff ff       	jmp    801066f0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801067f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801067f4:	0f 85 0e ff ff ff    	jne    80106708 <trap+0xd8>
    yield();
801067fa:	e8 81 de ff ff       	call   80104680 <yield>
801067ff:	e9 04 ff ff ff       	jmp    80106708 <trap+0xd8>
80106804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106808:	e8 33 d2 ff ff       	call   80103a40 <myproc>
8010680d:	8b 70 24             	mov    0x24(%eax),%esi
80106810:	85 f6                	test   %esi,%esi
80106812:	75 3c                	jne    80106850 <trap+0x220>
    myproc()->tf = tf;
80106814:	e8 27 d2 ff ff       	call   80103a40 <myproc>
80106819:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010681c:	e8 5f ed ff ff       	call   80105580 <syscall>
    if(myproc()->killed)
80106821:	e8 1a d2 ff ff       	call   80103a40 <myproc>
80106826:	8b 48 24             	mov    0x24(%eax),%ecx
80106829:	85 c9                	test   %ecx,%ecx
8010682b:	0f 84 fd fe ff ff    	je     8010672e <trap+0xfe>
}
80106831:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106834:	5b                   	pop    %ebx
80106835:	5e                   	pop    %esi
80106836:	5f                   	pop    %edi
80106837:	5d                   	pop    %ebp
      exit();
80106838:	e9 03 dd ff ff       	jmp    80104540 <exit>
8010683d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106840:	e8 fb dc ff ff       	call   80104540 <exit>
80106845:	e9 a6 fe ff ff       	jmp    801066f0 <trap+0xc0>
8010684a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106850:	e8 eb dc ff ff       	call   80104540 <exit>
80106855:	eb bd                	jmp    80106814 <trap+0x1e4>
80106857:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010685a:	e8 c1 d1 ff ff       	call   80103a20 <cpuid>
8010685f:	83 ec 0c             	sub    $0xc,%esp
80106862:	56                   	push   %esi
80106863:	57                   	push   %edi
80106864:	50                   	push   %eax
80106865:	ff 73 30             	pushl  0x30(%ebx)
80106868:	68 24 87 10 80       	push   $0x80108724
8010686d:	e8 3e 9e ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106872:	83 c4 14             	add    $0x14,%esp
80106875:	68 f9 86 10 80       	push   $0x801086f9
8010687a:	e8 11 9b ff ff       	call   80100390 <panic>
8010687f:	90                   	nop

80106880 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106880:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106884:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106889:	85 c0                	test   %eax,%eax
8010688b:	74 1b                	je     801068a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010688d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106892:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106893:	a8 01                	test   $0x1,%al
80106895:	74 11                	je     801068a8 <uartgetc+0x28>
80106897:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010689c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010689d:	0f b6 c0             	movzbl %al,%eax
801068a0:	c3                   	ret    
801068a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801068a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068ad:	c3                   	ret    
801068ae:	66 90                	xchg   %ax,%ax

801068b0 <uartputc.part.0>:
uartputc(int c)
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	89 c7                	mov    %eax,%edi
801068b6:	56                   	push   %esi
801068b7:	be fd 03 00 00       	mov    $0x3fd,%esi
801068bc:	53                   	push   %ebx
801068bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801068c2:	83 ec 0c             	sub    $0xc,%esp
801068c5:	eb 1b                	jmp    801068e2 <uartputc.part.0+0x32>
801068c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801068d0:	83 ec 0c             	sub    $0xc,%esp
801068d3:	6a 0a                	push   $0xa
801068d5:	e8 06 c0 ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068da:	83 c4 10             	add    $0x10,%esp
801068dd:	83 eb 01             	sub    $0x1,%ebx
801068e0:	74 07                	je     801068e9 <uartputc.part.0+0x39>
801068e2:	89 f2                	mov    %esi,%edx
801068e4:	ec                   	in     (%dx),%al
801068e5:	a8 20                	test   $0x20,%al
801068e7:	74 e7                	je     801068d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068ee:	89 f8                	mov    %edi,%eax
801068f0:	ee                   	out    %al,(%dx)
}
801068f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068f4:	5b                   	pop    %ebx
801068f5:	5e                   	pop    %esi
801068f6:	5f                   	pop    %edi
801068f7:	5d                   	pop    %ebp
801068f8:	c3                   	ret    
801068f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106900 <uartinit>:
{
80106900:	f3 0f 1e fb          	endbr32 
80106904:	55                   	push   %ebp
80106905:	31 c9                	xor    %ecx,%ecx
80106907:	89 c8                	mov    %ecx,%eax
80106909:	89 e5                	mov    %esp,%ebp
8010690b:	57                   	push   %edi
8010690c:	56                   	push   %esi
8010690d:	53                   	push   %ebx
8010690e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106913:	89 da                	mov    %ebx,%edx
80106915:	83 ec 0c             	sub    $0xc,%esp
80106918:	ee                   	out    %al,(%dx)
80106919:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010691e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106923:	89 fa                	mov    %edi,%edx
80106925:	ee                   	out    %al,(%dx)
80106926:	b8 0c 00 00 00       	mov    $0xc,%eax
8010692b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106930:	ee                   	out    %al,(%dx)
80106931:	be f9 03 00 00       	mov    $0x3f9,%esi
80106936:	89 c8                	mov    %ecx,%eax
80106938:	89 f2                	mov    %esi,%edx
8010693a:	ee                   	out    %al,(%dx)
8010693b:	b8 03 00 00 00       	mov    $0x3,%eax
80106940:	89 fa                	mov    %edi,%edx
80106942:	ee                   	out    %al,(%dx)
80106943:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106948:	89 c8                	mov    %ecx,%eax
8010694a:	ee                   	out    %al,(%dx)
8010694b:	b8 01 00 00 00       	mov    $0x1,%eax
80106950:	89 f2                	mov    %esi,%edx
80106952:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106953:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106958:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106959:	3c ff                	cmp    $0xff,%al
8010695b:	74 52                	je     801069af <uartinit+0xaf>
  uart = 1;
8010695d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106964:	00 00 00 
80106967:	89 da                	mov    %ebx,%edx
80106969:	ec                   	in     (%dx),%al
8010696a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010696f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106970:	83 ec 08             	sub    $0x8,%esp
80106973:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106978:	bb 1c 88 10 80       	mov    $0x8010881c,%ebx
  ioapicenable(IRQ_COM1, 0);
8010697d:	6a 00                	push   $0x0
8010697f:	6a 04                	push   $0x4
80106981:	e8 aa ba ff ff       	call   80102430 <ioapicenable>
80106986:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106989:	b8 78 00 00 00       	mov    $0x78,%eax
8010698e:	eb 04                	jmp    80106994 <uartinit+0x94>
80106990:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106994:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010699a:	85 d2                	test   %edx,%edx
8010699c:	74 08                	je     801069a6 <uartinit+0xa6>
    uartputc(*p);
8010699e:	0f be c0             	movsbl %al,%eax
801069a1:	e8 0a ff ff ff       	call   801068b0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801069a6:	89 f0                	mov    %esi,%eax
801069a8:	83 c3 01             	add    $0x1,%ebx
801069ab:	84 c0                	test   %al,%al
801069ad:	75 e1                	jne    80106990 <uartinit+0x90>
}
801069af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069b2:	5b                   	pop    %ebx
801069b3:	5e                   	pop    %esi
801069b4:	5f                   	pop    %edi
801069b5:	5d                   	pop    %ebp
801069b6:	c3                   	ret    
801069b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069be:	66 90                	xchg   %ax,%ax

801069c0 <uartputc>:
{
801069c0:	f3 0f 1e fb          	endbr32 
801069c4:	55                   	push   %ebp
  if(!uart)
801069c5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801069cb:	89 e5                	mov    %esp,%ebp
801069cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801069d0:	85 d2                	test   %edx,%edx
801069d2:	74 0c                	je     801069e0 <uartputc+0x20>
}
801069d4:	5d                   	pop    %ebp
801069d5:	e9 d6 fe ff ff       	jmp    801068b0 <uartputc.part.0>
801069da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069e0:	5d                   	pop    %ebp
801069e1:	c3                   	ret    
801069e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069f0 <uartintr>:

void
uartintr(void)
{
801069f0:	f3 0f 1e fb          	endbr32 
801069f4:	55                   	push   %ebp
801069f5:	89 e5                	mov    %esp,%ebp
801069f7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801069fa:	68 80 68 10 80       	push   $0x80106880
801069ff:	e8 5c 9e ff ff       	call   80100860 <consoleintr>
}
80106a04:	83 c4 10             	add    $0x10,%esp
80106a07:	c9                   	leave  
80106a08:	c3                   	ret    

80106a09 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $0
80106a0b:	6a 00                	push   $0x0
  jmp alltraps
80106a0d:	e9 40 fb ff ff       	jmp    80106552 <alltraps>

80106a12 <vector1>:
.globl vector1
vector1:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $1
80106a14:	6a 01                	push   $0x1
  jmp alltraps
80106a16:	e9 37 fb ff ff       	jmp    80106552 <alltraps>

80106a1b <vector2>:
.globl vector2
vector2:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $2
80106a1d:	6a 02                	push   $0x2
  jmp alltraps
80106a1f:	e9 2e fb ff ff       	jmp    80106552 <alltraps>

80106a24 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $3
80106a26:	6a 03                	push   $0x3
  jmp alltraps
80106a28:	e9 25 fb ff ff       	jmp    80106552 <alltraps>

80106a2d <vector4>:
.globl vector4
vector4:
  pushl $0
80106a2d:	6a 00                	push   $0x0
  pushl $4
80106a2f:	6a 04                	push   $0x4
  jmp alltraps
80106a31:	e9 1c fb ff ff       	jmp    80106552 <alltraps>

80106a36 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a36:	6a 00                	push   $0x0
  pushl $5
80106a38:	6a 05                	push   $0x5
  jmp alltraps
80106a3a:	e9 13 fb ff ff       	jmp    80106552 <alltraps>

80106a3f <vector6>:
.globl vector6
vector6:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $6
80106a41:	6a 06                	push   $0x6
  jmp alltraps
80106a43:	e9 0a fb ff ff       	jmp    80106552 <alltraps>

80106a48 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a48:	6a 00                	push   $0x0
  pushl $7
80106a4a:	6a 07                	push   $0x7
  jmp alltraps
80106a4c:	e9 01 fb ff ff       	jmp    80106552 <alltraps>

80106a51 <vector8>:
.globl vector8
vector8:
  pushl $8
80106a51:	6a 08                	push   $0x8
  jmp alltraps
80106a53:	e9 fa fa ff ff       	jmp    80106552 <alltraps>

80106a58 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $9
80106a5a:	6a 09                	push   $0x9
  jmp alltraps
80106a5c:	e9 f1 fa ff ff       	jmp    80106552 <alltraps>

80106a61 <vector10>:
.globl vector10
vector10:
  pushl $10
80106a61:	6a 0a                	push   $0xa
  jmp alltraps
80106a63:	e9 ea fa ff ff       	jmp    80106552 <alltraps>

80106a68 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a68:	6a 0b                	push   $0xb
  jmp alltraps
80106a6a:	e9 e3 fa ff ff       	jmp    80106552 <alltraps>

80106a6f <vector12>:
.globl vector12
vector12:
  pushl $12
80106a6f:	6a 0c                	push   $0xc
  jmp alltraps
80106a71:	e9 dc fa ff ff       	jmp    80106552 <alltraps>

80106a76 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a76:	6a 0d                	push   $0xd
  jmp alltraps
80106a78:	e9 d5 fa ff ff       	jmp    80106552 <alltraps>

80106a7d <vector14>:
.globl vector14
vector14:
  pushl $14
80106a7d:	6a 0e                	push   $0xe
  jmp alltraps
80106a7f:	e9 ce fa ff ff       	jmp    80106552 <alltraps>

80106a84 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $15
80106a86:	6a 0f                	push   $0xf
  jmp alltraps
80106a88:	e9 c5 fa ff ff       	jmp    80106552 <alltraps>

80106a8d <vector16>:
.globl vector16
vector16:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $16
80106a8f:	6a 10                	push   $0x10
  jmp alltraps
80106a91:	e9 bc fa ff ff       	jmp    80106552 <alltraps>

80106a96 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a96:	6a 11                	push   $0x11
  jmp alltraps
80106a98:	e9 b5 fa ff ff       	jmp    80106552 <alltraps>

80106a9d <vector18>:
.globl vector18
vector18:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $18
80106a9f:	6a 12                	push   $0x12
  jmp alltraps
80106aa1:	e9 ac fa ff ff       	jmp    80106552 <alltraps>

80106aa6 <vector19>:
.globl vector19
vector19:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $19
80106aa8:	6a 13                	push   $0x13
  jmp alltraps
80106aaa:	e9 a3 fa ff ff       	jmp    80106552 <alltraps>

80106aaf <vector20>:
.globl vector20
vector20:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $20
80106ab1:	6a 14                	push   $0x14
  jmp alltraps
80106ab3:	e9 9a fa ff ff       	jmp    80106552 <alltraps>

80106ab8 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $21
80106aba:	6a 15                	push   $0x15
  jmp alltraps
80106abc:	e9 91 fa ff ff       	jmp    80106552 <alltraps>

80106ac1 <vector22>:
.globl vector22
vector22:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $22
80106ac3:	6a 16                	push   $0x16
  jmp alltraps
80106ac5:	e9 88 fa ff ff       	jmp    80106552 <alltraps>

80106aca <vector23>:
.globl vector23
vector23:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $23
80106acc:	6a 17                	push   $0x17
  jmp alltraps
80106ace:	e9 7f fa ff ff       	jmp    80106552 <alltraps>

80106ad3 <vector24>:
.globl vector24
vector24:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $24
80106ad5:	6a 18                	push   $0x18
  jmp alltraps
80106ad7:	e9 76 fa ff ff       	jmp    80106552 <alltraps>

80106adc <vector25>:
.globl vector25
vector25:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $25
80106ade:	6a 19                	push   $0x19
  jmp alltraps
80106ae0:	e9 6d fa ff ff       	jmp    80106552 <alltraps>

80106ae5 <vector26>:
.globl vector26
vector26:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $26
80106ae7:	6a 1a                	push   $0x1a
  jmp alltraps
80106ae9:	e9 64 fa ff ff       	jmp    80106552 <alltraps>

80106aee <vector27>:
.globl vector27
vector27:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $27
80106af0:	6a 1b                	push   $0x1b
  jmp alltraps
80106af2:	e9 5b fa ff ff       	jmp    80106552 <alltraps>

80106af7 <vector28>:
.globl vector28
vector28:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $28
80106af9:	6a 1c                	push   $0x1c
  jmp alltraps
80106afb:	e9 52 fa ff ff       	jmp    80106552 <alltraps>

80106b00 <vector29>:
.globl vector29
vector29:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $29
80106b02:	6a 1d                	push   $0x1d
  jmp alltraps
80106b04:	e9 49 fa ff ff       	jmp    80106552 <alltraps>

80106b09 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $30
80106b0b:	6a 1e                	push   $0x1e
  jmp alltraps
80106b0d:	e9 40 fa ff ff       	jmp    80106552 <alltraps>

80106b12 <vector31>:
.globl vector31
vector31:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $31
80106b14:	6a 1f                	push   $0x1f
  jmp alltraps
80106b16:	e9 37 fa ff ff       	jmp    80106552 <alltraps>

80106b1b <vector32>:
.globl vector32
vector32:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $32
80106b1d:	6a 20                	push   $0x20
  jmp alltraps
80106b1f:	e9 2e fa ff ff       	jmp    80106552 <alltraps>

80106b24 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $33
80106b26:	6a 21                	push   $0x21
  jmp alltraps
80106b28:	e9 25 fa ff ff       	jmp    80106552 <alltraps>

80106b2d <vector34>:
.globl vector34
vector34:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $34
80106b2f:	6a 22                	push   $0x22
  jmp alltraps
80106b31:	e9 1c fa ff ff       	jmp    80106552 <alltraps>

80106b36 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $35
80106b38:	6a 23                	push   $0x23
  jmp alltraps
80106b3a:	e9 13 fa ff ff       	jmp    80106552 <alltraps>

80106b3f <vector36>:
.globl vector36
vector36:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $36
80106b41:	6a 24                	push   $0x24
  jmp alltraps
80106b43:	e9 0a fa ff ff       	jmp    80106552 <alltraps>

80106b48 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $37
80106b4a:	6a 25                	push   $0x25
  jmp alltraps
80106b4c:	e9 01 fa ff ff       	jmp    80106552 <alltraps>

80106b51 <vector38>:
.globl vector38
vector38:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $38
80106b53:	6a 26                	push   $0x26
  jmp alltraps
80106b55:	e9 f8 f9 ff ff       	jmp    80106552 <alltraps>

80106b5a <vector39>:
.globl vector39
vector39:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $39
80106b5c:	6a 27                	push   $0x27
  jmp alltraps
80106b5e:	e9 ef f9 ff ff       	jmp    80106552 <alltraps>

80106b63 <vector40>:
.globl vector40
vector40:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $40
80106b65:	6a 28                	push   $0x28
  jmp alltraps
80106b67:	e9 e6 f9 ff ff       	jmp    80106552 <alltraps>

80106b6c <vector41>:
.globl vector41
vector41:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $41
80106b6e:	6a 29                	push   $0x29
  jmp alltraps
80106b70:	e9 dd f9 ff ff       	jmp    80106552 <alltraps>

80106b75 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $42
80106b77:	6a 2a                	push   $0x2a
  jmp alltraps
80106b79:	e9 d4 f9 ff ff       	jmp    80106552 <alltraps>

80106b7e <vector43>:
.globl vector43
vector43:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $43
80106b80:	6a 2b                	push   $0x2b
  jmp alltraps
80106b82:	e9 cb f9 ff ff       	jmp    80106552 <alltraps>

80106b87 <vector44>:
.globl vector44
vector44:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $44
80106b89:	6a 2c                	push   $0x2c
  jmp alltraps
80106b8b:	e9 c2 f9 ff ff       	jmp    80106552 <alltraps>

80106b90 <vector45>:
.globl vector45
vector45:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $45
80106b92:	6a 2d                	push   $0x2d
  jmp alltraps
80106b94:	e9 b9 f9 ff ff       	jmp    80106552 <alltraps>

80106b99 <vector46>:
.globl vector46
vector46:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $46
80106b9b:	6a 2e                	push   $0x2e
  jmp alltraps
80106b9d:	e9 b0 f9 ff ff       	jmp    80106552 <alltraps>

80106ba2 <vector47>:
.globl vector47
vector47:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $47
80106ba4:	6a 2f                	push   $0x2f
  jmp alltraps
80106ba6:	e9 a7 f9 ff ff       	jmp    80106552 <alltraps>

80106bab <vector48>:
.globl vector48
vector48:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $48
80106bad:	6a 30                	push   $0x30
  jmp alltraps
80106baf:	e9 9e f9 ff ff       	jmp    80106552 <alltraps>

80106bb4 <vector49>:
.globl vector49
vector49:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $49
80106bb6:	6a 31                	push   $0x31
  jmp alltraps
80106bb8:	e9 95 f9 ff ff       	jmp    80106552 <alltraps>

80106bbd <vector50>:
.globl vector50
vector50:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $50
80106bbf:	6a 32                	push   $0x32
  jmp alltraps
80106bc1:	e9 8c f9 ff ff       	jmp    80106552 <alltraps>

80106bc6 <vector51>:
.globl vector51
vector51:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $51
80106bc8:	6a 33                	push   $0x33
  jmp alltraps
80106bca:	e9 83 f9 ff ff       	jmp    80106552 <alltraps>

80106bcf <vector52>:
.globl vector52
vector52:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $52
80106bd1:	6a 34                	push   $0x34
  jmp alltraps
80106bd3:	e9 7a f9 ff ff       	jmp    80106552 <alltraps>

80106bd8 <vector53>:
.globl vector53
vector53:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $53
80106bda:	6a 35                	push   $0x35
  jmp alltraps
80106bdc:	e9 71 f9 ff ff       	jmp    80106552 <alltraps>

80106be1 <vector54>:
.globl vector54
vector54:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $54
80106be3:	6a 36                	push   $0x36
  jmp alltraps
80106be5:	e9 68 f9 ff ff       	jmp    80106552 <alltraps>

80106bea <vector55>:
.globl vector55
vector55:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $55
80106bec:	6a 37                	push   $0x37
  jmp alltraps
80106bee:	e9 5f f9 ff ff       	jmp    80106552 <alltraps>

80106bf3 <vector56>:
.globl vector56
vector56:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $56
80106bf5:	6a 38                	push   $0x38
  jmp alltraps
80106bf7:	e9 56 f9 ff ff       	jmp    80106552 <alltraps>

80106bfc <vector57>:
.globl vector57
vector57:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $57
80106bfe:	6a 39                	push   $0x39
  jmp alltraps
80106c00:	e9 4d f9 ff ff       	jmp    80106552 <alltraps>

80106c05 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $58
80106c07:	6a 3a                	push   $0x3a
  jmp alltraps
80106c09:	e9 44 f9 ff ff       	jmp    80106552 <alltraps>

80106c0e <vector59>:
.globl vector59
vector59:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $59
80106c10:	6a 3b                	push   $0x3b
  jmp alltraps
80106c12:	e9 3b f9 ff ff       	jmp    80106552 <alltraps>

80106c17 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $60
80106c19:	6a 3c                	push   $0x3c
  jmp alltraps
80106c1b:	e9 32 f9 ff ff       	jmp    80106552 <alltraps>

80106c20 <vector61>:
.globl vector61
vector61:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $61
80106c22:	6a 3d                	push   $0x3d
  jmp alltraps
80106c24:	e9 29 f9 ff ff       	jmp    80106552 <alltraps>

80106c29 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $62
80106c2b:	6a 3e                	push   $0x3e
  jmp alltraps
80106c2d:	e9 20 f9 ff ff       	jmp    80106552 <alltraps>

80106c32 <vector63>:
.globl vector63
vector63:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $63
80106c34:	6a 3f                	push   $0x3f
  jmp alltraps
80106c36:	e9 17 f9 ff ff       	jmp    80106552 <alltraps>

80106c3b <vector64>:
.globl vector64
vector64:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $64
80106c3d:	6a 40                	push   $0x40
  jmp alltraps
80106c3f:	e9 0e f9 ff ff       	jmp    80106552 <alltraps>

80106c44 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $65
80106c46:	6a 41                	push   $0x41
  jmp alltraps
80106c48:	e9 05 f9 ff ff       	jmp    80106552 <alltraps>

80106c4d <vector66>:
.globl vector66
vector66:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $66
80106c4f:	6a 42                	push   $0x42
  jmp alltraps
80106c51:	e9 fc f8 ff ff       	jmp    80106552 <alltraps>

80106c56 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $67
80106c58:	6a 43                	push   $0x43
  jmp alltraps
80106c5a:	e9 f3 f8 ff ff       	jmp    80106552 <alltraps>

80106c5f <vector68>:
.globl vector68
vector68:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $68
80106c61:	6a 44                	push   $0x44
  jmp alltraps
80106c63:	e9 ea f8 ff ff       	jmp    80106552 <alltraps>

80106c68 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $69
80106c6a:	6a 45                	push   $0x45
  jmp alltraps
80106c6c:	e9 e1 f8 ff ff       	jmp    80106552 <alltraps>

80106c71 <vector70>:
.globl vector70
vector70:
  pushl $0
80106c71:	6a 00                	push   $0x0
  pushl $70
80106c73:	6a 46                	push   $0x46
  jmp alltraps
80106c75:	e9 d8 f8 ff ff       	jmp    80106552 <alltraps>

80106c7a <vector71>:
.globl vector71
vector71:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $71
80106c7c:	6a 47                	push   $0x47
  jmp alltraps
80106c7e:	e9 cf f8 ff ff       	jmp    80106552 <alltraps>

80106c83 <vector72>:
.globl vector72
vector72:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $72
80106c85:	6a 48                	push   $0x48
  jmp alltraps
80106c87:	e9 c6 f8 ff ff       	jmp    80106552 <alltraps>

80106c8c <vector73>:
.globl vector73
vector73:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $73
80106c8e:	6a 49                	push   $0x49
  jmp alltraps
80106c90:	e9 bd f8 ff ff       	jmp    80106552 <alltraps>

80106c95 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $74
80106c97:	6a 4a                	push   $0x4a
  jmp alltraps
80106c99:	e9 b4 f8 ff ff       	jmp    80106552 <alltraps>

80106c9e <vector75>:
.globl vector75
vector75:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $75
80106ca0:	6a 4b                	push   $0x4b
  jmp alltraps
80106ca2:	e9 ab f8 ff ff       	jmp    80106552 <alltraps>

80106ca7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $76
80106ca9:	6a 4c                	push   $0x4c
  jmp alltraps
80106cab:	e9 a2 f8 ff ff       	jmp    80106552 <alltraps>

80106cb0 <vector77>:
.globl vector77
vector77:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $77
80106cb2:	6a 4d                	push   $0x4d
  jmp alltraps
80106cb4:	e9 99 f8 ff ff       	jmp    80106552 <alltraps>

80106cb9 <vector78>:
.globl vector78
vector78:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $78
80106cbb:	6a 4e                	push   $0x4e
  jmp alltraps
80106cbd:	e9 90 f8 ff ff       	jmp    80106552 <alltraps>

80106cc2 <vector79>:
.globl vector79
vector79:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $79
80106cc4:	6a 4f                	push   $0x4f
  jmp alltraps
80106cc6:	e9 87 f8 ff ff       	jmp    80106552 <alltraps>

80106ccb <vector80>:
.globl vector80
vector80:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $80
80106ccd:	6a 50                	push   $0x50
  jmp alltraps
80106ccf:	e9 7e f8 ff ff       	jmp    80106552 <alltraps>

80106cd4 <vector81>:
.globl vector81
vector81:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $81
80106cd6:	6a 51                	push   $0x51
  jmp alltraps
80106cd8:	e9 75 f8 ff ff       	jmp    80106552 <alltraps>

80106cdd <vector82>:
.globl vector82
vector82:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $82
80106cdf:	6a 52                	push   $0x52
  jmp alltraps
80106ce1:	e9 6c f8 ff ff       	jmp    80106552 <alltraps>

80106ce6 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $83
80106ce8:	6a 53                	push   $0x53
  jmp alltraps
80106cea:	e9 63 f8 ff ff       	jmp    80106552 <alltraps>

80106cef <vector84>:
.globl vector84
vector84:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $84
80106cf1:	6a 54                	push   $0x54
  jmp alltraps
80106cf3:	e9 5a f8 ff ff       	jmp    80106552 <alltraps>

80106cf8 <vector85>:
.globl vector85
vector85:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $85
80106cfa:	6a 55                	push   $0x55
  jmp alltraps
80106cfc:	e9 51 f8 ff ff       	jmp    80106552 <alltraps>

80106d01 <vector86>:
.globl vector86
vector86:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $86
80106d03:	6a 56                	push   $0x56
  jmp alltraps
80106d05:	e9 48 f8 ff ff       	jmp    80106552 <alltraps>

80106d0a <vector87>:
.globl vector87
vector87:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $87
80106d0c:	6a 57                	push   $0x57
  jmp alltraps
80106d0e:	e9 3f f8 ff ff       	jmp    80106552 <alltraps>

80106d13 <vector88>:
.globl vector88
vector88:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $88
80106d15:	6a 58                	push   $0x58
  jmp alltraps
80106d17:	e9 36 f8 ff ff       	jmp    80106552 <alltraps>

80106d1c <vector89>:
.globl vector89
vector89:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $89
80106d1e:	6a 59                	push   $0x59
  jmp alltraps
80106d20:	e9 2d f8 ff ff       	jmp    80106552 <alltraps>

80106d25 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $90
80106d27:	6a 5a                	push   $0x5a
  jmp alltraps
80106d29:	e9 24 f8 ff ff       	jmp    80106552 <alltraps>

80106d2e <vector91>:
.globl vector91
vector91:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $91
80106d30:	6a 5b                	push   $0x5b
  jmp alltraps
80106d32:	e9 1b f8 ff ff       	jmp    80106552 <alltraps>

80106d37 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $92
80106d39:	6a 5c                	push   $0x5c
  jmp alltraps
80106d3b:	e9 12 f8 ff ff       	jmp    80106552 <alltraps>

80106d40 <vector93>:
.globl vector93
vector93:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $93
80106d42:	6a 5d                	push   $0x5d
  jmp alltraps
80106d44:	e9 09 f8 ff ff       	jmp    80106552 <alltraps>

80106d49 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $94
80106d4b:	6a 5e                	push   $0x5e
  jmp alltraps
80106d4d:	e9 00 f8 ff ff       	jmp    80106552 <alltraps>

80106d52 <vector95>:
.globl vector95
vector95:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $95
80106d54:	6a 5f                	push   $0x5f
  jmp alltraps
80106d56:	e9 f7 f7 ff ff       	jmp    80106552 <alltraps>

80106d5b <vector96>:
.globl vector96
vector96:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $96
80106d5d:	6a 60                	push   $0x60
  jmp alltraps
80106d5f:	e9 ee f7 ff ff       	jmp    80106552 <alltraps>

80106d64 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $97
80106d66:	6a 61                	push   $0x61
  jmp alltraps
80106d68:	e9 e5 f7 ff ff       	jmp    80106552 <alltraps>

80106d6d <vector98>:
.globl vector98
vector98:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $98
80106d6f:	6a 62                	push   $0x62
  jmp alltraps
80106d71:	e9 dc f7 ff ff       	jmp    80106552 <alltraps>

80106d76 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $99
80106d78:	6a 63                	push   $0x63
  jmp alltraps
80106d7a:	e9 d3 f7 ff ff       	jmp    80106552 <alltraps>

80106d7f <vector100>:
.globl vector100
vector100:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $100
80106d81:	6a 64                	push   $0x64
  jmp alltraps
80106d83:	e9 ca f7 ff ff       	jmp    80106552 <alltraps>

80106d88 <vector101>:
.globl vector101
vector101:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $101
80106d8a:	6a 65                	push   $0x65
  jmp alltraps
80106d8c:	e9 c1 f7 ff ff       	jmp    80106552 <alltraps>

80106d91 <vector102>:
.globl vector102
vector102:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $102
80106d93:	6a 66                	push   $0x66
  jmp alltraps
80106d95:	e9 b8 f7 ff ff       	jmp    80106552 <alltraps>

80106d9a <vector103>:
.globl vector103
vector103:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $103
80106d9c:	6a 67                	push   $0x67
  jmp alltraps
80106d9e:	e9 af f7 ff ff       	jmp    80106552 <alltraps>

80106da3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $104
80106da5:	6a 68                	push   $0x68
  jmp alltraps
80106da7:	e9 a6 f7 ff ff       	jmp    80106552 <alltraps>

80106dac <vector105>:
.globl vector105
vector105:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $105
80106dae:	6a 69                	push   $0x69
  jmp alltraps
80106db0:	e9 9d f7 ff ff       	jmp    80106552 <alltraps>

80106db5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $106
80106db7:	6a 6a                	push   $0x6a
  jmp alltraps
80106db9:	e9 94 f7 ff ff       	jmp    80106552 <alltraps>

80106dbe <vector107>:
.globl vector107
vector107:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $107
80106dc0:	6a 6b                	push   $0x6b
  jmp alltraps
80106dc2:	e9 8b f7 ff ff       	jmp    80106552 <alltraps>

80106dc7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $108
80106dc9:	6a 6c                	push   $0x6c
  jmp alltraps
80106dcb:	e9 82 f7 ff ff       	jmp    80106552 <alltraps>

80106dd0 <vector109>:
.globl vector109
vector109:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $109
80106dd2:	6a 6d                	push   $0x6d
  jmp alltraps
80106dd4:	e9 79 f7 ff ff       	jmp    80106552 <alltraps>

80106dd9 <vector110>:
.globl vector110
vector110:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $110
80106ddb:	6a 6e                	push   $0x6e
  jmp alltraps
80106ddd:	e9 70 f7 ff ff       	jmp    80106552 <alltraps>

80106de2 <vector111>:
.globl vector111
vector111:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $111
80106de4:	6a 6f                	push   $0x6f
  jmp alltraps
80106de6:	e9 67 f7 ff ff       	jmp    80106552 <alltraps>

80106deb <vector112>:
.globl vector112
vector112:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $112
80106ded:	6a 70                	push   $0x70
  jmp alltraps
80106def:	e9 5e f7 ff ff       	jmp    80106552 <alltraps>

80106df4 <vector113>:
.globl vector113
vector113:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $113
80106df6:	6a 71                	push   $0x71
  jmp alltraps
80106df8:	e9 55 f7 ff ff       	jmp    80106552 <alltraps>

80106dfd <vector114>:
.globl vector114
vector114:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $114
80106dff:	6a 72                	push   $0x72
  jmp alltraps
80106e01:	e9 4c f7 ff ff       	jmp    80106552 <alltraps>

80106e06 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $115
80106e08:	6a 73                	push   $0x73
  jmp alltraps
80106e0a:	e9 43 f7 ff ff       	jmp    80106552 <alltraps>

80106e0f <vector116>:
.globl vector116
vector116:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $116
80106e11:	6a 74                	push   $0x74
  jmp alltraps
80106e13:	e9 3a f7 ff ff       	jmp    80106552 <alltraps>

80106e18 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $117
80106e1a:	6a 75                	push   $0x75
  jmp alltraps
80106e1c:	e9 31 f7 ff ff       	jmp    80106552 <alltraps>

80106e21 <vector118>:
.globl vector118
vector118:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $118
80106e23:	6a 76                	push   $0x76
  jmp alltraps
80106e25:	e9 28 f7 ff ff       	jmp    80106552 <alltraps>

80106e2a <vector119>:
.globl vector119
vector119:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $119
80106e2c:	6a 77                	push   $0x77
  jmp alltraps
80106e2e:	e9 1f f7 ff ff       	jmp    80106552 <alltraps>

80106e33 <vector120>:
.globl vector120
vector120:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $120
80106e35:	6a 78                	push   $0x78
  jmp alltraps
80106e37:	e9 16 f7 ff ff       	jmp    80106552 <alltraps>

80106e3c <vector121>:
.globl vector121
vector121:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $121
80106e3e:	6a 79                	push   $0x79
  jmp alltraps
80106e40:	e9 0d f7 ff ff       	jmp    80106552 <alltraps>

80106e45 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $122
80106e47:	6a 7a                	push   $0x7a
  jmp alltraps
80106e49:	e9 04 f7 ff ff       	jmp    80106552 <alltraps>

80106e4e <vector123>:
.globl vector123
vector123:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $123
80106e50:	6a 7b                	push   $0x7b
  jmp alltraps
80106e52:	e9 fb f6 ff ff       	jmp    80106552 <alltraps>

80106e57 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $124
80106e59:	6a 7c                	push   $0x7c
  jmp alltraps
80106e5b:	e9 f2 f6 ff ff       	jmp    80106552 <alltraps>

80106e60 <vector125>:
.globl vector125
vector125:
  pushl $0
80106e60:	6a 00                	push   $0x0
  pushl $125
80106e62:	6a 7d                	push   $0x7d
  jmp alltraps
80106e64:	e9 e9 f6 ff ff       	jmp    80106552 <alltraps>

80106e69 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $126
80106e6b:	6a 7e                	push   $0x7e
  jmp alltraps
80106e6d:	e9 e0 f6 ff ff       	jmp    80106552 <alltraps>

80106e72 <vector127>:
.globl vector127
vector127:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $127
80106e74:	6a 7f                	push   $0x7f
  jmp alltraps
80106e76:	e9 d7 f6 ff ff       	jmp    80106552 <alltraps>

80106e7b <vector128>:
.globl vector128
vector128:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $128
80106e7d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e82:	e9 cb f6 ff ff       	jmp    80106552 <alltraps>

80106e87 <vector129>:
.globl vector129
vector129:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $129
80106e89:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e8e:	e9 bf f6 ff ff       	jmp    80106552 <alltraps>

80106e93 <vector130>:
.globl vector130
vector130:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $130
80106e95:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e9a:	e9 b3 f6 ff ff       	jmp    80106552 <alltraps>

80106e9f <vector131>:
.globl vector131
vector131:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $131
80106ea1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ea6:	e9 a7 f6 ff ff       	jmp    80106552 <alltraps>

80106eab <vector132>:
.globl vector132
vector132:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $132
80106ead:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106eb2:	e9 9b f6 ff ff       	jmp    80106552 <alltraps>

80106eb7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $133
80106eb9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106ebe:	e9 8f f6 ff ff       	jmp    80106552 <alltraps>

80106ec3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $134
80106ec5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106eca:	e9 83 f6 ff ff       	jmp    80106552 <alltraps>

80106ecf <vector135>:
.globl vector135
vector135:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $135
80106ed1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ed6:	e9 77 f6 ff ff       	jmp    80106552 <alltraps>

80106edb <vector136>:
.globl vector136
vector136:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $136
80106edd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ee2:	e9 6b f6 ff ff       	jmp    80106552 <alltraps>

80106ee7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $137
80106ee9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106eee:	e9 5f f6 ff ff       	jmp    80106552 <alltraps>

80106ef3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $138
80106ef5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106efa:	e9 53 f6 ff ff       	jmp    80106552 <alltraps>

80106eff <vector139>:
.globl vector139
vector139:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $139
80106f01:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f06:	e9 47 f6 ff ff       	jmp    80106552 <alltraps>

80106f0b <vector140>:
.globl vector140
vector140:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $140
80106f0d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f12:	e9 3b f6 ff ff       	jmp    80106552 <alltraps>

80106f17 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $141
80106f19:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f1e:	e9 2f f6 ff ff       	jmp    80106552 <alltraps>

80106f23 <vector142>:
.globl vector142
vector142:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $142
80106f25:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f2a:	e9 23 f6 ff ff       	jmp    80106552 <alltraps>

80106f2f <vector143>:
.globl vector143
vector143:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $143
80106f31:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f36:	e9 17 f6 ff ff       	jmp    80106552 <alltraps>

80106f3b <vector144>:
.globl vector144
vector144:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $144
80106f3d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f42:	e9 0b f6 ff ff       	jmp    80106552 <alltraps>

80106f47 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $145
80106f49:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f4e:	e9 ff f5 ff ff       	jmp    80106552 <alltraps>

80106f53 <vector146>:
.globl vector146
vector146:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $146
80106f55:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f5a:	e9 f3 f5 ff ff       	jmp    80106552 <alltraps>

80106f5f <vector147>:
.globl vector147
vector147:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $147
80106f61:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f66:	e9 e7 f5 ff ff       	jmp    80106552 <alltraps>

80106f6b <vector148>:
.globl vector148
vector148:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $148
80106f6d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f72:	e9 db f5 ff ff       	jmp    80106552 <alltraps>

80106f77 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $149
80106f79:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f7e:	e9 cf f5 ff ff       	jmp    80106552 <alltraps>

80106f83 <vector150>:
.globl vector150
vector150:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $150
80106f85:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f8a:	e9 c3 f5 ff ff       	jmp    80106552 <alltraps>

80106f8f <vector151>:
.globl vector151
vector151:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $151
80106f91:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f96:	e9 b7 f5 ff ff       	jmp    80106552 <alltraps>

80106f9b <vector152>:
.globl vector152
vector152:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $152
80106f9d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106fa2:	e9 ab f5 ff ff       	jmp    80106552 <alltraps>

80106fa7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $153
80106fa9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106fae:	e9 9f f5 ff ff       	jmp    80106552 <alltraps>

80106fb3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $154
80106fb5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106fba:	e9 93 f5 ff ff       	jmp    80106552 <alltraps>

80106fbf <vector155>:
.globl vector155
vector155:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $155
80106fc1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106fc6:	e9 87 f5 ff ff       	jmp    80106552 <alltraps>

80106fcb <vector156>:
.globl vector156
vector156:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $156
80106fcd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106fd2:	e9 7b f5 ff ff       	jmp    80106552 <alltraps>

80106fd7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $157
80106fd9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106fde:	e9 6f f5 ff ff       	jmp    80106552 <alltraps>

80106fe3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $158
80106fe5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106fea:	e9 63 f5 ff ff       	jmp    80106552 <alltraps>

80106fef <vector159>:
.globl vector159
vector159:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $159
80106ff1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ff6:	e9 57 f5 ff ff       	jmp    80106552 <alltraps>

80106ffb <vector160>:
.globl vector160
vector160:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $160
80106ffd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107002:	e9 4b f5 ff ff       	jmp    80106552 <alltraps>

80107007 <vector161>:
.globl vector161
vector161:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $161
80107009:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010700e:	e9 3f f5 ff ff       	jmp    80106552 <alltraps>

80107013 <vector162>:
.globl vector162
vector162:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $162
80107015:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010701a:	e9 33 f5 ff ff       	jmp    80106552 <alltraps>

8010701f <vector163>:
.globl vector163
vector163:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $163
80107021:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107026:	e9 27 f5 ff ff       	jmp    80106552 <alltraps>

8010702b <vector164>:
.globl vector164
vector164:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $164
8010702d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107032:	e9 1b f5 ff ff       	jmp    80106552 <alltraps>

80107037 <vector165>:
.globl vector165
vector165:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $165
80107039:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010703e:	e9 0f f5 ff ff       	jmp    80106552 <alltraps>

80107043 <vector166>:
.globl vector166
vector166:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $166
80107045:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010704a:	e9 03 f5 ff ff       	jmp    80106552 <alltraps>

8010704f <vector167>:
.globl vector167
vector167:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $167
80107051:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107056:	e9 f7 f4 ff ff       	jmp    80106552 <alltraps>

8010705b <vector168>:
.globl vector168
vector168:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $168
8010705d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107062:	e9 eb f4 ff ff       	jmp    80106552 <alltraps>

80107067 <vector169>:
.globl vector169
vector169:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $169
80107069:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010706e:	e9 df f4 ff ff       	jmp    80106552 <alltraps>

80107073 <vector170>:
.globl vector170
vector170:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $170
80107075:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010707a:	e9 d3 f4 ff ff       	jmp    80106552 <alltraps>

8010707f <vector171>:
.globl vector171
vector171:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $171
80107081:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107086:	e9 c7 f4 ff ff       	jmp    80106552 <alltraps>

8010708b <vector172>:
.globl vector172
vector172:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $172
8010708d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107092:	e9 bb f4 ff ff       	jmp    80106552 <alltraps>

80107097 <vector173>:
.globl vector173
vector173:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $173
80107099:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010709e:	e9 af f4 ff ff       	jmp    80106552 <alltraps>

801070a3 <vector174>:
.globl vector174
vector174:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $174
801070a5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070aa:	e9 a3 f4 ff ff       	jmp    80106552 <alltraps>

801070af <vector175>:
.globl vector175
vector175:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $175
801070b1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070b6:	e9 97 f4 ff ff       	jmp    80106552 <alltraps>

801070bb <vector176>:
.globl vector176
vector176:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $176
801070bd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070c2:	e9 8b f4 ff ff       	jmp    80106552 <alltraps>

801070c7 <vector177>:
.globl vector177
vector177:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $177
801070c9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070ce:	e9 7f f4 ff ff       	jmp    80106552 <alltraps>

801070d3 <vector178>:
.globl vector178
vector178:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $178
801070d5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801070da:	e9 73 f4 ff ff       	jmp    80106552 <alltraps>

801070df <vector179>:
.globl vector179
vector179:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $179
801070e1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801070e6:	e9 67 f4 ff ff       	jmp    80106552 <alltraps>

801070eb <vector180>:
.globl vector180
vector180:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $180
801070ed:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801070f2:	e9 5b f4 ff ff       	jmp    80106552 <alltraps>

801070f7 <vector181>:
.globl vector181
vector181:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $181
801070f9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801070fe:	e9 4f f4 ff ff       	jmp    80106552 <alltraps>

80107103 <vector182>:
.globl vector182
vector182:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $182
80107105:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010710a:	e9 43 f4 ff ff       	jmp    80106552 <alltraps>

8010710f <vector183>:
.globl vector183
vector183:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $183
80107111:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107116:	e9 37 f4 ff ff       	jmp    80106552 <alltraps>

8010711b <vector184>:
.globl vector184
vector184:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $184
8010711d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107122:	e9 2b f4 ff ff       	jmp    80106552 <alltraps>

80107127 <vector185>:
.globl vector185
vector185:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $185
80107129:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010712e:	e9 1f f4 ff ff       	jmp    80106552 <alltraps>

80107133 <vector186>:
.globl vector186
vector186:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $186
80107135:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010713a:	e9 13 f4 ff ff       	jmp    80106552 <alltraps>

8010713f <vector187>:
.globl vector187
vector187:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $187
80107141:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107146:	e9 07 f4 ff ff       	jmp    80106552 <alltraps>

8010714b <vector188>:
.globl vector188
vector188:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $188
8010714d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107152:	e9 fb f3 ff ff       	jmp    80106552 <alltraps>

80107157 <vector189>:
.globl vector189
vector189:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $189
80107159:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010715e:	e9 ef f3 ff ff       	jmp    80106552 <alltraps>

80107163 <vector190>:
.globl vector190
vector190:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $190
80107165:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010716a:	e9 e3 f3 ff ff       	jmp    80106552 <alltraps>

8010716f <vector191>:
.globl vector191
vector191:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $191
80107171:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107176:	e9 d7 f3 ff ff       	jmp    80106552 <alltraps>

8010717b <vector192>:
.globl vector192
vector192:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $192
8010717d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107182:	e9 cb f3 ff ff       	jmp    80106552 <alltraps>

80107187 <vector193>:
.globl vector193
vector193:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $193
80107189:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010718e:	e9 bf f3 ff ff       	jmp    80106552 <alltraps>

80107193 <vector194>:
.globl vector194
vector194:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $194
80107195:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010719a:	e9 b3 f3 ff ff       	jmp    80106552 <alltraps>

8010719f <vector195>:
.globl vector195
vector195:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $195
801071a1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071a6:	e9 a7 f3 ff ff       	jmp    80106552 <alltraps>

801071ab <vector196>:
.globl vector196
vector196:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $196
801071ad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071b2:	e9 9b f3 ff ff       	jmp    80106552 <alltraps>

801071b7 <vector197>:
.globl vector197
vector197:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $197
801071b9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071be:	e9 8f f3 ff ff       	jmp    80106552 <alltraps>

801071c3 <vector198>:
.globl vector198
vector198:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $198
801071c5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071ca:	e9 83 f3 ff ff       	jmp    80106552 <alltraps>

801071cf <vector199>:
.globl vector199
vector199:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $199
801071d1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801071d6:	e9 77 f3 ff ff       	jmp    80106552 <alltraps>

801071db <vector200>:
.globl vector200
vector200:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $200
801071dd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801071e2:	e9 6b f3 ff ff       	jmp    80106552 <alltraps>

801071e7 <vector201>:
.globl vector201
vector201:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $201
801071e9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801071ee:	e9 5f f3 ff ff       	jmp    80106552 <alltraps>

801071f3 <vector202>:
.globl vector202
vector202:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $202
801071f5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801071fa:	e9 53 f3 ff ff       	jmp    80106552 <alltraps>

801071ff <vector203>:
.globl vector203
vector203:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $203
80107201:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107206:	e9 47 f3 ff ff       	jmp    80106552 <alltraps>

8010720b <vector204>:
.globl vector204
vector204:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $204
8010720d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107212:	e9 3b f3 ff ff       	jmp    80106552 <alltraps>

80107217 <vector205>:
.globl vector205
vector205:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $205
80107219:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010721e:	e9 2f f3 ff ff       	jmp    80106552 <alltraps>

80107223 <vector206>:
.globl vector206
vector206:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $206
80107225:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010722a:	e9 23 f3 ff ff       	jmp    80106552 <alltraps>

8010722f <vector207>:
.globl vector207
vector207:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $207
80107231:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107236:	e9 17 f3 ff ff       	jmp    80106552 <alltraps>

8010723b <vector208>:
.globl vector208
vector208:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $208
8010723d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107242:	e9 0b f3 ff ff       	jmp    80106552 <alltraps>

80107247 <vector209>:
.globl vector209
vector209:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $209
80107249:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010724e:	e9 ff f2 ff ff       	jmp    80106552 <alltraps>

80107253 <vector210>:
.globl vector210
vector210:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $210
80107255:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010725a:	e9 f3 f2 ff ff       	jmp    80106552 <alltraps>

8010725f <vector211>:
.globl vector211
vector211:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $211
80107261:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107266:	e9 e7 f2 ff ff       	jmp    80106552 <alltraps>

8010726b <vector212>:
.globl vector212
vector212:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $212
8010726d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107272:	e9 db f2 ff ff       	jmp    80106552 <alltraps>

80107277 <vector213>:
.globl vector213
vector213:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $213
80107279:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010727e:	e9 cf f2 ff ff       	jmp    80106552 <alltraps>

80107283 <vector214>:
.globl vector214
vector214:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $214
80107285:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010728a:	e9 c3 f2 ff ff       	jmp    80106552 <alltraps>

8010728f <vector215>:
.globl vector215
vector215:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $215
80107291:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107296:	e9 b7 f2 ff ff       	jmp    80106552 <alltraps>

8010729b <vector216>:
.globl vector216
vector216:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $216
8010729d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072a2:	e9 ab f2 ff ff       	jmp    80106552 <alltraps>

801072a7 <vector217>:
.globl vector217
vector217:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $217
801072a9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072ae:	e9 9f f2 ff ff       	jmp    80106552 <alltraps>

801072b3 <vector218>:
.globl vector218
vector218:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $218
801072b5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072ba:	e9 93 f2 ff ff       	jmp    80106552 <alltraps>

801072bf <vector219>:
.globl vector219
vector219:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $219
801072c1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072c6:	e9 87 f2 ff ff       	jmp    80106552 <alltraps>

801072cb <vector220>:
.globl vector220
vector220:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $220
801072cd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072d2:	e9 7b f2 ff ff       	jmp    80106552 <alltraps>

801072d7 <vector221>:
.globl vector221
vector221:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $221
801072d9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801072de:	e9 6f f2 ff ff       	jmp    80106552 <alltraps>

801072e3 <vector222>:
.globl vector222
vector222:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $222
801072e5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801072ea:	e9 63 f2 ff ff       	jmp    80106552 <alltraps>

801072ef <vector223>:
.globl vector223
vector223:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $223
801072f1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801072f6:	e9 57 f2 ff ff       	jmp    80106552 <alltraps>

801072fb <vector224>:
.globl vector224
vector224:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $224
801072fd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107302:	e9 4b f2 ff ff       	jmp    80106552 <alltraps>

80107307 <vector225>:
.globl vector225
vector225:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $225
80107309:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010730e:	e9 3f f2 ff ff       	jmp    80106552 <alltraps>

80107313 <vector226>:
.globl vector226
vector226:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $226
80107315:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010731a:	e9 33 f2 ff ff       	jmp    80106552 <alltraps>

8010731f <vector227>:
.globl vector227
vector227:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $227
80107321:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107326:	e9 27 f2 ff ff       	jmp    80106552 <alltraps>

8010732b <vector228>:
.globl vector228
vector228:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $228
8010732d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107332:	e9 1b f2 ff ff       	jmp    80106552 <alltraps>

80107337 <vector229>:
.globl vector229
vector229:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $229
80107339:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010733e:	e9 0f f2 ff ff       	jmp    80106552 <alltraps>

80107343 <vector230>:
.globl vector230
vector230:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $230
80107345:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010734a:	e9 03 f2 ff ff       	jmp    80106552 <alltraps>

8010734f <vector231>:
.globl vector231
vector231:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $231
80107351:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107356:	e9 f7 f1 ff ff       	jmp    80106552 <alltraps>

8010735b <vector232>:
.globl vector232
vector232:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $232
8010735d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107362:	e9 eb f1 ff ff       	jmp    80106552 <alltraps>

80107367 <vector233>:
.globl vector233
vector233:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $233
80107369:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010736e:	e9 df f1 ff ff       	jmp    80106552 <alltraps>

80107373 <vector234>:
.globl vector234
vector234:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $234
80107375:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010737a:	e9 d3 f1 ff ff       	jmp    80106552 <alltraps>

8010737f <vector235>:
.globl vector235
vector235:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $235
80107381:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107386:	e9 c7 f1 ff ff       	jmp    80106552 <alltraps>

8010738b <vector236>:
.globl vector236
vector236:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $236
8010738d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107392:	e9 bb f1 ff ff       	jmp    80106552 <alltraps>

80107397 <vector237>:
.globl vector237
vector237:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $237
80107399:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010739e:	e9 af f1 ff ff       	jmp    80106552 <alltraps>

801073a3 <vector238>:
.globl vector238
vector238:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $238
801073a5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073aa:	e9 a3 f1 ff ff       	jmp    80106552 <alltraps>

801073af <vector239>:
.globl vector239
vector239:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $239
801073b1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073b6:	e9 97 f1 ff ff       	jmp    80106552 <alltraps>

801073bb <vector240>:
.globl vector240
vector240:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $240
801073bd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073c2:	e9 8b f1 ff ff       	jmp    80106552 <alltraps>

801073c7 <vector241>:
.globl vector241
vector241:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $241
801073c9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073ce:	e9 7f f1 ff ff       	jmp    80106552 <alltraps>

801073d3 <vector242>:
.globl vector242
vector242:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $242
801073d5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801073da:	e9 73 f1 ff ff       	jmp    80106552 <alltraps>

801073df <vector243>:
.globl vector243
vector243:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $243
801073e1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801073e6:	e9 67 f1 ff ff       	jmp    80106552 <alltraps>

801073eb <vector244>:
.globl vector244
vector244:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $244
801073ed:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801073f2:	e9 5b f1 ff ff       	jmp    80106552 <alltraps>

801073f7 <vector245>:
.globl vector245
vector245:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $245
801073f9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801073fe:	e9 4f f1 ff ff       	jmp    80106552 <alltraps>

80107403 <vector246>:
.globl vector246
vector246:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $246
80107405:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010740a:	e9 43 f1 ff ff       	jmp    80106552 <alltraps>

8010740f <vector247>:
.globl vector247
vector247:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $247
80107411:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107416:	e9 37 f1 ff ff       	jmp    80106552 <alltraps>

8010741b <vector248>:
.globl vector248
vector248:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $248
8010741d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107422:	e9 2b f1 ff ff       	jmp    80106552 <alltraps>

80107427 <vector249>:
.globl vector249
vector249:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $249
80107429:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010742e:	e9 1f f1 ff ff       	jmp    80106552 <alltraps>

80107433 <vector250>:
.globl vector250
vector250:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $250
80107435:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010743a:	e9 13 f1 ff ff       	jmp    80106552 <alltraps>

8010743f <vector251>:
.globl vector251
vector251:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $251
80107441:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107446:	e9 07 f1 ff ff       	jmp    80106552 <alltraps>

8010744b <vector252>:
.globl vector252
vector252:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $252
8010744d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107452:	e9 fb f0 ff ff       	jmp    80106552 <alltraps>

80107457 <vector253>:
.globl vector253
vector253:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $253
80107459:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010745e:	e9 ef f0 ff ff       	jmp    80106552 <alltraps>

80107463 <vector254>:
.globl vector254
vector254:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $254
80107465:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010746a:	e9 e3 f0 ff ff       	jmp    80106552 <alltraps>

8010746f <vector255>:
.globl vector255
vector255:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $255
80107471:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107476:	e9 d7 f0 ff ff       	jmp    80106552 <alltraps>
8010747b:	66 90                	xchg   %ax,%ax
8010747d:	66 90                	xchg   %ax,%ax
8010747f:	90                   	nop

80107480 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107487:	c1 ea 16             	shr    $0x16,%edx
{
8010748a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010748b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010748e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107491:	8b 1f                	mov    (%edi),%ebx
80107493:	f6 c3 01             	test   $0x1,%bl
80107496:	74 28                	je     801074c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107498:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010749e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801074a4:	89 f0                	mov    %esi,%eax
}
801074a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801074a9:	c1 e8 0a             	shr    $0xa,%eax
801074ac:	25 fc 0f 00 00       	and    $0xffc,%eax
801074b1:	01 d8                	add    %ebx,%eax
}
801074b3:	5b                   	pop    %ebx
801074b4:	5e                   	pop    %esi
801074b5:	5f                   	pop    %edi
801074b6:	5d                   	pop    %ebp
801074b7:	c3                   	ret    
801074b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074c0:	85 c9                	test   %ecx,%ecx
801074c2:	74 2c                	je     801074f0 <walkpgdir+0x70>
801074c4:	e8 67 b1 ff ff       	call   80102630 <kalloc>
801074c9:	89 c3                	mov    %eax,%ebx
801074cb:	85 c0                	test   %eax,%eax
801074cd:	74 21                	je     801074f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801074cf:	83 ec 04             	sub    $0x4,%esp
801074d2:	68 00 10 00 00       	push   $0x1000
801074d7:	6a 00                	push   $0x0
801074d9:	50                   	push   %eax
801074da:	e8 d1 dc ff ff       	call   801051b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074e5:	83 c4 10             	add    $0x10,%esp
801074e8:	83 c8 07             	or     $0x7,%eax
801074eb:	89 07                	mov    %eax,(%edi)
801074ed:	eb b5                	jmp    801074a4 <walkpgdir+0x24>
801074ef:	90                   	nop
}
801074f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801074f3:	31 c0                	xor    %eax,%eax
}
801074f5:	5b                   	pop    %ebx
801074f6:	5e                   	pop    %esi
801074f7:	5f                   	pop    %edi
801074f8:	5d                   	pop    %ebp
801074f9:	c3                   	ret    
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107500 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107506:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010750a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010750b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107510:	89 d6                	mov    %edx,%esi
{
80107512:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107513:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107519:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010751c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010751f:	8b 45 08             	mov    0x8(%ebp),%eax
80107522:	29 f0                	sub    %esi,%eax
80107524:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107527:	eb 1f                	jmp    80107548 <mappages+0x48>
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107530:	f6 00 01             	testb  $0x1,(%eax)
80107533:	75 45                	jne    8010757a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107535:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107538:	83 cb 01             	or     $0x1,%ebx
8010753b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010753d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107540:	74 2e                	je     80107570 <mappages+0x70>
      break;
    a += PGSIZE;
80107542:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010754b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107550:	89 f2                	mov    %esi,%edx
80107552:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107555:	89 f8                	mov    %edi,%eax
80107557:	e8 24 ff ff ff       	call   80107480 <walkpgdir>
8010755c:	85 c0                	test   %eax,%eax
8010755e:	75 d0                	jne    80107530 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107560:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107563:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107568:	5b                   	pop    %ebx
80107569:	5e                   	pop    %esi
8010756a:	5f                   	pop    %edi
8010756b:	5d                   	pop    %ebp
8010756c:	c3                   	ret    
8010756d:	8d 76 00             	lea    0x0(%esi),%esi
80107570:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107573:	31 c0                	xor    %eax,%eax
}
80107575:	5b                   	pop    %ebx
80107576:	5e                   	pop    %esi
80107577:	5f                   	pop    %edi
80107578:	5d                   	pop    %ebp
80107579:	c3                   	ret    
      panic("remap");
8010757a:	83 ec 0c             	sub    $0xc,%esp
8010757d:	68 24 88 10 80       	push   $0x80108824
80107582:	e8 09 8e ff ff       	call   80100390 <panic>
80107587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758e:	66 90                	xchg   %ax,%ax

80107590 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	57                   	push   %edi
80107594:	56                   	push   %esi
80107595:	89 c6                	mov    %eax,%esi
80107597:	53                   	push   %ebx
80107598:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010759a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801075a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801075a6:	83 ec 1c             	sub    $0x1c,%esp
801075a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801075ac:	39 da                	cmp    %ebx,%edx
801075ae:	73 5b                	jae    8010760b <deallocuvm.part.0+0x7b>
801075b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801075b3:	89 d7                	mov    %edx,%edi
801075b5:	eb 14                	jmp    801075cb <deallocuvm.part.0+0x3b>
801075b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075be:	66 90                	xchg   %ax,%ax
801075c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801075c6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801075c9:	76 40                	jbe    8010760b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801075cb:	31 c9                	xor    %ecx,%ecx
801075cd:	89 fa                	mov    %edi,%edx
801075cf:	89 f0                	mov    %esi,%eax
801075d1:	e8 aa fe ff ff       	call   80107480 <walkpgdir>
801075d6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801075d8:	85 c0                	test   %eax,%eax
801075da:	74 44                	je     80107620 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801075dc:	8b 00                	mov    (%eax),%eax
801075de:	a8 01                	test   $0x1,%al
801075e0:	74 de                	je     801075c0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801075e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075e7:	74 47                	je     80107630 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801075e9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801075ec:	05 00 00 00 80       	add    $0x80000000,%eax
801075f1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801075f7:	50                   	push   %eax
801075f8:	e8 73 ae ff ff       	call   80102470 <kfree>
      *pte = 0;
801075fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107603:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107606:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107609:	77 c0                	ja     801075cb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010760b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010760e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107611:	5b                   	pop    %ebx
80107612:	5e                   	pop    %esi
80107613:	5f                   	pop    %edi
80107614:	5d                   	pop    %ebp
80107615:	c3                   	ret    
80107616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107620:	89 fa                	mov    %edi,%edx
80107622:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107628:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010762e:	eb 96                	jmp    801075c6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107630:	83 ec 0c             	sub    $0xc,%esp
80107633:	68 26 80 10 80       	push   $0x80108026
80107638:	e8 53 8d ff ff       	call   80100390 <panic>
8010763d:	8d 76 00             	lea    0x0(%esi),%esi

80107640 <seginit>:
{
80107640:	f3 0f 1e fb          	endbr32 
80107644:	55                   	push   %ebp
80107645:	89 e5                	mov    %esp,%ebp
80107647:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010764a:	e8 d1 c3 ff ff       	call   80103a20 <cpuid>
  pd[0] = size-1;
8010764f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107654:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010765a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010765e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107665:	ff 00 00 
80107668:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010766f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107672:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107679:	ff 00 00 
8010767c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80107683:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107686:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
8010768d:	ff 00 00 
80107690:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107697:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010769a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
801076a1:	ff 00 00 
801076a4:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
801076ab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801076ae:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
801076b3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801076b7:	c1 e8 10             	shr    $0x10,%eax
801076ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801076be:	8d 45 f2             	lea    -0xe(%ebp),%eax
801076c1:	0f 01 10             	lgdtl  (%eax)
}
801076c4:	c9                   	leave  
801076c5:	c3                   	ret    
801076c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cd:	8d 76 00             	lea    0x0(%esi),%esi

801076d0 <switchkvm>:
{
801076d0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076d4:	a1 a4 86 11 80       	mov    0x801186a4,%eax
801076d9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076de:	0f 22 d8             	mov    %eax,%cr3
}
801076e1:	c3                   	ret    
801076e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076f0 <switchuvm>:
{
801076f0:	f3 0f 1e fb          	endbr32 
801076f4:	55                   	push   %ebp
801076f5:	89 e5                	mov    %esp,%ebp
801076f7:	57                   	push   %edi
801076f8:	56                   	push   %esi
801076f9:	53                   	push   %ebx
801076fa:	83 ec 1c             	sub    $0x1c,%esp
801076fd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107700:	85 f6                	test   %esi,%esi
80107702:	0f 84 cb 00 00 00    	je     801077d3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107708:	8b 46 08             	mov    0x8(%esi),%eax
8010770b:	85 c0                	test   %eax,%eax
8010770d:	0f 84 da 00 00 00    	je     801077ed <switchuvm+0xfd>
  if(p->pgdir == 0)
80107713:	8b 46 04             	mov    0x4(%esi),%eax
80107716:	85 c0                	test   %eax,%eax
80107718:	0f 84 c2 00 00 00    	je     801077e0 <switchuvm+0xf0>
  pushcli();
8010771e:	e8 7d d8 ff ff       	call   80104fa0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107723:	e8 88 c2 ff ff       	call   801039b0 <mycpu>
80107728:	89 c3                	mov    %eax,%ebx
8010772a:	e8 81 c2 ff ff       	call   801039b0 <mycpu>
8010772f:	89 c7                	mov    %eax,%edi
80107731:	e8 7a c2 ff ff       	call   801039b0 <mycpu>
80107736:	83 c7 08             	add    $0x8,%edi
80107739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010773c:	e8 6f c2 ff ff       	call   801039b0 <mycpu>
80107741:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107744:	ba 67 00 00 00       	mov    $0x67,%edx
80107749:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107750:	83 c0 08             	add    $0x8,%eax
80107753:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010775a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010775f:	83 c1 08             	add    $0x8,%ecx
80107762:	c1 e8 18             	shr    $0x18,%eax
80107765:	c1 e9 10             	shr    $0x10,%ecx
80107768:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010776e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107774:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107779:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107780:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107785:	e8 26 c2 ff ff       	call   801039b0 <mycpu>
8010778a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107791:	e8 1a c2 ff ff       	call   801039b0 <mycpu>
80107796:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010779a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010779d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077a3:	e8 08 c2 ff ff       	call   801039b0 <mycpu>
801077a8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801077ab:	e8 00 c2 ff ff       	call   801039b0 <mycpu>
801077b0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801077b4:	b8 28 00 00 00       	mov    $0x28,%eax
801077b9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801077bc:	8b 46 04             	mov    0x4(%esi),%eax
801077bf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077c4:	0f 22 d8             	mov    %eax,%cr3
}
801077c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ca:	5b                   	pop    %ebx
801077cb:	5e                   	pop    %esi
801077cc:	5f                   	pop    %edi
801077cd:	5d                   	pop    %ebp
  popcli();
801077ce:	e9 1d d8 ff ff       	jmp    80104ff0 <popcli>
    panic("switchuvm: no process");
801077d3:	83 ec 0c             	sub    $0xc,%esp
801077d6:	68 2a 88 10 80       	push   $0x8010882a
801077db:	e8 b0 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801077e0:	83 ec 0c             	sub    $0xc,%esp
801077e3:	68 55 88 10 80       	push   $0x80108855
801077e8:	e8 a3 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801077ed:	83 ec 0c             	sub    $0xc,%esp
801077f0:	68 40 88 10 80       	push   $0x80108840
801077f5:	e8 96 8b ff ff       	call   80100390 <panic>
801077fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107800 <inituvm>:
{
80107800:	f3 0f 1e fb          	endbr32 
80107804:	55                   	push   %ebp
80107805:	89 e5                	mov    %esp,%ebp
80107807:	57                   	push   %edi
80107808:	56                   	push   %esi
80107809:	53                   	push   %ebx
8010780a:	83 ec 1c             	sub    $0x1c,%esp
8010780d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107810:	8b 75 10             	mov    0x10(%ebp),%esi
80107813:	8b 7d 08             	mov    0x8(%ebp),%edi
80107816:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107819:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010781f:	77 4b                	ja     8010786c <inituvm+0x6c>
  mem = kalloc();
80107821:	e8 0a ae ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80107826:	83 ec 04             	sub    $0x4,%esp
80107829:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010782e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107830:	6a 00                	push   $0x0
80107832:	50                   	push   %eax
80107833:	e8 78 d9 ff ff       	call   801051b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107838:	58                   	pop    %eax
80107839:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010783f:	5a                   	pop    %edx
80107840:	6a 06                	push   $0x6
80107842:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107847:	31 d2                	xor    %edx,%edx
80107849:	50                   	push   %eax
8010784a:	89 f8                	mov    %edi,%eax
8010784c:	e8 af fc ff ff       	call   80107500 <mappages>
  memmove(mem, init, sz);
80107851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107854:	89 75 10             	mov    %esi,0x10(%ebp)
80107857:	83 c4 10             	add    $0x10,%esp
8010785a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010785d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107860:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107863:	5b                   	pop    %ebx
80107864:	5e                   	pop    %esi
80107865:	5f                   	pop    %edi
80107866:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107867:	e9 e4 d9 ff ff       	jmp    80105250 <memmove>
    panic("inituvm: more than a page");
8010786c:	83 ec 0c             	sub    $0xc,%esp
8010786f:	68 69 88 10 80       	push   $0x80108869
80107874:	e8 17 8b ff ff       	call   80100390 <panic>
80107879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107880 <loaduvm>:
{
80107880:	f3 0f 1e fb          	endbr32 
80107884:	55                   	push   %ebp
80107885:	89 e5                	mov    %esp,%ebp
80107887:	57                   	push   %edi
80107888:	56                   	push   %esi
80107889:	53                   	push   %ebx
8010788a:	83 ec 1c             	sub    $0x1c,%esp
8010788d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107890:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107893:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107898:	0f 85 99 00 00 00    	jne    80107937 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010789e:	01 f0                	add    %esi,%eax
801078a0:	89 f3                	mov    %esi,%ebx
801078a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801078a5:	8b 45 14             	mov    0x14(%ebp),%eax
801078a8:	01 f0                	add    %esi,%eax
801078aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801078ad:	85 f6                	test   %esi,%esi
801078af:	75 15                	jne    801078c6 <loaduvm+0x46>
801078b1:	eb 6d                	jmp    80107920 <loaduvm+0xa0>
801078b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078b7:	90                   	nop
801078b8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801078be:	89 f0                	mov    %esi,%eax
801078c0:	29 d8                	sub    %ebx,%eax
801078c2:	39 c6                	cmp    %eax,%esi
801078c4:	76 5a                	jbe    80107920 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801078c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801078c9:	8b 45 08             	mov    0x8(%ebp),%eax
801078cc:	31 c9                	xor    %ecx,%ecx
801078ce:	29 da                	sub    %ebx,%edx
801078d0:	e8 ab fb ff ff       	call   80107480 <walkpgdir>
801078d5:	85 c0                	test   %eax,%eax
801078d7:	74 51                	je     8010792a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801078d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801078db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801078de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801078e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801078e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801078ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801078f1:	29 d9                	sub    %ebx,%ecx
801078f3:	05 00 00 00 80       	add    $0x80000000,%eax
801078f8:	57                   	push   %edi
801078f9:	51                   	push   %ecx
801078fa:	50                   	push   %eax
801078fb:	ff 75 10             	pushl  0x10(%ebp)
801078fe:	e8 5d a1 ff ff       	call   80101a60 <readi>
80107903:	83 c4 10             	add    $0x10,%esp
80107906:	39 f8                	cmp    %edi,%eax
80107908:	74 ae                	je     801078b8 <loaduvm+0x38>
}
8010790a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010790d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107912:	5b                   	pop    %ebx
80107913:	5e                   	pop    %esi
80107914:	5f                   	pop    %edi
80107915:	5d                   	pop    %ebp
80107916:	c3                   	ret    
80107917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010791e:	66 90                	xchg   %ax,%ax
80107920:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107923:	31 c0                	xor    %eax,%eax
}
80107925:	5b                   	pop    %ebx
80107926:	5e                   	pop    %esi
80107927:	5f                   	pop    %edi
80107928:	5d                   	pop    %ebp
80107929:	c3                   	ret    
      panic("loaduvm: address should exist");
8010792a:	83 ec 0c             	sub    $0xc,%esp
8010792d:	68 83 88 10 80       	push   $0x80108883
80107932:	e8 59 8a ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107937:	83 ec 0c             	sub    $0xc,%esp
8010793a:	68 24 89 10 80       	push   $0x80108924
8010793f:	e8 4c 8a ff ff       	call   80100390 <panic>
80107944:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010794b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010794f:	90                   	nop

80107950 <allocuvm>:
{
80107950:	f3 0f 1e fb          	endbr32 
80107954:	55                   	push   %ebp
80107955:	89 e5                	mov    %esp,%ebp
80107957:	57                   	push   %edi
80107958:	56                   	push   %esi
80107959:	53                   	push   %ebx
8010795a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010795d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107960:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107963:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107966:	85 c0                	test   %eax,%eax
80107968:	0f 88 b2 00 00 00    	js     80107a20 <allocuvm+0xd0>
  if(newsz < oldsz)
8010796e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107971:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107974:	0f 82 96 00 00 00    	jb     80107a10 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010797a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107980:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107986:	39 75 10             	cmp    %esi,0x10(%ebp)
80107989:	77 40                	ja     801079cb <allocuvm+0x7b>
8010798b:	e9 83 00 00 00       	jmp    80107a13 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107990:	83 ec 04             	sub    $0x4,%esp
80107993:	68 00 10 00 00       	push   $0x1000
80107998:	6a 00                	push   $0x0
8010799a:	50                   	push   %eax
8010799b:	e8 10 d8 ff ff       	call   801051b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801079a0:	58                   	pop    %eax
801079a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079a7:	5a                   	pop    %edx
801079a8:	6a 06                	push   $0x6
801079aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079af:	89 f2                	mov    %esi,%edx
801079b1:	50                   	push   %eax
801079b2:	89 f8                	mov    %edi,%eax
801079b4:	e8 47 fb ff ff       	call   80107500 <mappages>
801079b9:	83 c4 10             	add    $0x10,%esp
801079bc:	85 c0                	test   %eax,%eax
801079be:	78 78                	js     80107a38 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801079c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801079c9:	76 48                	jbe    80107a13 <allocuvm+0xc3>
    mem = kalloc();
801079cb:	e8 60 ac ff ff       	call   80102630 <kalloc>
801079d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801079d2:	85 c0                	test   %eax,%eax
801079d4:	75 ba                	jne    80107990 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801079d6:	83 ec 0c             	sub    $0xc,%esp
801079d9:	68 a1 88 10 80       	push   $0x801088a1
801079de:	e8 cd 8c ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801079e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801079e6:	83 c4 10             	add    $0x10,%esp
801079e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801079ec:	74 32                	je     80107a20 <allocuvm+0xd0>
801079ee:	8b 55 10             	mov    0x10(%ebp),%edx
801079f1:	89 c1                	mov    %eax,%ecx
801079f3:	89 f8                	mov    %edi,%eax
801079f5:	e8 96 fb ff ff       	call   80107590 <deallocuvm.part.0>
      return 0;
801079fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a07:	5b                   	pop    %ebx
80107a08:	5e                   	pop    %esi
80107a09:	5f                   	pop    %edi
80107a0a:	5d                   	pop    %ebp
80107a0b:	c3                   	ret    
80107a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107a10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a19:	5b                   	pop    %ebx
80107a1a:	5e                   	pop    %esi
80107a1b:	5f                   	pop    %edi
80107a1c:	5d                   	pop    %ebp
80107a1d:	c3                   	ret    
80107a1e:	66 90                	xchg   %ax,%ax
    return 0;
80107a20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a2d:	5b                   	pop    %ebx
80107a2e:	5e                   	pop    %esi
80107a2f:	5f                   	pop    %edi
80107a30:	5d                   	pop    %ebp
80107a31:	c3                   	ret    
80107a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107a38:	83 ec 0c             	sub    $0xc,%esp
80107a3b:	68 b9 88 10 80       	push   $0x801088b9
80107a40:	e8 6b 8c ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107a45:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a48:	83 c4 10             	add    $0x10,%esp
80107a4b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107a4e:	74 0c                	je     80107a5c <allocuvm+0x10c>
80107a50:	8b 55 10             	mov    0x10(%ebp),%edx
80107a53:	89 c1                	mov    %eax,%ecx
80107a55:	89 f8                	mov    %edi,%eax
80107a57:	e8 34 fb ff ff       	call   80107590 <deallocuvm.part.0>
      kfree(mem);
80107a5c:	83 ec 0c             	sub    $0xc,%esp
80107a5f:	53                   	push   %ebx
80107a60:	e8 0b aa ff ff       	call   80102470 <kfree>
      return 0;
80107a65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107a6c:	83 c4 10             	add    $0x10,%esp
}
80107a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a75:	5b                   	pop    %ebx
80107a76:	5e                   	pop    %esi
80107a77:	5f                   	pop    %edi
80107a78:	5d                   	pop    %ebp
80107a79:	c3                   	ret    
80107a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a80 <deallocuvm>:
{
80107a80:	f3 0f 1e fb          	endbr32 
80107a84:	55                   	push   %ebp
80107a85:	89 e5                	mov    %esp,%ebp
80107a87:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107a90:	39 d1                	cmp    %edx,%ecx
80107a92:	73 0c                	jae    80107aa0 <deallocuvm+0x20>
}
80107a94:	5d                   	pop    %ebp
80107a95:	e9 f6 fa ff ff       	jmp    80107590 <deallocuvm.part.0>
80107a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107aa0:	89 d0                	mov    %edx,%eax
80107aa2:	5d                   	pop    %ebp
80107aa3:	c3                   	ret    
80107aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107aaf:	90                   	nop

80107ab0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ab0:	f3 0f 1e fb          	endbr32 
80107ab4:	55                   	push   %ebp
80107ab5:	89 e5                	mov    %esp,%ebp
80107ab7:	57                   	push   %edi
80107ab8:	56                   	push   %esi
80107ab9:	53                   	push   %ebx
80107aba:	83 ec 0c             	sub    $0xc,%esp
80107abd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107ac0:	85 f6                	test   %esi,%esi
80107ac2:	74 55                	je     80107b19 <freevm+0x69>
  if(newsz >= oldsz)
80107ac4:	31 c9                	xor    %ecx,%ecx
80107ac6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107acb:	89 f0                	mov    %esi,%eax
80107acd:	89 f3                	mov    %esi,%ebx
80107acf:	e8 bc fa ff ff       	call   80107590 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107ad4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107ada:	eb 0b                	jmp    80107ae7 <freevm+0x37>
80107adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ae0:	83 c3 04             	add    $0x4,%ebx
80107ae3:	39 df                	cmp    %ebx,%edi
80107ae5:	74 23                	je     80107b0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107ae7:	8b 03                	mov    (%ebx),%eax
80107ae9:	a8 01                	test   $0x1,%al
80107aeb:	74 f3                	je     80107ae0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107aed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107af2:	83 ec 0c             	sub    $0xc,%esp
80107af5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107af8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107afd:	50                   	push   %eax
80107afe:	e8 6d a9 ff ff       	call   80102470 <kfree>
80107b03:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b06:	39 df                	cmp    %ebx,%edi
80107b08:	75 dd                	jne    80107ae7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107b0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107b0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b10:	5b                   	pop    %ebx
80107b11:	5e                   	pop    %esi
80107b12:	5f                   	pop    %edi
80107b13:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107b14:	e9 57 a9 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107b19:	83 ec 0c             	sub    $0xc,%esp
80107b1c:	68 d5 88 10 80       	push   $0x801088d5
80107b21:	e8 6a 88 ff ff       	call   80100390 <panic>
80107b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b2d:	8d 76 00             	lea    0x0(%esi),%esi

80107b30 <setupkvm>:
{
80107b30:	f3 0f 1e fb          	endbr32 
80107b34:	55                   	push   %ebp
80107b35:	89 e5                	mov    %esp,%ebp
80107b37:	56                   	push   %esi
80107b38:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107b39:	e8 f2 aa ff ff       	call   80102630 <kalloc>
80107b3e:	89 c6                	mov    %eax,%esi
80107b40:	85 c0                	test   %eax,%eax
80107b42:	74 42                	je     80107b86 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107b44:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b47:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107b4c:	68 00 10 00 00       	push   $0x1000
80107b51:	6a 00                	push   $0x0
80107b53:	50                   	push   %eax
80107b54:	e8 57 d6 ff ff       	call   801051b0 <memset>
80107b59:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107b5c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107b5f:	83 ec 08             	sub    $0x8,%esp
80107b62:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107b65:	ff 73 0c             	pushl  0xc(%ebx)
80107b68:	8b 13                	mov    (%ebx),%edx
80107b6a:	50                   	push   %eax
80107b6b:	29 c1                	sub    %eax,%ecx
80107b6d:	89 f0                	mov    %esi,%eax
80107b6f:	e8 8c f9 ff ff       	call   80107500 <mappages>
80107b74:	83 c4 10             	add    $0x10,%esp
80107b77:	85 c0                	test   %eax,%eax
80107b79:	78 15                	js     80107b90 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b7b:	83 c3 10             	add    $0x10,%ebx
80107b7e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107b84:	75 d6                	jne    80107b5c <setupkvm+0x2c>
}
80107b86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b89:	89 f0                	mov    %esi,%eax
80107b8b:	5b                   	pop    %ebx
80107b8c:	5e                   	pop    %esi
80107b8d:	5d                   	pop    %ebp
80107b8e:	c3                   	ret    
80107b8f:	90                   	nop
      freevm(pgdir);
80107b90:	83 ec 0c             	sub    $0xc,%esp
80107b93:	56                   	push   %esi
      return 0;
80107b94:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107b96:	e8 15 ff ff ff       	call   80107ab0 <freevm>
      return 0;
80107b9b:	83 c4 10             	add    $0x10,%esp
}
80107b9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ba1:	89 f0                	mov    %esi,%eax
80107ba3:	5b                   	pop    %ebx
80107ba4:	5e                   	pop    %esi
80107ba5:	5d                   	pop    %ebp
80107ba6:	c3                   	ret    
80107ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bae:	66 90                	xchg   %ax,%ax

80107bb0 <kvmalloc>:
{
80107bb0:	f3 0f 1e fb          	endbr32 
80107bb4:	55                   	push   %ebp
80107bb5:	89 e5                	mov    %esp,%ebp
80107bb7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107bba:	e8 71 ff ff ff       	call   80107b30 <setupkvm>
80107bbf:	a3 a4 86 11 80       	mov    %eax,0x801186a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107bc4:	05 00 00 00 80       	add    $0x80000000,%eax
80107bc9:	0f 22 d8             	mov    %eax,%cr3
}
80107bcc:	c9                   	leave  
80107bcd:	c3                   	ret    
80107bce:	66 90                	xchg   %ax,%ax

80107bd0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107bd0:	f3 0f 1e fb          	endbr32 
80107bd4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107bd5:	31 c9                	xor    %ecx,%ecx
{
80107bd7:	89 e5                	mov    %esp,%ebp
80107bd9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80107be2:	e8 99 f8 ff ff       	call   80107480 <walkpgdir>
  if(pte == 0)
80107be7:	85 c0                	test   %eax,%eax
80107be9:	74 05                	je     80107bf0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107beb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107bee:	c9                   	leave  
80107bef:	c3                   	ret    
    panic("clearpteu");
80107bf0:	83 ec 0c             	sub    $0xc,%esp
80107bf3:	68 e6 88 10 80       	push   $0x801088e6
80107bf8:	e8 93 87 ff ff       	call   80100390 <panic>
80107bfd:	8d 76 00             	lea    0x0(%esi),%esi

80107c00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107c00:	f3 0f 1e fb          	endbr32 
80107c04:	55                   	push   %ebp
80107c05:	89 e5                	mov    %esp,%ebp
80107c07:	57                   	push   %edi
80107c08:	56                   	push   %esi
80107c09:	53                   	push   %ebx
80107c0a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107c0d:	e8 1e ff ff ff       	call   80107b30 <setupkvm>
80107c12:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c15:	85 c0                	test   %eax,%eax
80107c17:	0f 84 9b 00 00 00    	je     80107cb8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107c20:	85 c9                	test   %ecx,%ecx
80107c22:	0f 84 90 00 00 00    	je     80107cb8 <copyuvm+0xb8>
80107c28:	31 f6                	xor    %esi,%esi
80107c2a:	eb 46                	jmp    80107c72 <copyuvm+0x72>
80107c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107c30:	83 ec 04             	sub    $0x4,%esp
80107c33:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107c39:	68 00 10 00 00       	push   $0x1000
80107c3e:	57                   	push   %edi
80107c3f:	50                   	push   %eax
80107c40:	e8 0b d6 ff ff       	call   80105250 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107c45:	58                   	pop    %eax
80107c46:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c4c:	5a                   	pop    %edx
80107c4d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107c50:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c55:	89 f2                	mov    %esi,%edx
80107c57:	50                   	push   %eax
80107c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c5b:	e8 a0 f8 ff ff       	call   80107500 <mappages>
80107c60:	83 c4 10             	add    $0x10,%esp
80107c63:	85 c0                	test   %eax,%eax
80107c65:	78 61                	js     80107cc8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107c67:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107c6d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c70:	76 46                	jbe    80107cb8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c72:	8b 45 08             	mov    0x8(%ebp),%eax
80107c75:	31 c9                	xor    %ecx,%ecx
80107c77:	89 f2                	mov    %esi,%edx
80107c79:	e8 02 f8 ff ff       	call   80107480 <walkpgdir>
80107c7e:	85 c0                	test   %eax,%eax
80107c80:	74 61                	je     80107ce3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107c82:	8b 00                	mov    (%eax),%eax
80107c84:	a8 01                	test   $0x1,%al
80107c86:	74 4e                	je     80107cd6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107c88:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107c8a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107c92:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107c98:	e8 93 a9 ff ff       	call   80102630 <kalloc>
80107c9d:	89 c3                	mov    %eax,%ebx
80107c9f:	85 c0                	test   %eax,%eax
80107ca1:	75 8d                	jne    80107c30 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107ca3:	83 ec 0c             	sub    $0xc,%esp
80107ca6:	ff 75 e0             	pushl  -0x20(%ebp)
80107ca9:	e8 02 fe ff ff       	call   80107ab0 <freevm>
  return 0;
80107cae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107cb5:	83 c4 10             	add    $0x10,%esp
}
80107cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cbe:	5b                   	pop    %ebx
80107cbf:	5e                   	pop    %esi
80107cc0:	5f                   	pop    %edi
80107cc1:	5d                   	pop    %ebp
80107cc2:	c3                   	ret    
80107cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cc7:	90                   	nop
      kfree(mem);
80107cc8:	83 ec 0c             	sub    $0xc,%esp
80107ccb:	53                   	push   %ebx
80107ccc:	e8 9f a7 ff ff       	call   80102470 <kfree>
      goto bad;
80107cd1:	83 c4 10             	add    $0x10,%esp
80107cd4:	eb cd                	jmp    80107ca3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107cd6:	83 ec 0c             	sub    $0xc,%esp
80107cd9:	68 0a 89 10 80       	push   $0x8010890a
80107cde:	e8 ad 86 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107ce3:	83 ec 0c             	sub    $0xc,%esp
80107ce6:	68 f0 88 10 80       	push   $0x801088f0
80107ceb:	e8 a0 86 ff ff       	call   80100390 <panic>

80107cf0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107cf0:	f3 0f 1e fb          	endbr32 
80107cf4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107cf5:	31 c9                	xor    %ecx,%ecx
{
80107cf7:	89 e5                	mov    %esp,%ebp
80107cf9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cff:	8b 45 08             	mov    0x8(%ebp),%eax
80107d02:	e8 79 f7 ff ff       	call   80107480 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107d07:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107d09:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107d0a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107d0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107d11:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107d14:	05 00 00 00 80       	add    $0x80000000,%eax
80107d19:	83 fa 05             	cmp    $0x5,%edx
80107d1c:	ba 00 00 00 00       	mov    $0x0,%edx
80107d21:	0f 45 c2             	cmovne %edx,%eax
}
80107d24:	c3                   	ret    
80107d25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107d30:	f3 0f 1e fb          	endbr32 
80107d34:	55                   	push   %ebp
80107d35:	89 e5                	mov    %esp,%ebp
80107d37:	57                   	push   %edi
80107d38:	56                   	push   %esi
80107d39:	53                   	push   %ebx
80107d3a:	83 ec 0c             	sub    $0xc,%esp
80107d3d:	8b 75 14             	mov    0x14(%ebp),%esi
80107d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107d43:	85 f6                	test   %esi,%esi
80107d45:	75 3c                	jne    80107d83 <copyout+0x53>
80107d47:	eb 67                	jmp    80107db0 <copyout+0x80>
80107d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107d50:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d53:	89 fb                	mov    %edi,%ebx
80107d55:	29 d3                	sub    %edx,%ebx
80107d57:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107d5d:	39 f3                	cmp    %esi,%ebx
80107d5f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107d62:	29 fa                	sub    %edi,%edx
80107d64:	83 ec 04             	sub    $0x4,%esp
80107d67:	01 c2                	add    %eax,%edx
80107d69:	53                   	push   %ebx
80107d6a:	ff 75 10             	pushl  0x10(%ebp)
80107d6d:	52                   	push   %edx
80107d6e:	e8 dd d4 ff ff       	call   80105250 <memmove>
    len -= n;
    buf += n;
80107d73:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107d76:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107d7c:	83 c4 10             	add    $0x10,%esp
80107d7f:	29 de                	sub    %ebx,%esi
80107d81:	74 2d                	je     80107db0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107d83:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107d85:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107d88:	89 55 0c             	mov    %edx,0xc(%ebp)
80107d8b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107d91:	57                   	push   %edi
80107d92:	ff 75 08             	pushl  0x8(%ebp)
80107d95:	e8 56 ff ff ff       	call   80107cf0 <uva2ka>
    if(pa0 == 0)
80107d9a:	83 c4 10             	add    $0x10,%esp
80107d9d:	85 c0                	test   %eax,%eax
80107d9f:	75 af                	jne    80107d50 <copyout+0x20>
  }
  return 0;
}
80107da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107da4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107da9:	5b                   	pop    %ebx
80107daa:	5e                   	pop    %esi
80107dab:	5f                   	pop    %edi
80107dac:	5d                   	pop    %ebp
80107dad:	c3                   	ret    
80107dae:	66 90                	xchg   %ax,%ax
80107db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107db3:	31 c0                	xor    %eax,%eax
}
80107db5:	5b                   	pop    %ebx
80107db6:	5e                   	pop    %esi
80107db7:	5f                   	pop    %edi
80107db8:	5d                   	pop    %ebp
80107db9:	c3                   	ret    

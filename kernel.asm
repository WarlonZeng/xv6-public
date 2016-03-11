
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100028:	bc 40 d0 10 80       	mov    $0x8010d040,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d2 38 10 80       	mov    $0x801038d2,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 9c 88 10 80       	push   $0x8010889c
80100042:	68 40 d0 10 80       	push   $0x8010d040
80100047:	e8 ef 50 00 00       	call   8010513b <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 50 0f 11 80 44 	movl   $0x80110f44,0x80110f50
80100056:	0f 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 54 0f 11 80 44 	movl   $0x80110f44,0x80110f54
80100060:	0f 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 74 d0 10 80 	movl   $0x8010d074,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 54 0f 11 80    	mov    0x80110f54,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 44 0f 11 80 	movl   $0x80110f44,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 54 0f 11 80       	mov    0x80110f54,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 54 0f 11 80       	mov    %eax,0x80110f54

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	81 7d f4 44 0f 11 80 	cmpl   $0x80110f44,-0xc(%ebp)
801000ad:	72 bd                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	83 ec 0c             	sub    $0xc,%esp
801000ba:	68 40 d0 10 80       	push   $0x8010d040
801000bf:	e8 98 50 00 00       	call   8010515c <acquire>
801000c4:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c7:	a1 54 0f 11 80       	mov    0x80110f54,%eax
801000cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cf:	eb 67                	jmp    80100138 <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d4:	8b 40 04             	mov    0x4(%eax),%eax
801000d7:	3b 45 08             	cmp    0x8(%ebp),%eax
801000da:	75 53                	jne    8010012f <bget+0x7e>
801000dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000df:	8b 40 08             	mov    0x8(%eax),%eax
801000e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e5:	75 48                	jne    8010012f <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ea:	8b 00                	mov    (%eax),%eax
801000ec:	83 e0 01             	and    $0x1,%eax
801000ef:	85 c0                	test   %eax,%eax
801000f1:	75 27                	jne    8010011a <bget+0x69>
        b->flags |= B_BUSY;
801000f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f6:	8b 00                	mov    (%eax),%eax
801000f8:	83 c8 01             	or     $0x1,%eax
801000fb:	89 c2                	mov    %eax,%edx
801000fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100100:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100102:	83 ec 0c             	sub    $0xc,%esp
80100105:	68 40 d0 10 80       	push   $0x8010d040
8010010a:	e8 b3 50 00 00       	call   801051c2 <release>
8010010f:	83 c4 10             	add    $0x10,%esp
        return b;
80100112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100115:	e9 98 00 00 00       	jmp    801001b2 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011a:	83 ec 08             	sub    $0x8,%esp
8010011d:	68 40 d0 10 80       	push   $0x8010d040
80100122:	ff 75 f4             	pushl  -0xc(%ebp)
80100125:	e8 45 4d 00 00       	call   80104e6f <sleep>
8010012a:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012d:	eb 98                	jmp    801000c7 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 10             	mov    0x10(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 44 0f 11 80 	cmpl   $0x80110f44,-0xc(%ebp)
8010013f:	75 90                	jne    801000d1 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 50 0f 11 80       	mov    0x80110f50,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 51                	jmp    8010019c <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 00                	mov    (%eax),%eax
80100150:	83 e0 01             	and    $0x1,%eax
80100153:	85 c0                	test   %eax,%eax
80100155:	75 3c                	jne    80100193 <bget+0xe2>
80100157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015a:	8b 00                	mov    (%eax),%eax
8010015c:	83 e0 04             	and    $0x4,%eax
8010015f:	85 c0                	test   %eax,%eax
80100161:	75 30                	jne    80100193 <bget+0xe2>
      b->dev = dev;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 08             	mov    0x8(%ebp),%edx
80100169:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100172:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100178:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017e:	83 ec 0c             	sub    $0xc,%esp
80100181:	68 40 d0 10 80       	push   $0x8010d040
80100186:	e8 37 50 00 00       	call   801051c2 <release>
8010018b:	83 c4 10             	add    $0x10,%esp
      return b;
8010018e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100191:	eb 1f                	jmp    801001b2 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100196:	8b 40 0c             	mov    0xc(%eax),%eax
80100199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019c:	81 7d f4 44 0f 11 80 	cmpl   $0x80110f44,-0xc(%ebp)
801001a3:	75 a6                	jne    8010014b <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	68 a3 88 10 80       	push   $0x801088a3
801001ad:	e8 17 04 00 00       	call   801005c9 <panic>
}
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    

801001b4 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ba:	83 ec 08             	sub    $0x8,%esp
801001bd:	ff 75 0c             	pushl  0xc(%ebp)
801001c0:	ff 75 08             	pushl  0x8(%ebp)
801001c3:	e8 e9 fe ff ff       	call   801000b1 <bget>
801001c8:	83 c4 10             	add    $0x10,%esp
801001cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	8b 00                	mov    (%eax),%eax
801001d3:	83 e0 02             	and    $0x2,%eax
801001d6:	85 c0                	test   %eax,%eax
801001d8:	75 0e                	jne    801001e8 <bread+0x34>
    iderw(b);
801001da:	83 ec 0c             	sub    $0xc,%esp
801001dd:	ff 75 f4             	pushl  -0xc(%ebp)
801001e0:	e8 fc 26 00 00       	call   801028e1 <iderw>
801001e5:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001eb:	c9                   	leave  
801001ec:	c3                   	ret    

801001ed <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ed:	55                   	push   %ebp
801001ee:	89 e5                	mov    %esp,%ebp
801001f0:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f3:	8b 45 08             	mov    0x8(%ebp),%eax
801001f6:	8b 00                	mov    (%eax),%eax
801001f8:	83 e0 01             	and    $0x1,%eax
801001fb:	85 c0                	test   %eax,%eax
801001fd:	75 0d                	jne    8010020c <bwrite+0x1f>
    panic("bwrite");
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	68 b4 88 10 80       	push   $0x801088b4
80100207:	e8 bd 03 00 00       	call   801005c9 <panic>
  b->flags |= B_DIRTY;
8010020c:	8b 45 08             	mov    0x8(%ebp),%eax
8010020f:	8b 00                	mov    (%eax),%eax
80100211:	83 c8 04             	or     $0x4,%eax
80100214:	89 c2                	mov    %eax,%edx
80100216:	8b 45 08             	mov    0x8(%ebp),%eax
80100219:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	ff 75 08             	pushl  0x8(%ebp)
80100221:	e8 bb 26 00 00       	call   801028e1 <iderw>
80100226:	83 c4 10             	add    $0x10,%esp
}
80100229:	c9                   	leave  
8010022a:	c3                   	ret    

8010022b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022b:	55                   	push   %ebp
8010022c:	89 e5                	mov    %esp,%ebp
8010022e:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 e0 01             	and    $0x1,%eax
80100239:	85 c0                	test   %eax,%eax
8010023b:	75 0d                	jne    8010024a <brelse+0x1f>
    panic("brelse");
8010023d:	83 ec 0c             	sub    $0xc,%esp
80100240:	68 bb 88 10 80       	push   $0x801088bb
80100245:	e8 7f 03 00 00       	call   801005c9 <panic>

  acquire(&bcache.lock);
8010024a:	83 ec 0c             	sub    $0xc,%esp
8010024d:	68 40 d0 10 80       	push   $0x8010d040
80100252:	e8 05 4f 00 00       	call   8010515c <acquire>
80100257:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025a:	8b 45 08             	mov    0x8(%ebp),%eax
8010025d:	8b 40 10             	mov    0x10(%eax),%eax
80100260:	8b 55 08             	mov    0x8(%ebp),%edx
80100263:	8b 52 0c             	mov    0xc(%edx),%edx
80100266:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100269:	8b 45 08             	mov    0x8(%ebp),%eax
8010026c:	8b 40 0c             	mov    0xc(%eax),%eax
8010026f:	8b 55 08             	mov    0x8(%ebp),%edx
80100272:	8b 52 10             	mov    0x10(%edx),%edx
80100275:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100278:	8b 15 54 0f 11 80    	mov    0x80110f54,%edx
8010027e:	8b 45 08             	mov    0x8(%ebp),%eax
80100281:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100284:	8b 45 08             	mov    0x8(%ebp),%eax
80100287:	c7 40 0c 44 0f 11 80 	movl   $0x80110f44,0xc(%eax)
  bcache.head.next->prev = b;
8010028e:	a1 54 0f 11 80       	mov    0x80110f54,%eax
80100293:	8b 55 08             	mov    0x8(%ebp),%edx
80100296:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100299:	8b 45 08             	mov    0x8(%ebp),%eax
8010029c:	a3 54 0f 11 80       	mov    %eax,0x80110f54

  b->flags &= ~B_BUSY;
801002a1:	8b 45 08             	mov    0x8(%ebp),%eax
801002a4:	8b 00                	mov    (%eax),%eax
801002a6:	83 e0 fe             	and    $0xfffffffe,%eax
801002a9:	89 c2                	mov    %eax,%edx
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b0:	83 ec 0c             	sub    $0xc,%esp
801002b3:	ff 75 08             	pushl  0x8(%ebp)
801002b6:	e8 9d 4c 00 00       	call   80104f58 <wakeup>
801002bb:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 40 d0 10 80       	push   $0x8010d040
801002c6:	e8 f7 4e 00 00       	call   801051c2 <release>
801002cb:	83 c4 10             	add    $0x10,%esp
}
801002ce:	c9                   	leave  
801002cf:	c3                   	ret    

801002d0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	83 ec 14             	sub    $0x14,%esp
801002d6:	8b 45 08             	mov    0x8(%ebp),%eax
801002d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801002e0:	89 c2                	mov    %eax,%edx
801002e2:	ec                   	in     (%dx),%al
801002e3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002e6:	8a 45 ff             	mov    -0x1(%ebp),%al
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
801002ee:	83 ec 08             	sub    $0x8,%esp
801002f1:	8b 45 08             	mov    0x8(%ebp),%eax
801002f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801002f7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801002fb:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002fe:	8a 45 f8             	mov    -0x8(%ebp),%al
80100301:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100304:	ee                   	out    %al,(%dx)
}
80100305:	c9                   	leave  
80100306:	c3                   	ret    

80100307 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100307:	55                   	push   %ebp
80100308:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010030a:	fa                   	cli    
}
8010030b:	5d                   	pop    %ebp
8010030c:	c3                   	ret    

8010030d <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010030d:	55                   	push   %ebp
8010030e:	89 e5                	mov    %esp,%ebp
80100310:	53                   	push   %ebx
80100311:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100318:	74 1c                	je     80100336 <printint+0x29>
8010031a:	8b 45 08             	mov    0x8(%ebp),%eax
8010031d:	c1 e8 1f             	shr    $0x1f,%eax
80100320:	0f b6 c0             	movzbl %al,%eax
80100323:	89 45 10             	mov    %eax,0x10(%ebp)
80100326:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010032a:	74 0a                	je     80100336 <printint+0x29>
    x = -xx;
8010032c:	8b 45 08             	mov    0x8(%ebp),%eax
8010032f:	f7 d8                	neg    %eax
80100331:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100334:	eb 06                	jmp    8010033c <printint+0x2f>
  else
    x = xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010033c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100343:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100346:	8d 41 01             	lea    0x1(%ecx),%eax
80100349:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010034c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010034f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100352:	ba 00 00 00 00       	mov    $0x0,%edx
80100357:	f7 f3                	div    %ebx
80100359:	89 d0                	mov    %edx,%eax
8010035b:	8a 80 04 90 10 80    	mov    -0x7fef6ffc(%eax),%al
80100361:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100365:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100368:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010036b:	ba 00 00 00 00       	mov    $0x0,%edx
80100370:	f7 f3                	div    %ebx
80100372:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100375:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100379:	75 c8                	jne    80100343 <printint+0x36>

  if(sign)
8010037b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010037f:	74 0e                	je     8010038f <printint+0x82>
    buf[i++] = '-';
80100381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100384:	8d 50 01             	lea    0x1(%eax),%edx
80100387:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010038a:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010038f:	eb 19                	jmp    801003aa <printint+0x9d>
    consputc(buf[i]);
80100391:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100397:	01 d0                	add    %edx,%eax
80100399:	8a 00                	mov    (%eax),%al
8010039b:	0f be c0             	movsbl %al,%eax
8010039e:	83 ec 0c             	sub    $0xc,%esp
801003a1:	50                   	push   %eax
801003a2:	e8 37 04 00 00       	call   801007de <consputc>
801003a7:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003aa:	ff 4d f4             	decl   -0xc(%ebp)
801003ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b1:	79 de                	jns    80100391 <printint+0x84>
    consputc(buf[i]);
}
801003b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003b6:	c9                   	leave  
801003b7:	c3                   	ret    

801003b8 <printlong>:

static void
printlong(unsigned long long xx, int base, int sgn)
{
801003b8:	55                   	push   %ebp
801003b9:	89 e5                	mov    %esp,%ebp
801003bb:	83 ec 28             	sub    $0x28,%esp
801003be:	8b 45 08             	mov    0x8(%ebp),%eax
801003c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801003c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801003c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
801003ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801003cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801003d0:	89 d0                	mov    %edx,%eax
801003d2:	31 d2                	xor    %edx,%edx
801003d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
801003d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801003da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(upper, 16, 0);
801003dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003e1:	74 13                	je     801003f6 <printlong+0x3e>
801003e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003e6:	83 ec 04             	sub    $0x4,%esp
801003e9:	6a 00                	push   $0x0
801003eb:	6a 10                	push   $0x10
801003ed:	50                   	push   %eax
801003ee:	e8 1a ff ff ff       	call   8010030d <printint>
801003f3:	83 c4 10             	add    $0x10,%esp
    printint(lower, 16, 0);
801003f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003f9:	83 ec 04             	sub    $0x4,%esp
801003fc:	6a 00                	push   $0x0
801003fe:	6a 10                	push   $0x10
80100400:	50                   	push   %eax
80100401:	e8 07 ff ff ff       	call   8010030d <printint>
80100406:	83 c4 10             	add    $0x10,%esp
}
80100409:	c9                   	leave  
8010040a:	c3                   	ret    

8010040b <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010040b:	55                   	push   %ebp
8010040c:	89 e5                	mov    %esp,%ebp
8010040e:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100411:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80100416:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100419:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010041d:	74 10                	je     8010042f <cprintf+0x24>
    acquire(&cons.lock);
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 e0 b5 10 80       	push   $0x8010b5e0
80100427:	e8 30 4d 00 00       	call   8010515c <acquire>
8010042c:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
8010042f:	8b 45 08             	mov    0x8(%ebp),%eax
80100432:	85 c0                	test   %eax,%eax
80100434:	75 0d                	jne    80100443 <cprintf+0x38>
    panic("null fmt");
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	68 c2 88 10 80       	push   $0x801088c2
8010043e:	e8 86 01 00 00       	call   801005c9 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100443:	8d 45 0c             	lea    0xc(%ebp),%eax
80100446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100450:	e9 3d 01 00 00       	jmp    80100592 <cprintf+0x187>
    if(c != '%'){
80100455:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100459:	74 13                	je     8010046e <cprintf+0x63>
      consputc(c);
8010045b:	83 ec 0c             	sub    $0xc,%esp
8010045e:	ff 75 e4             	pushl  -0x1c(%ebp)
80100461:	e8 78 03 00 00       	call   801007de <consputc>
80100466:	83 c4 10             	add    $0x10,%esp
      continue;
80100469:	e9 21 01 00 00       	jmp    8010058f <cprintf+0x184>
    }
    c = fmt[++i] & 0xff;
8010046e:	8b 55 08             	mov    0x8(%ebp),%edx
80100471:	ff 45 f4             	incl   -0xc(%ebp)
80100474:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100477:	01 d0                	add    %edx,%eax
80100479:	8a 00                	mov    (%eax),%al
8010047b:	0f be c0             	movsbl %al,%eax
8010047e:	25 ff 00 00 00       	and    $0xff,%eax
80100483:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100486:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010048a:	75 05                	jne    80100491 <cprintf+0x86>
      break;
8010048c:	e9 20 01 00 00       	jmp    801005b1 <cprintf+0x1a6>
    switch(c){
80100491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100494:	83 f8 6c             	cmp    $0x6c,%eax
80100497:	74 4c                	je     801004e5 <cprintf+0xda>
80100499:	83 f8 6c             	cmp    $0x6c,%eax
8010049c:	7f 13                	jg     801004b1 <cprintf+0xa6>
8010049e:	83 f8 25             	cmp    $0x25,%eax
801004a1:	0f 84 bd 00 00 00    	je     80100564 <cprintf+0x159>
801004a7:	83 f8 64             	cmp    $0x64,%eax
801004aa:	74 19                	je     801004c5 <cprintf+0xba>
801004ac:	e9 c2 00 00 00       	jmp    80100573 <cprintf+0x168>
801004b1:	83 f8 73             	cmp    $0x73,%eax
801004b4:	74 6f                	je     80100525 <cprintf+0x11a>
801004b6:	83 f8 78             	cmp    $0x78,%eax
801004b9:	74 4d                	je     80100508 <cprintf+0xfd>
801004bb:	83 f8 70             	cmp    $0x70,%eax
801004be:	74 48                	je     80100508 <cprintf+0xfd>
801004c0:	e9 ae 00 00 00       	jmp    80100573 <cprintf+0x168>
    case 'd':
      printint(*argp++, 10, 1);
801004c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c8:	8d 50 04             	lea    0x4(%eax),%edx
801004cb:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004ce:	8b 00                	mov    (%eax),%eax
801004d0:	83 ec 04             	sub    $0x4,%esp
801004d3:	6a 01                	push   $0x1
801004d5:	6a 0a                	push   $0xa
801004d7:	50                   	push   %eax
801004d8:	e8 30 fe ff ff       	call   8010030d <printint>
801004dd:	83 c4 10             	add    $0x10,%esp
      break;
801004e0:	e9 aa 00 00 00       	jmp    8010058f <cprintf+0x184>
    case 'l':
        printlong(*(unsigned long long *)argp, 10, 0);
801004e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004e8:	8b 50 04             	mov    0x4(%eax),%edx
801004eb:	8b 00                	mov    (%eax),%eax
801004ed:	6a 00                	push   $0x0
801004ef:	6a 0a                	push   $0xa
801004f1:	52                   	push   %edx
801004f2:	50                   	push   %eax
801004f3:	e8 c0 fe ff ff       	call   801003b8 <printlong>
801004f8:	83 c4 10             	add    $0x10,%esp
        // long longs take up 2 argument slots
        argp++;
801004fb:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
        argp++;
801004ff:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
        break;
80100503:	e9 87 00 00 00       	jmp    8010058f <cprintf+0x184>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100508:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010050b:	8d 50 04             	lea    0x4(%eax),%edx
8010050e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100511:	8b 00                	mov    (%eax),%eax
80100513:	83 ec 04             	sub    $0x4,%esp
80100516:	6a 00                	push   $0x0
80100518:	6a 10                	push   $0x10
8010051a:	50                   	push   %eax
8010051b:	e8 ed fd ff ff       	call   8010030d <printint>
80100520:	83 c4 10             	add    $0x10,%esp
      break;
80100523:	eb 6a                	jmp    8010058f <cprintf+0x184>
    case 's':
      if((s = (char*)*argp++) == 0)
80100525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100528:	8d 50 04             	lea    0x4(%eax),%edx
8010052b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010052e:	8b 00                	mov    (%eax),%eax
80100530:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100533:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100537:	75 07                	jne    80100540 <cprintf+0x135>
        s = "(null)";
80100539:	c7 45 ec cb 88 10 80 	movl   $0x801088cb,-0x14(%ebp)
      for(; *s; s++)
80100540:	eb 17                	jmp    80100559 <cprintf+0x14e>
        consputc(*s);
80100542:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100545:	8a 00                	mov    (%eax),%al
80100547:	0f be c0             	movsbl %al,%eax
8010054a:	83 ec 0c             	sub    $0xc,%esp
8010054d:	50                   	push   %eax
8010054e:	e8 8b 02 00 00       	call   801007de <consputc>
80100553:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100556:	ff 45 ec             	incl   -0x14(%ebp)
80100559:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010055c:	8a 00                	mov    (%eax),%al
8010055e:	84 c0                	test   %al,%al
80100560:	75 e0                	jne    80100542 <cprintf+0x137>
        consputc(*s);
      break;
80100562:	eb 2b                	jmp    8010058f <cprintf+0x184>
    case '%':
      consputc('%');
80100564:	83 ec 0c             	sub    $0xc,%esp
80100567:	6a 25                	push   $0x25
80100569:	e8 70 02 00 00       	call   801007de <consputc>
8010056e:	83 c4 10             	add    $0x10,%esp
      break;
80100571:	eb 1c                	jmp    8010058f <cprintf+0x184>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100573:	83 ec 0c             	sub    $0xc,%esp
80100576:	6a 25                	push   $0x25
80100578:	e8 61 02 00 00       	call   801007de <consputc>
8010057d:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100580:	83 ec 0c             	sub    $0xc,%esp
80100583:	ff 75 e4             	pushl  -0x1c(%ebp)
80100586:	e8 53 02 00 00       	call   801007de <consputc>
8010058b:	83 c4 10             	add    $0x10,%esp
      break;
8010058e:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010058f:	ff 45 f4             	incl   -0xc(%ebp)
80100592:	8b 55 08             	mov    0x8(%ebp),%edx
80100595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100598:	01 d0                	add    %edx,%eax
8010059a:	8a 00                	mov    (%eax),%al
8010059c:	0f be c0             	movsbl %al,%eax
8010059f:	25 ff 00 00 00       	and    $0xff,%eax
801005a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801005ab:	0f 85 a4 fe ff ff    	jne    80100455 <cprintf+0x4a>
      consputc(c);
      break;
    }
  }

  if(locking)
801005b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801005b5:	74 10                	je     801005c7 <cprintf+0x1bc>
    release(&cons.lock);
801005b7:	83 ec 0c             	sub    $0xc,%esp
801005ba:	68 e0 b5 10 80       	push   $0x8010b5e0
801005bf:	e8 fe 4b 00 00       	call   801051c2 <release>
801005c4:	83 c4 10             	add    $0x10,%esp
}
801005c7:	c9                   	leave  
801005c8:	c3                   	ret    

801005c9 <panic>:

void
panic(char *s)
{
801005c9:	55                   	push   %ebp
801005ca:	89 e5                	mov    %esp,%ebp
801005cc:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
801005cf:	e8 33 fd ff ff       	call   80100307 <cli>
  cons.locking = 0;
801005d4:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
801005db:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
801005de:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801005e4:	8a 00                	mov    (%eax),%al
801005e6:	0f b6 c0             	movzbl %al,%eax
801005e9:	83 ec 08             	sub    $0x8,%esp
801005ec:	50                   	push   %eax
801005ed:	68 d2 88 10 80       	push   $0x801088d2
801005f2:	e8 14 fe ff ff       	call   8010040b <cprintf>
801005f7:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005fa:	8b 45 08             	mov    0x8(%ebp),%eax
801005fd:	83 ec 0c             	sub    $0xc,%esp
80100600:	50                   	push   %eax
80100601:	e8 05 fe ff ff       	call   8010040b <cprintf>
80100606:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80100609:	83 ec 0c             	sub    $0xc,%esp
8010060c:	68 e1 88 10 80       	push   $0x801088e1
80100611:	e8 f5 fd ff ff       	call   8010040b <cprintf>
80100616:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
80100619:	83 ec 08             	sub    $0x8,%esp
8010061c:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010061f:	50                   	push   %eax
80100620:	8d 45 08             	lea    0x8(%ebp),%eax
80100623:	50                   	push   %eax
80100624:	e8 ea 4b 00 00       	call   80105213 <getcallerpcs>
80100629:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
8010062c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100633:	eb 1b                	jmp    80100650 <panic+0x87>
    cprintf(" %p", pcs[i]);
80100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100638:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010063c:	83 ec 08             	sub    $0x8,%esp
8010063f:	50                   	push   %eax
80100640:	68 e3 88 10 80       	push   $0x801088e3
80100645:	e8 c1 fd ff ff       	call   8010040b <cprintf>
8010064a:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010064d:	ff 45 f4             	incl   -0xc(%ebp)
80100650:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100654:	7e df                	jle    80100635 <panic+0x6c>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100656:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
8010065d:	00 00 00 
  for(;;)
    ;
80100660:	eb fe                	jmp    80100660 <panic+0x97>

80100662 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100662:	55                   	push   %ebp
80100663:	89 e5                	mov    %esp,%ebp
80100665:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100668:	6a 0e                	push   $0xe
8010066a:	68 d4 03 00 00       	push   $0x3d4
8010066f:	e8 77 fc ff ff       	call   801002eb <outb>
80100674:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100677:	68 d5 03 00 00       	push   $0x3d5
8010067c:	e8 4f fc ff ff       	call   801002d0 <inb>
80100681:	83 c4 04             	add    $0x4,%esp
80100684:	0f b6 c0             	movzbl %al,%eax
80100687:	c1 e0 08             	shl    $0x8,%eax
8010068a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010068d:	6a 0f                	push   $0xf
8010068f:	68 d4 03 00 00       	push   $0x3d4
80100694:	e8 52 fc ff ff       	call   801002eb <outb>
80100699:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010069c:	68 d5 03 00 00       	push   $0x3d5
801006a1:	e8 2a fc ff ff       	call   801002d0 <inb>
801006a6:	83 c4 04             	add    $0x4,%esp
801006a9:	0f b6 c0             	movzbl %al,%eax
801006ac:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
801006af:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
801006b3:	75 1b                	jne    801006d0 <cgaputc+0x6e>
    pos += 80 - pos%80;
801006b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006b8:	b9 50 00 00 00       	mov    $0x50,%ecx
801006bd:	99                   	cltd   
801006be:	f7 f9                	idiv   %ecx
801006c0:	89 d0                	mov    %edx,%eax
801006c2:	ba 50 00 00 00       	mov    $0x50,%edx
801006c7:	29 c2                	sub    %eax,%edx
801006c9:	89 d0                	mov    %edx,%eax
801006cb:	01 45 f4             	add    %eax,-0xc(%ebp)
801006ce:	eb 34                	jmp    80100704 <cgaputc+0xa2>
  else if(c == BACKSPACE){
801006d0:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006d7:	75 0b                	jne    801006e4 <cgaputc+0x82>
    if(pos > 0) --pos;
801006d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006dd:	7e 25                	jle    80100704 <cgaputc+0xa2>
801006df:	ff 4d f4             	decl   -0xc(%ebp)
801006e2:	eb 20                	jmp    80100704 <cgaputc+0xa2>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006e4:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
801006ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006ed:	8d 50 01             	lea    0x1(%eax),%edx
801006f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006f3:	01 c0                	add    %eax,%eax
801006f5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801006f8:	8b 45 08             	mov    0x8(%ebp),%eax
801006fb:	0f b6 c0             	movzbl %al,%eax
801006fe:	80 cc 07             	or     $0x7,%ah
80100701:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
80100704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100708:	78 09                	js     80100713 <cgaputc+0xb1>
8010070a:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100711:	7e 0d                	jle    80100720 <cgaputc+0xbe>
    panic("pos under/overflow");
80100713:	83 ec 0c             	sub    $0xc,%esp
80100716:	68 e7 88 10 80       	push   $0x801088e7
8010071b:	e8 a9 fe ff ff       	call   801005c9 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
80100720:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100727:	7e 4c                	jle    80100775 <cgaputc+0x113>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100729:	a1 00 90 10 80       	mov    0x80109000,%eax
8010072e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100734:	a1 00 90 10 80       	mov    0x80109000,%eax
80100739:	83 ec 04             	sub    $0x4,%esp
8010073c:	68 60 0e 00 00       	push   $0xe60
80100741:	52                   	push   %edx
80100742:	50                   	push   %eax
80100743:	e8 25 4d 00 00       	call   8010546d <memmove>
80100748:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
8010074b:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010074f:	b8 80 07 00 00       	mov    $0x780,%eax
80100754:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100757:	01 c0                	add    %eax,%eax
80100759:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
8010075f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100762:	01 d2                	add    %edx,%edx
80100764:	01 ca                	add    %ecx,%edx
80100766:	83 ec 04             	sub    $0x4,%esp
80100769:	50                   	push   %eax
8010076a:	6a 00                	push   $0x0
8010076c:	52                   	push   %edx
8010076d:	e8 42 4c 00 00       	call   801053b4 <memset>
80100772:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100775:	83 ec 08             	sub    $0x8,%esp
80100778:	6a 0e                	push   $0xe
8010077a:	68 d4 03 00 00       	push   $0x3d4
8010077f:	e8 67 fb ff ff       	call   801002eb <outb>
80100784:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010078a:	c1 f8 08             	sar    $0x8,%eax
8010078d:	0f b6 c0             	movzbl %al,%eax
80100790:	83 ec 08             	sub    $0x8,%esp
80100793:	50                   	push   %eax
80100794:	68 d5 03 00 00       	push   $0x3d5
80100799:	e8 4d fb ff ff       	call   801002eb <outb>
8010079e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007a1:	83 ec 08             	sub    $0x8,%esp
801007a4:	6a 0f                	push   $0xf
801007a6:	68 d4 03 00 00       	push   $0x3d4
801007ab:	e8 3b fb ff ff       	call   801002eb <outb>
801007b0:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
801007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007b6:	0f b6 c0             	movzbl %al,%eax
801007b9:	83 ec 08             	sub    $0x8,%esp
801007bc:	50                   	push   %eax
801007bd:	68 d5 03 00 00       	push   $0x3d5
801007c2:	e8 24 fb ff ff       	call   801002eb <outb>
801007c7:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007ca:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007d3:	01 c0                	add    %eax,%eax
801007d5:	01 d0                	add    %edx,%eax
801007d7:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007dc:	c9                   	leave  
801007dd:	c3                   	ret    

801007de <consputc>:

void
consputc(int c)
{
801007de:	55                   	push   %ebp
801007df:	89 e5                	mov    %esp,%ebp
801007e1:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007e4:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
801007e9:	85 c0                	test   %eax,%eax
801007eb:	74 07                	je     801007f4 <consputc+0x16>
    cli();
801007ed:	e8 15 fb ff ff       	call   80100307 <cli>
    for(;;)
      ;
801007f2:	eb fe                	jmp    801007f2 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007f4:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007fb:	75 29                	jne    80100826 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	6a 08                	push   $0x8
80100802:	e8 06 65 00 00       	call   80106d0d <uartputc>
80100807:	83 c4 10             	add    $0x10,%esp
8010080a:	83 ec 0c             	sub    $0xc,%esp
8010080d:	6a 20                	push   $0x20
8010080f:	e8 f9 64 00 00       	call   80106d0d <uartputc>
80100814:	83 c4 10             	add    $0x10,%esp
80100817:	83 ec 0c             	sub    $0xc,%esp
8010081a:	6a 08                	push   $0x8
8010081c:	e8 ec 64 00 00       	call   80106d0d <uartputc>
80100821:	83 c4 10             	add    $0x10,%esp
80100824:	eb 0e                	jmp    80100834 <consputc+0x56>
  } else
    uartputc(c);
80100826:	83 ec 0c             	sub    $0xc,%esp
80100829:	ff 75 08             	pushl  0x8(%ebp)
8010082c:	e8 dc 64 00 00       	call   80106d0d <uartputc>
80100831:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100834:	83 ec 0c             	sub    $0xc,%esp
80100837:	ff 75 08             	pushl  0x8(%ebp)
8010083a:	e8 23 fe ff ff       	call   80100662 <cgaputc>
8010083f:	83 c4 10             	add    $0x10,%esp
}
80100842:	c9                   	leave  
80100843:	c3                   	ret    

80100844 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100844:	55                   	push   %ebp
80100845:	89 e5                	mov    %esp,%ebp
80100847:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
8010084a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100851:	83 ec 0c             	sub    $0xc,%esp
80100854:	68 e0 b5 10 80       	push   $0x8010b5e0
80100859:	e8 fe 48 00 00       	call   8010515c <acquire>
8010085e:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100861:	e9 34 01 00 00       	jmp    8010099a <consoleintr+0x156>
    switch(c){
80100866:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100869:	83 f8 10             	cmp    $0x10,%eax
8010086c:	74 1b                	je     80100889 <consoleintr+0x45>
8010086e:	83 f8 10             	cmp    $0x10,%eax
80100871:	7f 0a                	jg     8010087d <consoleintr+0x39>
80100873:	83 f8 08             	cmp    $0x8,%eax
80100876:	74 5f                	je     801008d7 <consoleintr+0x93>
80100878:	e9 89 00 00 00       	jmp    80100906 <consoleintr+0xc2>
8010087d:	83 f8 15             	cmp    $0x15,%eax
80100880:	74 2e                	je     801008b0 <consoleintr+0x6c>
80100882:	83 f8 7f             	cmp    $0x7f,%eax
80100885:	74 50                	je     801008d7 <consoleintr+0x93>
80100887:	eb 7d                	jmp    80100906 <consoleintr+0xc2>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100889:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100890:	e9 05 01 00 00       	jmp    8010099a <consoleintr+0x156>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100895:	a1 e8 11 11 80       	mov    0x801111e8,%eax
8010089a:	48                   	dec    %eax
8010089b:	a3 e8 11 11 80       	mov    %eax,0x801111e8
        consputc(BACKSPACE);
801008a0:	83 ec 0c             	sub    $0xc,%esp
801008a3:	68 00 01 00 00       	push   $0x100
801008a8:	e8 31 ff ff ff       	call   801007de <consputc>
801008ad:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008b0:	8b 15 e8 11 11 80    	mov    0x801111e8,%edx
801008b6:	a1 e4 11 11 80       	mov    0x801111e4,%eax
801008bb:	39 c2                	cmp    %eax,%edx
801008bd:	74 13                	je     801008d2 <consoleintr+0x8e>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008bf:	a1 e8 11 11 80       	mov    0x801111e8,%eax
801008c4:	48                   	dec    %eax
801008c5:	83 e0 7f             	and    $0x7f,%eax
801008c8:	8a 80 60 11 11 80    	mov    -0x7feeeea0(%eax),%al
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008ce:	3c 0a                	cmp    $0xa,%al
801008d0:	75 c3                	jne    80100895 <consoleintr+0x51>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008d2:	e9 c3 00 00 00       	jmp    8010099a <consoleintr+0x156>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008d7:	8b 15 e8 11 11 80    	mov    0x801111e8,%edx
801008dd:	a1 e4 11 11 80       	mov    0x801111e4,%eax
801008e2:	39 c2                	cmp    %eax,%edx
801008e4:	74 1b                	je     80100901 <consoleintr+0xbd>
        input.e--;
801008e6:	a1 e8 11 11 80       	mov    0x801111e8,%eax
801008eb:	48                   	dec    %eax
801008ec:	a3 e8 11 11 80       	mov    %eax,0x801111e8
        consputc(BACKSPACE);
801008f1:	83 ec 0c             	sub    $0xc,%esp
801008f4:	68 00 01 00 00       	push   $0x100
801008f9:	e8 e0 fe ff ff       	call   801007de <consputc>
801008fe:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100901:	e9 94 00 00 00       	jmp    8010099a <consoleintr+0x156>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100906:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010090a:	0f 84 89 00 00 00    	je     80100999 <consoleintr+0x155>
80100910:	8b 15 e8 11 11 80    	mov    0x801111e8,%edx
80100916:	a1 e0 11 11 80       	mov    0x801111e0,%eax
8010091b:	29 c2                	sub    %eax,%edx
8010091d:	89 d0                	mov    %edx,%eax
8010091f:	83 f8 7f             	cmp    $0x7f,%eax
80100922:	77 75                	ja     80100999 <consoleintr+0x155>
        c = (c == '\r') ? '\n' : c;
80100924:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100928:	74 05                	je     8010092f <consoleintr+0xeb>
8010092a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010092d:	eb 05                	jmp    80100934 <consoleintr+0xf0>
8010092f:	b8 0a 00 00 00       	mov    $0xa,%eax
80100934:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100937:	a1 e8 11 11 80       	mov    0x801111e8,%eax
8010093c:	8d 50 01             	lea    0x1(%eax),%edx
8010093f:	89 15 e8 11 11 80    	mov    %edx,0x801111e8
80100945:	83 e0 7f             	and    $0x7f,%eax
80100948:	89 c2                	mov    %eax,%edx
8010094a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010094d:	88 82 60 11 11 80    	mov    %al,-0x7feeeea0(%edx)
        consputc(c);
80100953:	83 ec 0c             	sub    $0xc,%esp
80100956:	ff 75 f0             	pushl  -0x10(%ebp)
80100959:	e8 80 fe ff ff       	call   801007de <consputc>
8010095e:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100961:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100965:	74 18                	je     8010097f <consoleintr+0x13b>
80100967:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010096b:	74 12                	je     8010097f <consoleintr+0x13b>
8010096d:	a1 e8 11 11 80       	mov    0x801111e8,%eax
80100972:	8b 15 e0 11 11 80    	mov    0x801111e0,%edx
80100978:	83 ea 80             	sub    $0xffffff80,%edx
8010097b:	39 d0                	cmp    %edx,%eax
8010097d:	75 1a                	jne    80100999 <consoleintr+0x155>
          input.w = input.e;
8010097f:	a1 e8 11 11 80       	mov    0x801111e8,%eax
80100984:	a3 e4 11 11 80       	mov    %eax,0x801111e4
          wakeup(&input.r);
80100989:	83 ec 0c             	sub    $0xc,%esp
8010098c:	68 e0 11 11 80       	push   $0x801111e0
80100991:	e8 c2 45 00 00       	call   80104f58 <wakeup>
80100996:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100999:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010099a:	8b 45 08             	mov    0x8(%ebp),%eax
8010099d:	ff d0                	call   *%eax
8010099f:	89 45 f0             	mov    %eax,-0x10(%ebp)
801009a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009a6:	0f 89 ba fe ff ff    	jns    80100866 <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009ac:	83 ec 0c             	sub    $0xc,%esp
801009af:	68 e0 b5 10 80       	push   $0x8010b5e0
801009b4:	e8 09 48 00 00       	call   801051c2 <release>
801009b9:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009c0:	74 05                	je     801009c7 <consoleintr+0x183>
    procdump();  // now call procdump() wo. cons.lock held
801009c2:	e8 4b 46 00 00       	call   80105012 <procdump>
  }
}
801009c7:	c9                   	leave  
801009c8:	c3                   	ret    

801009c9 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009c9:	55                   	push   %ebp
801009ca:	89 e5                	mov    %esp,%ebp
801009cc:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009cf:	83 ec 0c             	sub    $0xc,%esp
801009d2:	ff 75 08             	pushl  0x8(%ebp)
801009d5:	e8 d6 10 00 00       	call   80101ab0 <iunlock>
801009da:	83 c4 10             	add    $0x10,%esp
  target = n;
801009dd:	8b 45 10             	mov    0x10(%ebp),%eax
801009e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	68 e0 b5 10 80       	push   $0x8010b5e0
801009eb:	e8 6c 47 00 00       	call   8010515c <acquire>
801009f0:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009f3:	e9 ae 00 00 00       	jmp    80100aa6 <consoleread+0xdd>
    while(input.r == input.w){
801009f8:	eb 4a                	jmp    80100a44 <consoleread+0x7b>
      if(proc->killed){
801009fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a00:	8b 40 24             	mov    0x24(%eax),%eax
80100a03:	85 c0                	test   %eax,%eax
80100a05:	74 28                	je     80100a2f <consoleread+0x66>
        release(&cons.lock);
80100a07:	83 ec 0c             	sub    $0xc,%esp
80100a0a:	68 e0 b5 10 80       	push   $0x8010b5e0
80100a0f:	e8 ae 47 00 00       	call   801051c2 <release>
80100a14:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	ff 75 08             	pushl  0x8(%ebp)
80100a1d:	e8 34 0f 00 00       	call   80101956 <ilock>
80100a22:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a2a:	e9 a9 00 00 00       	jmp    80100ad8 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a2f:	83 ec 08             	sub    $0x8,%esp
80100a32:	68 e0 b5 10 80       	push   $0x8010b5e0
80100a37:	68 e0 11 11 80       	push   $0x801111e0
80100a3c:	e8 2e 44 00 00       	call   80104e6f <sleep>
80100a41:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a44:	8b 15 e0 11 11 80    	mov    0x801111e0,%edx
80100a4a:	a1 e4 11 11 80       	mov    0x801111e4,%eax
80100a4f:	39 c2                	cmp    %eax,%edx
80100a51:	74 a7                	je     801009fa <consoleread+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a53:	a1 e0 11 11 80       	mov    0x801111e0,%eax
80100a58:	8d 50 01             	lea    0x1(%eax),%edx
80100a5b:	89 15 e0 11 11 80    	mov    %edx,0x801111e0
80100a61:	83 e0 7f             	and    $0x7f,%eax
80100a64:	8a 80 60 11 11 80    	mov    -0x7feeeea0(%eax),%al
80100a6a:	0f be c0             	movsbl %al,%eax
80100a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a70:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a74:	75 17                	jne    80100a8d <consoleread+0xc4>
      if(n < target){
80100a76:	8b 45 10             	mov    0x10(%ebp),%eax
80100a79:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a7c:	73 0d                	jae    80100a8b <consoleread+0xc2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a7e:	a1 e0 11 11 80       	mov    0x801111e0,%eax
80100a83:	48                   	dec    %eax
80100a84:	a3 e0 11 11 80       	mov    %eax,0x801111e0
      }
      break;
80100a89:	eb 25                	jmp    80100ab0 <consoleread+0xe7>
80100a8b:	eb 23                	jmp    80100ab0 <consoleread+0xe7>
    }
    *dst++ = c;
80100a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a90:	8d 50 01             	lea    0x1(%eax),%edx
80100a93:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a96:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a99:	88 10                	mov    %dl,(%eax)
    --n;
80100a9b:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100a9e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100aa2:	75 02                	jne    80100aa6 <consoleread+0xdd>
      break;
80100aa4:	eb 0a                	jmp    80100ab0 <consoleread+0xe7>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100aa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100aaa:	0f 8f 48 ff ff ff    	jg     801009f8 <consoleread+0x2f>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100ab0:	83 ec 0c             	sub    $0xc,%esp
80100ab3:	68 e0 b5 10 80       	push   $0x8010b5e0
80100ab8:	e8 05 47 00 00       	call   801051c2 <release>
80100abd:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	ff 75 08             	pushl  0x8(%ebp)
80100ac6:	e8 8b 0e 00 00       	call   80101956 <ilock>
80100acb:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100ace:	8b 45 10             	mov    0x10(%ebp),%eax
80100ad1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad4:	29 c2                	sub    %eax,%edx
80100ad6:	89 d0                	mov    %edx,%eax
}
80100ad8:	c9                   	leave  
80100ad9:	c3                   	ret    

80100ada <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100ada:	55                   	push   %ebp
80100adb:	89 e5                	mov    %esp,%ebp
80100add:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100ae0:	83 ec 0c             	sub    $0xc,%esp
80100ae3:	ff 75 08             	pushl  0x8(%ebp)
80100ae6:	e8 c5 0f 00 00       	call   80101ab0 <iunlock>
80100aeb:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aee:	83 ec 0c             	sub    $0xc,%esp
80100af1:	68 e0 b5 10 80       	push   $0x8010b5e0
80100af6:	e8 61 46 00 00       	call   8010515c <acquire>
80100afb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b05:	eb 1f                	jmp    80100b26 <consolewrite+0x4c>
    consputc(buf[i] & 0xff);
80100b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b0d:	01 d0                	add    %edx,%eax
80100b0f:	8a 00                	mov    (%eax),%al
80100b11:	0f be c0             	movsbl %al,%eax
80100b14:	0f b6 c0             	movzbl %al,%eax
80100b17:	83 ec 0c             	sub    $0xc,%esp
80100b1a:	50                   	push   %eax
80100b1b:	e8 be fc ff ff       	call   801007de <consputc>
80100b20:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b23:	ff 45 f4             	incl   -0xc(%ebp)
80100b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b29:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b2c:	7c d9                	jl     80100b07 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b2e:	83 ec 0c             	sub    $0xc,%esp
80100b31:	68 e0 b5 10 80       	push   $0x8010b5e0
80100b36:	e8 87 46 00 00       	call   801051c2 <release>
80100b3b:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b3e:	83 ec 0c             	sub    $0xc,%esp
80100b41:	ff 75 08             	pushl  0x8(%ebp)
80100b44:	e8 0d 0e 00 00       	call   80101956 <ilock>
80100b49:	83 c4 10             	add    $0x10,%esp

  return n;
80100b4c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b4f:	c9                   	leave  
80100b50:	c3                   	ret    

80100b51 <consoleinit>:

void
consoleinit(void)
{
80100b51:	55                   	push   %ebp
80100b52:	89 e5                	mov    %esp,%ebp
80100b54:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b57:	83 ec 08             	sub    $0x8,%esp
80100b5a:	68 fa 88 10 80       	push   $0x801088fa
80100b5f:	68 e0 b5 10 80       	push   $0x8010b5e0
80100b64:	e8 d2 45 00 00       	call   8010513b <initlock>
80100b69:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b6c:	c7 05 ac 1b 11 80 da 	movl   $0x80100ada,0x80111bac
80100b73:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b76:	c7 05 a8 1b 11 80 c9 	movl   $0x801009c9,0x80111ba8
80100b7d:	09 10 80 
  cons.locking = 1;
80100b80:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100b87:	00 00 00 

  picenable(IRQ_KBD);
80100b8a:	83 ec 0c             	sub    $0xc,%esp
80100b8d:	6a 01                	push   $0x1
80100b8f:	e8 32 34 00 00       	call   80103fc6 <picenable>
80100b94:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b97:	83 ec 08             	sub    $0x8,%esp
80100b9a:	6a 00                	push   $0x0
80100b9c:	6a 01                	push   $0x1
80100b9e:	e8 02 1f 00 00       	call   80102aa5 <ioapicenable>
80100ba3:	83 c4 10             	add    $0x10,%esp
}
80100ba6:	c9                   	leave  
80100ba7:	c3                   	ret    

80100ba8 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ba8:	55                   	push   %ebp
80100ba9:	89 e5                	mov    %esp,%ebp
80100bab:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100bb1:	e8 eb 29 00 00       	call   801035a1 <begin_op>
  if((ip = namei(path)) == 0){
80100bb6:	83 ec 0c             	sub    $0xc,%esp
80100bb9:	ff 75 08             	pushl  0x8(%ebp)
80100bbc:	e8 47 19 00 00       	call   80102508 <namei>
80100bc1:	83 c4 10             	add    $0x10,%esp
80100bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bc7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bcb:	75 0f                	jne    80100bdc <exec+0x34>
    end_op();
80100bcd:	e8 5b 2a 00 00       	call   8010362d <end_op>
    return -1;
80100bd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd7:	e9 ab 03 00 00       	jmp    80100f87 <exec+0x3df>
  }
  ilock(ip);
80100bdc:	83 ec 0c             	sub    $0xc,%esp
80100bdf:	ff 75 d8             	pushl  -0x28(%ebp)
80100be2:	e8 6f 0d 00 00       	call   80101956 <ilock>
80100be7:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bea:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bf1:	6a 34                	push   $0x34
80100bf3:	6a 00                	push   $0x0
80100bf5:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bfb:	50                   	push   %eax
80100bfc:	ff 75 d8             	pushl  -0x28(%ebp)
80100bff:	e8 b4 12 00 00       	call   80101eb8 <readi>
80100c04:	83 c4 10             	add    $0x10,%esp
80100c07:	83 f8 33             	cmp    $0x33,%eax
80100c0a:	77 05                	ja     80100c11 <exec+0x69>
    goto bad;
80100c0c:	e9 44 03 00 00       	jmp    80100f55 <exec+0x3ad>
  if(elf.magic != ELF_MAGIC)
80100c11:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c17:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c1c:	74 05                	je     80100c23 <exec+0x7b>
    goto bad;
80100c1e:	e9 32 03 00 00       	jmp    80100f55 <exec+0x3ad>

  if((pgdir = setupkvm()) == 0)
80100c23:	e8 68 74 00 00       	call   80108090 <setupkvm>
80100c28:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c2b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c2f:	75 05                	jne    80100c36 <exec+0x8e>
    goto bad;
80100c31:	e9 1f 03 00 00       	jmp    80100f55 <exec+0x3ad>

  // Load program into memory.
  sz = 0;
80100c36:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c3d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c44:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c4d:	e9 ad 00 00 00       	jmp    80100cff <exec+0x157>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c55:	6a 20                	push   $0x20
80100c57:	50                   	push   %eax
80100c58:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c5e:	50                   	push   %eax
80100c5f:	ff 75 d8             	pushl  -0x28(%ebp)
80100c62:	e8 51 12 00 00       	call   80101eb8 <readi>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	83 f8 20             	cmp    $0x20,%eax
80100c6d:	74 05                	je     80100c74 <exec+0xcc>
      goto bad;
80100c6f:	e9 e1 02 00 00       	jmp    80100f55 <exec+0x3ad>
    if(ph.type != ELF_PROG_LOAD)
80100c74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c7a:	83 f8 01             	cmp    $0x1,%eax
80100c7d:	74 02                	je     80100c81 <exec+0xd9>
      continue;
80100c7f:	eb 72                	jmp    80100cf3 <exec+0x14b>
    if(ph.memsz < ph.filesz)
80100c81:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c87:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c8d:	39 c2                	cmp    %eax,%edx
80100c8f:	73 05                	jae    80100c96 <exec+0xee>
      goto bad;
80100c91:	e9 bf 02 00 00       	jmp    80100f55 <exec+0x3ad>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c96:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c9c:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100ca2:	01 d0                	add    %edx,%eax
80100ca4:	83 ec 04             	sub    $0x4,%esp
80100ca7:	50                   	push   %eax
80100ca8:	ff 75 e0             	pushl  -0x20(%ebp)
80100cab:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cae:	e8 72 77 00 00       	call   80108425 <allocuvm>
80100cb3:	83 c4 10             	add    $0x10,%esp
80100cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cbd:	75 05                	jne    80100cc4 <exec+0x11c>
      goto bad;
80100cbf:	e9 91 02 00 00       	jmp    80100f55 <exec+0x3ad>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cc4:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100cca:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cd0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100cd6:	83 ec 0c             	sub    $0xc,%esp
80100cd9:	51                   	push   %ecx
80100cda:	52                   	push   %edx
80100cdb:	ff 75 d8             	pushl  -0x28(%ebp)
80100cde:	50                   	push   %eax
80100cdf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ce2:	e8 67 76 00 00       	call   8010834e <loaduvm>
80100ce7:	83 c4 20             	add    $0x20,%esp
80100cea:	85 c0                	test   %eax,%eax
80100cec:	79 05                	jns    80100cf3 <exec+0x14b>
      goto bad;
80100cee:	e9 62 02 00 00       	jmp    80100f55 <exec+0x3ad>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cf3:	ff 45 ec             	incl   -0x14(%ebp)
80100cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cf9:	83 c0 20             	add    $0x20,%eax
80100cfc:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cff:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
80100d05:	0f b7 c0             	movzwl %ax,%eax
80100d08:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d0b:	0f 8f 41 ff ff ff    	jg     80100c52 <exec+0xaa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d11:	83 ec 0c             	sub    $0xc,%esp
80100d14:	ff 75 d8             	pushl  -0x28(%ebp)
80100d17:	e8 f4 0e 00 00       	call   80101c10 <iunlockput>
80100d1c:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d1f:	e8 09 29 00 00       	call   8010362d <end_op>
  ip = 0;
80100d24:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2e:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d38:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d3e:	05 00 20 00 00       	add    $0x2000,%eax
80100d43:	83 ec 04             	sub    $0x4,%esp
80100d46:	50                   	push   %eax
80100d47:	ff 75 e0             	pushl  -0x20(%ebp)
80100d4a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d4d:	e8 d3 76 00 00       	call   80108425 <allocuvm>
80100d52:	83 c4 10             	add    $0x10,%esp
80100d55:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d5c:	75 05                	jne    80100d63 <exec+0x1bb>
    goto bad;
80100d5e:	e9 f2 01 00 00       	jmp    80100f55 <exec+0x3ad>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d63:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d66:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d6b:	83 ec 08             	sub    $0x8,%esp
80100d6e:	50                   	push   %eax
80100d6f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d72:	e8 d0 78 00 00       	call   80108647 <clearpteu>
80100d77:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d7d:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d87:	e9 93 00 00 00       	jmp    80100e1f <exec+0x277>
    if(argc >= MAXARG)
80100d8c:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d90:	76 05                	jbe    80100d97 <exec+0x1ef>
      goto bad;
80100d92:	e9 be 01 00 00       	jmp    80100f55 <exec+0x3ad>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100da1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da4:	01 d0                	add    %edx,%eax
80100da6:	8b 00                	mov    (%eax),%eax
80100da8:	83 ec 0c             	sub    $0xc,%esp
80100dab:	50                   	push   %eax
80100dac:	e8 3b 48 00 00       	call   801055ec <strlen>
80100db1:	83 c4 10             	add    $0x10,%esp
80100db4:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100db7:	29 c2                	sub    %eax,%edx
80100db9:	89 d0                	mov    %edx,%eax
80100dbb:	48                   	dec    %eax
80100dbc:	83 e0 fc             	and    $0xfffffffc,%eax
80100dbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcf:	01 d0                	add    %edx,%eax
80100dd1:	8b 00                	mov    (%eax),%eax
80100dd3:	83 ec 0c             	sub    $0xc,%esp
80100dd6:	50                   	push   %eax
80100dd7:	e8 10 48 00 00       	call   801055ec <strlen>
80100ddc:	83 c4 10             	add    $0x10,%esp
80100ddf:	40                   	inc    %eax
80100de0:	89 c2                	mov    %eax,%edx
80100de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100dec:	8b 45 0c             	mov    0xc(%ebp),%eax
80100def:	01 c8                	add    %ecx,%eax
80100df1:	8b 00                	mov    (%eax),%eax
80100df3:	52                   	push   %edx
80100df4:	50                   	push   %eax
80100df5:	ff 75 dc             	pushl  -0x24(%ebp)
80100df8:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dfb:	e8 fb 79 00 00       	call   801087fb <copyout>
80100e00:	83 c4 10             	add    $0x10,%esp
80100e03:	85 c0                	test   %eax,%eax
80100e05:	79 05                	jns    80100e0c <exec+0x264>
      goto bad;
80100e07:	e9 49 01 00 00       	jmp    80100f55 <exec+0x3ad>
    ustack[3+argc] = sp;
80100e0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0f:	8d 50 03             	lea    0x3(%eax),%edx
80100e12:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e15:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e1c:	ff 45 e4             	incl   -0x1c(%ebp)
80100e1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e29:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e2c:	01 d0                	add    %edx,%eax
80100e2e:	8b 00                	mov    (%eax),%eax
80100e30:	85 c0                	test   %eax,%eax
80100e32:	0f 85 54 ff ff ff    	jne    80100d8c <exec+0x1e4>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3b:	83 c0 03             	add    $0x3,%eax
80100e3e:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e45:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e49:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e50:	ff ff ff 
  ustack[1] = argc;
80100e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e56:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5f:	40                   	inc    %eax
80100e60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e6a:	29 d0                	sub    %edx,%eax
80100e6c:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e75:	83 c0 04             	add    $0x4,%eax
80100e78:	c1 e0 02             	shl    $0x2,%eax
80100e7b:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e81:	83 c0 04             	add    $0x4,%eax
80100e84:	c1 e0 02             	shl    $0x2,%eax
80100e87:	50                   	push   %eax
80100e88:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e8e:	50                   	push   %eax
80100e8f:	ff 75 dc             	pushl  -0x24(%ebp)
80100e92:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e95:	e8 61 79 00 00       	call   801087fb <copyout>
80100e9a:	83 c4 10             	add    $0x10,%esp
80100e9d:	85 c0                	test   %eax,%eax
80100e9f:	79 05                	jns    80100ea6 <exec+0x2fe>
    goto bad;
80100ea1:	e9 af 00 00 00       	jmp    80100f55 <exec+0x3ad>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100eb2:	eb 13                	jmp    80100ec7 <exec+0x31f>
    if(*s == '/')
80100eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb7:	8a 00                	mov    (%eax),%al
80100eb9:	3c 2f                	cmp    $0x2f,%al
80100ebb:	75 07                	jne    80100ec4 <exec+0x31c>
      last = s+1;
80100ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec0:	40                   	inc    %eax
80100ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ec4:	ff 45 f4             	incl   -0xc(%ebp)
80100ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eca:	8a 00                	mov    (%eax),%al
80100ecc:	84 c0                	test   %al,%al
80100ece:	75 e4                	jne    80100eb4 <exec+0x30c>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ed0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed6:	83 c0 6c             	add    $0x6c,%eax
80100ed9:	83 ec 04             	sub    $0x4,%esp
80100edc:	6a 10                	push   $0x10
80100ede:	ff 75 f0             	pushl  -0x10(%ebp)
80100ee1:	50                   	push   %eax
80100ee2:	e8 be 46 00 00       	call   801055a5 <safestrcpy>
80100ee7:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef0:	8b 40 04             	mov    0x4(%eax),%eax
80100ef3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ef6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eff:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f08:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f0b:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f13:	8b 40 18             	mov    0x18(%eax),%eax
80100f16:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f1c:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f25:	8b 40 18             	mov    0x18(%eax),%eax
80100f28:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f2b:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f34:	83 ec 0c             	sub    $0xc,%esp
80100f37:	50                   	push   %eax
80100f38:	e8 38 72 00 00       	call   80108175 <switchuvm>
80100f3d:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	ff 75 d0             	pushl  -0x30(%ebp)
80100f46:	e8 5e 76 00 00       	call   801085a9 <freevm>
80100f4b:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f4e:	b8 00 00 00 00       	mov    $0x0,%eax
80100f53:	eb 32                	jmp    80100f87 <exec+0x3df>

 bad:
  if(pgdir)
80100f55:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f59:	74 0e                	je     80100f69 <exec+0x3c1>
    freevm(pgdir);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f61:	e8 43 76 00 00       	call   801085a9 <freevm>
80100f66:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f69:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f6d:	74 13                	je     80100f82 <exec+0x3da>
    iunlockput(ip);
80100f6f:	83 ec 0c             	sub    $0xc,%esp
80100f72:	ff 75 d8             	pushl  -0x28(%ebp)
80100f75:	e8 96 0c 00 00       	call   80101c10 <iunlockput>
80100f7a:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f7d:	e8 ab 26 00 00       	call   8010362d <end_op>
  }
  return -1;
80100f82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f87:	c9                   	leave  
80100f88:	c3                   	ret    

80100f89 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f89:	55                   	push   %ebp
80100f8a:	89 e5                	mov    %esp,%ebp
80100f8c:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f8f:	83 ec 08             	sub    $0x8,%esp
80100f92:	68 02 89 10 80       	push   $0x80108902
80100f97:	68 00 12 11 80       	push   $0x80111200
80100f9c:	e8 9a 41 00 00       	call   8010513b <initlock>
80100fa1:	83 c4 10             	add    $0x10,%esp
}
80100fa4:	c9                   	leave  
80100fa5:	c3                   	ret    

80100fa6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fa6:	55                   	push   %ebp
80100fa7:	89 e5                	mov    %esp,%ebp
80100fa9:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fac:	83 ec 0c             	sub    $0xc,%esp
80100faf:	68 00 12 11 80       	push   $0x80111200
80100fb4:	e8 a3 41 00 00       	call   8010515c <acquire>
80100fb9:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fbc:	c7 45 f4 34 12 11 80 	movl   $0x80111234,-0xc(%ebp)
80100fc3:	eb 2d                	jmp    80100ff2 <filealloc+0x4c>
    if(f->ref == 0){
80100fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc8:	8b 40 04             	mov    0x4(%eax),%eax
80100fcb:	85 c0                	test   %eax,%eax
80100fcd:	75 1f                	jne    80100fee <filealloc+0x48>
      f->ref = 1;
80100fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fd2:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 00 12 11 80       	push   $0x80111200
80100fe1:	e8 dc 41 00 00       	call   801051c2 <release>
80100fe6:	83 c4 10             	add    $0x10,%esp
      return f;
80100fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fec:	eb 22                	jmp    80101010 <filealloc+0x6a>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fee:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100ff2:	81 7d f4 94 1b 11 80 	cmpl   $0x80111b94,-0xc(%ebp)
80100ff9:	72 ca                	jb     80100fc5 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100ffb:	83 ec 0c             	sub    $0xc,%esp
80100ffe:	68 00 12 11 80       	push   $0x80111200
80101003:	e8 ba 41 00 00       	call   801051c2 <release>
80101008:	83 c4 10             	add    $0x10,%esp
  return 0;
8010100b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101010:	c9                   	leave  
80101011:	c3                   	ret    

80101012 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101012:	55                   	push   %ebp
80101013:	89 e5                	mov    %esp,%ebp
80101015:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	68 00 12 11 80       	push   $0x80111200
80101020:	e8 37 41 00 00       	call   8010515c <acquire>
80101025:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101028:	8b 45 08             	mov    0x8(%ebp),%eax
8010102b:	8b 40 04             	mov    0x4(%eax),%eax
8010102e:	85 c0                	test   %eax,%eax
80101030:	7f 0d                	jg     8010103f <filedup+0x2d>
    panic("filedup");
80101032:	83 ec 0c             	sub    $0xc,%esp
80101035:	68 09 89 10 80       	push   $0x80108909
8010103a:	e8 8a f5 ff ff       	call   801005c9 <panic>
  f->ref++;
8010103f:	8b 45 08             	mov    0x8(%ebp),%eax
80101042:	8b 40 04             	mov    0x4(%eax),%eax
80101045:	8d 50 01             	lea    0x1(%eax),%edx
80101048:	8b 45 08             	mov    0x8(%ebp),%eax
8010104b:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010104e:	83 ec 0c             	sub    $0xc,%esp
80101051:	68 00 12 11 80       	push   $0x80111200
80101056:	e8 67 41 00 00       	call   801051c2 <release>
8010105b:	83 c4 10             	add    $0x10,%esp
  return f;
8010105e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101061:	c9                   	leave  
80101062:	c3                   	ret    

80101063 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101063:	55                   	push   %ebp
80101064:	89 e5                	mov    %esp,%ebp
80101066:	57                   	push   %edi
80101067:	56                   	push   %esi
80101068:	53                   	push   %ebx
80101069:	83 ec 2c             	sub    $0x2c,%esp
  struct file ff;

  acquire(&ftable.lock);
8010106c:	83 ec 0c             	sub    $0xc,%esp
8010106f:	68 00 12 11 80       	push   $0x80111200
80101074:	e8 e3 40 00 00       	call   8010515c <acquire>
80101079:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010107c:	8b 45 08             	mov    0x8(%ebp),%eax
8010107f:	8b 40 04             	mov    0x4(%eax),%eax
80101082:	85 c0                	test   %eax,%eax
80101084:	7f 0d                	jg     80101093 <fileclose+0x30>
    panic("fileclose");
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	68 11 89 10 80       	push   $0x80108911
8010108e:	e8 36 f5 ff ff       	call   801005c9 <panic>
  if(--f->ref > 0){
80101093:	8b 45 08             	mov    0x8(%ebp),%eax
80101096:	8b 40 04             	mov    0x4(%eax),%eax
80101099:	8d 50 ff             	lea    -0x1(%eax),%edx
8010109c:	8b 45 08             	mov    0x8(%ebp),%eax
8010109f:	89 50 04             	mov    %edx,0x4(%eax)
801010a2:	8b 45 08             	mov    0x8(%ebp),%eax
801010a5:	8b 40 04             	mov    0x4(%eax),%eax
801010a8:	85 c0                	test   %eax,%eax
801010aa:	7e 12                	jle    801010be <fileclose+0x5b>
    release(&ftable.lock);
801010ac:	83 ec 0c             	sub    $0xc,%esp
801010af:	68 00 12 11 80       	push   $0x80111200
801010b4:	e8 09 41 00 00       	call   801051c2 <release>
801010b9:	83 c4 10             	add    $0x10,%esp
801010bc:	eb 79                	jmp    80101137 <fileclose+0xd4>
    return;
  }
  ff = *f;
801010be:	8b 45 08             	mov    0x8(%ebp),%eax
801010c1:	8d 55 d0             	lea    -0x30(%ebp),%edx
801010c4:	89 c3                	mov    %eax,%ebx
801010c6:	b8 06 00 00 00       	mov    $0x6,%eax
801010cb:	89 d7                	mov    %edx,%edi
801010cd:	89 de                	mov    %ebx,%esi
801010cf:	89 c1                	mov    %eax,%ecx
801010d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
801010d3:	8b 45 08             	mov    0x8(%ebp),%eax
801010d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010dd:	8b 45 08             	mov    0x8(%ebp),%eax
801010e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010e6:	83 ec 0c             	sub    $0xc,%esp
801010e9:	68 00 12 11 80       	push   $0x80111200
801010ee:	e8 cf 40 00 00       	call   801051c2 <release>
801010f3:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010f9:	83 f8 01             	cmp    $0x1,%eax
801010fc:	75 18                	jne    80101116 <fileclose+0xb3>
    pipeclose(ff.pipe, ff.writable);
801010fe:	8a 45 d9             	mov    -0x27(%ebp),%al
80101101:	0f be d0             	movsbl %al,%edx
80101104:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101107:	83 ec 08             	sub    $0x8,%esp
8010110a:	52                   	push   %edx
8010110b:	50                   	push   %eax
8010110c:	e8 15 31 00 00       	call   80104226 <pipeclose>
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	eb 21                	jmp    80101137 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101116:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101119:	83 f8 02             	cmp    $0x2,%eax
8010111c:	75 19                	jne    80101137 <fileclose+0xd4>
    begin_op();
8010111e:	e8 7e 24 00 00       	call   801035a1 <begin_op>
    iput(ff.ip);
80101123:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101126:	83 ec 0c             	sub    $0xc,%esp
80101129:	50                   	push   %eax
8010112a:	e8 f2 09 00 00       	call   80101b21 <iput>
8010112f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101132:	e8 f6 24 00 00       	call   8010362d <end_op>
  }
}
80101137:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010113a:	5b                   	pop    %ebx
8010113b:	5e                   	pop    %esi
8010113c:	5f                   	pop    %edi
8010113d:	5d                   	pop    %ebp
8010113e:	c3                   	ret    

8010113f <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010113f:	55                   	push   %ebp
80101140:	89 e5                	mov    %esp,%ebp
80101142:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101145:	8b 45 08             	mov    0x8(%ebp),%eax
80101148:	8b 00                	mov    (%eax),%eax
8010114a:	83 f8 02             	cmp    $0x2,%eax
8010114d:	75 40                	jne    8010118f <filestat+0x50>
    ilock(f->ip);
8010114f:	8b 45 08             	mov    0x8(%ebp),%eax
80101152:	8b 40 10             	mov    0x10(%eax),%eax
80101155:	83 ec 0c             	sub    $0xc,%esp
80101158:	50                   	push   %eax
80101159:	e8 f8 07 00 00       	call   80101956 <ilock>
8010115e:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101161:	8b 45 08             	mov    0x8(%ebp),%eax
80101164:	8b 40 10             	mov    0x10(%eax),%eax
80101167:	83 ec 08             	sub    $0x8,%esp
8010116a:	ff 75 0c             	pushl  0xc(%ebp)
8010116d:	50                   	push   %eax
8010116e:	e8 01 0d 00 00       	call   80101e74 <stati>
80101173:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101176:	8b 45 08             	mov    0x8(%ebp),%eax
80101179:	8b 40 10             	mov    0x10(%eax),%eax
8010117c:	83 ec 0c             	sub    $0xc,%esp
8010117f:	50                   	push   %eax
80101180:	e8 2b 09 00 00       	call   80101ab0 <iunlock>
80101185:	83 c4 10             	add    $0x10,%esp
    return 0;
80101188:	b8 00 00 00 00       	mov    $0x0,%eax
8010118d:	eb 05                	jmp    80101194 <filestat+0x55>
  }
  return -1;
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101194:	c9                   	leave  
80101195:	c3                   	ret    

80101196 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101196:	55                   	push   %ebp
80101197:	89 e5                	mov    %esp,%ebp
80101199:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010119c:	8b 45 08             	mov    0x8(%ebp),%eax
8010119f:	8a 40 08             	mov    0x8(%eax),%al
801011a2:	84 c0                	test   %al,%al
801011a4:	75 0a                	jne    801011b0 <fileread+0x1a>
    return -1;
801011a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ab:	e9 9b 00 00 00       	jmp    8010124b <fileread+0xb5>
  if(f->type == FD_PIPE)
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	8b 00                	mov    (%eax),%eax
801011b5:	83 f8 01             	cmp    $0x1,%eax
801011b8:	75 1a                	jne    801011d4 <fileread+0x3e>
    return piperead(f->pipe, addr, n);
801011ba:	8b 45 08             	mov    0x8(%ebp),%eax
801011bd:	8b 40 0c             	mov    0xc(%eax),%eax
801011c0:	83 ec 04             	sub    $0x4,%esp
801011c3:	ff 75 10             	pushl  0x10(%ebp)
801011c6:	ff 75 0c             	pushl  0xc(%ebp)
801011c9:	50                   	push   %eax
801011ca:	e8 02 32 00 00       	call   801043d1 <piperead>
801011cf:	83 c4 10             	add    $0x10,%esp
801011d2:	eb 77                	jmp    8010124b <fileread+0xb5>
  if(f->type == FD_INODE){
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	8b 00                	mov    (%eax),%eax
801011d9:	83 f8 02             	cmp    $0x2,%eax
801011dc:	75 60                	jne    8010123e <fileread+0xa8>
    ilock(f->ip);
801011de:	8b 45 08             	mov    0x8(%ebp),%eax
801011e1:	8b 40 10             	mov    0x10(%eax),%eax
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	50                   	push   %eax
801011e8:	e8 69 07 00 00       	call   80101956 <ilock>
801011ed:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011f3:	8b 45 08             	mov    0x8(%ebp),%eax
801011f6:	8b 50 14             	mov    0x14(%eax),%edx
801011f9:	8b 45 08             	mov    0x8(%ebp),%eax
801011fc:	8b 40 10             	mov    0x10(%eax),%eax
801011ff:	51                   	push   %ecx
80101200:	52                   	push   %edx
80101201:	ff 75 0c             	pushl  0xc(%ebp)
80101204:	50                   	push   %eax
80101205:	e8 ae 0c 00 00       	call   80101eb8 <readi>
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101214:	7e 11                	jle    80101227 <fileread+0x91>
      f->off += r;
80101216:	8b 45 08             	mov    0x8(%ebp),%eax
80101219:	8b 50 14             	mov    0x14(%eax),%edx
8010121c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121f:	01 c2                	add    %eax,%edx
80101221:	8b 45 08             	mov    0x8(%ebp),%eax
80101224:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	8b 40 10             	mov    0x10(%eax),%eax
8010122d:	83 ec 0c             	sub    $0xc,%esp
80101230:	50                   	push   %eax
80101231:	e8 7a 08 00 00       	call   80101ab0 <iunlock>
80101236:	83 c4 10             	add    $0x10,%esp
    return r;
80101239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010123c:	eb 0d                	jmp    8010124b <fileread+0xb5>
  }
  panic("fileread");
8010123e:	83 ec 0c             	sub    $0xc,%esp
80101241:	68 1b 89 10 80       	push   $0x8010891b
80101246:	e8 7e f3 ff ff       	call   801005c9 <panic>
}
8010124b:	c9                   	leave  
8010124c:	c3                   	ret    

8010124d <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010124d:	55                   	push   %ebp
8010124e:	89 e5                	mov    %esp,%ebp
80101250:	53                   	push   %ebx
80101251:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101254:	8b 45 08             	mov    0x8(%ebp),%eax
80101257:	8a 40 09             	mov    0x9(%eax),%al
8010125a:	84 c0                	test   %al,%al
8010125c:	75 0a                	jne    80101268 <filewrite+0x1b>
    return -1;
8010125e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101263:	e9 1a 01 00 00       	jmp    80101382 <filewrite+0x135>
  if(f->type == FD_PIPE)
80101268:	8b 45 08             	mov    0x8(%ebp),%eax
8010126b:	8b 00                	mov    (%eax),%eax
8010126d:	83 f8 01             	cmp    $0x1,%eax
80101270:	75 1d                	jne    8010128f <filewrite+0x42>
    return pipewrite(f->pipe, addr, n);
80101272:	8b 45 08             	mov    0x8(%ebp),%eax
80101275:	8b 40 0c             	mov    0xc(%eax),%eax
80101278:	83 ec 04             	sub    $0x4,%esp
8010127b:	ff 75 10             	pushl  0x10(%ebp)
8010127e:	ff 75 0c             	pushl  0xc(%ebp)
80101281:	50                   	push   %eax
80101282:	e8 48 30 00 00       	call   801042cf <pipewrite>
80101287:	83 c4 10             	add    $0x10,%esp
8010128a:	e9 f3 00 00 00       	jmp    80101382 <filewrite+0x135>
  if(f->type == FD_INODE){
8010128f:	8b 45 08             	mov    0x8(%ebp),%eax
80101292:	8b 00                	mov    (%eax),%eax
80101294:	83 f8 02             	cmp    $0x2,%eax
80101297:	0f 85 d8 00 00 00    	jne    80101375 <filewrite+0x128>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010129d:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012ab:	e9 a5 00 00 00       	jmp    80101355 <filewrite+0x108>
      int n1 = n - i;
801012b0:	8b 45 10             	mov    0x10(%ebp),%eax
801012b3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012bc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012bf:	7e 06                	jle    801012c7 <filewrite+0x7a>
        n1 = max;
801012c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012c4:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012c7:	e8 d5 22 00 00       	call   801035a1 <begin_op>
      ilock(f->ip);
801012cc:	8b 45 08             	mov    0x8(%ebp),%eax
801012cf:	8b 40 10             	mov    0x10(%eax),%eax
801012d2:	83 ec 0c             	sub    $0xc,%esp
801012d5:	50                   	push   %eax
801012d6:	e8 7b 06 00 00       	call   80101956 <ilock>
801012db:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012e1:	8b 45 08             	mov    0x8(%ebp),%eax
801012e4:	8b 50 14             	mov    0x14(%eax),%edx
801012e7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801012ed:	01 c3                	add    %eax,%ebx
801012ef:	8b 45 08             	mov    0x8(%ebp),%eax
801012f2:	8b 40 10             	mov    0x10(%eax),%eax
801012f5:	51                   	push   %ecx
801012f6:	52                   	push   %edx
801012f7:	53                   	push   %ebx
801012f8:	50                   	push   %eax
801012f9:	e8 1a 0d 00 00       	call   80102018 <writei>
801012fe:	83 c4 10             	add    $0x10,%esp
80101301:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101304:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101308:	7e 11                	jle    8010131b <filewrite+0xce>
        f->off += r;
8010130a:	8b 45 08             	mov    0x8(%ebp),%eax
8010130d:	8b 50 14             	mov    0x14(%eax),%edx
80101310:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101313:	01 c2                	add    %eax,%edx
80101315:	8b 45 08             	mov    0x8(%ebp),%eax
80101318:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010131b:	8b 45 08             	mov    0x8(%ebp),%eax
8010131e:	8b 40 10             	mov    0x10(%eax),%eax
80101321:	83 ec 0c             	sub    $0xc,%esp
80101324:	50                   	push   %eax
80101325:	e8 86 07 00 00       	call   80101ab0 <iunlock>
8010132a:	83 c4 10             	add    $0x10,%esp
      end_op();
8010132d:	e8 fb 22 00 00       	call   8010362d <end_op>

      if(r < 0)
80101332:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101336:	79 02                	jns    8010133a <filewrite+0xed>
        break;
80101338:	eb 27                	jmp    80101361 <filewrite+0x114>
      if(r != n1)
8010133a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010133d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101340:	74 0d                	je     8010134f <filewrite+0x102>
        panic("short filewrite");
80101342:	83 ec 0c             	sub    $0xc,%esp
80101345:	68 24 89 10 80       	push   $0x80108924
8010134a:	e8 7a f2 ff ff       	call   801005c9 <panic>
      i += r;
8010134f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101352:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101358:	3b 45 10             	cmp    0x10(%ebp),%eax
8010135b:	0f 8c 4f ff ff ff    	jl     801012b0 <filewrite+0x63>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101364:	3b 45 10             	cmp    0x10(%ebp),%eax
80101367:	75 05                	jne    8010136e <filewrite+0x121>
80101369:	8b 45 10             	mov    0x10(%ebp),%eax
8010136c:	eb 14                	jmp    80101382 <filewrite+0x135>
8010136e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101373:	eb 0d                	jmp    80101382 <filewrite+0x135>
  }
  panic("filewrite");
80101375:	83 ec 0c             	sub    $0xc,%esp
80101378:	68 34 89 10 80       	push   $0x80108934
8010137d:	e8 47 f2 ff ff       	call   801005c9 <panic>
}
80101382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101385:	c9                   	leave  
80101386:	c3                   	ret    

80101387 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101387:	55                   	push   %ebp
80101388:	89 e5                	mov    %esp,%ebp
8010138a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010138d:	8b 45 08             	mov    0x8(%ebp),%eax
80101390:	83 ec 08             	sub    $0x8,%esp
80101393:	6a 01                	push   $0x1
80101395:	50                   	push   %eax
80101396:	e8 19 ee ff ff       	call   801001b4 <bread>
8010139b:	83 c4 10             	add    $0x10,%esp
8010139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a4:	83 c0 18             	add    $0x18,%eax
801013a7:	83 ec 04             	sub    $0x4,%esp
801013aa:	6a 1c                	push   $0x1c
801013ac:	50                   	push   %eax
801013ad:	ff 75 0c             	pushl  0xc(%ebp)
801013b0:	e8 b8 40 00 00       	call   8010546d <memmove>
801013b5:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013b8:	83 ec 0c             	sub    $0xc,%esp
801013bb:	ff 75 f4             	pushl  -0xc(%ebp)
801013be:	e8 68 ee ff ff       	call   8010022b <brelse>
801013c3:	83 c4 10             	add    $0x10,%esp
}
801013c6:	c9                   	leave  
801013c7:	c3                   	ret    

801013c8 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013c8:	55                   	push   %ebp
801013c9:	89 e5                	mov    %esp,%ebp
801013cb:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801013d1:	8b 45 08             	mov    0x8(%ebp),%eax
801013d4:	83 ec 08             	sub    $0x8,%esp
801013d7:	52                   	push   %edx
801013d8:	50                   	push   %eax
801013d9:	e8 d6 ed ff ff       	call   801001b4 <bread>
801013de:	83 c4 10             	add    $0x10,%esp
801013e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e7:	83 c0 18             	add    $0x18,%eax
801013ea:	83 ec 04             	sub    $0x4,%esp
801013ed:	68 00 02 00 00       	push   $0x200
801013f2:	6a 00                	push   $0x0
801013f4:	50                   	push   %eax
801013f5:	e8 ba 3f 00 00       	call   801053b4 <memset>
801013fa:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013fd:	83 ec 0c             	sub    $0xc,%esp
80101400:	ff 75 f4             	pushl  -0xc(%ebp)
80101403:	e8 c9 23 00 00       	call   801037d1 <log_write>
80101408:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010140b:	83 ec 0c             	sub    $0xc,%esp
8010140e:	ff 75 f4             	pushl  -0xc(%ebp)
80101411:	e8 15 ee ff ff       	call   8010022b <brelse>
80101416:	83 c4 10             	add    $0x10,%esp
}
80101419:	c9                   	leave  
8010141a:	c3                   	ret    

8010141b <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010141b:	55                   	push   %ebp
8010141c:	89 e5                	mov    %esp,%ebp
8010141e:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101421:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101428:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010142f:	e9 0d 01 00 00       	jmp    80101541 <balloc+0x126>
    bp = bread(dev, BBLOCK(b, sb));
80101434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101437:	85 c0                	test   %eax,%eax
80101439:	79 05                	jns    80101440 <balloc+0x25>
8010143b:	05 ff 0f 00 00       	add    $0xfff,%eax
80101440:	c1 f8 0c             	sar    $0xc,%eax
80101443:	89 c2                	mov    %eax,%edx
80101445:	a1 18 1c 11 80       	mov    0x80111c18,%eax
8010144a:	01 d0                	add    %edx,%eax
8010144c:	83 ec 08             	sub    $0x8,%esp
8010144f:	50                   	push   %eax
80101450:	ff 75 08             	pushl  0x8(%ebp)
80101453:	e8 5c ed ff ff       	call   801001b4 <bread>
80101458:	83 c4 10             	add    $0x10,%esp
8010145b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010145e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101465:	e9 a2 00 00 00       	jmp    8010150c <balloc+0xf1>
      m = 1 << (bi % 8);
8010146a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146d:	25 07 00 00 80       	and    $0x80000007,%eax
80101472:	85 c0                	test   %eax,%eax
80101474:	79 05                	jns    8010147b <balloc+0x60>
80101476:	48                   	dec    %eax
80101477:	83 c8 f8             	or     $0xfffffff8,%eax
8010147a:	40                   	inc    %eax
8010147b:	ba 01 00 00 00       	mov    $0x1,%edx
80101480:	88 c1                	mov    %al,%cl
80101482:	d3 e2                	shl    %cl,%edx
80101484:	89 d0                	mov    %edx,%eax
80101486:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148c:	85 c0                	test   %eax,%eax
8010148e:	79 03                	jns    80101493 <balloc+0x78>
80101490:	83 c0 07             	add    $0x7,%eax
80101493:	c1 f8 03             	sar    $0x3,%eax
80101496:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101499:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
8010149d:	0f b6 c0             	movzbl %al,%eax
801014a0:	23 45 e8             	and    -0x18(%ebp),%eax
801014a3:	85 c0                	test   %eax,%eax
801014a5:	75 62                	jne    80101509 <balloc+0xee>
        bp->data[bi/8] |= m;  // Mark block in use.
801014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014aa:	85 c0                	test   %eax,%eax
801014ac:	79 03                	jns    801014b1 <balloc+0x96>
801014ae:	83 c0 07             	add    $0x7,%eax
801014b1:	c1 f8 03             	sar    $0x3,%eax
801014b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014b7:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
801014bb:	88 d1                	mov    %dl,%cl
801014bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c0:	09 ca                	or     %ecx,%edx
801014c2:	88 d1                	mov    %dl,%cl
801014c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014c7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014cb:	83 ec 0c             	sub    $0xc,%esp
801014ce:	ff 75 ec             	pushl  -0x14(%ebp)
801014d1:	e8 fb 22 00 00       	call   801037d1 <log_write>
801014d6:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014d9:	83 ec 0c             	sub    $0xc,%esp
801014dc:	ff 75 ec             	pushl  -0x14(%ebp)
801014df:	e8 47 ed ff ff       	call   8010022b <brelse>
801014e4:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ed:	01 c2                	add    %eax,%edx
801014ef:	8b 45 08             	mov    0x8(%ebp),%eax
801014f2:	83 ec 08             	sub    $0x8,%esp
801014f5:	52                   	push   %edx
801014f6:	50                   	push   %eax
801014f7:	e8 cc fe ff ff       	call   801013c8 <bzero>
801014fc:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101505:	01 d0                	add    %edx,%eax
80101507:	eb 55                	jmp    8010155e <balloc+0x143>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101509:	ff 45 f0             	incl   -0x10(%ebp)
8010150c:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101513:	7f 17                	jg     8010152c <balloc+0x111>
80101515:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010151b:	01 d0                	add    %edx,%eax
8010151d:	89 c2                	mov    %eax,%edx
8010151f:	a1 00 1c 11 80       	mov    0x80111c00,%eax
80101524:	39 c2                	cmp    %eax,%edx
80101526:	0f 82 3e ff ff ff    	jb     8010146a <balloc+0x4f>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010152c:	83 ec 0c             	sub    $0xc,%esp
8010152f:	ff 75 ec             	pushl  -0x14(%ebp)
80101532:	e8 f4 ec ff ff       	call   8010022b <brelse>
80101537:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010153a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101541:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101544:	a1 00 1c 11 80       	mov    0x80111c00,%eax
80101549:	39 c2                	cmp    %eax,%edx
8010154b:	0f 82 e3 fe ff ff    	jb     80101434 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101551:	83 ec 0c             	sub    $0xc,%esp
80101554:	68 40 89 10 80       	push   $0x80108940
80101559:	e8 6b f0 ff ff       	call   801005c9 <panic>
}
8010155e:	c9                   	leave  
8010155f:	c3                   	ret    

80101560 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101566:	83 ec 08             	sub    $0x8,%esp
80101569:	68 00 1c 11 80       	push   $0x80111c00
8010156e:	ff 75 08             	pushl  0x8(%ebp)
80101571:	e8 11 fe ff ff       	call   80101387 <readsb>
80101576:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101579:	8b 45 0c             	mov    0xc(%ebp),%eax
8010157c:	c1 e8 0c             	shr    $0xc,%eax
8010157f:	89 c2                	mov    %eax,%edx
80101581:	a1 18 1c 11 80       	mov    0x80111c18,%eax
80101586:	01 c2                	add    %eax,%edx
80101588:	8b 45 08             	mov    0x8(%ebp),%eax
8010158b:	83 ec 08             	sub    $0x8,%esp
8010158e:	52                   	push   %edx
8010158f:	50                   	push   %eax
80101590:	e8 1f ec ff ff       	call   801001b4 <bread>
80101595:	83 c4 10             	add    $0x10,%esp
80101598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010159b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010159e:	25 ff 0f 00 00       	and    $0xfff,%eax
801015a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a9:	25 07 00 00 80       	and    $0x80000007,%eax
801015ae:	85 c0                	test   %eax,%eax
801015b0:	79 05                	jns    801015b7 <bfree+0x57>
801015b2:	48                   	dec    %eax
801015b3:	83 c8 f8             	or     $0xfffffff8,%eax
801015b6:	40                   	inc    %eax
801015b7:	ba 01 00 00 00       	mov    $0x1,%edx
801015bc:	88 c1                	mov    %al,%cl
801015be:	d3 e2                	shl    %cl,%edx
801015c0:	89 d0                	mov    %edx,%eax
801015c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c8:	85 c0                	test   %eax,%eax
801015ca:	79 03                	jns    801015cf <bfree+0x6f>
801015cc:	83 c0 07             	add    $0x7,%eax
801015cf:	c1 f8 03             	sar    $0x3,%eax
801015d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d5:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
801015d9:	0f b6 c0             	movzbl %al,%eax
801015dc:	23 45 ec             	and    -0x14(%ebp),%eax
801015df:	85 c0                	test   %eax,%eax
801015e1:	75 0d                	jne    801015f0 <bfree+0x90>
    panic("freeing free block");
801015e3:	83 ec 0c             	sub    $0xc,%esp
801015e6:	68 56 89 10 80       	push   $0x80108956
801015eb:	e8 d9 ef ff ff       	call   801005c9 <panic>
  bp->data[bi/8] &= ~m;
801015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f3:	85 c0                	test   %eax,%eax
801015f5:	79 03                	jns    801015fa <bfree+0x9a>
801015f7:	83 c0 07             	add    $0x7,%eax
801015fa:	c1 f8 03             	sar    $0x3,%eax
801015fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101600:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
80101604:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101607:	f7 d1                	not    %ecx
80101609:	21 ca                	and    %ecx,%edx
8010160b:	88 d1                	mov    %dl,%cl
8010160d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101610:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101614:	83 ec 0c             	sub    $0xc,%esp
80101617:	ff 75 f4             	pushl  -0xc(%ebp)
8010161a:	e8 b2 21 00 00       	call   801037d1 <log_write>
8010161f:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101622:	83 ec 0c             	sub    $0xc,%esp
80101625:	ff 75 f4             	pushl  -0xc(%ebp)
80101628:	e8 fe eb ff ff       	call   8010022b <brelse>
8010162d:	83 c4 10             	add    $0x10,%esp
}
80101630:	c9                   	leave  
80101631:	c3                   	ret    

80101632 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101632:	55                   	push   %ebp
80101633:	89 e5                	mov    %esp,%ebp
80101635:	57                   	push   %edi
80101636:	56                   	push   %esi
80101637:	53                   	push   %ebx
80101638:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
8010163b:	83 ec 08             	sub    $0x8,%esp
8010163e:	68 69 89 10 80       	push   $0x80108969
80101643:	68 20 1c 11 80       	push   $0x80111c20
80101648:	e8 ee 3a 00 00       	call   8010513b <initlock>
8010164d:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	68 00 1c 11 80       	push   $0x80111c00
80101658:	ff 75 08             	pushl  0x8(%ebp)
8010165b:	e8 27 fd ff ff       	call   80101387 <readsb>
80101660:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101663:	a1 18 1c 11 80       	mov    0x80111c18,%eax
80101668:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010166b:	8b 3d 14 1c 11 80    	mov    0x80111c14,%edi
80101671:	8b 35 10 1c 11 80    	mov    0x80111c10,%esi
80101677:	8b 1d 0c 1c 11 80    	mov    0x80111c0c,%ebx
8010167d:	8b 0d 08 1c 11 80    	mov    0x80111c08,%ecx
80101683:	8b 15 04 1c 11 80    	mov    0x80111c04,%edx
80101689:	a1 00 1c 11 80       	mov    0x80111c00,%eax
8010168e:	ff 75 e4             	pushl  -0x1c(%ebp)
80101691:	57                   	push   %edi
80101692:	56                   	push   %esi
80101693:	53                   	push   %ebx
80101694:	51                   	push   %ecx
80101695:	52                   	push   %edx
80101696:	50                   	push   %eax
80101697:	68 70 89 10 80       	push   $0x80108970
8010169c:	e8 6a ed ff ff       	call   8010040b <cprintf>
801016a1:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801016a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016a7:	5b                   	pop    %ebx
801016a8:	5e                   	pop    %esi
801016a9:	5f                   	pop    %edi
801016aa:	5d                   	pop    %ebp
801016ab:	c3                   	ret    

801016ac <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016ac:	55                   	push   %ebp
801016ad:	89 e5                	mov    %esp,%ebp
801016af:	83 ec 28             	sub    $0x28,%esp
801016b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801016b5:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016b9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016c0:	e9 9b 00 00 00       	jmp    80101760 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum, sb));
801016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016c8:	c1 e8 03             	shr    $0x3,%eax
801016cb:	89 c2                	mov    %eax,%edx
801016cd:	a1 14 1c 11 80       	mov    0x80111c14,%eax
801016d2:	01 d0                	add    %edx,%eax
801016d4:	83 ec 08             	sub    $0x8,%esp
801016d7:	50                   	push   %eax
801016d8:	ff 75 08             	pushl  0x8(%ebp)
801016db:	e8 d4 ea ff ff       	call   801001b4 <bread>
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e9:	8d 50 18             	lea    0x18(%eax),%edx
801016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	01 d0                	add    %edx,%eax
801016f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016fd:	8b 00                	mov    (%eax),%eax
801016ff:	66 85 c0             	test   %ax,%ax
80101702:	75 4b                	jne    8010174f <ialloc+0xa3>
      memset(dip, 0, sizeof(*dip));
80101704:	83 ec 04             	sub    $0x4,%esp
80101707:	6a 40                	push   $0x40
80101709:	6a 00                	push   $0x0
8010170b:	ff 75 ec             	pushl  -0x14(%ebp)
8010170e:	e8 a1 3c 00 00       	call   801053b4 <memset>
80101713:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101716:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010171c:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
8010171f:	83 ec 0c             	sub    $0xc,%esp
80101722:	ff 75 f0             	pushl  -0x10(%ebp)
80101725:	e8 a7 20 00 00       	call   801037d1 <log_write>
8010172a:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010172d:	83 ec 0c             	sub    $0xc,%esp
80101730:	ff 75 f0             	pushl  -0x10(%ebp)
80101733:	e8 f3 ea ff ff       	call   8010022b <brelse>
80101738:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173e:	83 ec 08             	sub    $0x8,%esp
80101741:	50                   	push   %eax
80101742:	ff 75 08             	pushl  0x8(%ebp)
80101745:	e8 f3 00 00 00       	call   8010183d <iget>
8010174a:	83 c4 10             	add    $0x10,%esp
8010174d:	eb 2e                	jmp    8010177d <ialloc+0xd1>
    }
    brelse(bp);
8010174f:	83 ec 0c             	sub    $0xc,%esp
80101752:	ff 75 f0             	pushl  -0x10(%ebp)
80101755:	e8 d1 ea ff ff       	call   8010022b <brelse>
8010175a:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010175d:	ff 45 f4             	incl   -0xc(%ebp)
80101760:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101763:	a1 08 1c 11 80       	mov    0x80111c08,%eax
80101768:	39 c2                	cmp    %eax,%edx
8010176a:	0f 82 55 ff ff ff    	jb     801016c5 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101770:	83 ec 0c             	sub    $0xc,%esp
80101773:	68 c3 89 10 80       	push   $0x801089c3
80101778:	e8 4c ee ff ff       	call   801005c9 <panic>
}
8010177d:	c9                   	leave  
8010177e:	c3                   	ret    

8010177f <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010177f:	55                   	push   %ebp
80101780:	89 e5                	mov    %esp,%ebp
80101782:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101785:	8b 45 08             	mov    0x8(%ebp),%eax
80101788:	8b 40 04             	mov    0x4(%eax),%eax
8010178b:	c1 e8 03             	shr    $0x3,%eax
8010178e:	89 c2                	mov    %eax,%edx
80101790:	a1 14 1c 11 80       	mov    0x80111c14,%eax
80101795:	01 c2                	add    %eax,%edx
80101797:	8b 45 08             	mov    0x8(%ebp),%eax
8010179a:	8b 00                	mov    (%eax),%eax
8010179c:	83 ec 08             	sub    $0x8,%esp
8010179f:	52                   	push   %edx
801017a0:	50                   	push   %eax
801017a1:	e8 0e ea ff ff       	call   801001b4 <bread>
801017a6:	83 c4 10             	add    $0x10,%esp
801017a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017af:	8d 50 18             	lea    0x18(%eax),%edx
801017b2:	8b 45 08             	mov    0x8(%ebp),%eax
801017b5:	8b 40 04             	mov    0x4(%eax),%eax
801017b8:	83 e0 07             	and    $0x7,%eax
801017bb:	c1 e0 06             	shl    $0x6,%eax
801017be:	01 d0                	add    %edx,%eax
801017c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017c3:	8b 45 08             	mov    0x8(%ebp),%eax
801017c6:	8b 40 10             	mov    0x10(%eax),%eax
801017c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017cc:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
801017cf:	8b 45 08             	mov    0x8(%ebp),%eax
801017d2:	66 8b 40 12          	mov    0x12(%eax),%ax
801017d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017d9:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801017dd:	8b 45 08             	mov    0x8(%ebp),%eax
801017e0:	8b 40 14             	mov    0x14(%eax),%eax
801017e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017e6:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801017ea:	8b 45 08             	mov    0x8(%ebp),%eax
801017ed:	66 8b 40 16          	mov    0x16(%eax),%ax
801017f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017f4:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801017f8:	8b 45 08             	mov    0x8(%ebp),%eax
801017fb:	8b 50 18             	mov    0x18(%eax),%edx
801017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101801:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101804:	8b 45 08             	mov    0x8(%ebp),%eax
80101807:	8d 50 1c             	lea    0x1c(%eax),%edx
8010180a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010180d:	83 c0 0c             	add    $0xc,%eax
80101810:	83 ec 04             	sub    $0x4,%esp
80101813:	6a 34                	push   $0x34
80101815:	52                   	push   %edx
80101816:	50                   	push   %eax
80101817:	e8 51 3c 00 00       	call   8010546d <memmove>
8010181c:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010181f:	83 ec 0c             	sub    $0xc,%esp
80101822:	ff 75 f4             	pushl  -0xc(%ebp)
80101825:	e8 a7 1f 00 00       	call   801037d1 <log_write>
8010182a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010182d:	83 ec 0c             	sub    $0xc,%esp
80101830:	ff 75 f4             	pushl  -0xc(%ebp)
80101833:	e8 f3 e9 ff ff       	call   8010022b <brelse>
80101838:	83 c4 10             	add    $0x10,%esp
}
8010183b:	c9                   	leave  
8010183c:	c3                   	ret    

8010183d <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010183d:	55                   	push   %ebp
8010183e:	89 e5                	mov    %esp,%ebp
80101840:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101843:	83 ec 0c             	sub    $0xc,%esp
80101846:	68 20 1c 11 80       	push   $0x80111c20
8010184b:	e8 0c 39 00 00       	call   8010515c <acquire>
80101850:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101853:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010185a:	c7 45 f4 54 1c 11 80 	movl   $0x80111c54,-0xc(%ebp)
80101861:	eb 5d                	jmp    801018c0 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101866:	8b 40 08             	mov    0x8(%eax),%eax
80101869:	85 c0                	test   %eax,%eax
8010186b:	7e 39                	jle    801018a6 <iget+0x69>
8010186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101870:	8b 00                	mov    (%eax),%eax
80101872:	3b 45 08             	cmp    0x8(%ebp),%eax
80101875:	75 2f                	jne    801018a6 <iget+0x69>
80101877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187a:	8b 40 04             	mov    0x4(%eax),%eax
8010187d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101880:	75 24                	jne    801018a6 <iget+0x69>
      ip->ref++;
80101882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101885:	8b 40 08             	mov    0x8(%eax),%eax
80101888:	8d 50 01             	lea    0x1(%eax),%edx
8010188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188e:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101891:	83 ec 0c             	sub    $0xc,%esp
80101894:	68 20 1c 11 80       	push   $0x80111c20
80101899:	e8 24 39 00 00       	call   801051c2 <release>
8010189e:	83 c4 10             	add    $0x10,%esp
      return ip;
801018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a4:	eb 74                	jmp    8010191a <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018aa:	75 10                	jne    801018bc <iget+0x7f>
801018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018af:	8b 40 08             	mov    0x8(%eax),%eax
801018b2:	85 c0                	test   %eax,%eax
801018b4:	75 06                	jne    801018bc <iget+0x7f>
      empty = ip;
801018b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018bc:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801018c0:	81 7d f4 f4 2b 11 80 	cmpl   $0x80112bf4,-0xc(%ebp)
801018c7:	72 9a                	jb     80101863 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018cd:	75 0d                	jne    801018dc <iget+0x9f>
    panic("iget: no inodes");
801018cf:	83 ec 0c             	sub    $0xc,%esp
801018d2:	68 d5 89 10 80       	push   $0x801089d5
801018d7:	e8 ed ec ff ff       	call   801005c9 <panic>

  ip = empty;
801018dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e5:	8b 55 08             	mov    0x8(%ebp),%edx
801018e8:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
801018f0:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101900:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101907:	83 ec 0c             	sub    $0xc,%esp
8010190a:	68 20 1c 11 80       	push   $0x80111c20
8010190f:	e8 ae 38 00 00       	call   801051c2 <release>
80101914:	83 c4 10             	add    $0x10,%esp

  return ip;
80101917:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010191a:	c9                   	leave  
8010191b:	c3                   	ret    

8010191c <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010191c:	55                   	push   %ebp
8010191d:	89 e5                	mov    %esp,%ebp
8010191f:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101922:	83 ec 0c             	sub    $0xc,%esp
80101925:	68 20 1c 11 80       	push   $0x80111c20
8010192a:	e8 2d 38 00 00       	call   8010515c <acquire>
8010192f:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101932:	8b 45 08             	mov    0x8(%ebp),%eax
80101935:	8b 40 08             	mov    0x8(%eax),%eax
80101938:	8d 50 01             	lea    0x1(%eax),%edx
8010193b:	8b 45 08             	mov    0x8(%ebp),%eax
8010193e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101941:	83 ec 0c             	sub    $0xc,%esp
80101944:	68 20 1c 11 80       	push   $0x80111c20
80101949:	e8 74 38 00 00       	call   801051c2 <release>
8010194e:	83 c4 10             	add    $0x10,%esp
  return ip;
80101951:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101954:	c9                   	leave  
80101955:	c3                   	ret    

80101956 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101956:	55                   	push   %ebp
80101957:	89 e5                	mov    %esp,%ebp
80101959:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010195c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101960:	74 0a                	je     8010196c <ilock+0x16>
80101962:	8b 45 08             	mov    0x8(%ebp),%eax
80101965:	8b 40 08             	mov    0x8(%eax),%eax
80101968:	85 c0                	test   %eax,%eax
8010196a:	7f 0d                	jg     80101979 <ilock+0x23>
    panic("ilock");
8010196c:	83 ec 0c             	sub    $0xc,%esp
8010196f:	68 e5 89 10 80       	push   $0x801089e5
80101974:	e8 50 ec ff ff       	call   801005c9 <panic>

  acquire(&icache.lock);
80101979:	83 ec 0c             	sub    $0xc,%esp
8010197c:	68 20 1c 11 80       	push   $0x80111c20
80101981:	e8 d6 37 00 00       	call   8010515c <acquire>
80101986:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101989:	eb 13                	jmp    8010199e <ilock+0x48>
    sleep(ip, &icache.lock);
8010198b:	83 ec 08             	sub    $0x8,%esp
8010198e:	68 20 1c 11 80       	push   $0x80111c20
80101993:	ff 75 08             	pushl  0x8(%ebp)
80101996:	e8 d4 34 00 00       	call   80104e6f <sleep>
8010199b:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	8b 40 0c             	mov    0xc(%eax),%eax
801019a4:	83 e0 01             	and    $0x1,%eax
801019a7:	85 c0                	test   %eax,%eax
801019a9:	75 e0                	jne    8010198b <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801019ab:	8b 45 08             	mov    0x8(%ebp),%eax
801019ae:	8b 40 0c             	mov    0xc(%eax),%eax
801019b1:	83 c8 01             	or     $0x1,%eax
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	8b 45 08             	mov    0x8(%ebp),%eax
801019b9:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801019bc:	83 ec 0c             	sub    $0xc,%esp
801019bf:	68 20 1c 11 80       	push   $0x80111c20
801019c4:	e8 f9 37 00 00       	call   801051c2 <release>
801019c9:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
801019cc:	8b 45 08             	mov    0x8(%ebp),%eax
801019cf:	8b 40 0c             	mov    0xc(%eax),%eax
801019d2:	83 e0 02             	and    $0x2,%eax
801019d5:	85 c0                	test   %eax,%eax
801019d7:	0f 85 d1 00 00 00    	jne    80101aae <ilock+0x158>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019dd:	8b 45 08             	mov    0x8(%ebp),%eax
801019e0:	8b 40 04             	mov    0x4(%eax),%eax
801019e3:	c1 e8 03             	shr    $0x3,%eax
801019e6:	89 c2                	mov    %eax,%edx
801019e8:	a1 14 1c 11 80       	mov    0x80111c14,%eax
801019ed:	01 c2                	add    %eax,%edx
801019ef:	8b 45 08             	mov    0x8(%ebp),%eax
801019f2:	8b 00                	mov    (%eax),%eax
801019f4:	83 ec 08             	sub    $0x8,%esp
801019f7:	52                   	push   %edx
801019f8:	50                   	push   %eax
801019f9:	e8 b6 e7 ff ff       	call   801001b4 <bread>
801019fe:	83 c4 10             	add    $0x10,%esp
80101a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a07:	8d 50 18             	lea    0x18(%eax),%edx
80101a0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0d:	8b 40 04             	mov    0x4(%eax),%eax
80101a10:	83 e0 07             	and    $0x7,%eax
80101a13:	c1 e0 06             	shl    $0x6,%eax
80101a16:	01 d0                	add    %edx,%eax
80101a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1e:	8b 00                	mov    (%eax),%eax
80101a20:	8b 55 08             	mov    0x8(%ebp),%edx
80101a23:	66 89 42 10          	mov    %ax,0x10(%edx)
    ip->major = dip->major;
80101a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a2a:	66 8b 40 02          	mov    0x2(%eax),%ax
80101a2e:	8b 55 08             	mov    0x8(%ebp),%edx
80101a31:	66 89 42 12          	mov    %ax,0x12(%edx)
    ip->minor = dip->minor;
80101a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a38:	8b 40 04             	mov    0x4(%eax),%eax
80101a3b:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3e:	66 89 42 14          	mov    %ax,0x14(%edx)
    ip->nlink = dip->nlink;
80101a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a45:	66 8b 40 06          	mov    0x6(%eax),%ax
80101a49:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4c:	66 89 42 16          	mov    %ax,0x16(%edx)
    ip->size = dip->size;
80101a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a53:	8b 50 08             	mov    0x8(%eax),%edx
80101a56:	8b 45 08             	mov    0x8(%ebp),%eax
80101a59:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a5f:	8d 50 0c             	lea    0xc(%eax),%edx
80101a62:	8b 45 08             	mov    0x8(%ebp),%eax
80101a65:	83 c0 1c             	add    $0x1c,%eax
80101a68:	83 ec 04             	sub    $0x4,%esp
80101a6b:	6a 34                	push   $0x34
80101a6d:	52                   	push   %edx
80101a6e:	50                   	push   %eax
80101a6f:	e8 f9 39 00 00       	call   8010546d <memmove>
80101a74:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a77:	83 ec 0c             	sub    $0xc,%esp
80101a7a:	ff 75 f4             	pushl  -0xc(%ebp)
80101a7d:	e8 a9 e7 ff ff       	call   8010022b <brelse>
80101a82:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a85:	8b 45 08             	mov    0x8(%ebp),%eax
80101a88:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8b:	83 c8 02             	or     $0x2,%eax
80101a8e:	89 c2                	mov    %eax,%edx
80101a90:	8b 45 08             	mov    0x8(%ebp),%eax
80101a93:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a96:	8b 45 08             	mov    0x8(%ebp),%eax
80101a99:	8b 40 10             	mov    0x10(%eax),%eax
80101a9c:	66 85 c0             	test   %ax,%ax
80101a9f:	75 0d                	jne    80101aae <ilock+0x158>
      panic("ilock: no type");
80101aa1:	83 ec 0c             	sub    $0xc,%esp
80101aa4:	68 eb 89 10 80       	push   $0x801089eb
80101aa9:	e8 1b eb ff ff       	call   801005c9 <panic>
  }
}
80101aae:	c9                   	leave  
80101aaf:	c3                   	ret    

80101ab0 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101ab6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101aba:	74 17                	je     80101ad3 <iunlock+0x23>
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac2:	83 e0 01             	and    $0x1,%eax
80101ac5:	85 c0                	test   %eax,%eax
80101ac7:	74 0a                	je     80101ad3 <iunlock+0x23>
80101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80101acc:	8b 40 08             	mov    0x8(%eax),%eax
80101acf:	85 c0                	test   %eax,%eax
80101ad1:	7f 0d                	jg     80101ae0 <iunlock+0x30>
    panic("iunlock");
80101ad3:	83 ec 0c             	sub    $0xc,%esp
80101ad6:	68 fa 89 10 80       	push   $0x801089fa
80101adb:	e8 e9 ea ff ff       	call   801005c9 <panic>

  acquire(&icache.lock);
80101ae0:	83 ec 0c             	sub    $0xc,%esp
80101ae3:	68 20 1c 11 80       	push   $0x80111c20
80101ae8:	e8 6f 36 00 00       	call   8010515c <acquire>
80101aed:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101af0:	8b 45 08             	mov    0x8(%ebp),%eax
80101af3:	8b 40 0c             	mov    0xc(%eax),%eax
80101af6:	83 e0 fe             	and    $0xfffffffe,%eax
80101af9:	89 c2                	mov    %eax,%edx
80101afb:	8b 45 08             	mov    0x8(%ebp),%eax
80101afe:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b01:	83 ec 0c             	sub    $0xc,%esp
80101b04:	ff 75 08             	pushl  0x8(%ebp)
80101b07:	e8 4c 34 00 00       	call   80104f58 <wakeup>
80101b0c:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b0f:	83 ec 0c             	sub    $0xc,%esp
80101b12:	68 20 1c 11 80       	push   $0x80111c20
80101b17:	e8 a6 36 00 00       	call   801051c2 <release>
80101b1c:	83 c4 10             	add    $0x10,%esp
}
80101b1f:	c9                   	leave  
80101b20:	c3                   	ret    

80101b21 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b21:	55                   	push   %ebp
80101b22:	89 e5                	mov    %esp,%ebp
80101b24:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b27:	83 ec 0c             	sub    $0xc,%esp
80101b2a:	68 20 1c 11 80       	push   $0x80111c20
80101b2f:	e8 28 36 00 00       	call   8010515c <acquire>
80101b34:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b37:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3a:	8b 40 08             	mov    0x8(%eax),%eax
80101b3d:	83 f8 01             	cmp    $0x1,%eax
80101b40:	0f 85 a9 00 00 00    	jne    80101bef <iput+0xce>
80101b46:	8b 45 08             	mov    0x8(%ebp),%eax
80101b49:	8b 40 0c             	mov    0xc(%eax),%eax
80101b4c:	83 e0 02             	and    $0x2,%eax
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	0f 84 98 00 00 00    	je     80101bef <iput+0xce>
80101b57:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5a:	66 8b 40 16          	mov    0x16(%eax),%ax
80101b5e:	66 85 c0             	test   %ax,%ax
80101b61:	0f 85 88 00 00 00    	jne    80101bef <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b67:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6a:	8b 40 0c             	mov    0xc(%eax),%eax
80101b6d:	83 e0 01             	and    $0x1,%eax
80101b70:	85 c0                	test   %eax,%eax
80101b72:	74 0d                	je     80101b81 <iput+0x60>
      panic("iput busy");
80101b74:	83 ec 0c             	sub    $0xc,%esp
80101b77:	68 02 8a 10 80       	push   $0x80108a02
80101b7c:	e8 48 ea ff ff       	call   801005c9 <panic>
    ip->flags |= I_BUSY;
80101b81:	8b 45 08             	mov    0x8(%ebp),%eax
80101b84:	8b 40 0c             	mov    0xc(%eax),%eax
80101b87:	83 c8 01             	or     $0x1,%eax
80101b8a:	89 c2                	mov    %eax,%edx
80101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8f:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 20 1c 11 80       	push   $0x80111c20
80101b9a:	e8 23 36 00 00       	call   801051c2 <release>
80101b9f:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101ba2:	83 ec 0c             	sub    $0xc,%esp
80101ba5:	ff 75 08             	pushl  0x8(%ebp)
80101ba8:	e8 a6 01 00 00       	call   80101d53 <itrunc>
80101bad:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb3:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101bb9:	83 ec 0c             	sub    $0xc,%esp
80101bbc:	ff 75 08             	pushl  0x8(%ebp)
80101bbf:	e8 bb fb ff ff       	call   8010177f <iupdate>
80101bc4:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101bc7:	83 ec 0c             	sub    $0xc,%esp
80101bca:	68 20 1c 11 80       	push   $0x80111c20
80101bcf:	e8 88 35 00 00       	call   8010515c <acquire>
80101bd4:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101be1:	83 ec 0c             	sub    $0xc,%esp
80101be4:	ff 75 08             	pushl  0x8(%ebp)
80101be7:	e8 6c 33 00 00       	call   80104f58 <wakeup>
80101bec:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101bef:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf2:	8b 40 08             	mov    0x8(%eax),%eax
80101bf5:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfb:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bfe:	83 ec 0c             	sub    $0xc,%esp
80101c01:	68 20 1c 11 80       	push   $0x80111c20
80101c06:	e8 b7 35 00 00       	call   801051c2 <release>
80101c0b:	83 c4 10             	add    $0x10,%esp
}
80101c0e:	c9                   	leave  
80101c0f:	c3                   	ret    

80101c10 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c16:	83 ec 0c             	sub    $0xc,%esp
80101c19:	ff 75 08             	pushl  0x8(%ebp)
80101c1c:	e8 8f fe ff ff       	call   80101ab0 <iunlock>
80101c21:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c24:	83 ec 0c             	sub    $0xc,%esp
80101c27:	ff 75 08             	pushl  0x8(%ebp)
80101c2a:	e8 f2 fe ff ff       	call   80101b21 <iput>
80101c2f:	83 c4 10             	add    $0x10,%esp
}
80101c32:	c9                   	leave  
80101c33:	c3                   	ret    

80101c34 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c34:	55                   	push   %ebp
80101c35:	89 e5                	mov    %esp,%ebp
80101c37:	53                   	push   %ebx
80101c38:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c3b:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c3f:	77 42                	ja     80101c83 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c41:	8b 45 08             	mov    0x8(%ebp),%eax
80101c44:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c47:	83 c2 04             	add    $0x4,%edx
80101c4a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c55:	75 24                	jne    80101c7b <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c57:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5a:	8b 00                	mov    (%eax),%eax
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	50                   	push   %eax
80101c60:	e8 b6 f7 ff ff       	call   8010141b <balloc>
80101c65:	83 c4 10             	add    $0x10,%esp
80101c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c71:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c77:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c7e:	e9 cb 00 00 00       	jmp    80101d4e <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c83:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c87:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c8b:	0f 87 b0 00 00 00    	ja     80101d41 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c91:	8b 45 08             	mov    0x8(%ebp),%eax
80101c94:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c9e:	75 1d                	jne    80101cbd <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca3:	8b 00                	mov    (%eax),%eax
80101ca5:	83 ec 0c             	sub    $0xc,%esp
80101ca8:	50                   	push   %eax
80101ca9:	e8 6d f7 ff ff       	call   8010141b <balloc>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cba:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	8b 00                	mov    (%eax),%eax
80101cc2:	83 ec 08             	sub    $0x8,%esp
80101cc5:	ff 75 f4             	pushl  -0xc(%ebp)
80101cc8:	50                   	push   %eax
80101cc9:	e8 e6 e4 ff ff       	call   801001b4 <bread>
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd7:	83 c0 18             	add    $0x18,%eax
80101cda:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ce0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cea:	01 d0                	add    %edx,%eax
80101cec:	8b 00                	mov    (%eax),%eax
80101cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cf5:	75 37                	jne    80101d2e <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cfa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d04:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d07:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0a:	8b 00                	mov    (%eax),%eax
80101d0c:	83 ec 0c             	sub    $0xc,%esp
80101d0f:	50                   	push   %eax
80101d10:	e8 06 f7 ff ff       	call   8010141b <balloc>
80101d15:	83 c4 10             	add    $0x10,%esp
80101d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d1e:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d20:	83 ec 0c             	sub    $0xc,%esp
80101d23:	ff 75 f0             	pushl  -0x10(%ebp)
80101d26:	e8 a6 1a 00 00       	call   801037d1 <log_write>
80101d2b:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d2e:	83 ec 0c             	sub    $0xc,%esp
80101d31:	ff 75 f0             	pushl  -0x10(%ebp)
80101d34:	e8 f2 e4 ff ff       	call   8010022b <brelse>
80101d39:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d3f:	eb 0d                	jmp    80101d4e <bmap+0x11a>
  }

  panic("bmap: out of range");
80101d41:	83 ec 0c             	sub    $0xc,%esp
80101d44:	68 0c 8a 10 80       	push   $0x80108a0c
80101d49:	e8 7b e8 ff ff       	call   801005c9 <panic>
}
80101d4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d51:	c9                   	leave  
80101d52:	c3                   	ret    

80101d53 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d53:	55                   	push   %ebp
80101d54:	89 e5                	mov    %esp,%ebp
80101d56:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d60:	eb 44                	jmp    80101da6 <itrunc+0x53>
    if(ip->addrs[i]){
80101d62:	8b 45 08             	mov    0x8(%ebp),%eax
80101d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d68:	83 c2 04             	add    $0x4,%edx
80101d6b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d6f:	85 c0                	test   %eax,%eax
80101d71:	74 30                	je     80101da3 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d73:	8b 45 08             	mov    0x8(%ebp),%eax
80101d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d79:	83 c2 04             	add    $0x4,%edx
80101d7c:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	8b 00                	mov    (%eax),%eax
80101d85:	83 ec 08             	sub    $0x8,%esp
80101d88:	52                   	push   %edx
80101d89:	50                   	push   %eax
80101d8a:	e8 d1 f7 ff ff       	call   80101560 <bfree>
80101d8f:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d92:	8b 45 08             	mov    0x8(%ebp),%eax
80101d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d98:	83 c2 04             	add    $0x4,%edx
80101d9b:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101da2:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101da3:	ff 45 f4             	incl   -0xc(%ebp)
80101da6:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101daa:	7e b6                	jle    80101d62 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101dac:	8b 45 08             	mov    0x8(%ebp),%eax
80101daf:	8b 40 4c             	mov    0x4c(%eax),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	0f 84 a0 00 00 00    	je     80101e5a <itrunc+0x107>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dba:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbd:	8b 50 4c             	mov    0x4c(%eax),%edx
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	8b 00                	mov    (%eax),%eax
80101dc5:	83 ec 08             	sub    $0x8,%esp
80101dc8:	52                   	push   %edx
80101dc9:	50                   	push   %eax
80101dca:	e8 e5 e3 ff ff       	call   801001b4 <bread>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dd8:	83 c0 18             	add    $0x18,%eax
80101ddb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101dde:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101de5:	eb 3b                	jmp    80101e22 <itrunc+0xcf>
      if(a[j])
80101de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101df4:	01 d0                	add    %edx,%eax
80101df6:	8b 00                	mov    (%eax),%eax
80101df8:	85 c0                	test   %eax,%eax
80101dfa:	74 23                	je     80101e1f <itrunc+0xcc>
        bfree(ip->dev, a[j]);
80101dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e09:	01 d0                	add    %edx,%eax
80101e0b:	8b 10                	mov    (%eax),%edx
80101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e10:	8b 00                	mov    (%eax),%eax
80101e12:	83 ec 08             	sub    $0x8,%esp
80101e15:	52                   	push   %edx
80101e16:	50                   	push   %eax
80101e17:	e8 44 f7 ff ff       	call   80101560 <bfree>
80101e1c:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e1f:	ff 45 f0             	incl   -0x10(%ebp)
80101e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e25:	83 f8 7f             	cmp    $0x7f,%eax
80101e28:	76 bd                	jbe    80101de7 <itrunc+0x94>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e2a:	83 ec 0c             	sub    $0xc,%esp
80101e2d:	ff 75 ec             	pushl  -0x14(%ebp)
80101e30:	e8 f6 e3 ff ff       	call   8010022b <brelse>
80101e35:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e38:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3b:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e41:	8b 00                	mov    (%eax),%eax
80101e43:	83 ec 08             	sub    $0x8,%esp
80101e46:	52                   	push   %edx
80101e47:	50                   	push   %eax
80101e48:	e8 13 f7 ff ff       	call   80101560 <bfree>
80101e4d:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e50:	8b 45 08             	mov    0x8(%ebp),%eax
80101e53:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e64:	83 ec 0c             	sub    $0xc,%esp
80101e67:	ff 75 08             	pushl  0x8(%ebp)
80101e6a:	e8 10 f9 ff ff       	call   8010177f <iupdate>
80101e6f:	83 c4 10             	add    $0x10,%esp
}
80101e72:	c9                   	leave  
80101e73:	c3                   	ret    

80101e74 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e74:	55                   	push   %ebp
80101e75:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e77:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7a:	8b 00                	mov    (%eax),%eax
80101e7c:	89 c2                	mov    %eax,%edx
80101e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e81:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e84:	8b 45 08             	mov    0x8(%ebp),%eax
80101e87:	8b 50 04             	mov    0x4(%eax),%edx
80101e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8d:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e90:	8b 45 08             	mov    0x8(%ebp),%eax
80101e93:	8b 40 10             	mov    0x10(%eax),%eax
80101e96:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e99:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9f:	66 8b 40 16          	mov    0x16(%eax),%ax
80101ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ea6:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80101ead:	8b 50 18             	mov    0x18(%eax),%edx
80101eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb3:	89 50 10             	mov    %edx,0x10(%eax)
}
80101eb6:	5d                   	pop    %ebp
80101eb7:	c3                   	ret    

80101eb8 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101eb8:	55                   	push   %ebp
80101eb9:	89 e5                	mov    %esp,%ebp
80101ebb:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ebe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec1:	8b 40 10             	mov    0x10(%eax),%eax
80101ec4:	66 83 f8 03          	cmp    $0x3,%ax
80101ec8:	75 5c                	jne    80101f26 <readi+0x6e>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101eca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecd:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ed1:	66 85 c0             	test   %ax,%ax
80101ed4:	78 20                	js     80101ef6 <readi+0x3e>
80101ed6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed9:	66 8b 40 12          	mov    0x12(%eax),%ax
80101edd:	66 83 f8 09          	cmp    $0x9,%ax
80101ee1:	7f 13                	jg     80101ef6 <readi+0x3e>
80101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee6:	66 8b 40 12          	mov    0x12(%eax),%ax
80101eea:	98                   	cwtl   
80101eeb:	8b 04 c5 a0 1b 11 80 	mov    -0x7feee460(,%eax,8),%eax
80101ef2:	85 c0                	test   %eax,%eax
80101ef4:	75 0a                	jne    80101f00 <readi+0x48>
      return -1;
80101ef6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101efb:	e9 16 01 00 00       	jmp    80102016 <readi+0x15e>
    return devsw[ip->major].read(ip, dst, n);
80101f00:	8b 45 08             	mov    0x8(%ebp),%eax
80101f03:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f07:	98                   	cwtl   
80101f08:	8b 04 c5 a0 1b 11 80 	mov    -0x7feee460(,%eax,8),%eax
80101f0f:	8b 55 14             	mov    0x14(%ebp),%edx
80101f12:	83 ec 04             	sub    $0x4,%esp
80101f15:	52                   	push   %edx
80101f16:	ff 75 0c             	pushl  0xc(%ebp)
80101f19:	ff 75 08             	pushl  0x8(%ebp)
80101f1c:	ff d0                	call   *%eax
80101f1e:	83 c4 10             	add    $0x10,%esp
80101f21:	e9 f0 00 00 00       	jmp    80102016 <readi+0x15e>
  }

  if(off > ip->size || off + n < off)
80101f26:	8b 45 08             	mov    0x8(%ebp),%eax
80101f29:	8b 40 18             	mov    0x18(%eax),%eax
80101f2c:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f2f:	72 0d                	jb     80101f3e <readi+0x86>
80101f31:	8b 55 10             	mov    0x10(%ebp),%edx
80101f34:	8b 45 14             	mov    0x14(%ebp),%eax
80101f37:	01 d0                	add    %edx,%eax
80101f39:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f3c:	73 0a                	jae    80101f48 <readi+0x90>
    return -1;
80101f3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f43:	e9 ce 00 00 00       	jmp    80102016 <readi+0x15e>
  if(off + n > ip->size)
80101f48:	8b 55 10             	mov    0x10(%ebp),%edx
80101f4b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f4e:	01 c2                	add    %eax,%edx
80101f50:	8b 45 08             	mov    0x8(%ebp),%eax
80101f53:	8b 40 18             	mov    0x18(%eax),%eax
80101f56:	39 c2                	cmp    %eax,%edx
80101f58:	76 0c                	jbe    80101f66 <readi+0xae>
    n = ip->size - off;
80101f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5d:	8b 40 18             	mov    0x18(%eax),%eax
80101f60:	2b 45 10             	sub    0x10(%ebp),%eax
80101f63:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f6d:	e9 95 00 00 00       	jmp    80102007 <readi+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f72:	8b 45 10             	mov    0x10(%ebp),%eax
80101f75:	c1 e8 09             	shr    $0x9,%eax
80101f78:	83 ec 08             	sub    $0x8,%esp
80101f7b:	50                   	push   %eax
80101f7c:	ff 75 08             	pushl  0x8(%ebp)
80101f7f:	e8 b0 fc ff ff       	call   80101c34 <bmap>
80101f84:	83 c4 10             	add    $0x10,%esp
80101f87:	8b 55 08             	mov    0x8(%ebp),%edx
80101f8a:	8b 12                	mov    (%edx),%edx
80101f8c:	83 ec 08             	sub    $0x8,%esp
80101f8f:	50                   	push   %eax
80101f90:	52                   	push   %edx
80101f91:	e8 1e e2 ff ff       	call   801001b4 <bread>
80101f96:	83 c4 10             	add    $0x10,%esp
80101f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f9c:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9f:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fa4:	89 c2                	mov    %eax,%edx
80101fa6:	b8 00 02 00 00       	mov    $0x200,%eax
80101fab:	29 d0                	sub    %edx,%eax
80101fad:	89 c1                	mov    %eax,%ecx
80101faf:	8b 45 14             	mov    0x14(%ebp),%eax
80101fb2:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fb5:	89 c2                	mov    %eax,%edx
80101fb7:	89 c8                	mov    %ecx,%eax
80101fb9:	39 d0                	cmp    %edx,%eax
80101fbb:	76 02                	jbe    80101fbf <readi+0x107>
80101fbd:	89 d0                	mov    %edx,%eax
80101fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fc2:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fca:	8d 50 10             	lea    0x10(%eax),%edx
80101fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fd0:	01 d0                	add    %edx,%eax
80101fd2:	83 c0 08             	add    $0x8,%eax
80101fd5:	83 ec 04             	sub    $0x4,%esp
80101fd8:	ff 75 ec             	pushl  -0x14(%ebp)
80101fdb:	50                   	push   %eax
80101fdc:	ff 75 0c             	pushl  0xc(%ebp)
80101fdf:	e8 89 34 00 00       	call   8010546d <memmove>
80101fe4:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101fe7:	83 ec 0c             	sub    $0xc,%esp
80101fea:	ff 75 f0             	pushl  -0x10(%ebp)
80101fed:	e8 39 e2 ff ff       	call   8010022b <brelse>
80101ff2:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ff8:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ffe:	01 45 10             	add    %eax,0x10(%ebp)
80102001:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102004:	01 45 0c             	add    %eax,0xc(%ebp)
80102007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010200a:	3b 45 14             	cmp    0x14(%ebp),%eax
8010200d:	0f 82 5f ff ff ff    	jb     80101f72 <readi+0xba>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102013:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102016:	c9                   	leave  
80102017:	c3                   	ret    

80102018 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102018:	55                   	push   %ebp
80102019:	89 e5                	mov    %esp,%ebp
8010201b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010201e:	8b 45 08             	mov    0x8(%ebp),%eax
80102021:	8b 40 10             	mov    0x10(%eax),%eax
80102024:	66 83 f8 03          	cmp    $0x3,%ax
80102028:	75 5c                	jne    80102086 <writei+0x6e>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010202a:	8b 45 08             	mov    0x8(%ebp),%eax
8010202d:	66 8b 40 12          	mov    0x12(%eax),%ax
80102031:	66 85 c0             	test   %ax,%ax
80102034:	78 20                	js     80102056 <writei+0x3e>
80102036:	8b 45 08             	mov    0x8(%ebp),%eax
80102039:	66 8b 40 12          	mov    0x12(%eax),%ax
8010203d:	66 83 f8 09          	cmp    $0x9,%ax
80102041:	7f 13                	jg     80102056 <writei+0x3e>
80102043:	8b 45 08             	mov    0x8(%ebp),%eax
80102046:	66 8b 40 12          	mov    0x12(%eax),%ax
8010204a:	98                   	cwtl   
8010204b:	8b 04 c5 a4 1b 11 80 	mov    -0x7feee45c(,%eax,8),%eax
80102052:	85 c0                	test   %eax,%eax
80102054:	75 0a                	jne    80102060 <writei+0x48>
      return -1;
80102056:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010205b:	e9 47 01 00 00       	jmp    801021a7 <writei+0x18f>
    return devsw[ip->major].write(ip, src, n);
80102060:	8b 45 08             	mov    0x8(%ebp),%eax
80102063:	66 8b 40 12          	mov    0x12(%eax),%ax
80102067:	98                   	cwtl   
80102068:	8b 04 c5 a4 1b 11 80 	mov    -0x7feee45c(,%eax,8),%eax
8010206f:	8b 55 14             	mov    0x14(%ebp),%edx
80102072:	83 ec 04             	sub    $0x4,%esp
80102075:	52                   	push   %edx
80102076:	ff 75 0c             	pushl  0xc(%ebp)
80102079:	ff 75 08             	pushl  0x8(%ebp)
8010207c:	ff d0                	call   *%eax
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	e9 21 01 00 00       	jmp    801021a7 <writei+0x18f>
  }

  if(off > ip->size || off + n < off)
80102086:	8b 45 08             	mov    0x8(%ebp),%eax
80102089:	8b 40 18             	mov    0x18(%eax),%eax
8010208c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010208f:	72 0d                	jb     8010209e <writei+0x86>
80102091:	8b 55 10             	mov    0x10(%ebp),%edx
80102094:	8b 45 14             	mov    0x14(%ebp),%eax
80102097:	01 d0                	add    %edx,%eax
80102099:	3b 45 10             	cmp    0x10(%ebp),%eax
8010209c:	73 0a                	jae    801020a8 <writei+0x90>
    return -1;
8010209e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a3:	e9 ff 00 00 00       	jmp    801021a7 <writei+0x18f>
  if(off + n > MAXFILE*BSIZE)
801020a8:	8b 55 10             	mov    0x10(%ebp),%edx
801020ab:	8b 45 14             	mov    0x14(%ebp),%eax
801020ae:	01 d0                	add    %edx,%eax
801020b0:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020b5:	76 0a                	jbe    801020c1 <writei+0xa9>
    return -1;
801020b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020bc:	e9 e6 00 00 00       	jmp    801021a7 <writei+0x18f>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020c8:	e9 a3 00 00 00       	jmp    80102170 <writei+0x158>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020cd:	8b 45 10             	mov    0x10(%ebp),%eax
801020d0:	c1 e8 09             	shr    $0x9,%eax
801020d3:	83 ec 08             	sub    $0x8,%esp
801020d6:	50                   	push   %eax
801020d7:	ff 75 08             	pushl  0x8(%ebp)
801020da:	e8 55 fb ff ff       	call   80101c34 <bmap>
801020df:	83 c4 10             	add    $0x10,%esp
801020e2:	8b 55 08             	mov    0x8(%ebp),%edx
801020e5:	8b 12                	mov    (%edx),%edx
801020e7:	83 ec 08             	sub    $0x8,%esp
801020ea:	50                   	push   %eax
801020eb:	52                   	push   %edx
801020ec:	e8 c3 e0 ff ff       	call   801001b4 <bread>
801020f1:	83 c4 10             	add    $0x10,%esp
801020f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020f7:	8b 45 10             	mov    0x10(%ebp),%eax
801020fa:	25 ff 01 00 00       	and    $0x1ff,%eax
801020ff:	89 c2                	mov    %eax,%edx
80102101:	b8 00 02 00 00       	mov    $0x200,%eax
80102106:	29 d0                	sub    %edx,%eax
80102108:	89 c1                	mov    %eax,%ecx
8010210a:	8b 45 14             	mov    0x14(%ebp),%eax
8010210d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102110:	89 c2                	mov    %eax,%edx
80102112:	89 c8                	mov    %ecx,%eax
80102114:	39 d0                	cmp    %edx,%eax
80102116:	76 02                	jbe    8010211a <writei+0x102>
80102118:	89 d0                	mov    %edx,%eax
8010211a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010211d:	8b 45 10             	mov    0x10(%ebp),%eax
80102120:	25 ff 01 00 00       	and    $0x1ff,%eax
80102125:	8d 50 10             	lea    0x10(%eax),%edx
80102128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010212b:	01 d0                	add    %edx,%eax
8010212d:	83 c0 08             	add    $0x8,%eax
80102130:	83 ec 04             	sub    $0x4,%esp
80102133:	ff 75 ec             	pushl  -0x14(%ebp)
80102136:	ff 75 0c             	pushl  0xc(%ebp)
80102139:	50                   	push   %eax
8010213a:	e8 2e 33 00 00       	call   8010546d <memmove>
8010213f:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102142:	83 ec 0c             	sub    $0xc,%esp
80102145:	ff 75 f0             	pushl  -0x10(%ebp)
80102148:	e8 84 16 00 00       	call   801037d1 <log_write>
8010214d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102150:	83 ec 0c             	sub    $0xc,%esp
80102153:	ff 75 f0             	pushl  -0x10(%ebp)
80102156:	e8 d0 e0 ff ff       	call   8010022b <brelse>
8010215b:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010215e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102161:	01 45 f4             	add    %eax,-0xc(%ebp)
80102164:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102167:	01 45 10             	add    %eax,0x10(%ebp)
8010216a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010216d:	01 45 0c             	add    %eax,0xc(%ebp)
80102170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102173:	3b 45 14             	cmp    0x14(%ebp),%eax
80102176:	0f 82 51 ff ff ff    	jb     801020cd <writei+0xb5>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010217c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102180:	74 22                	je     801021a4 <writei+0x18c>
80102182:	8b 45 08             	mov    0x8(%ebp),%eax
80102185:	8b 40 18             	mov    0x18(%eax),%eax
80102188:	3b 45 10             	cmp    0x10(%ebp),%eax
8010218b:	73 17                	jae    801021a4 <writei+0x18c>
    ip->size = off;
8010218d:	8b 45 08             	mov    0x8(%ebp),%eax
80102190:	8b 55 10             	mov    0x10(%ebp),%edx
80102193:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102196:	83 ec 0c             	sub    $0xc,%esp
80102199:	ff 75 08             	pushl  0x8(%ebp)
8010219c:	e8 de f5 ff ff       	call   8010177f <iupdate>
801021a1:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021a4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021a7:	c9                   	leave  
801021a8:	c3                   	ret    

801021a9 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021a9:	55                   	push   %ebp
801021aa:	89 e5                	mov    %esp,%ebp
801021ac:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021af:	83 ec 04             	sub    $0x4,%esp
801021b2:	6a 0e                	push   $0xe
801021b4:	ff 75 0c             	pushl  0xc(%ebp)
801021b7:	ff 75 08             	pushl  0x8(%ebp)
801021ba:	e8 42 33 00 00       	call   80105501 <strncmp>
801021bf:	83 c4 10             	add    $0x10,%esp
}
801021c2:	c9                   	leave  
801021c3:	c3                   	ret    

801021c4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021c4:	55                   	push   %ebp
801021c5:	89 e5                	mov    %esp,%ebp
801021c7:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021ca:	8b 45 08             	mov    0x8(%ebp),%eax
801021cd:	8b 40 10             	mov    0x10(%eax),%eax
801021d0:	66 83 f8 01          	cmp    $0x1,%ax
801021d4:	74 0d                	je     801021e3 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 1f 8a 10 80       	push   $0x80108a1f
801021de:	e8 e6 e3 ff ff       	call   801005c9 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021ea:	eb 7a                	jmp    80102266 <dirlookup+0xa2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021ec:	6a 10                	push   $0x10
801021ee:	ff 75 f4             	pushl  -0xc(%ebp)
801021f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f4:	50                   	push   %eax
801021f5:	ff 75 08             	pushl  0x8(%ebp)
801021f8:	e8 bb fc ff ff       	call   80101eb8 <readi>
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	83 f8 10             	cmp    $0x10,%eax
80102203:	74 0d                	je     80102212 <dirlookup+0x4e>
      panic("dirlink read");
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	68 31 8a 10 80       	push   $0x80108a31
8010220d:	e8 b7 e3 ff ff       	call   801005c9 <panic>
    if(de.inum == 0)
80102212:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102215:	66 85 c0             	test   %ax,%ax
80102218:	75 02                	jne    8010221c <dirlookup+0x58>
      continue;
8010221a:	eb 46                	jmp    80102262 <dirlookup+0x9e>
    if(namecmp(name, de.name) == 0){
8010221c:	83 ec 08             	sub    $0x8,%esp
8010221f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102222:	83 c0 02             	add    $0x2,%eax
80102225:	50                   	push   %eax
80102226:	ff 75 0c             	pushl  0xc(%ebp)
80102229:	e8 7b ff ff ff       	call   801021a9 <namecmp>
8010222e:	83 c4 10             	add    $0x10,%esp
80102231:	85 c0                	test   %eax,%eax
80102233:	75 2d                	jne    80102262 <dirlookup+0x9e>
      // entry matches path element
      if(poff)
80102235:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102239:	74 08                	je     80102243 <dirlookup+0x7f>
        *poff = off;
8010223b:	8b 45 10             	mov    0x10(%ebp),%eax
8010223e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102241:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102243:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102246:	0f b7 c0             	movzwl %ax,%eax
80102249:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010224c:	8b 45 08             	mov    0x8(%ebp),%eax
8010224f:	8b 00                	mov    (%eax),%eax
80102251:	83 ec 08             	sub    $0x8,%esp
80102254:	ff 75 f0             	pushl  -0x10(%ebp)
80102257:	50                   	push   %eax
80102258:	e8 e0 f5 ff ff       	call   8010183d <iget>
8010225d:	83 c4 10             	add    $0x10,%esp
80102260:	eb 18                	jmp    8010227a <dirlookup+0xb6>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102262:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102266:	8b 45 08             	mov    0x8(%ebp),%eax
80102269:	8b 40 18             	mov    0x18(%eax),%eax
8010226c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010226f:	0f 87 77 ff ff ff    	ja     801021ec <dirlookup+0x28>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102275:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010227a:	c9                   	leave  
8010227b:	c3                   	ret    

8010227c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010227c:	55                   	push   %ebp
8010227d:	89 e5                	mov    %esp,%ebp
8010227f:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102282:	83 ec 04             	sub    $0x4,%esp
80102285:	6a 00                	push   $0x0
80102287:	ff 75 0c             	pushl  0xc(%ebp)
8010228a:	ff 75 08             	pushl  0x8(%ebp)
8010228d:	e8 32 ff ff ff       	call   801021c4 <dirlookup>
80102292:	83 c4 10             	add    $0x10,%esp
80102295:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102298:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010229c:	74 18                	je     801022b6 <dirlink+0x3a>
    iput(ip);
8010229e:	83 ec 0c             	sub    $0xc,%esp
801022a1:	ff 75 f0             	pushl  -0x10(%ebp)
801022a4:	e8 78 f8 ff ff       	call   80101b21 <iput>
801022a9:	83 c4 10             	add    $0x10,%esp
    return -1;
801022ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022b1:	e9 9a 00 00 00       	jmp    80102350 <dirlink+0xd4>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022bd:	eb 3a                	jmp    801022f9 <dirlink+0x7d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c2:	6a 10                	push   $0x10
801022c4:	50                   	push   %eax
801022c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022c8:	50                   	push   %eax
801022c9:	ff 75 08             	pushl  0x8(%ebp)
801022cc:	e8 e7 fb ff ff       	call   80101eb8 <readi>
801022d1:	83 c4 10             	add    $0x10,%esp
801022d4:	83 f8 10             	cmp    $0x10,%eax
801022d7:	74 0d                	je     801022e6 <dirlink+0x6a>
      panic("dirlink read");
801022d9:	83 ec 0c             	sub    $0xc,%esp
801022dc:	68 31 8a 10 80       	push   $0x80108a31
801022e1:	e8 e3 e2 ff ff       	call   801005c9 <panic>
    if(de.inum == 0)
801022e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801022e9:	66 85 c0             	test   %ax,%ax
801022ec:	75 02                	jne    801022f0 <dirlink+0x74>
      break;
801022ee:	eb 16                	jmp    80102306 <dirlink+0x8a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f3:	83 c0 10             	add    $0x10,%eax
801022f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022fc:	8b 45 08             	mov    0x8(%ebp),%eax
801022ff:	8b 40 18             	mov    0x18(%eax),%eax
80102302:	39 c2                	cmp    %eax,%edx
80102304:	72 b9                	jb     801022bf <dirlink+0x43>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102306:	83 ec 04             	sub    $0x4,%esp
80102309:	6a 0e                	push   $0xe
8010230b:	ff 75 0c             	pushl  0xc(%ebp)
8010230e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102311:	83 c0 02             	add    $0x2,%eax
80102314:	50                   	push   %eax
80102315:	e8 35 32 00 00       	call   8010554f <strncpy>
8010231a:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010231d:	8b 45 10             	mov    0x10(%ebp),%eax
80102320:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102327:	6a 10                	push   $0x10
80102329:	50                   	push   %eax
8010232a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010232d:	50                   	push   %eax
8010232e:	ff 75 08             	pushl  0x8(%ebp)
80102331:	e8 e2 fc ff ff       	call   80102018 <writei>
80102336:	83 c4 10             	add    $0x10,%esp
80102339:	83 f8 10             	cmp    $0x10,%eax
8010233c:	74 0d                	je     8010234b <dirlink+0xcf>
    panic("dirlink");
8010233e:	83 ec 0c             	sub    $0xc,%esp
80102341:	68 3e 8a 10 80       	push   $0x80108a3e
80102346:	e8 7e e2 ff ff       	call   801005c9 <panic>
  
  return 0;
8010234b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102350:	c9                   	leave  
80102351:	c3                   	ret    

80102352 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102352:	55                   	push   %ebp
80102353:	89 e5                	mov    %esp,%ebp
80102355:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102358:	eb 03                	jmp    8010235d <skipelem+0xb>
    path++;
8010235a:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010235d:	8b 45 08             	mov    0x8(%ebp),%eax
80102360:	8a 00                	mov    (%eax),%al
80102362:	3c 2f                	cmp    $0x2f,%al
80102364:	74 f4                	je     8010235a <skipelem+0x8>
    path++;
  if(*path == 0)
80102366:	8b 45 08             	mov    0x8(%ebp),%eax
80102369:	8a 00                	mov    (%eax),%al
8010236b:	84 c0                	test   %al,%al
8010236d:	75 07                	jne    80102376 <skipelem+0x24>
    return 0;
8010236f:	b8 00 00 00 00       	mov    $0x0,%eax
80102374:	eb 76                	jmp    801023ec <skipelem+0x9a>
  s = path;
80102376:	8b 45 08             	mov    0x8(%ebp),%eax
80102379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010237c:	eb 03                	jmp    80102381 <skipelem+0x2f>
    path++;
8010237e:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102381:	8b 45 08             	mov    0x8(%ebp),%eax
80102384:	8a 00                	mov    (%eax),%al
80102386:	3c 2f                	cmp    $0x2f,%al
80102388:	74 09                	je     80102393 <skipelem+0x41>
8010238a:	8b 45 08             	mov    0x8(%ebp),%eax
8010238d:	8a 00                	mov    (%eax),%al
8010238f:	84 c0                	test   %al,%al
80102391:	75 eb                	jne    8010237e <skipelem+0x2c>
    path++;
  len = path - s;
80102393:	8b 55 08             	mov    0x8(%ebp),%edx
80102396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102399:	29 c2                	sub    %eax,%edx
8010239b:	89 d0                	mov    %edx,%eax
8010239d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023a4:	7e 15                	jle    801023bb <skipelem+0x69>
    memmove(name, s, DIRSIZ);
801023a6:	83 ec 04             	sub    $0x4,%esp
801023a9:	6a 0e                	push   $0xe
801023ab:	ff 75 f4             	pushl  -0xc(%ebp)
801023ae:	ff 75 0c             	pushl  0xc(%ebp)
801023b1:	e8 b7 30 00 00       	call   8010546d <memmove>
801023b6:	83 c4 10             	add    $0x10,%esp
801023b9:	eb 20                	jmp    801023db <skipelem+0x89>
  else {
    memmove(name, s, len);
801023bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023be:	83 ec 04             	sub    $0x4,%esp
801023c1:	50                   	push   %eax
801023c2:	ff 75 f4             	pushl  -0xc(%ebp)
801023c5:	ff 75 0c             	pushl  0xc(%ebp)
801023c8:	e8 a0 30 00 00       	call   8010546d <memmove>
801023cd:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801023d6:	01 d0                	add    %edx,%eax
801023d8:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023db:	eb 03                	jmp    801023e0 <skipelem+0x8e>
    path++;
801023dd:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023e0:	8b 45 08             	mov    0x8(%ebp),%eax
801023e3:	8a 00                	mov    (%eax),%al
801023e5:	3c 2f                	cmp    $0x2f,%al
801023e7:	74 f4                	je     801023dd <skipelem+0x8b>
    path++;
  return path;
801023e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023ec:	c9                   	leave  
801023ed:	c3                   	ret    

801023ee <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023ee:	55                   	push   %ebp
801023ef:	89 e5                	mov    %esp,%ebp
801023f1:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023f4:	8b 45 08             	mov    0x8(%ebp),%eax
801023f7:	8a 00                	mov    (%eax),%al
801023f9:	3c 2f                	cmp    $0x2f,%al
801023fb:	75 14                	jne    80102411 <namex+0x23>
    ip = iget(ROOTDEV, ROOTINO);
801023fd:	83 ec 08             	sub    $0x8,%esp
80102400:	6a 01                	push   $0x1
80102402:	6a 01                	push   $0x1
80102404:	e8 34 f4 ff ff       	call   8010183d <iget>
80102409:	83 c4 10             	add    $0x10,%esp
8010240c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010240f:	eb 18                	jmp    80102429 <namex+0x3b>
  else
    ip = idup(proc->cwd);
80102411:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102417:	8b 40 68             	mov    0x68(%eax),%eax
8010241a:	83 ec 0c             	sub    $0xc,%esp
8010241d:	50                   	push   %eax
8010241e:	e8 f9 f4 ff ff       	call   8010191c <idup>
80102423:	83 c4 10             	add    $0x10,%esp
80102426:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102429:	e9 9c 00 00 00       	jmp    801024ca <namex+0xdc>
    ilock(ip);
8010242e:	83 ec 0c             	sub    $0xc,%esp
80102431:	ff 75 f4             	pushl  -0xc(%ebp)
80102434:	e8 1d f5 ff ff       	call   80101956 <ilock>
80102439:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243f:	8b 40 10             	mov    0x10(%eax),%eax
80102442:	66 83 f8 01          	cmp    $0x1,%ax
80102446:	74 18                	je     80102460 <namex+0x72>
      iunlockput(ip);
80102448:	83 ec 0c             	sub    $0xc,%esp
8010244b:	ff 75 f4             	pushl  -0xc(%ebp)
8010244e:	e8 bd f7 ff ff       	call   80101c10 <iunlockput>
80102453:	83 c4 10             	add    $0x10,%esp
      return 0;
80102456:	b8 00 00 00 00       	mov    $0x0,%eax
8010245b:	e9 a6 00 00 00       	jmp    80102506 <namex+0x118>
    }
    if(nameiparent && *path == '\0'){
80102460:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102464:	74 1f                	je     80102485 <namex+0x97>
80102466:	8b 45 08             	mov    0x8(%ebp),%eax
80102469:	8a 00                	mov    (%eax),%al
8010246b:	84 c0                	test   %al,%al
8010246d:	75 16                	jne    80102485 <namex+0x97>
      // Stop one level early.
      iunlock(ip);
8010246f:	83 ec 0c             	sub    $0xc,%esp
80102472:	ff 75 f4             	pushl  -0xc(%ebp)
80102475:	e8 36 f6 ff ff       	call   80101ab0 <iunlock>
8010247a:	83 c4 10             	add    $0x10,%esp
      return ip;
8010247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102480:	e9 81 00 00 00       	jmp    80102506 <namex+0x118>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102485:	83 ec 04             	sub    $0x4,%esp
80102488:	6a 00                	push   $0x0
8010248a:	ff 75 10             	pushl  0x10(%ebp)
8010248d:	ff 75 f4             	pushl  -0xc(%ebp)
80102490:	e8 2f fd ff ff       	call   801021c4 <dirlookup>
80102495:	83 c4 10             	add    $0x10,%esp
80102498:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010249b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010249f:	75 15                	jne    801024b6 <namex+0xc8>
      iunlockput(ip);
801024a1:	83 ec 0c             	sub    $0xc,%esp
801024a4:	ff 75 f4             	pushl  -0xc(%ebp)
801024a7:	e8 64 f7 ff ff       	call   80101c10 <iunlockput>
801024ac:	83 c4 10             	add    $0x10,%esp
      return 0;
801024af:	b8 00 00 00 00       	mov    $0x0,%eax
801024b4:	eb 50                	jmp    80102506 <namex+0x118>
    }
    iunlockput(ip);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	ff 75 f4             	pushl  -0xc(%ebp)
801024bc:	e8 4f f7 ff ff       	call   80101c10 <iunlockput>
801024c1:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801024ca:	83 ec 08             	sub    $0x8,%esp
801024cd:	ff 75 10             	pushl  0x10(%ebp)
801024d0:	ff 75 08             	pushl  0x8(%ebp)
801024d3:	e8 7a fe ff ff       	call   80102352 <skipelem>
801024d8:	83 c4 10             	add    $0x10,%esp
801024db:	89 45 08             	mov    %eax,0x8(%ebp)
801024de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024e2:	0f 85 46 ff ff ff    	jne    8010242e <namex+0x40>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024ec:	74 15                	je     80102503 <namex+0x115>
    iput(ip);
801024ee:	83 ec 0c             	sub    $0xc,%esp
801024f1:	ff 75 f4             	pushl  -0xc(%ebp)
801024f4:	e8 28 f6 ff ff       	call   80101b21 <iput>
801024f9:	83 c4 10             	add    $0x10,%esp
    return 0;
801024fc:	b8 00 00 00 00       	mov    $0x0,%eax
80102501:	eb 03                	jmp    80102506 <namex+0x118>
  }
  return ip;
80102503:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102506:	c9                   	leave  
80102507:	c3                   	ret    

80102508 <namei>:

struct inode*
namei(char *path)
{
80102508:	55                   	push   %ebp
80102509:	89 e5                	mov    %esp,%ebp
8010250b:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010250e:	83 ec 04             	sub    $0x4,%esp
80102511:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102514:	50                   	push   %eax
80102515:	6a 00                	push   $0x0
80102517:	ff 75 08             	pushl  0x8(%ebp)
8010251a:	e8 cf fe ff ff       	call   801023ee <namex>
8010251f:	83 c4 10             	add    $0x10,%esp
}
80102522:	c9                   	leave  
80102523:	c3                   	ret    

80102524 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010252a:	83 ec 04             	sub    $0x4,%esp
8010252d:	ff 75 0c             	pushl  0xc(%ebp)
80102530:	6a 01                	push   $0x1
80102532:	ff 75 08             	pushl  0x8(%ebp)
80102535:	e8 b4 fe ff ff       	call   801023ee <namex>
8010253a:	83 c4 10             	add    $0x10,%esp
}
8010253d:	c9                   	leave  
8010253e:	c3                   	ret    

8010253f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010253f:	55                   	push   %ebp
80102540:	89 e5                	mov    %esp,%ebp
80102542:	83 ec 14             	sub    $0x14,%esp
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
80102548:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010254c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010254f:	89 c2                	mov    %eax,%edx
80102551:	ec                   	in     (%dx),%al
80102552:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102555:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102558:	c9                   	leave  
80102559:	c3                   	ret    

8010255a <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010255a:	55                   	push   %ebp
8010255b:	89 e5                	mov    %esp,%ebp
8010255d:	57                   	push   %edi
8010255e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010255f:	8b 55 08             	mov    0x8(%ebp),%edx
80102562:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102565:	8b 45 10             	mov    0x10(%ebp),%eax
80102568:	89 cb                	mov    %ecx,%ebx
8010256a:	89 df                	mov    %ebx,%edi
8010256c:	89 c1                	mov    %eax,%ecx
8010256e:	fc                   	cld    
8010256f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102571:	89 c8                	mov    %ecx,%eax
80102573:	89 fb                	mov    %edi,%ebx
80102575:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102578:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010257b:	5b                   	pop    %ebx
8010257c:	5f                   	pop    %edi
8010257d:	5d                   	pop    %ebp
8010257e:	c3                   	ret    

8010257f <outb>:

static inline void
outb(ushort port, uchar data)
{
8010257f:	55                   	push   %ebp
80102580:	89 e5                	mov    %esp,%ebp
80102582:	83 ec 08             	sub    $0x8,%esp
80102585:	8b 45 08             	mov    0x8(%ebp),%eax
80102588:	8b 55 0c             	mov    0xc(%ebp),%edx
8010258b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010258f:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102592:	8a 45 f8             	mov    -0x8(%ebp),%al
80102595:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102598:	ee                   	out    %al,(%dx)
}
80102599:	c9                   	leave  
8010259a:	c3                   	ret    

8010259b <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010259b:	55                   	push   %ebp
8010259c:	89 e5                	mov    %esp,%ebp
8010259e:	56                   	push   %esi
8010259f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025a0:	8b 55 08             	mov    0x8(%ebp),%edx
801025a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025a6:	8b 45 10             	mov    0x10(%ebp),%eax
801025a9:	89 cb                	mov    %ecx,%ebx
801025ab:	89 de                	mov    %ebx,%esi
801025ad:	89 c1                	mov    %eax,%ecx
801025af:	fc                   	cld    
801025b0:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025b2:	89 c8                	mov    %ecx,%eax
801025b4:	89 f3                	mov    %esi,%ebx
801025b6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025b9:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801025bc:	5b                   	pop    %ebx
801025bd:	5e                   	pop    %esi
801025be:	5d                   	pop    %ebp
801025bf:	c3                   	ret    

801025c0 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801025c6:	90                   	nop
801025c7:	68 f7 01 00 00       	push   $0x1f7
801025cc:	e8 6e ff ff ff       	call   8010253f <inb>
801025d1:	83 c4 04             	add    $0x4,%esp
801025d4:	0f b6 c0             	movzbl %al,%eax
801025d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025dd:	25 c0 00 00 00       	and    $0xc0,%eax
801025e2:	83 f8 40             	cmp    $0x40,%eax
801025e5:	75 e0                	jne    801025c7 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025eb:	74 11                	je     801025fe <idewait+0x3e>
801025ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025f0:	83 e0 21             	and    $0x21,%eax
801025f3:	85 c0                	test   %eax,%eax
801025f5:	74 07                	je     801025fe <idewait+0x3e>
    return -1;
801025f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025fc:	eb 05                	jmp    80102603 <idewait+0x43>
  return 0;
801025fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102603:	c9                   	leave  
80102604:	c3                   	ret    

80102605 <ideinit>:

void
ideinit(void)
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
80102608:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
8010260b:	83 ec 08             	sub    $0x8,%esp
8010260e:	68 46 8a 10 80       	push   $0x80108a46
80102613:	68 20 b6 10 80       	push   $0x8010b620
80102618:	e8 1e 2b 00 00       	call   8010513b <initlock>
8010261d:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	6a 0e                	push   $0xe
80102625:	e8 9c 19 00 00       	call   80103fc6 <picenable>
8010262a:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010262d:	a1 20 33 11 80       	mov    0x80113320,%eax
80102632:	48                   	dec    %eax
80102633:	83 ec 08             	sub    $0x8,%esp
80102636:	50                   	push   %eax
80102637:	6a 0e                	push   $0xe
80102639:	e8 67 04 00 00       	call   80102aa5 <ioapicenable>
8010263e:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102641:	83 ec 0c             	sub    $0xc,%esp
80102644:	6a 00                	push   $0x0
80102646:	e8 75 ff ff ff       	call   801025c0 <idewait>
8010264b:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010264e:	83 ec 08             	sub    $0x8,%esp
80102651:	68 f0 00 00 00       	push   $0xf0
80102656:	68 f6 01 00 00       	push   $0x1f6
8010265b:	e8 1f ff ff ff       	call   8010257f <outb>
80102660:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102663:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010266a:	eb 23                	jmp    8010268f <ideinit+0x8a>
    if(inb(0x1f7) != 0){
8010266c:	83 ec 0c             	sub    $0xc,%esp
8010266f:	68 f7 01 00 00       	push   $0x1f7
80102674:	e8 c6 fe ff ff       	call   8010253f <inb>
80102679:	83 c4 10             	add    $0x10,%esp
8010267c:	84 c0                	test   %al,%al
8010267e:	74 0c                	je     8010268c <ideinit+0x87>
      havedisk1 = 1;
80102680:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
80102687:	00 00 00 
      break;
8010268a:	eb 0c                	jmp    80102698 <ideinit+0x93>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010268c:	ff 45 f4             	incl   -0xc(%ebp)
8010268f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102696:	7e d4                	jle    8010266c <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	68 e0 00 00 00       	push   $0xe0
801026a0:	68 f6 01 00 00       	push   $0x1f6
801026a5:	e8 d5 fe ff ff       	call   8010257f <outb>
801026aa:	83 c4 10             	add    $0x10,%esp
}
801026ad:	c9                   	leave  
801026ae:	c3                   	ret    

801026af <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026af:	55                   	push   %ebp
801026b0:	89 e5                	mov    %esp,%ebp
801026b2:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026b9:	75 0d                	jne    801026c8 <idestart+0x19>
    panic("idestart");
801026bb:	83 ec 0c             	sub    $0xc,%esp
801026be:	68 4a 8a 10 80       	push   $0x80108a4a
801026c3:	e8 01 df ff ff       	call   801005c9 <panic>
  if(b->blockno >= FSSIZE)
801026c8:	8b 45 08             	mov    0x8(%ebp),%eax
801026cb:	8b 40 08             	mov    0x8(%eax),%eax
801026ce:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026d3:	76 0d                	jbe    801026e2 <idestart+0x33>
    panic("incorrect blockno");
801026d5:	83 ec 0c             	sub    $0xc,%esp
801026d8:	68 53 8a 10 80       	push   $0x80108a53
801026dd:	e8 e7 de ff ff       	call   801005c9 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026e9:	8b 45 08             	mov    0x8(%ebp),%eax
801026ec:	8b 50 08             	mov    0x8(%eax),%edx
801026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f2:	0f af c2             	imul   %edx,%eax
801026f5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026f8:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026fc:	7e 0d                	jle    8010270b <idestart+0x5c>
801026fe:	83 ec 0c             	sub    $0xc,%esp
80102701:	68 4a 8a 10 80       	push   $0x80108a4a
80102706:	e8 be de ff ff       	call   801005c9 <panic>
  
  idewait(0);
8010270b:	83 ec 0c             	sub    $0xc,%esp
8010270e:	6a 00                	push   $0x0
80102710:	e8 ab fe ff ff       	call   801025c0 <idewait>
80102715:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102718:	83 ec 08             	sub    $0x8,%esp
8010271b:	6a 00                	push   $0x0
8010271d:	68 f6 03 00 00       	push   $0x3f6
80102722:	e8 58 fe ff ff       	call   8010257f <outb>
80102727:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272d:	0f b6 c0             	movzbl %al,%eax
80102730:	83 ec 08             	sub    $0x8,%esp
80102733:	50                   	push   %eax
80102734:	68 f2 01 00 00       	push   $0x1f2
80102739:	e8 41 fe ff ff       	call   8010257f <outb>
8010273e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102744:	0f b6 c0             	movzbl %al,%eax
80102747:	83 ec 08             	sub    $0x8,%esp
8010274a:	50                   	push   %eax
8010274b:	68 f3 01 00 00       	push   $0x1f3
80102750:	e8 2a fe ff ff       	call   8010257f <outb>
80102755:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102758:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010275b:	c1 f8 08             	sar    $0x8,%eax
8010275e:	0f b6 c0             	movzbl %al,%eax
80102761:	83 ec 08             	sub    $0x8,%esp
80102764:	50                   	push   %eax
80102765:	68 f4 01 00 00       	push   $0x1f4
8010276a:	e8 10 fe ff ff       	call   8010257f <outb>
8010276f:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102772:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102775:	c1 f8 10             	sar    $0x10,%eax
80102778:	0f b6 c0             	movzbl %al,%eax
8010277b:	83 ec 08             	sub    $0x8,%esp
8010277e:	50                   	push   %eax
8010277f:	68 f5 01 00 00       	push   $0x1f5
80102784:	e8 f6 fd ff ff       	call   8010257f <outb>
80102789:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010278c:	8b 45 08             	mov    0x8(%ebp),%eax
8010278f:	8b 40 04             	mov    0x4(%eax),%eax
80102792:	83 e0 01             	and    $0x1,%eax
80102795:	c1 e0 04             	shl    $0x4,%eax
80102798:	88 c2                	mov    %al,%dl
8010279a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010279d:	c1 f8 18             	sar    $0x18,%eax
801027a0:	83 e0 0f             	and    $0xf,%eax
801027a3:	09 d0                	or     %edx,%eax
801027a5:	83 c8 e0             	or     $0xffffffe0,%eax
801027a8:	0f b6 c0             	movzbl %al,%eax
801027ab:	83 ec 08             	sub    $0x8,%esp
801027ae:	50                   	push   %eax
801027af:	68 f6 01 00 00       	push   $0x1f6
801027b4:	e8 c6 fd ff ff       	call   8010257f <outb>
801027b9:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801027bc:	8b 45 08             	mov    0x8(%ebp),%eax
801027bf:	8b 00                	mov    (%eax),%eax
801027c1:	83 e0 04             	and    $0x4,%eax
801027c4:	85 c0                	test   %eax,%eax
801027c6:	74 30                	je     801027f8 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801027c8:	83 ec 08             	sub    $0x8,%esp
801027cb:	6a 30                	push   $0x30
801027cd:	68 f7 01 00 00       	push   $0x1f7
801027d2:	e8 a8 fd ff ff       	call   8010257f <outb>
801027d7:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801027da:	8b 45 08             	mov    0x8(%ebp),%eax
801027dd:	83 c0 18             	add    $0x18,%eax
801027e0:	83 ec 04             	sub    $0x4,%esp
801027e3:	68 80 00 00 00       	push   $0x80
801027e8:	50                   	push   %eax
801027e9:	68 f0 01 00 00       	push   $0x1f0
801027ee:	e8 a8 fd ff ff       	call   8010259b <outsl>
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	eb 12                	jmp    8010280a <idestart+0x15b>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801027f8:	83 ec 08             	sub    $0x8,%esp
801027fb:	6a 20                	push   $0x20
801027fd:	68 f7 01 00 00       	push   $0x1f7
80102802:	e8 78 fd ff ff       	call   8010257f <outb>
80102807:	83 c4 10             	add    $0x10,%esp
  }
}
8010280a:	c9                   	leave  
8010280b:	c3                   	ret    

8010280c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010280c:	55                   	push   %ebp
8010280d:	89 e5                	mov    %esp,%ebp
8010280f:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102812:	83 ec 0c             	sub    $0xc,%esp
80102815:	68 20 b6 10 80       	push   $0x8010b620
8010281a:	e8 3d 29 00 00       	call   8010515c <acquire>
8010281f:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102822:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102827:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010282a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010282e:	75 15                	jne    80102845 <ideintr+0x39>
    release(&idelock);
80102830:	83 ec 0c             	sub    $0xc,%esp
80102833:	68 20 b6 10 80       	push   $0x8010b620
80102838:	e8 85 29 00 00       	call   801051c2 <release>
8010283d:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102840:	e9 9a 00 00 00       	jmp    801028df <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102848:	8b 40 14             	mov    0x14(%eax),%eax
8010284b:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102853:	8b 00                	mov    (%eax),%eax
80102855:	83 e0 04             	and    $0x4,%eax
80102858:	85 c0                	test   %eax,%eax
8010285a:	75 2d                	jne    80102889 <ideintr+0x7d>
8010285c:	83 ec 0c             	sub    $0xc,%esp
8010285f:	6a 01                	push   $0x1
80102861:	e8 5a fd ff ff       	call   801025c0 <idewait>
80102866:	83 c4 10             	add    $0x10,%esp
80102869:	85 c0                	test   %eax,%eax
8010286b:	78 1c                	js     80102889 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
8010286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102870:	83 c0 18             	add    $0x18,%eax
80102873:	83 ec 04             	sub    $0x4,%esp
80102876:	68 80 00 00 00       	push   $0x80
8010287b:	50                   	push   %eax
8010287c:	68 f0 01 00 00       	push   $0x1f0
80102881:	e8 d4 fc ff ff       	call   8010255a <insl>
80102886:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010288c:	8b 00                	mov    (%eax),%eax
8010288e:	83 c8 02             	or     $0x2,%eax
80102891:	89 c2                	mov    %eax,%edx
80102893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102896:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010289b:	8b 00                	mov    (%eax),%eax
8010289d:	83 e0 fb             	and    $0xfffffffb,%eax
801028a0:	89 c2                	mov    %eax,%edx
801028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a5:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801028a7:	83 ec 0c             	sub    $0xc,%esp
801028aa:	ff 75 f4             	pushl  -0xc(%ebp)
801028ad:	e8 a6 26 00 00       	call   80104f58 <wakeup>
801028b2:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801028b5:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801028ba:	85 c0                	test   %eax,%eax
801028bc:	74 11                	je     801028cf <ideintr+0xc3>
    idestart(idequeue);
801028be:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801028c3:	83 ec 0c             	sub    $0xc,%esp
801028c6:	50                   	push   %eax
801028c7:	e8 e3 fd ff ff       	call   801026af <idestart>
801028cc:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801028cf:	83 ec 0c             	sub    $0xc,%esp
801028d2:	68 20 b6 10 80       	push   $0x8010b620
801028d7:	e8 e6 28 00 00       	call   801051c2 <release>
801028dc:	83 c4 10             	add    $0x10,%esp
}
801028df:	c9                   	leave  
801028e0:	c3                   	ret    

801028e1 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028e1:	55                   	push   %ebp
801028e2:	89 e5                	mov    %esp,%ebp
801028e4:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801028e7:	8b 45 08             	mov    0x8(%ebp),%eax
801028ea:	8b 00                	mov    (%eax),%eax
801028ec:	83 e0 01             	and    $0x1,%eax
801028ef:	85 c0                	test   %eax,%eax
801028f1:	75 0d                	jne    80102900 <iderw+0x1f>
    panic("iderw: buf not busy");
801028f3:	83 ec 0c             	sub    $0xc,%esp
801028f6:	68 65 8a 10 80       	push   $0x80108a65
801028fb:	e8 c9 dc ff ff       	call   801005c9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102900:	8b 45 08             	mov    0x8(%ebp),%eax
80102903:	8b 00                	mov    (%eax),%eax
80102905:	83 e0 06             	and    $0x6,%eax
80102908:	83 f8 02             	cmp    $0x2,%eax
8010290b:	75 0d                	jne    8010291a <iderw+0x39>
    panic("iderw: nothing to do");
8010290d:	83 ec 0c             	sub    $0xc,%esp
80102910:	68 79 8a 10 80       	push   $0x80108a79
80102915:	e8 af dc ff ff       	call   801005c9 <panic>
  if(b->dev != 0 && !havedisk1)
8010291a:	8b 45 08             	mov    0x8(%ebp),%eax
8010291d:	8b 40 04             	mov    0x4(%eax),%eax
80102920:	85 c0                	test   %eax,%eax
80102922:	74 16                	je     8010293a <iderw+0x59>
80102924:	a1 58 b6 10 80       	mov    0x8010b658,%eax
80102929:	85 c0                	test   %eax,%eax
8010292b:	75 0d                	jne    8010293a <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010292d:	83 ec 0c             	sub    $0xc,%esp
80102930:	68 8e 8a 10 80       	push   $0x80108a8e
80102935:	e8 8f dc ff ff       	call   801005c9 <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010293a:	83 ec 0c             	sub    $0xc,%esp
8010293d:	68 20 b6 10 80       	push   $0x8010b620
80102942:	e8 15 28 00 00       	call   8010515c <acquire>
80102947:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
8010294a:	8b 45 08             	mov    0x8(%ebp),%eax
8010294d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102954:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
8010295b:	eb 0b                	jmp    80102968 <iderw+0x87>
8010295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102960:	8b 00                	mov    (%eax),%eax
80102962:	83 c0 14             	add    $0x14,%eax
80102965:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296b:	8b 00                	mov    (%eax),%eax
8010296d:	85 c0                	test   %eax,%eax
8010296f:	75 ec                	jne    8010295d <iderw+0x7c>
    ;
  *pp = b;
80102971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102974:	8b 55 08             	mov    0x8(%ebp),%edx
80102977:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102979:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010297e:	3b 45 08             	cmp    0x8(%ebp),%eax
80102981:	75 0e                	jne    80102991 <iderw+0xb0>
    idestart(b);
80102983:	83 ec 0c             	sub    $0xc,%esp
80102986:	ff 75 08             	pushl  0x8(%ebp)
80102989:	e8 21 fd ff ff       	call   801026af <idestart>
8010298e:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102991:	eb 13                	jmp    801029a6 <iderw+0xc5>
    sleep(b, &idelock);
80102993:	83 ec 08             	sub    $0x8,%esp
80102996:	68 20 b6 10 80       	push   $0x8010b620
8010299b:	ff 75 08             	pushl  0x8(%ebp)
8010299e:	e8 cc 24 00 00       	call   80104e6f <sleep>
801029a3:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029a6:	8b 45 08             	mov    0x8(%ebp),%eax
801029a9:	8b 00                	mov    (%eax),%eax
801029ab:	83 e0 06             	and    $0x6,%eax
801029ae:	83 f8 02             	cmp    $0x2,%eax
801029b1:	75 e0                	jne    80102993 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
801029b3:	83 ec 0c             	sub    $0xc,%esp
801029b6:	68 20 b6 10 80       	push   $0x8010b620
801029bb:	e8 02 28 00 00       	call   801051c2 <release>
801029c0:	83 c4 10             	add    $0x10,%esp
}
801029c3:	c9                   	leave  
801029c4:	c3                   	ret    

801029c5 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801029c5:	55                   	push   %ebp
801029c6:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029c8:	a1 f4 2b 11 80       	mov    0x80112bf4,%eax
801029cd:	8b 55 08             	mov    0x8(%ebp),%edx
801029d0:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029d2:	a1 f4 2b 11 80       	mov    0x80112bf4,%eax
801029d7:	8b 40 10             	mov    0x10(%eax),%eax
}
801029da:	5d                   	pop    %ebp
801029db:	c3                   	ret    

801029dc <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801029dc:	55                   	push   %ebp
801029dd:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029df:	a1 f4 2b 11 80       	mov    0x80112bf4,%eax
801029e4:	8b 55 08             	mov    0x8(%ebp),%edx
801029e7:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801029e9:	a1 f4 2b 11 80       	mov    0x80112bf4,%eax
801029ee:	8b 55 0c             	mov    0xc(%ebp),%edx
801029f1:	89 50 10             	mov    %edx,0x10(%eax)
}
801029f4:	5d                   	pop    %ebp
801029f5:	c3                   	ret    

801029f6 <ioapicinit>:

void
ioapicinit(void)
{
801029f6:	55                   	push   %ebp
801029f7:	89 e5                	mov    %esp,%ebp
801029f9:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
801029fc:	a1 24 2d 11 80       	mov    0x80112d24,%eax
80102a01:	85 c0                	test   %eax,%eax
80102a03:	75 05                	jne    80102a0a <ioapicinit+0x14>
    return;
80102a05:	e9 99 00 00 00       	jmp    80102aa3 <ioapicinit+0xad>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a0a:	c7 05 f4 2b 11 80 00 	movl   $0xfec00000,0x80112bf4
80102a11:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a14:	6a 01                	push   $0x1
80102a16:	e8 aa ff ff ff       	call   801029c5 <ioapicread>
80102a1b:	83 c4 04             	add    $0x4,%esp
80102a1e:	c1 e8 10             	shr    $0x10,%eax
80102a21:	25 ff 00 00 00       	and    $0xff,%eax
80102a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a29:	6a 00                	push   $0x0
80102a2b:	e8 95 ff ff ff       	call   801029c5 <ioapicread>
80102a30:	83 c4 04             	add    $0x4,%esp
80102a33:	c1 e8 18             	shr    $0x18,%eax
80102a36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a39:	a0 20 2d 11 80       	mov    0x80112d20,%al
80102a3e:	0f b6 c0             	movzbl %al,%eax
80102a41:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a44:	74 10                	je     80102a56 <ioapicinit+0x60>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a46:	83 ec 0c             	sub    $0xc,%esp
80102a49:	68 ac 8a 10 80       	push   $0x80108aac
80102a4e:	e8 b8 d9 ff ff       	call   8010040b <cprintf>
80102a53:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a5d:	eb 3c                	jmp    80102a9b <ioapicinit+0xa5>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a62:	83 c0 20             	add    $0x20,%eax
80102a65:	0d 00 00 01 00       	or     $0x10000,%eax
80102a6a:	89 c2                	mov    %eax,%edx
80102a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a6f:	83 c0 08             	add    $0x8,%eax
80102a72:	01 c0                	add    %eax,%eax
80102a74:	83 ec 08             	sub    $0x8,%esp
80102a77:	52                   	push   %edx
80102a78:	50                   	push   %eax
80102a79:	e8 5e ff ff ff       	call   801029dc <ioapicwrite>
80102a7e:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a84:	83 c0 08             	add    $0x8,%eax
80102a87:	01 c0                	add    %eax,%eax
80102a89:	40                   	inc    %eax
80102a8a:	83 ec 08             	sub    $0x8,%esp
80102a8d:	6a 00                	push   $0x0
80102a8f:	50                   	push   %eax
80102a90:	e8 47 ff ff ff       	call   801029dc <ioapicwrite>
80102a95:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a98:	ff 45 f4             	incl   -0xc(%ebp)
80102a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a9e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102aa1:	7e bc                	jle    80102a5f <ioapicinit+0x69>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102aa3:	c9                   	leave  
80102aa4:	c3                   	ret    

80102aa5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102aa5:	55                   	push   %ebp
80102aa6:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102aa8:	a1 24 2d 11 80       	mov    0x80112d24,%eax
80102aad:	85 c0                	test   %eax,%eax
80102aaf:	75 02                	jne    80102ab3 <ioapicenable+0xe>
    return;
80102ab1:	eb 33                	jmp    80102ae6 <ioapicenable+0x41>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab6:	83 c0 20             	add    $0x20,%eax
80102ab9:	89 c2                	mov    %eax,%edx
80102abb:	8b 45 08             	mov    0x8(%ebp),%eax
80102abe:	83 c0 08             	add    $0x8,%eax
80102ac1:	01 c0                	add    %eax,%eax
80102ac3:	52                   	push   %edx
80102ac4:	50                   	push   %eax
80102ac5:	e8 12 ff ff ff       	call   801029dc <ioapicwrite>
80102aca:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102acd:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ad0:	c1 e0 18             	shl    $0x18,%eax
80102ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80102ad6:	83 c2 08             	add    $0x8,%edx
80102ad9:	01 d2                	add    %edx,%edx
80102adb:	42                   	inc    %edx
80102adc:	50                   	push   %eax
80102add:	52                   	push   %edx
80102ade:	e8 f9 fe ff ff       	call   801029dc <ioapicwrite>
80102ae3:	83 c4 08             	add    $0x8,%esp
}
80102ae6:	c9                   	leave  
80102ae7:	c3                   	ret    

80102ae8 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102ae8:	55                   	push   %ebp
80102ae9:	89 e5                	mov    %esp,%ebp
80102aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80102aee:	05 00 00 00 80       	add    $0x80000000,%eax
80102af3:	5d                   	pop    %ebp
80102af4:	c3                   	ret    

80102af5 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
80102af8:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102afb:	83 ec 08             	sub    $0x8,%esp
80102afe:	68 de 8a 10 80       	push   $0x80108ade
80102b03:	68 00 2c 11 80       	push   $0x80112c00
80102b08:	e8 2e 26 00 00       	call   8010513b <initlock>
80102b0d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b10:	c7 05 34 2c 11 80 00 	movl   $0x0,0x80112c34
80102b17:	00 00 00 
  freerange(vstart, vend);
80102b1a:	83 ec 08             	sub    $0x8,%esp
80102b1d:	ff 75 0c             	pushl  0xc(%ebp)
80102b20:	ff 75 08             	pushl  0x8(%ebp)
80102b23:	e8 28 00 00 00       	call   80102b50 <freerange>
80102b28:	83 c4 10             	add    $0x10,%esp
}
80102b2b:	c9                   	leave  
80102b2c:	c3                   	ret    

80102b2d <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b2d:	55                   	push   %ebp
80102b2e:	89 e5                	mov    %esp,%ebp
80102b30:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b33:	83 ec 08             	sub    $0x8,%esp
80102b36:	ff 75 0c             	pushl  0xc(%ebp)
80102b39:	ff 75 08             	pushl  0x8(%ebp)
80102b3c:	e8 0f 00 00 00       	call   80102b50 <freerange>
80102b41:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b44:	c7 05 34 2c 11 80 01 	movl   $0x1,0x80112c34
80102b4b:	00 00 00 
}
80102b4e:	c9                   	leave  
80102b4f:	c3                   	ret    

80102b50 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b56:	8b 45 08             	mov    0x8(%ebp),%eax
80102b59:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b66:	eb 15                	jmp    80102b7d <freerange+0x2d>
    kfree(p);
80102b68:	83 ec 0c             	sub    $0xc,%esp
80102b6b:	ff 75 f4             	pushl  -0xc(%ebp)
80102b6e:	e8 19 00 00 00       	call   80102b8c <kfree>
80102b73:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b76:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b80:	05 00 10 00 00       	add    $0x1000,%eax
80102b85:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b88:	76 de                	jbe    80102b68 <freerange+0x18>
    kfree(p);
}
80102b8a:	c9                   	leave  
80102b8b:	c3                   	ret    

80102b8c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b8c:	55                   	push   %ebp
80102b8d:	89 e5                	mov    %esp,%ebp
80102b8f:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b92:	8b 45 08             	mov    0x8(%ebp),%eax
80102b95:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b9a:	85 c0                	test   %eax,%eax
80102b9c:	75 1b                	jne    80102bb9 <kfree+0x2d>
80102b9e:	81 7d 08 1c 5c 11 80 	cmpl   $0x80115c1c,0x8(%ebp)
80102ba5:	72 12                	jb     80102bb9 <kfree+0x2d>
80102ba7:	ff 75 08             	pushl  0x8(%ebp)
80102baa:	e8 39 ff ff ff       	call   80102ae8 <v2p>
80102baf:	83 c4 04             	add    $0x4,%esp
80102bb2:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bb7:	76 0d                	jbe    80102bc6 <kfree+0x3a>
    panic("kfree");
80102bb9:	83 ec 0c             	sub    $0xc,%esp
80102bbc:	68 e3 8a 10 80       	push   $0x80108ae3
80102bc1:	e8 03 da ff ff       	call   801005c9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bc6:	83 ec 04             	sub    $0x4,%esp
80102bc9:	68 00 10 00 00       	push   $0x1000
80102bce:	6a 01                	push   $0x1
80102bd0:	ff 75 08             	pushl  0x8(%ebp)
80102bd3:	e8 dc 27 00 00       	call   801053b4 <memset>
80102bd8:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102bdb:	a1 34 2c 11 80       	mov    0x80112c34,%eax
80102be0:	85 c0                	test   %eax,%eax
80102be2:	74 10                	je     80102bf4 <kfree+0x68>
    acquire(&kmem.lock);
80102be4:	83 ec 0c             	sub    $0xc,%esp
80102be7:	68 00 2c 11 80       	push   $0x80112c00
80102bec:	e8 6b 25 00 00       	call   8010515c <acquire>
80102bf1:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102bf4:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102bfa:	8b 15 38 2c 11 80    	mov    0x80112c38,%edx
80102c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c03:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c08:	a3 38 2c 11 80       	mov    %eax,0x80112c38
  if(kmem.use_lock)
80102c0d:	a1 34 2c 11 80       	mov    0x80112c34,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	74 10                	je     80102c26 <kfree+0x9a>
    release(&kmem.lock);
80102c16:	83 ec 0c             	sub    $0xc,%esp
80102c19:	68 00 2c 11 80       	push   $0x80112c00
80102c1e:	e8 9f 25 00 00       	call   801051c2 <release>
80102c23:	83 c4 10             	add    $0x10,%esp
}
80102c26:	c9                   	leave  
80102c27:	c3                   	ret    

80102c28 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c28:	55                   	push   %ebp
80102c29:	89 e5                	mov    %esp,%ebp
80102c2b:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c2e:	a1 34 2c 11 80       	mov    0x80112c34,%eax
80102c33:	85 c0                	test   %eax,%eax
80102c35:	74 10                	je     80102c47 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c37:	83 ec 0c             	sub    $0xc,%esp
80102c3a:	68 00 2c 11 80       	push   $0x80112c00
80102c3f:	e8 18 25 00 00       	call   8010515c <acquire>
80102c44:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102c47:	a1 38 2c 11 80       	mov    0x80112c38,%eax
80102c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c53:	74 0a                	je     80102c5f <kalloc+0x37>
    kmem.freelist = r->next;
80102c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c58:	8b 00                	mov    (%eax),%eax
80102c5a:	a3 38 2c 11 80       	mov    %eax,0x80112c38
  if(kmem.use_lock)
80102c5f:	a1 34 2c 11 80       	mov    0x80112c34,%eax
80102c64:	85 c0                	test   %eax,%eax
80102c66:	74 10                	je     80102c78 <kalloc+0x50>
    release(&kmem.lock);
80102c68:	83 ec 0c             	sub    $0xc,%esp
80102c6b:	68 00 2c 11 80       	push   $0x80112c00
80102c70:	e8 4d 25 00 00       	call   801051c2 <release>
80102c75:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c7b:	c9                   	leave  
80102c7c:	c3                   	ret    

80102c7d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c7d:	55                   	push   %ebp
80102c7e:	89 e5                	mov    %esp,%ebp
80102c80:	83 ec 14             	sub    $0x14,%esp
80102c83:	8b 45 08             	mov    0x8(%ebp),%eax
80102c86:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102c8d:	89 c2                	mov    %eax,%edx
80102c8f:	ec                   	in     (%dx),%al
80102c90:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c93:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102c96:	c9                   	leave  
80102c97:	c3                   	ret    

80102c98 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c98:	55                   	push   %ebp
80102c99:	89 e5                	mov    %esp,%ebp
80102c9b:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c9e:	6a 64                	push   $0x64
80102ca0:	e8 d8 ff ff ff       	call   80102c7d <inb>
80102ca5:	83 c4 04             	add    $0x4,%esp
80102ca8:	0f b6 c0             	movzbl %al,%eax
80102cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cb1:	83 e0 01             	and    $0x1,%eax
80102cb4:	85 c0                	test   %eax,%eax
80102cb6:	75 0a                	jne    80102cc2 <kbdgetc+0x2a>
    return -1;
80102cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cbd:	e9 1f 01 00 00       	jmp    80102de1 <kbdgetc+0x149>
  data = inb(KBDATAP);
80102cc2:	6a 60                	push   $0x60
80102cc4:	e8 b4 ff ff ff       	call   80102c7d <inb>
80102cc9:	83 c4 04             	add    $0x4,%esp
80102ccc:	0f b6 c0             	movzbl %al,%eax
80102ccf:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102cd2:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cd9:	75 17                	jne    80102cf2 <kbdgetc+0x5a>
    shift |= E0ESC;
80102cdb:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102ce0:	83 c8 40             	or     $0x40,%eax
80102ce3:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102ce8:	b8 00 00 00 00       	mov    $0x0,%eax
80102ced:	e9 ef 00 00 00       	jmp    80102de1 <kbdgetc+0x149>
  } else if(data & 0x80){
80102cf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cf5:	25 80 00 00 00       	and    $0x80,%eax
80102cfa:	85 c0                	test   %eax,%eax
80102cfc:	74 44                	je     80102d42 <kbdgetc+0xaa>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102cfe:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d03:	83 e0 40             	and    $0x40,%eax
80102d06:	85 c0                	test   %eax,%eax
80102d08:	75 08                	jne    80102d12 <kbdgetc+0x7a>
80102d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d0d:	83 e0 7f             	and    $0x7f,%eax
80102d10:	eb 03                	jmp    80102d15 <kbdgetc+0x7d>
80102d12:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d1b:	05 20 90 10 80       	add    $0x80109020,%eax
80102d20:	8a 00                	mov    (%eax),%al
80102d22:	83 c8 40             	or     $0x40,%eax
80102d25:	0f b6 c0             	movzbl %al,%eax
80102d28:	f7 d0                	not    %eax
80102d2a:	89 c2                	mov    %eax,%edx
80102d2c:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d31:	21 d0                	and    %edx,%eax
80102d33:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102d38:	b8 00 00 00 00       	mov    $0x0,%eax
80102d3d:	e9 9f 00 00 00       	jmp    80102de1 <kbdgetc+0x149>
  } else if(shift & E0ESC){
80102d42:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d47:	83 e0 40             	and    $0x40,%eax
80102d4a:	85 c0                	test   %eax,%eax
80102d4c:	74 14                	je     80102d62 <kbdgetc+0xca>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d4e:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d55:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d5a:	83 e0 bf             	and    $0xffffffbf,%eax
80102d5d:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102d62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d65:	05 20 90 10 80       	add    $0x80109020,%eax
80102d6a:	8a 00                	mov    (%eax),%al
80102d6c:	0f b6 d0             	movzbl %al,%edx
80102d6f:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d74:	09 d0                	or     %edx,%eax
80102d76:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d7e:	05 20 91 10 80       	add    $0x80109120,%eax
80102d83:	8a 00                	mov    (%eax),%al
80102d85:	0f b6 d0             	movzbl %al,%edx
80102d88:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d8d:	31 d0                	xor    %edx,%eax
80102d8f:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d94:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d99:	83 e0 03             	and    $0x3,%eax
80102d9c:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102da6:	01 d0                	add    %edx,%eax
80102da8:	8a 00                	mov    (%eax),%al
80102daa:	0f b6 c0             	movzbl %al,%eax
80102dad:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102db0:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102db5:	83 e0 08             	and    $0x8,%eax
80102db8:	85 c0                	test   %eax,%eax
80102dba:	74 22                	je     80102dde <kbdgetc+0x146>
    if('a' <= c && c <= 'z')
80102dbc:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102dc0:	76 0c                	jbe    80102dce <kbdgetc+0x136>
80102dc2:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102dc6:	77 06                	ja     80102dce <kbdgetc+0x136>
      c += 'A' - 'a';
80102dc8:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102dcc:	eb 10                	jmp    80102dde <kbdgetc+0x146>
    else if('A' <= c && c <= 'Z')
80102dce:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102dd2:	76 0a                	jbe    80102dde <kbdgetc+0x146>
80102dd4:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102dd8:	77 04                	ja     80102dde <kbdgetc+0x146>
      c += 'a' - 'A';
80102dda:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102de1:	c9                   	leave  
80102de2:	c3                   	ret    

80102de3 <kbdintr>:

void
kbdintr(void)
{
80102de3:	55                   	push   %ebp
80102de4:	89 e5                	mov    %esp,%ebp
80102de6:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102de9:	83 ec 0c             	sub    $0xc,%esp
80102dec:	68 98 2c 10 80       	push   $0x80102c98
80102df1:	e8 4e da ff ff       	call   80100844 <consoleintr>
80102df6:	83 c4 10             	add    $0x10,%esp
}
80102df9:	c9                   	leave  
80102dfa:	c3                   	ret    

80102dfb <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102dfb:	55                   	push   %ebp
80102dfc:	89 e5                	mov    %esp,%ebp
80102dfe:	83 ec 14             	sub    $0x14,%esp
80102e01:	8b 45 08             	mov    0x8(%ebp),%eax
80102e04:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e0b:	89 c2                	mov    %eax,%edx
80102e0d:	ec                   	in     (%dx),%al
80102e0e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e11:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80102e14:	c9                   	leave  
80102e15:	c3                   	ret    

80102e16 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e16:	55                   	push   %ebp
80102e17:	89 e5                	mov    %esp,%ebp
80102e19:	83 ec 08             	sub    $0x8,%esp
80102e1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102e22:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102e26:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e29:	8a 45 f8             	mov    -0x8(%ebp),%al
80102e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102e2f:	ee                   	out    %al,(%dx)
}
80102e30:	c9                   	leave  
80102e31:	c3                   	ret    

80102e32 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e32:	55                   	push   %ebp
80102e33:	89 e5                	mov    %esp,%ebp
80102e35:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e38:	9c                   	pushf  
80102e39:	58                   	pop    %eax
80102e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e40:	c9                   	leave  
80102e41:	c3                   	ret    

80102e42 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e42:	55                   	push   %ebp
80102e43:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e45:	a1 3c 2c 11 80       	mov    0x80112c3c,%eax
80102e4a:	8b 55 08             	mov    0x8(%ebp),%edx
80102e4d:	c1 e2 02             	shl    $0x2,%edx
80102e50:	01 c2                	add    %eax,%edx
80102e52:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e55:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e57:	a1 3c 2c 11 80       	mov    0x80112c3c,%eax
80102e5c:	83 c0 20             	add    $0x20,%eax
80102e5f:	8b 00                	mov    (%eax),%eax
}
80102e61:	5d                   	pop    %ebp
80102e62:	c3                   	ret    

80102e63 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e63:	55                   	push   %ebp
80102e64:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e66:	a1 3c 2c 11 80       	mov    0x80112c3c,%eax
80102e6b:	85 c0                	test   %eax,%eax
80102e6d:	75 05                	jne    80102e74 <lapicinit+0x11>
    return;
80102e6f:	e9 09 01 00 00       	jmp    80102f7d <lapicinit+0x11a>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e74:	68 3f 01 00 00       	push   $0x13f
80102e79:	6a 3c                	push   $0x3c
80102e7b:	e8 c2 ff ff ff       	call   80102e42 <lapicw>
80102e80:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e83:	6a 0b                	push   $0xb
80102e85:	68 f8 00 00 00       	push   $0xf8
80102e8a:	e8 b3 ff ff ff       	call   80102e42 <lapicw>
80102e8f:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e92:	68 20 00 02 00       	push   $0x20020
80102e97:	68 c8 00 00 00       	push   $0xc8
80102e9c:	e8 a1 ff ff ff       	call   80102e42 <lapicw>
80102ea1:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102ea4:	68 80 96 98 00       	push   $0x989680
80102ea9:	68 e0 00 00 00       	push   $0xe0
80102eae:	e8 8f ff ff ff       	call   80102e42 <lapicw>
80102eb3:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102eb6:	68 00 00 01 00       	push   $0x10000
80102ebb:	68 d4 00 00 00       	push   $0xd4
80102ec0:	e8 7d ff ff ff       	call   80102e42 <lapicw>
80102ec5:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102ec8:	68 00 00 01 00       	push   $0x10000
80102ecd:	68 d8 00 00 00       	push   $0xd8
80102ed2:	e8 6b ff ff ff       	call   80102e42 <lapicw>
80102ed7:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102eda:	a1 3c 2c 11 80       	mov    0x80112c3c,%eax
80102edf:	83 c0 30             	add    $0x30,%eax
80102ee2:	8b 00                	mov    (%eax),%eax
80102ee4:	c1 e8 10             	shr    $0x10,%eax
80102ee7:	0f b6 c0             	movzbl %al,%eax
80102eea:	83 f8 03             	cmp    $0x3,%eax
80102eed:	76 12                	jbe    80102f01 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102eef:	68 00 00 01 00       	push   $0x10000
80102ef4:	68 d0 00 00 00       	push   $0xd0
80102ef9:	e8 44 ff ff ff       	call   80102e42 <lapicw>
80102efe:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f01:	6a 33                	push   $0x33
80102f03:	68 dc 00 00 00       	push   $0xdc
80102f08:	e8 35 ff ff ff       	call   80102e42 <lapicw>
80102f0d:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f10:	6a 00                	push   $0x0
80102f12:	68 a0 00 00 00       	push   $0xa0
80102f17:	e8 26 ff ff ff       	call   80102e42 <lapicw>
80102f1c:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f1f:	6a 00                	push   $0x0
80102f21:	68 a0 00 00 00       	push   $0xa0
80102f26:	e8 17 ff ff ff       	call   80102e42 <lapicw>
80102f2b:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f2e:	6a 00                	push   $0x0
80102f30:	6a 2c                	push   $0x2c
80102f32:	e8 0b ff ff ff       	call   80102e42 <lapicw>
80102f37:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f3a:	6a 00                	push   $0x0
80102f3c:	68 c4 00 00 00       	push   $0xc4
80102f41:	e8 fc fe ff ff       	call   80102e42 <lapicw>
80102f46:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f49:	68 00 85 08 00       	push   $0x88500
80102f4e:	68 c0 00 00 00       	push   $0xc0
80102f53:	e8 ea fe ff ff       	call   80102e42 <lapicw>
80102f58:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f5b:	90                   	nop
80102f5c:	a1 3c 2c 11 80       	mov    0x80112c3c,%eax
80102f61:	05 00 03 00 00       	add    $0x300,%eax
80102f66:	8b 00                	mov    (%eax),%eax
80102f68:	25 00 10 00 00       	and    $0x1000,%eax
80102f6d:	85 c0                	test   %eax,%eax
80102f6f:	75 eb                	jne    80102f5c <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f71:	6a 00                	push   $0x0
80102f73:	6a 20                	push   $0x20
80102f75:	e8 c8 fe ff ff       	call   80102e42 <lapicw>
80102f7a:	83 c4 08             	add    $0x8,%esp
}
80102f7d:	c9                   	leave  
80102f7e:	c3                   	ret    

80102f7f <cpunum>:

int
cpunum(void)
{
80102f7f:	55                   	push   %ebp
80102f80:	89 e5                	mov    %esp,%ebp
80102f82:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f85:	e8 a8 fe ff ff       	call   80102e32 <readeflags>
80102f8a:	25 00 02 00 00       	and    $0x200,%eax
80102f8f:	85 c0                	test   %eax,%eax
80102f91:	74 26                	je     80102fb9 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f93:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102f98:	8d 50 01             	lea    0x1(%eax),%edx
80102f9b:	89 15 60 b6 10 80    	mov    %edx,0x8010b660
80102fa1:	85 c0                	test   %eax,%eax
80102fa3:	75 14                	jne    80102fb9 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102fa5:	8b 45 04             	mov    0x4(%ebp),%eax
80102fa8:	83 ec 08             	sub    $0x8,%esp
80102fab:	50                   	push   %eax
80102fac:	68 ec 8a 10 80       	push   $0x80108aec
80102fb1:	e8 55 d4 ff ff       	call   8010040b <cprintf>
80102fb6:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102fb9:	a1 3c 2c 11 80       	mov    0x80112c3c,%eax
80102fbe:	85 c0                	test   %eax,%eax
80102fc0:	74 0f                	je     80102fd1 <cpunum+0x52>
    return lapic[ID]>>24;
80102fc2:	a1 3c 2c 11 80       	mov    0x80112c3c,%eax
80102fc7:	83 c0 20             	add    $0x20,%eax
80102fca:	8b 00                	mov    (%eax),%eax
80102fcc:	c1 e8 18             	shr    $0x18,%eax
80102fcf:	eb 05                	jmp    80102fd6 <cpunum+0x57>
  return 0;
80102fd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fd6:	c9                   	leave  
80102fd7:	c3                   	ret    

80102fd8 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fd8:	55                   	push   %ebp
80102fd9:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fdb:	a1 3c 2c 11 80       	mov    0x80112c3c,%eax
80102fe0:	85 c0                	test   %eax,%eax
80102fe2:	74 0c                	je     80102ff0 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102fe4:	6a 00                	push   $0x0
80102fe6:	6a 2c                	push   $0x2c
80102fe8:	e8 55 fe ff ff       	call   80102e42 <lapicw>
80102fed:	83 c4 08             	add    $0x8,%esp
}
80102ff0:	c9                   	leave  
80102ff1:	c3                   	ret    

80102ff2 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ff2:	55                   	push   %ebp
80102ff3:	89 e5                	mov    %esp,%ebp
}
80102ff5:	5d                   	pop    %ebp
80102ff6:	c3                   	ret    

80102ff7 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ff7:	55                   	push   %ebp
80102ff8:	89 e5                	mov    %esp,%ebp
80102ffa:	83 ec 14             	sub    $0x14,%esp
80102ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80103000:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103003:	6a 0f                	push   $0xf
80103005:	6a 70                	push   $0x70
80103007:	e8 0a fe ff ff       	call   80102e16 <outb>
8010300c:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010300f:	6a 0a                	push   $0xa
80103011:	6a 71                	push   $0x71
80103013:	e8 fe fd ff ff       	call   80102e16 <outb>
80103018:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010301b:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103022:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103025:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010302a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010302d:	8d 50 02             	lea    0x2(%eax),%edx
80103030:	8b 45 0c             	mov    0xc(%ebp),%eax
80103033:	c1 e8 04             	shr    $0x4,%eax
80103036:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103039:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010303d:	c1 e0 18             	shl    $0x18,%eax
80103040:	50                   	push   %eax
80103041:	68 c4 00 00 00       	push   $0xc4
80103046:	e8 f7 fd ff ff       	call   80102e42 <lapicw>
8010304b:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010304e:	68 00 c5 00 00       	push   $0xc500
80103053:	68 c0 00 00 00       	push   $0xc0
80103058:	e8 e5 fd ff ff       	call   80102e42 <lapicw>
8010305d:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103060:	68 c8 00 00 00       	push   $0xc8
80103065:	e8 88 ff ff ff       	call   80102ff2 <microdelay>
8010306a:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010306d:	68 00 85 00 00       	push   $0x8500
80103072:	68 c0 00 00 00       	push   $0xc0
80103077:	e8 c6 fd ff ff       	call   80102e42 <lapicw>
8010307c:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010307f:	6a 64                	push   $0x64
80103081:	e8 6c ff ff ff       	call   80102ff2 <microdelay>
80103086:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103089:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103090:	eb 3c                	jmp    801030ce <lapicstartap+0xd7>
    lapicw(ICRHI, apicid<<24);
80103092:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103096:	c1 e0 18             	shl    $0x18,%eax
80103099:	50                   	push   %eax
8010309a:	68 c4 00 00 00       	push   $0xc4
8010309f:	e8 9e fd ff ff       	call   80102e42 <lapicw>
801030a4:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801030aa:	c1 e8 0c             	shr    $0xc,%eax
801030ad:	80 cc 06             	or     $0x6,%ah
801030b0:	50                   	push   %eax
801030b1:	68 c0 00 00 00       	push   $0xc0
801030b6:	e8 87 fd ff ff       	call   80102e42 <lapicw>
801030bb:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030be:	68 c8 00 00 00       	push   $0xc8
801030c3:	e8 2a ff ff ff       	call   80102ff2 <microdelay>
801030c8:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030cb:	ff 45 fc             	incl   -0x4(%ebp)
801030ce:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030d2:	7e be                	jle    80103092 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030d4:	c9                   	leave  
801030d5:	c3                   	ret    

801030d6 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030d6:	55                   	push   %ebp
801030d7:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801030d9:	8b 45 08             	mov    0x8(%ebp),%eax
801030dc:	0f b6 c0             	movzbl %al,%eax
801030df:	50                   	push   %eax
801030e0:	6a 70                	push   $0x70
801030e2:	e8 2f fd ff ff       	call   80102e16 <outb>
801030e7:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030ea:	68 c8 00 00 00       	push   $0xc8
801030ef:	e8 fe fe ff ff       	call   80102ff2 <microdelay>
801030f4:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801030f7:	6a 71                	push   $0x71
801030f9:	e8 fd fc ff ff       	call   80102dfb <inb>
801030fe:	83 c4 04             	add    $0x4,%esp
80103101:	0f b6 c0             	movzbl %al,%eax
}
80103104:	c9                   	leave  
80103105:	c3                   	ret    

80103106 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103106:	55                   	push   %ebp
80103107:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103109:	6a 00                	push   $0x0
8010310b:	e8 c6 ff ff ff       	call   801030d6 <cmos_read>
80103110:	83 c4 04             	add    $0x4,%esp
80103113:	8b 55 08             	mov    0x8(%ebp),%edx
80103116:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103118:	6a 02                	push   $0x2
8010311a:	e8 b7 ff ff ff       	call   801030d6 <cmos_read>
8010311f:	83 c4 04             	add    $0x4,%esp
80103122:	8b 55 08             	mov    0x8(%ebp),%edx
80103125:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103128:	6a 04                	push   $0x4
8010312a:	e8 a7 ff ff ff       	call   801030d6 <cmos_read>
8010312f:	83 c4 04             	add    $0x4,%esp
80103132:	8b 55 08             	mov    0x8(%ebp),%edx
80103135:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103138:	6a 07                	push   $0x7
8010313a:	e8 97 ff ff ff       	call   801030d6 <cmos_read>
8010313f:	83 c4 04             	add    $0x4,%esp
80103142:	8b 55 08             	mov    0x8(%ebp),%edx
80103145:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103148:	6a 08                	push   $0x8
8010314a:	e8 87 ff ff ff       	call   801030d6 <cmos_read>
8010314f:	83 c4 04             	add    $0x4,%esp
80103152:	8b 55 08             	mov    0x8(%ebp),%edx
80103155:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103158:	6a 09                	push   $0x9
8010315a:	e8 77 ff ff ff       	call   801030d6 <cmos_read>
8010315f:	83 c4 04             	add    $0x4,%esp
80103162:	8b 55 08             	mov    0x8(%ebp),%edx
80103165:	89 42 14             	mov    %eax,0x14(%edx)
}
80103168:	c9                   	leave  
80103169:	c3                   	ret    

8010316a <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010316a:	55                   	push   %ebp
8010316b:	89 e5                	mov    %esp,%ebp
8010316d:	57                   	push   %edi
8010316e:	56                   	push   %esi
8010316f:	53                   	push   %ebx
80103170:	83 ec 4c             	sub    $0x4c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103173:	6a 0b                	push   $0xb
80103175:	e8 5c ff ff ff       	call   801030d6 <cmos_read>
8010317a:	83 c4 04             	add    $0x4,%esp
8010317d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103183:	83 e0 04             	and    $0x4,%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	0f 94 c0             	sete   %al
8010318b:	0f b6 c0             	movzbl %al,%eax
8010318e:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103191:	8d 45 c8             	lea    -0x38(%ebp),%eax
80103194:	50                   	push   %eax
80103195:	e8 6c ff ff ff       	call   80103106 <fill_rtcdate>
8010319a:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010319d:	6a 0a                	push   $0xa
8010319f:	e8 32 ff ff ff       	call   801030d6 <cmos_read>
801031a4:	83 c4 04             	add    $0x4,%esp
801031a7:	25 80 00 00 00       	and    $0x80,%eax
801031ac:	85 c0                	test   %eax,%eax
801031ae:	74 02                	je     801031b2 <cmostime+0x48>
        continue;
801031b0:	eb 32                	jmp    801031e4 <cmostime+0x7a>
    fill_rtcdate(&t2);
801031b2:	8d 45 b0             	lea    -0x50(%ebp),%eax
801031b5:	50                   	push   %eax
801031b6:	e8 4b ff ff ff       	call   80103106 <fill_rtcdate>
801031bb:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031be:	83 ec 04             	sub    $0x4,%esp
801031c1:	6a 18                	push   $0x18
801031c3:	8d 45 b0             	lea    -0x50(%ebp),%eax
801031c6:	50                   	push   %eax
801031c7:	8d 45 c8             	lea    -0x38(%ebp),%eax
801031ca:	50                   	push   %eax
801031cb:	e8 4b 22 00 00       	call   8010541b <memcmp>
801031d0:	83 c4 10             	add    $0x10,%esp
801031d3:	85 c0                	test   %eax,%eax
801031d5:	75 0d                	jne    801031e4 <cmostime+0x7a>
      break;
801031d7:	90                   	nop
  }

  // convert
  if (bcd) {
801031d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801031dc:	0f 84 ac 00 00 00    	je     8010328e <cmostime+0x124>
801031e2:	eb 02                	jmp    801031e6 <cmostime+0x7c>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031e4:	eb ab                	jmp    80103191 <cmostime+0x27>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031e9:	c1 e8 04             	shr    $0x4,%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	89 d0                	mov    %edx,%eax
801031f0:	c1 e0 02             	shl    $0x2,%eax
801031f3:	01 d0                	add    %edx,%eax
801031f5:	01 c0                	add    %eax,%eax
801031f7:	8b 55 c8             	mov    -0x38(%ebp),%edx
801031fa:	83 e2 0f             	and    $0xf,%edx
801031fd:	01 d0                	add    %edx,%eax
801031ff:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
80103202:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103205:	c1 e8 04             	shr    $0x4,%eax
80103208:	89 c2                	mov    %eax,%edx
8010320a:	89 d0                	mov    %edx,%eax
8010320c:	c1 e0 02             	shl    $0x2,%eax
8010320f:	01 d0                	add    %edx,%eax
80103211:	01 c0                	add    %eax,%eax
80103213:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103216:	83 e2 0f             	and    $0xf,%edx
80103219:	01 d0                	add    %edx,%eax
8010321b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
8010321e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80103221:	c1 e8 04             	shr    $0x4,%eax
80103224:	89 c2                	mov    %eax,%edx
80103226:	89 d0                	mov    %edx,%eax
80103228:	c1 e0 02             	shl    $0x2,%eax
8010322b:	01 d0                	add    %edx,%eax
8010322d:	01 c0                	add    %eax,%eax
8010322f:	8b 55 d0             	mov    -0x30(%ebp),%edx
80103232:	83 e2 0f             	and    $0xf,%edx
80103235:	01 d0                	add    %edx,%eax
80103237:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
8010323a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010323d:	c1 e8 04             	shr    $0x4,%eax
80103240:	89 c2                	mov    %eax,%edx
80103242:	89 d0                	mov    %edx,%eax
80103244:	c1 e0 02             	shl    $0x2,%eax
80103247:	01 d0                	add    %edx,%eax
80103249:	01 c0                	add    %eax,%eax
8010324b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010324e:	83 e2 0f             	and    $0xf,%edx
80103251:	01 d0                	add    %edx,%eax
80103253:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
80103256:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103259:	c1 e8 04             	shr    $0x4,%eax
8010325c:	89 c2                	mov    %eax,%edx
8010325e:	89 d0                	mov    %edx,%eax
80103260:	c1 e0 02             	shl    $0x2,%eax
80103263:	01 d0                	add    %edx,%eax
80103265:	01 c0                	add    %eax,%eax
80103267:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010326a:	83 e2 0f             	and    $0xf,%edx
8010326d:	01 d0                	add    %edx,%eax
8010326f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
80103272:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103275:	c1 e8 04             	shr    $0x4,%eax
80103278:	89 c2                	mov    %eax,%edx
8010327a:	89 d0                	mov    %edx,%eax
8010327c:	c1 e0 02             	shl    $0x2,%eax
8010327f:	01 d0                	add    %edx,%eax
80103281:	01 c0                	add    %eax,%eax
80103283:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103286:	83 e2 0f             	and    $0xf,%edx
80103289:	01 d0                	add    %edx,%eax
8010328b:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
8010328e:	8b 45 08             	mov    0x8(%ebp),%eax
80103291:	89 c2                	mov    %eax,%edx
80103293:	8d 5d c8             	lea    -0x38(%ebp),%ebx
80103296:	b8 06 00 00 00       	mov    $0x6,%eax
8010329b:	89 d7                	mov    %edx,%edi
8010329d:	89 de                	mov    %ebx,%esi
8010329f:	89 c1                	mov    %eax,%ecx
801032a1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801032a3:	8b 45 08             	mov    0x8(%ebp),%eax
801032a6:	8b 40 14             	mov    0x14(%eax),%eax
801032a9:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032af:	8b 45 08             	mov    0x8(%ebp),%eax
801032b2:	89 50 14             	mov    %edx,0x14(%eax)
}
801032b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032b8:	5b                   	pop    %ebx
801032b9:	5e                   	pop    %esi
801032ba:	5f                   	pop    %edi
801032bb:	5d                   	pop    %ebp
801032bc:	c3                   	ret    

801032bd <unixtime>:

// This is not the "real" UNIX time as it makes many
// simplifying assumptions -- no leap years, months
// that are all the same length (!)
unsigned long unixtime(void) {
801032bd:	55                   	push   %ebp
801032be:	89 e5                	mov    %esp,%ebp
801032c0:	53                   	push   %ebx
801032c1:	83 ec 24             	sub    $0x24,%esp
  struct rtcdate t;
  cmostime(&t);
801032c4:	83 ec 0c             	sub    $0xc,%esp
801032c7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801032ca:	50                   	push   %eax
801032cb:	e8 9a fe ff ff       	call   8010316a <cmostime>
801032d0:	83 c4 10             	add    $0x10,%esp
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
801032d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032d6:	89 d0                	mov    %edx,%eax
801032d8:	c1 e0 09             	shl    $0x9,%eax
801032db:	01 d0                	add    %edx,%eax
801032dd:	c1 e0 02             	shl    $0x2,%eax
801032e0:	01 d0                	add    %edx,%eax
801032e2:	c1 e0 03             	shl    $0x3,%eax
801032e5:	01 d0                	add    %edx,%eax
801032e7:	89 c2                	mov    %eax,%edx
801032e9:	c1 e2 04             	shl    $0x4,%edx
801032ec:	29 c2                	sub    %eax,%edx
801032ee:	89 d0                	mov    %edx,%eax
801032f0:	c1 e0 07             	shl    $0x7,%eax
801032f3:	89 c2                	mov    %eax,%edx
801032f5:	89 d1                	mov    %edx,%ecx
         (t.month * 30 * 24 * 60 * 60) +
801032f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801032fa:	89 d0                	mov    %edx,%eax
801032fc:	c1 e0 06             	shl    $0x6,%eax
801032ff:	29 d0                	sub    %edx,%eax
80103301:	c1 e0 02             	shl    $0x2,%eax
80103304:	01 d0                	add    %edx,%eax
80103306:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
8010330d:	01 d8                	add    %ebx,%eax
8010330f:	01 c0                	add    %eax,%eax
80103311:	01 d0                	add    %edx,%eax
80103313:	c1 e0 02             	shl    $0x2,%eax
80103316:	01 d0                	add    %edx,%eax
80103318:	c1 e0 08             	shl    $0x8,%eax
// simplifying assumptions -- no leap years, months
// that are all the same length (!)
unsigned long unixtime(void) {
  struct rtcdate t;
  cmostime(&t);
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
8010331b:	01 c1                	add    %eax,%ecx
         (t.month * 30 * 24 * 60 * 60) +
         (t.day * 24 * 60 * 60) +
8010331d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103320:	89 d0                	mov    %edx,%eax
80103322:	c1 e0 02             	shl    $0x2,%eax
80103325:	01 d0                	add    %edx,%eax
80103327:	01 c0                	add    %eax,%eax
80103329:	01 d0                	add    %edx,%eax
8010332b:	c1 e0 02             	shl    $0x2,%eax
8010332e:	01 d0                	add    %edx,%eax
80103330:	89 c2                	mov    %eax,%edx
80103332:	c1 e2 04             	shl    $0x4,%edx
80103335:	29 c2                	sub    %eax,%edx
80103337:	89 d0                	mov    %edx,%eax
80103339:	c1 e0 07             	shl    $0x7,%eax
8010333c:	89 c2                	mov    %eax,%edx
8010333e:	89 d0                	mov    %edx,%eax
// that are all the same length (!)
unsigned long unixtime(void) {
  struct rtcdate t;
  cmostime(&t);
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
         (t.month * 30 * 24 * 60 * 60) +
80103340:	01 c1                	add    %eax,%ecx
         (t.day * 24 * 60 * 60) +
         (t.hour * 60 * 60) +
80103342:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103345:	89 d0                	mov    %edx,%eax
80103347:	01 c0                	add    %eax,%eax
80103349:	01 d0                	add    %edx,%eax
8010334b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103352:	01 d0                	add    %edx,%eax
80103354:	89 c2                	mov    %eax,%edx
80103356:	c1 e2 04             	shl    $0x4,%edx
80103359:	29 c2                	sub    %eax,%edx
8010335b:	89 d0                	mov    %edx,%eax
8010335d:	c1 e0 04             	shl    $0x4,%eax
80103360:	89 c2                	mov    %eax,%edx
80103362:	89 d0                	mov    %edx,%eax
unsigned long unixtime(void) {
  struct rtcdate t;
  cmostime(&t);
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
         (t.month * 30 * 24 * 60 * 60) +
         (t.day * 24 * 60 * 60) +
80103364:	01 c1                	add    %eax,%ecx
         (t.hour * 60 * 60) +
         (t.minute * 60) +
80103366:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103369:	89 d0                	mov    %edx,%eax
8010336b:	01 c0                	add    %eax,%eax
8010336d:	01 d0                	add    %edx,%eax
8010336f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80103376:	01 d0                	add    %edx,%eax
80103378:	c1 e0 02             	shl    $0x2,%eax
  struct rtcdate t;
  cmostime(&t);
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
         (t.month * 30 * 24 * 60 * 60) +
         (t.day * 24 * 60 * 60) +
         (t.hour * 60 * 60) +
8010337b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
         (t.minute * 60) +
         (t.second);
8010337e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  cmostime(&t);
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
         (t.month * 30 * 24 * 60 * 60) +
         (t.day * 24 * 60 * 60) +
         (t.hour * 60 * 60) +
         (t.minute * 60) +
80103381:	01 d0                	add    %edx,%eax
// simplifying assumptions -- no leap years, months
// that are all the same length (!)
unsigned long unixtime(void) {
  struct rtcdate t;
  cmostime(&t);
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
80103383:	2d 00 4f fe 76       	sub    $0x76fe4f00,%eax
         (t.month * 30 * 24 * 60 * 60) +
         (t.day * 24 * 60 * 60) +
         (t.hour * 60 * 60) +
         (t.minute * 60) +
         (t.second);
}
80103388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010338b:	c9                   	leave  
8010338c:	c3                   	ret    

8010338d <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010338d:	55                   	push   %ebp
8010338e:	89 e5                	mov    %esp,%ebp
80103390:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103393:	83 ec 08             	sub    $0x8,%esp
80103396:	68 18 8b 10 80       	push   $0x80108b18
8010339b:	68 40 2c 11 80       	push   $0x80112c40
801033a0:	e8 96 1d 00 00       	call   8010513b <initlock>
801033a5:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801033a8:	83 ec 08             	sub    $0x8,%esp
801033ab:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033ae:	50                   	push   %eax
801033af:	ff 75 08             	pushl  0x8(%ebp)
801033b2:	e8 d0 df ff ff       	call   80101387 <readsb>
801033b7:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801033ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033bd:	a3 74 2c 11 80       	mov    %eax,0x80112c74
  log.size = sb.nlog;
801033c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033c5:	a3 78 2c 11 80       	mov    %eax,0x80112c78
  log.dev = dev;
801033ca:	8b 45 08             	mov    0x8(%ebp),%eax
801033cd:	a3 84 2c 11 80       	mov    %eax,0x80112c84
  recover_from_log();
801033d2:	e8 a9 01 00 00       	call   80103580 <recover_from_log>
}
801033d7:	c9                   	leave  
801033d8:	c3                   	ret    

801033d9 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801033d9:	55                   	push   %ebp
801033da:	89 e5                	mov    %esp,%ebp
801033dc:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033e6:	e9 92 00 00 00       	jmp    8010347d <install_trans+0xa4>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033eb:	8b 15 74 2c 11 80    	mov    0x80112c74,%edx
801033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033f4:	01 d0                	add    %edx,%eax
801033f6:	40                   	inc    %eax
801033f7:	89 c2                	mov    %eax,%edx
801033f9:	a1 84 2c 11 80       	mov    0x80112c84,%eax
801033fe:	83 ec 08             	sub    $0x8,%esp
80103401:	52                   	push   %edx
80103402:	50                   	push   %eax
80103403:	e8 ac cd ff ff       	call   801001b4 <bread>
80103408:	83 c4 10             	add    $0x10,%esp
8010340b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103411:	83 c0 10             	add    $0x10,%eax
80103414:	8b 04 85 4c 2c 11 80 	mov    -0x7feed3b4(,%eax,4),%eax
8010341b:	89 c2                	mov    %eax,%edx
8010341d:	a1 84 2c 11 80       	mov    0x80112c84,%eax
80103422:	83 ec 08             	sub    $0x8,%esp
80103425:	52                   	push   %edx
80103426:	50                   	push   %eax
80103427:	e8 88 cd ff ff       	call   801001b4 <bread>
8010342c:	83 c4 10             	add    $0x10,%esp
8010342f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103432:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103435:	8d 50 18             	lea    0x18(%eax),%edx
80103438:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010343b:	83 c0 18             	add    $0x18,%eax
8010343e:	83 ec 04             	sub    $0x4,%esp
80103441:	68 00 02 00 00       	push   $0x200
80103446:	52                   	push   %edx
80103447:	50                   	push   %eax
80103448:	e8 20 20 00 00       	call   8010546d <memmove>
8010344d:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	ff 75 ec             	pushl  -0x14(%ebp)
80103456:	e8 92 cd ff ff       	call   801001ed <bwrite>
8010345b:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010345e:	83 ec 0c             	sub    $0xc,%esp
80103461:	ff 75 f0             	pushl  -0x10(%ebp)
80103464:	e8 c2 cd ff ff       	call   8010022b <brelse>
80103469:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010346c:	83 ec 0c             	sub    $0xc,%esp
8010346f:	ff 75 ec             	pushl  -0x14(%ebp)
80103472:	e8 b4 cd ff ff       	call   8010022b <brelse>
80103477:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010347a:	ff 45 f4             	incl   -0xc(%ebp)
8010347d:	a1 88 2c 11 80       	mov    0x80112c88,%eax
80103482:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103485:	0f 8f 60 ff ff ff    	jg     801033eb <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010348b:	c9                   	leave  
8010348c:	c3                   	ret    

8010348d <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010348d:	55                   	push   %ebp
8010348e:	89 e5                	mov    %esp,%ebp
80103490:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103493:	a1 74 2c 11 80       	mov    0x80112c74,%eax
80103498:	89 c2                	mov    %eax,%edx
8010349a:	a1 84 2c 11 80       	mov    0x80112c84,%eax
8010349f:	83 ec 08             	sub    $0x8,%esp
801034a2:	52                   	push   %edx
801034a3:	50                   	push   %eax
801034a4:	e8 0b cd ff ff       	call   801001b4 <bread>
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b2:	83 c0 18             	add    $0x18,%eax
801034b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801034b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034bb:	8b 00                	mov    (%eax),%eax
801034bd:	a3 88 2c 11 80       	mov    %eax,0x80112c88
  for (i = 0; i < log.lh.n; i++) {
801034c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034c9:	eb 1a                	jmp    801034e5 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
801034cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034d1:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801034d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034d8:	83 c2 10             	add    $0x10,%edx
801034db:	89 04 95 4c 2c 11 80 	mov    %eax,-0x7feed3b4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801034e2:	ff 45 f4             	incl   -0xc(%ebp)
801034e5:	a1 88 2c 11 80       	mov    0x80112c88,%eax
801034ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034ed:	7f dc                	jg     801034cb <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	ff 75 f0             	pushl  -0x10(%ebp)
801034f5:	e8 31 cd ff ff       	call   8010022b <brelse>
801034fa:	83 c4 10             	add    $0x10,%esp
}
801034fd:	c9                   	leave  
801034fe:	c3                   	ret    

801034ff <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034ff:	55                   	push   %ebp
80103500:	89 e5                	mov    %esp,%ebp
80103502:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103505:	a1 74 2c 11 80       	mov    0x80112c74,%eax
8010350a:	89 c2                	mov    %eax,%edx
8010350c:	a1 84 2c 11 80       	mov    0x80112c84,%eax
80103511:	83 ec 08             	sub    $0x8,%esp
80103514:	52                   	push   %edx
80103515:	50                   	push   %eax
80103516:	e8 99 cc ff ff       	call   801001b4 <bread>
8010351b:	83 c4 10             	add    $0x10,%esp
8010351e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103521:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103524:	83 c0 18             	add    $0x18,%eax
80103527:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010352a:	8b 15 88 2c 11 80    	mov    0x80112c88,%edx
80103530:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103533:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103535:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010353c:	eb 1a                	jmp    80103558 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
8010353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103541:	83 c0 10             	add    $0x10,%eax
80103544:	8b 0c 85 4c 2c 11 80 	mov    -0x7feed3b4(,%eax,4),%ecx
8010354b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010354e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103551:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103555:	ff 45 f4             	incl   -0xc(%ebp)
80103558:	a1 88 2c 11 80       	mov    0x80112c88,%eax
8010355d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103560:	7f dc                	jg     8010353e <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103562:	83 ec 0c             	sub    $0xc,%esp
80103565:	ff 75 f0             	pushl  -0x10(%ebp)
80103568:	e8 80 cc ff ff       	call   801001ed <bwrite>
8010356d:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	ff 75 f0             	pushl  -0x10(%ebp)
80103576:	e8 b0 cc ff ff       	call   8010022b <brelse>
8010357b:	83 c4 10             	add    $0x10,%esp
}
8010357e:	c9                   	leave  
8010357f:	c3                   	ret    

80103580 <recover_from_log>:

static void
recover_from_log(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103586:	e8 02 ff ff ff       	call   8010348d <read_head>
  install_trans(); // if committed, copy from log to disk
8010358b:	e8 49 fe ff ff       	call   801033d9 <install_trans>
  log.lh.n = 0;
80103590:	c7 05 88 2c 11 80 00 	movl   $0x0,0x80112c88
80103597:	00 00 00 
  write_head(); // clear the log
8010359a:	e8 60 ff ff ff       	call   801034ff <write_head>
}
8010359f:	c9                   	leave  
801035a0:	c3                   	ret    

801035a1 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035a1:	55                   	push   %ebp
801035a2:	89 e5                	mov    %esp,%ebp
801035a4:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035a7:	83 ec 0c             	sub    $0xc,%esp
801035aa:	68 40 2c 11 80       	push   $0x80112c40
801035af:	e8 a8 1b 00 00       	call   8010515c <acquire>
801035b4:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801035b7:	a1 80 2c 11 80       	mov    0x80112c80,%eax
801035bc:	85 c0                	test   %eax,%eax
801035be:	74 17                	je     801035d7 <begin_op+0x36>
      sleep(&log, &log.lock);
801035c0:	83 ec 08             	sub    $0x8,%esp
801035c3:	68 40 2c 11 80       	push   $0x80112c40
801035c8:	68 40 2c 11 80       	push   $0x80112c40
801035cd:	e8 9d 18 00 00       	call   80104e6f <sleep>
801035d2:	83 c4 10             	add    $0x10,%esp
801035d5:	eb 52                	jmp    80103629 <begin_op+0x88>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035d7:	8b 15 88 2c 11 80    	mov    0x80112c88,%edx
801035dd:	a1 7c 2c 11 80       	mov    0x80112c7c,%eax
801035e2:	8d 48 01             	lea    0x1(%eax),%ecx
801035e5:	89 c8                	mov    %ecx,%eax
801035e7:	c1 e0 02             	shl    $0x2,%eax
801035ea:	01 c8                	add    %ecx,%eax
801035ec:	01 c0                	add    %eax,%eax
801035ee:	01 d0                	add    %edx,%eax
801035f0:	83 f8 1e             	cmp    $0x1e,%eax
801035f3:	7e 17                	jle    8010360c <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035f5:	83 ec 08             	sub    $0x8,%esp
801035f8:	68 40 2c 11 80       	push   $0x80112c40
801035fd:	68 40 2c 11 80       	push   $0x80112c40
80103602:	e8 68 18 00 00       	call   80104e6f <sleep>
80103607:	83 c4 10             	add    $0x10,%esp
8010360a:	eb 1d                	jmp    80103629 <begin_op+0x88>
    } else {
      log.outstanding += 1;
8010360c:	a1 7c 2c 11 80       	mov    0x80112c7c,%eax
80103611:	40                   	inc    %eax
80103612:	a3 7c 2c 11 80       	mov    %eax,0x80112c7c
      release(&log.lock);
80103617:	83 ec 0c             	sub    $0xc,%esp
8010361a:	68 40 2c 11 80       	push   $0x80112c40
8010361f:	e8 9e 1b 00 00       	call   801051c2 <release>
80103624:	83 c4 10             	add    $0x10,%esp
      break;
80103627:	eb 02                	jmp    8010362b <begin_op+0x8a>
    }
  }
80103629:	eb 8c                	jmp    801035b7 <begin_op+0x16>
}
8010362b:	c9                   	leave  
8010362c:	c3                   	ret    

8010362d <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010362d:	55                   	push   %ebp
8010362e:	89 e5                	mov    %esp,%ebp
80103630:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103633:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010363a:	83 ec 0c             	sub    $0xc,%esp
8010363d:	68 40 2c 11 80       	push   $0x80112c40
80103642:	e8 15 1b 00 00       	call   8010515c <acquire>
80103647:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010364a:	a1 7c 2c 11 80       	mov    0x80112c7c,%eax
8010364f:	48                   	dec    %eax
80103650:	a3 7c 2c 11 80       	mov    %eax,0x80112c7c
  if(log.committing)
80103655:	a1 80 2c 11 80       	mov    0x80112c80,%eax
8010365a:	85 c0                	test   %eax,%eax
8010365c:	74 0d                	je     8010366b <end_op+0x3e>
    panic("log.committing");
8010365e:	83 ec 0c             	sub    $0xc,%esp
80103661:	68 1c 8b 10 80       	push   $0x80108b1c
80103666:	e8 5e cf ff ff       	call   801005c9 <panic>
  if(log.outstanding == 0){
8010366b:	a1 7c 2c 11 80       	mov    0x80112c7c,%eax
80103670:	85 c0                	test   %eax,%eax
80103672:	75 13                	jne    80103687 <end_op+0x5a>
    do_commit = 1;
80103674:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010367b:	c7 05 80 2c 11 80 01 	movl   $0x1,0x80112c80
80103682:	00 00 00 
80103685:	eb 10                	jmp    80103697 <end_op+0x6a>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103687:	83 ec 0c             	sub    $0xc,%esp
8010368a:	68 40 2c 11 80       	push   $0x80112c40
8010368f:	e8 c4 18 00 00       	call   80104f58 <wakeup>
80103694:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103697:	83 ec 0c             	sub    $0xc,%esp
8010369a:	68 40 2c 11 80       	push   $0x80112c40
8010369f:	e8 1e 1b 00 00       	call   801051c2 <release>
801036a4:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036ab:	74 3f                	je     801036ec <end_op+0xbf>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801036ad:	e8 f0 00 00 00       	call   801037a2 <commit>
    acquire(&log.lock);
801036b2:	83 ec 0c             	sub    $0xc,%esp
801036b5:	68 40 2c 11 80       	push   $0x80112c40
801036ba:	e8 9d 1a 00 00       	call   8010515c <acquire>
801036bf:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801036c2:	c7 05 80 2c 11 80 00 	movl   $0x0,0x80112c80
801036c9:	00 00 00 
    wakeup(&log);
801036cc:	83 ec 0c             	sub    $0xc,%esp
801036cf:	68 40 2c 11 80       	push   $0x80112c40
801036d4:	e8 7f 18 00 00       	call   80104f58 <wakeup>
801036d9:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801036dc:	83 ec 0c             	sub    $0xc,%esp
801036df:	68 40 2c 11 80       	push   $0x80112c40
801036e4:	e8 d9 1a 00 00       	call   801051c2 <release>
801036e9:	83 c4 10             	add    $0x10,%esp
  }
}
801036ec:	c9                   	leave  
801036ed:	c3                   	ret    

801036ee <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801036ee:	55                   	push   %ebp
801036ef:	89 e5                	mov    %esp,%ebp
801036f1:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036fb:	e9 92 00 00 00       	jmp    80103792 <write_log+0xa4>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103700:	8b 15 74 2c 11 80    	mov    0x80112c74,%edx
80103706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103709:	01 d0                	add    %edx,%eax
8010370b:	40                   	inc    %eax
8010370c:	89 c2                	mov    %eax,%edx
8010370e:	a1 84 2c 11 80       	mov    0x80112c84,%eax
80103713:	83 ec 08             	sub    $0x8,%esp
80103716:	52                   	push   %edx
80103717:	50                   	push   %eax
80103718:	e8 97 ca ff ff       	call   801001b4 <bread>
8010371d:	83 c4 10             	add    $0x10,%esp
80103720:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103726:	83 c0 10             	add    $0x10,%eax
80103729:	8b 04 85 4c 2c 11 80 	mov    -0x7feed3b4(,%eax,4),%eax
80103730:	89 c2                	mov    %eax,%edx
80103732:	a1 84 2c 11 80       	mov    0x80112c84,%eax
80103737:	83 ec 08             	sub    $0x8,%esp
8010373a:	52                   	push   %edx
8010373b:	50                   	push   %eax
8010373c:	e8 73 ca ff ff       	call   801001b4 <bread>
80103741:	83 c4 10             	add    $0x10,%esp
80103744:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103747:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010374a:	8d 50 18             	lea    0x18(%eax),%edx
8010374d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103750:	83 c0 18             	add    $0x18,%eax
80103753:	83 ec 04             	sub    $0x4,%esp
80103756:	68 00 02 00 00       	push   $0x200
8010375b:	52                   	push   %edx
8010375c:	50                   	push   %eax
8010375d:	e8 0b 1d 00 00       	call   8010546d <memmove>
80103762:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103765:	83 ec 0c             	sub    $0xc,%esp
80103768:	ff 75 f0             	pushl  -0x10(%ebp)
8010376b:	e8 7d ca ff ff       	call   801001ed <bwrite>
80103770:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103773:	83 ec 0c             	sub    $0xc,%esp
80103776:	ff 75 ec             	pushl  -0x14(%ebp)
80103779:	e8 ad ca ff ff       	call   8010022b <brelse>
8010377e:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103781:	83 ec 0c             	sub    $0xc,%esp
80103784:	ff 75 f0             	pushl  -0x10(%ebp)
80103787:	e8 9f ca ff ff       	call   8010022b <brelse>
8010378c:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010378f:	ff 45 f4             	incl   -0xc(%ebp)
80103792:	a1 88 2c 11 80       	mov    0x80112c88,%eax
80103797:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010379a:	0f 8f 60 ff ff ff    	jg     80103700 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801037a0:	c9                   	leave  
801037a1:	c3                   	ret    

801037a2 <commit>:

static void
commit()
{
801037a2:	55                   	push   %ebp
801037a3:	89 e5                	mov    %esp,%ebp
801037a5:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801037a8:	a1 88 2c 11 80       	mov    0x80112c88,%eax
801037ad:	85 c0                	test   %eax,%eax
801037af:	7e 1e                	jle    801037cf <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801037b1:	e8 38 ff ff ff       	call   801036ee <write_log>
    write_head();    // Write header to disk -- the real commit
801037b6:	e8 44 fd ff ff       	call   801034ff <write_head>
    install_trans(); // Now install writes to home locations
801037bb:	e8 19 fc ff ff       	call   801033d9 <install_trans>
    log.lh.n = 0; 
801037c0:	c7 05 88 2c 11 80 00 	movl   $0x0,0x80112c88
801037c7:	00 00 00 
    write_head();    // Erase the transaction from the log
801037ca:	e8 30 fd ff ff       	call   801034ff <write_head>
  }
}
801037cf:	c9                   	leave  
801037d0:	c3                   	ret    

801037d1 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037d1:	55                   	push   %ebp
801037d2:	89 e5                	mov    %esp,%ebp
801037d4:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037d7:	a1 88 2c 11 80       	mov    0x80112c88,%eax
801037dc:	83 f8 1d             	cmp    $0x1d,%eax
801037df:	7f 10                	jg     801037f1 <log_write+0x20>
801037e1:	a1 88 2c 11 80       	mov    0x80112c88,%eax
801037e6:	8b 15 78 2c 11 80    	mov    0x80112c78,%edx
801037ec:	4a                   	dec    %edx
801037ed:	39 d0                	cmp    %edx,%eax
801037ef:	7c 0d                	jl     801037fe <log_write+0x2d>
    panic("too big a transaction");
801037f1:	83 ec 0c             	sub    $0xc,%esp
801037f4:	68 2b 8b 10 80       	push   $0x80108b2b
801037f9:	e8 cb cd ff ff       	call   801005c9 <panic>
  if (log.outstanding < 1)
801037fe:	a1 7c 2c 11 80       	mov    0x80112c7c,%eax
80103803:	85 c0                	test   %eax,%eax
80103805:	7f 0d                	jg     80103814 <log_write+0x43>
    panic("log_write outside of trans");
80103807:	83 ec 0c             	sub    $0xc,%esp
8010380a:	68 41 8b 10 80       	push   $0x80108b41
8010380f:	e8 b5 cd ff ff       	call   801005c9 <panic>

  acquire(&log.lock);
80103814:	83 ec 0c             	sub    $0xc,%esp
80103817:	68 40 2c 11 80       	push   $0x80112c40
8010381c:	e8 3b 19 00 00       	call   8010515c <acquire>
80103821:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103824:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010382b:	eb 1e                	jmp    8010384b <log_write+0x7a>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010382d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103830:	83 c0 10             	add    $0x10,%eax
80103833:	8b 04 85 4c 2c 11 80 	mov    -0x7feed3b4(,%eax,4),%eax
8010383a:	89 c2                	mov    %eax,%edx
8010383c:	8b 45 08             	mov    0x8(%ebp),%eax
8010383f:	8b 40 08             	mov    0x8(%eax),%eax
80103842:	39 c2                	cmp    %eax,%edx
80103844:	75 02                	jne    80103848 <log_write+0x77>
      break;
80103846:	eb 0d                	jmp    80103855 <log_write+0x84>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103848:	ff 45 f4             	incl   -0xc(%ebp)
8010384b:	a1 88 2c 11 80       	mov    0x80112c88,%eax
80103850:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103853:	7f d8                	jg     8010382d <log_write+0x5c>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	8b 40 08             	mov    0x8(%eax),%eax
8010385b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010385e:	83 c2 10             	add    $0x10,%edx
80103861:	89 04 95 4c 2c 11 80 	mov    %eax,-0x7feed3b4(,%edx,4)
  if (i == log.lh.n)
80103868:	a1 88 2c 11 80       	mov    0x80112c88,%eax
8010386d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103870:	75 0b                	jne    8010387d <log_write+0xac>
    log.lh.n++;
80103872:	a1 88 2c 11 80       	mov    0x80112c88,%eax
80103877:	40                   	inc    %eax
80103878:	a3 88 2c 11 80       	mov    %eax,0x80112c88
  b->flags |= B_DIRTY; // prevent eviction
8010387d:	8b 45 08             	mov    0x8(%ebp),%eax
80103880:	8b 00                	mov    (%eax),%eax
80103882:	83 c8 04             	or     $0x4,%eax
80103885:	89 c2                	mov    %eax,%edx
80103887:	8b 45 08             	mov    0x8(%ebp),%eax
8010388a:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010388c:	83 ec 0c             	sub    $0xc,%esp
8010388f:	68 40 2c 11 80       	push   $0x80112c40
80103894:	e8 29 19 00 00       	call   801051c2 <release>
80103899:	83 c4 10             	add    $0x10,%esp
}
8010389c:	c9                   	leave  
8010389d:	c3                   	ret    

8010389e <v2p>:
8010389e:	55                   	push   %ebp
8010389f:	89 e5                	mov    %esp,%ebp
801038a1:	8b 45 08             	mov    0x8(%ebp),%eax
801038a4:	05 00 00 00 80       	add    $0x80000000,%eax
801038a9:	5d                   	pop    %ebp
801038aa:	c3                   	ret    

801038ab <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801038ab:	55                   	push   %ebp
801038ac:	89 e5                	mov    %esp,%ebp
801038ae:	8b 45 08             	mov    0x8(%ebp),%eax
801038b1:	05 00 00 00 80       	add    $0x80000000,%eax
801038b6:	5d                   	pop    %ebp
801038b7:	c3                   	ret    

801038b8 <xchg>:
    return ret;
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801038b8:	55                   	push   %ebp
801038b9:	89 e5                	mov    %esp,%ebp
801038bb:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038be:	8b 55 08             	mov    0x8(%ebp),%edx
801038c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801038c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801038c7:	f0 87 02             	lock xchg %eax,(%edx)
801038ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801038cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801038d0:	c9                   	leave  
801038d1:	c3                   	ret    

801038d2 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801038d2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038d6:	83 e4 f0             	and    $0xfffffff0,%esp
801038d9:	ff 71 fc             	pushl  -0x4(%ecx)
801038dc:	55                   	push   %ebp
801038dd:	89 e5                	mov    %esp,%ebp
801038df:	51                   	push   %ecx
801038e0:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038e3:	83 ec 08             	sub    $0x8,%esp
801038e6:	68 00 00 40 80       	push   $0x80400000
801038eb:	68 1c 5c 11 80       	push   $0x80115c1c
801038f0:	e8 00 f2 ff ff       	call   80102af5 <kinit1>
801038f5:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801038f8:	e8 45 48 00 00       	call   80108142 <kvmalloc>
  mpinit();        // collect info about this machine
801038fd:	e8 8b 04 00 00       	call   80103d8d <mpinit>
  lapicinit();
80103902:	e8 5c f5 ff ff       	call   80102e63 <lapicinit>
  seginit();       // set up segments
80103907:	e8 ff 41 00 00       	call   80107b0b <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010390c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103912:	8a 00                	mov    (%eax),%al
80103914:	0f b6 c0             	movzbl %al,%eax
80103917:	83 ec 08             	sub    $0x8,%esp
8010391a:	50                   	push   %eax
8010391b:	68 5c 8b 10 80       	push   $0x80108b5c
80103920:	e8 e6 ca ff ff       	call   8010040b <cprintf>
80103925:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103928:	e8 c4 06 00 00       	call   80103ff1 <picinit>
  ioapicinit();    // another interrupt controller
8010392d:	e8 c4 f0 ff ff       	call   801029f6 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103932:	e8 1a d2 ff ff       	call   80100b51 <consoleinit>
  uartinit();      // serial port
80103937:	e8 e1 32 00 00       	call   80106c1d <uartinit>
  pinit();         // process table
8010393c:	e8 ab 0b 00 00       	call   801044ec <pinit>
  tvinit();        // trap vectors
80103941:	e8 ca 2e 00 00       	call   80106810 <tvinit>
  binit();         // buffer cache
80103946:	e8 e9 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010394b:	e8 39 d6 ff ff       	call   80100f89 <fileinit>
  ideinit();       // disk
80103950:	e8 b0 ec ff ff       	call   80102605 <ideinit>
  if(!ismp)
80103955:	a1 24 2d 11 80       	mov    0x80112d24,%eax
8010395a:	85 c0                	test   %eax,%eax
8010395c:	75 05                	jne    80103963 <main+0x91>
    timerinit();   // uniprocessor timer
8010395e:	e8 0e 2e 00 00       	call   80106771 <timerinit>
  startothers();   // start other processors
80103963:	e8 7e 00 00 00       	call   801039e6 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103968:	83 ec 08             	sub    $0x8,%esp
8010396b:	68 00 00 00 8e       	push   $0x8e000000
80103970:	68 00 00 40 80       	push   $0x80400000
80103975:	e8 b3 f1 ff ff       	call   80102b2d <kinit2>
8010397a:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
8010397d:	e8 9b 0c 00 00       	call   8010461d <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103982:	e8 1a 00 00 00       	call   801039a1 <mpmain>

80103987 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103987:	55                   	push   %ebp
80103988:	89 e5                	mov    %esp,%ebp
8010398a:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010398d:	e8 c7 47 00 00       	call   80108159 <switchkvm>
  seginit();
80103992:	e8 74 41 00 00       	call   80107b0b <seginit>
  lapicinit();
80103997:	e8 c7 f4 ff ff       	call   80102e63 <lapicinit>
  mpmain();
8010399c:	e8 00 00 00 00       	call   801039a1 <mpmain>

801039a1 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039a1:	55                   	push   %ebp
801039a2:	89 e5                	mov    %esp,%ebp
801039a4:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801039a7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039ad:	8a 00                	mov    (%eax),%al
801039af:	0f b6 c0             	movzbl %al,%eax
801039b2:	83 ec 08             	sub    $0x8,%esp
801039b5:	50                   	push   %eax
801039b6:	68 73 8b 10 80       	push   $0x80108b73
801039bb:	e8 4b ca ff ff       	call   8010040b <cprintf>
801039c0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801039c3:	e8 a6 2f 00 00       	call   8010696e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801039c8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039ce:	05 a8 00 00 00       	add    $0xa8,%eax
801039d3:	83 ec 08             	sub    $0x8,%esp
801039d6:	6a 01                	push   $0x1
801039d8:	50                   	push   %eax
801039d9:	e8 da fe ff ff       	call   801038b8 <xchg>
801039de:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801039e1:	e8 d3 11 00 00       	call   80104bb9 <scheduler>

801039e6 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801039e6:	55                   	push   %ebp
801039e7:	89 e5                	mov    %esp,%ebp
801039e9:	53                   	push   %ebx
801039ea:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801039ed:	68 00 70 00 00       	push   $0x7000
801039f2:	e8 b4 fe ff ff       	call   801038ab <p2v>
801039f7:	83 c4 04             	add    $0x4,%esp
801039fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801039fd:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a02:	83 ec 04             	sub    $0x4,%esp
80103a05:	50                   	push   %eax
80103a06:	68 2c b5 10 80       	push   $0x8010b52c
80103a0b:	ff 75 f0             	pushl  -0x10(%ebp)
80103a0e:	e8 5a 1a 00 00       	call   8010546d <memmove>
80103a13:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a16:	c7 45 f4 40 2d 11 80 	movl   $0x80112d40,-0xc(%ebp)
80103a1d:	e9 9c 00 00 00       	jmp    80103abe <startothers+0xd8>
    if(c == cpus+cpunum())  // We've started already.
80103a22:	e8 58 f5 ff ff       	call   80102f7f <cpunum>
80103a27:	89 c2                	mov    %eax,%edx
80103a29:	89 d0                	mov    %edx,%eax
80103a2b:	c1 e0 02             	shl    $0x2,%eax
80103a2e:	01 d0                	add    %edx,%eax
80103a30:	01 c0                	add    %eax,%eax
80103a32:	01 d0                	add    %edx,%eax
80103a34:	89 c1                	mov    %eax,%ecx
80103a36:	c1 e1 04             	shl    $0x4,%ecx
80103a39:	01 c8                	add    %ecx,%eax
80103a3b:	01 d0                	add    %edx,%eax
80103a3d:	05 40 2d 11 80       	add    $0x80112d40,%eax
80103a42:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a45:	75 02                	jne    80103a49 <startothers+0x63>
      continue;
80103a47:	eb 6e                	jmp    80103ab7 <startothers+0xd1>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a49:	e8 da f1 ff ff       	call   80102c28 <kalloc>
80103a4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a54:	83 e8 04             	sub    $0x4,%eax
80103a57:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a5a:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a60:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a65:	83 e8 08             	sub    $0x8,%eax
80103a68:	c7 00 87 39 10 80    	movl   $0x80103987,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a71:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103a74:	83 ec 0c             	sub    $0xc,%esp
80103a77:	68 00 a0 10 80       	push   $0x8010a000
80103a7c:	e8 1d fe ff ff       	call   8010389e <v2p>
80103a81:	83 c4 10             	add    $0x10,%esp
80103a84:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103a86:	83 ec 0c             	sub    $0xc,%esp
80103a89:	ff 75 f0             	pushl  -0x10(%ebp)
80103a8c:	e8 0d fe ff ff       	call   8010389e <v2p>
80103a91:	83 c4 10             	add    $0x10,%esp
80103a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a97:	8a 12                	mov    (%edx),%dl
80103a99:	0f b6 d2             	movzbl %dl,%edx
80103a9c:	83 ec 08             	sub    $0x8,%esp
80103a9f:	50                   	push   %eax
80103aa0:	52                   	push   %edx
80103aa1:	e8 51 f5 ff ff       	call   80102ff7 <lapicstartap>
80103aa6:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103aa9:	90                   	nop
80103aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aad:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103ab3:	85 c0                	test   %eax,%eax
80103ab5:	74 f3                	je     80103aaa <startothers+0xc4>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103ab7:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103abe:	a1 20 33 11 80       	mov    0x80113320,%eax
80103ac3:	89 c2                	mov    %eax,%edx
80103ac5:	89 d0                	mov    %edx,%eax
80103ac7:	c1 e0 02             	shl    $0x2,%eax
80103aca:	01 d0                	add    %edx,%eax
80103acc:	01 c0                	add    %eax,%eax
80103ace:	01 d0                	add    %edx,%eax
80103ad0:	89 c1                	mov    %eax,%ecx
80103ad2:	c1 e1 04             	shl    $0x4,%ecx
80103ad5:	01 c8                	add    %ecx,%eax
80103ad7:	01 d0                	add    %edx,%eax
80103ad9:	05 40 2d 11 80       	add    $0x80112d40,%eax
80103ade:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ae1:	0f 87 3b ff ff ff    	ja     80103a22 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aea:	c9                   	leave  
80103aeb:	c3                   	ret    

80103aec <p2v>:
80103aec:	55                   	push   %ebp
80103aed:	89 e5                	mov    %esp,%ebp
80103aef:	8b 45 08             	mov    0x8(%ebp),%eax
80103af2:	05 00 00 00 80       	add    $0x80000000,%eax
80103af7:	5d                   	pop    %ebp
80103af8:	c3                   	ret    

80103af9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103af9:	55                   	push   %ebp
80103afa:	89 e5                	mov    %esp,%ebp
80103afc:	83 ec 14             	sub    $0x14,%esp
80103aff:	8b 45 08             	mov    0x8(%ebp),%eax
80103b02:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b06:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b09:	89 c2                	mov    %eax,%edx
80103b0b:	ec                   	in     (%dx),%al
80103b0c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b0f:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80103b12:	c9                   	leave  
80103b13:	c3                   	ret    

80103b14 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b14:	55                   	push   %ebp
80103b15:	89 e5                	mov    %esp,%ebp
80103b17:	83 ec 08             	sub    $0x8,%esp
80103b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80103b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b20:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103b24:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b27:	8a 45 f8             	mov    -0x8(%ebp),%al
80103b2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b2d:	ee                   	out    %al,(%dx)
}
80103b2e:	c9                   	leave  
80103b2f:	c3                   	ret    

80103b30 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b33:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103b38:	89 c2                	mov    %eax,%edx
80103b3a:	b8 40 2d 11 80       	mov    $0x80112d40,%eax
80103b3f:	29 c2                	sub    %eax,%edx
80103b41:	89 d0                	mov    %edx,%eax
80103b43:	c1 f8 02             	sar    $0x2,%eax
80103b46:	89 c2                	mov    %eax,%edx
80103b48:	89 d0                	mov    %edx,%eax
80103b4a:	c1 e0 03             	shl    $0x3,%eax
80103b4d:	01 d0                	add    %edx,%eax
80103b4f:	c1 e0 03             	shl    $0x3,%eax
80103b52:	01 d0                	add    %edx,%eax
80103b54:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80103b5b:	01 c8                	add    %ecx,%eax
80103b5d:	c1 e0 03             	shl    $0x3,%eax
80103b60:	01 d0                	add    %edx,%eax
80103b62:	01 c0                	add    %eax,%eax
80103b64:	01 d0                	add    %edx,%eax
80103b66:	c1 e0 03             	shl    $0x3,%eax
80103b69:	01 d0                	add    %edx,%eax
80103b6b:	c1 e0 02             	shl    $0x2,%eax
80103b6e:	01 d0                	add    %edx,%eax
80103b70:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80103b77:	01 c8                	add    %ecx,%eax
80103b79:	01 c0                	add    %eax,%eax
80103b7b:	01 d0                	add    %edx,%eax
80103b7d:	01 c0                	add    %eax,%eax
80103b7f:	01 d0                	add    %edx,%eax
80103b81:	89 c1                	mov    %eax,%ecx
80103b83:	c1 e1 07             	shl    $0x7,%ecx
80103b86:	01 c8                	add    %ecx,%eax
80103b88:	01 c0                	add    %eax,%eax
80103b8a:	01 d0                	add    %edx,%eax
}
80103b8c:	5d                   	pop    %ebp
80103b8d:	c3                   	ret    

80103b8e <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b8e:	55                   	push   %ebp
80103b8f:	89 e5                	mov    %esp,%ebp
80103b91:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103b94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103ba2:	eb 13                	jmp    80103bb7 <sum+0x29>
    sum += addr[i];
80103ba4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ba7:	8b 45 08             	mov    0x8(%ebp),%eax
80103baa:	01 d0                	add    %edx,%eax
80103bac:	8a 00                	mov    (%eax),%al
80103bae:	0f b6 c0             	movzbl %al,%eax
80103bb1:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103bb4:	ff 45 fc             	incl   -0x4(%ebp)
80103bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bba:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bbd:	7c e5                	jl     80103ba4 <sum+0x16>
    sum += addr[i];
  return sum;
80103bbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bc2:	c9                   	leave  
80103bc3:	c3                   	ret    

80103bc4 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bc4:	55                   	push   %ebp
80103bc5:	89 e5                	mov    %esp,%ebp
80103bc7:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103bca:	ff 75 08             	pushl  0x8(%ebp)
80103bcd:	e8 1a ff ff ff       	call   80103aec <p2v>
80103bd2:	83 c4 04             	add    $0x4,%esp
80103bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bde:	01 d0                	add    %edx,%eax
80103be0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103be9:	eb 36                	jmp    80103c21 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103beb:	83 ec 04             	sub    $0x4,%esp
80103bee:	6a 04                	push   $0x4
80103bf0:	68 84 8b 10 80       	push   $0x80108b84
80103bf5:	ff 75 f4             	pushl  -0xc(%ebp)
80103bf8:	e8 1e 18 00 00       	call   8010541b <memcmp>
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	85 c0                	test   %eax,%eax
80103c02:	75 19                	jne    80103c1d <mpsearch1+0x59>
80103c04:	83 ec 08             	sub    $0x8,%esp
80103c07:	6a 10                	push   $0x10
80103c09:	ff 75 f4             	pushl  -0xc(%ebp)
80103c0c:	e8 7d ff ff ff       	call   80103b8e <sum>
80103c11:	83 c4 10             	add    $0x10,%esp
80103c14:	84 c0                	test   %al,%al
80103c16:	75 05                	jne    80103c1d <mpsearch1+0x59>
      return (struct mp*)p;
80103c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1b:	eb 11                	jmp    80103c2e <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c1d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c27:	72 c2                	jb     80103beb <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c2e:	c9                   	leave  
80103c2f:	c3                   	ret    

80103c30 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c36:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c40:	83 c0 0f             	add    $0xf,%eax
80103c43:	8a 00                	mov    (%eax),%al
80103c45:	0f b6 c0             	movzbl %al,%eax
80103c48:	c1 e0 08             	shl    $0x8,%eax
80103c4b:	89 c2                	mov    %eax,%edx
80103c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c50:	83 c0 0e             	add    $0xe,%eax
80103c53:	8a 00                	mov    (%eax),%al
80103c55:	0f b6 c0             	movzbl %al,%eax
80103c58:	09 d0                	or     %edx,%eax
80103c5a:	c1 e0 04             	shl    $0x4,%eax
80103c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c64:	74 21                	je     80103c87 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103c66:	83 ec 08             	sub    $0x8,%esp
80103c69:	68 00 04 00 00       	push   $0x400
80103c6e:	ff 75 f0             	pushl  -0x10(%ebp)
80103c71:	e8 4e ff ff ff       	call   80103bc4 <mpsearch1>
80103c76:	83 c4 10             	add    $0x10,%esp
80103c79:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c80:	74 4f                	je     80103cd1 <mpsearch+0xa1>
      return mp;
80103c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c85:	eb 5f                	jmp    80103ce6 <mpsearch+0xb6>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8a:	83 c0 14             	add    $0x14,%eax
80103c8d:	8a 00                	mov    (%eax),%al
80103c8f:	0f b6 c0             	movzbl %al,%eax
80103c92:	c1 e0 08             	shl    $0x8,%eax
80103c95:	89 c2                	mov    %eax,%edx
80103c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9a:	83 c0 13             	add    $0x13,%eax
80103c9d:	8a 00                	mov    (%eax),%al
80103c9f:	0f b6 c0             	movzbl %al,%eax
80103ca2:	09 d0                	or     %edx,%eax
80103ca4:	c1 e0 0a             	shl    $0xa,%eax
80103ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cad:	2d 00 04 00 00       	sub    $0x400,%eax
80103cb2:	83 ec 08             	sub    $0x8,%esp
80103cb5:	68 00 04 00 00       	push   $0x400
80103cba:	50                   	push   %eax
80103cbb:	e8 04 ff ff ff       	call   80103bc4 <mpsearch1>
80103cc0:	83 c4 10             	add    $0x10,%esp
80103cc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cc6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cca:	74 05                	je     80103cd1 <mpsearch+0xa1>
      return mp;
80103ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ccf:	eb 15                	jmp    80103ce6 <mpsearch+0xb6>
  }
  return mpsearch1(0xF0000, 0x10000);
80103cd1:	83 ec 08             	sub    $0x8,%esp
80103cd4:	68 00 00 01 00       	push   $0x10000
80103cd9:	68 00 00 0f 00       	push   $0xf0000
80103cde:	e8 e1 fe ff ff       	call   80103bc4 <mpsearch1>
80103ce3:	83 c4 10             	add    $0x10,%esp
}
80103ce6:	c9                   	leave  
80103ce7:	c3                   	ret    

80103ce8 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ce8:	55                   	push   %ebp
80103ce9:	89 e5                	mov    %esp,%ebp
80103ceb:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103cee:	e8 3d ff ff ff       	call   80103c30 <mpsearch>
80103cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cfa:	74 0a                	je     80103d06 <mpconfig+0x1e>
80103cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cff:	8b 40 04             	mov    0x4(%eax),%eax
80103d02:	85 c0                	test   %eax,%eax
80103d04:	75 07                	jne    80103d0d <mpconfig+0x25>
    return 0;
80103d06:	b8 00 00 00 00       	mov    $0x0,%eax
80103d0b:	eb 7e                	jmp    80103d8b <mpconfig+0xa3>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d10:	8b 40 04             	mov    0x4(%eax),%eax
80103d13:	83 ec 0c             	sub    $0xc,%esp
80103d16:	50                   	push   %eax
80103d17:	e8 d0 fd ff ff       	call   80103aec <p2v>
80103d1c:	83 c4 10             	add    $0x10,%esp
80103d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d22:	83 ec 04             	sub    $0x4,%esp
80103d25:	6a 04                	push   $0x4
80103d27:	68 89 8b 10 80       	push   $0x80108b89
80103d2c:	ff 75 f0             	pushl  -0x10(%ebp)
80103d2f:	e8 e7 16 00 00       	call   8010541b <memcmp>
80103d34:	83 c4 10             	add    $0x10,%esp
80103d37:	85 c0                	test   %eax,%eax
80103d39:	74 07                	je     80103d42 <mpconfig+0x5a>
    return 0;
80103d3b:	b8 00 00 00 00       	mov    $0x0,%eax
80103d40:	eb 49                	jmp    80103d8b <mpconfig+0xa3>
  if(conf->version != 1 && conf->version != 4)
80103d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d45:	8a 40 06             	mov    0x6(%eax),%al
80103d48:	3c 01                	cmp    $0x1,%al
80103d4a:	74 11                	je     80103d5d <mpconfig+0x75>
80103d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d4f:	8a 40 06             	mov    0x6(%eax),%al
80103d52:	3c 04                	cmp    $0x4,%al
80103d54:	74 07                	je     80103d5d <mpconfig+0x75>
    return 0;
80103d56:	b8 00 00 00 00       	mov    $0x0,%eax
80103d5b:	eb 2e                	jmp    80103d8b <mpconfig+0xa3>
  if(sum((uchar*)conf, conf->length) != 0)
80103d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d60:	8b 40 04             	mov    0x4(%eax),%eax
80103d63:	0f b7 c0             	movzwl %ax,%eax
80103d66:	83 ec 08             	sub    $0x8,%esp
80103d69:	50                   	push   %eax
80103d6a:	ff 75 f0             	pushl  -0x10(%ebp)
80103d6d:	e8 1c fe ff ff       	call   80103b8e <sum>
80103d72:	83 c4 10             	add    $0x10,%esp
80103d75:	84 c0                	test   %al,%al
80103d77:	74 07                	je     80103d80 <mpconfig+0x98>
    return 0;
80103d79:	b8 00 00 00 00       	mov    $0x0,%eax
80103d7e:	eb 0b                	jmp    80103d8b <mpconfig+0xa3>
  *pmp = mp;
80103d80:	8b 45 08             	mov    0x8(%ebp),%eax
80103d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d86:	89 10                	mov    %edx,(%eax)
  return conf;
80103d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d8b:	c9                   	leave  
80103d8c:	c3                   	ret    

80103d8d <mpinit>:

void
mpinit(void)
{
80103d8d:	55                   	push   %ebp
80103d8e:	89 e5                	mov    %esp,%ebp
80103d90:	53                   	push   %ebx
80103d91:	83 ec 24             	sub    $0x24,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103d94:	c7 05 64 b6 10 80 40 	movl   $0x80112d40,0x8010b664
80103d9b:	2d 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103d9e:	83 ec 0c             	sub    $0xc,%esp
80103da1:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103da4:	50                   	push   %eax
80103da5:	e8 3e ff ff ff       	call   80103ce8 <mpconfig>
80103daa:	83 c4 10             	add    $0x10,%esp
80103dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103db0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103db4:	75 05                	jne    80103dbb <mpinit+0x2e>
    return;
80103db6:	e9 a9 01 00 00       	jmp    80103f64 <mpinit+0x1d7>
  ismp = 1;
80103dbb:	c7 05 24 2d 11 80 01 	movl   $0x1,0x80112d24
80103dc2:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dc8:	8b 40 24             	mov    0x24(%eax),%eax
80103dcb:	a3 3c 2c 11 80       	mov    %eax,0x80112c3c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dd3:	83 c0 2c             	add    $0x2c,%eax
80103dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ddc:	8b 40 04             	mov    0x4(%eax),%eax
80103ddf:	0f b7 d0             	movzwl %ax,%edx
80103de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de5:	01 d0                	add    %edx,%eax
80103de7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103dea:	e9 09 01 00 00       	jmp    80103ef8 <mpinit+0x16b>
    switch(*p){
80103def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df2:	8a 00                	mov    (%eax),%al
80103df4:	0f b6 c0             	movzbl %al,%eax
80103df7:	83 f8 04             	cmp    $0x4,%eax
80103dfa:	0f 87 d5 00 00 00    	ja     80103ed5 <mpinit+0x148>
80103e00:	8b 04 85 cc 8b 10 80 	mov    -0x7fef7434(,%eax,4),%eax
80103e07:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e12:	8a 40 01             	mov    0x1(%eax),%al
80103e15:	0f b6 d0             	movzbl %al,%edx
80103e18:	a1 20 33 11 80       	mov    0x80113320,%eax
80103e1d:	39 c2                	cmp    %eax,%edx
80103e1f:	74 2a                	je     80103e4b <mpinit+0xbe>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e24:	8a 40 01             	mov    0x1(%eax),%al
80103e27:	0f b6 d0             	movzbl %al,%edx
80103e2a:	a1 20 33 11 80       	mov    0x80113320,%eax
80103e2f:	83 ec 04             	sub    $0x4,%esp
80103e32:	52                   	push   %edx
80103e33:	50                   	push   %eax
80103e34:	68 8e 8b 10 80       	push   $0x80108b8e
80103e39:	e8 cd c5 ff ff       	call   8010040b <cprintf>
80103e3e:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e41:	c7 05 24 2d 11 80 00 	movl   $0x0,0x80112d24
80103e48:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e4e:	8a 40 03             	mov    0x3(%eax),%al
80103e51:	0f b6 c0             	movzbl %al,%eax
80103e54:	83 e0 02             	and    $0x2,%eax
80103e57:	85 c0                	test   %eax,%eax
80103e59:	74 24                	je     80103e7f <mpinit+0xf2>
        bcpu = &cpus[ncpu];
80103e5b:	8b 15 20 33 11 80    	mov    0x80113320,%edx
80103e61:	89 d0                	mov    %edx,%eax
80103e63:	c1 e0 02             	shl    $0x2,%eax
80103e66:	01 d0                	add    %edx,%eax
80103e68:	01 c0                	add    %eax,%eax
80103e6a:	01 d0                	add    %edx,%eax
80103e6c:	89 c1                	mov    %eax,%ecx
80103e6e:	c1 e1 04             	shl    $0x4,%ecx
80103e71:	01 c8                	add    %ecx,%eax
80103e73:	01 d0                	add    %edx,%eax
80103e75:	05 40 2d 11 80       	add    $0x80112d40,%eax
80103e7a:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103e7f:	8b 15 20 33 11 80    	mov    0x80113320,%edx
80103e85:	a1 20 33 11 80       	mov    0x80113320,%eax
80103e8a:	88 c1                	mov    %al,%cl
80103e8c:	89 d0                	mov    %edx,%eax
80103e8e:	c1 e0 02             	shl    $0x2,%eax
80103e91:	01 d0                	add    %edx,%eax
80103e93:	01 c0                	add    %eax,%eax
80103e95:	01 d0                	add    %edx,%eax
80103e97:	89 c3                	mov    %eax,%ebx
80103e99:	c1 e3 04             	shl    $0x4,%ebx
80103e9c:	01 d8                	add    %ebx,%eax
80103e9e:	01 d0                	add    %edx,%eax
80103ea0:	05 40 2d 11 80       	add    $0x80112d40,%eax
80103ea5:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103ea7:	a1 20 33 11 80       	mov    0x80113320,%eax
80103eac:	40                   	inc    %eax
80103ead:	a3 20 33 11 80       	mov    %eax,0x80113320
      p += sizeof(struct mpproc);
80103eb2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103eb6:	eb 40                	jmp    80103ef8 <mpinit+0x16b>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ebb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ebe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ec1:	8a 40 01             	mov    0x1(%eax),%al
80103ec4:	a2 20 2d 11 80       	mov    %al,0x80112d20
      p += sizeof(struct mpioapic);
80103ec9:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ecd:	eb 29                	jmp    80103ef8 <mpinit+0x16b>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ecf:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ed3:	eb 23                	jmp    80103ef8 <mpinit+0x16b>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed8:	8a 00                	mov    (%eax),%al
80103eda:	0f b6 c0             	movzbl %al,%eax
80103edd:	83 ec 08             	sub    $0x8,%esp
80103ee0:	50                   	push   %eax
80103ee1:	68 ac 8b 10 80       	push   $0x80108bac
80103ee6:	e8 20 c5 ff ff       	call   8010040b <cprintf>
80103eeb:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103eee:	c7 05 24 2d 11 80 00 	movl   $0x0,0x80112d24
80103ef5:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103efb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103efe:	0f 82 eb fe ff ff    	jb     80103def <mpinit+0x62>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103f04:	a1 24 2d 11 80       	mov    0x80112d24,%eax
80103f09:	85 c0                	test   %eax,%eax
80103f0b:	75 1d                	jne    80103f2a <mpinit+0x19d>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f0d:	c7 05 20 33 11 80 01 	movl   $0x1,0x80113320
80103f14:	00 00 00 
    lapic = 0;
80103f17:	c7 05 3c 2c 11 80 00 	movl   $0x0,0x80112c3c
80103f1e:	00 00 00 
    ioapicid = 0;
80103f21:	c6 05 20 2d 11 80 00 	movb   $0x0,0x80112d20
    return;
80103f28:	eb 3a                	jmp    80103f64 <mpinit+0x1d7>
  }

  if(mp->imcrp){
80103f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f2d:	8a 40 0c             	mov    0xc(%eax),%al
80103f30:	84 c0                	test   %al,%al
80103f32:	74 30                	je     80103f64 <mpinit+0x1d7>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f34:	83 ec 08             	sub    $0x8,%esp
80103f37:	6a 70                	push   $0x70
80103f39:	6a 22                	push   $0x22
80103f3b:	e8 d4 fb ff ff       	call   80103b14 <outb>
80103f40:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	6a 23                	push   $0x23
80103f48:	e8 ac fb ff ff       	call   80103af9 <inb>
80103f4d:	83 c4 10             	add    $0x10,%esp
80103f50:	83 c8 01             	or     $0x1,%eax
80103f53:	0f b6 c0             	movzbl %al,%eax
80103f56:	83 ec 08             	sub    $0x8,%esp
80103f59:	50                   	push   %eax
80103f5a:	6a 23                	push   $0x23
80103f5c:	e8 b3 fb ff ff       	call   80103b14 <outb>
80103f61:	83 c4 10             	add    $0x10,%esp
  }
}
80103f64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f67:	c9                   	leave  
80103f68:	c3                   	ret    

80103f69 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f69:	55                   	push   %ebp
80103f6a:	89 e5                	mov    %esp,%ebp
80103f6c:	83 ec 08             	sub    $0x8,%esp
80103f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f72:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f75:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103f79:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f7c:	8a 45 f8             	mov    -0x8(%ebp),%al
80103f7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103f82:	ee                   	out    %al,(%dx)
}
80103f83:	c9                   	leave  
80103f84:	c3                   	ret    

80103f85 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f85:	55                   	push   %ebp
80103f86:	89 e5                	mov    %esp,%ebp
80103f88:	83 ec 04             	sub    $0x4,%esp
80103f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103f95:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103f9e:	0f b6 c0             	movzbl %al,%eax
80103fa1:	50                   	push   %eax
80103fa2:	6a 21                	push   $0x21
80103fa4:	e8 c0 ff ff ff       	call   80103f69 <outb>
80103fa9:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103faf:	66 c1 e8 08          	shr    $0x8,%ax
80103fb3:	0f b6 c0             	movzbl %al,%eax
80103fb6:	50                   	push   %eax
80103fb7:	68 a1 00 00 00       	push   $0xa1
80103fbc:	e8 a8 ff ff ff       	call   80103f69 <outb>
80103fc1:	83 c4 08             	add    $0x8,%esp
}
80103fc4:	c9                   	leave  
80103fc5:	c3                   	ret    

80103fc6 <picenable>:

void
picenable(int irq)
{
80103fc6:	55                   	push   %ebp
80103fc7:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcc:	ba 01 00 00 00       	mov    $0x1,%edx
80103fd1:	88 c1                	mov    %al,%cl
80103fd3:	d3 e2                	shl    %cl,%edx
80103fd5:	89 d0                	mov    %edx,%eax
80103fd7:	f7 d0                	not    %eax
80103fd9:	89 c2                	mov    %eax,%edx
80103fdb:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103fe1:	21 d0                	and    %edx,%eax
80103fe3:	0f b7 c0             	movzwl %ax,%eax
80103fe6:	50                   	push   %eax
80103fe7:	e8 99 ff ff ff       	call   80103f85 <picsetmask>
80103fec:	83 c4 04             	add    $0x4,%esp
}
80103fef:	c9                   	leave  
80103ff0:	c3                   	ret    

80103ff1 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ff1:	55                   	push   %ebp
80103ff2:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ff4:	68 ff 00 00 00       	push   $0xff
80103ff9:	6a 21                	push   $0x21
80103ffb:	e8 69 ff ff ff       	call   80103f69 <outb>
80104000:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104003:	68 ff 00 00 00       	push   $0xff
80104008:	68 a1 00 00 00       	push   $0xa1
8010400d:	e8 57 ff ff ff       	call   80103f69 <outb>
80104012:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104015:	6a 11                	push   $0x11
80104017:	6a 20                	push   $0x20
80104019:	e8 4b ff ff ff       	call   80103f69 <outb>
8010401e:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104021:	6a 20                	push   $0x20
80104023:	6a 21                	push   $0x21
80104025:	e8 3f ff ff ff       	call   80103f69 <outb>
8010402a:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
8010402d:	6a 04                	push   $0x4
8010402f:	6a 21                	push   $0x21
80104031:	e8 33 ff ff ff       	call   80103f69 <outb>
80104036:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80104039:	6a 03                	push   $0x3
8010403b:	6a 21                	push   $0x21
8010403d:	e8 27 ff ff ff       	call   80103f69 <outb>
80104042:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104045:	6a 11                	push   $0x11
80104047:	68 a0 00 00 00       	push   $0xa0
8010404c:	e8 18 ff ff ff       	call   80103f69 <outb>
80104051:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104054:	6a 28                	push   $0x28
80104056:	68 a1 00 00 00       	push   $0xa1
8010405b:	e8 09 ff ff ff       	call   80103f69 <outb>
80104060:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104063:	6a 02                	push   $0x2
80104065:	68 a1 00 00 00       	push   $0xa1
8010406a:	e8 fa fe ff ff       	call   80103f69 <outb>
8010406f:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104072:	6a 03                	push   $0x3
80104074:	68 a1 00 00 00       	push   $0xa1
80104079:	e8 eb fe ff ff       	call   80103f69 <outb>
8010407e:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104081:	6a 68                	push   $0x68
80104083:	6a 20                	push   $0x20
80104085:	e8 df fe ff ff       	call   80103f69 <outb>
8010408a:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010408d:	6a 0a                	push   $0xa
8010408f:	6a 20                	push   $0x20
80104091:	e8 d3 fe ff ff       	call   80103f69 <outb>
80104096:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104099:	6a 68                	push   $0x68
8010409b:	68 a0 00 00 00       	push   $0xa0
801040a0:	e8 c4 fe ff ff       	call   80103f69 <outb>
801040a5:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801040a8:	6a 0a                	push   $0xa
801040aa:	68 a0 00 00 00       	push   $0xa0
801040af:	e8 b5 fe ff ff       	call   80103f69 <outb>
801040b4:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801040b7:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
801040bd:	66 83 f8 ff          	cmp    $0xffff,%ax
801040c1:	74 12                	je     801040d5 <picinit+0xe4>
    picsetmask(irqmask);
801040c3:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
801040c9:	0f b7 c0             	movzwl %ax,%eax
801040cc:	50                   	push   %eax
801040cd:	e8 b3 fe ff ff       	call   80103f85 <picsetmask>
801040d2:	83 c4 04             	add    $0x4,%esp
}
801040d5:	c9                   	leave  
801040d6:	c3                   	ret    

801040d7 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801040d7:	55                   	push   %ebp
801040d8:	89 e5                	mov    %esp,%ebp
801040da:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801040dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801040e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801040e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801040ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f0:	8b 10                	mov    (%eax),%edx
801040f2:	8b 45 08             	mov    0x8(%ebp),%eax
801040f5:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801040f7:	e8 aa ce ff ff       	call   80100fa6 <filealloc>
801040fc:	8b 55 08             	mov    0x8(%ebp),%edx
801040ff:	89 02                	mov    %eax,(%edx)
80104101:	8b 45 08             	mov    0x8(%ebp),%eax
80104104:	8b 00                	mov    (%eax),%eax
80104106:	85 c0                	test   %eax,%eax
80104108:	0f 84 c9 00 00 00    	je     801041d7 <pipealloc+0x100>
8010410e:	e8 93 ce ff ff       	call   80100fa6 <filealloc>
80104113:	8b 55 0c             	mov    0xc(%ebp),%edx
80104116:	89 02                	mov    %eax,(%edx)
80104118:	8b 45 0c             	mov    0xc(%ebp),%eax
8010411b:	8b 00                	mov    (%eax),%eax
8010411d:	85 c0                	test   %eax,%eax
8010411f:	0f 84 b2 00 00 00    	je     801041d7 <pipealloc+0x100>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104125:	e8 fe ea ff ff       	call   80102c28 <kalloc>
8010412a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010412d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104131:	75 05                	jne    80104138 <pipealloc+0x61>
    goto bad;
80104133:	e9 9f 00 00 00       	jmp    801041d7 <pipealloc+0x100>
  p->readopen = 1;
80104138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104142:	00 00 00 
  p->writeopen = 1;
80104145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104148:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010414f:	00 00 00 
  p->nwrite = 0;
80104152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104155:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010415c:	00 00 00 
  p->nread = 0;
8010415f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104162:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104169:	00 00 00 
  initlock(&p->lock, "pipe");
8010416c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416f:	83 ec 08             	sub    $0x8,%esp
80104172:	68 e0 8b 10 80       	push   $0x80108be0
80104177:	50                   	push   %eax
80104178:	e8 be 0f 00 00       	call   8010513b <initlock>
8010417d:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104180:	8b 45 08             	mov    0x8(%ebp),%eax
80104183:	8b 00                	mov    (%eax),%eax
80104185:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010418b:	8b 45 08             	mov    0x8(%ebp),%eax
8010418e:	8b 00                	mov    (%eax),%eax
80104190:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104194:	8b 45 08             	mov    0x8(%ebp),%eax
80104197:	8b 00                	mov    (%eax),%eax
80104199:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010419d:	8b 45 08             	mov    0x8(%ebp),%eax
801041a0:	8b 00                	mov    (%eax),%eax
801041a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041a5:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801041ab:	8b 00                	mov    (%eax),%eax
801041ad:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b6:	8b 00                	mov    (%eax),%eax
801041b8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801041bf:	8b 00                	mov    (%eax),%eax
801041c1:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801041c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c8:	8b 00                	mov    (%eax),%eax
801041ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041cd:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801041d0:	b8 00 00 00 00       	mov    $0x0,%eax
801041d5:	eb 4d                	jmp    80104224 <pipealloc+0x14d>

//PAGEBREAK: 20
 bad:
  if(p)
801041d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041db:	74 0e                	je     801041eb <pipealloc+0x114>
    kfree((char*)p);
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	ff 75 f4             	pushl  -0xc(%ebp)
801041e3:	e8 a4 e9 ff ff       	call   80102b8c <kfree>
801041e8:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801041eb:	8b 45 08             	mov    0x8(%ebp),%eax
801041ee:	8b 00                	mov    (%eax),%eax
801041f0:	85 c0                	test   %eax,%eax
801041f2:	74 11                	je     80104205 <pipealloc+0x12e>
    fileclose(*f0);
801041f4:	8b 45 08             	mov    0x8(%ebp),%eax
801041f7:	8b 00                	mov    (%eax),%eax
801041f9:	83 ec 0c             	sub    $0xc,%esp
801041fc:	50                   	push   %eax
801041fd:	e8 61 ce ff ff       	call   80101063 <fileclose>
80104202:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104205:	8b 45 0c             	mov    0xc(%ebp),%eax
80104208:	8b 00                	mov    (%eax),%eax
8010420a:	85 c0                	test   %eax,%eax
8010420c:	74 11                	je     8010421f <pipealloc+0x148>
    fileclose(*f1);
8010420e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104211:	8b 00                	mov    (%eax),%eax
80104213:	83 ec 0c             	sub    $0xc,%esp
80104216:	50                   	push   %eax
80104217:	e8 47 ce ff ff       	call   80101063 <fileclose>
8010421c:	83 c4 10             	add    $0x10,%esp
  return -1;
8010421f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104224:	c9                   	leave  
80104225:	c3                   	ret    

80104226 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104226:	55                   	push   %ebp
80104227:	89 e5                	mov    %esp,%ebp
80104229:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010422c:	8b 45 08             	mov    0x8(%ebp),%eax
8010422f:	83 ec 0c             	sub    $0xc,%esp
80104232:	50                   	push   %eax
80104233:	e8 24 0f 00 00       	call   8010515c <acquire>
80104238:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010423b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010423f:	74 23                	je     80104264 <pipeclose+0x3e>
    p->writeopen = 0;
80104241:	8b 45 08             	mov    0x8(%ebp),%eax
80104244:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010424b:	00 00 00 
    wakeup(&p->nread);
8010424e:	8b 45 08             	mov    0x8(%ebp),%eax
80104251:	05 34 02 00 00       	add    $0x234,%eax
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	50                   	push   %eax
8010425a:	e8 f9 0c 00 00       	call   80104f58 <wakeup>
8010425f:	83 c4 10             	add    $0x10,%esp
80104262:	eb 21                	jmp    80104285 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104264:	8b 45 08             	mov    0x8(%ebp),%eax
80104267:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010426e:	00 00 00 
    wakeup(&p->nwrite);
80104271:	8b 45 08             	mov    0x8(%ebp),%eax
80104274:	05 38 02 00 00       	add    $0x238,%eax
80104279:	83 ec 0c             	sub    $0xc,%esp
8010427c:	50                   	push   %eax
8010427d:	e8 d6 0c 00 00       	call   80104f58 <wakeup>
80104282:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104285:	8b 45 08             	mov    0x8(%ebp),%eax
80104288:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010428e:	85 c0                	test   %eax,%eax
80104290:	75 2c                	jne    801042be <pipeclose+0x98>
80104292:	8b 45 08             	mov    0x8(%ebp),%eax
80104295:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010429b:	85 c0                	test   %eax,%eax
8010429d:	75 1f                	jne    801042be <pipeclose+0x98>
    release(&p->lock);
8010429f:	8b 45 08             	mov    0x8(%ebp),%eax
801042a2:	83 ec 0c             	sub    $0xc,%esp
801042a5:	50                   	push   %eax
801042a6:	e8 17 0f 00 00       	call   801051c2 <release>
801042ab:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042ae:	83 ec 0c             	sub    $0xc,%esp
801042b1:	ff 75 08             	pushl  0x8(%ebp)
801042b4:	e8 d3 e8 ff ff       	call   80102b8c <kfree>
801042b9:	83 c4 10             	add    $0x10,%esp
801042bc:	eb 0f                	jmp    801042cd <pipeclose+0xa7>
  } else
    release(&p->lock);
801042be:	8b 45 08             	mov    0x8(%ebp),%eax
801042c1:	83 ec 0c             	sub    $0xc,%esp
801042c4:	50                   	push   %eax
801042c5:	e8 f8 0e 00 00       	call   801051c2 <release>
801042ca:	83 c4 10             	add    $0x10,%esp
}
801042cd:	c9                   	leave  
801042ce:	c3                   	ret    

801042cf <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801042cf:	55                   	push   %ebp
801042d0:	89 e5                	mov    %esp,%ebp
801042d2:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042d5:	8b 45 08             	mov    0x8(%ebp),%eax
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	50                   	push   %eax
801042dc:	e8 7b 0e 00 00       	call   8010515c <acquire>
801042e1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801042e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042eb:	e9 ad 00 00 00       	jmp    8010439d <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801042f0:	eb 60                	jmp    80104352 <pipewrite+0x83>
      if(p->readopen == 0 || proc->killed){
801042f2:	8b 45 08             	mov    0x8(%ebp),%eax
801042f5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042fb:	85 c0                	test   %eax,%eax
801042fd:	74 0d                	je     8010430c <pipewrite+0x3d>
801042ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104305:	8b 40 24             	mov    0x24(%eax),%eax
80104308:	85 c0                	test   %eax,%eax
8010430a:	74 19                	je     80104325 <pipewrite+0x56>
        release(&p->lock);
8010430c:	8b 45 08             	mov    0x8(%ebp),%eax
8010430f:	83 ec 0c             	sub    $0xc,%esp
80104312:	50                   	push   %eax
80104313:	e8 aa 0e 00 00       	call   801051c2 <release>
80104318:	83 c4 10             	add    $0x10,%esp
        return -1;
8010431b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104320:	e9 aa 00 00 00       	jmp    801043cf <pipewrite+0x100>
      }
      wakeup(&p->nread);
80104325:	8b 45 08             	mov    0x8(%ebp),%eax
80104328:	05 34 02 00 00       	add    $0x234,%eax
8010432d:	83 ec 0c             	sub    $0xc,%esp
80104330:	50                   	push   %eax
80104331:	e8 22 0c 00 00       	call   80104f58 <wakeup>
80104336:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104339:	8b 45 08             	mov    0x8(%ebp),%eax
8010433c:	8b 55 08             	mov    0x8(%ebp),%edx
8010433f:	81 c2 38 02 00 00    	add    $0x238,%edx
80104345:	83 ec 08             	sub    $0x8,%esp
80104348:	50                   	push   %eax
80104349:	52                   	push   %edx
8010434a:	e8 20 0b 00 00       	call   80104e6f <sleep>
8010434f:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104352:	8b 45 08             	mov    0x8(%ebp),%eax
80104355:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010435b:	8b 45 08             	mov    0x8(%ebp),%eax
8010435e:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104364:	05 00 02 00 00       	add    $0x200,%eax
80104369:	39 c2                	cmp    %eax,%edx
8010436b:	74 85                	je     801042f2 <pipewrite+0x23>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010436d:	8b 45 08             	mov    0x8(%ebp),%eax
80104370:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104376:	8d 48 01             	lea    0x1(%eax),%ecx
80104379:	8b 55 08             	mov    0x8(%ebp),%edx
8010437c:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104382:	25 ff 01 00 00       	and    $0x1ff,%eax
80104387:	89 c1                	mov    %eax,%ecx
80104389:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010438c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010438f:	01 d0                	add    %edx,%eax
80104391:	8a 10                	mov    (%eax),%dl
80104393:	8b 45 08             	mov    0x8(%ebp),%eax
80104396:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010439a:	ff 45 f4             	incl   -0xc(%ebp)
8010439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a0:	3b 45 10             	cmp    0x10(%ebp),%eax
801043a3:	0f 8c 47 ff ff ff    	jl     801042f0 <pipewrite+0x21>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043a9:	8b 45 08             	mov    0x8(%ebp),%eax
801043ac:	05 34 02 00 00       	add    $0x234,%eax
801043b1:	83 ec 0c             	sub    $0xc,%esp
801043b4:	50                   	push   %eax
801043b5:	e8 9e 0b 00 00       	call   80104f58 <wakeup>
801043ba:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043bd:	8b 45 08             	mov    0x8(%ebp),%eax
801043c0:	83 ec 0c             	sub    $0xc,%esp
801043c3:	50                   	push   %eax
801043c4:	e8 f9 0d 00 00       	call   801051c2 <release>
801043c9:	83 c4 10             	add    $0x10,%esp
  return n;
801043cc:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043cf:	c9                   	leave  
801043d0:	c3                   	ret    

801043d1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043d1:	55                   	push   %ebp
801043d2:	89 e5                	mov    %esp,%ebp
801043d4:	53                   	push   %ebx
801043d5:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801043d8:	8b 45 08             	mov    0x8(%ebp),%eax
801043db:	83 ec 0c             	sub    $0xc,%esp
801043de:	50                   	push   %eax
801043df:	e8 78 0d 00 00       	call   8010515c <acquire>
801043e4:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043e7:	eb 3f                	jmp    80104428 <piperead+0x57>
    if(proc->killed){
801043e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ef:	8b 40 24             	mov    0x24(%eax),%eax
801043f2:	85 c0                	test   %eax,%eax
801043f4:	74 19                	je     8010440f <piperead+0x3e>
      release(&p->lock);
801043f6:	8b 45 08             	mov    0x8(%ebp),%eax
801043f9:	83 ec 0c             	sub    $0xc,%esp
801043fc:	50                   	push   %eax
801043fd:	e8 c0 0d 00 00       	call   801051c2 <release>
80104402:	83 c4 10             	add    $0x10,%esp
      return -1;
80104405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010440a:	e9 bc 00 00 00       	jmp    801044cb <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010440f:	8b 45 08             	mov    0x8(%ebp),%eax
80104412:	8b 55 08             	mov    0x8(%ebp),%edx
80104415:	81 c2 34 02 00 00    	add    $0x234,%edx
8010441b:	83 ec 08             	sub    $0x8,%esp
8010441e:	50                   	push   %eax
8010441f:	52                   	push   %edx
80104420:	e8 4a 0a 00 00       	call   80104e6f <sleep>
80104425:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104428:	8b 45 08             	mov    0x8(%ebp),%eax
8010442b:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104431:	8b 45 08             	mov    0x8(%ebp),%eax
80104434:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010443a:	39 c2                	cmp    %eax,%edx
8010443c:	75 0d                	jne    8010444b <piperead+0x7a>
8010443e:	8b 45 08             	mov    0x8(%ebp),%eax
80104441:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104447:	85 c0                	test   %eax,%eax
80104449:	75 9e                	jne    801043e9 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010444b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104452:	eb 49                	jmp    8010449d <piperead+0xcc>
    if(p->nread == p->nwrite)
80104454:	8b 45 08             	mov    0x8(%ebp),%eax
80104457:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010445d:	8b 45 08             	mov    0x8(%ebp),%eax
80104460:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104466:	39 c2                	cmp    %eax,%edx
80104468:	75 02                	jne    8010446c <piperead+0x9b>
      break;
8010446a:	eb 39                	jmp    801044a5 <piperead+0xd4>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010446c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010446f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104472:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104475:	8b 45 08             	mov    0x8(%ebp),%eax
80104478:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010447e:	8d 48 01             	lea    0x1(%eax),%ecx
80104481:	8b 55 08             	mov    0x8(%ebp),%edx
80104484:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010448a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010448f:	89 c2                	mov    %eax,%edx
80104491:	8b 45 08             	mov    0x8(%ebp),%eax
80104494:	8a 44 10 34          	mov    0x34(%eax,%edx,1),%al
80104498:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010449a:	ff 45 f4             	incl   -0xc(%ebp)
8010449d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a0:	3b 45 10             	cmp    0x10(%ebp),%eax
801044a3:	7c af                	jl     80104454 <piperead+0x83>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044a5:	8b 45 08             	mov    0x8(%ebp),%eax
801044a8:	05 38 02 00 00       	add    $0x238,%eax
801044ad:	83 ec 0c             	sub    $0xc,%esp
801044b0:	50                   	push   %eax
801044b1:	e8 a2 0a 00 00       	call   80104f58 <wakeup>
801044b6:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044b9:	8b 45 08             	mov    0x8(%ebp),%eax
801044bc:	83 ec 0c             	sub    $0xc,%esp
801044bf:	50                   	push   %eax
801044c0:	e8 fd 0c 00 00       	call   801051c2 <release>
801044c5:	83 c4 10             	add    $0x10,%esp
  return i;
801044c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044ce:	c9                   	leave  
801044cf:	c3                   	ret    

801044d0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044d6:	9c                   	pushf  
801044d7:	58                   	pop    %eax
801044d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801044db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044de:	c9                   	leave  
801044df:	c3                   	ret    

801044e0 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801044e3:	fb                   	sti    
}
801044e4:	5d                   	pop    %ebp
801044e5:	c3                   	ret    

801044e6 <hlt>:

static inline void
hlt(void)
{
801044e6:	55                   	push   %ebp
801044e7:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801044e9:	f4                   	hlt    
}
801044ea:	5d                   	pop    %ebp
801044eb:	c3                   	ret    

801044ec <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801044ec:	55                   	push   %ebp
801044ed:	89 e5                	mov    %esp,%ebp
801044ef:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801044f2:	83 ec 08             	sub    $0x8,%esp
801044f5:	68 e5 8b 10 80       	push   $0x80108be5
801044fa:	68 40 33 11 80       	push   $0x80113340
801044ff:	e8 37 0c 00 00       	call   8010513b <initlock>
80104504:	83 c4 10             	add    $0x10,%esp
  // Seed RNG with current time
  sgenrand(unixtime());
80104507:	e8 b1 ed ff ff       	call   801032bd <unixtime>
8010450c:	83 ec 0c             	sub    $0xc,%esp
8010450f:	50                   	push   %eax
80104510:	e8 28 33 00 00       	call   8010783d <sgenrand>
80104515:	83 c4 10             	add    $0x10,%esp
}
80104518:	c9                   	leave  
80104519:	c3                   	ret    

8010451a <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010451a:	55                   	push   %ebp
8010451b:	89 e5                	mov    %esp,%ebp
8010451d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	68 40 33 11 80       	push   $0x80113340
80104528:	e8 2f 0c 00 00       	call   8010515c <acquire>
8010452d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104530:	c7 45 f4 74 33 11 80 	movl   $0x80113374,-0xc(%ebp)
80104537:	eb 54                	jmp    8010458d <allocproc+0x73>
    if(p->state == UNUSED)
80104539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453c:	8b 40 0c             	mov    0xc(%eax),%eax
8010453f:	85 c0                	test   %eax,%eax
80104541:	75 46                	jne    80104589 <allocproc+0x6f>
      goto found;
80104543:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104544:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104547:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010454e:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104553:	8d 50 01             	lea    0x1(%eax),%edx
80104556:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010455c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010455f:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104562:	83 ec 0c             	sub    $0xc,%esp
80104565:	68 40 33 11 80       	push   $0x80113340
8010456a:	e8 53 0c 00 00       	call   801051c2 <release>
8010456f:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104572:	e8 b1 e6 ff ff       	call   80102c28 <kalloc>
80104577:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010457a:	89 42 08             	mov    %eax,0x8(%edx)
8010457d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104580:	8b 40 08             	mov    0x8(%eax),%eax
80104583:	85 c0                	test   %eax,%eax
80104585:	75 37                	jne    801045be <allocproc+0xa4>
80104587:	eb 24                	jmp    801045ad <allocproc+0x93>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104589:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010458d:	81 7d f4 74 53 11 80 	cmpl   $0x80115374,-0xc(%ebp)
80104594:	72 a3                	jb     80104539 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	68 40 33 11 80       	push   $0x80113340
8010459e:	e8 1f 0c 00 00       	call   801051c2 <release>
801045a3:	83 c4 10             	add    $0x10,%esp
  return 0;
801045a6:	b8 00 00 00 00       	mov    $0x0,%eax
801045ab:	eb 6e                	jmp    8010461b <allocproc+0x101>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801045ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801045b7:	b8 00 00 00 00       	mov    $0x0,%eax
801045bc:	eb 5d                	jmp    8010461b <allocproc+0x101>
  }
  sp = p->kstack + KSTACKSIZE;
801045be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c1:	8b 40 08             	mov    0x8(%eax),%eax
801045c4:	05 00 10 00 00       	add    $0x1000,%eax
801045c9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801045cc:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045d6:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801045d9:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801045dd:	ba cd 67 10 80       	mov    $0x801067cd,%edx
801045e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045e5:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801045e7:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801045eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045f1:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801045f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f7:	8b 40 1c             	mov    0x1c(%eax),%eax
801045fa:	83 ec 04             	sub    $0x4,%esp
801045fd:	6a 14                	push   $0x14
801045ff:	6a 00                	push   $0x0
80104601:	50                   	push   %eax
80104602:	e8 ad 0d 00 00       	call   801053b4 <memset>
80104607:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010460a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104610:	ba 2a 4e 10 80       	mov    $0x80104e2a,%edx
80104615:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104618:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010461b:	c9                   	leave  
8010461c:	c3                   	ret    

8010461d <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010461d:	55                   	push   %ebp
8010461e:	89 e5                	mov    %esp,%ebp
80104620:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104623:	e8 f2 fe ff ff       	call   8010451a <allocproc>
80104628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010462b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462e:	a3 68 b6 10 80       	mov    %eax,0x8010b668
  if((p->pgdir = setupkvm()) == 0)
80104633:	e8 58 3a 00 00       	call   80108090 <setupkvm>
80104638:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010463b:	89 42 04             	mov    %eax,0x4(%edx)
8010463e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104641:	8b 40 04             	mov    0x4(%eax),%eax
80104644:	85 c0                	test   %eax,%eax
80104646:	75 0d                	jne    80104655 <userinit+0x38>
    panic("userinit: out of memory?");
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 ec 8b 10 80       	push   $0x80108bec
80104650:	e8 74 bf ff ff       	call   801005c9 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104655:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010465a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465d:	8b 40 04             	mov    0x4(%eax),%eax
80104660:	83 ec 04             	sub    $0x4,%esp
80104663:	52                   	push   %edx
80104664:	68 00 b5 10 80       	push   $0x8010b500
80104669:	50                   	push   %eax
8010466a:	e8 6a 3c 00 00       	call   801082d9 <inituvm>
8010466f:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104675:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010467b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467e:	8b 40 18             	mov    0x18(%eax),%eax
80104681:	83 ec 04             	sub    $0x4,%esp
80104684:	6a 4c                	push   $0x4c
80104686:	6a 00                	push   $0x0
80104688:	50                   	push   %eax
80104689:	e8 26 0d 00 00       	call   801053b4 <memset>
8010468e:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104694:	8b 40 18             	mov    0x18(%eax),%eax
80104697:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010469d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a0:	8b 40 18             	mov    0x18(%eax),%eax
801046a3:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801046a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ac:	8b 50 18             	mov    0x18(%eax),%edx
801046af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b2:	8b 40 18             	mov    0x18(%eax),%eax
801046b5:	8b 40 2c             	mov    0x2c(%eax),%eax
801046b8:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801046bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bf:	8b 50 18             	mov    0x18(%eax),%edx
801046c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c5:	8b 40 18             	mov    0x18(%eax),%eax
801046c8:	8b 40 2c             	mov    0x2c(%eax),%eax
801046cb:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801046cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d2:	8b 40 18             	mov    0x18(%eax),%eax
801046d5:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801046dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046df:	8b 40 18             	mov    0x18(%eax),%eax
801046e2:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801046e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ec:	8b 40 18             	mov    0x18(%eax),%eax
801046ef:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801046f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f9:	83 c0 6c             	add    $0x6c,%eax
801046fc:	83 ec 04             	sub    $0x4,%esp
801046ff:	6a 10                	push   $0x10
80104701:	68 05 8c 10 80       	push   $0x80108c05
80104706:	50                   	push   %eax
80104707:	e8 99 0e 00 00       	call   801055a5 <safestrcpy>
8010470c:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
8010470f:	83 ec 0c             	sub    $0xc,%esp
80104712:	68 0e 8c 10 80       	push   $0x80108c0e
80104717:	e8 ec dd ff ff       	call   80102508 <namei>
8010471c:	83 c4 10             	add    $0x10,%esp
8010471f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104722:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104728:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010472f:	c9                   	leave  
80104730:	c3                   	ret    

80104731 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104731:	55                   	push   %ebp
80104732:	89 e5                	mov    %esp,%ebp
80104734:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
80104737:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010473d:	8b 00                	mov    (%eax),%eax
8010473f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104742:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104746:	7e 31                	jle    80104779 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104748:	8b 55 08             	mov    0x8(%ebp),%edx
8010474b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474e:	01 c2                	add    %eax,%edx
80104750:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104756:	8b 40 04             	mov    0x4(%eax),%eax
80104759:	83 ec 04             	sub    $0x4,%esp
8010475c:	52                   	push   %edx
8010475d:	ff 75 f4             	pushl  -0xc(%ebp)
80104760:	50                   	push   %eax
80104761:	e8 bf 3c 00 00       	call   80108425 <allocuvm>
80104766:	83 c4 10             	add    $0x10,%esp
80104769:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010476c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104770:	75 3e                	jne    801047b0 <growproc+0x7f>
      return -1;
80104772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104777:	eb 59                	jmp    801047d2 <growproc+0xa1>
  } else if(n < 0){
80104779:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010477d:	79 31                	jns    801047b0 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010477f:	8b 55 08             	mov    0x8(%ebp),%edx
80104782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104785:	01 c2                	add    %eax,%edx
80104787:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478d:	8b 40 04             	mov    0x4(%eax),%eax
80104790:	83 ec 04             	sub    $0x4,%esp
80104793:	52                   	push   %edx
80104794:	ff 75 f4             	pushl  -0xc(%ebp)
80104797:	50                   	push   %eax
80104798:	e8 4f 3d 00 00       	call   801084ec <deallocuvm>
8010479d:	83 c4 10             	add    $0x10,%esp
801047a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047a7:	75 07                	jne    801047b0 <growproc+0x7f>
      return -1;
801047a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ae:	eb 22                	jmp    801047d2 <growproc+0xa1>
  }
  proc->sz = sz;
801047b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047b9:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801047bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	50                   	push   %eax
801047c5:	e8 ab 39 00 00       	call   80108175 <switchuvm>
801047ca:	83 c4 10             	add    $0x10,%esp
  return 0;
801047cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047d2:	c9                   	leave  
801047d3:	c3                   	ret    

801047d4 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801047d4:	55                   	push   %ebp
801047d5:	89 e5                	mov    %esp,%ebp
801047d7:	57                   	push   %edi
801047d8:	56                   	push   %esi
801047d9:	53                   	push   %ebx
801047da:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801047dd:	e8 38 fd ff ff       	call   8010451a <allocproc>
801047e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801047e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801047e9:	75 0a                	jne    801047f5 <fork+0x21>
    return -1;
801047eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f0:	e9 61 01 00 00       	jmp    80104956 <fork+0x182>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801047f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fb:	8b 10                	mov    (%eax),%edx
801047fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104803:	8b 40 04             	mov    0x4(%eax),%eax
80104806:	83 ec 08             	sub    $0x8,%esp
80104809:	52                   	push   %edx
8010480a:	50                   	push   %eax
8010480b:	e8 77 3e 00 00       	call   80108687 <copyuvm>
80104810:	83 c4 10             	add    $0x10,%esp
80104813:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104816:	89 42 04             	mov    %eax,0x4(%edx)
80104819:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481c:	8b 40 04             	mov    0x4(%eax),%eax
8010481f:	85 c0                	test   %eax,%eax
80104821:	75 30                	jne    80104853 <fork+0x7f>
    kfree(np->kstack);
80104823:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104826:	8b 40 08             	mov    0x8(%eax),%eax
80104829:	83 ec 0c             	sub    $0xc,%esp
8010482c:	50                   	push   %eax
8010482d:	e8 5a e3 ff ff       	call   80102b8c <kfree>
80104832:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104835:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104838:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010483f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104842:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010484e:	e9 03 01 00 00       	jmp    80104956 <fork+0x182>
  }
  np->sz = proc->sz;
80104853:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104859:	8b 10                	mov    (%eax),%edx
8010485b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010485e:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104860:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104867:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010486a:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010486d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104870:	8b 50 18             	mov    0x18(%eax),%edx
80104873:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104879:	8b 40 18             	mov    0x18(%eax),%eax
8010487c:	89 c3                	mov    %eax,%ebx
8010487e:	b8 13 00 00 00       	mov    $0x13,%eax
80104883:	89 d7                	mov    %edx,%edi
80104885:	89 de                	mov    %ebx,%esi
80104887:	89 c1                	mov    %eax,%ecx
80104889:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010488b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010488e:	8b 40 18             	mov    0x18(%eax),%eax
80104891:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104898:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010489f:	eb 40                	jmp    801048e1 <fork+0x10d>
    if(proc->ofile[i])
801048a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048aa:	83 c2 08             	add    $0x8,%edx
801048ad:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048b1:	85 c0                	test   %eax,%eax
801048b3:	74 29                	je     801048de <fork+0x10a>
      np->ofile[i] = filedup(proc->ofile[i]);
801048b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048be:	83 c2 08             	add    $0x8,%edx
801048c1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048c5:	83 ec 0c             	sub    $0xc,%esp
801048c8:	50                   	push   %eax
801048c9:	e8 44 c7 ff ff       	call   80101012 <filedup>
801048ce:	83 c4 10             	add    $0x10,%esp
801048d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801048d4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801048d7:	83 c1 08             	add    $0x8,%ecx
801048da:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801048de:	ff 45 e4             	incl   -0x1c(%ebp)
801048e1:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801048e5:	7e ba                	jle    801048a1 <fork+0xcd>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801048e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ed:	8b 40 68             	mov    0x68(%eax),%eax
801048f0:	83 ec 0c             	sub    $0xc,%esp
801048f3:	50                   	push   %eax
801048f4:	e8 23 d0 ff ff       	call   8010191c <idup>
801048f9:	83 c4 10             	add    $0x10,%esp
801048fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801048ff:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104902:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104908:	8d 50 6c             	lea    0x6c(%eax),%edx
8010490b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010490e:	83 c0 6c             	add    $0x6c,%eax
80104911:	83 ec 04             	sub    $0x4,%esp
80104914:	6a 10                	push   $0x10
80104916:	52                   	push   %edx
80104917:	50                   	push   %eax
80104918:	e8 88 0c 00 00       	call   801055a5 <safestrcpy>
8010491d:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104920:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104923:	8b 40 10             	mov    0x10(%eax),%eax
80104926:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104929:	83 ec 0c             	sub    $0xc,%esp
8010492c:	68 40 33 11 80       	push   $0x80113340
80104931:	e8 26 08 00 00       	call   8010515c <acquire>
80104936:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104939:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010493c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104943:	83 ec 0c             	sub    $0xc,%esp
80104946:	68 40 33 11 80       	push   $0x80113340
8010494b:	e8 72 08 00 00       	call   801051c2 <release>
80104950:	83 c4 10             	add    $0x10,%esp

  return pid;
80104953:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104956:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104959:	5b                   	pop    %ebx
8010495a:	5e                   	pop    %esi
8010495b:	5f                   	pop    %edi
8010495c:	5d                   	pop    %ebp
8010495d:	c3                   	ret    

8010495e <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010495e:	55                   	push   %ebp
8010495f:	89 e5                	mov    %esp,%ebp
80104961:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104964:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010496b:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104970:	39 c2                	cmp    %eax,%edx
80104972:	75 0d                	jne    80104981 <exit+0x23>
    panic("init exiting");
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	68 10 8c 10 80       	push   $0x80108c10
8010497c:	e8 48 bc ff ff       	call   801005c9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104988:	eb 47                	jmp    801049d1 <exit+0x73>
    if(proc->ofile[fd]){
8010498a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104990:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104993:	83 c2 08             	add    $0x8,%edx
80104996:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010499a:	85 c0                	test   %eax,%eax
8010499c:	74 30                	je     801049ce <exit+0x70>
      fileclose(proc->ofile[fd]);
8010499e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049a7:	83 c2 08             	add    $0x8,%edx
801049aa:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049ae:	83 ec 0c             	sub    $0xc,%esp
801049b1:	50                   	push   %eax
801049b2:	e8 ac c6 ff ff       	call   80101063 <fileclose>
801049b7:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801049ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049c3:	83 c2 08             	add    $0x8,%edx
801049c6:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801049cd:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801049ce:	ff 45 f0             	incl   -0x10(%ebp)
801049d1:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801049d5:	7e b3                	jle    8010498a <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801049d7:	e8 c5 eb ff ff       	call   801035a1 <begin_op>
  iput(proc->cwd);
801049dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e2:	8b 40 68             	mov    0x68(%eax),%eax
801049e5:	83 ec 0c             	sub    $0xc,%esp
801049e8:	50                   	push   %eax
801049e9:	e8 33 d1 ff ff       	call   80101b21 <iput>
801049ee:	83 c4 10             	add    $0x10,%esp
  end_op();
801049f1:	e8 37 ec ff ff       	call   8010362d <end_op>
  proc->cwd = 0;
801049f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049fc:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a03:	83 ec 0c             	sub    $0xc,%esp
80104a06:	68 40 33 11 80       	push   $0x80113340
80104a0b:	e8 4c 07 00 00       	call   8010515c <acquire>
80104a10:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104a13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a19:	8b 40 14             	mov    0x14(%eax),%eax
80104a1c:	83 ec 0c             	sub    $0xc,%esp
80104a1f:	50                   	push   %eax
80104a20:	e8 f5 04 00 00       	call   80104f1a <wakeup1>
80104a25:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a28:	c7 45 f4 74 33 11 80 	movl   $0x80113374,-0xc(%ebp)
80104a2f:	eb 3c                	jmp    80104a6d <exit+0x10f>
    if(p->parent == proc){
80104a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a34:	8b 50 14             	mov    0x14(%eax),%edx
80104a37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a3d:	39 c2                	cmp    %eax,%edx
80104a3f:	75 28                	jne    80104a69 <exit+0x10b>
      p->parent = initproc;
80104a41:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
80104a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4a:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a50:	8b 40 0c             	mov    0xc(%eax),%eax
80104a53:	83 f8 05             	cmp    $0x5,%eax
80104a56:	75 11                	jne    80104a69 <exit+0x10b>
        wakeup1(initproc);
80104a58:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104a5d:	83 ec 0c             	sub    $0xc,%esp
80104a60:	50                   	push   %eax
80104a61:	e8 b4 04 00 00       	call   80104f1a <wakeup1>
80104a66:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a69:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104a6d:	81 7d f4 74 53 11 80 	cmpl   $0x80115374,-0xc(%ebp)
80104a74:	72 bb                	jb     80104a31 <exit+0xd3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104a76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7c:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104a83:	e8 ad 02 00 00       	call   80104d35 <sched>
  panic("zombie exit");
80104a88:	83 ec 0c             	sub    $0xc,%esp
80104a8b:	68 1d 8c 10 80       	push   $0x80108c1d
80104a90:	e8 34 bb ff ff       	call   801005c9 <panic>

80104a95 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a95:	55                   	push   %ebp
80104a96:	89 e5                	mov    %esp,%ebp
80104a98:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	68 40 33 11 80       	push   $0x80113340
80104aa3:	e8 b4 06 00 00       	call   8010515c <acquire>
80104aa8:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ab2:	c7 45 f4 74 33 11 80 	movl   $0x80113374,-0xc(%ebp)
80104ab9:	e9 a6 00 00 00       	jmp    80104b64 <wait+0xcf>
      if(p->parent != proc)
80104abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac1:	8b 50 14             	mov    0x14(%eax),%edx
80104ac4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aca:	39 c2                	cmp    %eax,%edx
80104acc:	74 05                	je     80104ad3 <wait+0x3e>
        continue;
80104ace:	e9 8d 00 00 00       	jmp    80104b60 <wait+0xcb>
      havekids = 1;
80104ad3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104add:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae0:	83 f8 05             	cmp    $0x5,%eax
80104ae3:	75 7b                	jne    80104b60 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae8:	8b 40 10             	mov    0x10(%eax),%eax
80104aeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af1:	8b 40 08             	mov    0x8(%eax),%eax
80104af4:	83 ec 0c             	sub    $0xc,%esp
80104af7:	50                   	push   %eax
80104af8:	e8 8f e0 ff ff       	call   80102b8c <kfree>
80104afd:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0d:	8b 40 04             	mov    0x4(%eax),%eax
80104b10:	83 ec 0c             	sub    $0xc,%esp
80104b13:	50                   	push   %eax
80104b14:	e8 90 3a 00 00       	call   801085a9 <freevm>
80104b19:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b29:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b33:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b44:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104b4b:	83 ec 0c             	sub    $0xc,%esp
80104b4e:	68 40 33 11 80       	push   $0x80113340
80104b53:	e8 6a 06 00 00       	call   801051c2 <release>
80104b58:	83 c4 10             	add    $0x10,%esp
        return pid;
80104b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b5e:	eb 57                	jmp    80104bb7 <wait+0x122>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b60:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104b64:	81 7d f4 74 53 11 80 	cmpl   $0x80115374,-0xc(%ebp)
80104b6b:	0f 82 4d ff ff ff    	jb     80104abe <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104b71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b75:	74 0d                	je     80104b84 <wait+0xef>
80104b77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b7d:	8b 40 24             	mov    0x24(%eax),%eax
80104b80:	85 c0                	test   %eax,%eax
80104b82:	74 17                	je     80104b9b <wait+0x106>
      release(&ptable.lock);
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	68 40 33 11 80       	push   $0x80113340
80104b8c:	e8 31 06 00 00       	call   801051c2 <release>
80104b91:	83 c4 10             	add    $0x10,%esp
      return -1;
80104b94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b99:	eb 1c                	jmp    80104bb7 <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104b9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba1:	83 ec 08             	sub    $0x8,%esp
80104ba4:	68 40 33 11 80       	push   $0x80113340
80104ba9:	50                   	push   %eax
80104baa:	e8 c0 02 00 00       	call   80104e6f <sleep>
80104baf:	83 c4 10             	add    $0x10,%esp
  }
80104bb2:	e9 f4 fe ff ff       	jmp    80104aab <wait+0x16>
}
80104bb7:	c9                   	leave  
80104bb8:	c3                   	ret    

80104bb9 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104bb9:	55                   	push   %ebp
80104bba:	89 e5                	mov    %esp,%ebp
80104bbc:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int foundproc = 1;
80104bbf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

  long total_tickets = 0;
80104bc6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  long counter = 0;
80104bcd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  long winner;

  int got_total = 0; // 0 is False, 1 is True
80104bd4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  int winner_found = 0;
80104bdb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  for(;;){
    // Enable interrupts on this processor.

    sti();
80104be2:	e8 f9 f8 ff ff       	call   801044e0 <sti>

    if (!foundproc) hlt();
80104be7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104beb:	75 05                	jne    80104bf2 <scheduler+0x39>
80104bed:	e8 f4 f8 ff ff       	call   801044e6 <hlt>
    if (got_total == 1) {
80104bf2:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
80104bf6:	75 2d                	jne    80104c25 <scheduler+0x6c>
         foundproc = 0;
80104bf8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
         winner = random_at_most(total_tickets);
80104bff:	83 ec 0c             	sub    $0xc,%esp
80104c02:	ff 75 ec             	pushl  -0x14(%ebp)
80104c05:	e8 38 2e 00 00       	call   80107a42 <random_at_most>
80104c0a:	83 c4 10             	add    $0x10,%esp
80104c0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
         total_tickets = 0;
80104c10:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
         counter = 0;
80104c17:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
         winner_found = 0;
80104c1e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    }

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104c25:	83 ec 0c             	sub    $0xc,%esp
80104c28:	68 40 33 11 80       	push   $0x80113340
80104c2d:	e8 2a 05 00 00       	call   8010515c <acquire>
80104c32:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c35:	c7 45 f4 74 33 11 80 	movl   $0x80113374,-0xc(%ebp)
80104c3c:	e9 cb 00 00 00       	jmp    80104d0c <scheduler+0x153>

      if(p->state != RUNNABLE) {
80104c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c44:	8b 40 0c             	mov    0xc(%eax),%eax
80104c47:	83 f8 03             	cmp    $0x3,%eax
80104c4a:	74 05                	je     80104c51 <scheduler+0x98>
            continue;
80104c4c:	e9 b7 00 00 00       	jmp    80104d08 <scheduler+0x14f>
      }
      // Or first time running the loop. Must find total tickets
      // Continue to prevent process from being ran because it's not fair
      if (got_total == 0) {
80104c51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104c55:	75 0e                	jne    80104c65 <scheduler+0xac>
            total_tickets += p->tickets;
80104c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5a:	8b 40 7c             	mov    0x7c(%eax),%eax
80104c5d:	01 45 ec             	add    %eax,-0x14(%ebp)
            continue;
80104c60:	e9 a3 00 00 00       	jmp    80104d08 <scheduler+0x14f>
      }

      counter += p->tickets;
80104c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c68:	8b 40 7c             	mov    0x7c(%eax),%eax
80104c6b:	01 45 e8             	add    %eax,-0x18(%ebp)

      if (counter < winner) {
80104c6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104c71:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80104c74:	7d 0e                	jge    80104c84 <scheduler+0xcb>
            // Runnable but not winner. State doesn't change. Tickets valid for next round
            total_tickets += p->tickets;
80104c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c79:	8b 40 7c             	mov    0x7c(%eax),%eax
80104c7c:	01 45 ec             	add    %eax,-0x14(%ebp)
            continue;
80104c7f:	e9 84 00 00 00       	jmp    80104d08 <scheduler+0x14f>
      }

      if (winner_found) {
80104c84:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104c88:	74 0b                	je     80104c95 <scheduler+0xdc>
            total_tickets += p->tickets;
80104c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8d:	8b 40 7c             	mov    0x7c(%eax),%eax
80104c90:	01 45 ec             	add    %eax,-0x14(%ebp)
            continue;
80104c93:	eb 73                	jmp    80104d08 <scheduler+0x14f>
      }

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      foundproc = 1;
80104c95:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      proc = p;
80104c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c9f:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104ca5:	83 ec 0c             	sub    $0xc,%esp
80104ca8:	ff 75 f4             	pushl  -0xc(%ebp)
80104cab:	e8 c5 34 00 00       	call   80108175 <switchuvm>
80104cb0:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb6:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104cbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc3:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cc6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ccd:	83 c2 04             	add    $0x4,%edx
80104cd0:	83 ec 08             	sub    $0x8,%esp
80104cd3:	50                   	push   %eax
80104cd4:	52                   	push   %edx
80104cd5:	e8 37 09 00 00       	call   80105611 <swtch>
80104cda:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104cdd:	e8 77 34 00 00       	call   80108159 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.

      //If it's still runnable, it it should be added to total tickets
      if (p->state == RUNNABLE) {
80104ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce5:	8b 40 0c             	mov    0xc(%eax),%eax
80104ce8:	83 f8 03             	cmp    $0x3,%eax
80104ceb:	75 10                	jne    80104cfd <scheduler+0x144>
            total_tickets += p->tickets;
80104ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf0:	8b 40 7c             	mov    0x7c(%eax),%eax
80104cf3:	01 45 ec             	add    %eax,-0x14(%ebp)

      winner_found = 1;
80104cf6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)

      }
      proc = 0;
80104cfd:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104d04:	00 00 00 00 
         winner_found = 0;
    }

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d08:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104d0c:	81 7d f4 74 53 11 80 	cmpl   $0x80115374,-0xc(%ebp)
80104d13:	0f 82 28 ff ff ff    	jb     80104c41 <scheduler+0x88>
      winner_found = 1;

      }
      proc = 0;
    }
    release(&ptable.lock);
80104d19:	83 ec 0c             	sub    $0xc,%esp
80104d1c:	68 40 33 11 80       	push   $0x80113340
80104d21:	e8 9c 04 00 00       	call   801051c2 <release>
80104d26:	83 c4 10             	add    $0x10,%esp
    got_total = 1;
80104d29:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

  }
80104d30:	e9 ad fe ff ff       	jmp    80104be2 <scheduler+0x29>

80104d35 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d35:	55                   	push   %ebp
80104d36:	89 e5                	mov    %esp,%ebp
80104d38:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d3b:	83 ec 0c             	sub    $0xc,%esp
80104d3e:	68 40 33 11 80       	push   $0x80113340
80104d43:	e8 42 05 00 00       	call   8010528a <holding>
80104d48:	83 c4 10             	add    $0x10,%esp
80104d4b:	85 c0                	test   %eax,%eax
80104d4d:	75 0d                	jne    80104d5c <sched+0x27>
    panic("sched ptable.lock");
80104d4f:	83 ec 0c             	sub    $0xc,%esp
80104d52:	68 29 8c 10 80       	push   $0x80108c29
80104d57:	e8 6d b8 ff ff       	call   801005c9 <panic>
  if(cpu->ncli != 1)
80104d5c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d62:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d68:	83 f8 01             	cmp    $0x1,%eax
80104d6b:	74 0d                	je     80104d7a <sched+0x45>
    panic("sched locks");
80104d6d:	83 ec 0c             	sub    $0xc,%esp
80104d70:	68 3b 8c 10 80       	push   $0x80108c3b
80104d75:	e8 4f b8 ff ff       	call   801005c9 <panic>
  if(proc->state == RUNNING)
80104d7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d80:	8b 40 0c             	mov    0xc(%eax),%eax
80104d83:	83 f8 04             	cmp    $0x4,%eax
80104d86:	75 0d                	jne    80104d95 <sched+0x60>
    panic("sched running");
80104d88:	83 ec 0c             	sub    $0xc,%esp
80104d8b:	68 47 8c 10 80       	push   $0x80108c47
80104d90:	e8 34 b8 ff ff       	call   801005c9 <panic>
  if(readeflags()&FL_IF)
80104d95:	e8 36 f7 ff ff       	call   801044d0 <readeflags>
80104d9a:	25 00 02 00 00       	and    $0x200,%eax
80104d9f:	85 c0                	test   %eax,%eax
80104da1:	74 0d                	je     80104db0 <sched+0x7b>
    panic("sched interruptible");
80104da3:	83 ec 0c             	sub    $0xc,%esp
80104da6:	68 55 8c 10 80       	push   $0x80108c55
80104dab:	e8 19 b8 ff ff       	call   801005c9 <panic>
  intena = cpu->intena;
80104db0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104db6:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104dbf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dc5:	8b 40 04             	mov    0x4(%eax),%eax
80104dc8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104dcf:	83 c2 1c             	add    $0x1c,%edx
80104dd2:	83 ec 08             	sub    $0x8,%esp
80104dd5:	50                   	push   %eax
80104dd6:	52                   	push   %edx
80104dd7:	e8 35 08 00 00       	call   80105611 <swtch>
80104ddc:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104ddf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104de8:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dee:	c9                   	leave  
80104def:	c3                   	ret    

80104df0 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104df6:	83 ec 0c             	sub    $0xc,%esp
80104df9:	68 40 33 11 80       	push   $0x80113340
80104dfe:	e8 59 03 00 00       	call   8010515c <acquire>
80104e03:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104e06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e0c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104e13:	e8 1d ff ff ff       	call   80104d35 <sched>
  release(&ptable.lock);
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	68 40 33 11 80       	push   $0x80113340
80104e20:	e8 9d 03 00 00       	call   801051c2 <release>
80104e25:	83 c4 10             	add    $0x10,%esp
}
80104e28:	c9                   	leave  
80104e29:	c3                   	ret    

80104e2a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e2a:	55                   	push   %ebp
80104e2b:	89 e5                	mov    %esp,%ebp
80104e2d:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e30:	83 ec 0c             	sub    $0xc,%esp
80104e33:	68 40 33 11 80       	push   $0x80113340
80104e38:	e8 85 03 00 00       	call   801051c2 <release>
80104e3d:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e40:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104e45:	85 c0                	test   %eax,%eax
80104e47:	74 24                	je     80104e6d <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104e49:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104e50:	00 00 00 
    iinit(ROOTDEV);
80104e53:	83 ec 0c             	sub    $0xc,%esp
80104e56:	6a 01                	push   $0x1
80104e58:	e8 d5 c7 ff ff       	call   80101632 <iinit>
80104e5d:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104e60:	83 ec 0c             	sub    $0xc,%esp
80104e63:	6a 01                	push   $0x1
80104e65:	e8 23 e5 ff ff       	call   8010338d <initlog>
80104e6a:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104e6d:	c9                   	leave  
80104e6e:	c3                   	ret    

80104e6f <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e6f:	55                   	push   %ebp
80104e70:	89 e5                	mov    %esp,%ebp
80104e72:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104e75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	75 0d                	jne    80104e8c <sleep+0x1d>
    panic("sleep");
80104e7f:	83 ec 0c             	sub    $0xc,%esp
80104e82:	68 69 8c 10 80       	push   $0x80108c69
80104e87:	e8 3d b7 ff ff       	call   801005c9 <panic>

  if(lk == 0)
80104e8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e90:	75 0d                	jne    80104e9f <sleep+0x30>
    panic("sleep without lk");
80104e92:	83 ec 0c             	sub    $0xc,%esp
80104e95:	68 6f 8c 10 80       	push   $0x80108c6f
80104e9a:	e8 2a b7 ff ff       	call   801005c9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e9f:	81 7d 0c 40 33 11 80 	cmpl   $0x80113340,0xc(%ebp)
80104ea6:	74 1e                	je     80104ec6 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ea8:	83 ec 0c             	sub    $0xc,%esp
80104eab:	68 40 33 11 80       	push   $0x80113340
80104eb0:	e8 a7 02 00 00       	call   8010515c <acquire>
80104eb5:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104eb8:	83 ec 0c             	sub    $0xc,%esp
80104ebb:	ff 75 0c             	pushl  0xc(%ebp)
80104ebe:	e8 ff 02 00 00       	call   801051c2 <release>
80104ec3:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104ec6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ecc:	8b 55 08             	mov    0x8(%ebp),%edx
80104ecf:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104ed2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ed8:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104edf:	e8 51 fe ff ff       	call   80104d35 <sched>

  // Tidy up.
  proc->chan = 0;
80104ee4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eea:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104ef1:	81 7d 0c 40 33 11 80 	cmpl   $0x80113340,0xc(%ebp)
80104ef8:	74 1e                	je     80104f18 <sleep+0xa9>
    release(&ptable.lock);
80104efa:	83 ec 0c             	sub    $0xc,%esp
80104efd:	68 40 33 11 80       	push   $0x80113340
80104f02:	e8 bb 02 00 00       	call   801051c2 <release>
80104f07:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104f0a:	83 ec 0c             	sub    $0xc,%esp
80104f0d:	ff 75 0c             	pushl  0xc(%ebp)
80104f10:	e8 47 02 00 00       	call   8010515c <acquire>
80104f15:	83 c4 10             	add    $0x10,%esp
  }
}
80104f18:	c9                   	leave  
80104f19:	c3                   	ret    

80104f1a <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f1a:	55                   	push   %ebp
80104f1b:	89 e5                	mov    %esp,%ebp
80104f1d:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f20:	c7 45 fc 74 33 11 80 	movl   $0x80113374,-0x4(%ebp)
80104f27:	eb 24                	jmp    80104f4d <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f2c:	8b 40 0c             	mov    0xc(%eax),%eax
80104f2f:	83 f8 02             	cmp    $0x2,%eax
80104f32:	75 15                	jne    80104f49 <wakeup1+0x2f>
80104f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f37:	8b 40 20             	mov    0x20(%eax),%eax
80104f3a:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f3d:	75 0a                	jne    80104f49 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f42:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f49:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104f4d:	81 7d fc 74 53 11 80 	cmpl   $0x80115374,-0x4(%ebp)
80104f54:	72 d3                	jb     80104f29 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104f56:	c9                   	leave  
80104f57:	c3                   	ret    

80104f58 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f58:	55                   	push   %ebp
80104f59:	89 e5                	mov    %esp,%ebp
80104f5b:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104f5e:	83 ec 0c             	sub    $0xc,%esp
80104f61:	68 40 33 11 80       	push   $0x80113340
80104f66:	e8 f1 01 00 00       	call   8010515c <acquire>
80104f6b:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104f6e:	83 ec 0c             	sub    $0xc,%esp
80104f71:	ff 75 08             	pushl  0x8(%ebp)
80104f74:	e8 a1 ff ff ff       	call   80104f1a <wakeup1>
80104f79:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104f7c:	83 ec 0c             	sub    $0xc,%esp
80104f7f:	68 40 33 11 80       	push   $0x80113340
80104f84:	e8 39 02 00 00       	call   801051c2 <release>
80104f89:	83 c4 10             	add    $0x10,%esp
}
80104f8c:	c9                   	leave  
80104f8d:	c3                   	ret    

80104f8e <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f8e:	55                   	push   %ebp
80104f8f:	89 e5                	mov    %esp,%ebp
80104f91:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104f94:	83 ec 0c             	sub    $0xc,%esp
80104f97:	68 40 33 11 80       	push   $0x80113340
80104f9c:	e8 bb 01 00 00       	call   8010515c <acquire>
80104fa1:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fa4:	c7 45 f4 74 33 11 80 	movl   $0x80113374,-0xc(%ebp)
80104fab:	eb 45                	jmp    80104ff2 <kill+0x64>
    if(p->pid == pid){
80104fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb0:	8b 40 10             	mov    0x10(%eax),%eax
80104fb3:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fb6:	75 36                	jne    80104fee <kill+0x60>
      p->killed = 1;
80104fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc5:	8b 40 0c             	mov    0xc(%eax),%eax
80104fc8:	83 f8 02             	cmp    $0x2,%eax
80104fcb:	75 0a                	jne    80104fd7 <kill+0x49>
        p->state = RUNNABLE;
80104fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104fd7:	83 ec 0c             	sub    $0xc,%esp
80104fda:	68 40 33 11 80       	push   $0x80113340
80104fdf:	e8 de 01 00 00       	call   801051c2 <release>
80104fe4:	83 c4 10             	add    $0x10,%esp
      return 0;
80104fe7:	b8 00 00 00 00       	mov    $0x0,%eax
80104fec:	eb 22                	jmp    80105010 <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fee:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104ff2:	81 7d f4 74 53 11 80 	cmpl   $0x80115374,-0xc(%ebp)
80104ff9:	72 b2                	jb     80104fad <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104ffb:	83 ec 0c             	sub    $0xc,%esp
80104ffe:	68 40 33 11 80       	push   $0x80113340
80105003:	e8 ba 01 00 00       	call   801051c2 <release>
80105008:	83 c4 10             	add    $0x10,%esp
  return -1;
8010500b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105010:	c9                   	leave  
80105011:	c3                   	ret    

80105012 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105012:	55                   	push   %ebp
80105013:	89 e5                	mov    %esp,%ebp
80105015:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105018:	c7 45 f0 74 33 11 80 	movl   $0x80113374,-0x10(%ebp)
8010501f:	e9 d2 00 00 00       	jmp    801050f6 <procdump+0xe4>
    if(p->state == UNUSED)
80105024:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105027:	8b 40 0c             	mov    0xc(%eax),%eax
8010502a:	85 c0                	test   %eax,%eax
8010502c:	75 05                	jne    80105033 <procdump+0x21>
      continue;
8010502e:	e9 bf 00 00 00       	jmp    801050f2 <procdump+0xe0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105033:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105036:	8b 40 0c             	mov    0xc(%eax),%eax
80105039:	83 f8 05             	cmp    $0x5,%eax
8010503c:	77 23                	ja     80105061 <procdump+0x4f>
8010503e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105041:	8b 40 0c             	mov    0xc(%eax),%eax
80105044:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
8010504b:	85 c0                	test   %eax,%eax
8010504d:	74 12                	je     80105061 <procdump+0x4f>
      state = states[p->state];
8010504f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105052:	8b 40 0c             	mov    0xc(%eax),%eax
80105055:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
8010505c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010505f:	eb 07                	jmp    80105068 <procdump+0x56>
    else
      state = "???";
80105061:	c7 45 ec 80 8c 10 80 	movl   $0x80108c80,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105068:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010506b:	8d 50 6c             	lea    0x6c(%eax),%edx
8010506e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105071:	8b 40 10             	mov    0x10(%eax),%eax
80105074:	52                   	push   %edx
80105075:	ff 75 ec             	pushl  -0x14(%ebp)
80105078:	50                   	push   %eax
80105079:	68 84 8c 10 80       	push   $0x80108c84
8010507e:	e8 88 b3 ff ff       	call   8010040b <cprintf>
80105083:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105086:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105089:	8b 40 0c             	mov    0xc(%eax),%eax
8010508c:	83 f8 02             	cmp    $0x2,%eax
8010508f:	75 51                	jne    801050e2 <procdump+0xd0>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105091:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105094:	8b 40 1c             	mov    0x1c(%eax),%eax
80105097:	8b 40 0c             	mov    0xc(%eax),%eax
8010509a:	83 c0 08             	add    $0x8,%eax
8010509d:	83 ec 08             	sub    $0x8,%esp
801050a0:	8d 55 c4             	lea    -0x3c(%ebp),%edx
801050a3:	52                   	push   %edx
801050a4:	50                   	push   %eax
801050a5:	e8 69 01 00 00       	call   80105213 <getcallerpcs>
801050aa:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801050ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801050b4:	eb 1b                	jmp    801050d1 <procdump+0xbf>
        cprintf(" %p", pc[i]);
801050b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b9:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050bd:	83 ec 08             	sub    $0x8,%esp
801050c0:	50                   	push   %eax
801050c1:	68 8d 8c 10 80       	push   $0x80108c8d
801050c6:	e8 40 b3 ff ff       	call   8010040b <cprintf>
801050cb:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801050ce:	ff 45 f4             	incl   -0xc(%ebp)
801050d1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801050d5:	7f 0b                	jg     801050e2 <procdump+0xd0>
801050d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050da:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050de:	85 c0                	test   %eax,%eax
801050e0:	75 d4                	jne    801050b6 <procdump+0xa4>
        cprintf(" %p", pc[i]);
    }
    // cprintf(" %d", p->tickets);
    // cprintf(" %d", winning_ticket);
    // cprintf(" %d", total_tickets);
    cprintf("\n");
801050e2:	83 ec 0c             	sub    $0xc,%esp
801050e5:	68 91 8c 10 80       	push   $0x80108c91
801050ea:	e8 1c b3 ff ff       	call   8010040b <cprintf>
801050ef:	83 c4 10             	add    $0x10,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050f2:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
801050f6:	81 7d f0 74 53 11 80 	cmpl   $0x80115374,-0x10(%ebp)
801050fd:	0f 82 21 ff ff ff    	jb     80105024 <procdump+0x12>
    // cprintf(" %d", p->tickets);
    // cprintf(" %d", winning_ticket);
    // cprintf(" %d", total_tickets);
    cprintf("\n");
  }
}
80105103:	c9                   	leave  
80105104:	c3                   	ret    

80105105 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105105:	55                   	push   %ebp
80105106:	89 e5                	mov    %esp,%ebp
80105108:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010510b:	9c                   	pushf  
8010510c:	58                   	pop    %eax
8010510d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105113:	c9                   	leave  
80105114:	c3                   	ret    

80105115 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105115:	55                   	push   %ebp
80105116:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105118:	fa                   	cli    
}
80105119:	5d                   	pop    %ebp
8010511a:	c3                   	ret    

8010511b <sti>:

static inline void
sti(void)
{
8010511b:	55                   	push   %ebp
8010511c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010511e:	fb                   	sti    
}
8010511f:	5d                   	pop    %ebp
80105120:	c3                   	ret    

80105121 <xchg>:
    return ret;
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105121:	55                   	push   %ebp
80105122:	89 e5                	mov    %esp,%ebp
80105124:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105127:	8b 55 08             	mov    0x8(%ebp),%edx
8010512a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010512d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105130:	f0 87 02             	lock xchg %eax,(%edx)
80105133:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105136:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105139:	c9                   	leave  
8010513a:	c3                   	ret    

8010513b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010513b:	55                   	push   %ebp
8010513c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010513e:	8b 45 08             	mov    0x8(%ebp),%eax
80105141:	8b 55 0c             	mov    0xc(%ebp),%edx
80105144:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105147:	8b 45 08             	mov    0x8(%ebp),%eax
8010514a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105150:	8b 45 08             	mov    0x8(%ebp),%eax
80105153:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010515a:	5d                   	pop    %ebp
8010515b:	c3                   	ret    

8010515c <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010515c:	55                   	push   %ebp
8010515d:	89 e5                	mov    %esp,%ebp
8010515f:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105162:	e8 4d 01 00 00       	call   801052b4 <pushcli>
  if(holding(lk))
80105167:	8b 45 08             	mov    0x8(%ebp),%eax
8010516a:	83 ec 0c             	sub    $0xc,%esp
8010516d:	50                   	push   %eax
8010516e:	e8 17 01 00 00       	call   8010528a <holding>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	74 0d                	je     80105187 <acquire+0x2b>
    panic("acquire");
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	68 bd 8c 10 80       	push   $0x80108cbd
80105182:	e8 42 b4 ff ff       	call   801005c9 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105187:	90                   	nop
80105188:	8b 45 08             	mov    0x8(%ebp),%eax
8010518b:	83 ec 08             	sub    $0x8,%esp
8010518e:	6a 01                	push   $0x1
80105190:	50                   	push   %eax
80105191:	e8 8b ff ff ff       	call   80105121 <xchg>
80105196:	83 c4 10             	add    $0x10,%esp
80105199:	85 c0                	test   %eax,%eax
8010519b:	75 eb                	jne    80105188 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010519d:	8b 45 08             	mov    0x8(%ebp),%eax
801051a0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801051a7:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801051aa:	8b 45 08             	mov    0x8(%ebp),%eax
801051ad:	83 c0 0c             	add    $0xc,%eax
801051b0:	83 ec 08             	sub    $0x8,%esp
801051b3:	50                   	push   %eax
801051b4:	8d 45 08             	lea    0x8(%ebp),%eax
801051b7:	50                   	push   %eax
801051b8:	e8 56 00 00 00       	call   80105213 <getcallerpcs>
801051bd:	83 c4 10             	add    $0x10,%esp
}
801051c0:	c9                   	leave  
801051c1:	c3                   	ret    

801051c2 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801051c2:	55                   	push   %ebp
801051c3:	89 e5                	mov    %esp,%ebp
801051c5:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801051c8:	83 ec 0c             	sub    $0xc,%esp
801051cb:	ff 75 08             	pushl  0x8(%ebp)
801051ce:	e8 b7 00 00 00       	call   8010528a <holding>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	85 c0                	test   %eax,%eax
801051d8:	75 0d                	jne    801051e7 <release+0x25>
    panic("release");
801051da:	83 ec 0c             	sub    $0xc,%esp
801051dd:	68 c5 8c 10 80       	push   $0x80108cc5
801051e2:	e8 e2 b3 ff ff       	call   801005c9 <panic>

  lk->pcs[0] = 0;
801051e7:	8b 45 08             	mov    0x8(%ebp),%eax
801051ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801051f1:	8b 45 08             	mov    0x8(%ebp),%eax
801051f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801051fb:	8b 45 08             	mov    0x8(%ebp),%eax
801051fe:	83 ec 08             	sub    $0x8,%esp
80105201:	6a 00                	push   $0x0
80105203:	50                   	push   %eax
80105204:	e8 18 ff ff ff       	call   80105121 <xchg>
80105209:	83 c4 10             	add    $0x10,%esp

  popcli();
8010520c:	e8 e7 00 00 00       	call   801052f8 <popcli>
}
80105211:	c9                   	leave  
80105212:	c3                   	ret    

80105213 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105213:	55                   	push   %ebp
80105214:	89 e5                	mov    %esp,%ebp
80105216:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105219:	8b 45 08             	mov    0x8(%ebp),%eax
8010521c:	83 e8 08             	sub    $0x8,%eax
8010521f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105222:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105229:	eb 37                	jmp    80105262 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010522b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010522f:	74 37                	je     80105268 <getcallerpcs+0x55>
80105231:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105238:	76 2e                	jbe    80105268 <getcallerpcs+0x55>
8010523a:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010523e:	74 28                	je     80105268 <getcallerpcs+0x55>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105240:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105243:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010524a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010524d:	01 c2                	add    %eax,%edx
8010524f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105252:	8b 40 04             	mov    0x4(%eax),%eax
80105255:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105257:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010525a:	8b 00                	mov    (%eax),%eax
8010525c:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010525f:	ff 45 f8             	incl   -0x8(%ebp)
80105262:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105266:	7e c3                	jle    8010522b <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105268:	eb 18                	jmp    80105282 <getcallerpcs+0x6f>
    pcs[i] = 0;
8010526a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010526d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105274:	8b 45 0c             	mov    0xc(%ebp),%eax
80105277:	01 d0                	add    %edx,%eax
80105279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010527f:	ff 45 f8             	incl   -0x8(%ebp)
80105282:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105286:	7e e2                	jle    8010526a <getcallerpcs+0x57>
    pcs[i] = 0;
}
80105288:	c9                   	leave  
80105289:	c3                   	ret    

8010528a <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010528a:	55                   	push   %ebp
8010528b:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010528d:	8b 45 08             	mov    0x8(%ebp),%eax
80105290:	8b 00                	mov    (%eax),%eax
80105292:	85 c0                	test   %eax,%eax
80105294:	74 17                	je     801052ad <holding+0x23>
80105296:	8b 45 08             	mov    0x8(%ebp),%eax
80105299:	8b 50 08             	mov    0x8(%eax),%edx
8010529c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052a2:	39 c2                	cmp    %eax,%edx
801052a4:	75 07                	jne    801052ad <holding+0x23>
801052a6:	b8 01 00 00 00       	mov    $0x1,%eax
801052ab:	eb 05                	jmp    801052b2 <holding+0x28>
801052ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052b2:	5d                   	pop    %ebp
801052b3:	c3                   	ret    

801052b4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801052ba:	e8 46 fe ff ff       	call   80105105 <readeflags>
801052bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801052c2:	e8 4e fe ff ff       	call   80105115 <cli>
  if(cpu->ncli++ == 0)
801052c7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052ce:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801052d4:	8d 48 01             	lea    0x1(%eax),%ecx
801052d7:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801052dd:	85 c0                	test   %eax,%eax
801052df:	75 15                	jne    801052f6 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801052e1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052ea:	81 e2 00 02 00 00    	and    $0x200,%edx
801052f0:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801052f6:	c9                   	leave  
801052f7:	c3                   	ret    

801052f8 <popcli>:

void
popcli(void)
{
801052f8:	55                   	push   %ebp
801052f9:	89 e5                	mov    %esp,%ebp
801052fb:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801052fe:	e8 02 fe ff ff       	call   80105105 <readeflags>
80105303:	25 00 02 00 00       	and    $0x200,%eax
80105308:	85 c0                	test   %eax,%eax
8010530a:	74 0d                	je     80105319 <popcli+0x21>
    panic("popcli - interruptible");
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	68 cd 8c 10 80       	push   $0x80108ccd
80105314:	e8 b0 b2 ff ff       	call   801005c9 <panic>
  if(--cpu->ncli < 0)
80105319:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010531f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105325:	4a                   	dec    %edx
80105326:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010532c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105332:	85 c0                	test   %eax,%eax
80105334:	79 0d                	jns    80105343 <popcli+0x4b>
    panic("popcli");
80105336:	83 ec 0c             	sub    $0xc,%esp
80105339:	68 e4 8c 10 80       	push   $0x80108ce4
8010533e:	e8 86 b2 ff ff       	call   801005c9 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105343:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105349:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010534f:	85 c0                	test   %eax,%eax
80105351:	75 15                	jne    80105368 <popcli+0x70>
80105353:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105359:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010535f:	85 c0                	test   %eax,%eax
80105361:	74 05                	je     80105368 <popcli+0x70>
    sti();
80105363:	e8 b3 fd ff ff       	call   8010511b <sti>
}
80105368:	c9                   	leave  
80105369:	c3                   	ret    

8010536a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010536a:	55                   	push   %ebp
8010536b:	89 e5                	mov    %esp,%ebp
8010536d:	57                   	push   %edi
8010536e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010536f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105372:	8b 55 10             	mov    0x10(%ebp),%edx
80105375:	8b 45 0c             	mov    0xc(%ebp),%eax
80105378:	89 cb                	mov    %ecx,%ebx
8010537a:	89 df                	mov    %ebx,%edi
8010537c:	89 d1                	mov    %edx,%ecx
8010537e:	fc                   	cld    
8010537f:	f3 aa                	rep stos %al,%es:(%edi)
80105381:	89 ca                	mov    %ecx,%edx
80105383:	89 fb                	mov    %edi,%ebx
80105385:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105388:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010538b:	5b                   	pop    %ebx
8010538c:	5f                   	pop    %edi
8010538d:	5d                   	pop    %ebp
8010538e:	c3                   	ret    

8010538f <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010538f:	55                   	push   %ebp
80105390:	89 e5                	mov    %esp,%ebp
80105392:	57                   	push   %edi
80105393:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105394:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105397:	8b 55 10             	mov    0x10(%ebp),%edx
8010539a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010539d:	89 cb                	mov    %ecx,%ebx
8010539f:	89 df                	mov    %ebx,%edi
801053a1:	89 d1                	mov    %edx,%ecx
801053a3:	fc                   	cld    
801053a4:	f3 ab                	rep stos %eax,%es:(%edi)
801053a6:	89 ca                	mov    %ecx,%edx
801053a8:	89 fb                	mov    %edi,%ebx
801053aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801053ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801053b0:	5b                   	pop    %ebx
801053b1:	5f                   	pop    %edi
801053b2:	5d                   	pop    %ebp
801053b3:	c3                   	ret    

801053b4 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801053b4:	55                   	push   %ebp
801053b5:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801053b7:	8b 45 08             	mov    0x8(%ebp),%eax
801053ba:	83 e0 03             	and    $0x3,%eax
801053bd:	85 c0                	test   %eax,%eax
801053bf:	75 43                	jne    80105404 <memset+0x50>
801053c1:	8b 45 10             	mov    0x10(%ebp),%eax
801053c4:	83 e0 03             	and    $0x3,%eax
801053c7:	85 c0                	test   %eax,%eax
801053c9:	75 39                	jne    80105404 <memset+0x50>
    c &= 0xFF;
801053cb:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801053d2:	8b 45 10             	mov    0x10(%ebp),%eax
801053d5:	c1 e8 02             	shr    $0x2,%eax
801053d8:	89 c2                	mov    %eax,%edx
801053da:	8b 45 0c             	mov    0xc(%ebp),%eax
801053dd:	c1 e0 18             	shl    $0x18,%eax
801053e0:	89 c1                	mov    %eax,%ecx
801053e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053e5:	c1 e0 10             	shl    $0x10,%eax
801053e8:	09 c1                	or     %eax,%ecx
801053ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ed:	c1 e0 08             	shl    $0x8,%eax
801053f0:	09 c8                	or     %ecx,%eax
801053f2:	0b 45 0c             	or     0xc(%ebp),%eax
801053f5:	52                   	push   %edx
801053f6:	50                   	push   %eax
801053f7:	ff 75 08             	pushl  0x8(%ebp)
801053fa:	e8 90 ff ff ff       	call   8010538f <stosl>
801053ff:	83 c4 0c             	add    $0xc,%esp
80105402:	eb 12                	jmp    80105416 <memset+0x62>
  } else
    stosb(dst, c, n);
80105404:	8b 45 10             	mov    0x10(%ebp),%eax
80105407:	50                   	push   %eax
80105408:	ff 75 0c             	pushl  0xc(%ebp)
8010540b:	ff 75 08             	pushl  0x8(%ebp)
8010540e:	e8 57 ff ff ff       	call   8010536a <stosb>
80105413:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105416:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105419:	c9                   	leave  
8010541a:	c3                   	ret    

8010541b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010541b:	55                   	push   %ebp
8010541c:	89 e5                	mov    %esp,%ebp
8010541e:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105421:	8b 45 08             	mov    0x8(%ebp),%eax
80105424:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105427:	8b 45 0c             	mov    0xc(%ebp),%eax
8010542a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010542d:	eb 2a                	jmp    80105459 <memcmp+0x3e>
    if(*s1 != *s2)
8010542f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105432:	8a 10                	mov    (%eax),%dl
80105434:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105437:	8a 00                	mov    (%eax),%al
80105439:	38 c2                	cmp    %al,%dl
8010543b:	74 16                	je     80105453 <memcmp+0x38>
      return *s1 - *s2;
8010543d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105440:	8a 00                	mov    (%eax),%al
80105442:	0f b6 d0             	movzbl %al,%edx
80105445:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105448:	8a 00                	mov    (%eax),%al
8010544a:	0f b6 c0             	movzbl %al,%eax
8010544d:	29 c2                	sub    %eax,%edx
8010544f:	89 d0                	mov    %edx,%eax
80105451:	eb 18                	jmp    8010546b <memcmp+0x50>
    s1++, s2++;
80105453:	ff 45 fc             	incl   -0x4(%ebp)
80105456:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105459:	8b 45 10             	mov    0x10(%ebp),%eax
8010545c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010545f:	89 55 10             	mov    %edx,0x10(%ebp)
80105462:	85 c0                	test   %eax,%eax
80105464:	75 c9                	jne    8010542f <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105466:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010546b:	c9                   	leave  
8010546c:	c3                   	ret    

8010546d <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010546d:	55                   	push   %ebp
8010546e:	89 e5                	mov    %esp,%ebp
80105470:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105473:	8b 45 0c             	mov    0xc(%ebp),%eax
80105476:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105479:	8b 45 08             	mov    0x8(%ebp),%eax
8010547c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010547f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105482:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105485:	73 3a                	jae    801054c1 <memmove+0x54>
80105487:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010548a:	8b 45 10             	mov    0x10(%ebp),%eax
8010548d:	01 d0                	add    %edx,%eax
8010548f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105492:	76 2d                	jbe    801054c1 <memmove+0x54>
    s += n;
80105494:	8b 45 10             	mov    0x10(%ebp),%eax
80105497:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010549a:	8b 45 10             	mov    0x10(%ebp),%eax
8010549d:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801054a0:	eb 10                	jmp    801054b2 <memmove+0x45>
      *--d = *--s;
801054a2:	ff 4d f8             	decl   -0x8(%ebp)
801054a5:	ff 4d fc             	decl   -0x4(%ebp)
801054a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054ab:	8a 10                	mov    (%eax),%dl
801054ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054b0:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801054b2:	8b 45 10             	mov    0x10(%ebp),%eax
801054b5:	8d 50 ff             	lea    -0x1(%eax),%edx
801054b8:	89 55 10             	mov    %edx,0x10(%ebp)
801054bb:	85 c0                	test   %eax,%eax
801054bd:	75 e3                	jne    801054a2 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801054bf:	eb 25                	jmp    801054e6 <memmove+0x79>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801054c1:	eb 16                	jmp    801054d9 <memmove+0x6c>
      *d++ = *s++;
801054c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054c6:	8d 50 01             	lea    0x1(%eax),%edx
801054c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
801054cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054cf:	8d 4a 01             	lea    0x1(%edx),%ecx
801054d2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801054d5:	8a 12                	mov    (%edx),%dl
801054d7:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801054d9:	8b 45 10             	mov    0x10(%ebp),%eax
801054dc:	8d 50 ff             	lea    -0x1(%eax),%edx
801054df:	89 55 10             	mov    %edx,0x10(%ebp)
801054e2:	85 c0                	test   %eax,%eax
801054e4:	75 dd                	jne    801054c3 <memmove+0x56>
      *d++ = *s++;

  return dst;
801054e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801054e9:	c9                   	leave  
801054ea:	c3                   	ret    

801054eb <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801054eb:	55                   	push   %ebp
801054ec:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801054ee:	ff 75 10             	pushl  0x10(%ebp)
801054f1:	ff 75 0c             	pushl  0xc(%ebp)
801054f4:	ff 75 08             	pushl  0x8(%ebp)
801054f7:	e8 71 ff ff ff       	call   8010546d <memmove>
801054fc:	83 c4 0c             	add    $0xc,%esp
}
801054ff:	c9                   	leave  
80105500:	c3                   	ret    

80105501 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105501:	55                   	push   %ebp
80105502:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105504:	eb 09                	jmp    8010550f <strncmp+0xe>
    n--, p++, q++;
80105506:	ff 4d 10             	decl   0x10(%ebp)
80105509:	ff 45 08             	incl   0x8(%ebp)
8010550c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010550f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105513:	74 17                	je     8010552c <strncmp+0x2b>
80105515:	8b 45 08             	mov    0x8(%ebp),%eax
80105518:	8a 00                	mov    (%eax),%al
8010551a:	84 c0                	test   %al,%al
8010551c:	74 0e                	je     8010552c <strncmp+0x2b>
8010551e:	8b 45 08             	mov    0x8(%ebp),%eax
80105521:	8a 10                	mov    (%eax),%dl
80105523:	8b 45 0c             	mov    0xc(%ebp),%eax
80105526:	8a 00                	mov    (%eax),%al
80105528:	38 c2                	cmp    %al,%dl
8010552a:	74 da                	je     80105506 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010552c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105530:	75 07                	jne    80105539 <strncmp+0x38>
    return 0;
80105532:	b8 00 00 00 00       	mov    $0x0,%eax
80105537:	eb 14                	jmp    8010554d <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
80105539:	8b 45 08             	mov    0x8(%ebp),%eax
8010553c:	8a 00                	mov    (%eax),%al
8010553e:	0f b6 d0             	movzbl %al,%edx
80105541:	8b 45 0c             	mov    0xc(%ebp),%eax
80105544:	8a 00                	mov    (%eax),%al
80105546:	0f b6 c0             	movzbl %al,%eax
80105549:	29 c2                	sub    %eax,%edx
8010554b:	89 d0                	mov    %edx,%eax
}
8010554d:	5d                   	pop    %ebp
8010554e:	c3                   	ret    

8010554f <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010554f:	55                   	push   %ebp
80105550:	89 e5                	mov    %esp,%ebp
80105552:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105555:	8b 45 08             	mov    0x8(%ebp),%eax
80105558:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010555b:	90                   	nop
8010555c:	8b 45 10             	mov    0x10(%ebp),%eax
8010555f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105562:	89 55 10             	mov    %edx,0x10(%ebp)
80105565:	85 c0                	test   %eax,%eax
80105567:	7e 1c                	jle    80105585 <strncpy+0x36>
80105569:	8b 45 08             	mov    0x8(%ebp),%eax
8010556c:	8d 50 01             	lea    0x1(%eax),%edx
8010556f:	89 55 08             	mov    %edx,0x8(%ebp)
80105572:	8b 55 0c             	mov    0xc(%ebp),%edx
80105575:	8d 4a 01             	lea    0x1(%edx),%ecx
80105578:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010557b:	8a 12                	mov    (%edx),%dl
8010557d:	88 10                	mov    %dl,(%eax)
8010557f:	8a 00                	mov    (%eax),%al
80105581:	84 c0                	test   %al,%al
80105583:	75 d7                	jne    8010555c <strncpy+0xd>
    ;
  while(n-- > 0)
80105585:	eb 0c                	jmp    80105593 <strncpy+0x44>
    *s++ = 0;
80105587:	8b 45 08             	mov    0x8(%ebp),%eax
8010558a:	8d 50 01             	lea    0x1(%eax),%edx
8010558d:	89 55 08             	mov    %edx,0x8(%ebp)
80105590:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105593:	8b 45 10             	mov    0x10(%ebp),%eax
80105596:	8d 50 ff             	lea    -0x1(%eax),%edx
80105599:	89 55 10             	mov    %edx,0x10(%ebp)
8010559c:	85 c0                	test   %eax,%eax
8010559e:	7f e7                	jg     80105587 <strncpy+0x38>
    *s++ = 0;
  return os;
801055a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055a3:	c9                   	leave  
801055a4:	c3                   	ret    

801055a5 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801055a5:	55                   	push   %ebp
801055a6:	89 e5                	mov    %esp,%ebp
801055a8:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801055ab:	8b 45 08             	mov    0x8(%ebp),%eax
801055ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801055b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055b5:	7f 05                	jg     801055bc <safestrcpy+0x17>
    return os;
801055b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055ba:	eb 2e                	jmp    801055ea <safestrcpy+0x45>
  while(--n > 0 && (*s++ = *t++) != 0)
801055bc:	ff 4d 10             	decl   0x10(%ebp)
801055bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055c3:	7e 1c                	jle    801055e1 <safestrcpy+0x3c>
801055c5:	8b 45 08             	mov    0x8(%ebp),%eax
801055c8:	8d 50 01             	lea    0x1(%eax),%edx
801055cb:	89 55 08             	mov    %edx,0x8(%ebp)
801055ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801055d1:	8d 4a 01             	lea    0x1(%edx),%ecx
801055d4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801055d7:	8a 12                	mov    (%edx),%dl
801055d9:	88 10                	mov    %dl,(%eax)
801055db:	8a 00                	mov    (%eax),%al
801055dd:	84 c0                	test   %al,%al
801055df:	75 db                	jne    801055bc <safestrcpy+0x17>
    ;
  *s = 0;
801055e1:	8b 45 08             	mov    0x8(%ebp),%eax
801055e4:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801055e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055ea:	c9                   	leave  
801055eb:	c3                   	ret    

801055ec <strlen>:

int
strlen(const char *s)
{
801055ec:	55                   	push   %ebp
801055ed:	89 e5                	mov    %esp,%ebp
801055ef:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801055f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801055f9:	eb 03                	jmp    801055fe <strlen+0x12>
801055fb:	ff 45 fc             	incl   -0x4(%ebp)
801055fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105601:	8b 45 08             	mov    0x8(%ebp),%eax
80105604:	01 d0                	add    %edx,%eax
80105606:	8a 00                	mov    (%eax),%al
80105608:	84 c0                	test   %al,%al
8010560a:	75 ef                	jne    801055fb <strlen+0xf>
    ;
  return n;
8010560c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010560f:	c9                   	leave  
80105610:	c3                   	ret    

80105611 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105611:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105615:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105619:	55                   	push   %ebp
  pushl %ebx
8010561a:	53                   	push   %ebx
  pushl %esi
8010561b:	56                   	push   %esi
  pushl %edi
8010561c:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010561d:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010561f:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105621:	5f                   	pop    %edi
  popl %esi
80105622:	5e                   	pop    %esi
  popl %ebx
80105623:	5b                   	pop    %ebx
  popl %ebp
80105624:	5d                   	pop    %ebp
  ret
80105625:	c3                   	ret    

80105626 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105626:	55                   	push   %ebp
80105627:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105629:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562f:	8b 00                	mov    (%eax),%eax
80105631:	3b 45 08             	cmp    0x8(%ebp),%eax
80105634:	76 12                	jbe    80105648 <fetchint+0x22>
80105636:	8b 45 08             	mov    0x8(%ebp),%eax
80105639:	8d 50 04             	lea    0x4(%eax),%edx
8010563c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105642:	8b 00                	mov    (%eax),%eax
80105644:	39 c2                	cmp    %eax,%edx
80105646:	76 07                	jbe    8010564f <fetchint+0x29>
    return -1;
80105648:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010564d:	eb 0f                	jmp    8010565e <fetchint+0x38>
  *ip = *(int*)(addr);
8010564f:	8b 45 08             	mov    0x8(%ebp),%eax
80105652:	8b 10                	mov    (%eax),%edx
80105654:	8b 45 0c             	mov    0xc(%ebp),%eax
80105657:	89 10                	mov    %edx,(%eax)
  return 0;
80105659:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010565e:	5d                   	pop    %ebp
8010565f:	c3                   	ret    

80105660 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105666:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010566c:	8b 00                	mov    (%eax),%eax
8010566e:	3b 45 08             	cmp    0x8(%ebp),%eax
80105671:	77 07                	ja     8010567a <fetchstr+0x1a>
    return -1;
80105673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105678:	eb 44                	jmp    801056be <fetchstr+0x5e>
  *pp = (char*)addr;
8010567a:	8b 55 08             	mov    0x8(%ebp),%edx
8010567d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105680:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105682:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105688:	8b 00                	mov    (%eax),%eax
8010568a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010568d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105690:	8b 00                	mov    (%eax),%eax
80105692:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105695:	eb 1a                	jmp    801056b1 <fetchstr+0x51>
    if(*s == 0)
80105697:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010569a:	8a 00                	mov    (%eax),%al
8010569c:	84 c0                	test   %al,%al
8010569e:	75 0e                	jne    801056ae <fetchstr+0x4e>
      return s - *pp;
801056a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a6:	8b 00                	mov    (%eax),%eax
801056a8:	29 c2                	sub    %eax,%edx
801056aa:	89 d0                	mov    %edx,%eax
801056ac:	eb 10                	jmp    801056be <fetchstr+0x5e>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801056ae:	ff 45 fc             	incl   -0x4(%ebp)
801056b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801056b7:	72 de                	jb     80105697 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801056b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056be:	c9                   	leave  
801056bf:	c3                   	ret    

801056c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801056c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c9:	8b 40 18             	mov    0x18(%eax),%eax
801056cc:	8b 50 44             	mov    0x44(%eax),%edx
801056cf:	8b 45 08             	mov    0x8(%ebp),%eax
801056d2:	c1 e0 02             	shl    $0x2,%eax
801056d5:	01 d0                	add    %edx,%eax
801056d7:	83 c0 04             	add    $0x4,%eax
801056da:	ff 75 0c             	pushl  0xc(%ebp)
801056dd:	50                   	push   %eax
801056de:	e8 43 ff ff ff       	call   80105626 <fetchint>
801056e3:	83 c4 08             	add    $0x8,%esp
}
801056e6:	c9                   	leave  
801056e7:	c3                   	ret    

801056e8 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801056e8:	55                   	push   %ebp
801056e9:	89 e5                	mov    %esp,%ebp
801056eb:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(argint(n, &i) < 0)
801056ee:	8d 45 fc             	lea    -0x4(%ebp),%eax
801056f1:	50                   	push   %eax
801056f2:	ff 75 08             	pushl  0x8(%ebp)
801056f5:	e8 c6 ff ff ff       	call   801056c0 <argint>
801056fa:	83 c4 08             	add    $0x8,%esp
801056fd:	85 c0                	test   %eax,%eax
801056ff:	79 07                	jns    80105708 <argptr+0x20>
    return -1;
80105701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105706:	eb 3d                	jmp    80105745 <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105708:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010570b:	89 c2                	mov    %eax,%edx
8010570d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105713:	8b 00                	mov    (%eax),%eax
80105715:	39 c2                	cmp    %eax,%edx
80105717:	73 16                	jae    8010572f <argptr+0x47>
80105719:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010571c:	89 c2                	mov    %eax,%edx
8010571e:	8b 45 10             	mov    0x10(%ebp),%eax
80105721:	01 c2                	add    %eax,%edx
80105723:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105729:	8b 00                	mov    (%eax),%eax
8010572b:	39 c2                	cmp    %eax,%edx
8010572d:	76 07                	jbe    80105736 <argptr+0x4e>
    return -1;
8010572f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105734:	eb 0f                	jmp    80105745 <argptr+0x5d>
  *pp = (char*)i;
80105736:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105739:	89 c2                	mov    %eax,%edx
8010573b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010573e:	89 10                	mov    %edx,(%eax)
  return 0;
80105740:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105745:	c9                   	leave  
80105746:	c3                   	ret    

80105747 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105747:	55                   	push   %ebp
80105748:	89 e5                	mov    %esp,%ebp
8010574a:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010574d:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105750:	50                   	push   %eax
80105751:	ff 75 08             	pushl  0x8(%ebp)
80105754:	e8 67 ff ff ff       	call   801056c0 <argint>
80105759:	83 c4 08             	add    $0x8,%esp
8010575c:	85 c0                	test   %eax,%eax
8010575e:	79 07                	jns    80105767 <argstr+0x20>
    return -1;
80105760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105765:	eb 0f                	jmp    80105776 <argstr+0x2f>
  return fetchstr(addr, pp);
80105767:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010576a:	ff 75 0c             	pushl  0xc(%ebp)
8010576d:	50                   	push   %eax
8010576e:	e8 ed fe ff ff       	call   80105660 <fetchstr>
80105773:	83 c4 08             	add    $0x8,%esp
}
80105776:	c9                   	leave  
80105777:	c3                   	ret    

80105778 <syscall>:
[SYS_settickets] sys_settickets,
};

void
syscall(void)
{
80105778:	55                   	push   %ebp
80105779:	89 e5                	mov    %esp,%ebp
8010577b:	53                   	push   %ebx
8010577c:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
8010577f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105785:	8b 40 18             	mov    0x18(%eax),%eax
80105788:	8b 40 1c             	mov    0x1c(%eax),%eax
8010578b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010578e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105792:	7e 30                	jle    801057c4 <syscall+0x4c>
80105794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105797:	83 f8 17             	cmp    $0x17,%eax
8010579a:	77 28                	ja     801057c4 <syscall+0x4c>
8010579c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579f:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801057a6:	85 c0                	test   %eax,%eax
801057a8:	74 1a                	je     801057c4 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801057aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057b0:	8b 58 18             	mov    0x18(%eax),%ebx
801057b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b6:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801057bd:	ff d0                	call   *%eax
801057bf:	89 43 1c             	mov    %eax,0x1c(%ebx)
801057c2:	eb 34                	jmp    801057f8 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801057c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057ca:	8d 50 6c             	lea    0x6c(%eax),%edx
801057cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801057d3:	8b 40 10             	mov    0x10(%eax),%eax
801057d6:	ff 75 f4             	pushl  -0xc(%ebp)
801057d9:	52                   	push   %edx
801057da:	50                   	push   %eax
801057db:	68 eb 8c 10 80       	push   $0x80108ceb
801057e0:	e8 26 ac ff ff       	call   8010040b <cprintf>
801057e5:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801057e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057ee:	8b 40 18             	mov    0x18(%eax),%eax
801057f1:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801057f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057fb:	c9                   	leave  
801057fc:	c3                   	ret    

801057fd <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801057fd:	55                   	push   %ebp
801057fe:	89 e5                	mov    %esp,%ebp
80105800:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105803:	83 ec 08             	sub    $0x8,%esp
80105806:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105809:	50                   	push   %eax
8010580a:	ff 75 08             	pushl  0x8(%ebp)
8010580d:	e8 ae fe ff ff       	call   801056c0 <argint>
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	85 c0                	test   %eax,%eax
80105817:	79 07                	jns    80105820 <argfd+0x23>
    return -1;
80105819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581e:	eb 50                	jmp    80105870 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105820:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105823:	85 c0                	test   %eax,%eax
80105825:	78 21                	js     80105848 <argfd+0x4b>
80105827:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010582a:	83 f8 0f             	cmp    $0xf,%eax
8010582d:	7f 19                	jg     80105848 <argfd+0x4b>
8010582f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105835:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105838:	83 c2 08             	add    $0x8,%edx
8010583b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010583f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105842:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105846:	75 07                	jne    8010584f <argfd+0x52>
    return -1;
80105848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584d:	eb 21                	jmp    80105870 <argfd+0x73>
  if(pfd)
8010584f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105853:	74 08                	je     8010585d <argfd+0x60>
    *pfd = fd;
80105855:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105858:	8b 45 0c             	mov    0xc(%ebp),%eax
8010585b:	89 10                	mov    %edx,(%eax)
  if(pf)
8010585d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105861:	74 08                	je     8010586b <argfd+0x6e>
    *pf = f;
80105863:	8b 45 10             	mov    0x10(%ebp),%eax
80105866:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105869:	89 10                	mov    %edx,(%eax)
  return 0;
8010586b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105870:	c9                   	leave  
80105871:	c3                   	ret    

80105872 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105872:	55                   	push   %ebp
80105873:	89 e5                	mov    %esp,%ebp
80105875:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105878:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010587f:	eb 2f                	jmp    801058b0 <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105881:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105887:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010588a:	83 c2 08             	add    $0x8,%edx
8010588d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105891:	85 c0                	test   %eax,%eax
80105893:	75 18                	jne    801058ad <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105895:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010589b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010589e:	8d 4a 08             	lea    0x8(%edx),%ecx
801058a1:	8b 55 08             	mov    0x8(%ebp),%edx
801058a4:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801058a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ab:	eb 0e                	jmp    801058bb <fdalloc+0x49>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801058ad:	ff 45 fc             	incl   -0x4(%ebp)
801058b0:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801058b4:	7e cb                	jle    80105881 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801058b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058bb:	c9                   	leave  
801058bc:	c3                   	ret    

801058bd <sys_dup>:

int
sys_dup(void)
{
801058bd:	55                   	push   %ebp
801058be:	89 e5                	mov    %esp,%ebp
801058c0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801058c3:	83 ec 04             	sub    $0x4,%esp
801058c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c9:	50                   	push   %eax
801058ca:	6a 00                	push   $0x0
801058cc:	6a 00                	push   $0x0
801058ce:	e8 2a ff ff ff       	call   801057fd <argfd>
801058d3:	83 c4 10             	add    $0x10,%esp
801058d6:	85 c0                	test   %eax,%eax
801058d8:	79 07                	jns    801058e1 <sys_dup+0x24>
    return -1;
801058da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058df:	eb 31                	jmp    80105912 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801058e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e4:	83 ec 0c             	sub    $0xc,%esp
801058e7:	50                   	push   %eax
801058e8:	e8 85 ff ff ff       	call   80105872 <fdalloc>
801058ed:	83 c4 10             	add    $0x10,%esp
801058f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058f7:	79 07                	jns    80105900 <sys_dup+0x43>
    return -1;
801058f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fe:	eb 12                	jmp    80105912 <sys_dup+0x55>
  filedup(f);
80105900:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105903:	83 ec 0c             	sub    $0xc,%esp
80105906:	50                   	push   %eax
80105907:	e8 06 b7 ff ff       	call   80101012 <filedup>
8010590c:	83 c4 10             	add    $0x10,%esp
  return fd;
8010590f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105912:	c9                   	leave  
80105913:	c3                   	ret    

80105914 <sys_read>:

int
sys_read(void)
{
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010591a:	83 ec 04             	sub    $0x4,%esp
8010591d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105920:	50                   	push   %eax
80105921:	6a 00                	push   $0x0
80105923:	6a 00                	push   $0x0
80105925:	e8 d3 fe ff ff       	call   801057fd <argfd>
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	85 c0                	test   %eax,%eax
8010592f:	78 2e                	js     8010595f <sys_read+0x4b>
80105931:	83 ec 08             	sub    $0x8,%esp
80105934:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105937:	50                   	push   %eax
80105938:	6a 02                	push   $0x2
8010593a:	e8 81 fd ff ff       	call   801056c0 <argint>
8010593f:	83 c4 10             	add    $0x10,%esp
80105942:	85 c0                	test   %eax,%eax
80105944:	78 19                	js     8010595f <sys_read+0x4b>
80105946:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105949:	83 ec 04             	sub    $0x4,%esp
8010594c:	50                   	push   %eax
8010594d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105950:	50                   	push   %eax
80105951:	6a 01                	push   $0x1
80105953:	e8 90 fd ff ff       	call   801056e8 <argptr>
80105958:	83 c4 10             	add    $0x10,%esp
8010595b:	85 c0                	test   %eax,%eax
8010595d:	79 07                	jns    80105966 <sys_read+0x52>
    return -1;
8010595f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105964:	eb 17                	jmp    8010597d <sys_read+0x69>
  return fileread(f, p, n);
80105966:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105969:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010596c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596f:	83 ec 04             	sub    $0x4,%esp
80105972:	51                   	push   %ecx
80105973:	52                   	push   %edx
80105974:	50                   	push   %eax
80105975:	e8 1c b8 ff ff       	call   80101196 <fileread>
8010597a:	83 c4 10             	add    $0x10,%esp
}
8010597d:	c9                   	leave  
8010597e:	c3                   	ret    

8010597f <sys_write>:

int
sys_write(void)
{
8010597f:	55                   	push   %ebp
80105980:	89 e5                	mov    %esp,%ebp
80105982:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105985:	83 ec 04             	sub    $0x4,%esp
80105988:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010598b:	50                   	push   %eax
8010598c:	6a 00                	push   $0x0
8010598e:	6a 00                	push   $0x0
80105990:	e8 68 fe ff ff       	call   801057fd <argfd>
80105995:	83 c4 10             	add    $0x10,%esp
80105998:	85 c0                	test   %eax,%eax
8010599a:	78 2e                	js     801059ca <sys_write+0x4b>
8010599c:	83 ec 08             	sub    $0x8,%esp
8010599f:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059a2:	50                   	push   %eax
801059a3:	6a 02                	push   $0x2
801059a5:	e8 16 fd ff ff       	call   801056c0 <argint>
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	85 c0                	test   %eax,%eax
801059af:	78 19                	js     801059ca <sys_write+0x4b>
801059b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b4:	83 ec 04             	sub    $0x4,%esp
801059b7:	50                   	push   %eax
801059b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059bb:	50                   	push   %eax
801059bc:	6a 01                	push   $0x1
801059be:	e8 25 fd ff ff       	call   801056e8 <argptr>
801059c3:	83 c4 10             	add    $0x10,%esp
801059c6:	85 c0                	test   %eax,%eax
801059c8:	79 07                	jns    801059d1 <sys_write+0x52>
    return -1;
801059ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cf:	eb 17                	jmp    801059e8 <sys_write+0x69>
  return filewrite(f, p, n);
801059d1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801059d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801059d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059da:	83 ec 04             	sub    $0x4,%esp
801059dd:	51                   	push   %ecx
801059de:	52                   	push   %edx
801059df:	50                   	push   %eax
801059e0:	e8 68 b8 ff ff       	call   8010124d <filewrite>
801059e5:	83 c4 10             	add    $0x10,%esp
}
801059e8:	c9                   	leave  
801059e9:	c3                   	ret    

801059ea <sys_close>:

int
sys_close(void)
{
801059ea:	55                   	push   %ebp
801059eb:	89 e5                	mov    %esp,%ebp
801059ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801059f0:	83 ec 04             	sub    $0x4,%esp
801059f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059f6:	50                   	push   %eax
801059f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059fa:	50                   	push   %eax
801059fb:	6a 00                	push   $0x0
801059fd:	e8 fb fd ff ff       	call   801057fd <argfd>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	79 07                	jns    80105a10 <sys_close+0x26>
    return -1;
80105a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0e:	eb 28                	jmp    80105a38 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105a10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a19:	83 c2 08             	add    $0x8,%edx
80105a1c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105a23:	00 
  fileclose(f);
80105a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a27:	83 ec 0c             	sub    $0xc,%esp
80105a2a:	50                   	push   %eax
80105a2b:	e8 33 b6 ff ff       	call   80101063 <fileclose>
80105a30:	83 c4 10             	add    $0x10,%esp
  return 0;
80105a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a38:	c9                   	leave  
80105a39:	c3                   	ret    

80105a3a <sys_fstat>:

int
sys_fstat(void)
{
80105a3a:	55                   	push   %ebp
80105a3b:	89 e5                	mov    %esp,%ebp
80105a3d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a40:	83 ec 04             	sub    $0x4,%esp
80105a43:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a46:	50                   	push   %eax
80105a47:	6a 00                	push   $0x0
80105a49:	6a 00                	push   $0x0
80105a4b:	e8 ad fd ff ff       	call   801057fd <argfd>
80105a50:	83 c4 10             	add    $0x10,%esp
80105a53:	85 c0                	test   %eax,%eax
80105a55:	78 17                	js     80105a6e <sys_fstat+0x34>
80105a57:	83 ec 04             	sub    $0x4,%esp
80105a5a:	6a 14                	push   $0x14
80105a5c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a5f:	50                   	push   %eax
80105a60:	6a 01                	push   $0x1
80105a62:	e8 81 fc ff ff       	call   801056e8 <argptr>
80105a67:	83 c4 10             	add    $0x10,%esp
80105a6a:	85 c0                	test   %eax,%eax
80105a6c:	79 07                	jns    80105a75 <sys_fstat+0x3b>
    return -1;
80105a6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a73:	eb 13                	jmp    80105a88 <sys_fstat+0x4e>
  return filestat(f, st);
80105a75:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7b:	83 ec 08             	sub    $0x8,%esp
80105a7e:	52                   	push   %edx
80105a7f:	50                   	push   %eax
80105a80:	e8 ba b6 ff ff       	call   8010113f <filestat>
80105a85:	83 c4 10             	add    $0x10,%esp
}
80105a88:	c9                   	leave  
80105a89:	c3                   	ret    

80105a8a <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a8a:	55                   	push   %ebp
80105a8b:	89 e5                	mov    %esp,%ebp
80105a8d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a90:	83 ec 08             	sub    $0x8,%esp
80105a93:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a96:	50                   	push   %eax
80105a97:	6a 00                	push   $0x0
80105a99:	e8 a9 fc ff ff       	call   80105747 <argstr>
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	78 15                	js     80105aba <sys_link+0x30>
80105aa5:	83 ec 08             	sub    $0x8,%esp
80105aa8:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105aab:	50                   	push   %eax
80105aac:	6a 01                	push   $0x1
80105aae:	e8 94 fc ff ff       	call   80105747 <argstr>
80105ab3:	83 c4 10             	add    $0x10,%esp
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	79 0a                	jns    80105ac4 <sys_link+0x3a>
    return -1;
80105aba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abf:	e9 60 01 00 00       	jmp    80105c24 <sys_link+0x19a>

  begin_op();
80105ac4:	e8 d8 da ff ff       	call   801035a1 <begin_op>
  if((ip = namei(old)) == 0){
80105ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105acc:	83 ec 0c             	sub    $0xc,%esp
80105acf:	50                   	push   %eax
80105ad0:	e8 33 ca ff ff       	call   80102508 <namei>
80105ad5:	83 c4 10             	add    $0x10,%esp
80105ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105adf:	75 0f                	jne    80105af0 <sys_link+0x66>
    end_op();
80105ae1:	e8 47 db ff ff       	call   8010362d <end_op>
    return -1;
80105ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aeb:	e9 34 01 00 00       	jmp    80105c24 <sys_link+0x19a>
  }

  ilock(ip);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	ff 75 f4             	pushl  -0xc(%ebp)
80105af6:	e8 5b be ff ff       	call   80101956 <ilock>
80105afb:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b01:	8b 40 10             	mov    0x10(%eax),%eax
80105b04:	66 83 f8 01          	cmp    $0x1,%ax
80105b08:	75 1d                	jne    80105b27 <sys_link+0x9d>
    iunlockput(ip);
80105b0a:	83 ec 0c             	sub    $0xc,%esp
80105b0d:	ff 75 f4             	pushl  -0xc(%ebp)
80105b10:	e8 fb c0 ff ff       	call   80101c10 <iunlockput>
80105b15:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b18:	e8 10 db ff ff       	call   8010362d <end_op>
    return -1;
80105b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b22:	e9 fd 00 00 00       	jmp    80105c24 <sys_link+0x19a>
  }

  ip->nlink++;
80105b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2a:	66 8b 40 16          	mov    0x16(%eax),%ax
80105b2e:	40                   	inc    %eax
80105b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b32:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105b36:	83 ec 0c             	sub    $0xc,%esp
80105b39:	ff 75 f4             	pushl  -0xc(%ebp)
80105b3c:	e8 3e bc ff ff       	call   8010177f <iupdate>
80105b41:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105b44:	83 ec 0c             	sub    $0xc,%esp
80105b47:	ff 75 f4             	pushl  -0xc(%ebp)
80105b4a:	e8 61 bf ff ff       	call   80101ab0 <iunlock>
80105b4f:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105b52:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b55:	83 ec 08             	sub    $0x8,%esp
80105b58:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105b5b:	52                   	push   %edx
80105b5c:	50                   	push   %eax
80105b5d:	e8 c2 c9 ff ff       	call   80102524 <nameiparent>
80105b62:	83 c4 10             	add    $0x10,%esp
80105b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b6c:	75 02                	jne    80105b70 <sys_link+0xe6>
    goto bad;
80105b6e:	eb 71                	jmp    80105be1 <sys_link+0x157>
  ilock(dp);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	ff 75 f0             	pushl  -0x10(%ebp)
80105b76:	e8 db bd ff ff       	call   80101956 <ilock>
80105b7b:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b81:	8b 10                	mov    (%eax),%edx
80105b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b86:	8b 00                	mov    (%eax),%eax
80105b88:	39 c2                	cmp    %eax,%edx
80105b8a:	75 1d                	jne    80105ba9 <sys_link+0x11f>
80105b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8f:	8b 40 04             	mov    0x4(%eax),%eax
80105b92:	83 ec 04             	sub    $0x4,%esp
80105b95:	50                   	push   %eax
80105b96:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b99:	50                   	push   %eax
80105b9a:	ff 75 f0             	pushl  -0x10(%ebp)
80105b9d:	e8 da c6 ff ff       	call   8010227c <dirlink>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	79 10                	jns    80105bb9 <sys_link+0x12f>
    iunlockput(dp);
80105ba9:	83 ec 0c             	sub    $0xc,%esp
80105bac:	ff 75 f0             	pushl  -0x10(%ebp)
80105baf:	e8 5c c0 ff ff       	call   80101c10 <iunlockput>
80105bb4:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105bb7:	eb 28                	jmp    80105be1 <sys_link+0x157>
  }
  iunlockput(dp);
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	ff 75 f0             	pushl  -0x10(%ebp)
80105bbf:	e8 4c c0 ff ff       	call   80101c10 <iunlockput>
80105bc4:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105bc7:	83 ec 0c             	sub    $0xc,%esp
80105bca:	ff 75 f4             	pushl  -0xc(%ebp)
80105bcd:	e8 4f bf ff ff       	call   80101b21 <iput>
80105bd2:	83 c4 10             	add    $0x10,%esp

  end_op();
80105bd5:	e8 53 da ff ff       	call   8010362d <end_op>

  return 0;
80105bda:	b8 00 00 00 00       	mov    $0x0,%eax
80105bdf:	eb 43                	jmp    80105c24 <sys_link+0x19a>

bad:
  ilock(ip);
80105be1:	83 ec 0c             	sub    $0xc,%esp
80105be4:	ff 75 f4             	pushl  -0xc(%ebp)
80105be7:	e8 6a bd ff ff       	call   80101956 <ilock>
80105bec:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf2:	66 8b 40 16          	mov    0x16(%eax),%ax
80105bf6:	48                   	dec    %eax
80105bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bfa:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105bfe:	83 ec 0c             	sub    $0xc,%esp
80105c01:	ff 75 f4             	pushl  -0xc(%ebp)
80105c04:	e8 76 bb ff ff       	call   8010177f <iupdate>
80105c09:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c0c:	83 ec 0c             	sub    $0xc,%esp
80105c0f:	ff 75 f4             	pushl  -0xc(%ebp)
80105c12:	e8 f9 bf ff ff       	call   80101c10 <iunlockput>
80105c17:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c1a:	e8 0e da ff ff       	call   8010362d <end_op>
  return -1;
80105c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c24:	c9                   	leave  
80105c25:	c3                   	ret    

80105c26 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105c26:	55                   	push   %ebp
80105c27:	89 e5                	mov    %esp,%ebp
80105c29:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c2c:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105c33:	eb 3f                	jmp    80105c74 <isdirempty+0x4e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c38:	6a 10                	push   $0x10
80105c3a:	50                   	push   %eax
80105c3b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c3e:	50                   	push   %eax
80105c3f:	ff 75 08             	pushl  0x8(%ebp)
80105c42:	e8 71 c2 ff ff       	call   80101eb8 <readi>
80105c47:	83 c4 10             	add    $0x10,%esp
80105c4a:	83 f8 10             	cmp    $0x10,%eax
80105c4d:	74 0d                	je     80105c5c <isdirempty+0x36>
      panic("isdirempty: readi");
80105c4f:	83 ec 0c             	sub    $0xc,%esp
80105c52:	68 07 8d 10 80       	push   $0x80108d07
80105c57:	e8 6d a9 ff ff       	call   801005c9 <panic>
    if(de.inum != 0)
80105c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c5f:	66 85 c0             	test   %ax,%ax
80105c62:	74 07                	je     80105c6b <isdirempty+0x45>
      return 0;
80105c64:	b8 00 00 00 00       	mov    $0x0,%eax
80105c69:	eb 1b                	jmp    80105c86 <isdirempty+0x60>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6e:	83 c0 10             	add    $0x10,%eax
80105c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c77:	8b 45 08             	mov    0x8(%ebp),%eax
80105c7a:	8b 40 18             	mov    0x18(%eax),%eax
80105c7d:	39 c2                	cmp    %eax,%edx
80105c7f:	72 b4                	jb     80105c35 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105c81:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c86:	c9                   	leave  
80105c87:	c3                   	ret    

80105c88 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c88:	55                   	push   %ebp
80105c89:	89 e5                	mov    %esp,%ebp
80105c8b:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c8e:	83 ec 08             	sub    $0x8,%esp
80105c91:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c94:	50                   	push   %eax
80105c95:	6a 00                	push   $0x0
80105c97:	e8 ab fa ff ff       	call   80105747 <argstr>
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	79 0a                	jns    80105cad <sys_unlink+0x25>
    return -1;
80105ca3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca8:	e9 b2 01 00 00       	jmp    80105e5f <sys_unlink+0x1d7>

  begin_op();
80105cad:	e8 ef d8 ff ff       	call   801035a1 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105cb2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105cb5:	83 ec 08             	sub    $0x8,%esp
80105cb8:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105cbb:	52                   	push   %edx
80105cbc:	50                   	push   %eax
80105cbd:	e8 62 c8 ff ff       	call   80102524 <nameiparent>
80105cc2:	83 c4 10             	add    $0x10,%esp
80105cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ccc:	75 0f                	jne    80105cdd <sys_unlink+0x55>
    end_op();
80105cce:	e8 5a d9 ff ff       	call   8010362d <end_op>
    return -1;
80105cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd8:	e9 82 01 00 00       	jmp    80105e5f <sys_unlink+0x1d7>
  }

  ilock(dp);
80105cdd:	83 ec 0c             	sub    $0xc,%esp
80105ce0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ce3:	e8 6e bc ff ff       	call   80101956 <ilock>
80105ce8:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105ceb:	83 ec 08             	sub    $0x8,%esp
80105cee:	68 19 8d 10 80       	push   $0x80108d19
80105cf3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cf6:	50                   	push   %eax
80105cf7:	e8 ad c4 ff ff       	call   801021a9 <namecmp>
80105cfc:	83 c4 10             	add    $0x10,%esp
80105cff:	85 c0                	test   %eax,%eax
80105d01:	0f 84 40 01 00 00    	je     80105e47 <sys_unlink+0x1bf>
80105d07:	83 ec 08             	sub    $0x8,%esp
80105d0a:	68 1b 8d 10 80       	push   $0x80108d1b
80105d0f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d12:	50                   	push   %eax
80105d13:	e8 91 c4 ff ff       	call   801021a9 <namecmp>
80105d18:	83 c4 10             	add    $0x10,%esp
80105d1b:	85 c0                	test   %eax,%eax
80105d1d:	0f 84 24 01 00 00    	je     80105e47 <sys_unlink+0x1bf>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105d23:	83 ec 04             	sub    $0x4,%esp
80105d26:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d2d:	50                   	push   %eax
80105d2e:	ff 75 f4             	pushl  -0xc(%ebp)
80105d31:	e8 8e c4 ff ff       	call   801021c4 <dirlookup>
80105d36:	83 c4 10             	add    $0x10,%esp
80105d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d40:	75 05                	jne    80105d47 <sys_unlink+0xbf>
    goto bad;
80105d42:	e9 00 01 00 00       	jmp    80105e47 <sys_unlink+0x1bf>
  ilock(ip);
80105d47:	83 ec 0c             	sub    $0xc,%esp
80105d4a:	ff 75 f0             	pushl  -0x10(%ebp)
80105d4d:	e8 04 bc ff ff       	call   80101956 <ilock>
80105d52:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d58:	66 8b 40 16          	mov    0x16(%eax),%ax
80105d5c:	66 85 c0             	test   %ax,%ax
80105d5f:	7f 0d                	jg     80105d6e <sys_unlink+0xe6>
    panic("unlink: nlink < 1");
80105d61:	83 ec 0c             	sub    $0xc,%esp
80105d64:	68 1e 8d 10 80       	push   $0x80108d1e
80105d69:	e8 5b a8 ff ff       	call   801005c9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d71:	8b 40 10             	mov    0x10(%eax),%eax
80105d74:	66 83 f8 01          	cmp    $0x1,%ax
80105d78:	75 25                	jne    80105d9f <sys_unlink+0x117>
80105d7a:	83 ec 0c             	sub    $0xc,%esp
80105d7d:	ff 75 f0             	pushl  -0x10(%ebp)
80105d80:	e8 a1 fe ff ff       	call   80105c26 <isdirempty>
80105d85:	83 c4 10             	add    $0x10,%esp
80105d88:	85 c0                	test   %eax,%eax
80105d8a:	75 13                	jne    80105d9f <sys_unlink+0x117>
    iunlockput(ip);
80105d8c:	83 ec 0c             	sub    $0xc,%esp
80105d8f:	ff 75 f0             	pushl  -0x10(%ebp)
80105d92:	e8 79 be ff ff       	call   80101c10 <iunlockput>
80105d97:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d9a:	e9 a8 00 00 00       	jmp    80105e47 <sys_unlink+0x1bf>
  }

  memset(&de, 0, sizeof(de));
80105d9f:	83 ec 04             	sub    $0x4,%esp
80105da2:	6a 10                	push   $0x10
80105da4:	6a 00                	push   $0x0
80105da6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105da9:	50                   	push   %eax
80105daa:	e8 05 f6 ff ff       	call   801053b4 <memset>
80105daf:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105db2:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105db5:	6a 10                	push   $0x10
80105db7:	50                   	push   %eax
80105db8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dbb:	50                   	push   %eax
80105dbc:	ff 75 f4             	pushl  -0xc(%ebp)
80105dbf:	e8 54 c2 ff ff       	call   80102018 <writei>
80105dc4:	83 c4 10             	add    $0x10,%esp
80105dc7:	83 f8 10             	cmp    $0x10,%eax
80105dca:	74 0d                	je     80105dd9 <sys_unlink+0x151>
    panic("unlink: writei");
80105dcc:	83 ec 0c             	sub    $0xc,%esp
80105dcf:	68 30 8d 10 80       	push   $0x80108d30
80105dd4:	e8 f0 a7 ff ff       	call   801005c9 <panic>
  if(ip->type == T_DIR){
80105dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddc:	8b 40 10             	mov    0x10(%eax),%eax
80105ddf:	66 83 f8 01          	cmp    $0x1,%ax
80105de3:	75 1d                	jne    80105e02 <sys_unlink+0x17a>
    dp->nlink--;
80105de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de8:	66 8b 40 16          	mov    0x16(%eax),%ax
80105dec:	48                   	dec    %eax
80105ded:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105df0:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105df4:	83 ec 0c             	sub    $0xc,%esp
80105df7:	ff 75 f4             	pushl  -0xc(%ebp)
80105dfa:	e8 80 b9 ff ff       	call   8010177f <iupdate>
80105dff:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105e02:	83 ec 0c             	sub    $0xc,%esp
80105e05:	ff 75 f4             	pushl  -0xc(%ebp)
80105e08:	e8 03 be ff ff       	call   80101c10 <iunlockput>
80105e0d:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e13:	66 8b 40 16          	mov    0x16(%eax),%ax
80105e17:	48                   	dec    %eax
80105e18:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e1b:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105e1f:	83 ec 0c             	sub    $0xc,%esp
80105e22:	ff 75 f0             	pushl  -0x10(%ebp)
80105e25:	e8 55 b9 ff ff       	call   8010177f <iupdate>
80105e2a:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	ff 75 f0             	pushl  -0x10(%ebp)
80105e33:	e8 d8 bd ff ff       	call   80101c10 <iunlockput>
80105e38:	83 c4 10             	add    $0x10,%esp

  end_op();
80105e3b:	e8 ed d7 ff ff       	call   8010362d <end_op>

  return 0;
80105e40:	b8 00 00 00 00       	mov    $0x0,%eax
80105e45:	eb 18                	jmp    80105e5f <sys_unlink+0x1d7>

bad:
  iunlockput(dp);
80105e47:	83 ec 0c             	sub    $0xc,%esp
80105e4a:	ff 75 f4             	pushl  -0xc(%ebp)
80105e4d:	e8 be bd ff ff       	call   80101c10 <iunlockput>
80105e52:	83 c4 10             	add    $0x10,%esp
  end_op();
80105e55:	e8 d3 d7 ff ff       	call   8010362d <end_op>
  return -1;
80105e5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e5f:	c9                   	leave  
80105e60:	c3                   	ret    

80105e61 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105e61:	55                   	push   %ebp
80105e62:	89 e5                	mov    %esp,%ebp
80105e64:	83 ec 38             	sub    $0x38,%esp
80105e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e6a:	8b 55 10             	mov    0x10(%ebp),%edx
80105e6d:	8b 45 14             	mov    0x14(%ebp),%eax
80105e70:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105e74:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e78:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e7c:	83 ec 08             	sub    $0x8,%esp
80105e7f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e82:	50                   	push   %eax
80105e83:	ff 75 08             	pushl  0x8(%ebp)
80105e86:	e8 99 c6 ff ff       	call   80102524 <nameiparent>
80105e8b:	83 c4 10             	add    $0x10,%esp
80105e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e95:	75 0a                	jne    80105ea1 <create+0x40>
    return 0;
80105e97:	b8 00 00 00 00       	mov    $0x0,%eax
80105e9c:	e9 89 01 00 00       	jmp    8010602a <create+0x1c9>
  ilock(dp);
80105ea1:	83 ec 0c             	sub    $0xc,%esp
80105ea4:	ff 75 f4             	pushl  -0xc(%ebp)
80105ea7:	e8 aa ba ff ff       	call   80101956 <ilock>
80105eac:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105eaf:	83 ec 04             	sub    $0x4,%esp
80105eb2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105eb5:	50                   	push   %eax
80105eb6:	8d 45 de             	lea    -0x22(%ebp),%eax
80105eb9:	50                   	push   %eax
80105eba:	ff 75 f4             	pushl  -0xc(%ebp)
80105ebd:	e8 02 c3 ff ff       	call   801021c4 <dirlookup>
80105ec2:	83 c4 10             	add    $0x10,%esp
80105ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ec8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ecc:	74 4f                	je     80105f1d <create+0xbc>
    iunlockput(dp);
80105ece:	83 ec 0c             	sub    $0xc,%esp
80105ed1:	ff 75 f4             	pushl  -0xc(%ebp)
80105ed4:	e8 37 bd ff ff       	call   80101c10 <iunlockput>
80105ed9:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105edc:	83 ec 0c             	sub    $0xc,%esp
80105edf:	ff 75 f0             	pushl  -0x10(%ebp)
80105ee2:	e8 6f ba ff ff       	call   80101956 <ilock>
80105ee7:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105eea:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105eef:	75 14                	jne    80105f05 <create+0xa4>
80105ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef4:	8b 40 10             	mov    0x10(%eax),%eax
80105ef7:	66 83 f8 02          	cmp    $0x2,%ax
80105efb:	75 08                	jne    80105f05 <create+0xa4>
      return ip;
80105efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f00:	e9 25 01 00 00       	jmp    8010602a <create+0x1c9>
    iunlockput(ip);
80105f05:	83 ec 0c             	sub    $0xc,%esp
80105f08:	ff 75 f0             	pushl  -0x10(%ebp)
80105f0b:	e8 00 bd ff ff       	call   80101c10 <iunlockput>
80105f10:	83 c4 10             	add    $0x10,%esp
    return 0;
80105f13:	b8 00 00 00 00       	mov    $0x0,%eax
80105f18:	e9 0d 01 00 00       	jmp    8010602a <create+0x1c9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105f1d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f24:	8b 00                	mov    (%eax),%eax
80105f26:	83 ec 08             	sub    $0x8,%esp
80105f29:	52                   	push   %edx
80105f2a:	50                   	push   %eax
80105f2b:	e8 7c b7 ff ff       	call   801016ac <ialloc>
80105f30:	83 c4 10             	add    $0x10,%esp
80105f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f3a:	75 0d                	jne    80105f49 <create+0xe8>
    panic("create: ialloc");
80105f3c:	83 ec 0c             	sub    $0xc,%esp
80105f3f:	68 3f 8d 10 80       	push   $0x80108d3f
80105f44:	e8 80 a6 ff ff       	call   801005c9 <panic>

  ilock(ip);
80105f49:	83 ec 0c             	sub    $0xc,%esp
80105f4c:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4f:	e8 02 ba ff ff       	call   80101956 <ilock>
80105f54:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105f57:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105f5d:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80105f61:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f64:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105f67:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80105f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6e:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105f74:	83 ec 0c             	sub    $0xc,%esp
80105f77:	ff 75 f0             	pushl  -0x10(%ebp)
80105f7a:	e8 00 b8 ff ff       	call   8010177f <iupdate>
80105f7f:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105f82:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f87:	75 66                	jne    80105fef <create+0x18e>
    dp->nlink++;  // for ".."
80105f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f8c:	66 8b 40 16          	mov    0x16(%eax),%ax
80105f90:	40                   	inc    %eax
80105f91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f94:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105f98:	83 ec 0c             	sub    $0xc,%esp
80105f9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f9e:	e8 dc b7 ff ff       	call   8010177f <iupdate>
80105fa3:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa9:	8b 40 04             	mov    0x4(%eax),%eax
80105fac:	83 ec 04             	sub    $0x4,%esp
80105faf:	50                   	push   %eax
80105fb0:	68 19 8d 10 80       	push   $0x80108d19
80105fb5:	ff 75 f0             	pushl  -0x10(%ebp)
80105fb8:	e8 bf c2 ff ff       	call   8010227c <dirlink>
80105fbd:	83 c4 10             	add    $0x10,%esp
80105fc0:	85 c0                	test   %eax,%eax
80105fc2:	78 1e                	js     80105fe2 <create+0x181>
80105fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc7:	8b 40 04             	mov    0x4(%eax),%eax
80105fca:	83 ec 04             	sub    $0x4,%esp
80105fcd:	50                   	push   %eax
80105fce:	68 1b 8d 10 80       	push   $0x80108d1b
80105fd3:	ff 75 f0             	pushl  -0x10(%ebp)
80105fd6:	e8 a1 c2 ff ff       	call   8010227c <dirlink>
80105fdb:	83 c4 10             	add    $0x10,%esp
80105fde:	85 c0                	test   %eax,%eax
80105fe0:	79 0d                	jns    80105fef <create+0x18e>
      panic("create dots");
80105fe2:	83 ec 0c             	sub    $0xc,%esp
80105fe5:	68 4e 8d 10 80       	push   $0x80108d4e
80105fea:	e8 da a5 ff ff       	call   801005c9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff2:	8b 40 04             	mov    0x4(%eax),%eax
80105ff5:	83 ec 04             	sub    $0x4,%esp
80105ff8:	50                   	push   %eax
80105ff9:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ffc:	50                   	push   %eax
80105ffd:	ff 75 f4             	pushl  -0xc(%ebp)
80106000:	e8 77 c2 ff ff       	call   8010227c <dirlink>
80106005:	83 c4 10             	add    $0x10,%esp
80106008:	85 c0                	test   %eax,%eax
8010600a:	79 0d                	jns    80106019 <create+0x1b8>
    panic("create: dirlink");
8010600c:	83 ec 0c             	sub    $0xc,%esp
8010600f:	68 5a 8d 10 80       	push   $0x80108d5a
80106014:	e8 b0 a5 ff ff       	call   801005c9 <panic>

  iunlockput(dp);
80106019:	83 ec 0c             	sub    $0xc,%esp
8010601c:	ff 75 f4             	pushl  -0xc(%ebp)
8010601f:	e8 ec bb ff ff       	call   80101c10 <iunlockput>
80106024:	83 c4 10             	add    $0x10,%esp

  return ip;
80106027:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010602a:	c9                   	leave  
8010602b:	c3                   	ret    

8010602c <sys_open>:

int
sys_open(void)
{
8010602c:	55                   	push   %ebp
8010602d:	89 e5                	mov    %esp,%ebp
8010602f:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106032:	83 ec 08             	sub    $0x8,%esp
80106035:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106038:	50                   	push   %eax
80106039:	6a 00                	push   $0x0
8010603b:	e8 07 f7 ff ff       	call   80105747 <argstr>
80106040:	83 c4 10             	add    $0x10,%esp
80106043:	85 c0                	test   %eax,%eax
80106045:	78 15                	js     8010605c <sys_open+0x30>
80106047:	83 ec 08             	sub    $0x8,%esp
8010604a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010604d:	50                   	push   %eax
8010604e:	6a 01                	push   $0x1
80106050:	e8 6b f6 ff ff       	call   801056c0 <argint>
80106055:	83 c4 10             	add    $0x10,%esp
80106058:	85 c0                	test   %eax,%eax
8010605a:	79 0a                	jns    80106066 <sys_open+0x3a>
    return -1;
8010605c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106061:	e9 60 01 00 00       	jmp    801061c6 <sys_open+0x19a>

  begin_op();
80106066:	e8 36 d5 ff ff       	call   801035a1 <begin_op>

  if(omode & O_CREATE){
8010606b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010606e:	25 00 02 00 00       	and    $0x200,%eax
80106073:	85 c0                	test   %eax,%eax
80106075:	74 2a                	je     801060a1 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106077:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010607a:	6a 00                	push   $0x0
8010607c:	6a 00                	push   $0x0
8010607e:	6a 02                	push   $0x2
80106080:	50                   	push   %eax
80106081:	e8 db fd ff ff       	call   80105e61 <create>
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010608c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106090:	75 74                	jne    80106106 <sys_open+0xda>
      end_op();
80106092:	e8 96 d5 ff ff       	call   8010362d <end_op>
      return -1;
80106097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609c:	e9 25 01 00 00       	jmp    801061c6 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
801060a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060a4:	83 ec 0c             	sub    $0xc,%esp
801060a7:	50                   	push   %eax
801060a8:	e8 5b c4 ff ff       	call   80102508 <namei>
801060ad:	83 c4 10             	add    $0x10,%esp
801060b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b7:	75 0f                	jne    801060c8 <sys_open+0x9c>
      end_op();
801060b9:	e8 6f d5 ff ff       	call   8010362d <end_op>
      return -1;
801060be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c3:	e9 fe 00 00 00       	jmp    801061c6 <sys_open+0x19a>
    }
    ilock(ip);
801060c8:	83 ec 0c             	sub    $0xc,%esp
801060cb:	ff 75 f4             	pushl  -0xc(%ebp)
801060ce:	e8 83 b8 ff ff       	call   80101956 <ilock>
801060d3:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801060d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d9:	8b 40 10             	mov    0x10(%eax),%eax
801060dc:	66 83 f8 01          	cmp    $0x1,%ax
801060e0:	75 24                	jne    80106106 <sys_open+0xda>
801060e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060e5:	85 c0                	test   %eax,%eax
801060e7:	74 1d                	je     80106106 <sys_open+0xda>
      iunlockput(ip);
801060e9:	83 ec 0c             	sub    $0xc,%esp
801060ec:	ff 75 f4             	pushl  -0xc(%ebp)
801060ef:	e8 1c bb ff ff       	call   80101c10 <iunlockput>
801060f4:	83 c4 10             	add    $0x10,%esp
      end_op();
801060f7:	e8 31 d5 ff ff       	call   8010362d <end_op>
      return -1;
801060fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106101:	e9 c0 00 00 00       	jmp    801061c6 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106106:	e8 9b ae ff ff       	call   80100fa6 <filealloc>
8010610b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010610e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106112:	74 17                	je     8010612b <sys_open+0xff>
80106114:	83 ec 0c             	sub    $0xc,%esp
80106117:	ff 75 f0             	pushl  -0x10(%ebp)
8010611a:	e8 53 f7 ff ff       	call   80105872 <fdalloc>
8010611f:	83 c4 10             	add    $0x10,%esp
80106122:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106125:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106129:	79 2e                	jns    80106159 <sys_open+0x12d>
    if(f)
8010612b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010612f:	74 0e                	je     8010613f <sys_open+0x113>
      fileclose(f);
80106131:	83 ec 0c             	sub    $0xc,%esp
80106134:	ff 75 f0             	pushl  -0x10(%ebp)
80106137:	e8 27 af ff ff       	call   80101063 <fileclose>
8010613c:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010613f:	83 ec 0c             	sub    $0xc,%esp
80106142:	ff 75 f4             	pushl  -0xc(%ebp)
80106145:	e8 c6 ba ff ff       	call   80101c10 <iunlockput>
8010614a:	83 c4 10             	add    $0x10,%esp
    end_op();
8010614d:	e8 db d4 ff ff       	call   8010362d <end_op>
    return -1;
80106152:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106157:	eb 6d                	jmp    801061c6 <sys_open+0x19a>
  }
  iunlock(ip);
80106159:	83 ec 0c             	sub    $0xc,%esp
8010615c:	ff 75 f4             	pushl  -0xc(%ebp)
8010615f:	e8 4c b9 ff ff       	call   80101ab0 <iunlock>
80106164:	83 c4 10             	add    $0x10,%esp
  end_op();
80106167:	e8 c1 d4 ff ff       	call   8010362d <end_op>

  f->type = FD_INODE;
8010616c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010616f:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106175:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106178:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010617b:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010617e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106181:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106188:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010618b:	83 e0 01             	and    $0x1,%eax
8010618e:	85 c0                	test   %eax,%eax
80106190:	0f 94 c0             	sete   %al
80106193:	88 c2                	mov    %al,%dl
80106195:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106198:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010619b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010619e:	83 e0 01             	and    $0x1,%eax
801061a1:	85 c0                	test   %eax,%eax
801061a3:	75 0a                	jne    801061af <sys_open+0x183>
801061a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061a8:	83 e0 02             	and    $0x2,%eax
801061ab:	85 c0                	test   %eax,%eax
801061ad:	74 07                	je     801061b6 <sys_open+0x18a>
801061af:	b8 01 00 00 00       	mov    $0x1,%eax
801061b4:	eb 05                	jmp    801061bb <sys_open+0x18f>
801061b6:	b8 00 00 00 00       	mov    $0x0,%eax
801061bb:	88 c2                	mov    %al,%dl
801061bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c0:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801061c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801061c6:	c9                   	leave  
801061c7:	c3                   	ret    

801061c8 <sys_mkdir>:

int
sys_mkdir(void)
{
801061c8:	55                   	push   %ebp
801061c9:	89 e5                	mov    %esp,%ebp
801061cb:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801061ce:	e8 ce d3 ff ff       	call   801035a1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801061d3:	83 ec 08             	sub    $0x8,%esp
801061d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061d9:	50                   	push   %eax
801061da:	6a 00                	push   $0x0
801061dc:	e8 66 f5 ff ff       	call   80105747 <argstr>
801061e1:	83 c4 10             	add    $0x10,%esp
801061e4:	85 c0                	test   %eax,%eax
801061e6:	78 1b                	js     80106203 <sys_mkdir+0x3b>
801061e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061eb:	6a 00                	push   $0x0
801061ed:	6a 00                	push   $0x0
801061ef:	6a 01                	push   $0x1
801061f1:	50                   	push   %eax
801061f2:	e8 6a fc ff ff       	call   80105e61 <create>
801061f7:	83 c4 10             	add    $0x10,%esp
801061fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106201:	75 0c                	jne    8010620f <sys_mkdir+0x47>
    end_op();
80106203:	e8 25 d4 ff ff       	call   8010362d <end_op>
    return -1;
80106208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010620d:	eb 18                	jmp    80106227 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010620f:	83 ec 0c             	sub    $0xc,%esp
80106212:	ff 75 f4             	pushl  -0xc(%ebp)
80106215:	e8 f6 b9 ff ff       	call   80101c10 <iunlockput>
8010621a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010621d:	e8 0b d4 ff ff       	call   8010362d <end_op>
  return 0;
80106222:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106227:	c9                   	leave  
80106228:	c3                   	ret    

80106229 <sys_mknod>:

int
sys_mknod(void)
{
80106229:	55                   	push   %ebp
8010622a:	89 e5                	mov    %esp,%ebp
8010622c:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010622f:	e8 6d d3 ff ff       	call   801035a1 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106234:	83 ec 08             	sub    $0x8,%esp
80106237:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010623a:	50                   	push   %eax
8010623b:	6a 00                	push   $0x0
8010623d:	e8 05 f5 ff ff       	call   80105747 <argstr>
80106242:	83 c4 10             	add    $0x10,%esp
80106245:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010624c:	78 4f                	js     8010629d <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010624e:	83 ec 08             	sub    $0x8,%esp
80106251:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106254:	50                   	push   %eax
80106255:	6a 01                	push   $0x1
80106257:	e8 64 f4 ff ff       	call   801056c0 <argint>
8010625c:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010625f:	85 c0                	test   %eax,%eax
80106261:	78 3a                	js     8010629d <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106263:	83 ec 08             	sub    $0x8,%esp
80106266:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106269:	50                   	push   %eax
8010626a:	6a 02                	push   $0x2
8010626c:	e8 4f f4 ff ff       	call   801056c0 <argint>
80106271:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106274:	85 c0                	test   %eax,%eax
80106276:	78 25                	js     8010629d <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010627b:	0f bf c8             	movswl %ax,%ecx
8010627e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106281:	0f bf d0             	movswl %ax,%edx
80106284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106287:	51                   	push   %ecx
80106288:	52                   	push   %edx
80106289:	6a 03                	push   $0x3
8010628b:	50                   	push   %eax
8010628c:	e8 d0 fb ff ff       	call   80105e61 <create>
80106291:	83 c4 10             	add    $0x10,%esp
80106294:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106297:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010629b:	75 0c                	jne    801062a9 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
8010629d:	e8 8b d3 ff ff       	call   8010362d <end_op>
    return -1;
801062a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a7:	eb 18                	jmp    801062c1 <sys_mknod+0x98>
  }
  iunlockput(ip);
801062a9:	83 ec 0c             	sub    $0xc,%esp
801062ac:	ff 75 f0             	pushl  -0x10(%ebp)
801062af:	e8 5c b9 ff ff       	call   80101c10 <iunlockput>
801062b4:	83 c4 10             	add    $0x10,%esp
  end_op();
801062b7:	e8 71 d3 ff ff       	call   8010362d <end_op>
  return 0;
801062bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062c1:	c9                   	leave  
801062c2:	c3                   	ret    

801062c3 <sys_chdir>:

int
sys_chdir(void)
{
801062c3:	55                   	push   %ebp
801062c4:	89 e5                	mov    %esp,%ebp
801062c6:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801062c9:	e8 d3 d2 ff ff       	call   801035a1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801062ce:	83 ec 08             	sub    $0x8,%esp
801062d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062d4:	50                   	push   %eax
801062d5:	6a 00                	push   $0x0
801062d7:	e8 6b f4 ff ff       	call   80105747 <argstr>
801062dc:	83 c4 10             	add    $0x10,%esp
801062df:	85 c0                	test   %eax,%eax
801062e1:	78 18                	js     801062fb <sys_chdir+0x38>
801062e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e6:	83 ec 0c             	sub    $0xc,%esp
801062e9:	50                   	push   %eax
801062ea:	e8 19 c2 ff ff       	call   80102508 <namei>
801062ef:	83 c4 10             	add    $0x10,%esp
801062f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062f9:	75 0c                	jne    80106307 <sys_chdir+0x44>
    end_op();
801062fb:	e8 2d d3 ff ff       	call   8010362d <end_op>
    return -1;
80106300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106305:	eb 6d                	jmp    80106374 <sys_chdir+0xb1>
  }
  ilock(ip);
80106307:	83 ec 0c             	sub    $0xc,%esp
8010630a:	ff 75 f4             	pushl  -0xc(%ebp)
8010630d:	e8 44 b6 ff ff       	call   80101956 <ilock>
80106312:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106315:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106318:	8b 40 10             	mov    0x10(%eax),%eax
8010631b:	66 83 f8 01          	cmp    $0x1,%ax
8010631f:	74 1a                	je     8010633b <sys_chdir+0x78>
    iunlockput(ip);
80106321:	83 ec 0c             	sub    $0xc,%esp
80106324:	ff 75 f4             	pushl  -0xc(%ebp)
80106327:	e8 e4 b8 ff ff       	call   80101c10 <iunlockput>
8010632c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010632f:	e8 f9 d2 ff ff       	call   8010362d <end_op>
    return -1;
80106334:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106339:	eb 39                	jmp    80106374 <sys_chdir+0xb1>
  }
  iunlock(ip);
8010633b:	83 ec 0c             	sub    $0xc,%esp
8010633e:	ff 75 f4             	pushl  -0xc(%ebp)
80106341:	e8 6a b7 ff ff       	call   80101ab0 <iunlock>
80106346:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106349:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010634f:	8b 40 68             	mov    0x68(%eax),%eax
80106352:	83 ec 0c             	sub    $0xc,%esp
80106355:	50                   	push   %eax
80106356:	e8 c6 b7 ff ff       	call   80101b21 <iput>
8010635b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010635e:	e8 ca d2 ff ff       	call   8010362d <end_op>
  proc->cwd = ip;
80106363:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106369:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010636c:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010636f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106374:	c9                   	leave  
80106375:	c3                   	ret    

80106376 <sys_exec>:

int
sys_exec(void)
{
80106376:	55                   	push   %ebp
80106377:	89 e5                	mov    %esp,%ebp
80106379:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010637f:	83 ec 08             	sub    $0x8,%esp
80106382:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106385:	50                   	push   %eax
80106386:	6a 00                	push   $0x0
80106388:	e8 ba f3 ff ff       	call   80105747 <argstr>
8010638d:	83 c4 10             	add    $0x10,%esp
80106390:	85 c0                	test   %eax,%eax
80106392:	78 18                	js     801063ac <sys_exec+0x36>
80106394:	83 ec 08             	sub    $0x8,%esp
80106397:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010639d:	50                   	push   %eax
8010639e:	6a 01                	push   $0x1
801063a0:	e8 1b f3 ff ff       	call   801056c0 <argint>
801063a5:	83 c4 10             	add    $0x10,%esp
801063a8:	85 c0                	test   %eax,%eax
801063aa:	79 0a                	jns    801063b6 <sys_exec+0x40>
    return -1;
801063ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b1:	e9 c5 00 00 00       	jmp    8010647b <sys_exec+0x105>
  }
  memset(argv, 0, sizeof(argv));
801063b6:	83 ec 04             	sub    $0x4,%esp
801063b9:	68 80 00 00 00       	push   $0x80
801063be:	6a 00                	push   $0x0
801063c0:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801063c6:	50                   	push   %eax
801063c7:	e8 e8 ef ff ff       	call   801053b4 <memset>
801063cc:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801063cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801063d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d9:	83 f8 1f             	cmp    $0x1f,%eax
801063dc:	76 0a                	jbe    801063e8 <sys_exec+0x72>
      return -1;
801063de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063e3:	e9 93 00 00 00       	jmp    8010647b <sys_exec+0x105>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063eb:	c1 e0 02             	shl    $0x2,%eax
801063ee:	89 c2                	mov    %eax,%edx
801063f0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801063f6:	01 c2                	add    %eax,%edx
801063f8:	83 ec 08             	sub    $0x8,%esp
801063fb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106401:	50                   	push   %eax
80106402:	52                   	push   %edx
80106403:	e8 1e f2 ff ff       	call   80105626 <fetchint>
80106408:	83 c4 10             	add    $0x10,%esp
8010640b:	85 c0                	test   %eax,%eax
8010640d:	79 07                	jns    80106416 <sys_exec+0xa0>
      return -1;
8010640f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106414:	eb 65                	jmp    8010647b <sys_exec+0x105>
    if(uarg == 0){
80106416:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010641c:	85 c0                	test   %eax,%eax
8010641e:	75 27                	jne    80106447 <sys_exec+0xd1>
      argv[i] = 0;
80106420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106423:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010642a:	00 00 00 00 
      break;
8010642e:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010642f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106432:	83 ec 08             	sub    $0x8,%esp
80106435:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010643b:	52                   	push   %edx
8010643c:	50                   	push   %eax
8010643d:	e8 66 a7 ff ff       	call   80100ba8 <exec>
80106442:	83 c4 10             	add    $0x10,%esp
80106445:	eb 34                	jmp    8010647b <sys_exec+0x105>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106447:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010644d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106450:	c1 e2 02             	shl    $0x2,%edx
80106453:	01 c2                	add    %eax,%edx
80106455:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010645b:	83 ec 08             	sub    $0x8,%esp
8010645e:	52                   	push   %edx
8010645f:	50                   	push   %eax
80106460:	e8 fb f1 ff ff       	call   80105660 <fetchstr>
80106465:	83 c4 10             	add    $0x10,%esp
80106468:	85 c0                	test   %eax,%eax
8010646a:	79 07                	jns    80106473 <sys_exec+0xfd>
      return -1;
8010646c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106471:	eb 08                	jmp    8010647b <sys_exec+0x105>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106473:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106476:	e9 5b ff ff ff       	jmp    801063d6 <sys_exec+0x60>
  return exec(path, argv);
}
8010647b:	c9                   	leave  
8010647c:	c3                   	ret    

8010647d <sys_pipe>:

int
sys_pipe(void)
{
8010647d:	55                   	push   %ebp
8010647e:	89 e5                	mov    %esp,%ebp
80106480:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106483:	83 ec 04             	sub    $0x4,%esp
80106486:	6a 08                	push   $0x8
80106488:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010648b:	50                   	push   %eax
8010648c:	6a 00                	push   $0x0
8010648e:	e8 55 f2 ff ff       	call   801056e8 <argptr>
80106493:	83 c4 10             	add    $0x10,%esp
80106496:	85 c0                	test   %eax,%eax
80106498:	79 0a                	jns    801064a4 <sys_pipe+0x27>
    return -1;
8010649a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649f:	e9 af 00 00 00       	jmp    80106553 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801064a4:	83 ec 08             	sub    $0x8,%esp
801064a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064aa:	50                   	push   %eax
801064ab:	8d 45 e8             	lea    -0x18(%ebp),%eax
801064ae:	50                   	push   %eax
801064af:	e8 23 dc ff ff       	call   801040d7 <pipealloc>
801064b4:	83 c4 10             	add    $0x10,%esp
801064b7:	85 c0                	test   %eax,%eax
801064b9:	79 0a                	jns    801064c5 <sys_pipe+0x48>
    return -1;
801064bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064c0:	e9 8e 00 00 00       	jmp    80106553 <sys_pipe+0xd6>
  fd0 = -1;
801064c5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064cf:	83 ec 0c             	sub    $0xc,%esp
801064d2:	50                   	push   %eax
801064d3:	e8 9a f3 ff ff       	call   80105872 <fdalloc>
801064d8:	83 c4 10             	add    $0x10,%esp
801064db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064e2:	78 18                	js     801064fc <sys_pipe+0x7f>
801064e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064e7:	83 ec 0c             	sub    $0xc,%esp
801064ea:	50                   	push   %eax
801064eb:	e8 82 f3 ff ff       	call   80105872 <fdalloc>
801064f0:	83 c4 10             	add    $0x10,%esp
801064f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064fa:	79 3f                	jns    8010653b <sys_pipe+0xbe>
    if(fd0 >= 0)
801064fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106500:	78 14                	js     80106516 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106502:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106508:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010650b:	83 c2 08             	add    $0x8,%edx
8010650e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106515:	00 
    fileclose(rf);
80106516:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106519:	83 ec 0c             	sub    $0xc,%esp
8010651c:	50                   	push   %eax
8010651d:	e8 41 ab ff ff       	call   80101063 <fileclose>
80106522:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106528:	83 ec 0c             	sub    $0xc,%esp
8010652b:	50                   	push   %eax
8010652c:	e8 32 ab ff ff       	call   80101063 <fileclose>
80106531:	83 c4 10             	add    $0x10,%esp
    return -1;
80106534:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106539:	eb 18                	jmp    80106553 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010653b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010653e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106541:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106543:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106546:	8d 50 04             	lea    0x4(%eax),%edx
80106549:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010654c:	89 02                	mov    %eax,(%edx)
  return 0;
8010654e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106553:	c9                   	leave  
80106554:	c3                   	ret    

80106555 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106555:	55                   	push   %ebp
80106556:	89 e5                	mov    %esp,%ebp
80106558:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010655b:	e8 74 e2 ff ff       	call   801047d4 <fork>
}
80106560:	c9                   	leave  
80106561:	c3                   	ret    

80106562 <sys_exit>:

int
sys_exit(void)
{
80106562:	55                   	push   %ebp
80106563:	89 e5                	mov    %esp,%ebp
80106565:	83 ec 08             	sub    $0x8,%esp
  exit();
80106568:	e8 f1 e3 ff ff       	call   8010495e <exit>
  return 0;  // not reached
8010656d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106572:	c9                   	leave  
80106573:	c3                   	ret    

80106574 <sys_wait>:

int
sys_wait(void)
{
80106574:	55                   	push   %ebp
80106575:	89 e5                	mov    %esp,%ebp
80106577:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010657a:	e8 16 e5 ff ff       	call   80104a95 <wait>
}
8010657f:	c9                   	leave  
80106580:	c3                   	ret    

80106581 <sys_kill>:

int
sys_kill(void)
{
80106581:	55                   	push   %ebp
80106582:	89 e5                	mov    %esp,%ebp
80106584:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106587:	83 ec 08             	sub    $0x8,%esp
8010658a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010658d:	50                   	push   %eax
8010658e:	6a 00                	push   $0x0
80106590:	e8 2b f1 ff ff       	call   801056c0 <argint>
80106595:	83 c4 10             	add    $0x10,%esp
80106598:	85 c0                	test   %eax,%eax
8010659a:	79 07                	jns    801065a3 <sys_kill+0x22>
    return -1;
8010659c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a1:	eb 0f                	jmp    801065b2 <sys_kill+0x31>
  return kill(pid);
801065a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a6:	83 ec 0c             	sub    $0xc,%esp
801065a9:	50                   	push   %eax
801065aa:	e8 df e9 ff ff       	call   80104f8e <kill>
801065af:	83 c4 10             	add    $0x10,%esp
}
801065b2:	c9                   	leave  
801065b3:	c3                   	ret    

801065b4 <sys_getpid>:

int
sys_getpid(void)
{
801065b4:	55                   	push   %ebp
801065b5:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801065b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065bd:	8b 40 10             	mov    0x10(%eax),%eax
}
801065c0:	5d                   	pop    %ebp
801065c1:	c3                   	ret    

801065c2 <sys_sbrk>:

int
sys_sbrk(void)
{
801065c2:	55                   	push   %ebp
801065c3:	89 e5                	mov    %esp,%ebp
801065c5:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801065c8:	83 ec 08             	sub    $0x8,%esp
801065cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065ce:	50                   	push   %eax
801065cf:	6a 00                	push   $0x0
801065d1:	e8 ea f0 ff ff       	call   801056c0 <argint>
801065d6:	83 c4 10             	add    $0x10,%esp
801065d9:	85 c0                	test   %eax,%eax
801065db:	79 07                	jns    801065e4 <sys_sbrk+0x22>
    return -1;
801065dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e2:	eb 28                	jmp    8010660c <sys_sbrk+0x4a>
  addr = proc->sz;
801065e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065ea:	8b 00                	mov    (%eax),%eax
801065ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801065ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065f2:	83 ec 0c             	sub    $0xc,%esp
801065f5:	50                   	push   %eax
801065f6:	e8 36 e1 ff ff       	call   80104731 <growproc>
801065fb:	83 c4 10             	add    $0x10,%esp
801065fe:	85 c0                	test   %eax,%eax
80106600:	79 07                	jns    80106609 <sys_sbrk+0x47>
    return -1;
80106602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106607:	eb 03                	jmp    8010660c <sys_sbrk+0x4a>
  return addr;
80106609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010660c:	c9                   	leave  
8010660d:	c3                   	ret    

8010660e <sys_sleep>:

int
sys_sleep(void)
{
8010660e:	55                   	push   %ebp
8010660f:	89 e5                	mov    %esp,%ebp
80106611:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106614:	83 ec 08             	sub    $0x8,%esp
80106617:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010661a:	50                   	push   %eax
8010661b:	6a 00                	push   $0x0
8010661d:	e8 9e f0 ff ff       	call   801056c0 <argint>
80106622:	83 c4 10             	add    $0x10,%esp
80106625:	85 c0                	test   %eax,%eax
80106627:	79 07                	jns    80106630 <sys_sleep+0x22>
    return -1;
80106629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010662e:	eb 79                	jmp    801066a9 <sys_sleep+0x9b>
  acquire(&tickslock);
80106630:	83 ec 0c             	sub    $0xc,%esp
80106633:	68 80 53 11 80       	push   $0x80115380
80106638:	e8 1f eb ff ff       	call   8010515c <acquire>
8010663d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106640:	a1 c0 5b 11 80       	mov    0x80115bc0,%eax
80106645:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106648:	eb 39                	jmp    80106683 <sys_sleep+0x75>
    if(proc->killed){
8010664a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106650:	8b 40 24             	mov    0x24(%eax),%eax
80106653:	85 c0                	test   %eax,%eax
80106655:	74 17                	je     8010666e <sys_sleep+0x60>
      release(&tickslock);
80106657:	83 ec 0c             	sub    $0xc,%esp
8010665a:	68 80 53 11 80       	push   $0x80115380
8010665f:	e8 5e eb ff ff       	call   801051c2 <release>
80106664:	83 c4 10             	add    $0x10,%esp
      return -1;
80106667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010666c:	eb 3b                	jmp    801066a9 <sys_sleep+0x9b>
    }
    sleep(&ticks, &tickslock);
8010666e:	83 ec 08             	sub    $0x8,%esp
80106671:	68 80 53 11 80       	push   $0x80115380
80106676:	68 c0 5b 11 80       	push   $0x80115bc0
8010667b:	e8 ef e7 ff ff       	call   80104e6f <sleep>
80106680:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106683:	a1 c0 5b 11 80       	mov    0x80115bc0,%eax
80106688:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010668b:	89 c2                	mov    %eax,%edx
8010668d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106690:	39 c2                	cmp    %eax,%edx
80106692:	72 b6                	jb     8010664a <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106694:	83 ec 0c             	sub    $0xc,%esp
80106697:	68 80 53 11 80       	push   $0x80115380
8010669c:	e8 21 eb ff ff       	call   801051c2 <release>
801066a1:	83 c4 10             	add    $0x10,%esp
  return 0;
801066a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066a9:	c9                   	leave  
801066aa:	c3                   	ret    

801066ab <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801066ab:	55                   	push   %ebp
801066ac:	89 e5                	mov    %esp,%ebp
801066ae:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
801066b1:	83 ec 0c             	sub    $0xc,%esp
801066b4:	68 80 53 11 80       	push   $0x80115380
801066b9:	e8 9e ea ff ff       	call   8010515c <acquire>
801066be:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801066c1:	a1 c0 5b 11 80       	mov    0x80115bc0,%eax
801066c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801066c9:	83 ec 0c             	sub    $0xc,%esp
801066cc:	68 80 53 11 80       	push   $0x80115380
801066d1:	e8 ec ea ff ff       	call   801051c2 <release>
801066d6:	83 c4 10             	add    $0x10,%esp
  return xticks;
801066d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801066dc:	c9                   	leave  
801066dd:	c3                   	ret    

801066de <sys_gettime>:

int
sys_gettime(void) {
801066de:	55                   	push   %ebp
801066df:	89 e5                	mov    %esp,%ebp
801066e1:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;
  if (argptr(0, (char **)&d, sizeof(struct rtcdate)) < 0)
801066e4:	83 ec 04             	sub    $0x4,%esp
801066e7:	6a 18                	push   $0x18
801066e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066ec:	50                   	push   %eax
801066ed:	6a 00                	push   $0x0
801066ef:	e8 f4 ef ff ff       	call   801056e8 <argptr>
801066f4:	83 c4 10             	add    $0x10,%esp
801066f7:	85 c0                	test   %eax,%eax
801066f9:	79 07                	jns    80106702 <sys_gettime+0x24>
      return -1;
801066fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106700:	eb 14                	jmp    80106716 <sys_gettime+0x38>
  cmostime(d);
80106702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106705:	83 ec 0c             	sub    $0xc,%esp
80106708:	50                   	push   %eax
80106709:	e8 5c ca ff ff       	call   8010316a <cmostime>
8010670e:	83 c4 10             	add    $0x10,%esp
  return 0;
80106711:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106716:	c9                   	leave  
80106717:	c3                   	ret    

80106718 <sys_settickets>:

int
sys_settickets(void) {
80106718:	55                   	push   %ebp
80106719:	89 e5                	mov    %esp,%ebp
8010671b:	83 ec 18             	sub    $0x18,%esp
      int n;
      if(argint(0, &n) < 0) {
8010671e:	83 ec 08             	sub    $0x8,%esp
80106721:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106724:	50                   	push   %eax
80106725:	6a 00                	push   $0x0
80106727:	e8 94 ef ff ff       	call   801056c0 <argint>
8010672c:	83 c4 10             	add    $0x10,%esp
8010672f:	85 c0                	test   %eax,%eax
80106731:	79 0f                	jns    80106742 <sys_settickets+0x2a>
            proc->tickets = 10;
80106733:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106739:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)
80106740:	eb 0c                	jmp    8010674e <sys_settickets+0x36>
      }
      else {
            proc->tickets = n;
80106742:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106748:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010674b:	89 50 7c             	mov    %edx,0x7c(%eax)
      }
      return 0;
8010674e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106753:	c9                   	leave  
80106754:	c3                   	ret    

80106755 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106755:	55                   	push   %ebp
80106756:	89 e5                	mov    %esp,%ebp
80106758:	83 ec 08             	sub    $0x8,%esp
8010675b:	8b 45 08             	mov    0x8(%ebp),%eax
8010675e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106761:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106765:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106768:	8a 45 f8             	mov    -0x8(%ebp),%al
8010676b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010676e:	ee                   	out    %al,(%dx)
}
8010676f:	c9                   	leave  
80106770:	c3                   	ret    

80106771 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106771:	55                   	push   %ebp
80106772:	89 e5                	mov    %esp,%ebp
80106774:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106777:	6a 34                	push   $0x34
80106779:	6a 43                	push   $0x43
8010677b:	e8 d5 ff ff ff       	call   80106755 <outb>
80106780:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106783:	68 9c 00 00 00       	push   $0x9c
80106788:	6a 40                	push   $0x40
8010678a:	e8 c6 ff ff ff       	call   80106755 <outb>
8010678f:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106792:	6a 2e                	push   $0x2e
80106794:	6a 40                	push   $0x40
80106796:	e8 ba ff ff ff       	call   80106755 <outb>
8010679b:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010679e:	83 ec 0c             	sub    $0xc,%esp
801067a1:	6a 00                	push   $0x0
801067a3:	e8 1e d8 ff ff       	call   80103fc6 <picenable>
801067a8:	83 c4 10             	add    $0x10,%esp
}
801067ab:	c9                   	leave  
801067ac:	c3                   	ret    

801067ad <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801067ad:	1e                   	push   %ds
  pushl %es
801067ae:	06                   	push   %es
  pushl %fs
801067af:	0f a0                	push   %fs
  pushl %gs
801067b1:	0f a8                	push   %gs
  pushal
801067b3:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801067b4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067b8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067ba:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801067bc:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801067c0:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801067c2:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801067c4:	54                   	push   %esp
  call trap
801067c5:	e8 bb 01 00 00       	call   80106985 <trap>
  addl $4, %esp
801067ca:	83 c4 04             	add    $0x4,%esp

801067cd <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067cd:	61                   	popa   
  popl %gs
801067ce:	0f a9                	pop    %gs
  popl %fs
801067d0:	0f a1                	pop    %fs
  popl %es
801067d2:	07                   	pop    %es
  popl %ds
801067d3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067d4:	83 c4 08             	add    $0x8,%esp
  iret
801067d7:	cf                   	iret   

801067d8 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801067d8:	55                   	push   %ebp
801067d9:	89 e5                	mov    %esp,%ebp
801067db:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801067de:	8b 45 0c             	mov    0xc(%ebp),%eax
801067e1:	48                   	dec    %eax
801067e2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801067e6:	8b 45 08             	mov    0x8(%ebp),%eax
801067e9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801067ed:	8b 45 08             	mov    0x8(%ebp),%eax
801067f0:	c1 e8 10             	shr    $0x10,%eax
801067f3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801067f7:	8d 45 fa             	lea    -0x6(%ebp),%eax
801067fa:	0f 01 18             	lidtl  (%eax)
}
801067fd:	c9                   	leave  
801067fe:	c3                   	ret    

801067ff <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801067ff:	55                   	push   %ebp
80106800:	89 e5                	mov    %esp,%ebp
80106802:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106805:	0f 20 d0             	mov    %cr2,%eax
80106808:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010680b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010680e:	c9                   	leave  
8010680f:	c3                   	ret    

80106810 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106816:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010681d:	e9 b8 00 00 00       	jmp    801068da <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106825:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
8010682c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010682f:	66 89 04 d5 c0 53 11 	mov    %ax,-0x7feeac40(,%edx,8)
80106836:	80 
80106837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010683a:	66 c7 04 c5 c2 53 11 	movw   $0x8,-0x7feeac3e(,%eax,8)
80106841:	80 08 00 
80106844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106847:	8a 14 c5 c4 53 11 80 	mov    -0x7feeac3c(,%eax,8),%dl
8010684e:	83 e2 e0             	and    $0xffffffe0,%edx
80106851:	88 14 c5 c4 53 11 80 	mov    %dl,-0x7feeac3c(,%eax,8)
80106858:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010685b:	8a 14 c5 c4 53 11 80 	mov    -0x7feeac3c(,%eax,8),%dl
80106862:	83 e2 1f             	and    $0x1f,%edx
80106865:	88 14 c5 c4 53 11 80 	mov    %dl,-0x7feeac3c(,%eax,8)
8010686c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010686f:	8a 14 c5 c5 53 11 80 	mov    -0x7feeac3b(,%eax,8),%dl
80106876:	83 e2 f0             	and    $0xfffffff0,%edx
80106879:	83 ca 0e             	or     $0xe,%edx
8010687c:	88 14 c5 c5 53 11 80 	mov    %dl,-0x7feeac3b(,%eax,8)
80106883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106886:	8a 14 c5 c5 53 11 80 	mov    -0x7feeac3b(,%eax,8),%dl
8010688d:	83 e2 ef             	and    $0xffffffef,%edx
80106890:	88 14 c5 c5 53 11 80 	mov    %dl,-0x7feeac3b(,%eax,8)
80106897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010689a:	8a 14 c5 c5 53 11 80 	mov    -0x7feeac3b(,%eax,8),%dl
801068a1:	83 e2 9f             	and    $0xffffff9f,%edx
801068a4:	88 14 c5 c5 53 11 80 	mov    %dl,-0x7feeac3b(,%eax,8)
801068ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ae:	8a 14 c5 c5 53 11 80 	mov    -0x7feeac3b(,%eax,8),%dl
801068b5:	83 ca 80             	or     $0xffffff80,%edx
801068b8:	88 14 c5 c5 53 11 80 	mov    %dl,-0x7feeac3b(,%eax,8)
801068bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c2:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
801068c9:	c1 e8 10             	shr    $0x10,%eax
801068cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068cf:	66 89 04 d5 c6 53 11 	mov    %ax,-0x7feeac3a(,%edx,8)
801068d6:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801068d7:	ff 45 f4             	incl   -0xc(%ebp)
801068da:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801068e1:	0f 8e 3b ff ff ff    	jle    80106822 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801068e7:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
801068ec:	66 a3 c0 55 11 80    	mov    %ax,0x801155c0
801068f2:	66 c7 05 c2 55 11 80 	movw   $0x8,0x801155c2
801068f9:	08 00 
801068fb:	a0 c4 55 11 80       	mov    0x801155c4,%al
80106900:	83 e0 e0             	and    $0xffffffe0,%eax
80106903:	a2 c4 55 11 80       	mov    %al,0x801155c4
80106908:	a0 c4 55 11 80       	mov    0x801155c4,%al
8010690d:	83 e0 1f             	and    $0x1f,%eax
80106910:	a2 c4 55 11 80       	mov    %al,0x801155c4
80106915:	a0 c5 55 11 80       	mov    0x801155c5,%al
8010691a:	83 c8 0f             	or     $0xf,%eax
8010691d:	a2 c5 55 11 80       	mov    %al,0x801155c5
80106922:	a0 c5 55 11 80       	mov    0x801155c5,%al
80106927:	83 e0 ef             	and    $0xffffffef,%eax
8010692a:	a2 c5 55 11 80       	mov    %al,0x801155c5
8010692f:	a0 c5 55 11 80       	mov    0x801155c5,%al
80106934:	83 c8 60             	or     $0x60,%eax
80106937:	a2 c5 55 11 80       	mov    %al,0x801155c5
8010693c:	a0 c5 55 11 80       	mov    0x801155c5,%al
80106941:	83 c8 80             	or     $0xffffff80,%eax
80106944:	a2 c5 55 11 80       	mov    %al,0x801155c5
80106949:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
8010694e:	c1 e8 10             	shr    $0x10,%eax
80106951:	66 a3 c6 55 11 80    	mov    %ax,0x801155c6
  
  initlock(&tickslock, "time");
80106957:	83 ec 08             	sub    $0x8,%esp
8010695a:	68 6c 8d 10 80       	push   $0x80108d6c
8010695f:	68 80 53 11 80       	push   $0x80115380
80106964:	e8 d2 e7 ff ff       	call   8010513b <initlock>
80106969:	83 c4 10             	add    $0x10,%esp
}
8010696c:	c9                   	leave  
8010696d:	c3                   	ret    

8010696e <idtinit>:

void
idtinit(void)
{
8010696e:	55                   	push   %ebp
8010696f:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106971:	68 00 08 00 00       	push   $0x800
80106976:	68 c0 53 11 80       	push   $0x801153c0
8010697b:	e8 58 fe ff ff       	call   801067d8 <lidt>
80106980:	83 c4 08             	add    $0x8,%esp
}
80106983:	c9                   	leave  
80106984:	c3                   	ret    

80106985 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106985:	55                   	push   %ebp
80106986:	89 e5                	mov    %esp,%ebp
80106988:	57                   	push   %edi
80106989:	56                   	push   %esi
8010698a:	53                   	push   %ebx
8010698b:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010698e:	8b 45 08             	mov    0x8(%ebp),%eax
80106991:	8b 40 30             	mov    0x30(%eax),%eax
80106994:	83 f8 40             	cmp    $0x40,%eax
80106997:	75 3f                	jne    801069d8 <trap+0x53>
    if(proc->killed)
80106999:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010699f:	8b 40 24             	mov    0x24(%eax),%eax
801069a2:	85 c0                	test   %eax,%eax
801069a4:	74 05                	je     801069ab <trap+0x26>
      exit();
801069a6:	e8 b3 df ff ff       	call   8010495e <exit>
    proc->tf = tf;
801069ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069b1:	8b 55 08             	mov    0x8(%ebp),%edx
801069b4:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801069b7:	e8 bc ed ff ff       	call   80105778 <syscall>
    if(proc->killed)
801069bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c2:	8b 40 24             	mov    0x24(%eax),%eax
801069c5:	85 c0                	test   %eax,%eax
801069c7:	74 0a                	je     801069d3 <trap+0x4e>
      exit();
801069c9:	e8 90 df ff ff       	call   8010495e <exit>
    return;
801069ce:	e9 0b 02 00 00       	jmp    80106bde <trap+0x259>
801069d3:	e9 06 02 00 00       	jmp    80106bde <trap+0x259>
  }

  switch(tf->trapno){
801069d8:	8b 45 08             	mov    0x8(%ebp),%eax
801069db:	8b 40 30             	mov    0x30(%eax),%eax
801069de:	83 e8 20             	sub    $0x20,%eax
801069e1:	83 f8 1f             	cmp    $0x1f,%eax
801069e4:	0f 87 bb 00 00 00    	ja     80106aa5 <trap+0x120>
801069ea:	8b 04 85 14 8e 10 80 	mov    -0x7fef71ec(,%eax,4),%eax
801069f1:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801069f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069f9:	8a 00                	mov    (%eax),%al
801069fb:	84 c0                	test   %al,%al
801069fd:	75 3b                	jne    80106a3a <trap+0xb5>
      acquire(&tickslock);
801069ff:	83 ec 0c             	sub    $0xc,%esp
80106a02:	68 80 53 11 80       	push   $0x80115380
80106a07:	e8 50 e7 ff ff       	call   8010515c <acquire>
80106a0c:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106a0f:	a1 c0 5b 11 80       	mov    0x80115bc0,%eax
80106a14:	40                   	inc    %eax
80106a15:	a3 c0 5b 11 80       	mov    %eax,0x80115bc0
      wakeup(&ticks);
80106a1a:	83 ec 0c             	sub    $0xc,%esp
80106a1d:	68 c0 5b 11 80       	push   $0x80115bc0
80106a22:	e8 31 e5 ff ff       	call   80104f58 <wakeup>
80106a27:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106a2a:	83 ec 0c             	sub    $0xc,%esp
80106a2d:	68 80 53 11 80       	push   $0x80115380
80106a32:	e8 8b e7 ff ff       	call   801051c2 <release>
80106a37:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106a3a:	e8 99 c5 ff ff       	call   80102fd8 <lapiceoi>
    break;
80106a3f:	e9 18 01 00 00       	jmp    80106b5c <trap+0x1d7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106a44:	e8 c3 bd ff ff       	call   8010280c <ideintr>
    lapiceoi();
80106a49:	e8 8a c5 ff ff       	call   80102fd8 <lapiceoi>
    break;
80106a4e:	e9 09 01 00 00       	jmp    80106b5c <trap+0x1d7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106a53:	e8 8b c3 ff ff       	call   80102de3 <kbdintr>
    lapiceoi();
80106a58:	e8 7b c5 ff ff       	call   80102fd8 <lapiceoi>
    break;
80106a5d:	e9 fa 00 00 00       	jmp    80106b5c <trap+0x1d7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106a62:	e8 4c 03 00 00       	call   80106db3 <uartintr>
    lapiceoi();
80106a67:	e8 6c c5 ff ff       	call   80102fd8 <lapiceoi>
    break;
80106a6c:	e9 eb 00 00 00       	jmp    80106b5c <trap+0x1d7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a71:	8b 45 08             	mov    0x8(%ebp),%eax
80106a74:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106a77:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7a:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a7d:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106a80:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a86:	8a 00                	mov    (%eax),%al
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a88:	0f b6 c0             	movzbl %al,%eax
80106a8b:	51                   	push   %ecx
80106a8c:	52                   	push   %edx
80106a8d:	50                   	push   %eax
80106a8e:	68 74 8d 10 80       	push   $0x80108d74
80106a93:	e8 73 99 ff ff       	call   8010040b <cprintf>
80106a98:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106a9b:	e8 38 c5 ff ff       	call   80102fd8 <lapiceoi>
    break;
80106aa0:	e9 b7 00 00 00       	jmp    80106b5c <trap+0x1d7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106aa5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aab:	85 c0                	test   %eax,%eax
80106aad:	74 10                	je     80106abf <trap+0x13a>
80106aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab2:	8b 40 3c             	mov    0x3c(%eax),%eax
80106ab5:	0f b7 c0             	movzwl %ax,%eax
80106ab8:	83 e0 03             	and    $0x3,%eax
80106abb:	85 c0                	test   %eax,%eax
80106abd:	75 3e                	jne    80106afd <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106abf:	e8 3b fd ff ff       	call   801067ff <rcr2>
80106ac4:	8b 55 08             	mov    0x8(%ebp),%edx
80106ac7:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106aca:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106ad1:	8a 12                	mov    (%edx),%dl
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ad3:	0f b6 ca             	movzbl %dl,%ecx
80106ad6:	8b 55 08             	mov    0x8(%ebp),%edx
80106ad9:	8b 52 30             	mov    0x30(%edx),%edx
80106adc:	83 ec 0c             	sub    $0xc,%esp
80106adf:	50                   	push   %eax
80106ae0:	53                   	push   %ebx
80106ae1:	51                   	push   %ecx
80106ae2:	52                   	push   %edx
80106ae3:	68 98 8d 10 80       	push   $0x80108d98
80106ae8:	e8 1e 99 ff ff       	call   8010040b <cprintf>
80106aed:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106af0:	83 ec 0c             	sub    $0xc,%esp
80106af3:	68 ca 8d 10 80       	push   $0x80108dca
80106af8:	e8 cc 9a ff ff       	call   801005c9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106afd:	e8 fd fc ff ff       	call   801067ff <rcr2>
80106b02:	89 c2                	mov    %eax,%edx
80106b04:	8b 45 08             	mov    0x8(%ebp),%eax
80106b07:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106b0a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b10:	8a 00                	mov    (%eax),%al
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b12:	0f b6 f0             	movzbl %al,%esi
80106b15:	8b 45 08             	mov    0x8(%ebp),%eax
80106b18:	8b 58 34             	mov    0x34(%eax),%ebx
80106b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1e:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106b21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b27:	83 c0 6c             	add    $0x6c,%eax
80106b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b33:	8b 40 10             	mov    0x10(%eax),%eax
80106b36:	52                   	push   %edx
80106b37:	57                   	push   %edi
80106b38:	56                   	push   %esi
80106b39:	53                   	push   %ebx
80106b3a:	51                   	push   %ecx
80106b3b:	ff 75 e4             	pushl  -0x1c(%ebp)
80106b3e:	50                   	push   %eax
80106b3f:	68 d0 8d 10 80       	push   $0x80108dd0
80106b44:	e8 c2 98 ff ff       	call   8010040b <cprintf>
80106b49:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106b4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b52:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106b59:	eb 01                	jmp    80106b5c <trap+0x1d7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106b5b:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106b5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b62:	85 c0                	test   %eax,%eax
80106b64:	74 23                	je     80106b89 <trap+0x204>
80106b66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b6c:	8b 40 24             	mov    0x24(%eax),%eax
80106b6f:	85 c0                	test   %eax,%eax
80106b71:	74 16                	je     80106b89 <trap+0x204>
80106b73:	8b 45 08             	mov    0x8(%ebp),%eax
80106b76:	8b 40 3c             	mov    0x3c(%eax),%eax
80106b79:	0f b7 c0             	movzwl %ax,%eax
80106b7c:	83 e0 03             	and    $0x3,%eax
80106b7f:	83 f8 03             	cmp    $0x3,%eax
80106b82:	75 05                	jne    80106b89 <trap+0x204>
    exit();
80106b84:	e8 d5 dd ff ff       	call   8010495e <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106b89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b8f:	85 c0                	test   %eax,%eax
80106b91:	74 1e                	je     80106bb1 <trap+0x22c>
80106b93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b99:	8b 40 0c             	mov    0xc(%eax),%eax
80106b9c:	83 f8 04             	cmp    $0x4,%eax
80106b9f:	75 10                	jne    80106bb1 <trap+0x22c>
80106ba1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba4:	8b 40 30             	mov    0x30(%eax),%eax
80106ba7:	83 f8 20             	cmp    $0x20,%eax
80106baa:	75 05                	jne    80106bb1 <trap+0x22c>
    yield();
80106bac:	e8 3f e2 ff ff       	call   80104df0 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106bb1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bb7:	85 c0                	test   %eax,%eax
80106bb9:	74 23                	je     80106bde <trap+0x259>
80106bbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bc1:	8b 40 24             	mov    0x24(%eax),%eax
80106bc4:	85 c0                	test   %eax,%eax
80106bc6:	74 16                	je     80106bde <trap+0x259>
80106bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcb:	8b 40 3c             	mov    0x3c(%eax),%eax
80106bce:	0f b7 c0             	movzwl %ax,%eax
80106bd1:	83 e0 03             	and    $0x3,%eax
80106bd4:	83 f8 03             	cmp    $0x3,%eax
80106bd7:	75 05                	jne    80106bde <trap+0x259>
    exit();
80106bd9:	e8 80 dd ff ff       	call   8010495e <exit>
}
80106bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be1:	5b                   	pop    %ebx
80106be2:	5e                   	pop    %esi
80106be3:	5f                   	pop    %edi
80106be4:	5d                   	pop    %ebp
80106be5:	c3                   	ret    

80106be6 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106be6:	55                   	push   %ebp
80106be7:	89 e5                	mov    %esp,%ebp
80106be9:	83 ec 14             	sub    $0x14,%esp
80106bec:	8b 45 08             	mov    0x8(%ebp),%eax
80106bef:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106bf6:	89 c2                	mov    %eax,%edx
80106bf8:	ec                   	in     (%dx),%al
80106bf9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106bfc:	8a 45 ff             	mov    -0x1(%ebp),%al
}
80106bff:	c9                   	leave  
80106c00:	c3                   	ret    

80106c01 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106c01:	55                   	push   %ebp
80106c02:	89 e5                	mov    %esp,%ebp
80106c04:	83 ec 08             	sub    $0x8,%esp
80106c07:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c0d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106c11:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c14:	8a 45 f8             	mov    -0x8(%ebp),%al
80106c17:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c1a:	ee                   	out    %al,(%dx)
}
80106c1b:	c9                   	leave  
80106c1c:	c3                   	ret    

80106c1d <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106c1d:	55                   	push   %ebp
80106c1e:	89 e5                	mov    %esp,%ebp
80106c20:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106c23:	6a 00                	push   $0x0
80106c25:	68 fa 03 00 00       	push   $0x3fa
80106c2a:	e8 d2 ff ff ff       	call   80106c01 <outb>
80106c2f:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106c32:	68 80 00 00 00       	push   $0x80
80106c37:	68 fb 03 00 00       	push   $0x3fb
80106c3c:	e8 c0 ff ff ff       	call   80106c01 <outb>
80106c41:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106c44:	6a 0c                	push   $0xc
80106c46:	68 f8 03 00 00       	push   $0x3f8
80106c4b:	e8 b1 ff ff ff       	call   80106c01 <outb>
80106c50:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106c53:	6a 00                	push   $0x0
80106c55:	68 f9 03 00 00       	push   $0x3f9
80106c5a:	e8 a2 ff ff ff       	call   80106c01 <outb>
80106c5f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106c62:	6a 03                	push   $0x3
80106c64:	68 fb 03 00 00       	push   $0x3fb
80106c69:	e8 93 ff ff ff       	call   80106c01 <outb>
80106c6e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106c71:	6a 00                	push   $0x0
80106c73:	68 fc 03 00 00       	push   $0x3fc
80106c78:	e8 84 ff ff ff       	call   80106c01 <outb>
80106c7d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106c80:	6a 01                	push   $0x1
80106c82:	68 f9 03 00 00       	push   $0x3f9
80106c87:	e8 75 ff ff ff       	call   80106c01 <outb>
80106c8c:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106c8f:	68 fd 03 00 00       	push   $0x3fd
80106c94:	e8 4d ff ff ff       	call   80106be6 <inb>
80106c99:	83 c4 04             	add    $0x4,%esp
80106c9c:	3c ff                	cmp    $0xff,%al
80106c9e:	75 02                	jne    80106ca2 <uartinit+0x85>
    return;
80106ca0:	eb 69                	jmp    80106d0b <uartinit+0xee>
  uart = 1;
80106ca2:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106ca9:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106cac:	68 fa 03 00 00       	push   $0x3fa
80106cb1:	e8 30 ff ff ff       	call   80106be6 <inb>
80106cb6:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106cb9:	68 f8 03 00 00       	push   $0x3f8
80106cbe:	e8 23 ff ff ff       	call   80106be6 <inb>
80106cc3:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106cc6:	83 ec 0c             	sub    $0xc,%esp
80106cc9:	6a 04                	push   $0x4
80106ccb:	e8 f6 d2 ff ff       	call   80103fc6 <picenable>
80106cd0:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106cd3:	83 ec 08             	sub    $0x8,%esp
80106cd6:	6a 00                	push   $0x0
80106cd8:	6a 04                	push   $0x4
80106cda:	e8 c6 bd ff ff       	call   80102aa5 <ioapicenable>
80106cdf:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ce2:	c7 45 f4 94 8e 10 80 	movl   $0x80108e94,-0xc(%ebp)
80106ce9:	eb 17                	jmp    80106d02 <uartinit+0xe5>
    uartputc(*p);
80106ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cee:	8a 00                	mov    (%eax),%al
80106cf0:	0f be c0             	movsbl %al,%eax
80106cf3:	83 ec 0c             	sub    $0xc,%esp
80106cf6:	50                   	push   %eax
80106cf7:	e8 11 00 00 00       	call   80106d0d <uartputc>
80106cfc:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106cff:	ff 45 f4             	incl   -0xc(%ebp)
80106d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d05:	8a 00                	mov    (%eax),%al
80106d07:	84 c0                	test   %al,%al
80106d09:	75 e0                	jne    80106ceb <uartinit+0xce>
    uartputc(*p);
}
80106d0b:	c9                   	leave  
80106d0c:	c3                   	ret    

80106d0d <uartputc>:

void
uartputc(int c)
{
80106d0d:	55                   	push   %ebp
80106d0e:	89 e5                	mov    %esp,%ebp
80106d10:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106d13:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106d18:	85 c0                	test   %eax,%eax
80106d1a:	75 02                	jne    80106d1e <uartputc+0x11>
    return;
80106d1c:	eb 50                	jmp    80106d6e <uartputc+0x61>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106d25:	eb 10                	jmp    80106d37 <uartputc+0x2a>
    microdelay(10);
80106d27:	83 ec 0c             	sub    $0xc,%esp
80106d2a:	6a 0a                	push   $0xa
80106d2c:	e8 c1 c2 ff ff       	call   80102ff2 <microdelay>
80106d31:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d34:	ff 45 f4             	incl   -0xc(%ebp)
80106d37:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106d3b:	7f 1a                	jg     80106d57 <uartputc+0x4a>
80106d3d:	83 ec 0c             	sub    $0xc,%esp
80106d40:	68 fd 03 00 00       	push   $0x3fd
80106d45:	e8 9c fe ff ff       	call   80106be6 <inb>
80106d4a:	83 c4 10             	add    $0x10,%esp
80106d4d:	0f b6 c0             	movzbl %al,%eax
80106d50:	83 e0 20             	and    $0x20,%eax
80106d53:	85 c0                	test   %eax,%eax
80106d55:	74 d0                	je     80106d27 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106d57:	8b 45 08             	mov    0x8(%ebp),%eax
80106d5a:	0f b6 c0             	movzbl %al,%eax
80106d5d:	83 ec 08             	sub    $0x8,%esp
80106d60:	50                   	push   %eax
80106d61:	68 f8 03 00 00       	push   $0x3f8
80106d66:	e8 96 fe ff ff       	call   80106c01 <outb>
80106d6b:	83 c4 10             	add    $0x10,%esp
}
80106d6e:	c9                   	leave  
80106d6f:	c3                   	ret    

80106d70 <uartgetc>:

static int
uartgetc(void)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106d73:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106d78:	85 c0                	test   %eax,%eax
80106d7a:	75 07                	jne    80106d83 <uartgetc+0x13>
    return -1;
80106d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d81:	eb 2e                	jmp    80106db1 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106d83:	68 fd 03 00 00       	push   $0x3fd
80106d88:	e8 59 fe ff ff       	call   80106be6 <inb>
80106d8d:	83 c4 04             	add    $0x4,%esp
80106d90:	0f b6 c0             	movzbl %al,%eax
80106d93:	83 e0 01             	and    $0x1,%eax
80106d96:	85 c0                	test   %eax,%eax
80106d98:	75 07                	jne    80106da1 <uartgetc+0x31>
    return -1;
80106d9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d9f:	eb 10                	jmp    80106db1 <uartgetc+0x41>
  return inb(COM1+0);
80106da1:	68 f8 03 00 00       	push   $0x3f8
80106da6:	e8 3b fe ff ff       	call   80106be6 <inb>
80106dab:	83 c4 04             	add    $0x4,%esp
80106dae:	0f b6 c0             	movzbl %al,%eax
}
80106db1:	c9                   	leave  
80106db2:	c3                   	ret    

80106db3 <uartintr>:

void
uartintr(void)
{
80106db3:	55                   	push   %ebp
80106db4:	89 e5                	mov    %esp,%ebp
80106db6:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106db9:	83 ec 0c             	sub    $0xc,%esp
80106dbc:	68 70 6d 10 80       	push   $0x80106d70
80106dc1:	e8 7e 9a ff ff       	call   80100844 <consoleintr>
80106dc6:	83 c4 10             	add    $0x10,%esp
}
80106dc9:	c9                   	leave  
80106dca:	c3                   	ret    

80106dcb <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $0
80106dcd:	6a 00                	push   $0x0
  jmp alltraps
80106dcf:	e9 d9 f9 ff ff       	jmp    801067ad <alltraps>

80106dd4 <vector1>:
.globl vector1
vector1:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $1
80106dd6:	6a 01                	push   $0x1
  jmp alltraps
80106dd8:	e9 d0 f9 ff ff       	jmp    801067ad <alltraps>

80106ddd <vector2>:
.globl vector2
vector2:
  pushl $0
80106ddd:	6a 00                	push   $0x0
  pushl $2
80106ddf:	6a 02                	push   $0x2
  jmp alltraps
80106de1:	e9 c7 f9 ff ff       	jmp    801067ad <alltraps>

80106de6 <vector3>:
.globl vector3
vector3:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $3
80106de8:	6a 03                	push   $0x3
  jmp alltraps
80106dea:	e9 be f9 ff ff       	jmp    801067ad <alltraps>

80106def <vector4>:
.globl vector4
vector4:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $4
80106df1:	6a 04                	push   $0x4
  jmp alltraps
80106df3:	e9 b5 f9 ff ff       	jmp    801067ad <alltraps>

80106df8 <vector5>:
.globl vector5
vector5:
  pushl $0
80106df8:	6a 00                	push   $0x0
  pushl $5
80106dfa:	6a 05                	push   $0x5
  jmp alltraps
80106dfc:	e9 ac f9 ff ff       	jmp    801067ad <alltraps>

80106e01 <vector6>:
.globl vector6
vector6:
  pushl $0
80106e01:	6a 00                	push   $0x0
  pushl $6
80106e03:	6a 06                	push   $0x6
  jmp alltraps
80106e05:	e9 a3 f9 ff ff       	jmp    801067ad <alltraps>

80106e0a <vector7>:
.globl vector7
vector7:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $7
80106e0c:	6a 07                	push   $0x7
  jmp alltraps
80106e0e:	e9 9a f9 ff ff       	jmp    801067ad <alltraps>

80106e13 <vector8>:
.globl vector8
vector8:
  pushl $8
80106e13:	6a 08                	push   $0x8
  jmp alltraps
80106e15:	e9 93 f9 ff ff       	jmp    801067ad <alltraps>

80106e1a <vector9>:
.globl vector9
vector9:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $9
80106e1c:	6a 09                	push   $0x9
  jmp alltraps
80106e1e:	e9 8a f9 ff ff       	jmp    801067ad <alltraps>

80106e23 <vector10>:
.globl vector10
vector10:
  pushl $10
80106e23:	6a 0a                	push   $0xa
  jmp alltraps
80106e25:	e9 83 f9 ff ff       	jmp    801067ad <alltraps>

80106e2a <vector11>:
.globl vector11
vector11:
  pushl $11
80106e2a:	6a 0b                	push   $0xb
  jmp alltraps
80106e2c:	e9 7c f9 ff ff       	jmp    801067ad <alltraps>

80106e31 <vector12>:
.globl vector12
vector12:
  pushl $12
80106e31:	6a 0c                	push   $0xc
  jmp alltraps
80106e33:	e9 75 f9 ff ff       	jmp    801067ad <alltraps>

80106e38 <vector13>:
.globl vector13
vector13:
  pushl $13
80106e38:	6a 0d                	push   $0xd
  jmp alltraps
80106e3a:	e9 6e f9 ff ff       	jmp    801067ad <alltraps>

80106e3f <vector14>:
.globl vector14
vector14:
  pushl $14
80106e3f:	6a 0e                	push   $0xe
  jmp alltraps
80106e41:	e9 67 f9 ff ff       	jmp    801067ad <alltraps>

80106e46 <vector15>:
.globl vector15
vector15:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $15
80106e48:	6a 0f                	push   $0xf
  jmp alltraps
80106e4a:	e9 5e f9 ff ff       	jmp    801067ad <alltraps>

80106e4f <vector16>:
.globl vector16
vector16:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $16
80106e51:	6a 10                	push   $0x10
  jmp alltraps
80106e53:	e9 55 f9 ff ff       	jmp    801067ad <alltraps>

80106e58 <vector17>:
.globl vector17
vector17:
  pushl $17
80106e58:	6a 11                	push   $0x11
  jmp alltraps
80106e5a:	e9 4e f9 ff ff       	jmp    801067ad <alltraps>

80106e5f <vector18>:
.globl vector18
vector18:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $18
80106e61:	6a 12                	push   $0x12
  jmp alltraps
80106e63:	e9 45 f9 ff ff       	jmp    801067ad <alltraps>

80106e68 <vector19>:
.globl vector19
vector19:
  pushl $0
80106e68:	6a 00                	push   $0x0
  pushl $19
80106e6a:	6a 13                	push   $0x13
  jmp alltraps
80106e6c:	e9 3c f9 ff ff       	jmp    801067ad <alltraps>

80106e71 <vector20>:
.globl vector20
vector20:
  pushl $0
80106e71:	6a 00                	push   $0x0
  pushl $20
80106e73:	6a 14                	push   $0x14
  jmp alltraps
80106e75:	e9 33 f9 ff ff       	jmp    801067ad <alltraps>

80106e7a <vector21>:
.globl vector21
vector21:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $21
80106e7c:	6a 15                	push   $0x15
  jmp alltraps
80106e7e:	e9 2a f9 ff ff       	jmp    801067ad <alltraps>

80106e83 <vector22>:
.globl vector22
vector22:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $22
80106e85:	6a 16                	push   $0x16
  jmp alltraps
80106e87:	e9 21 f9 ff ff       	jmp    801067ad <alltraps>

80106e8c <vector23>:
.globl vector23
vector23:
  pushl $0
80106e8c:	6a 00                	push   $0x0
  pushl $23
80106e8e:	6a 17                	push   $0x17
  jmp alltraps
80106e90:	e9 18 f9 ff ff       	jmp    801067ad <alltraps>

80106e95 <vector24>:
.globl vector24
vector24:
  pushl $0
80106e95:	6a 00                	push   $0x0
  pushl $24
80106e97:	6a 18                	push   $0x18
  jmp alltraps
80106e99:	e9 0f f9 ff ff       	jmp    801067ad <alltraps>

80106e9e <vector25>:
.globl vector25
vector25:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $25
80106ea0:	6a 19                	push   $0x19
  jmp alltraps
80106ea2:	e9 06 f9 ff ff       	jmp    801067ad <alltraps>

80106ea7 <vector26>:
.globl vector26
vector26:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $26
80106ea9:	6a 1a                	push   $0x1a
  jmp alltraps
80106eab:	e9 fd f8 ff ff       	jmp    801067ad <alltraps>

80106eb0 <vector27>:
.globl vector27
vector27:
  pushl $0
80106eb0:	6a 00                	push   $0x0
  pushl $27
80106eb2:	6a 1b                	push   $0x1b
  jmp alltraps
80106eb4:	e9 f4 f8 ff ff       	jmp    801067ad <alltraps>

80106eb9 <vector28>:
.globl vector28
vector28:
  pushl $0
80106eb9:	6a 00                	push   $0x0
  pushl $28
80106ebb:	6a 1c                	push   $0x1c
  jmp alltraps
80106ebd:	e9 eb f8 ff ff       	jmp    801067ad <alltraps>

80106ec2 <vector29>:
.globl vector29
vector29:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $29
80106ec4:	6a 1d                	push   $0x1d
  jmp alltraps
80106ec6:	e9 e2 f8 ff ff       	jmp    801067ad <alltraps>

80106ecb <vector30>:
.globl vector30
vector30:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $30
80106ecd:	6a 1e                	push   $0x1e
  jmp alltraps
80106ecf:	e9 d9 f8 ff ff       	jmp    801067ad <alltraps>

80106ed4 <vector31>:
.globl vector31
vector31:
  pushl $0
80106ed4:	6a 00                	push   $0x0
  pushl $31
80106ed6:	6a 1f                	push   $0x1f
  jmp alltraps
80106ed8:	e9 d0 f8 ff ff       	jmp    801067ad <alltraps>

80106edd <vector32>:
.globl vector32
vector32:
  pushl $0
80106edd:	6a 00                	push   $0x0
  pushl $32
80106edf:	6a 20                	push   $0x20
  jmp alltraps
80106ee1:	e9 c7 f8 ff ff       	jmp    801067ad <alltraps>

80106ee6 <vector33>:
.globl vector33
vector33:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $33
80106ee8:	6a 21                	push   $0x21
  jmp alltraps
80106eea:	e9 be f8 ff ff       	jmp    801067ad <alltraps>

80106eef <vector34>:
.globl vector34
vector34:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $34
80106ef1:	6a 22                	push   $0x22
  jmp alltraps
80106ef3:	e9 b5 f8 ff ff       	jmp    801067ad <alltraps>

80106ef8 <vector35>:
.globl vector35
vector35:
  pushl $0
80106ef8:	6a 00                	push   $0x0
  pushl $35
80106efa:	6a 23                	push   $0x23
  jmp alltraps
80106efc:	e9 ac f8 ff ff       	jmp    801067ad <alltraps>

80106f01 <vector36>:
.globl vector36
vector36:
  pushl $0
80106f01:	6a 00                	push   $0x0
  pushl $36
80106f03:	6a 24                	push   $0x24
  jmp alltraps
80106f05:	e9 a3 f8 ff ff       	jmp    801067ad <alltraps>

80106f0a <vector37>:
.globl vector37
vector37:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $37
80106f0c:	6a 25                	push   $0x25
  jmp alltraps
80106f0e:	e9 9a f8 ff ff       	jmp    801067ad <alltraps>

80106f13 <vector38>:
.globl vector38
vector38:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $38
80106f15:	6a 26                	push   $0x26
  jmp alltraps
80106f17:	e9 91 f8 ff ff       	jmp    801067ad <alltraps>

80106f1c <vector39>:
.globl vector39
vector39:
  pushl $0
80106f1c:	6a 00                	push   $0x0
  pushl $39
80106f1e:	6a 27                	push   $0x27
  jmp alltraps
80106f20:	e9 88 f8 ff ff       	jmp    801067ad <alltraps>

80106f25 <vector40>:
.globl vector40
vector40:
  pushl $0
80106f25:	6a 00                	push   $0x0
  pushl $40
80106f27:	6a 28                	push   $0x28
  jmp alltraps
80106f29:	e9 7f f8 ff ff       	jmp    801067ad <alltraps>

80106f2e <vector41>:
.globl vector41
vector41:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $41
80106f30:	6a 29                	push   $0x29
  jmp alltraps
80106f32:	e9 76 f8 ff ff       	jmp    801067ad <alltraps>

80106f37 <vector42>:
.globl vector42
vector42:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $42
80106f39:	6a 2a                	push   $0x2a
  jmp alltraps
80106f3b:	e9 6d f8 ff ff       	jmp    801067ad <alltraps>

80106f40 <vector43>:
.globl vector43
vector43:
  pushl $0
80106f40:	6a 00                	push   $0x0
  pushl $43
80106f42:	6a 2b                	push   $0x2b
  jmp alltraps
80106f44:	e9 64 f8 ff ff       	jmp    801067ad <alltraps>

80106f49 <vector44>:
.globl vector44
vector44:
  pushl $0
80106f49:	6a 00                	push   $0x0
  pushl $44
80106f4b:	6a 2c                	push   $0x2c
  jmp alltraps
80106f4d:	e9 5b f8 ff ff       	jmp    801067ad <alltraps>

80106f52 <vector45>:
.globl vector45
vector45:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $45
80106f54:	6a 2d                	push   $0x2d
  jmp alltraps
80106f56:	e9 52 f8 ff ff       	jmp    801067ad <alltraps>

80106f5b <vector46>:
.globl vector46
vector46:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $46
80106f5d:	6a 2e                	push   $0x2e
  jmp alltraps
80106f5f:	e9 49 f8 ff ff       	jmp    801067ad <alltraps>

80106f64 <vector47>:
.globl vector47
vector47:
  pushl $0
80106f64:	6a 00                	push   $0x0
  pushl $47
80106f66:	6a 2f                	push   $0x2f
  jmp alltraps
80106f68:	e9 40 f8 ff ff       	jmp    801067ad <alltraps>

80106f6d <vector48>:
.globl vector48
vector48:
  pushl $0
80106f6d:	6a 00                	push   $0x0
  pushl $48
80106f6f:	6a 30                	push   $0x30
  jmp alltraps
80106f71:	e9 37 f8 ff ff       	jmp    801067ad <alltraps>

80106f76 <vector49>:
.globl vector49
vector49:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $49
80106f78:	6a 31                	push   $0x31
  jmp alltraps
80106f7a:	e9 2e f8 ff ff       	jmp    801067ad <alltraps>

80106f7f <vector50>:
.globl vector50
vector50:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $50
80106f81:	6a 32                	push   $0x32
  jmp alltraps
80106f83:	e9 25 f8 ff ff       	jmp    801067ad <alltraps>

80106f88 <vector51>:
.globl vector51
vector51:
  pushl $0
80106f88:	6a 00                	push   $0x0
  pushl $51
80106f8a:	6a 33                	push   $0x33
  jmp alltraps
80106f8c:	e9 1c f8 ff ff       	jmp    801067ad <alltraps>

80106f91 <vector52>:
.globl vector52
vector52:
  pushl $0
80106f91:	6a 00                	push   $0x0
  pushl $52
80106f93:	6a 34                	push   $0x34
  jmp alltraps
80106f95:	e9 13 f8 ff ff       	jmp    801067ad <alltraps>

80106f9a <vector53>:
.globl vector53
vector53:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $53
80106f9c:	6a 35                	push   $0x35
  jmp alltraps
80106f9e:	e9 0a f8 ff ff       	jmp    801067ad <alltraps>

80106fa3 <vector54>:
.globl vector54
vector54:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $54
80106fa5:	6a 36                	push   $0x36
  jmp alltraps
80106fa7:	e9 01 f8 ff ff       	jmp    801067ad <alltraps>

80106fac <vector55>:
.globl vector55
vector55:
  pushl $0
80106fac:	6a 00                	push   $0x0
  pushl $55
80106fae:	6a 37                	push   $0x37
  jmp alltraps
80106fb0:	e9 f8 f7 ff ff       	jmp    801067ad <alltraps>

80106fb5 <vector56>:
.globl vector56
vector56:
  pushl $0
80106fb5:	6a 00                	push   $0x0
  pushl $56
80106fb7:	6a 38                	push   $0x38
  jmp alltraps
80106fb9:	e9 ef f7 ff ff       	jmp    801067ad <alltraps>

80106fbe <vector57>:
.globl vector57
vector57:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $57
80106fc0:	6a 39                	push   $0x39
  jmp alltraps
80106fc2:	e9 e6 f7 ff ff       	jmp    801067ad <alltraps>

80106fc7 <vector58>:
.globl vector58
vector58:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $58
80106fc9:	6a 3a                	push   $0x3a
  jmp alltraps
80106fcb:	e9 dd f7 ff ff       	jmp    801067ad <alltraps>

80106fd0 <vector59>:
.globl vector59
vector59:
  pushl $0
80106fd0:	6a 00                	push   $0x0
  pushl $59
80106fd2:	6a 3b                	push   $0x3b
  jmp alltraps
80106fd4:	e9 d4 f7 ff ff       	jmp    801067ad <alltraps>

80106fd9 <vector60>:
.globl vector60
vector60:
  pushl $0
80106fd9:	6a 00                	push   $0x0
  pushl $60
80106fdb:	6a 3c                	push   $0x3c
  jmp alltraps
80106fdd:	e9 cb f7 ff ff       	jmp    801067ad <alltraps>

80106fe2 <vector61>:
.globl vector61
vector61:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $61
80106fe4:	6a 3d                	push   $0x3d
  jmp alltraps
80106fe6:	e9 c2 f7 ff ff       	jmp    801067ad <alltraps>

80106feb <vector62>:
.globl vector62
vector62:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $62
80106fed:	6a 3e                	push   $0x3e
  jmp alltraps
80106fef:	e9 b9 f7 ff ff       	jmp    801067ad <alltraps>

80106ff4 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ff4:	6a 00                	push   $0x0
  pushl $63
80106ff6:	6a 3f                	push   $0x3f
  jmp alltraps
80106ff8:	e9 b0 f7 ff ff       	jmp    801067ad <alltraps>

80106ffd <vector64>:
.globl vector64
vector64:
  pushl $0
80106ffd:	6a 00                	push   $0x0
  pushl $64
80106fff:	6a 40                	push   $0x40
  jmp alltraps
80107001:	e9 a7 f7 ff ff       	jmp    801067ad <alltraps>

80107006 <vector65>:
.globl vector65
vector65:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $65
80107008:	6a 41                	push   $0x41
  jmp alltraps
8010700a:	e9 9e f7 ff ff       	jmp    801067ad <alltraps>

8010700f <vector66>:
.globl vector66
vector66:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $66
80107011:	6a 42                	push   $0x42
  jmp alltraps
80107013:	e9 95 f7 ff ff       	jmp    801067ad <alltraps>

80107018 <vector67>:
.globl vector67
vector67:
  pushl $0
80107018:	6a 00                	push   $0x0
  pushl $67
8010701a:	6a 43                	push   $0x43
  jmp alltraps
8010701c:	e9 8c f7 ff ff       	jmp    801067ad <alltraps>

80107021 <vector68>:
.globl vector68
vector68:
  pushl $0
80107021:	6a 00                	push   $0x0
  pushl $68
80107023:	6a 44                	push   $0x44
  jmp alltraps
80107025:	e9 83 f7 ff ff       	jmp    801067ad <alltraps>

8010702a <vector69>:
.globl vector69
vector69:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $69
8010702c:	6a 45                	push   $0x45
  jmp alltraps
8010702e:	e9 7a f7 ff ff       	jmp    801067ad <alltraps>

80107033 <vector70>:
.globl vector70
vector70:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $70
80107035:	6a 46                	push   $0x46
  jmp alltraps
80107037:	e9 71 f7 ff ff       	jmp    801067ad <alltraps>

8010703c <vector71>:
.globl vector71
vector71:
  pushl $0
8010703c:	6a 00                	push   $0x0
  pushl $71
8010703e:	6a 47                	push   $0x47
  jmp alltraps
80107040:	e9 68 f7 ff ff       	jmp    801067ad <alltraps>

80107045 <vector72>:
.globl vector72
vector72:
  pushl $0
80107045:	6a 00                	push   $0x0
  pushl $72
80107047:	6a 48                	push   $0x48
  jmp alltraps
80107049:	e9 5f f7 ff ff       	jmp    801067ad <alltraps>

8010704e <vector73>:
.globl vector73
vector73:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $73
80107050:	6a 49                	push   $0x49
  jmp alltraps
80107052:	e9 56 f7 ff ff       	jmp    801067ad <alltraps>

80107057 <vector74>:
.globl vector74
vector74:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $74
80107059:	6a 4a                	push   $0x4a
  jmp alltraps
8010705b:	e9 4d f7 ff ff       	jmp    801067ad <alltraps>

80107060 <vector75>:
.globl vector75
vector75:
  pushl $0
80107060:	6a 00                	push   $0x0
  pushl $75
80107062:	6a 4b                	push   $0x4b
  jmp alltraps
80107064:	e9 44 f7 ff ff       	jmp    801067ad <alltraps>

80107069 <vector76>:
.globl vector76
vector76:
  pushl $0
80107069:	6a 00                	push   $0x0
  pushl $76
8010706b:	6a 4c                	push   $0x4c
  jmp alltraps
8010706d:	e9 3b f7 ff ff       	jmp    801067ad <alltraps>

80107072 <vector77>:
.globl vector77
vector77:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $77
80107074:	6a 4d                	push   $0x4d
  jmp alltraps
80107076:	e9 32 f7 ff ff       	jmp    801067ad <alltraps>

8010707b <vector78>:
.globl vector78
vector78:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $78
8010707d:	6a 4e                	push   $0x4e
  jmp alltraps
8010707f:	e9 29 f7 ff ff       	jmp    801067ad <alltraps>

80107084 <vector79>:
.globl vector79
vector79:
  pushl $0
80107084:	6a 00                	push   $0x0
  pushl $79
80107086:	6a 4f                	push   $0x4f
  jmp alltraps
80107088:	e9 20 f7 ff ff       	jmp    801067ad <alltraps>

8010708d <vector80>:
.globl vector80
vector80:
  pushl $0
8010708d:	6a 00                	push   $0x0
  pushl $80
8010708f:	6a 50                	push   $0x50
  jmp alltraps
80107091:	e9 17 f7 ff ff       	jmp    801067ad <alltraps>

80107096 <vector81>:
.globl vector81
vector81:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $81
80107098:	6a 51                	push   $0x51
  jmp alltraps
8010709a:	e9 0e f7 ff ff       	jmp    801067ad <alltraps>

8010709f <vector82>:
.globl vector82
vector82:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $82
801070a1:	6a 52                	push   $0x52
  jmp alltraps
801070a3:	e9 05 f7 ff ff       	jmp    801067ad <alltraps>

801070a8 <vector83>:
.globl vector83
vector83:
  pushl $0
801070a8:	6a 00                	push   $0x0
  pushl $83
801070aa:	6a 53                	push   $0x53
  jmp alltraps
801070ac:	e9 fc f6 ff ff       	jmp    801067ad <alltraps>

801070b1 <vector84>:
.globl vector84
vector84:
  pushl $0
801070b1:	6a 00                	push   $0x0
  pushl $84
801070b3:	6a 54                	push   $0x54
  jmp alltraps
801070b5:	e9 f3 f6 ff ff       	jmp    801067ad <alltraps>

801070ba <vector85>:
.globl vector85
vector85:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $85
801070bc:	6a 55                	push   $0x55
  jmp alltraps
801070be:	e9 ea f6 ff ff       	jmp    801067ad <alltraps>

801070c3 <vector86>:
.globl vector86
vector86:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $86
801070c5:	6a 56                	push   $0x56
  jmp alltraps
801070c7:	e9 e1 f6 ff ff       	jmp    801067ad <alltraps>

801070cc <vector87>:
.globl vector87
vector87:
  pushl $0
801070cc:	6a 00                	push   $0x0
  pushl $87
801070ce:	6a 57                	push   $0x57
  jmp alltraps
801070d0:	e9 d8 f6 ff ff       	jmp    801067ad <alltraps>

801070d5 <vector88>:
.globl vector88
vector88:
  pushl $0
801070d5:	6a 00                	push   $0x0
  pushl $88
801070d7:	6a 58                	push   $0x58
  jmp alltraps
801070d9:	e9 cf f6 ff ff       	jmp    801067ad <alltraps>

801070de <vector89>:
.globl vector89
vector89:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $89
801070e0:	6a 59                	push   $0x59
  jmp alltraps
801070e2:	e9 c6 f6 ff ff       	jmp    801067ad <alltraps>

801070e7 <vector90>:
.globl vector90
vector90:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $90
801070e9:	6a 5a                	push   $0x5a
  jmp alltraps
801070eb:	e9 bd f6 ff ff       	jmp    801067ad <alltraps>

801070f0 <vector91>:
.globl vector91
vector91:
  pushl $0
801070f0:	6a 00                	push   $0x0
  pushl $91
801070f2:	6a 5b                	push   $0x5b
  jmp alltraps
801070f4:	e9 b4 f6 ff ff       	jmp    801067ad <alltraps>

801070f9 <vector92>:
.globl vector92
vector92:
  pushl $0
801070f9:	6a 00                	push   $0x0
  pushl $92
801070fb:	6a 5c                	push   $0x5c
  jmp alltraps
801070fd:	e9 ab f6 ff ff       	jmp    801067ad <alltraps>

80107102 <vector93>:
.globl vector93
vector93:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $93
80107104:	6a 5d                	push   $0x5d
  jmp alltraps
80107106:	e9 a2 f6 ff ff       	jmp    801067ad <alltraps>

8010710b <vector94>:
.globl vector94
vector94:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $94
8010710d:	6a 5e                	push   $0x5e
  jmp alltraps
8010710f:	e9 99 f6 ff ff       	jmp    801067ad <alltraps>

80107114 <vector95>:
.globl vector95
vector95:
  pushl $0
80107114:	6a 00                	push   $0x0
  pushl $95
80107116:	6a 5f                	push   $0x5f
  jmp alltraps
80107118:	e9 90 f6 ff ff       	jmp    801067ad <alltraps>

8010711d <vector96>:
.globl vector96
vector96:
  pushl $0
8010711d:	6a 00                	push   $0x0
  pushl $96
8010711f:	6a 60                	push   $0x60
  jmp alltraps
80107121:	e9 87 f6 ff ff       	jmp    801067ad <alltraps>

80107126 <vector97>:
.globl vector97
vector97:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $97
80107128:	6a 61                	push   $0x61
  jmp alltraps
8010712a:	e9 7e f6 ff ff       	jmp    801067ad <alltraps>

8010712f <vector98>:
.globl vector98
vector98:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $98
80107131:	6a 62                	push   $0x62
  jmp alltraps
80107133:	e9 75 f6 ff ff       	jmp    801067ad <alltraps>

80107138 <vector99>:
.globl vector99
vector99:
  pushl $0
80107138:	6a 00                	push   $0x0
  pushl $99
8010713a:	6a 63                	push   $0x63
  jmp alltraps
8010713c:	e9 6c f6 ff ff       	jmp    801067ad <alltraps>

80107141 <vector100>:
.globl vector100
vector100:
  pushl $0
80107141:	6a 00                	push   $0x0
  pushl $100
80107143:	6a 64                	push   $0x64
  jmp alltraps
80107145:	e9 63 f6 ff ff       	jmp    801067ad <alltraps>

8010714a <vector101>:
.globl vector101
vector101:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $101
8010714c:	6a 65                	push   $0x65
  jmp alltraps
8010714e:	e9 5a f6 ff ff       	jmp    801067ad <alltraps>

80107153 <vector102>:
.globl vector102
vector102:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $102
80107155:	6a 66                	push   $0x66
  jmp alltraps
80107157:	e9 51 f6 ff ff       	jmp    801067ad <alltraps>

8010715c <vector103>:
.globl vector103
vector103:
  pushl $0
8010715c:	6a 00                	push   $0x0
  pushl $103
8010715e:	6a 67                	push   $0x67
  jmp alltraps
80107160:	e9 48 f6 ff ff       	jmp    801067ad <alltraps>

80107165 <vector104>:
.globl vector104
vector104:
  pushl $0
80107165:	6a 00                	push   $0x0
  pushl $104
80107167:	6a 68                	push   $0x68
  jmp alltraps
80107169:	e9 3f f6 ff ff       	jmp    801067ad <alltraps>

8010716e <vector105>:
.globl vector105
vector105:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $105
80107170:	6a 69                	push   $0x69
  jmp alltraps
80107172:	e9 36 f6 ff ff       	jmp    801067ad <alltraps>

80107177 <vector106>:
.globl vector106
vector106:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $106
80107179:	6a 6a                	push   $0x6a
  jmp alltraps
8010717b:	e9 2d f6 ff ff       	jmp    801067ad <alltraps>

80107180 <vector107>:
.globl vector107
vector107:
  pushl $0
80107180:	6a 00                	push   $0x0
  pushl $107
80107182:	6a 6b                	push   $0x6b
  jmp alltraps
80107184:	e9 24 f6 ff ff       	jmp    801067ad <alltraps>

80107189 <vector108>:
.globl vector108
vector108:
  pushl $0
80107189:	6a 00                	push   $0x0
  pushl $108
8010718b:	6a 6c                	push   $0x6c
  jmp alltraps
8010718d:	e9 1b f6 ff ff       	jmp    801067ad <alltraps>

80107192 <vector109>:
.globl vector109
vector109:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $109
80107194:	6a 6d                	push   $0x6d
  jmp alltraps
80107196:	e9 12 f6 ff ff       	jmp    801067ad <alltraps>

8010719b <vector110>:
.globl vector110
vector110:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $110
8010719d:	6a 6e                	push   $0x6e
  jmp alltraps
8010719f:	e9 09 f6 ff ff       	jmp    801067ad <alltraps>

801071a4 <vector111>:
.globl vector111
vector111:
  pushl $0
801071a4:	6a 00                	push   $0x0
  pushl $111
801071a6:	6a 6f                	push   $0x6f
  jmp alltraps
801071a8:	e9 00 f6 ff ff       	jmp    801067ad <alltraps>

801071ad <vector112>:
.globl vector112
vector112:
  pushl $0
801071ad:	6a 00                	push   $0x0
  pushl $112
801071af:	6a 70                	push   $0x70
  jmp alltraps
801071b1:	e9 f7 f5 ff ff       	jmp    801067ad <alltraps>

801071b6 <vector113>:
.globl vector113
vector113:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $113
801071b8:	6a 71                	push   $0x71
  jmp alltraps
801071ba:	e9 ee f5 ff ff       	jmp    801067ad <alltraps>

801071bf <vector114>:
.globl vector114
vector114:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $114
801071c1:	6a 72                	push   $0x72
  jmp alltraps
801071c3:	e9 e5 f5 ff ff       	jmp    801067ad <alltraps>

801071c8 <vector115>:
.globl vector115
vector115:
  pushl $0
801071c8:	6a 00                	push   $0x0
  pushl $115
801071ca:	6a 73                	push   $0x73
  jmp alltraps
801071cc:	e9 dc f5 ff ff       	jmp    801067ad <alltraps>

801071d1 <vector116>:
.globl vector116
vector116:
  pushl $0
801071d1:	6a 00                	push   $0x0
  pushl $116
801071d3:	6a 74                	push   $0x74
  jmp alltraps
801071d5:	e9 d3 f5 ff ff       	jmp    801067ad <alltraps>

801071da <vector117>:
.globl vector117
vector117:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $117
801071dc:	6a 75                	push   $0x75
  jmp alltraps
801071de:	e9 ca f5 ff ff       	jmp    801067ad <alltraps>

801071e3 <vector118>:
.globl vector118
vector118:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $118
801071e5:	6a 76                	push   $0x76
  jmp alltraps
801071e7:	e9 c1 f5 ff ff       	jmp    801067ad <alltraps>

801071ec <vector119>:
.globl vector119
vector119:
  pushl $0
801071ec:	6a 00                	push   $0x0
  pushl $119
801071ee:	6a 77                	push   $0x77
  jmp alltraps
801071f0:	e9 b8 f5 ff ff       	jmp    801067ad <alltraps>

801071f5 <vector120>:
.globl vector120
vector120:
  pushl $0
801071f5:	6a 00                	push   $0x0
  pushl $120
801071f7:	6a 78                	push   $0x78
  jmp alltraps
801071f9:	e9 af f5 ff ff       	jmp    801067ad <alltraps>

801071fe <vector121>:
.globl vector121
vector121:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $121
80107200:	6a 79                	push   $0x79
  jmp alltraps
80107202:	e9 a6 f5 ff ff       	jmp    801067ad <alltraps>

80107207 <vector122>:
.globl vector122
vector122:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $122
80107209:	6a 7a                	push   $0x7a
  jmp alltraps
8010720b:	e9 9d f5 ff ff       	jmp    801067ad <alltraps>

80107210 <vector123>:
.globl vector123
vector123:
  pushl $0
80107210:	6a 00                	push   $0x0
  pushl $123
80107212:	6a 7b                	push   $0x7b
  jmp alltraps
80107214:	e9 94 f5 ff ff       	jmp    801067ad <alltraps>

80107219 <vector124>:
.globl vector124
vector124:
  pushl $0
80107219:	6a 00                	push   $0x0
  pushl $124
8010721b:	6a 7c                	push   $0x7c
  jmp alltraps
8010721d:	e9 8b f5 ff ff       	jmp    801067ad <alltraps>

80107222 <vector125>:
.globl vector125
vector125:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $125
80107224:	6a 7d                	push   $0x7d
  jmp alltraps
80107226:	e9 82 f5 ff ff       	jmp    801067ad <alltraps>

8010722b <vector126>:
.globl vector126
vector126:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $126
8010722d:	6a 7e                	push   $0x7e
  jmp alltraps
8010722f:	e9 79 f5 ff ff       	jmp    801067ad <alltraps>

80107234 <vector127>:
.globl vector127
vector127:
  pushl $0
80107234:	6a 00                	push   $0x0
  pushl $127
80107236:	6a 7f                	push   $0x7f
  jmp alltraps
80107238:	e9 70 f5 ff ff       	jmp    801067ad <alltraps>

8010723d <vector128>:
.globl vector128
vector128:
  pushl $0
8010723d:	6a 00                	push   $0x0
  pushl $128
8010723f:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107244:	e9 64 f5 ff ff       	jmp    801067ad <alltraps>

80107249 <vector129>:
.globl vector129
vector129:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $129
8010724b:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107250:	e9 58 f5 ff ff       	jmp    801067ad <alltraps>

80107255 <vector130>:
.globl vector130
vector130:
  pushl $0
80107255:	6a 00                	push   $0x0
  pushl $130
80107257:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010725c:	e9 4c f5 ff ff       	jmp    801067ad <alltraps>

80107261 <vector131>:
.globl vector131
vector131:
  pushl $0
80107261:	6a 00                	push   $0x0
  pushl $131
80107263:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107268:	e9 40 f5 ff ff       	jmp    801067ad <alltraps>

8010726d <vector132>:
.globl vector132
vector132:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $132
8010726f:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107274:	e9 34 f5 ff ff       	jmp    801067ad <alltraps>

80107279 <vector133>:
.globl vector133
vector133:
  pushl $0
80107279:	6a 00                	push   $0x0
  pushl $133
8010727b:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107280:	e9 28 f5 ff ff       	jmp    801067ad <alltraps>

80107285 <vector134>:
.globl vector134
vector134:
  pushl $0
80107285:	6a 00                	push   $0x0
  pushl $134
80107287:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010728c:	e9 1c f5 ff ff       	jmp    801067ad <alltraps>

80107291 <vector135>:
.globl vector135
vector135:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $135
80107293:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107298:	e9 10 f5 ff ff       	jmp    801067ad <alltraps>

8010729d <vector136>:
.globl vector136
vector136:
  pushl $0
8010729d:	6a 00                	push   $0x0
  pushl $136
8010729f:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801072a4:	e9 04 f5 ff ff       	jmp    801067ad <alltraps>

801072a9 <vector137>:
.globl vector137
vector137:
  pushl $0
801072a9:	6a 00                	push   $0x0
  pushl $137
801072ab:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801072b0:	e9 f8 f4 ff ff       	jmp    801067ad <alltraps>

801072b5 <vector138>:
.globl vector138
vector138:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $138
801072b7:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801072bc:	e9 ec f4 ff ff       	jmp    801067ad <alltraps>

801072c1 <vector139>:
.globl vector139
vector139:
  pushl $0
801072c1:	6a 00                	push   $0x0
  pushl $139
801072c3:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801072c8:	e9 e0 f4 ff ff       	jmp    801067ad <alltraps>

801072cd <vector140>:
.globl vector140
vector140:
  pushl $0
801072cd:	6a 00                	push   $0x0
  pushl $140
801072cf:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801072d4:	e9 d4 f4 ff ff       	jmp    801067ad <alltraps>

801072d9 <vector141>:
.globl vector141
vector141:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $141
801072db:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801072e0:	e9 c8 f4 ff ff       	jmp    801067ad <alltraps>

801072e5 <vector142>:
.globl vector142
vector142:
  pushl $0
801072e5:	6a 00                	push   $0x0
  pushl $142
801072e7:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801072ec:	e9 bc f4 ff ff       	jmp    801067ad <alltraps>

801072f1 <vector143>:
.globl vector143
vector143:
  pushl $0
801072f1:	6a 00                	push   $0x0
  pushl $143
801072f3:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801072f8:	e9 b0 f4 ff ff       	jmp    801067ad <alltraps>

801072fd <vector144>:
.globl vector144
vector144:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $144
801072ff:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107304:	e9 a4 f4 ff ff       	jmp    801067ad <alltraps>

80107309 <vector145>:
.globl vector145
vector145:
  pushl $0
80107309:	6a 00                	push   $0x0
  pushl $145
8010730b:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107310:	e9 98 f4 ff ff       	jmp    801067ad <alltraps>

80107315 <vector146>:
.globl vector146
vector146:
  pushl $0
80107315:	6a 00                	push   $0x0
  pushl $146
80107317:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010731c:	e9 8c f4 ff ff       	jmp    801067ad <alltraps>

80107321 <vector147>:
.globl vector147
vector147:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $147
80107323:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107328:	e9 80 f4 ff ff       	jmp    801067ad <alltraps>

8010732d <vector148>:
.globl vector148
vector148:
  pushl $0
8010732d:	6a 00                	push   $0x0
  pushl $148
8010732f:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107334:	e9 74 f4 ff ff       	jmp    801067ad <alltraps>

80107339 <vector149>:
.globl vector149
vector149:
  pushl $0
80107339:	6a 00                	push   $0x0
  pushl $149
8010733b:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107340:	e9 68 f4 ff ff       	jmp    801067ad <alltraps>

80107345 <vector150>:
.globl vector150
vector150:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $150
80107347:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010734c:	e9 5c f4 ff ff       	jmp    801067ad <alltraps>

80107351 <vector151>:
.globl vector151
vector151:
  pushl $0
80107351:	6a 00                	push   $0x0
  pushl $151
80107353:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107358:	e9 50 f4 ff ff       	jmp    801067ad <alltraps>

8010735d <vector152>:
.globl vector152
vector152:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $152
8010735f:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107364:	e9 44 f4 ff ff       	jmp    801067ad <alltraps>

80107369 <vector153>:
.globl vector153
vector153:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $153
8010736b:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107370:	e9 38 f4 ff ff       	jmp    801067ad <alltraps>

80107375 <vector154>:
.globl vector154
vector154:
  pushl $0
80107375:	6a 00                	push   $0x0
  pushl $154
80107377:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010737c:	e9 2c f4 ff ff       	jmp    801067ad <alltraps>

80107381 <vector155>:
.globl vector155
vector155:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $155
80107383:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107388:	e9 20 f4 ff ff       	jmp    801067ad <alltraps>

8010738d <vector156>:
.globl vector156
vector156:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $156
8010738f:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107394:	e9 14 f4 ff ff       	jmp    801067ad <alltraps>

80107399 <vector157>:
.globl vector157
vector157:
  pushl $0
80107399:	6a 00                	push   $0x0
  pushl $157
8010739b:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801073a0:	e9 08 f4 ff ff       	jmp    801067ad <alltraps>

801073a5 <vector158>:
.globl vector158
vector158:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $158
801073a7:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801073ac:	e9 fc f3 ff ff       	jmp    801067ad <alltraps>

801073b1 <vector159>:
.globl vector159
vector159:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $159
801073b3:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801073b8:	e9 f0 f3 ff ff       	jmp    801067ad <alltraps>

801073bd <vector160>:
.globl vector160
vector160:
  pushl $0
801073bd:	6a 00                	push   $0x0
  pushl $160
801073bf:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801073c4:	e9 e4 f3 ff ff       	jmp    801067ad <alltraps>

801073c9 <vector161>:
.globl vector161
vector161:
  pushl $0
801073c9:	6a 00                	push   $0x0
  pushl $161
801073cb:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801073d0:	e9 d8 f3 ff ff       	jmp    801067ad <alltraps>

801073d5 <vector162>:
.globl vector162
vector162:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $162
801073d7:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801073dc:	e9 cc f3 ff ff       	jmp    801067ad <alltraps>

801073e1 <vector163>:
.globl vector163
vector163:
  pushl $0
801073e1:	6a 00                	push   $0x0
  pushl $163
801073e3:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801073e8:	e9 c0 f3 ff ff       	jmp    801067ad <alltraps>

801073ed <vector164>:
.globl vector164
vector164:
  pushl $0
801073ed:	6a 00                	push   $0x0
  pushl $164
801073ef:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801073f4:	e9 b4 f3 ff ff       	jmp    801067ad <alltraps>

801073f9 <vector165>:
.globl vector165
vector165:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $165
801073fb:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107400:	e9 a8 f3 ff ff       	jmp    801067ad <alltraps>

80107405 <vector166>:
.globl vector166
vector166:
  pushl $0
80107405:	6a 00                	push   $0x0
  pushl $166
80107407:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010740c:	e9 9c f3 ff ff       	jmp    801067ad <alltraps>

80107411 <vector167>:
.globl vector167
vector167:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $167
80107413:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107418:	e9 90 f3 ff ff       	jmp    801067ad <alltraps>

8010741d <vector168>:
.globl vector168
vector168:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $168
8010741f:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107424:	e9 84 f3 ff ff       	jmp    801067ad <alltraps>

80107429 <vector169>:
.globl vector169
vector169:
  pushl $0
80107429:	6a 00                	push   $0x0
  pushl $169
8010742b:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107430:	e9 78 f3 ff ff       	jmp    801067ad <alltraps>

80107435 <vector170>:
.globl vector170
vector170:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $170
80107437:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010743c:	e9 6c f3 ff ff       	jmp    801067ad <alltraps>

80107441 <vector171>:
.globl vector171
vector171:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $171
80107443:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107448:	e9 60 f3 ff ff       	jmp    801067ad <alltraps>

8010744d <vector172>:
.globl vector172
vector172:
  pushl $0
8010744d:	6a 00                	push   $0x0
  pushl $172
8010744f:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107454:	e9 54 f3 ff ff       	jmp    801067ad <alltraps>

80107459 <vector173>:
.globl vector173
vector173:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $173
8010745b:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107460:	e9 48 f3 ff ff       	jmp    801067ad <alltraps>

80107465 <vector174>:
.globl vector174
vector174:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $174
80107467:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010746c:	e9 3c f3 ff ff       	jmp    801067ad <alltraps>

80107471 <vector175>:
.globl vector175
vector175:
  pushl $0
80107471:	6a 00                	push   $0x0
  pushl $175
80107473:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107478:	e9 30 f3 ff ff       	jmp    801067ad <alltraps>

8010747d <vector176>:
.globl vector176
vector176:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $176
8010747f:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107484:	e9 24 f3 ff ff       	jmp    801067ad <alltraps>

80107489 <vector177>:
.globl vector177
vector177:
  pushl $0
80107489:	6a 00                	push   $0x0
  pushl $177
8010748b:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107490:	e9 18 f3 ff ff       	jmp    801067ad <alltraps>

80107495 <vector178>:
.globl vector178
vector178:
  pushl $0
80107495:	6a 00                	push   $0x0
  pushl $178
80107497:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010749c:	e9 0c f3 ff ff       	jmp    801067ad <alltraps>

801074a1 <vector179>:
.globl vector179
vector179:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $179
801074a3:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801074a8:	e9 00 f3 ff ff       	jmp    801067ad <alltraps>

801074ad <vector180>:
.globl vector180
vector180:
  pushl $0
801074ad:	6a 00                	push   $0x0
  pushl $180
801074af:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801074b4:	e9 f4 f2 ff ff       	jmp    801067ad <alltraps>

801074b9 <vector181>:
.globl vector181
vector181:
  pushl $0
801074b9:	6a 00                	push   $0x0
  pushl $181
801074bb:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801074c0:	e9 e8 f2 ff ff       	jmp    801067ad <alltraps>

801074c5 <vector182>:
.globl vector182
vector182:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $182
801074c7:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801074cc:	e9 dc f2 ff ff       	jmp    801067ad <alltraps>

801074d1 <vector183>:
.globl vector183
vector183:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $183
801074d3:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801074d8:	e9 d0 f2 ff ff       	jmp    801067ad <alltraps>

801074dd <vector184>:
.globl vector184
vector184:
  pushl $0
801074dd:	6a 00                	push   $0x0
  pushl $184
801074df:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801074e4:	e9 c4 f2 ff ff       	jmp    801067ad <alltraps>

801074e9 <vector185>:
.globl vector185
vector185:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $185
801074eb:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801074f0:	e9 b8 f2 ff ff       	jmp    801067ad <alltraps>

801074f5 <vector186>:
.globl vector186
vector186:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $186
801074f7:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801074fc:	e9 ac f2 ff ff       	jmp    801067ad <alltraps>

80107501 <vector187>:
.globl vector187
vector187:
  pushl $0
80107501:	6a 00                	push   $0x0
  pushl $187
80107503:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107508:	e9 a0 f2 ff ff       	jmp    801067ad <alltraps>

8010750d <vector188>:
.globl vector188
vector188:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $188
8010750f:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107514:	e9 94 f2 ff ff       	jmp    801067ad <alltraps>

80107519 <vector189>:
.globl vector189
vector189:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $189
8010751b:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107520:	e9 88 f2 ff ff       	jmp    801067ad <alltraps>

80107525 <vector190>:
.globl vector190
vector190:
  pushl $0
80107525:	6a 00                	push   $0x0
  pushl $190
80107527:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010752c:	e9 7c f2 ff ff       	jmp    801067ad <alltraps>

80107531 <vector191>:
.globl vector191
vector191:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $191
80107533:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107538:	e9 70 f2 ff ff       	jmp    801067ad <alltraps>

8010753d <vector192>:
.globl vector192
vector192:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $192
8010753f:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107544:	e9 64 f2 ff ff       	jmp    801067ad <alltraps>

80107549 <vector193>:
.globl vector193
vector193:
  pushl $0
80107549:	6a 00                	push   $0x0
  pushl $193
8010754b:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107550:	e9 58 f2 ff ff       	jmp    801067ad <alltraps>

80107555 <vector194>:
.globl vector194
vector194:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $194
80107557:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010755c:	e9 4c f2 ff ff       	jmp    801067ad <alltraps>

80107561 <vector195>:
.globl vector195
vector195:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $195
80107563:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107568:	e9 40 f2 ff ff       	jmp    801067ad <alltraps>

8010756d <vector196>:
.globl vector196
vector196:
  pushl $0
8010756d:	6a 00                	push   $0x0
  pushl $196
8010756f:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107574:	e9 34 f2 ff ff       	jmp    801067ad <alltraps>

80107579 <vector197>:
.globl vector197
vector197:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $197
8010757b:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107580:	e9 28 f2 ff ff       	jmp    801067ad <alltraps>

80107585 <vector198>:
.globl vector198
vector198:
  pushl $0
80107585:	6a 00                	push   $0x0
  pushl $198
80107587:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010758c:	e9 1c f2 ff ff       	jmp    801067ad <alltraps>

80107591 <vector199>:
.globl vector199
vector199:
  pushl $0
80107591:	6a 00                	push   $0x0
  pushl $199
80107593:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107598:	e9 10 f2 ff ff       	jmp    801067ad <alltraps>

8010759d <vector200>:
.globl vector200
vector200:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $200
8010759f:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801075a4:	e9 04 f2 ff ff       	jmp    801067ad <alltraps>

801075a9 <vector201>:
.globl vector201
vector201:
  pushl $0
801075a9:	6a 00                	push   $0x0
  pushl $201
801075ab:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801075b0:	e9 f8 f1 ff ff       	jmp    801067ad <alltraps>

801075b5 <vector202>:
.globl vector202
vector202:
  pushl $0
801075b5:	6a 00                	push   $0x0
  pushl $202
801075b7:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801075bc:	e9 ec f1 ff ff       	jmp    801067ad <alltraps>

801075c1 <vector203>:
.globl vector203
vector203:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $203
801075c3:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801075c8:	e9 e0 f1 ff ff       	jmp    801067ad <alltraps>

801075cd <vector204>:
.globl vector204
vector204:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $204
801075cf:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801075d4:	e9 d4 f1 ff ff       	jmp    801067ad <alltraps>

801075d9 <vector205>:
.globl vector205
vector205:
  pushl $0
801075d9:	6a 00                	push   $0x0
  pushl $205
801075db:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801075e0:	e9 c8 f1 ff ff       	jmp    801067ad <alltraps>

801075e5 <vector206>:
.globl vector206
vector206:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $206
801075e7:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801075ec:	e9 bc f1 ff ff       	jmp    801067ad <alltraps>

801075f1 <vector207>:
.globl vector207
vector207:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $207
801075f3:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801075f8:	e9 b0 f1 ff ff       	jmp    801067ad <alltraps>

801075fd <vector208>:
.globl vector208
vector208:
  pushl $0
801075fd:	6a 00                	push   $0x0
  pushl $208
801075ff:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107604:	e9 a4 f1 ff ff       	jmp    801067ad <alltraps>

80107609 <vector209>:
.globl vector209
vector209:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $209
8010760b:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107610:	e9 98 f1 ff ff       	jmp    801067ad <alltraps>

80107615 <vector210>:
.globl vector210
vector210:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $210
80107617:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010761c:	e9 8c f1 ff ff       	jmp    801067ad <alltraps>

80107621 <vector211>:
.globl vector211
vector211:
  pushl $0
80107621:	6a 00                	push   $0x0
  pushl $211
80107623:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107628:	e9 80 f1 ff ff       	jmp    801067ad <alltraps>

8010762d <vector212>:
.globl vector212
vector212:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $212
8010762f:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107634:	e9 74 f1 ff ff       	jmp    801067ad <alltraps>

80107639 <vector213>:
.globl vector213
vector213:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $213
8010763b:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107640:	e9 68 f1 ff ff       	jmp    801067ad <alltraps>

80107645 <vector214>:
.globl vector214
vector214:
  pushl $0
80107645:	6a 00                	push   $0x0
  pushl $214
80107647:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010764c:	e9 5c f1 ff ff       	jmp    801067ad <alltraps>

80107651 <vector215>:
.globl vector215
vector215:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $215
80107653:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107658:	e9 50 f1 ff ff       	jmp    801067ad <alltraps>

8010765d <vector216>:
.globl vector216
vector216:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $216
8010765f:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107664:	e9 44 f1 ff ff       	jmp    801067ad <alltraps>

80107669 <vector217>:
.globl vector217
vector217:
  pushl $0
80107669:	6a 00                	push   $0x0
  pushl $217
8010766b:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107670:	e9 38 f1 ff ff       	jmp    801067ad <alltraps>

80107675 <vector218>:
.globl vector218
vector218:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $218
80107677:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010767c:	e9 2c f1 ff ff       	jmp    801067ad <alltraps>

80107681 <vector219>:
.globl vector219
vector219:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $219
80107683:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107688:	e9 20 f1 ff ff       	jmp    801067ad <alltraps>

8010768d <vector220>:
.globl vector220
vector220:
  pushl $0
8010768d:	6a 00                	push   $0x0
  pushl $220
8010768f:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107694:	e9 14 f1 ff ff       	jmp    801067ad <alltraps>

80107699 <vector221>:
.globl vector221
vector221:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $221
8010769b:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801076a0:	e9 08 f1 ff ff       	jmp    801067ad <alltraps>

801076a5 <vector222>:
.globl vector222
vector222:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $222
801076a7:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801076ac:	e9 fc f0 ff ff       	jmp    801067ad <alltraps>

801076b1 <vector223>:
.globl vector223
vector223:
  pushl $0
801076b1:	6a 00                	push   $0x0
  pushl $223
801076b3:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801076b8:	e9 f0 f0 ff ff       	jmp    801067ad <alltraps>

801076bd <vector224>:
.globl vector224
vector224:
  pushl $0
801076bd:	6a 00                	push   $0x0
  pushl $224
801076bf:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801076c4:	e9 e4 f0 ff ff       	jmp    801067ad <alltraps>

801076c9 <vector225>:
.globl vector225
vector225:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $225
801076cb:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801076d0:	e9 d8 f0 ff ff       	jmp    801067ad <alltraps>

801076d5 <vector226>:
.globl vector226
vector226:
  pushl $0
801076d5:	6a 00                	push   $0x0
  pushl $226
801076d7:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801076dc:	e9 cc f0 ff ff       	jmp    801067ad <alltraps>

801076e1 <vector227>:
.globl vector227
vector227:
  pushl $0
801076e1:	6a 00                	push   $0x0
  pushl $227
801076e3:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801076e8:	e9 c0 f0 ff ff       	jmp    801067ad <alltraps>

801076ed <vector228>:
.globl vector228
vector228:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $228
801076ef:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801076f4:	e9 b4 f0 ff ff       	jmp    801067ad <alltraps>

801076f9 <vector229>:
.globl vector229
vector229:
  pushl $0
801076f9:	6a 00                	push   $0x0
  pushl $229
801076fb:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107700:	e9 a8 f0 ff ff       	jmp    801067ad <alltraps>

80107705 <vector230>:
.globl vector230
vector230:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $230
80107707:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010770c:	e9 9c f0 ff ff       	jmp    801067ad <alltraps>

80107711 <vector231>:
.globl vector231
vector231:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $231
80107713:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107718:	e9 90 f0 ff ff       	jmp    801067ad <alltraps>

8010771d <vector232>:
.globl vector232
vector232:
  pushl $0
8010771d:	6a 00                	push   $0x0
  pushl $232
8010771f:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107724:	e9 84 f0 ff ff       	jmp    801067ad <alltraps>

80107729 <vector233>:
.globl vector233
vector233:
  pushl $0
80107729:	6a 00                	push   $0x0
  pushl $233
8010772b:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107730:	e9 78 f0 ff ff       	jmp    801067ad <alltraps>

80107735 <vector234>:
.globl vector234
vector234:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $234
80107737:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010773c:	e9 6c f0 ff ff       	jmp    801067ad <alltraps>

80107741 <vector235>:
.globl vector235
vector235:
  pushl $0
80107741:	6a 00                	push   $0x0
  pushl $235
80107743:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107748:	e9 60 f0 ff ff       	jmp    801067ad <alltraps>

8010774d <vector236>:
.globl vector236
vector236:
  pushl $0
8010774d:	6a 00                	push   $0x0
  pushl $236
8010774f:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107754:	e9 54 f0 ff ff       	jmp    801067ad <alltraps>

80107759 <vector237>:
.globl vector237
vector237:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $237
8010775b:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107760:	e9 48 f0 ff ff       	jmp    801067ad <alltraps>

80107765 <vector238>:
.globl vector238
vector238:
  pushl $0
80107765:	6a 00                	push   $0x0
  pushl $238
80107767:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010776c:	e9 3c f0 ff ff       	jmp    801067ad <alltraps>

80107771 <vector239>:
.globl vector239
vector239:
  pushl $0
80107771:	6a 00                	push   $0x0
  pushl $239
80107773:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107778:	e9 30 f0 ff ff       	jmp    801067ad <alltraps>

8010777d <vector240>:
.globl vector240
vector240:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $240
8010777f:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107784:	e9 24 f0 ff ff       	jmp    801067ad <alltraps>

80107789 <vector241>:
.globl vector241
vector241:
  pushl $0
80107789:	6a 00                	push   $0x0
  pushl $241
8010778b:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107790:	e9 18 f0 ff ff       	jmp    801067ad <alltraps>

80107795 <vector242>:
.globl vector242
vector242:
  pushl $0
80107795:	6a 00                	push   $0x0
  pushl $242
80107797:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010779c:	e9 0c f0 ff ff       	jmp    801067ad <alltraps>

801077a1 <vector243>:
.globl vector243
vector243:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $243
801077a3:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801077a8:	e9 00 f0 ff ff       	jmp    801067ad <alltraps>

801077ad <vector244>:
.globl vector244
vector244:
  pushl $0
801077ad:	6a 00                	push   $0x0
  pushl $244
801077af:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801077b4:	e9 f4 ef ff ff       	jmp    801067ad <alltraps>

801077b9 <vector245>:
.globl vector245
vector245:
  pushl $0
801077b9:	6a 00                	push   $0x0
  pushl $245
801077bb:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801077c0:	e9 e8 ef ff ff       	jmp    801067ad <alltraps>

801077c5 <vector246>:
.globl vector246
vector246:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $246
801077c7:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801077cc:	e9 dc ef ff ff       	jmp    801067ad <alltraps>

801077d1 <vector247>:
.globl vector247
vector247:
  pushl $0
801077d1:	6a 00                	push   $0x0
  pushl $247
801077d3:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801077d8:	e9 d0 ef ff ff       	jmp    801067ad <alltraps>

801077dd <vector248>:
.globl vector248
vector248:
  pushl $0
801077dd:	6a 00                	push   $0x0
  pushl $248
801077df:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801077e4:	e9 c4 ef ff ff       	jmp    801067ad <alltraps>

801077e9 <vector249>:
.globl vector249
vector249:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $249
801077eb:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801077f0:	e9 b8 ef ff ff       	jmp    801067ad <alltraps>

801077f5 <vector250>:
.globl vector250
vector250:
  pushl $0
801077f5:	6a 00                	push   $0x0
  pushl $250
801077f7:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801077fc:	e9 ac ef ff ff       	jmp    801067ad <alltraps>

80107801 <vector251>:
.globl vector251
vector251:
  pushl $0
80107801:	6a 00                	push   $0x0
  pushl $251
80107803:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107808:	e9 a0 ef ff ff       	jmp    801067ad <alltraps>

8010780d <vector252>:
.globl vector252
vector252:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $252
8010780f:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107814:	e9 94 ef ff ff       	jmp    801067ad <alltraps>

80107819 <vector253>:
.globl vector253
vector253:
  pushl $0
80107819:	6a 00                	push   $0x0
  pushl $253
8010781b:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107820:	e9 88 ef ff ff       	jmp    801067ad <alltraps>

80107825 <vector254>:
.globl vector254
vector254:
  pushl $0
80107825:	6a 00                	push   $0x0
  pushl $254
80107827:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010782c:	e9 7c ef ff ff       	jmp    801067ad <alltraps>

80107831 <vector255>:
.globl vector255
vector255:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $255
80107833:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107838:	e9 70 ef ff ff       	jmp    801067ad <alltraps>

8010783d <sgenrand>:
static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */

/* initializing the array with a NONZERO seed */
void
sgenrand(unsigned long seed)
{
8010783d:	55                   	push   %ebp
8010783e:	89 e5                	mov    %esp,%ebp
80107840:	53                   	push   %ebx
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
80107841:	8b 45 08             	mov    0x8(%ebp),%eax
80107844:	a3 80 b6 10 80       	mov    %eax,0x8010b680
    for (mti=1; mti<N; mti++)
80107849:	c7 05 a0 b4 10 80 01 	movl   $0x1,0x8010b4a0
80107850:	00 00 00 
80107853:	eb 4d                	jmp    801078a2 <sgenrand+0x65>
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80107855:	8b 0d a0 b4 10 80    	mov    0x8010b4a0,%ecx
8010785b:	a1 a0 b4 10 80       	mov    0x8010b4a0,%eax
80107860:	48                   	dec    %eax
80107861:	8b 14 85 80 b6 10 80 	mov    -0x7fef4980(,%eax,4),%edx
80107868:	89 d0                	mov    %edx,%eax
8010786a:	01 c0                	add    %eax,%eax
8010786c:	01 d0                	add    %edx,%eax
8010786e:	01 c0                	add    %eax,%eax
80107870:	01 d0                	add    %edx,%eax
80107872:	c1 e0 02             	shl    $0x2,%eax
80107875:	01 d0                	add    %edx,%eax
80107877:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
8010787e:	01 d8                	add    %ebx,%eax
80107880:	01 c0                	add    %eax,%eax
80107882:	01 d0                	add    %edx,%eax
80107884:	c1 e0 02             	shl    $0x2,%eax
80107887:	01 d0                	add    %edx,%eax
80107889:	89 c2                	mov    %eax,%edx
8010788b:	c1 e2 05             	shl    $0x5,%edx
8010788e:	01 d0                	add    %edx,%eax
80107890:	89 04 8d 80 b6 10 80 	mov    %eax,-0x7fef4980(,%ecx,4)
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
    for (mti=1; mti<N; mti++)
80107897:	a1 a0 b4 10 80       	mov    0x8010b4a0,%eax
8010789c:	40                   	inc    %eax
8010789d:	a3 a0 b4 10 80       	mov    %eax,0x8010b4a0
801078a2:	a1 a0 b4 10 80       	mov    0x8010b4a0,%eax
801078a7:	3d 6f 02 00 00       	cmp    $0x26f,%eax
801078ac:	7e a7                	jle    80107855 <sgenrand+0x18>
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
}
801078ae:	5b                   	pop    %ebx
801078af:	5d                   	pop    %ebp
801078b0:	c3                   	ret    

801078b1 <genrand>:

long /* for integer generation */
genrand()
{
801078b1:	55                   	push   %ebp
801078b2:	89 e5                	mov    %esp,%ebp
801078b4:	83 ec 10             	sub    $0x10,%esp
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
801078b7:	a1 a0 b4 10 80       	mov    0x8010b4a0,%eax
801078bc:	3d 6f 02 00 00       	cmp    $0x26f,%eax
801078c1:	0f 8e 2b 01 00 00    	jle    801079f2 <genrand+0x141>
        int kk;

        if (mti == N+1)   /* if sgenrand() has not been called, */
801078c7:	a1 a0 b4 10 80       	mov    0x8010b4a0,%eax
801078cc:	3d 71 02 00 00       	cmp    $0x271,%eax
801078d1:	75 0d                	jne    801078e0 <genrand+0x2f>
            sgenrand(4357); /* a default initial seed is used   */
801078d3:	68 05 11 00 00       	push   $0x1105
801078d8:	e8 60 ff ff ff       	call   8010783d <sgenrand>
801078dd:	83 c4 04             	add    $0x4,%esp

        for (kk=0;kk<N-M;kk++) {
801078e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801078e7:	eb 58                	jmp    80107941 <genrand+0x90>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
801078e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801078ec:	8b 04 85 80 b6 10 80 	mov    -0x7fef4980(,%eax,4),%eax
801078f3:	25 00 00 00 80       	and    $0x80000000,%eax
801078f8:	89 c2                	mov    %eax,%edx
801078fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801078fd:	40                   	inc    %eax
801078fe:	8b 04 85 80 b6 10 80 	mov    -0x7fef4980(,%eax,4),%eax
80107905:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
8010790a:	09 d0                	or     %edx,%eax
8010790c:	89 45 f8             	mov    %eax,-0x8(%ebp)
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
8010790f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107912:	05 8d 01 00 00       	add    $0x18d,%eax
80107917:	8b 04 85 80 b6 10 80 	mov    -0x7fef4980(,%eax,4),%eax
8010791e:	8b 55 f8             	mov    -0x8(%ebp),%edx
80107921:	d1 ea                	shr    %edx
80107923:	31 c2                	xor    %eax,%edx
80107925:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107928:	83 e0 01             	and    $0x1,%eax
8010792b:	8b 04 85 a4 b4 10 80 	mov    -0x7fef4b5c(,%eax,4),%eax
80107932:	31 c2                	xor    %eax,%edx
80107934:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107937:	89 14 85 80 b6 10 80 	mov    %edx,-0x7fef4980(,%eax,4)
        int kk;

        if (mti == N+1)   /* if sgenrand() has not been called, */
            sgenrand(4357); /* a default initial seed is used   */

        for (kk=0;kk<N-M;kk++) {
8010793e:	ff 45 fc             	incl   -0x4(%ebp)
80107941:	81 7d fc e2 00 00 00 	cmpl   $0xe2,-0x4(%ebp)
80107948:	7e 9f                	jle    801078e9 <genrand+0x38>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
        }
        for (;kk<N-1;kk++) {
8010794a:	eb 58                	jmp    801079a4 <genrand+0xf3>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
8010794c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010794f:	8b 04 85 80 b6 10 80 	mov    -0x7fef4980(,%eax,4),%eax
80107956:	25 00 00 00 80       	and    $0x80000000,%eax
8010795b:	89 c2                	mov    %eax,%edx
8010795d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107960:	40                   	inc    %eax
80107961:	8b 04 85 80 b6 10 80 	mov    -0x7fef4980(,%eax,4),%eax
80107968:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
8010796d:	09 d0                	or     %edx,%eax
8010796f:	89 45 f8             	mov    %eax,-0x8(%ebp)
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
80107972:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107975:	2d e3 00 00 00       	sub    $0xe3,%eax
8010797a:	8b 04 85 80 b6 10 80 	mov    -0x7fef4980(,%eax,4),%eax
80107981:	8b 55 f8             	mov    -0x8(%ebp),%edx
80107984:	d1 ea                	shr    %edx
80107986:	31 c2                	xor    %eax,%edx
80107988:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010798b:	83 e0 01             	and    $0x1,%eax
8010798e:	8b 04 85 a4 b4 10 80 	mov    -0x7fef4b5c(,%eax,4),%eax
80107995:	31 c2                	xor    %eax,%edx
80107997:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010799a:	89 14 85 80 b6 10 80 	mov    %edx,-0x7fef4980(,%eax,4)

        for (kk=0;kk<N-M;kk++) {
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
        }
        for (;kk<N-1;kk++) {
801079a1:	ff 45 fc             	incl   -0x4(%ebp)
801079a4:	81 7d fc 6e 02 00 00 	cmpl   $0x26e,-0x4(%ebp)
801079ab:	7e 9f                	jle    8010794c <genrand+0x9b>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
        }
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
801079ad:	a1 3c c0 10 80       	mov    0x8010c03c,%eax
801079b2:	25 00 00 00 80       	and    $0x80000000,%eax
801079b7:	89 c2                	mov    %eax,%edx
801079b9:	a1 80 b6 10 80       	mov    0x8010b680,%eax
801079be:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
801079c3:	09 d0                	or     %edx,%eax
801079c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
801079c8:	a1 b0 bc 10 80       	mov    0x8010bcb0,%eax
801079cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
801079d0:	d1 ea                	shr    %edx
801079d2:	31 c2                	xor    %eax,%edx
801079d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801079d7:	83 e0 01             	and    $0x1,%eax
801079da:	8b 04 85 a4 b4 10 80 	mov    -0x7fef4b5c(,%eax,4),%eax
801079e1:	31 d0                	xor    %edx,%eax
801079e3:	a3 3c c0 10 80       	mov    %eax,0x8010c03c

        mti = 0;
801079e8:	c7 05 a0 b4 10 80 00 	movl   $0x0,0x8010b4a0
801079ef:	00 00 00 
    }
  
    y = mt[mti++];
801079f2:	a1 a0 b4 10 80       	mov    0x8010b4a0,%eax
801079f7:	8d 50 01             	lea    0x1(%eax),%edx
801079fa:	89 15 a0 b4 10 80    	mov    %edx,0x8010b4a0
80107a00:	8b 04 85 80 b6 10 80 	mov    -0x7fef4980(,%eax,4),%eax
80107a07:	89 45 f8             	mov    %eax,-0x8(%ebp)
    y ^= TEMPERING_SHIFT_U(y);
80107a0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a0d:	c1 e8 0b             	shr    $0xb,%eax
80107a10:	31 45 f8             	xor    %eax,-0x8(%ebp)
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
80107a13:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a16:	c1 e0 07             	shl    $0x7,%eax
80107a19:	25 80 56 2c 9d       	and    $0x9d2c5680,%eax
80107a1e:	31 45 f8             	xor    %eax,-0x8(%ebp)
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
80107a21:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a24:	c1 e0 0f             	shl    $0xf,%eax
80107a27:	25 00 00 c6 ef       	and    $0xefc60000,%eax
80107a2c:	31 45 f8             	xor    %eax,-0x8(%ebp)
    y ^= TEMPERING_SHIFT_L(y);
80107a2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a32:	c1 e8 12             	shr    $0x12,%eax
80107a35:	31 45 f8             	xor    %eax,-0x8(%ebp)

    // Strip off uppermost bit because we want a long,
    // not an unsigned long
    return y & RAND_MAX;
80107a38:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a3b:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
80107a40:	c9                   	leave  
80107a41:	c3                   	ret    

80107a42 <random_at_most>:

// Assumes 0 <= max <= RAND_MAX
// Returns in the half-open interval [0, max]
long random_at_most(long max) {
80107a42:	55                   	push   %ebp
80107a43:	89 e5                	mov    %esp,%ebp
80107a45:	83 ec 20             	sub    $0x20,%esp
  unsigned long
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
    num_bins = (unsigned long) max + 1,
80107a48:	8b 45 08             	mov    0x8(%ebp),%eax
80107a4b:	40                   	inc    %eax
80107a4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    num_rand = (unsigned long) RAND_MAX + 1,
80107a4f:	c7 45 f8 00 00 00 80 	movl   $0x80000000,-0x8(%ebp)
    bin_size = num_rand / num_bins,
80107a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a59:	ba 00 00 00 00       	mov    $0x0,%edx
80107a5e:	f7 75 fc             	divl   -0x4(%ebp)
80107a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    defect   = num_rand % num_bins;
80107a64:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a67:	ba 00 00 00 00       	mov    $0x0,%edx
80107a6c:	f7 75 fc             	divl   -0x4(%ebp)
80107a6f:	89 55 f0             	mov    %edx,-0x10(%ebp)

  long x;
  do {
   x = genrand();
80107a72:	e8 3a fe ff ff       	call   801078b1 <genrand>
80107a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
80107a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a7d:	2b 45 f0             	sub    -0x10(%ebp),%eax
80107a80:	89 c2                	mov    %eax,%edx
80107a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a85:	39 c2                	cmp    %eax,%edx
80107a87:	76 e9                	jbe    80107a72 <random_at_most+0x30>

  // Truncated division is intentional
  return x/bin_size;
80107a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a8c:	ba 00 00 00 00       	mov    $0x0,%edx
80107a91:	f7 75 f4             	divl   -0xc(%ebp)
}
80107a94:	c9                   	leave  
80107a95:	c3                   	ret    

80107a96 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107a96:	55                   	push   %ebp
80107a97:	89 e5                	mov    %esp,%ebp
80107a99:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a9f:	48                   	dec    %eax
80107aa0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80107aa7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107aab:	8b 45 08             	mov    0x8(%ebp),%eax
80107aae:	c1 e8 10             	shr    $0x10,%eax
80107ab1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107ab5:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ab8:	0f 01 10             	lgdtl  (%eax)
}
80107abb:	c9                   	leave  
80107abc:	c3                   	ret    

80107abd <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107abd:	55                   	push   %ebp
80107abe:	89 e5                	mov    %esp,%ebp
80107ac0:	83 ec 04             	sub    $0x4,%esp
80107ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ac6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107acd:	0f 00 d8             	ltr    %ax
}
80107ad0:	c9                   	leave  
80107ad1:	c3                   	ret    

80107ad2 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107ad2:	55                   	push   %ebp
80107ad3:	89 e5                	mov    %esp,%ebp
80107ad5:	83 ec 04             	sub    $0x4,%esp
80107ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80107adb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107adf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ae2:	8e e8                	mov    %eax,%gs
}
80107ae4:	c9                   	leave  
80107ae5:	c3                   	ret    

80107ae6 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107ae6:	55                   	push   %ebp
80107ae7:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80107aec:	0f 22 d8             	mov    %eax,%cr3
}
80107aef:	5d                   	pop    %ebp
80107af0:	c3                   	ret    

80107af1 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107af1:	55                   	push   %ebp
80107af2:	89 e5                	mov    %esp,%ebp
80107af4:	8b 45 08             	mov    0x8(%ebp),%eax
80107af7:	05 00 00 00 80       	add    $0x80000000,%eax
80107afc:	5d                   	pop    %ebp
80107afd:	c3                   	ret    

80107afe <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107afe:	55                   	push   %ebp
80107aff:	89 e5                	mov    %esp,%ebp
80107b01:	8b 45 08             	mov    0x8(%ebp),%eax
80107b04:	05 00 00 00 80       	add    $0x80000000,%eax
80107b09:	5d                   	pop    %ebp
80107b0a:	c3                   	ret    

80107b0b <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107b0b:	55                   	push   %ebp
80107b0c:	89 e5                	mov    %esp,%ebp
80107b0e:	53                   	push   %ebx
80107b0f:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107b12:	e8 68 b4 ff ff       	call   80102f7f <cpunum>
80107b17:	89 c2                	mov    %eax,%edx
80107b19:	89 d0                	mov    %edx,%eax
80107b1b:	c1 e0 02             	shl    $0x2,%eax
80107b1e:	01 d0                	add    %edx,%eax
80107b20:	01 c0                	add    %eax,%eax
80107b22:	01 d0                	add    %edx,%eax
80107b24:	89 c1                	mov    %eax,%ecx
80107b26:	c1 e1 04             	shl    $0x4,%ecx
80107b29:	01 c8                	add    %ecx,%eax
80107b2b:	01 d0                	add    %edx,%eax
80107b2d:	05 40 2d 11 80       	add    $0x80112d40,%eax
80107b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b38:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b41:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4a:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b51:	8a 50 7d             	mov    0x7d(%eax),%dl
80107b54:	83 e2 f0             	and    $0xfffffff0,%edx
80107b57:	83 ca 0a             	or     $0xa,%edx
80107b5a:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b60:	8a 50 7d             	mov    0x7d(%eax),%dl
80107b63:	83 ca 10             	or     $0x10,%edx
80107b66:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6c:	8a 50 7d             	mov    0x7d(%eax),%dl
80107b6f:	83 e2 9f             	and    $0xffffff9f,%edx
80107b72:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b78:	8a 50 7d             	mov    0x7d(%eax),%dl
80107b7b:	83 ca 80             	or     $0xffffff80,%edx
80107b7e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b84:	8a 50 7e             	mov    0x7e(%eax),%dl
80107b87:	83 ca 0f             	or     $0xf,%edx
80107b8a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b90:	8a 50 7e             	mov    0x7e(%eax),%dl
80107b93:	83 e2 ef             	and    $0xffffffef,%edx
80107b96:	88 50 7e             	mov    %dl,0x7e(%eax)
80107b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b9c:	8a 50 7e             	mov    0x7e(%eax),%dl
80107b9f:	83 e2 df             	and    $0xffffffdf,%edx
80107ba2:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba8:	8a 50 7e             	mov    0x7e(%eax),%dl
80107bab:	83 ca 40             	or     $0x40,%edx
80107bae:	88 50 7e             	mov    %dl,0x7e(%eax)
80107bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb4:	8a 50 7e             	mov    0x7e(%eax),%dl
80107bb7:	83 ca 80             	or     $0xffffff80,%edx
80107bba:	88 50 7e             	mov    %dl,0x7e(%eax)
80107bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc0:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc7:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107bce:	ff ff 
80107bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd3:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107bda:	00 00 
80107bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bdf:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be9:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107bef:	83 e2 f0             	and    $0xfffffff0,%edx
80107bf2:	83 ca 02             	or     $0x2,%edx
80107bf5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfe:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107c04:	83 ca 10             	or     $0x10,%edx
80107c07:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c10:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107c16:	83 e2 9f             	and    $0xffffff9f,%edx
80107c19:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c22:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107c28:	83 ca 80             	or     $0xffffff80,%edx
80107c2b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c34:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107c3a:	83 ca 0f             	or     $0xf,%edx
80107c3d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c46:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107c4c:	83 e2 ef             	and    $0xffffffef,%edx
80107c4f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c58:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107c5e:	83 e2 df             	and    $0xffffffdf,%edx
80107c61:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6a:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107c70:	83 ca 40             	or     $0x40,%edx
80107c73:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7c:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107c82:	83 ca 80             	or     $0xffffff80,%edx
80107c85:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8e:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c98:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107c9f:	ff ff 
80107ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca4:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107cab:	00 00 
80107cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb0:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cba:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107cc0:	83 e2 f0             	and    $0xfffffff0,%edx
80107cc3:	83 ca 0a             	or     $0xa,%edx
80107cc6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccf:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107cd5:	83 ca 10             	or     $0x10,%edx
80107cd8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce1:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107ce7:	83 ca 60             	or     $0x60,%edx
80107cea:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf3:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107cf9:	83 ca 80             	or     $0xffffff80,%edx
80107cfc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d05:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107d0b:	83 ca 0f             	or     $0xf,%edx
80107d0e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d17:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107d1d:	83 e2 ef             	and    $0xffffffef,%edx
80107d20:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d29:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107d2f:	83 e2 df             	and    $0xffffffdf,%edx
80107d32:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107d41:	83 ca 40             	or     $0x40,%edx
80107d44:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4d:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107d53:	83 ca 80             	or     $0xffffff80,%edx
80107d56:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5f:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d69:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107d70:	ff ff 
80107d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d75:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107d7c:	00 00 
80107d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d81:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8b:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107d91:	83 e2 f0             	and    $0xfffffff0,%edx
80107d94:	83 ca 02             	or     $0x2,%edx
80107d97:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da0:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107da6:	83 ca 10             	or     $0x10,%edx
80107da9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db2:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107db8:	83 ca 60             	or     $0x60,%edx
80107dbb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc4:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107dca:	83 ca 80             	or     $0xffffff80,%edx
80107dcd:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd6:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107ddc:	83 ca 0f             	or     $0xf,%edx
80107ddf:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de8:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107dee:	83 e2 ef             	and    $0xffffffef,%edx
80107df1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfa:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107e00:	83 e2 df             	and    $0xffffffdf,%edx
80107e03:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0c:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107e12:	83 ca 40             	or     $0x40,%edx
80107e15:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1e:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107e24:	83 ca 80             	or     $0xffffff80,%edx
80107e27:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e30:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3a:	05 b4 00 00 00       	add    $0xb4,%eax
80107e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e42:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107e48:	c1 ea 10             	shr    $0x10,%edx
80107e4b:	88 d1                	mov    %dl,%cl
80107e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e50:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107e56:	c1 ea 18             	shr    $0x18,%edx
80107e59:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80107e5c:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
80107e63:	00 00 
80107e65:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80107e68:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
80107e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e72:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7b:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107e81:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e84:	83 c9 02             	or     $0x2,%ecx
80107e87:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e90:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107e96:	83 c9 10             	or     $0x10,%ecx
80107e99:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea2:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107ea8:	83 e1 9f             	and    $0xffffff9f,%ecx
80107eab:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb4:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107eba:	83 c9 80             	or     $0xffffff80,%ecx
80107ebd:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec6:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107ecc:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ecf:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed8:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107ede:	83 e1 ef             	and    $0xffffffef,%ecx
80107ee1:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eea:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107ef0:	83 e1 df             	and    $0xffffffdf,%ecx
80107ef3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efc:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107f02:	83 c9 40             	or     $0x40,%ecx
80107f05:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0e:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107f14:	83 c9 80             	or     $0xffffff80,%ecx
80107f17:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f20:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f29:	83 c0 70             	add    $0x70,%eax
80107f2c:	83 ec 08             	sub    $0x8,%esp
80107f2f:	6a 38                	push   $0x38
80107f31:	50                   	push   %eax
80107f32:	e8 5f fb ff ff       	call   80107a96 <lgdt>
80107f37:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107f3a:	83 ec 0c             	sub    $0xc,%esp
80107f3d:	6a 18                	push   $0x18
80107f3f:	e8 8e fb ff ff       	call   80107ad2 <loadgs>
80107f44:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4a:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107f50:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107f57:	00 00 00 00 
}
80107f5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107f5e:	c9                   	leave  
80107f5f:	c3                   	ret    

80107f60 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107f60:	55                   	push   %ebp
80107f61:	89 e5                	mov    %esp,%ebp
80107f63:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107f66:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f69:	c1 e8 16             	shr    $0x16,%eax
80107f6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f73:	8b 45 08             	mov    0x8(%ebp),%eax
80107f76:	01 d0                	add    %edx,%eax
80107f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f7e:	8b 00                	mov    (%eax),%eax
80107f80:	83 e0 01             	and    $0x1,%eax
80107f83:	85 c0                	test   %eax,%eax
80107f85:	74 18                	je     80107f9f <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f8a:	8b 00                	mov    (%eax),%eax
80107f8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f91:	50                   	push   %eax
80107f92:	e8 67 fb ff ff       	call   80107afe <p2v>
80107f97:	83 c4 04             	add    $0x4,%esp
80107f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107f9d:	eb 48                	jmp    80107fe7 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107fa3:	74 0e                	je     80107fb3 <walkpgdir+0x53>
80107fa5:	e8 7e ac ff ff       	call   80102c28 <kalloc>
80107faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107fad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107fb1:	75 07                	jne    80107fba <walkpgdir+0x5a>
      return 0;
80107fb3:	b8 00 00 00 00       	mov    $0x0,%eax
80107fb8:	eb 44                	jmp    80107ffe <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107fba:	83 ec 04             	sub    $0x4,%esp
80107fbd:	68 00 10 00 00       	push   $0x1000
80107fc2:	6a 00                	push   $0x0
80107fc4:	ff 75 f4             	pushl  -0xc(%ebp)
80107fc7:	e8 e8 d3 ff ff       	call   801053b4 <memset>
80107fcc:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107fcf:	83 ec 0c             	sub    $0xc,%esp
80107fd2:	ff 75 f4             	pushl  -0xc(%ebp)
80107fd5:	e8 17 fb ff ff       	call   80107af1 <v2p>
80107fda:	83 c4 10             	add    $0x10,%esp
80107fdd:	83 c8 07             	or     $0x7,%eax
80107fe0:	89 c2                	mov    %eax,%edx
80107fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fe5:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fea:	c1 e8 0c             	shr    $0xc,%eax
80107fed:	25 ff 03 00 00       	and    $0x3ff,%eax
80107ff2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffc:	01 d0                	add    %edx,%eax
}
80107ffe:	c9                   	leave  
80107fff:	c3                   	ret    

80108000 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108000:	55                   	push   %ebp
80108001:	89 e5                	mov    %esp,%ebp
80108003:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108006:	8b 45 0c             	mov    0xc(%ebp),%eax
80108009:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010800e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108011:	8b 55 0c             	mov    0xc(%ebp),%edx
80108014:	8b 45 10             	mov    0x10(%ebp),%eax
80108017:	01 d0                	add    %edx,%eax
80108019:	48                   	dec    %eax
8010801a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010801f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108022:	83 ec 04             	sub    $0x4,%esp
80108025:	6a 01                	push   $0x1
80108027:	ff 75 f4             	pushl  -0xc(%ebp)
8010802a:	ff 75 08             	pushl  0x8(%ebp)
8010802d:	e8 2e ff ff ff       	call   80107f60 <walkpgdir>
80108032:	83 c4 10             	add    $0x10,%esp
80108035:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108038:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010803c:	75 07                	jne    80108045 <mappages+0x45>
      return -1;
8010803e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108043:	eb 49                	jmp    8010808e <mappages+0x8e>
    if(*pte & PTE_P)
80108045:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108048:	8b 00                	mov    (%eax),%eax
8010804a:	83 e0 01             	and    $0x1,%eax
8010804d:	85 c0                	test   %eax,%eax
8010804f:	74 0d                	je     8010805e <mappages+0x5e>
      panic("remap");
80108051:	83 ec 0c             	sub    $0xc,%esp
80108054:	68 9c 8e 10 80       	push   $0x80108e9c
80108059:	e8 6b 85 ff ff       	call   801005c9 <panic>
    *pte = pa | perm | PTE_P;
8010805e:	8b 45 18             	mov    0x18(%ebp),%eax
80108061:	0b 45 14             	or     0x14(%ebp),%eax
80108064:	83 c8 01             	or     $0x1,%eax
80108067:	89 c2                	mov    %eax,%edx
80108069:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010806c:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010806e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108071:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108074:	75 08                	jne    8010807e <mappages+0x7e>
      break;
80108076:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108077:	b8 00 00 00 00       	mov    $0x0,%eax
8010807c:	eb 10                	jmp    8010808e <mappages+0x8e>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
8010807e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108085:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010808c:	eb 94                	jmp    80108022 <mappages+0x22>
  return 0;
}
8010808e:	c9                   	leave  
8010808f:	c3                   	ret    

80108090 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108090:	55                   	push   %ebp
80108091:	89 e5                	mov    %esp,%ebp
80108093:	53                   	push   %ebx
80108094:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108097:	e8 8c ab ff ff       	call   80102c28 <kalloc>
8010809c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010809f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080a3:	75 0a                	jne    801080af <setupkvm+0x1f>
    return 0;
801080a5:	b8 00 00 00 00       	mov    $0x0,%eax
801080aa:	e9 8e 00 00 00       	jmp    8010813d <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801080af:	83 ec 04             	sub    $0x4,%esp
801080b2:	68 00 10 00 00       	push   $0x1000
801080b7:	6a 00                	push   $0x0
801080b9:	ff 75 f0             	pushl  -0x10(%ebp)
801080bc:	e8 f3 d2 ff ff       	call   801053b4 <memset>
801080c1:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801080c4:	83 ec 0c             	sub    $0xc,%esp
801080c7:	68 00 00 00 0e       	push   $0xe000000
801080cc:	e8 2d fa ff ff       	call   80107afe <p2v>
801080d1:	83 c4 10             	add    $0x10,%esp
801080d4:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801080d9:	76 0d                	jbe    801080e8 <setupkvm+0x58>
    panic("PHYSTOP too high");
801080db:	83 ec 0c             	sub    $0xc,%esp
801080de:	68 a2 8e 10 80       	push   $0x80108ea2
801080e3:	e8 e1 84 ff ff       	call   801005c9 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801080e8:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
801080ef:	eb 40                	jmp    80108131 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801080f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f4:	8b 48 0c             	mov    0xc(%eax),%ecx
801080f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fa:	8b 50 04             	mov    0x4(%eax),%edx
801080fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108100:	8b 58 08             	mov    0x8(%eax),%ebx
80108103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108106:	8b 40 04             	mov    0x4(%eax),%eax
80108109:	29 c3                	sub    %eax,%ebx
8010810b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810e:	8b 00                	mov    (%eax),%eax
80108110:	83 ec 0c             	sub    $0xc,%esp
80108113:	51                   	push   %ecx
80108114:	52                   	push   %edx
80108115:	53                   	push   %ebx
80108116:	50                   	push   %eax
80108117:	ff 75 f0             	pushl  -0x10(%ebp)
8010811a:	e8 e1 fe ff ff       	call   80108000 <mappages>
8010811f:	83 c4 20             	add    $0x20,%esp
80108122:	85 c0                	test   %eax,%eax
80108124:	79 07                	jns    8010812d <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108126:	b8 00 00 00 00       	mov    $0x0,%eax
8010812b:	eb 10                	jmp    8010813d <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010812d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108131:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80108138:	72 b7                	jb     801080f1 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010813a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010813d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108140:	c9                   	leave  
80108141:	c3                   	ret    

80108142 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108142:	55                   	push   %ebp
80108143:	89 e5                	mov    %esp,%ebp
80108145:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108148:	e8 43 ff ff ff       	call   80108090 <setupkvm>
8010814d:	a3 18 5c 11 80       	mov    %eax,0x80115c18
  switchkvm();
80108152:	e8 02 00 00 00       	call   80108159 <switchkvm>
}
80108157:	c9                   	leave  
80108158:	c3                   	ret    

80108159 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108159:	55                   	push   %ebp
8010815a:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010815c:	a1 18 5c 11 80       	mov    0x80115c18,%eax
80108161:	50                   	push   %eax
80108162:	e8 8a f9 ff ff       	call   80107af1 <v2p>
80108167:	83 c4 04             	add    $0x4,%esp
8010816a:	50                   	push   %eax
8010816b:	e8 76 f9 ff ff       	call   80107ae6 <lcr3>
80108170:	83 c4 04             	add    $0x4,%esp
}
80108173:	c9                   	leave  
80108174:	c3                   	ret    

80108175 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108175:	55                   	push   %ebp
80108176:	89 e5                	mov    %esp,%ebp
80108178:	53                   	push   %ebx
80108179:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010817c:	e8 33 d1 ff ff       	call   801052b4 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108181:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108187:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010818e:	83 c2 08             	add    $0x8,%edx
80108191:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80108198:	83 c1 08             	add    $0x8,%ecx
8010819b:	c1 e9 10             	shr    $0x10,%ecx
8010819e:	88 cb                	mov    %cl,%bl
801081a0:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801081a7:	83 c1 08             	add    $0x8,%ecx
801081aa:	c1 e9 18             	shr    $0x18,%ecx
801081ad:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801081b4:	67 00 
801081b6:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
801081bd:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801081c3:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801081c9:	83 e2 f0             	and    $0xfffffff0,%edx
801081cc:	83 ca 09             	or     $0x9,%edx
801081cf:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801081d5:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801081db:	83 ca 10             	or     $0x10,%edx
801081de:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801081e4:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801081ea:	83 e2 9f             	and    $0xffffff9f,%edx
801081ed:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801081f3:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801081f9:	83 ca 80             	or     $0xffffff80,%edx
801081fc:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108202:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108208:	83 e2 f0             	and    $0xfffffff0,%edx
8010820b:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108211:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108217:	83 e2 ef             	and    $0xffffffef,%edx
8010821a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108220:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108226:	83 e2 df             	and    $0xffffffdf,%edx
80108229:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010822f:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108235:	83 ca 40             	or     $0x40,%edx
80108238:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010823e:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108244:	83 e2 7f             	and    $0x7f,%edx
80108247:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010824d:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108253:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108259:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010825f:	83 e2 ef             	and    $0xffffffef,%edx
80108262:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108268:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010826e:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108274:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010827a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108281:	8b 52 08             	mov    0x8(%edx),%edx
80108284:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010828a:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010828d:	83 ec 0c             	sub    $0xc,%esp
80108290:	6a 30                	push   $0x30
80108292:	e8 26 f8 ff ff       	call   80107abd <ltr>
80108297:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010829a:	8b 45 08             	mov    0x8(%ebp),%eax
8010829d:	8b 40 04             	mov    0x4(%eax),%eax
801082a0:	85 c0                	test   %eax,%eax
801082a2:	75 0d                	jne    801082b1 <switchuvm+0x13c>
    panic("switchuvm: no pgdir");
801082a4:	83 ec 0c             	sub    $0xc,%esp
801082a7:	68 b3 8e 10 80       	push   $0x80108eb3
801082ac:	e8 18 83 ff ff       	call   801005c9 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801082b1:	8b 45 08             	mov    0x8(%ebp),%eax
801082b4:	8b 40 04             	mov    0x4(%eax),%eax
801082b7:	83 ec 0c             	sub    $0xc,%esp
801082ba:	50                   	push   %eax
801082bb:	e8 31 f8 ff ff       	call   80107af1 <v2p>
801082c0:	83 c4 10             	add    $0x10,%esp
801082c3:	83 ec 0c             	sub    $0xc,%esp
801082c6:	50                   	push   %eax
801082c7:	e8 1a f8 ff ff       	call   80107ae6 <lcr3>
801082cc:	83 c4 10             	add    $0x10,%esp
  popcli();
801082cf:	e8 24 d0 ff ff       	call   801052f8 <popcli>
}
801082d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082d7:	c9                   	leave  
801082d8:	c3                   	ret    

801082d9 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801082d9:	55                   	push   %ebp
801082da:	89 e5                	mov    %esp,%ebp
801082dc:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801082df:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801082e6:	76 0d                	jbe    801082f5 <inituvm+0x1c>
    panic("inituvm: more than a page");
801082e8:	83 ec 0c             	sub    $0xc,%esp
801082eb:	68 c7 8e 10 80       	push   $0x80108ec7
801082f0:	e8 d4 82 ff ff       	call   801005c9 <panic>
  mem = kalloc();
801082f5:	e8 2e a9 ff ff       	call   80102c28 <kalloc>
801082fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801082fd:	83 ec 04             	sub    $0x4,%esp
80108300:	68 00 10 00 00       	push   $0x1000
80108305:	6a 00                	push   $0x0
80108307:	ff 75 f4             	pushl  -0xc(%ebp)
8010830a:	e8 a5 d0 ff ff       	call   801053b4 <memset>
8010830f:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108312:	83 ec 0c             	sub    $0xc,%esp
80108315:	ff 75 f4             	pushl  -0xc(%ebp)
80108318:	e8 d4 f7 ff ff       	call   80107af1 <v2p>
8010831d:	83 c4 10             	add    $0x10,%esp
80108320:	83 ec 0c             	sub    $0xc,%esp
80108323:	6a 06                	push   $0x6
80108325:	50                   	push   %eax
80108326:	68 00 10 00 00       	push   $0x1000
8010832b:	6a 00                	push   $0x0
8010832d:	ff 75 08             	pushl  0x8(%ebp)
80108330:	e8 cb fc ff ff       	call   80108000 <mappages>
80108335:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108338:	83 ec 04             	sub    $0x4,%esp
8010833b:	ff 75 10             	pushl  0x10(%ebp)
8010833e:	ff 75 0c             	pushl  0xc(%ebp)
80108341:	ff 75 f4             	pushl  -0xc(%ebp)
80108344:	e8 24 d1 ff ff       	call   8010546d <memmove>
80108349:	83 c4 10             	add    $0x10,%esp
}
8010834c:	c9                   	leave  
8010834d:	c3                   	ret    

8010834e <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010834e:	55                   	push   %ebp
8010834f:	89 e5                	mov    %esp,%ebp
80108351:	53                   	push   %ebx
80108352:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108355:	8b 45 0c             	mov    0xc(%ebp),%eax
80108358:	25 ff 0f 00 00       	and    $0xfff,%eax
8010835d:	85 c0                	test   %eax,%eax
8010835f:	74 0d                	je     8010836e <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108361:	83 ec 0c             	sub    $0xc,%esp
80108364:	68 e4 8e 10 80       	push   $0x80108ee4
80108369:	e8 5b 82 ff ff       	call   801005c9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010836e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108375:	e9 95 00 00 00       	jmp    8010840f <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010837a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010837d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108380:	01 d0                	add    %edx,%eax
80108382:	83 ec 04             	sub    $0x4,%esp
80108385:	6a 00                	push   $0x0
80108387:	50                   	push   %eax
80108388:	ff 75 08             	pushl  0x8(%ebp)
8010838b:	e8 d0 fb ff ff       	call   80107f60 <walkpgdir>
80108390:	83 c4 10             	add    $0x10,%esp
80108393:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108396:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010839a:	75 0d                	jne    801083a9 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010839c:	83 ec 0c             	sub    $0xc,%esp
8010839f:	68 07 8f 10 80       	push   $0x80108f07
801083a4:	e8 20 82 ff ff       	call   801005c9 <panic>
    pa = PTE_ADDR(*pte);
801083a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083ac:	8b 00                	mov    (%eax),%eax
801083ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801083b6:	8b 45 18             	mov    0x18(%ebp),%eax
801083b9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801083bc:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801083c1:	77 0b                	ja     801083ce <loaduvm+0x80>
      n = sz - i;
801083c3:	8b 45 18             	mov    0x18(%ebp),%eax
801083c6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801083c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801083cc:	eb 07                	jmp    801083d5 <loaduvm+0x87>
    else
      n = PGSIZE;
801083ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801083d5:	8b 55 14             	mov    0x14(%ebp),%edx
801083d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083db:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801083de:	83 ec 0c             	sub    $0xc,%esp
801083e1:	ff 75 e8             	pushl  -0x18(%ebp)
801083e4:	e8 15 f7 ff ff       	call   80107afe <p2v>
801083e9:	83 c4 10             	add    $0x10,%esp
801083ec:	ff 75 f0             	pushl  -0x10(%ebp)
801083ef:	53                   	push   %ebx
801083f0:	50                   	push   %eax
801083f1:	ff 75 10             	pushl  0x10(%ebp)
801083f4:	e8 bf 9a ff ff       	call   80101eb8 <readi>
801083f9:	83 c4 10             	add    $0x10,%esp
801083fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801083ff:	74 07                	je     80108408 <loaduvm+0xba>
      return -1;
80108401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108406:	eb 18                	jmp    80108420 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108408:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010840f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108412:	3b 45 18             	cmp    0x18(%ebp),%eax
80108415:	0f 82 5f ff ff ff    	jb     8010837a <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010841b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108423:	c9                   	leave  
80108424:	c3                   	ret    

80108425 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108425:	55                   	push   %ebp
80108426:	89 e5                	mov    %esp,%ebp
80108428:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010842b:	8b 45 10             	mov    0x10(%ebp),%eax
8010842e:	85 c0                	test   %eax,%eax
80108430:	79 0a                	jns    8010843c <allocuvm+0x17>
    return 0;
80108432:	b8 00 00 00 00       	mov    $0x0,%eax
80108437:	e9 ae 00 00 00       	jmp    801084ea <allocuvm+0xc5>
  if(newsz < oldsz)
8010843c:	8b 45 10             	mov    0x10(%ebp),%eax
8010843f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108442:	73 08                	jae    8010844c <allocuvm+0x27>
    return oldsz;
80108444:	8b 45 0c             	mov    0xc(%ebp),%eax
80108447:	e9 9e 00 00 00       	jmp    801084ea <allocuvm+0xc5>

  a = PGROUNDUP(oldsz);
8010844c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010844f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108454:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108459:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010845c:	eb 7d                	jmp    801084db <allocuvm+0xb6>
    mem = kalloc();
8010845e:	e8 c5 a7 ff ff       	call   80102c28 <kalloc>
80108463:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108466:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010846a:	75 2b                	jne    80108497 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010846c:	83 ec 0c             	sub    $0xc,%esp
8010846f:	68 25 8f 10 80       	push   $0x80108f25
80108474:	e8 92 7f ff ff       	call   8010040b <cprintf>
80108479:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010847c:	83 ec 04             	sub    $0x4,%esp
8010847f:	ff 75 0c             	pushl  0xc(%ebp)
80108482:	ff 75 10             	pushl  0x10(%ebp)
80108485:	ff 75 08             	pushl  0x8(%ebp)
80108488:	e8 5f 00 00 00       	call   801084ec <deallocuvm>
8010848d:	83 c4 10             	add    $0x10,%esp
      return 0;
80108490:	b8 00 00 00 00       	mov    $0x0,%eax
80108495:	eb 53                	jmp    801084ea <allocuvm+0xc5>
    }
    memset(mem, 0, PGSIZE);
80108497:	83 ec 04             	sub    $0x4,%esp
8010849a:	68 00 10 00 00       	push   $0x1000
8010849f:	6a 00                	push   $0x0
801084a1:	ff 75 f0             	pushl  -0x10(%ebp)
801084a4:	e8 0b cf ff ff       	call   801053b4 <memset>
801084a9:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801084ac:	83 ec 0c             	sub    $0xc,%esp
801084af:	ff 75 f0             	pushl  -0x10(%ebp)
801084b2:	e8 3a f6 ff ff       	call   80107af1 <v2p>
801084b7:	83 c4 10             	add    $0x10,%esp
801084ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801084bd:	83 ec 0c             	sub    $0xc,%esp
801084c0:	6a 06                	push   $0x6
801084c2:	50                   	push   %eax
801084c3:	68 00 10 00 00       	push   $0x1000
801084c8:	52                   	push   %edx
801084c9:	ff 75 08             	pushl  0x8(%ebp)
801084cc:	e8 2f fb ff ff       	call   80108000 <mappages>
801084d1:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801084d4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801084db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084de:	3b 45 10             	cmp    0x10(%ebp),%eax
801084e1:	0f 82 77 ff ff ff    	jb     8010845e <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801084e7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801084ea:	c9                   	leave  
801084eb:	c3                   	ret    

801084ec <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801084ec:	55                   	push   %ebp
801084ed:	89 e5                	mov    %esp,%ebp
801084ef:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801084f2:	8b 45 10             	mov    0x10(%ebp),%eax
801084f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801084f8:	72 08                	jb     80108502 <deallocuvm+0x16>
    return oldsz;
801084fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801084fd:	e9 a5 00 00 00       	jmp    801085a7 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108502:	8b 45 10             	mov    0x10(%ebp),%eax
80108505:	05 ff 0f 00 00       	add    $0xfff,%eax
8010850a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010850f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108512:	e9 81 00 00 00       	jmp    80108598 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851a:	83 ec 04             	sub    $0x4,%esp
8010851d:	6a 00                	push   $0x0
8010851f:	50                   	push   %eax
80108520:	ff 75 08             	pushl  0x8(%ebp)
80108523:	e8 38 fa ff ff       	call   80107f60 <walkpgdir>
80108528:	83 c4 10             	add    $0x10,%esp
8010852b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010852e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108532:	75 09                	jne    8010853d <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108534:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010853b:	eb 54                	jmp    80108591 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010853d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108540:	8b 00                	mov    (%eax),%eax
80108542:	83 e0 01             	and    $0x1,%eax
80108545:	85 c0                	test   %eax,%eax
80108547:	74 48                	je     80108591 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108549:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010854c:	8b 00                	mov    (%eax),%eax
8010854e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108553:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108556:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010855a:	75 0d                	jne    80108569 <deallocuvm+0x7d>
        panic("kfree");
8010855c:	83 ec 0c             	sub    $0xc,%esp
8010855f:	68 3d 8f 10 80       	push   $0x80108f3d
80108564:	e8 60 80 ff ff       	call   801005c9 <panic>
      char *v = p2v(pa);
80108569:	83 ec 0c             	sub    $0xc,%esp
8010856c:	ff 75 ec             	pushl  -0x14(%ebp)
8010856f:	e8 8a f5 ff ff       	call   80107afe <p2v>
80108574:	83 c4 10             	add    $0x10,%esp
80108577:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010857a:	83 ec 0c             	sub    $0xc,%esp
8010857d:	ff 75 e8             	pushl  -0x18(%ebp)
80108580:	e8 07 a6 ff ff       	call   80102b8c <kfree>
80108585:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108588:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010858b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108591:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010859e:	0f 82 73 ff ff ff    	jb     80108517 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801085a4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801085a7:	c9                   	leave  
801085a8:	c3                   	ret    

801085a9 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801085a9:	55                   	push   %ebp
801085aa:	89 e5                	mov    %esp,%ebp
801085ac:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801085af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801085b3:	75 0d                	jne    801085c2 <freevm+0x19>
    panic("freevm: no pgdir");
801085b5:	83 ec 0c             	sub    $0xc,%esp
801085b8:	68 43 8f 10 80       	push   $0x80108f43
801085bd:	e8 07 80 ff ff       	call   801005c9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801085c2:	83 ec 04             	sub    $0x4,%esp
801085c5:	6a 00                	push   $0x0
801085c7:	68 00 00 00 80       	push   $0x80000000
801085cc:	ff 75 08             	pushl  0x8(%ebp)
801085cf:	e8 18 ff ff ff       	call   801084ec <deallocuvm>
801085d4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801085d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085de:	eb 4e                	jmp    8010862e <freevm+0x85>
    if(pgdir[i] & PTE_P){
801085e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085ea:	8b 45 08             	mov    0x8(%ebp),%eax
801085ed:	01 d0                	add    %edx,%eax
801085ef:	8b 00                	mov    (%eax),%eax
801085f1:	83 e0 01             	and    $0x1,%eax
801085f4:	85 c0                	test   %eax,%eax
801085f6:	74 33                	je     8010862b <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801085f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108602:	8b 45 08             	mov    0x8(%ebp),%eax
80108605:	01 d0                	add    %edx,%eax
80108607:	8b 00                	mov    (%eax),%eax
80108609:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010860e:	83 ec 0c             	sub    $0xc,%esp
80108611:	50                   	push   %eax
80108612:	e8 e7 f4 ff ff       	call   80107afe <p2v>
80108617:	83 c4 10             	add    $0x10,%esp
8010861a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010861d:	83 ec 0c             	sub    $0xc,%esp
80108620:	ff 75 f0             	pushl  -0x10(%ebp)
80108623:	e8 64 a5 ff ff       	call   80102b8c <kfree>
80108628:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010862b:	ff 45 f4             	incl   -0xc(%ebp)
8010862e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108635:	76 a9                	jbe    801085e0 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108637:	83 ec 0c             	sub    $0xc,%esp
8010863a:	ff 75 08             	pushl  0x8(%ebp)
8010863d:	e8 4a a5 ff ff       	call   80102b8c <kfree>
80108642:	83 c4 10             	add    $0x10,%esp
}
80108645:	c9                   	leave  
80108646:	c3                   	ret    

80108647 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108647:	55                   	push   %ebp
80108648:	89 e5                	mov    %esp,%ebp
8010864a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010864d:	83 ec 04             	sub    $0x4,%esp
80108650:	6a 00                	push   $0x0
80108652:	ff 75 0c             	pushl  0xc(%ebp)
80108655:	ff 75 08             	pushl  0x8(%ebp)
80108658:	e8 03 f9 ff ff       	call   80107f60 <walkpgdir>
8010865d:	83 c4 10             	add    $0x10,%esp
80108660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108667:	75 0d                	jne    80108676 <clearpteu+0x2f>
    panic("clearpteu");
80108669:	83 ec 0c             	sub    $0xc,%esp
8010866c:	68 54 8f 10 80       	push   $0x80108f54
80108671:	e8 53 7f ff ff       	call   801005c9 <panic>
  *pte &= ~PTE_U;
80108676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108679:	8b 00                	mov    (%eax),%eax
8010867b:	83 e0 fb             	and    $0xfffffffb,%eax
8010867e:	89 c2                	mov    %eax,%edx
80108680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108683:	89 10                	mov    %edx,(%eax)
}
80108685:	c9                   	leave  
80108686:	c3                   	ret    

80108687 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108687:	55                   	push   %ebp
80108688:	89 e5                	mov    %esp,%ebp
8010868a:	53                   	push   %ebx
8010868b:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010868e:	e8 fd f9 ff ff       	call   80108090 <setupkvm>
80108693:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108696:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010869a:	75 0a                	jne    801086a6 <copyuvm+0x1f>
    return 0;
8010869c:	b8 00 00 00 00       	mov    $0x0,%eax
801086a1:	e9 f6 00 00 00       	jmp    8010879c <copyuvm+0x115>
  for(i = 0; i < sz; i += PGSIZE){
801086a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801086ad:	e9 c6 00 00 00       	jmp    80108778 <copyuvm+0xf1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801086b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086b5:	83 ec 04             	sub    $0x4,%esp
801086b8:	6a 00                	push   $0x0
801086ba:	50                   	push   %eax
801086bb:	ff 75 08             	pushl  0x8(%ebp)
801086be:	e8 9d f8 ff ff       	call   80107f60 <walkpgdir>
801086c3:	83 c4 10             	add    $0x10,%esp
801086c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801086c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086cd:	75 0d                	jne    801086dc <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801086cf:	83 ec 0c             	sub    $0xc,%esp
801086d2:	68 5e 8f 10 80       	push   $0x80108f5e
801086d7:	e8 ed 7e ff ff       	call   801005c9 <panic>
    if(!(*pte & PTE_P))
801086dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086df:	8b 00                	mov    (%eax),%eax
801086e1:	83 e0 01             	and    $0x1,%eax
801086e4:	85 c0                	test   %eax,%eax
801086e6:	75 0d                	jne    801086f5 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801086e8:	83 ec 0c             	sub    $0xc,%esp
801086eb:	68 78 8f 10 80       	push   $0x80108f78
801086f0:	e8 d4 7e ff ff       	call   801005c9 <panic>
    pa = PTE_ADDR(*pte);
801086f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086f8:	8b 00                	mov    (%eax),%eax
801086fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108702:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108705:	8b 00                	mov    (%eax),%eax
80108707:	25 ff 0f 00 00       	and    $0xfff,%eax
8010870c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010870f:	e8 14 a5 ff ff       	call   80102c28 <kalloc>
80108714:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108717:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010871b:	75 02                	jne    8010871f <copyuvm+0x98>
      goto bad;
8010871d:	eb 6a                	jmp    80108789 <copyuvm+0x102>
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010871f:	83 ec 0c             	sub    $0xc,%esp
80108722:	ff 75 e8             	pushl  -0x18(%ebp)
80108725:	e8 d4 f3 ff ff       	call   80107afe <p2v>
8010872a:	83 c4 10             	add    $0x10,%esp
8010872d:	83 ec 04             	sub    $0x4,%esp
80108730:	68 00 10 00 00       	push   $0x1000
80108735:	50                   	push   %eax
80108736:	ff 75 e0             	pushl  -0x20(%ebp)
80108739:	e8 2f cd ff ff       	call   8010546d <memmove>
8010873e:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108741:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108744:	83 ec 0c             	sub    $0xc,%esp
80108747:	ff 75 e0             	pushl  -0x20(%ebp)
8010874a:	e8 a2 f3 ff ff       	call   80107af1 <v2p>
8010874f:	83 c4 10             	add    $0x10,%esp
80108752:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108755:	83 ec 0c             	sub    $0xc,%esp
80108758:	53                   	push   %ebx
80108759:	50                   	push   %eax
8010875a:	68 00 10 00 00       	push   $0x1000
8010875f:	52                   	push   %edx
80108760:	ff 75 f0             	pushl  -0x10(%ebp)
80108763:	e8 98 f8 ff ff       	call   80108000 <mappages>
80108768:	83 c4 20             	add    $0x20,%esp
8010876b:	85 c0                	test   %eax,%eax
8010876d:	79 02                	jns    80108771 <copyuvm+0xea>
      goto bad;
8010876f:	eb 18                	jmp    80108789 <copyuvm+0x102>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108771:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010877b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010877e:	0f 82 2e ff ff ff    	jb     801086b2 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108784:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108787:	eb 13                	jmp    8010879c <copyuvm+0x115>

bad:
  freevm(d);
80108789:	83 ec 0c             	sub    $0xc,%esp
8010878c:	ff 75 f0             	pushl  -0x10(%ebp)
8010878f:	e8 15 fe ff ff       	call   801085a9 <freevm>
80108794:	83 c4 10             	add    $0x10,%esp
  return 0;
80108797:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010879c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010879f:	c9                   	leave  
801087a0:	c3                   	ret    

801087a1 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801087a1:	55                   	push   %ebp
801087a2:	89 e5                	mov    %esp,%ebp
801087a4:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801087a7:	83 ec 04             	sub    $0x4,%esp
801087aa:	6a 00                	push   $0x0
801087ac:	ff 75 0c             	pushl  0xc(%ebp)
801087af:	ff 75 08             	pushl  0x8(%ebp)
801087b2:	e8 a9 f7 ff ff       	call   80107f60 <walkpgdir>
801087b7:	83 c4 10             	add    $0x10,%esp
801087ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801087bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087c0:	8b 00                	mov    (%eax),%eax
801087c2:	83 e0 01             	and    $0x1,%eax
801087c5:	85 c0                	test   %eax,%eax
801087c7:	75 07                	jne    801087d0 <uva2ka+0x2f>
    return 0;
801087c9:	b8 00 00 00 00       	mov    $0x0,%eax
801087ce:	eb 29                	jmp    801087f9 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801087d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d3:	8b 00                	mov    (%eax),%eax
801087d5:	83 e0 04             	and    $0x4,%eax
801087d8:	85 c0                	test   %eax,%eax
801087da:	75 07                	jne    801087e3 <uva2ka+0x42>
    return 0;
801087dc:	b8 00 00 00 00       	mov    $0x0,%eax
801087e1:	eb 16                	jmp    801087f9 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801087e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e6:	8b 00                	mov    (%eax),%eax
801087e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087ed:	83 ec 0c             	sub    $0xc,%esp
801087f0:	50                   	push   %eax
801087f1:	e8 08 f3 ff ff       	call   80107afe <p2v>
801087f6:	83 c4 10             	add    $0x10,%esp
}
801087f9:	c9                   	leave  
801087fa:	c3                   	ret    

801087fb <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801087fb:	55                   	push   %ebp
801087fc:	89 e5                	mov    %esp,%ebp
801087fe:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108801:	8b 45 10             	mov    0x10(%ebp),%eax
80108804:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108807:	eb 7f                	jmp    80108888 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010880c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108811:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108814:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108817:	83 ec 08             	sub    $0x8,%esp
8010881a:	50                   	push   %eax
8010881b:	ff 75 08             	pushl  0x8(%ebp)
8010881e:	e8 7e ff ff ff       	call   801087a1 <uva2ka>
80108823:	83 c4 10             	add    $0x10,%esp
80108826:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108829:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010882d:	75 07                	jne    80108836 <copyout+0x3b>
      return -1;
8010882f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108834:	eb 61                	jmp    80108897 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108836:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108839:	2b 45 0c             	sub    0xc(%ebp),%eax
8010883c:	05 00 10 00 00       	add    $0x1000,%eax
80108841:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108844:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108847:	3b 45 14             	cmp    0x14(%ebp),%eax
8010884a:	76 06                	jbe    80108852 <copyout+0x57>
      n = len;
8010884c:	8b 45 14             	mov    0x14(%ebp),%eax
8010884f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108852:	8b 45 0c             	mov    0xc(%ebp),%eax
80108855:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108858:	89 c2                	mov    %eax,%edx
8010885a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010885d:	01 d0                	add    %edx,%eax
8010885f:	83 ec 04             	sub    $0x4,%esp
80108862:	ff 75 f0             	pushl  -0x10(%ebp)
80108865:	ff 75 f4             	pushl  -0xc(%ebp)
80108868:	50                   	push   %eax
80108869:	e8 ff cb ff ff       	call   8010546d <memmove>
8010886e:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108871:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108874:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108877:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010887a:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010887d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108880:	05 00 10 00 00       	add    $0x1000,%eax
80108885:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108888:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010888c:	0f 85 77 ff ff ff    	jne    80108809 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108892:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108897:	c9                   	leave  
80108898:	c3                   	ret    

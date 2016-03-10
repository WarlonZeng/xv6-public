
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 4c 02 00 00       	call   262 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 d6 02 00 00       	call   2fa <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 3e 02 00 00       	call   26a <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	5b                   	pop    %ebx
  4e:	5f                   	pop    %edi
  4f:	5d                   	pop    %ebp
  50:	c3                   	ret    

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5d:	90                   	nop
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	8d 50 01             	lea    0x1(%eax),%edx
  64:	89 55 08             	mov    %edx,0x8(%ebp)
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  70:	8a 12                	mov    (%edx),%dl
  72:	88 10                	mov    %dl,(%eax)
  74:	8a 00                	mov    (%eax),%al
  76:	84 c0                	test   %al,%al
  78:	75 e4                	jne    5e <strcpy+0xd>
    ;
  return os;
  7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7d:	c9                   	leave  
  7e:	c3                   	ret    

0000007f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7f:	55                   	push   %ebp
  80:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  82:	eb 06                	jmp    8a <strcmp+0xb>
    p++, q++;
  84:	ff 45 08             	incl   0x8(%ebp)
  87:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8a:	8b 45 08             	mov    0x8(%ebp),%eax
  8d:	8a 00                	mov    (%eax),%al
  8f:	84 c0                	test   %al,%al
  91:	74 0e                	je     a1 <strcmp+0x22>
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	8a 10                	mov    (%eax),%dl
  98:	8b 45 0c             	mov    0xc(%ebp),%eax
  9b:	8a 00                	mov    (%eax),%al
  9d:	38 c2                	cmp    %al,%dl
  9f:	74 e3                	je     84 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	8a 00                	mov    (%eax),%al
  a6:	0f b6 d0             	movzbl %al,%edx
  a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  ac:	8a 00                	mov    (%eax),%al
  ae:	0f b6 c0             	movzbl %al,%eax
  b1:	29 c2                	sub    %eax,%edx
  b3:	89 d0                	mov    %edx,%eax
}
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    

000000b7 <strlen>:

uint
strlen(char *s)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c4:	eb 03                	jmp    c9 <strlen+0x12>
  c6:	ff 45 fc             	incl   -0x4(%ebp)
  c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	01 d0                	add    %edx,%eax
  d1:	8a 00                	mov    (%eax),%al
  d3:	84 c0                	test   %al,%al
  d5:	75 ef                	jne    c6 <strlen+0xf>
    ;
  return n;
  d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  da:	c9                   	leave  
  db:	c3                   	ret    

000000dc <memset>:

void*
memset(void *dst, int c, uint n)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  df:	8b 45 10             	mov    0x10(%ebp),%eax
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	pushl  0xc(%ebp)
  e6:	ff 75 08             	pushl  0x8(%ebp)
  e9:	e8 3e ff ff ff       	call   2c <stosb>
  ee:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f4:	c9                   	leave  
  f5:	c3                   	ret    

000000f6 <strchr>:

char*
strchr(const char *s, char c)
{
  f6:	55                   	push   %ebp
  f7:	89 e5                	mov    %esp,%ebp
  f9:	83 ec 04             	sub    $0x4,%esp
  fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  ff:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 102:	eb 12                	jmp    116 <strchr+0x20>
    if(*s == c)
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8a 00                	mov    (%eax),%al
 109:	3a 45 fc             	cmp    -0x4(%ebp),%al
 10c:	75 05                	jne    113 <strchr+0x1d>
      return (char*)s;
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	eb 11                	jmp    124 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 113:	ff 45 08             	incl   0x8(%ebp)
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	8a 00                	mov    (%eax),%al
 11b:	84 c0                	test   %al,%al
 11d:	75 e5                	jne    104 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 11f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 124:	c9                   	leave  
 125:	c3                   	ret    

00000126 <gets>:

char*
gets(char *buf, int max)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 133:	eb 41                	jmp    176 <gets+0x50>
    cc = read(0, &c, 1);
 135:	83 ec 04             	sub    $0x4,%esp
 138:	6a 01                	push   $0x1
 13a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13d:	50                   	push   %eax
 13e:	6a 00                	push   $0x0
 140:	e8 3d 01 00 00       	call   282 <read>
 145:	83 c4 10             	add    $0x10,%esp
 148:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14f:	7f 02                	jg     153 <gets+0x2d>
      break;
 151:	eb 2c                	jmp    17f <gets+0x59>
    buf[i++] = c;
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	8d 50 01             	lea    0x1(%eax),%edx
 159:	89 55 f4             	mov    %edx,-0xc(%ebp)
 15c:	89 c2                	mov    %eax,%edx
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	01 c2                	add    %eax,%edx
 163:	8a 45 ef             	mov    -0x11(%ebp),%al
 166:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 168:	8a 45 ef             	mov    -0x11(%ebp),%al
 16b:	3c 0a                	cmp    $0xa,%al
 16d:	74 10                	je     17f <gets+0x59>
 16f:	8a 45 ef             	mov    -0x11(%ebp),%al
 172:	3c 0d                	cmp    $0xd,%al
 174:	74 09                	je     17f <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	8b 45 f4             	mov    -0xc(%ebp),%eax
 179:	40                   	inc    %eax
 17a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 17d:	7c b6                	jl     135 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 17f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	01 d0                	add    %edx,%eax
 187:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18d:	c9                   	leave  
 18e:	c3                   	ret    

0000018f <stat>:

int
stat(char *n, struct stat *st)
{
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 195:	83 ec 08             	sub    $0x8,%esp
 198:	6a 00                	push   $0x0
 19a:	ff 75 08             	pushl  0x8(%ebp)
 19d:	e8 08 01 00 00       	call   2aa <open>
 1a2:	83 c4 10             	add    $0x10,%esp
 1a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ac:	79 07                	jns    1b5 <stat+0x26>
    return -1;
 1ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1b3:	eb 25                	jmp    1da <stat+0x4b>
  r = fstat(fd, st);
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	ff 75 0c             	pushl  0xc(%ebp)
 1bb:	ff 75 f4             	pushl  -0xc(%ebp)
 1be:	e8 ff 00 00 00       	call   2c2 <fstat>
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1c9:	83 ec 0c             	sub    $0xc,%esp
 1cc:	ff 75 f4             	pushl  -0xc(%ebp)
 1cf:	e8 be 00 00 00       	call   292 <close>
 1d4:	83 c4 10             	add    $0x10,%esp
  return r;
 1d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <atoi>:

int
atoi(const char *s)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1e9:	eb 24                	jmp    20f <atoi+0x33>
    n = n*10 + *s++ - '0';
 1eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ee:	89 d0                	mov    %edx,%eax
 1f0:	c1 e0 02             	shl    $0x2,%eax
 1f3:	01 d0                	add    %edx,%eax
 1f5:	01 c0                	add    %eax,%eax
 1f7:	89 c1                	mov    %eax,%ecx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	8d 50 01             	lea    0x1(%eax),%edx
 1ff:	89 55 08             	mov    %edx,0x8(%ebp)
 202:	8a 00                	mov    (%eax),%al
 204:	0f be c0             	movsbl %al,%eax
 207:	01 c8                	add    %ecx,%eax
 209:	83 e8 30             	sub    $0x30,%eax
 20c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	8a 00                	mov    (%eax),%al
 214:	3c 2f                	cmp    $0x2f,%al
 216:	7e 09                	jle    221 <atoi+0x45>
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	8a 00                	mov    (%eax),%al
 21d:	3c 39                	cmp    $0x39,%al
 21f:	7e ca                	jle    1eb <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 221:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 224:	c9                   	leave  
 225:	c3                   	ret    

00000226 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 232:	8b 45 0c             	mov    0xc(%ebp),%eax
 235:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 238:	eb 16                	jmp    250 <memmove+0x2a>
    *dst++ = *src++;
 23a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 23d:	8d 50 01             	lea    0x1(%eax),%edx
 240:	89 55 fc             	mov    %edx,-0x4(%ebp)
 243:	8b 55 f8             	mov    -0x8(%ebp),%edx
 246:	8d 4a 01             	lea    0x1(%edx),%ecx
 249:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 24c:	8a 12                	mov    (%edx),%dl
 24e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 250:	8b 45 10             	mov    0x10(%ebp),%eax
 253:	8d 50 ff             	lea    -0x1(%eax),%edx
 256:	89 55 10             	mov    %edx,0x10(%ebp)
 259:	85 c0                	test   %eax,%eax
 25b:	7f dd                	jg     23a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 260:	c9                   	leave  
 261:	c3                   	ret    

00000262 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 262:	b8 01 00 00 00       	mov    $0x1,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <exit>:
SYSCALL(exit)
 26a:	b8 02 00 00 00       	mov    $0x2,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <wait>:
SYSCALL(wait)
 272:	b8 03 00 00 00       	mov    $0x3,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <pipe>:
SYSCALL(pipe)
 27a:	b8 04 00 00 00       	mov    $0x4,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <read>:
SYSCALL(read)
 282:	b8 05 00 00 00       	mov    $0x5,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <write>:
SYSCALL(write)
 28a:	b8 10 00 00 00       	mov    $0x10,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <close>:
SYSCALL(close)
 292:	b8 15 00 00 00       	mov    $0x15,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <kill>:
SYSCALL(kill)
 29a:	b8 06 00 00 00       	mov    $0x6,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <exec>:
SYSCALL(exec)
 2a2:	b8 07 00 00 00       	mov    $0x7,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <open>:
SYSCALL(open)
 2aa:	b8 0f 00 00 00       	mov    $0xf,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <mknod>:
SYSCALL(mknod)
 2b2:	b8 11 00 00 00       	mov    $0x11,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <unlink>:
SYSCALL(unlink)
 2ba:	b8 12 00 00 00       	mov    $0x12,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <fstat>:
SYSCALL(fstat)
 2c2:	b8 08 00 00 00       	mov    $0x8,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <link>:
SYSCALL(link)
 2ca:	b8 13 00 00 00       	mov    $0x13,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <mkdir>:
SYSCALL(mkdir)
 2d2:	b8 14 00 00 00       	mov    $0x14,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <chdir>:
SYSCALL(chdir)
 2da:	b8 09 00 00 00       	mov    $0x9,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <dup>:
SYSCALL(dup)
 2e2:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <getpid>:
SYSCALL(getpid)
 2ea:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <sbrk>:
SYSCALL(sbrk)
 2f2:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <sleep>:
SYSCALL(sleep)
 2fa:	b8 0d 00 00 00       	mov    $0xd,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <uptime>:
SYSCALL(uptime)
 302:	b8 0e 00 00 00       	mov    $0xe,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <gettime>:
SYSCALL(gettime)
 30a:	b8 16 00 00 00       	mov    $0x16,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <settickets>:
SYSCALL(settickets)
 312:	b8 17 00 00 00       	mov    $0x17,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 31a:	55                   	push   %ebp
 31b:	89 e5                	mov    %esp,%ebp
 31d:	83 ec 18             	sub    $0x18,%esp
 320:	8b 45 0c             	mov    0xc(%ebp),%eax
 323:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 326:	83 ec 04             	sub    $0x4,%esp
 329:	6a 01                	push   $0x1
 32b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 32e:	50                   	push   %eax
 32f:	ff 75 08             	pushl  0x8(%ebp)
 332:	e8 53 ff ff ff       	call   28a <write>
 337:	83 c4 10             	add    $0x10,%esp
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	53                   	push   %ebx
 340:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 343:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 34a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 34e:	74 17                	je     367 <printint+0x2b>
 350:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 354:	79 11                	jns    367 <printint+0x2b>
    neg = 1;
 356:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 35d:	8b 45 0c             	mov    0xc(%ebp),%eax
 360:	f7 d8                	neg    %eax
 362:	89 45 ec             	mov    %eax,-0x14(%ebp)
 365:	eb 06                	jmp    36d <printint+0x31>
  } else {
    x = xx;
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 36d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 374:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 377:	8d 41 01             	lea    0x1(%ecx),%eax
 37a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 37d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 380:	8b 45 ec             	mov    -0x14(%ebp),%eax
 383:	ba 00 00 00 00       	mov    $0x0,%edx
 388:	f7 f3                	div    %ebx
 38a:	89 d0                	mov    %edx,%eax
 38c:	8a 80 8c 0a 00 00    	mov    0xa8c(%eax),%al
 392:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 396:	8b 5d 10             	mov    0x10(%ebp),%ebx
 399:	8b 45 ec             	mov    -0x14(%ebp),%eax
 39c:	ba 00 00 00 00       	mov    $0x0,%edx
 3a1:	f7 f3                	div    %ebx
 3a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3aa:	75 c8                	jne    374 <printint+0x38>
  if(neg)
 3ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3b0:	74 0e                	je     3c0 <printint+0x84>
    buf[i++] = '-';
 3b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b5:	8d 50 01             	lea    0x1(%eax),%edx
 3b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3bb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3c0:	eb 1c                	jmp    3de <printint+0xa2>
    putc(fd, buf[i]);
 3c2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c8:	01 d0                	add    %edx,%eax
 3ca:	8a 00                	mov    (%eax),%al
 3cc:	0f be c0             	movsbl %al,%eax
 3cf:	83 ec 08             	sub    $0x8,%esp
 3d2:	50                   	push   %eax
 3d3:	ff 75 08             	pushl  0x8(%ebp)
 3d6:	e8 3f ff ff ff       	call   31a <putc>
 3db:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3de:	ff 4d f4             	decl   -0xc(%ebp)
 3e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e5:	79 db                	jns    3c2 <printint+0x86>
    putc(fd, buf[i]);
}
 3e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 28             	sub    $0x28,%esp
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
 3f8:	8b 45 10             	mov    0x10(%ebp),%eax
 3fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 3fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
 401:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 404:	89 d0                	mov    %edx,%eax
 406:	31 d2                	xor    %edx,%edx
 408:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 40b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 40e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 415:	74 13                	je     42a <printlong+0x3e>
 417:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41a:	6a 00                	push   $0x0
 41c:	6a 10                	push   $0x10
 41e:	50                   	push   %eax
 41f:	ff 75 08             	pushl  0x8(%ebp)
 422:	e8 15 ff ff ff       	call   33c <printint>
 427:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 42a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 42d:	6a 00                	push   $0x0
 42f:	6a 10                	push   $0x10
 431:	50                   	push   %eax
 432:	ff 75 08             	pushl  0x8(%ebp)
 435:	e8 02 ff ff ff       	call   33c <printint>
 43a:	83 c4 10             	add    $0x10,%esp
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 445:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44c:	8d 45 0c             	lea    0xc(%ebp),%eax
 44f:	83 c0 04             	add    $0x4,%eax
 452:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 455:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45c:	e9 83 01 00 00       	jmp    5e4 <printf+0x1a5>
    c = fmt[i] & 0xff;
 461:	8b 55 0c             	mov    0xc(%ebp),%edx
 464:	8b 45 f0             	mov    -0x10(%ebp),%eax
 467:	01 d0                	add    %edx,%eax
 469:	8a 00                	mov    (%eax),%al
 46b:	0f be c0             	movsbl %al,%eax
 46e:	25 ff 00 00 00       	and    $0xff,%eax
 473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 476:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47a:	75 2c                	jne    4a8 <printf+0x69>
      if(c == '%'){
 47c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 480:	75 0c                	jne    48e <printf+0x4f>
        state = '%';
 482:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 489:	e9 53 01 00 00       	jmp    5e1 <printf+0x1a2>
      } else {
        putc(fd, c);
 48e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 491:	0f be c0             	movsbl %al,%eax
 494:	83 ec 08             	sub    $0x8,%esp
 497:	50                   	push   %eax
 498:	ff 75 08             	pushl  0x8(%ebp)
 49b:	e8 7a fe ff ff       	call   31a <putc>
 4a0:	83 c4 10             	add    $0x10,%esp
 4a3:	e9 39 01 00 00       	jmp    5e1 <printf+0x1a2>
      }
    } else if(state == '%'){
 4a8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ac:	0f 85 2f 01 00 00    	jne    5e1 <printf+0x1a2>
      if(c == 'd'){
 4b2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b6:	75 1e                	jne    4d6 <printf+0x97>
        printint(fd, *ap, 10, 1);
 4b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bb:	8b 00                	mov    (%eax),%eax
 4bd:	6a 01                	push   $0x1
 4bf:	6a 0a                	push   $0xa
 4c1:	50                   	push   %eax
 4c2:	ff 75 08             	pushl  0x8(%ebp)
 4c5:	e8 72 fe ff ff       	call   33c <printint>
 4ca:	83 c4 10             	add    $0x10,%esp
        ap++;
 4cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d1:	e9 04 01 00 00       	jmp    5da <printf+0x19b>
      } else if(c == 'l') {
 4d6:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 4da:	75 29                	jne    505 <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 4dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4df:	8b 50 04             	mov    0x4(%eax),%edx
 4e2:	8b 00                	mov    (%eax),%eax
 4e4:	83 ec 0c             	sub    $0xc,%esp
 4e7:	6a 00                	push   $0x0
 4e9:	6a 0a                	push   $0xa
 4eb:	52                   	push   %edx
 4ec:	50                   	push   %eax
 4ed:	ff 75 08             	pushl  0x8(%ebp)
 4f0:	e8 f7 fe ff ff       	call   3ec <printlong>
 4f5:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 4f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 4fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 500:	e9 d5 00 00 00       	jmp    5da <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 505:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 509:	74 06                	je     511 <printf+0xd2>
 50b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 50f:	75 1e                	jne    52f <printf+0xf0>
        printint(fd, *ap, 16, 0);
 511:	8b 45 e8             	mov    -0x18(%ebp),%eax
 514:	8b 00                	mov    (%eax),%eax
 516:	6a 00                	push   $0x0
 518:	6a 10                	push   $0x10
 51a:	50                   	push   %eax
 51b:	ff 75 08             	pushl  0x8(%ebp)
 51e:	e8 19 fe ff ff       	call   33c <printint>
 523:	83 c4 10             	add    $0x10,%esp
        ap++;
 526:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52a:	e9 ab 00 00 00       	jmp    5da <printf+0x19b>
      } else if(c == 's'){
 52f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 533:	75 40                	jne    575 <printf+0x136>
        s = (char*)*ap;
 535:	8b 45 e8             	mov    -0x18(%ebp),%eax
 538:	8b 00                	mov    (%eax),%eax
 53a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 545:	75 07                	jne    54e <printf+0x10f>
          s = "(null)";
 547:	c7 45 f4 1a 08 00 00 	movl   $0x81a,-0xc(%ebp)
        while(*s != 0){
 54e:	eb 1a                	jmp    56a <printf+0x12b>
          putc(fd, *s);
 550:	8b 45 f4             	mov    -0xc(%ebp),%eax
 553:	8a 00                	mov    (%eax),%al
 555:	0f be c0             	movsbl %al,%eax
 558:	83 ec 08             	sub    $0x8,%esp
 55b:	50                   	push   %eax
 55c:	ff 75 08             	pushl  0x8(%ebp)
 55f:	e8 b6 fd ff ff       	call   31a <putc>
 564:	83 c4 10             	add    $0x10,%esp
          s++;
 567:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56d:	8a 00                	mov    (%eax),%al
 56f:	84 c0                	test   %al,%al
 571:	75 dd                	jne    550 <printf+0x111>
 573:	eb 65                	jmp    5da <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 575:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 579:	75 1d                	jne    598 <printf+0x159>
        putc(fd, *ap);
 57b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57e:	8b 00                	mov    (%eax),%eax
 580:	0f be c0             	movsbl %al,%eax
 583:	83 ec 08             	sub    $0x8,%esp
 586:	50                   	push   %eax
 587:	ff 75 08             	pushl  0x8(%ebp)
 58a:	e8 8b fd ff ff       	call   31a <putc>
 58f:	83 c4 10             	add    $0x10,%esp
        ap++;
 592:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 596:	eb 42                	jmp    5da <printf+0x19b>
      } else if(c == '%'){
 598:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59c:	75 17                	jne    5b5 <printf+0x176>
        putc(fd, c);
 59e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	83 ec 08             	sub    $0x8,%esp
 5a7:	50                   	push   %eax
 5a8:	ff 75 08             	pushl  0x8(%ebp)
 5ab:	e8 6a fd ff ff       	call   31a <putc>
 5b0:	83 c4 10             	add    $0x10,%esp
 5b3:	eb 25                	jmp    5da <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b5:	83 ec 08             	sub    $0x8,%esp
 5b8:	6a 25                	push   $0x25
 5ba:	ff 75 08             	pushl  0x8(%ebp)
 5bd:	e8 58 fd ff ff       	call   31a <putc>
 5c2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	83 ec 08             	sub    $0x8,%esp
 5ce:	50                   	push   %eax
 5cf:	ff 75 08             	pushl  0x8(%ebp)
 5d2:	e8 43 fd ff ff       	call   31a <putc>
 5d7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e1:	ff 45 f0             	incl   -0x10(%ebp)
 5e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ea:	01 d0                	add    %edx,%eax
 5ec:	8a 00                	mov    (%eax),%al
 5ee:	84 c0                	test   %al,%al
 5f0:	0f 85 6b fe ff ff    	jne    461 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f6:	c9                   	leave  
 5f7:	c3                   	ret    

000005f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f8:	55                   	push   %ebp
 5f9:	89 e5                	mov    %esp,%ebp
 5fb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	83 e8 08             	sub    $0x8,%eax
 604:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 607:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 60c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60f:	eb 24                	jmp    635 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 619:	77 12                	ja     62d <free+0x35>
 61b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 621:	77 24                	ja     647 <free+0x4f>
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62b:	77 1a                	ja     647 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	89 45 fc             	mov    %eax,-0x4(%ebp)
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63b:	76 d4                	jbe    611 <free+0x19>
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 645:	76 ca                	jbe    611 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	8b 40 04             	mov    0x4(%eax),%eax
 64d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	01 c2                	add    %eax,%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	39 c2                	cmp    %eax,%edx
 660:	75 24                	jne    686 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	8b 40 04             	mov    0x4(%eax),%eax
 670:	01 c2                	add    %eax,%edx
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	8b 10                	mov    (%eax),%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	89 10                	mov    %edx,(%eax)
 684:	eb 0a                	jmp    690 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 40 04             	mov    0x4(%eax),%eax
 696:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	01 d0                	add    %edx,%eax
 6a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a5:	75 20                	jne    6c7 <free+0xcf>
    p->s.size += bp->s.size;
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 50 04             	mov    0x4(%eax),%edx
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	8b 40 04             	mov    0x4(%eax),%eax
 6b3:	01 c2                	add    %eax,%edx
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	8b 10                	mov    (%eax),%edx
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	89 10                	mov    %edx,(%eax)
 6c5:	eb 08                	jmp    6cf <free+0xd7>
  } else
    p->s.ptr = bp;
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6cd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	a3 a8 0a 00 00       	mov    %eax,0xaa8
}
 6d7:	c9                   	leave  
 6d8:	c3                   	ret    

000006d9 <morecore>:

static Header*
morecore(uint nu)
{
 6d9:	55                   	push   %ebp
 6da:	89 e5                	mov    %esp,%ebp
 6dc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6df:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e6:	77 07                	ja     6ef <morecore+0x16>
    nu = 4096;
 6e8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	c1 e0 03             	shl    $0x3,%eax
 6f5:	83 ec 0c             	sub    $0xc,%esp
 6f8:	50                   	push   %eax
 6f9:	e8 f4 fb ff ff       	call   2f2 <sbrk>
 6fe:	83 c4 10             	add    $0x10,%esp
 701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 704:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 708:	75 07                	jne    711 <morecore+0x38>
    return 0;
 70a:	b8 00 00 00 00       	mov    $0x0,%eax
 70f:	eb 26                	jmp    737 <morecore+0x5e>
  hp = (Header*)p;
 711:	8b 45 f4             	mov    -0xc(%ebp),%eax
 714:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 717:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71a:	8b 55 08             	mov    0x8(%ebp),%edx
 71d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 720:	8b 45 f0             	mov    -0x10(%ebp),%eax
 723:	83 c0 08             	add    $0x8,%eax
 726:	83 ec 0c             	sub    $0xc,%esp
 729:	50                   	push   %eax
 72a:	e8 c9 fe ff ff       	call   5f8 <free>
 72f:	83 c4 10             	add    $0x10,%esp
  return freep;
 732:	a1 a8 0a 00 00       	mov    0xaa8,%eax
}
 737:	c9                   	leave  
 738:	c3                   	ret    

00000739 <malloc>:

void*
malloc(uint nbytes)
{
 739:	55                   	push   %ebp
 73a:	89 e5                	mov    %esp,%ebp
 73c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73f:	8b 45 08             	mov    0x8(%ebp),%eax
 742:	83 c0 07             	add    $0x7,%eax
 745:	c1 e8 03             	shr    $0x3,%eax
 748:	40                   	inc    %eax
 749:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 74c:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 751:	89 45 f0             	mov    %eax,-0x10(%ebp)
 754:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 758:	75 23                	jne    77d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 75a:	c7 45 f0 a0 0a 00 00 	movl   $0xaa0,-0x10(%ebp)
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	a3 a8 0a 00 00       	mov    %eax,0xaa8
 769:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 76e:	a3 a0 0a 00 00       	mov    %eax,0xaa0
    base.s.size = 0;
 773:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 77a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	8b 00                	mov    (%eax),%eax
 782:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78e:	72 4d                	jb     7dd <malloc+0xa4>
      if(p->s.size == nunits)
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 799:	75 0c                	jne    7a7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 10                	mov    (%eax),%edx
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	89 10                	mov    %edx,(%eax)
 7a5:	eb 26                	jmp    7cd <malloc+0x94>
      else {
        p->s.size -= nunits;
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7b0:	89 c2                	mov    %eax,%edx
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 40 04             	mov    0x4(%eax),%eax
 7be:	c1 e0 03             	shl    $0x3,%eax
 7c1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ca:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	a3 a8 0a 00 00       	mov    %eax,0xaa8
      return (void*)(p + 1);
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	83 c0 08             	add    $0x8,%eax
 7db:	eb 3b                	jmp    818 <malloc+0xdf>
    }
    if(p == freep)
 7dd:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 7e2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7e5:	75 1e                	jne    805 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 7e7:	83 ec 0c             	sub    $0xc,%esp
 7ea:	ff 75 ec             	pushl  -0x14(%ebp)
 7ed:	e8 e7 fe ff ff       	call   6d9 <morecore>
 7f2:	83 c4 10             	add    $0x10,%esp
 7f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fc:	75 07                	jne    805 <malloc+0xcc>
        return 0;
 7fe:	b8 00 00 00 00       	mov    $0x0,%eax
 803:	eb 13                	jmp    818 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 00                	mov    (%eax),%eax
 810:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 813:	e9 6d ff ff ff       	jmp    785 <malloc+0x4c>
}
 818:	c9                   	leave  
 819:	c3                   	ret    

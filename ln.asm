
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 62 08 00 00       	push   $0x862
  1e:	6a 02                	push   $0x2
  20:	e8 62 04 00 00       	call   487 <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 85 02 00 00       	call   2b2 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 cb 02 00 00       	call   312 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 75 08 00 00       	push   $0x875
  65:	6a 02                	push   $0x2
  67:	e8 1b 04 00 00       	call   487 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 3e 02 00 00       	call   2b2 <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	5b                   	pop    %ebx
  96:	5f                   	pop    %edi
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    

00000099 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a5:	90                   	nop
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	8d 50 01             	lea    0x1(%eax),%edx
  ac:	89 55 08             	mov    %edx,0x8(%ebp)
  af:	8b 55 0c             	mov    0xc(%ebp),%edx
  b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  b5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b8:	8a 12                	mov    (%edx),%dl
  ba:	88 10                	mov    %dl,(%eax)
  bc:	8a 00                	mov    (%eax),%al
  be:	84 c0                	test   %al,%al
  c0:	75 e4                	jne    a6 <strcpy+0xd>
    ;
  return os;
  c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c5:	c9                   	leave  
  c6:	c3                   	ret    

000000c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ca:	eb 06                	jmp    d2 <strcmp+0xb>
    p++, q++;
  cc:	ff 45 08             	incl   0x8(%ebp)
  cf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	8a 00                	mov    (%eax),%al
  d7:	84 c0                	test   %al,%al
  d9:	74 0e                	je     e9 <strcmp+0x22>
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	8a 10                	mov    (%eax),%dl
  e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  e3:	8a 00                	mov    (%eax),%al
  e5:	38 c2                	cmp    %al,%dl
  e7:	74 e3                	je     cc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	8a 00                	mov    (%eax),%al
  ee:	0f b6 d0             	movzbl %al,%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	8a 00                	mov    (%eax),%al
  f6:	0f b6 c0             	movzbl %al,%eax
  f9:	29 c2                	sub    %eax,%edx
  fb:	89 d0                	mov    %edx,%eax
}
  fd:	5d                   	pop    %ebp
  fe:	c3                   	ret    

000000ff <strlen>:

uint
strlen(char *s)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 105:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10c:	eb 03                	jmp    111 <strlen+0x12>
 10e:	ff 45 fc             	incl   -0x4(%ebp)
 111:	8b 55 fc             	mov    -0x4(%ebp),%edx
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	01 d0                	add    %edx,%eax
 119:	8a 00                	mov    (%eax),%al
 11b:	84 c0                	test   %al,%al
 11d:	75 ef                	jne    10e <strlen+0xf>
    ;
  return n;
 11f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 122:	c9                   	leave  
 123:	c3                   	ret    

00000124 <memset>:

void*
memset(void *dst, int c, uint n)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 127:	8b 45 10             	mov    0x10(%ebp),%eax
 12a:	50                   	push   %eax
 12b:	ff 75 0c             	pushl  0xc(%ebp)
 12e:	ff 75 08             	pushl  0x8(%ebp)
 131:	e8 3e ff ff ff       	call   74 <stosb>
 136:	83 c4 0c             	add    $0xc,%esp
  return dst;
 139:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <strchr>:

char*
strchr(const char *s, char c)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	83 ec 04             	sub    $0x4,%esp
 144:	8b 45 0c             	mov    0xc(%ebp),%eax
 147:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14a:	eb 12                	jmp    15e <strchr+0x20>
    if(*s == c)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	8a 00                	mov    (%eax),%al
 151:	3a 45 fc             	cmp    -0x4(%ebp),%al
 154:	75 05                	jne    15b <strchr+0x1d>
      return (char*)s;
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	eb 11                	jmp    16c <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 15b:	ff 45 08             	incl   0x8(%ebp)
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	8a 00                	mov    (%eax),%al
 163:	84 c0                	test   %al,%al
 165:	75 e5                	jne    14c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 41                	jmp    1be <gets+0x50>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 3d 01 00 00       	call   2ca <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7f 02                	jg     19b <gets+0x2d>
      break;
 199:	eb 2c                	jmp    1c7 <gets+0x59>
    buf[i++] = c;
 19b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19e:	8d 50 01             	lea    0x1(%eax),%edx
 1a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a4:	89 c2                	mov    %eax,%edx
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	01 c2                	add    %eax,%edx
 1ab:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ae:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b0:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 10                	je     1c7 <gets+0x59>
 1b7:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ba:	3c 0d                	cmp    $0xd,%al
 1bc:	74 09                	je     1c7 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c1:	40                   	inc    %eax
 1c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c5:	7c b6                	jl     17d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	01 d0                	add    %edx,%eax
 1cf:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <stat>:

int
stat(char *n, struct stat *st)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1dd:	83 ec 08             	sub    $0x8,%esp
 1e0:	6a 00                	push   $0x0
 1e2:	ff 75 08             	pushl  0x8(%ebp)
 1e5:	e8 08 01 00 00       	call   2f2 <open>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f4:	79 07                	jns    1fd <stat+0x26>
    return -1;
 1f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1fb:	eb 25                	jmp    222 <stat+0x4b>
  r = fstat(fd, st);
 1fd:	83 ec 08             	sub    $0x8,%esp
 200:	ff 75 0c             	pushl  0xc(%ebp)
 203:	ff 75 f4             	pushl  -0xc(%ebp)
 206:	e8 ff 00 00 00       	call   30a <fstat>
 20b:	83 c4 10             	add    $0x10,%esp
 20e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 211:	83 ec 0c             	sub    $0xc,%esp
 214:	ff 75 f4             	pushl  -0xc(%ebp)
 217:	e8 be 00 00 00       	call   2da <close>
 21c:	83 c4 10             	add    $0x10,%esp
  return r;
 21f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 222:	c9                   	leave  
 223:	c3                   	ret    

00000224 <atoi>:

int
atoi(const char *s)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 22a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 231:	eb 24                	jmp    257 <atoi+0x33>
    n = n*10 + *s++ - '0';
 233:	8b 55 fc             	mov    -0x4(%ebp),%edx
 236:	89 d0                	mov    %edx,%eax
 238:	c1 e0 02             	shl    $0x2,%eax
 23b:	01 d0                	add    %edx,%eax
 23d:	01 c0                	add    %eax,%eax
 23f:	89 c1                	mov    %eax,%ecx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	8d 50 01             	lea    0x1(%eax),%edx
 247:	89 55 08             	mov    %edx,0x8(%ebp)
 24a:	8a 00                	mov    (%eax),%al
 24c:	0f be c0             	movsbl %al,%eax
 24f:	01 c8                	add    %ecx,%eax
 251:	83 e8 30             	sub    $0x30,%eax
 254:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	8a 00                	mov    (%eax),%al
 25c:	3c 2f                	cmp    $0x2f,%al
 25e:	7e 09                	jle    269 <atoi+0x45>
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	8a 00                	mov    (%eax),%al
 265:	3c 39                	cmp    $0x39,%al
 267:	7e ca                	jle    233 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 269:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 27a:	8b 45 0c             	mov    0xc(%ebp),%eax
 27d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 280:	eb 16                	jmp    298 <memmove+0x2a>
    *dst++ = *src++;
 282:	8b 45 fc             	mov    -0x4(%ebp),%eax
 285:	8d 50 01             	lea    0x1(%eax),%edx
 288:	89 55 fc             	mov    %edx,-0x4(%ebp)
 28b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 28e:	8d 4a 01             	lea    0x1(%edx),%ecx
 291:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 294:	8a 12                	mov    (%edx),%dl
 296:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 298:	8b 45 10             	mov    0x10(%ebp),%eax
 29b:	8d 50 ff             	lea    -0x1(%eax),%edx
 29e:	89 55 10             	mov    %edx,0x10(%ebp)
 2a1:	85 c0                	test   %eax,%eax
 2a3:	7f dd                	jg     282 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a8:	c9                   	leave  
 2a9:	c3                   	ret    

000002aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2aa:	b8 01 00 00 00       	mov    $0x1,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <exit>:
SYSCALL(exit)
 2b2:	b8 02 00 00 00       	mov    $0x2,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <wait>:
SYSCALL(wait)
 2ba:	b8 03 00 00 00       	mov    $0x3,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <pipe>:
SYSCALL(pipe)
 2c2:	b8 04 00 00 00       	mov    $0x4,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <read>:
SYSCALL(read)
 2ca:	b8 05 00 00 00       	mov    $0x5,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <write>:
SYSCALL(write)
 2d2:	b8 10 00 00 00       	mov    $0x10,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <close>:
SYSCALL(close)
 2da:	b8 15 00 00 00       	mov    $0x15,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <kill>:
SYSCALL(kill)
 2e2:	b8 06 00 00 00       	mov    $0x6,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <exec>:
SYSCALL(exec)
 2ea:	b8 07 00 00 00       	mov    $0x7,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <open>:
SYSCALL(open)
 2f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <mknod>:
SYSCALL(mknod)
 2fa:	b8 11 00 00 00       	mov    $0x11,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <unlink>:
SYSCALL(unlink)
 302:	b8 12 00 00 00       	mov    $0x12,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <fstat>:
SYSCALL(fstat)
 30a:	b8 08 00 00 00       	mov    $0x8,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <link>:
SYSCALL(link)
 312:	b8 13 00 00 00       	mov    $0x13,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mkdir>:
SYSCALL(mkdir)
 31a:	b8 14 00 00 00       	mov    $0x14,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <chdir>:
SYSCALL(chdir)
 322:	b8 09 00 00 00       	mov    $0x9,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <dup>:
SYSCALL(dup)
 32a:	b8 0a 00 00 00       	mov    $0xa,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <getpid>:
SYSCALL(getpid)
 332:	b8 0b 00 00 00       	mov    $0xb,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sbrk>:
SYSCALL(sbrk)
 33a:	b8 0c 00 00 00       	mov    $0xc,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sleep>:
SYSCALL(sleep)
 342:	b8 0d 00 00 00       	mov    $0xd,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <uptime>:
SYSCALL(uptime)
 34a:	b8 0e 00 00 00       	mov    $0xe,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <gettime>:
SYSCALL(gettime)
 352:	b8 16 00 00 00       	mov    $0x16,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <settickets>:
SYSCALL(settickets)
 35a:	b8 17 00 00 00       	mov    $0x17,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 18             	sub    $0x18,%esp
 368:	8b 45 0c             	mov    0xc(%ebp),%eax
 36b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36e:	83 ec 04             	sub    $0x4,%esp
 371:	6a 01                	push   $0x1
 373:	8d 45 f4             	lea    -0xc(%ebp),%eax
 376:	50                   	push   %eax
 377:	ff 75 08             	pushl  0x8(%ebp)
 37a:	e8 53 ff ff ff       	call   2d2 <write>
 37f:	83 c4 10             	add    $0x10,%esp
}
 382:	c9                   	leave  
 383:	c3                   	ret    

00000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	53                   	push   %ebx
 388:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 392:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 396:	74 17                	je     3af <printint+0x2b>
 398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39c:	79 11                	jns    3af <printint+0x2b>
    neg = 1;
 39e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a8:	f7 d8                	neg    %eax
 3aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ad:	eb 06                	jmp    3b5 <printint+0x31>
  } else {
    x = xx;
 3af:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3bf:	8d 41 01             	lea    0x1(%ecx),%eax
 3c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cb:	ba 00 00 00 00       	mov    $0x0,%edx
 3d0:	f7 f3                	div    %ebx
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	8a 80 fc 0a 00 00    	mov    0xafc(%eax),%al
 3da:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3de:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e4:	ba 00 00 00 00       	mov    $0x0,%edx
 3e9:	f7 f3                	div    %ebx
 3eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f2:	75 c8                	jne    3bc <printint+0x38>
  if(neg)
 3f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f8:	74 0e                	je     408 <printint+0x84>
    buf[i++] = '-';
 3fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fd:	8d 50 01             	lea    0x1(%eax),%edx
 400:	89 55 f4             	mov    %edx,-0xc(%ebp)
 403:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 408:	eb 1c                	jmp    426 <printint+0xa2>
    putc(fd, buf[i]);
 40a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 410:	01 d0                	add    %edx,%eax
 412:	8a 00                	mov    (%eax),%al
 414:	0f be c0             	movsbl %al,%eax
 417:	83 ec 08             	sub    $0x8,%esp
 41a:	50                   	push   %eax
 41b:	ff 75 08             	pushl  0x8(%ebp)
 41e:	e8 3f ff ff ff       	call   362 <putc>
 423:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 426:	ff 4d f4             	decl   -0xc(%ebp)
 429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42d:	79 db                	jns    40a <printint+0x86>
    putc(fd, buf[i]);
}
 42f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 28             	sub    $0x28,%esp
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 440:	8b 45 10             	mov    0x10(%ebp),%eax
 443:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 446:	8b 45 e0             	mov    -0x20(%ebp),%eax
 449:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 44c:	89 d0                	mov    %edx,%eax
 44e:	31 d2                	xor    %edx,%edx
 450:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 453:	8b 45 e0             	mov    -0x20(%ebp),%eax
 456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45d:	74 13                	je     472 <printlong+0x3e>
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	6a 00                	push   $0x0
 464:	6a 10                	push   $0x10
 466:	50                   	push   %eax
 467:	ff 75 08             	pushl  0x8(%ebp)
 46a:	e8 15 ff ff ff       	call   384 <printint>
 46f:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 472:	8b 45 f0             	mov    -0x10(%ebp),%eax
 475:	6a 00                	push   $0x0
 477:	6a 10                	push   $0x10
 479:	50                   	push   %eax
 47a:	ff 75 08             	pushl  0x8(%ebp)
 47d:	e8 02 ff ff ff       	call   384 <printint>
 482:	83 c4 10             	add    $0x10,%esp
}
 485:	c9                   	leave  
 486:	c3                   	ret    

00000487 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 487:	55                   	push   %ebp
 488:	89 e5                	mov    %esp,%ebp
 48a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 494:	8d 45 0c             	lea    0xc(%ebp),%eax
 497:	83 c0 04             	add    $0x4,%eax
 49a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a4:	e9 83 01 00 00       	jmp    62c <printf+0x1a5>
    c = fmt[i] & 0xff;
 4a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4af:	01 d0                	add    %edx,%eax
 4b1:	8a 00                	mov    (%eax),%al
 4b3:	0f be c0             	movsbl %al,%eax
 4b6:	25 ff 00 00 00       	and    $0xff,%eax
 4bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c2:	75 2c                	jne    4f0 <printf+0x69>
      if(c == '%'){
 4c4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c8:	75 0c                	jne    4d6 <printf+0x4f>
        state = '%';
 4ca:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d1:	e9 53 01 00 00       	jmp    629 <printf+0x1a2>
      } else {
        putc(fd, c);
 4d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d9:	0f be c0             	movsbl %al,%eax
 4dc:	83 ec 08             	sub    $0x8,%esp
 4df:	50                   	push   %eax
 4e0:	ff 75 08             	pushl  0x8(%ebp)
 4e3:	e8 7a fe ff ff       	call   362 <putc>
 4e8:	83 c4 10             	add    $0x10,%esp
 4eb:	e9 39 01 00 00       	jmp    629 <printf+0x1a2>
      }
    } else if(state == '%'){
 4f0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f4:	0f 85 2f 01 00 00    	jne    629 <printf+0x1a2>
      if(c == 'd'){
 4fa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fe:	75 1e                	jne    51e <printf+0x97>
        printint(fd, *ap, 10, 1);
 500:	8b 45 e8             	mov    -0x18(%ebp),%eax
 503:	8b 00                	mov    (%eax),%eax
 505:	6a 01                	push   $0x1
 507:	6a 0a                	push   $0xa
 509:	50                   	push   %eax
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 72 fe ff ff       	call   384 <printint>
 512:	83 c4 10             	add    $0x10,%esp
        ap++;
 515:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 519:	e9 04 01 00 00       	jmp    622 <printf+0x19b>
      } else if(c == 'l') {
 51e:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 522:	75 29                	jne    54d <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 524:	8b 45 e8             	mov    -0x18(%ebp),%eax
 527:	8b 50 04             	mov    0x4(%eax),%edx
 52a:	8b 00                	mov    (%eax),%eax
 52c:	83 ec 0c             	sub    $0xc,%esp
 52f:	6a 00                	push   $0x0
 531:	6a 0a                	push   $0xa
 533:	52                   	push   %edx
 534:	50                   	push   %eax
 535:	ff 75 08             	pushl  0x8(%ebp)
 538:	e8 f7 fe ff ff       	call   434 <printlong>
 53d:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 540:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 544:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 548:	e9 d5 00 00 00       	jmp    622 <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 54d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 551:	74 06                	je     559 <printf+0xd2>
 553:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 557:	75 1e                	jne    577 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 559:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55c:	8b 00                	mov    (%eax),%eax
 55e:	6a 00                	push   $0x0
 560:	6a 10                	push   $0x10
 562:	50                   	push   %eax
 563:	ff 75 08             	pushl  0x8(%ebp)
 566:	e8 19 fe ff ff       	call   384 <printint>
 56b:	83 c4 10             	add    $0x10,%esp
        ap++;
 56e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 572:	e9 ab 00 00 00       	jmp    622 <printf+0x19b>
      } else if(c == 's'){
 577:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 57b:	75 40                	jne    5bd <printf+0x136>
        s = (char*)*ap;
 57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 580:	8b 00                	mov    (%eax),%eax
 582:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58d:	75 07                	jne    596 <printf+0x10f>
          s = "(null)";
 58f:	c7 45 f4 89 08 00 00 	movl   $0x889,-0xc(%ebp)
        while(*s != 0){
 596:	eb 1a                	jmp    5b2 <printf+0x12b>
          putc(fd, *s);
 598:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59b:	8a 00                	mov    (%eax),%al
 59d:	0f be c0             	movsbl %al,%eax
 5a0:	83 ec 08             	sub    $0x8,%esp
 5a3:	50                   	push   %eax
 5a4:	ff 75 08             	pushl  0x8(%ebp)
 5a7:	e8 b6 fd ff ff       	call   362 <putc>
 5ac:	83 c4 10             	add    $0x10,%esp
          s++;
 5af:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b5:	8a 00                	mov    (%eax),%al
 5b7:	84 c0                	test   %al,%al
 5b9:	75 dd                	jne    598 <printf+0x111>
 5bb:	eb 65                	jmp    622 <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5bd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c1:	75 1d                	jne    5e0 <printf+0x159>
        putc(fd, *ap);
 5c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c6:	8b 00                	mov    (%eax),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	83 ec 08             	sub    $0x8,%esp
 5ce:	50                   	push   %eax
 5cf:	ff 75 08             	pushl  0x8(%ebp)
 5d2:	e8 8b fd ff ff       	call   362 <putc>
 5d7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5de:	eb 42                	jmp    622 <printf+0x19b>
      } else if(c == '%'){
 5e0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e4:	75 17                	jne    5fd <printf+0x176>
        putc(fd, c);
 5e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e9:	0f be c0             	movsbl %al,%eax
 5ec:	83 ec 08             	sub    $0x8,%esp
 5ef:	50                   	push   %eax
 5f0:	ff 75 08             	pushl  0x8(%ebp)
 5f3:	e8 6a fd ff ff       	call   362 <putc>
 5f8:	83 c4 10             	add    $0x10,%esp
 5fb:	eb 25                	jmp    622 <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fd:	83 ec 08             	sub    $0x8,%esp
 600:	6a 25                	push   $0x25
 602:	ff 75 08             	pushl  0x8(%ebp)
 605:	e8 58 fd ff ff       	call   362 <putc>
 60a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	83 ec 08             	sub    $0x8,%esp
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 43 fd ff ff       	call   362 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 622:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 629:	ff 45 f0             	incl   -0x10(%ebp)
 62c:	8b 55 0c             	mov    0xc(%ebp),%edx
 62f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 632:	01 d0                	add    %edx,%eax
 634:	8a 00                	mov    (%eax),%al
 636:	84 c0                	test   %al,%al
 638:	0f 85 6b fe ff ff    	jne    4a9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 63e:	c9                   	leave  
 63f:	c3                   	ret    

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 646:	8b 45 08             	mov    0x8(%ebp),%eax
 649:	83 e8 08             	sub    $0x8,%eax
 64c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64f:	a1 18 0b 00 00       	mov    0xb18,%eax
 654:	89 45 fc             	mov    %eax,-0x4(%ebp)
 657:	eb 24                	jmp    67d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	77 12                	ja     675 <free+0x35>
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 669:	77 24                	ja     68f <free+0x4f>
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 673:	77 1a                	ja     68f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 683:	76 d4                	jbe    659 <free+0x19>
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68d:	76 ca                	jbe    659 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	39 c2                	cmp    %eax,%edx
 6a8:	75 24                	jne    6ce <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 50 04             	mov    0x4(%eax),%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	8b 40 04             	mov    0x4(%eax),%eax
 6b8:	01 c2                	add    %eax,%edx
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	8b 10                	mov    (%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 10                	mov    %edx,(%eax)
 6cc:	eb 0a                	jmp    6d8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	01 d0                	add    %edx,%eax
 6ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ed:	75 20                	jne    70f <free+0xcf>
    p->s.size += bp->s.size;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 50 04             	mov    0x4(%eax),%edx
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	8b 40 04             	mov    0x4(%eax),%eax
 6fb:	01 c2                	add    %eax,%edx
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	8b 10                	mov    (%eax),%edx
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	89 10                	mov    %edx,(%eax)
 70d:	eb 08                	jmp    717 <free+0xd7>
  } else
    p->s.ptr = bp;
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 55 f8             	mov    -0x8(%ebp),%edx
 715:	89 10                	mov    %edx,(%eax)
  freep = p;
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	a3 18 0b 00 00       	mov    %eax,0xb18
}
 71f:	c9                   	leave  
 720:	c3                   	ret    

00000721 <morecore>:

static Header*
morecore(uint nu)
{
 721:	55                   	push   %ebp
 722:	89 e5                	mov    %esp,%ebp
 724:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 727:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72e:	77 07                	ja     737 <morecore+0x16>
    nu = 4096;
 730:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	c1 e0 03             	shl    $0x3,%eax
 73d:	83 ec 0c             	sub    $0xc,%esp
 740:	50                   	push   %eax
 741:	e8 f4 fb ff ff       	call   33a <sbrk>
 746:	83 c4 10             	add    $0x10,%esp
 749:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 74c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 750:	75 07                	jne    759 <morecore+0x38>
    return 0;
 752:	b8 00 00 00 00       	mov    $0x0,%eax
 757:	eb 26                	jmp    77f <morecore+0x5e>
  hp = (Header*)p;
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 75f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 762:	8b 55 08             	mov    0x8(%ebp),%edx
 765:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 768:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76b:	83 c0 08             	add    $0x8,%eax
 76e:	83 ec 0c             	sub    $0xc,%esp
 771:	50                   	push   %eax
 772:	e8 c9 fe ff ff       	call   640 <free>
 777:	83 c4 10             	add    $0x10,%esp
  return freep;
 77a:	a1 18 0b 00 00       	mov    0xb18,%eax
}
 77f:	c9                   	leave  
 780:	c3                   	ret    

00000781 <malloc>:

void*
malloc(uint nbytes)
{
 781:	55                   	push   %ebp
 782:	89 e5                	mov    %esp,%ebp
 784:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 787:	8b 45 08             	mov    0x8(%ebp),%eax
 78a:	83 c0 07             	add    $0x7,%eax
 78d:	c1 e8 03             	shr    $0x3,%eax
 790:	40                   	inc    %eax
 791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 794:	a1 18 0b 00 00       	mov    0xb18,%eax
 799:	89 45 f0             	mov    %eax,-0x10(%ebp)
 79c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a0:	75 23                	jne    7c5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7a2:	c7 45 f0 10 0b 00 00 	movl   $0xb10,-0x10(%ebp)
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	a3 18 0b 00 00       	mov    %eax,0xb18
 7b1:	a1 18 0b 00 00       	mov    0xb18,%eax
 7b6:	a3 10 0b 00 00       	mov    %eax,0xb10
    base.s.size = 0;
 7bb:	c7 05 14 0b 00 00 00 	movl   $0x0,0xb14
 7c2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	8b 00                	mov    (%eax),%eax
 7ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d6:	72 4d                	jb     825 <malloc+0xa4>
      if(p->s.size == nunits)
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 40 04             	mov    0x4(%eax),%eax
 7de:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e1:	75 0c                	jne    7ef <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	8b 10                	mov    (%eax),%edx
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	89 10                	mov    %edx,(%eax)
 7ed:	eb 26                	jmp    815 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f8:	89 c2                	mov    %eax,%edx
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	c1 e0 03             	shl    $0x3,%eax
 809:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 812:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 815:	8b 45 f0             	mov    -0x10(%ebp),%eax
 818:	a3 18 0b 00 00       	mov    %eax,0xb18
      return (void*)(p + 1);
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	83 c0 08             	add    $0x8,%eax
 823:	eb 3b                	jmp    860 <malloc+0xdf>
    }
    if(p == freep)
 825:	a1 18 0b 00 00       	mov    0xb18,%eax
 82a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 82d:	75 1e                	jne    84d <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 82f:	83 ec 0c             	sub    $0xc,%esp
 832:	ff 75 ec             	pushl  -0x14(%ebp)
 835:	e8 e7 fe ff ff       	call   721 <morecore>
 83a:	83 c4 10             	add    $0x10,%esp
 83d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 844:	75 07                	jne    84d <malloc+0xcc>
        return 0;
 846:	b8 00 00 00 00       	mov    $0x0,%eax
 84b:	eb 13                	jmp    860 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	89 45 f0             	mov    %eax,-0x10(%ebp)
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 00                	mov    (%eax),%eax
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 85b:	e9 6d ff ff ff       	jmp    7cd <malloc+0x4c>
}
 860:	c9                   	leave  
 861:	c3                   	ret    

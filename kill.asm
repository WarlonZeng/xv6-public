
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 5f 08 00 00       	push   $0x85f
  21:	6a 02                	push   $0x2
  23:	e8 5c 04 00 00       	call   484 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 7f 02 00 00       	call   2af <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2c                	jmp    65 <main+0x65>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 ce 01 00 00       	call   221 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 80 02 00 00       	call   2df <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	ff 45 f4             	incl   -0xc(%ebp)
  65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  68:	3b 03                	cmp    (%ebx),%eax
  6a:	7c cd                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6c:	e8 3e 02 00 00       	call   2af <exit>

00000071 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  74:	57                   	push   %edi
  75:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  79:	8b 55 10             	mov    0x10(%ebp),%edx
  7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  7f:	89 cb                	mov    %ecx,%ebx
  81:	89 df                	mov    %ebx,%edi
  83:	89 d1                	mov    %edx,%ecx
  85:	fc                   	cld    
  86:	f3 aa                	rep stos %al,%es:(%edi)
  88:	89 ca                	mov    %ecx,%edx
  8a:	89 fb                	mov    %edi,%ebx
  8c:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  92:	5b                   	pop    %ebx
  93:	5f                   	pop    %edi
  94:	5d                   	pop    %ebp
  95:	c3                   	ret    

00000096 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a2:	90                   	nop
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	8d 50 01             	lea    0x1(%eax),%edx
  a9:	89 55 08             	mov    %edx,0x8(%ebp)
  ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  af:	8d 4a 01             	lea    0x1(%edx),%ecx
  b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b5:	8a 12                	mov    (%edx),%dl
  b7:	88 10                	mov    %dl,(%eax)
  b9:	8a 00                	mov    (%eax),%al
  bb:	84 c0                	test   %al,%al
  bd:	75 e4                	jne    a3 <strcpy+0xd>
    ;
  return os;
  bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c2:	c9                   	leave  
  c3:	c3                   	ret    

000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c7:	eb 06                	jmp    cf <strcmp+0xb>
    p++, q++;
  c9:	ff 45 08             	incl   0x8(%ebp)
  cc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	8a 00                	mov    (%eax),%al
  d4:	84 c0                	test   %al,%al
  d6:	74 0e                	je     e6 <strcmp+0x22>
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	8a 10                	mov    (%eax),%dl
  dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  e0:	8a 00                	mov    (%eax),%al
  e2:	38 c2                	cmp    %al,%dl
  e4:	74 e3                	je     c9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	8a 00                	mov    (%eax),%al
  eb:	0f b6 d0             	movzbl %al,%edx
  ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  f1:	8a 00                	mov    (%eax),%al
  f3:	0f b6 c0             	movzbl %al,%eax
  f6:	29 c2                	sub    %eax,%edx
  f8:	89 d0                	mov    %edx,%eax
}
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <strlen>:

uint
strlen(char *s)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 102:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 109:	eb 03                	jmp    10e <strlen+0x12>
 10b:	ff 45 fc             	incl   -0x4(%ebp)
 10e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	01 d0                	add    %edx,%eax
 116:	8a 00                	mov    (%eax),%al
 118:	84 c0                	test   %al,%al
 11a:	75 ef                	jne    10b <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 3e ff ff ff       	call   71 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 12                	jmp    15b <strchr+0x20>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	8a 00                	mov    (%eax),%al
 14e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 151:	75 05                	jne    158 <strchr+0x1d>
      return (char*)s;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	eb 11                	jmp    169 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 158:	ff 45 08             	incl   0x8(%ebp)
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	8a 00                	mov    (%eax),%al
 160:	84 c0                	test   %al,%al
 162:	75 e5                	jne    149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 164:	b8 00 00 00 00       	mov    $0x0,%eax
}
 169:	c9                   	leave  
 16a:	c3                   	ret    

0000016b <gets>:

char*
gets(char *buf, int max)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 171:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 178:	eb 41                	jmp    1bb <gets+0x50>
    cc = read(0, &c, 1);
 17a:	83 ec 04             	sub    $0x4,%esp
 17d:	6a 01                	push   $0x1
 17f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 182:	50                   	push   %eax
 183:	6a 00                	push   $0x0
 185:	e8 3d 01 00 00       	call   2c7 <read>
 18a:	83 c4 10             	add    $0x10,%esp
 18d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 190:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 194:	7f 02                	jg     198 <gets+0x2d>
      break;
 196:	eb 2c                	jmp    1c4 <gets+0x59>
    buf[i++] = c;
 198:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19b:	8d 50 01             	lea    0x1(%eax),%edx
 19e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a1:	89 c2                	mov    %eax,%edx
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	01 c2                	add    %eax,%edx
 1a8:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ab:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1ad:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b0:	3c 0a                	cmp    $0xa,%al
 1b2:	74 10                	je     1c4 <gets+0x59>
 1b4:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b7:	3c 0d                	cmp    $0xd,%al
 1b9:	74 09                	je     1c4 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1be:	40                   	inc    %eax
 1bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c2:	7c b6                	jl     17a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 d0                	add    %edx,%eax
 1cc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d2:	c9                   	leave  
 1d3:	c3                   	ret    

000001d4 <stat>:

int
stat(char *n, struct stat *st)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1da:	83 ec 08             	sub    $0x8,%esp
 1dd:	6a 00                	push   $0x0
 1df:	ff 75 08             	pushl  0x8(%ebp)
 1e2:	e8 08 01 00 00       	call   2ef <open>
 1e7:	83 c4 10             	add    $0x10,%esp
 1ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f1:	79 07                	jns    1fa <stat+0x26>
    return -1;
 1f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f8:	eb 25                	jmp    21f <stat+0x4b>
  r = fstat(fd, st);
 1fa:	83 ec 08             	sub    $0x8,%esp
 1fd:	ff 75 0c             	pushl  0xc(%ebp)
 200:	ff 75 f4             	pushl  -0xc(%ebp)
 203:	e8 ff 00 00 00       	call   307 <fstat>
 208:	83 c4 10             	add    $0x10,%esp
 20b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 20e:	83 ec 0c             	sub    $0xc,%esp
 211:	ff 75 f4             	pushl  -0xc(%ebp)
 214:	e8 be 00 00 00       	call   2d7 <close>
 219:	83 c4 10             	add    $0x10,%esp
  return r;
 21c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <atoi>:

int
atoi(const char *s)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 227:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 22e:	eb 24                	jmp    254 <atoi+0x33>
    n = n*10 + *s++ - '0';
 230:	8b 55 fc             	mov    -0x4(%ebp),%edx
 233:	89 d0                	mov    %edx,%eax
 235:	c1 e0 02             	shl    $0x2,%eax
 238:	01 d0                	add    %edx,%eax
 23a:	01 c0                	add    %eax,%eax
 23c:	89 c1                	mov    %eax,%ecx
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	8d 50 01             	lea    0x1(%eax),%edx
 244:	89 55 08             	mov    %edx,0x8(%ebp)
 247:	8a 00                	mov    (%eax),%al
 249:	0f be c0             	movsbl %al,%eax
 24c:	01 c8                	add    %ecx,%eax
 24e:	83 e8 30             	sub    $0x30,%eax
 251:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8a 00                	mov    (%eax),%al
 259:	3c 2f                	cmp    $0x2f,%al
 25b:	7e 09                	jle    266 <atoi+0x45>
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	8a 00                	mov    (%eax),%al
 262:	3c 39                	cmp    $0x39,%al
 264:	7e ca                	jle    230 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 266:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 269:	c9                   	leave  
 26a:	c3                   	ret    

0000026b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 26b:	55                   	push   %ebp
 26c:	89 e5                	mov    %esp,%ebp
 26e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 277:	8b 45 0c             	mov    0xc(%ebp),%eax
 27a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 27d:	eb 16                	jmp    295 <memmove+0x2a>
    *dst++ = *src++;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 fc             	mov    %edx,-0x4(%ebp)
 288:	8b 55 f8             	mov    -0x8(%ebp),%edx
 28b:	8d 4a 01             	lea    0x1(%edx),%ecx
 28e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 291:	8a 12                	mov    (%edx),%dl
 293:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 295:	8b 45 10             	mov    0x10(%ebp),%eax
 298:	8d 50 ff             	lea    -0x1(%eax),%edx
 29b:	89 55 10             	mov    %edx,0x10(%ebp)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7f dd                	jg     27f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a5:	c9                   	leave  
 2a6:	c3                   	ret    

000002a7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a7:	b8 01 00 00 00       	mov    $0x1,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <exit>:
SYSCALL(exit)
 2af:	b8 02 00 00 00       	mov    $0x2,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <wait>:
SYSCALL(wait)
 2b7:	b8 03 00 00 00       	mov    $0x3,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <pipe>:
SYSCALL(pipe)
 2bf:	b8 04 00 00 00       	mov    $0x4,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <read>:
SYSCALL(read)
 2c7:	b8 05 00 00 00       	mov    $0x5,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <write>:
SYSCALL(write)
 2cf:	b8 10 00 00 00       	mov    $0x10,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <close>:
SYSCALL(close)
 2d7:	b8 15 00 00 00       	mov    $0x15,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <kill>:
SYSCALL(kill)
 2df:	b8 06 00 00 00       	mov    $0x6,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <exec>:
SYSCALL(exec)
 2e7:	b8 07 00 00 00       	mov    $0x7,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <open>:
SYSCALL(open)
 2ef:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <mknod>:
SYSCALL(mknod)
 2f7:	b8 11 00 00 00       	mov    $0x11,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <unlink>:
SYSCALL(unlink)
 2ff:	b8 12 00 00 00       	mov    $0x12,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <fstat>:
SYSCALL(fstat)
 307:	b8 08 00 00 00       	mov    $0x8,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <link>:
SYSCALL(link)
 30f:	b8 13 00 00 00       	mov    $0x13,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mkdir>:
SYSCALL(mkdir)
 317:	b8 14 00 00 00       	mov    $0x14,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <chdir>:
SYSCALL(chdir)
 31f:	b8 09 00 00 00       	mov    $0x9,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <dup>:
SYSCALL(dup)
 327:	b8 0a 00 00 00       	mov    $0xa,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <getpid>:
SYSCALL(getpid)
 32f:	b8 0b 00 00 00       	mov    $0xb,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <sbrk>:
SYSCALL(sbrk)
 337:	b8 0c 00 00 00       	mov    $0xc,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <sleep>:
SYSCALL(sleep)
 33f:	b8 0d 00 00 00       	mov    $0xd,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <uptime>:
SYSCALL(uptime)
 347:	b8 0e 00 00 00       	mov    $0xe,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <gettime>:
SYSCALL(gettime)
 34f:	b8 16 00 00 00       	mov    $0x16,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <settickets>:
SYSCALL(settickets)
 357:	b8 17 00 00 00       	mov    $0x17,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	83 ec 18             	sub    $0x18,%esp
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36b:	83 ec 04             	sub    $0x4,%esp
 36e:	6a 01                	push   $0x1
 370:	8d 45 f4             	lea    -0xc(%ebp),%eax
 373:	50                   	push   %eax
 374:	ff 75 08             	pushl  0x8(%ebp)
 377:	e8 53 ff ff ff       	call   2cf <write>
 37c:	83 c4 10             	add    $0x10,%esp
}
 37f:	c9                   	leave  
 380:	c3                   	ret    

00000381 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	53                   	push   %ebx
 385:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 393:	74 17                	je     3ac <printint+0x2b>
 395:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 399:	79 11                	jns    3ac <printint+0x2b>
    neg = 1;
 39b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a5:	f7 d8                	neg    %eax
 3a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3aa:	eb 06                	jmp    3b2 <printint+0x31>
  } else {
    x = xx;
 3ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 3af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3bc:	8d 41 01             	lea    0x1(%ecx),%eax
 3bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c8:	ba 00 00 00 00       	mov    $0x0,%edx
 3cd:	f7 f3                	div    %ebx
 3cf:	89 d0                	mov    %edx,%eax
 3d1:	8a 80 e8 0a 00 00    	mov    0xae8(%eax),%al
 3d7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3db:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3de:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e1:	ba 00 00 00 00       	mov    $0x0,%edx
 3e6:	f7 f3                	div    %ebx
 3e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ef:	75 c8                	jne    3b9 <printint+0x38>
  if(neg)
 3f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f5:	74 0e                	je     405 <printint+0x84>
    buf[i++] = '-';
 3f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fa:	8d 50 01             	lea    0x1(%eax),%edx
 3fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 400:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 405:	eb 1c                	jmp    423 <printint+0xa2>
    putc(fd, buf[i]);
 407:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40d:	01 d0                	add    %edx,%eax
 40f:	8a 00                	mov    (%eax),%al
 411:	0f be c0             	movsbl %al,%eax
 414:	83 ec 08             	sub    $0x8,%esp
 417:	50                   	push   %eax
 418:	ff 75 08             	pushl  0x8(%ebp)
 41b:	e8 3f ff ff ff       	call   35f <putc>
 420:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 423:	ff 4d f4             	decl   -0xc(%ebp)
 426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42a:	79 db                	jns    407 <printint+0x86>
    putc(fd, buf[i]);
}
 42c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 42f:	c9                   	leave  
 430:	c3                   	ret    

00000431 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 431:	55                   	push   %ebp
 432:	89 e5                	mov    %esp,%ebp
 434:	83 ec 28             	sub    $0x28,%esp
 437:	8b 45 0c             	mov    0xc(%ebp),%eax
 43a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 43d:	8b 45 10             	mov    0x10(%ebp),%eax
 440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 443:	8b 45 e0             	mov    -0x20(%ebp),%eax
 446:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 449:	89 d0                	mov    %edx,%eax
 44b:	31 d2                	xor    %edx,%edx
 44d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 450:	8b 45 e0             	mov    -0x20(%ebp),%eax
 453:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45a:	74 13                	je     46f <printlong+0x3e>
 45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45f:	6a 00                	push   $0x0
 461:	6a 10                	push   $0x10
 463:	50                   	push   %eax
 464:	ff 75 08             	pushl  0x8(%ebp)
 467:	e8 15 ff ff ff       	call   381 <printint>
 46c:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 46f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 472:	6a 00                	push   $0x0
 474:	6a 10                	push   $0x10
 476:	50                   	push   %eax
 477:	ff 75 08             	pushl  0x8(%ebp)
 47a:	e8 02 ff ff ff       	call   381 <printint>
 47f:	83 c4 10             	add    $0x10,%esp
}
 482:	c9                   	leave  
 483:	c3                   	ret    

00000484 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 491:	8d 45 0c             	lea    0xc(%ebp),%eax
 494:	83 c0 04             	add    $0x4,%eax
 497:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a1:	e9 83 01 00 00       	jmp    629 <printf+0x1a5>
    c = fmt[i] & 0xff;
 4a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ac:	01 d0                	add    %edx,%eax
 4ae:	8a 00                	mov    (%eax),%al
 4b0:	0f be c0             	movsbl %al,%eax
 4b3:	25 ff 00 00 00       	and    $0xff,%eax
 4b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bf:	75 2c                	jne    4ed <printf+0x69>
      if(c == '%'){
 4c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c5:	75 0c                	jne    4d3 <printf+0x4f>
        state = '%';
 4c7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ce:	e9 53 01 00 00       	jmp    626 <printf+0x1a2>
      } else {
        putc(fd, c);
 4d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d6:	0f be c0             	movsbl %al,%eax
 4d9:	83 ec 08             	sub    $0x8,%esp
 4dc:	50                   	push   %eax
 4dd:	ff 75 08             	pushl  0x8(%ebp)
 4e0:	e8 7a fe ff ff       	call   35f <putc>
 4e5:	83 c4 10             	add    $0x10,%esp
 4e8:	e9 39 01 00 00       	jmp    626 <printf+0x1a2>
      }
    } else if(state == '%'){
 4ed:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f1:	0f 85 2f 01 00 00    	jne    626 <printf+0x1a2>
      if(c == 'd'){
 4f7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fb:	75 1e                	jne    51b <printf+0x97>
        printint(fd, *ap, 10, 1);
 4fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 500:	8b 00                	mov    (%eax),%eax
 502:	6a 01                	push   $0x1
 504:	6a 0a                	push   $0xa
 506:	50                   	push   %eax
 507:	ff 75 08             	pushl  0x8(%ebp)
 50a:	e8 72 fe ff ff       	call   381 <printint>
 50f:	83 c4 10             	add    $0x10,%esp
        ap++;
 512:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 516:	e9 04 01 00 00       	jmp    61f <printf+0x19b>
      } else if(c == 'l') {
 51b:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 51f:	75 29                	jne    54a <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	8b 50 04             	mov    0x4(%eax),%edx
 527:	8b 00                	mov    (%eax),%eax
 529:	83 ec 0c             	sub    $0xc,%esp
 52c:	6a 00                	push   $0x0
 52e:	6a 0a                	push   $0xa
 530:	52                   	push   %edx
 531:	50                   	push   %eax
 532:	ff 75 08             	pushl  0x8(%ebp)
 535:	e8 f7 fe ff ff       	call   431 <printlong>
 53a:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 53d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 541:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 545:	e9 d5 00 00 00       	jmp    61f <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 54a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 54e:	74 06                	je     556 <printf+0xd2>
 550:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 554:	75 1e                	jne    574 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 556:	8b 45 e8             	mov    -0x18(%ebp),%eax
 559:	8b 00                	mov    (%eax),%eax
 55b:	6a 00                	push   $0x0
 55d:	6a 10                	push   $0x10
 55f:	50                   	push   %eax
 560:	ff 75 08             	pushl  0x8(%ebp)
 563:	e8 19 fe ff ff       	call   381 <printint>
 568:	83 c4 10             	add    $0x10,%esp
        ap++;
 56b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56f:	e9 ab 00 00 00       	jmp    61f <printf+0x19b>
      } else if(c == 's'){
 574:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 578:	75 40                	jne    5ba <printf+0x136>
        s = (char*)*ap;
 57a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57d:	8b 00                	mov    (%eax),%eax
 57f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58a:	75 07                	jne    593 <printf+0x10f>
          s = "(null)";
 58c:	c7 45 f4 73 08 00 00 	movl   $0x873,-0xc(%ebp)
        while(*s != 0){
 593:	eb 1a                	jmp    5af <printf+0x12b>
          putc(fd, *s);
 595:	8b 45 f4             	mov    -0xc(%ebp),%eax
 598:	8a 00                	mov    (%eax),%al
 59a:	0f be c0             	movsbl %al,%eax
 59d:	83 ec 08             	sub    $0x8,%esp
 5a0:	50                   	push   %eax
 5a1:	ff 75 08             	pushl  0x8(%ebp)
 5a4:	e8 b6 fd ff ff       	call   35f <putc>
 5a9:	83 c4 10             	add    $0x10,%esp
          s++;
 5ac:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b2:	8a 00                	mov    (%eax),%al
 5b4:	84 c0                	test   %al,%al
 5b6:	75 dd                	jne    595 <printf+0x111>
 5b8:	eb 65                	jmp    61f <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ba:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5be:	75 1d                	jne    5dd <printf+0x159>
        putc(fd, *ap);
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	83 ec 08             	sub    $0x8,%esp
 5cb:	50                   	push   %eax
 5cc:	ff 75 08             	pushl  0x8(%ebp)
 5cf:	e8 8b fd ff ff       	call   35f <putc>
 5d4:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5db:	eb 42                	jmp    61f <printf+0x19b>
      } else if(c == '%'){
 5dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e1:	75 17                	jne    5fa <printf+0x176>
        putc(fd, c);
 5e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	83 ec 08             	sub    $0x8,%esp
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 6a fd ff ff       	call   35f <putc>
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	eb 25                	jmp    61f <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fa:	83 ec 08             	sub    $0x8,%esp
 5fd:	6a 25                	push   $0x25
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 58 fd ff ff       	call   35f <putc>
 607:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 60a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	83 ec 08             	sub    $0x8,%esp
 613:	50                   	push   %eax
 614:	ff 75 08             	pushl  0x8(%ebp)
 617:	e8 43 fd ff ff       	call   35f <putc>
 61c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 61f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 626:	ff 45 f0             	incl   -0x10(%ebp)
 629:	8b 55 0c             	mov    0xc(%ebp),%edx
 62c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62f:	01 d0                	add    %edx,%eax
 631:	8a 00                	mov    (%eax),%al
 633:	84 c0                	test   %al,%al
 635:	0f 85 6b fe ff ff    	jne    4a6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	83 e8 08             	sub    $0x8,%eax
 649:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64c:	a1 04 0b 00 00       	mov    0xb04,%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
 654:	eb 24                	jmp    67a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65e:	77 12                	ja     672 <free+0x35>
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 666:	77 24                	ja     68c <free+0x4f>
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 670:	77 1a                	ja     68c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 680:	76 d4                	jbe    656 <free+0x19>
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68a:	76 ca                	jbe    656 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	01 c2                	add    %eax,%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	39 c2                	cmp    %eax,%edx
 6a5:	75 24                	jne    6cb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 50 04             	mov    0x4(%eax),%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	01 c2                	add    %eax,%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	8b 10                	mov    (%eax),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	89 10                	mov    %edx,(%eax)
 6c9:	eb 0a                	jmp    6d5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 10                	mov    (%eax),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 40 04             	mov    0x4(%eax),%eax
 6db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	01 d0                	add    %edx,%eax
 6e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ea:	75 20                	jne    70c <free+0xcf>
    p->s.size += bp->s.size;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 50 04             	mov    0x4(%eax),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	01 c2                	add    %eax,%edx
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	8b 10                	mov    (%eax),%edx
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	89 10                	mov    %edx,(%eax)
 70a:	eb 08                	jmp    714 <free+0xd7>
  } else
    p->s.ptr = bp;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 712:	89 10                	mov    %edx,(%eax)
  freep = p;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	a3 04 0b 00 00       	mov    %eax,0xb04
}
 71c:	c9                   	leave  
 71d:	c3                   	ret    

0000071e <morecore>:

static Header*
morecore(uint nu)
{
 71e:	55                   	push   %ebp
 71f:	89 e5                	mov    %esp,%ebp
 721:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 724:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72b:	77 07                	ja     734 <morecore+0x16>
    nu = 4096;
 72d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 734:	8b 45 08             	mov    0x8(%ebp),%eax
 737:	c1 e0 03             	shl    $0x3,%eax
 73a:	83 ec 0c             	sub    $0xc,%esp
 73d:	50                   	push   %eax
 73e:	e8 f4 fb ff ff       	call   337 <sbrk>
 743:	83 c4 10             	add    $0x10,%esp
 746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 749:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 74d:	75 07                	jne    756 <morecore+0x38>
    return 0;
 74f:	b8 00 00 00 00       	mov    $0x0,%eax
 754:	eb 26                	jmp    77c <morecore+0x5e>
  hp = (Header*)p;
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 75c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75f:	8b 55 08             	mov    0x8(%ebp),%edx
 762:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	83 c0 08             	add    $0x8,%eax
 76b:	83 ec 0c             	sub    $0xc,%esp
 76e:	50                   	push   %eax
 76f:	e8 c9 fe ff ff       	call   63d <free>
 774:	83 c4 10             	add    $0x10,%esp
  return freep;
 777:	a1 04 0b 00 00       	mov    0xb04,%eax
}
 77c:	c9                   	leave  
 77d:	c3                   	ret    

0000077e <malloc>:

void*
malloc(uint nbytes)
{
 77e:	55                   	push   %ebp
 77f:	89 e5                	mov    %esp,%ebp
 781:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	83 c0 07             	add    $0x7,%eax
 78a:	c1 e8 03             	shr    $0x3,%eax
 78d:	40                   	inc    %eax
 78e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 791:	a1 04 0b 00 00       	mov    0xb04,%eax
 796:	89 45 f0             	mov    %eax,-0x10(%ebp)
 799:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 79d:	75 23                	jne    7c2 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 79f:	c7 45 f0 fc 0a 00 00 	movl   $0xafc,-0x10(%ebp)
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	a3 04 0b 00 00       	mov    %eax,0xb04
 7ae:	a1 04 0b 00 00       	mov    0xb04,%eax
 7b3:	a3 fc 0a 00 00       	mov    %eax,0xafc
    base.s.size = 0;
 7b8:	c7 05 00 0b 00 00 00 	movl   $0x0,0xb00
 7bf:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d3:	72 4d                	jb     822 <malloc+0xa4>
      if(p->s.size == nunits)
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7de:	75 0c                	jne    7ec <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 10                	mov    (%eax),%edx
 7e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e8:	89 10                	mov    %edx,(%eax)
 7ea:	eb 26                	jmp    812 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f5:	89 c2                	mov    %eax,%edx
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 40 04             	mov    0x4(%eax),%eax
 803:	c1 e0 03             	shl    $0x3,%eax
 806:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	a3 04 0b 00 00       	mov    %eax,0xb04
      return (void*)(p + 1);
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	83 c0 08             	add    $0x8,%eax
 820:	eb 3b                	jmp    85d <malloc+0xdf>
    }
    if(p == freep)
 822:	a1 04 0b 00 00       	mov    0xb04,%eax
 827:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 82a:	75 1e                	jne    84a <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 82c:	83 ec 0c             	sub    $0xc,%esp
 82f:	ff 75 ec             	pushl  -0x14(%ebp)
 832:	e8 e7 fe ff ff       	call   71e <morecore>
 837:	83 c4 10             	add    $0x10,%esp
 83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 83d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 841:	75 07                	jne    84a <malloc+0xcc>
        return 0;
 843:	b8 00 00 00 00       	mov    $0x0,%eax
 848:	eb 13                	jmp    85d <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	8b 00                	mov    (%eax),%eax
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 858:	e9 6d ff ff ff       	jmp    7ca <malloc+0x4c>
}
 85d:	c9                   	leave  
 85e:	c3                   	ret    

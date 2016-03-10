
_echo:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 39                	jmp    56 <main+0x56>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	40                   	inc    %eax
  21:	3b 03                	cmp    (%ebx),%eax
  23:	7d 07                	jge    2c <main+0x2c>
  25:	b8 50 08 00 00       	mov    $0x850,%eax
  2a:	eb 05                	jmp    31 <main+0x31>
  2c:	b8 52 08 00 00       	mov    $0x852,%eax
  31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  34:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  3b:	8b 53 04             	mov    0x4(%ebx),%edx
  3e:	01 ca                	add    %ecx,%edx
  40:	8b 12                	mov    (%edx),%edx
  42:	50                   	push   %eax
  43:	52                   	push   %edx
  44:	68 54 08 00 00       	push   $0x854
  49:	6a 01                	push   $0x1
  4b:	e8 25 04 00 00       	call   475 <printf>
  50:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  53:	ff 45 f4             	incl   -0xc(%ebp)
  56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  59:	3b 03                	cmp    (%ebx),%eax
  5b:	7c c0                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  5d:	e8 3e 02 00 00       	call   2a0 <exit>

00000062 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  62:	55                   	push   %ebp
  63:	89 e5                	mov    %esp,%ebp
  65:	57                   	push   %edi
  66:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6a:	8b 55 10             	mov    0x10(%ebp),%edx
  6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  70:	89 cb                	mov    %ecx,%ebx
  72:	89 df                	mov    %ebx,%edi
  74:	89 d1                	mov    %edx,%ecx
  76:	fc                   	cld    
  77:	f3 aa                	rep stos %al,%es:(%edi)
  79:	89 ca                	mov    %ecx,%edx
  7b:	89 fb                	mov    %edi,%ebx
  7d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  80:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  83:	5b                   	pop    %ebx
  84:	5f                   	pop    %edi
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    

00000087 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  8d:	8b 45 08             	mov    0x8(%ebp),%eax
  90:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  93:	90                   	nop
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	8d 50 01             	lea    0x1(%eax),%edx
  9a:	89 55 08             	mov    %edx,0x8(%ebp)
  9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  a3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  a6:	8a 12                	mov    (%edx),%dl
  a8:	88 10                	mov    %dl,(%eax)
  aa:	8a 00                	mov    (%eax),%al
  ac:	84 c0                	test   %al,%al
  ae:	75 e4                	jne    94 <strcpy+0xd>
    ;
  return os;
  b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b3:	c9                   	leave  
  b4:	c3                   	ret    

000000b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  b8:	eb 06                	jmp    c0 <strcmp+0xb>
    p++, q++;
  ba:	ff 45 08             	incl   0x8(%ebp)
  bd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	8a 00                	mov    (%eax),%al
  c5:	84 c0                	test   %al,%al
  c7:	74 0e                	je     d7 <strcmp+0x22>
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	8a 10                	mov    (%eax),%dl
  ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  d1:	8a 00                	mov    (%eax),%al
  d3:	38 c2                	cmp    %al,%dl
  d5:	74 e3                	je     ba <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	8a 00                	mov    (%eax),%al
  dc:	0f b6 d0             	movzbl %al,%edx
  df:	8b 45 0c             	mov    0xc(%ebp),%eax
  e2:	8a 00                	mov    (%eax),%al
  e4:	0f b6 c0             	movzbl %al,%eax
  e7:	29 c2                	sub    %eax,%edx
  e9:	89 d0                	mov    %edx,%eax
}
  eb:	5d                   	pop    %ebp
  ec:	c3                   	ret    

000000ed <strlen>:

uint
strlen(char *s)
{
  ed:	55                   	push   %ebp
  ee:	89 e5                	mov    %esp,%ebp
  f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  fa:	eb 03                	jmp    ff <strlen+0x12>
  fc:	ff 45 fc             	incl   -0x4(%ebp)
  ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	01 d0                	add    %edx,%eax
 107:	8a 00                	mov    (%eax),%al
 109:	84 c0                	test   %al,%al
 10b:	75 ef                	jne    fc <strlen+0xf>
    ;
  return n;
 10d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 110:	c9                   	leave  
 111:	c3                   	ret    

00000112 <memset>:

void*
memset(void *dst, int c, uint n)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 115:	8b 45 10             	mov    0x10(%ebp),%eax
 118:	50                   	push   %eax
 119:	ff 75 0c             	pushl  0xc(%ebp)
 11c:	ff 75 08             	pushl  0x8(%ebp)
 11f:	e8 3e ff ff ff       	call   62 <stosb>
 124:	83 c4 0c             	add    $0xc,%esp
  return dst;
 127:	8b 45 08             	mov    0x8(%ebp),%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <strchr>:

char*
strchr(const char *s, char c)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	83 ec 04             	sub    $0x4,%esp
 132:	8b 45 0c             	mov    0xc(%ebp),%eax
 135:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 138:	eb 12                	jmp    14c <strchr+0x20>
    if(*s == c)
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	8a 00                	mov    (%eax),%al
 13f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 142:	75 05                	jne    149 <strchr+0x1d>
      return (char*)s;
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	eb 11                	jmp    15a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 149:	ff 45 08             	incl   0x8(%ebp)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	8a 00                	mov    (%eax),%al
 151:	84 c0                	test   %al,%al
 153:	75 e5                	jne    13a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 155:	b8 00 00 00 00       	mov    $0x0,%eax
}
 15a:	c9                   	leave  
 15b:	c3                   	ret    

0000015c <gets>:

char*
gets(char *buf, int max)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 162:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 169:	eb 41                	jmp    1ac <gets+0x50>
    cc = read(0, &c, 1);
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	6a 01                	push   $0x1
 170:	8d 45 ef             	lea    -0x11(%ebp),%eax
 173:	50                   	push   %eax
 174:	6a 00                	push   $0x0
 176:	e8 3d 01 00 00       	call   2b8 <read>
 17b:	83 c4 10             	add    $0x10,%esp
 17e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 185:	7f 02                	jg     189 <gets+0x2d>
      break;
 187:	eb 2c                	jmp    1b5 <gets+0x59>
    buf[i++] = c;
 189:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18c:	8d 50 01             	lea    0x1(%eax),%edx
 18f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 192:	89 c2                	mov    %eax,%edx
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	01 c2                	add    %eax,%edx
 199:	8a 45 ef             	mov    -0x11(%ebp),%al
 19c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 19e:	8a 45 ef             	mov    -0x11(%ebp),%al
 1a1:	3c 0a                	cmp    $0xa,%al
 1a3:	74 10                	je     1b5 <gets+0x59>
 1a5:	8a 45 ef             	mov    -0x11(%ebp),%al
 1a8:	3c 0d                	cmp    $0xd,%al
 1aa:	74 09                	je     1b5 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1af:	40                   	inc    %eax
 1b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1b3:	7c b6                	jl     16b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	01 d0                	add    %edx,%eax
 1bd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c3:	c9                   	leave  
 1c4:	c3                   	ret    

000001c5 <stat>:

int
stat(char *n, struct stat *st)
{
 1c5:	55                   	push   %ebp
 1c6:	89 e5                	mov    %esp,%ebp
 1c8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cb:	83 ec 08             	sub    $0x8,%esp
 1ce:	6a 00                	push   $0x0
 1d0:	ff 75 08             	pushl  0x8(%ebp)
 1d3:	e8 08 01 00 00       	call   2e0 <open>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1e2:	79 07                	jns    1eb <stat+0x26>
    return -1;
 1e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e9:	eb 25                	jmp    210 <stat+0x4b>
  r = fstat(fd, st);
 1eb:	83 ec 08             	sub    $0x8,%esp
 1ee:	ff 75 0c             	pushl  0xc(%ebp)
 1f1:	ff 75 f4             	pushl  -0xc(%ebp)
 1f4:	e8 ff 00 00 00       	call   2f8 <fstat>
 1f9:	83 c4 10             	add    $0x10,%esp
 1fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1ff:	83 ec 0c             	sub    $0xc,%esp
 202:	ff 75 f4             	pushl  -0xc(%ebp)
 205:	e8 be 00 00 00       	call   2c8 <close>
 20a:	83 c4 10             	add    $0x10,%esp
  return r;
 20d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 210:	c9                   	leave  
 211:	c3                   	ret    

00000212 <atoi>:

int
atoi(const char *s)
{
 212:	55                   	push   %ebp
 213:	89 e5                	mov    %esp,%ebp
 215:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 218:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 21f:	eb 24                	jmp    245 <atoi+0x33>
    n = n*10 + *s++ - '0';
 221:	8b 55 fc             	mov    -0x4(%ebp),%edx
 224:	89 d0                	mov    %edx,%eax
 226:	c1 e0 02             	shl    $0x2,%eax
 229:	01 d0                	add    %edx,%eax
 22b:	01 c0                	add    %eax,%eax
 22d:	89 c1                	mov    %eax,%ecx
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	8d 50 01             	lea    0x1(%eax),%edx
 235:	89 55 08             	mov    %edx,0x8(%ebp)
 238:	8a 00                	mov    (%eax),%al
 23a:	0f be c0             	movsbl %al,%eax
 23d:	01 c8                	add    %ecx,%eax
 23f:	83 e8 30             	sub    $0x30,%eax
 242:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	8a 00                	mov    (%eax),%al
 24a:	3c 2f                	cmp    $0x2f,%al
 24c:	7e 09                	jle    257 <atoi+0x45>
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	8a 00                	mov    (%eax),%al
 253:	3c 39                	cmp    $0x39,%al
 255:	7e ca                	jle    221 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 257:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 25a:	c9                   	leave  
 25b:	c3                   	ret    

0000025c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 268:	8b 45 0c             	mov    0xc(%ebp),%eax
 26b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 26e:	eb 16                	jmp    286 <memmove+0x2a>
    *dst++ = *src++;
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
 273:	8d 50 01             	lea    0x1(%eax),%edx
 276:	89 55 fc             	mov    %edx,-0x4(%ebp)
 279:	8b 55 f8             	mov    -0x8(%ebp),%edx
 27c:	8d 4a 01             	lea    0x1(%edx),%ecx
 27f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 282:	8a 12                	mov    (%edx),%dl
 284:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 286:	8b 45 10             	mov    0x10(%ebp),%eax
 289:	8d 50 ff             	lea    -0x1(%eax),%edx
 28c:	89 55 10             	mov    %edx,0x10(%ebp)
 28f:	85 c0                	test   %eax,%eax
 291:	7f dd                	jg     270 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 293:	8b 45 08             	mov    0x8(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 298:	b8 01 00 00 00       	mov    $0x1,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <exit>:
SYSCALL(exit)
 2a0:	b8 02 00 00 00       	mov    $0x2,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <wait>:
SYSCALL(wait)
 2a8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <pipe>:
SYSCALL(pipe)
 2b0:	b8 04 00 00 00       	mov    $0x4,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <read>:
SYSCALL(read)
 2b8:	b8 05 00 00 00       	mov    $0x5,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <write>:
SYSCALL(write)
 2c0:	b8 10 00 00 00       	mov    $0x10,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <close>:
SYSCALL(close)
 2c8:	b8 15 00 00 00       	mov    $0x15,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <kill>:
SYSCALL(kill)
 2d0:	b8 06 00 00 00       	mov    $0x6,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <exec>:
SYSCALL(exec)
 2d8:	b8 07 00 00 00       	mov    $0x7,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <open>:
SYSCALL(open)
 2e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <mknod>:
SYSCALL(mknod)
 2e8:	b8 11 00 00 00       	mov    $0x11,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <unlink>:
SYSCALL(unlink)
 2f0:	b8 12 00 00 00       	mov    $0x12,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <fstat>:
SYSCALL(fstat)
 2f8:	b8 08 00 00 00       	mov    $0x8,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <link>:
SYSCALL(link)
 300:	b8 13 00 00 00       	mov    $0x13,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <mkdir>:
SYSCALL(mkdir)
 308:	b8 14 00 00 00       	mov    $0x14,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <chdir>:
SYSCALL(chdir)
 310:	b8 09 00 00 00       	mov    $0x9,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <dup>:
SYSCALL(dup)
 318:	b8 0a 00 00 00       	mov    $0xa,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <getpid>:
SYSCALL(getpid)
 320:	b8 0b 00 00 00       	mov    $0xb,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <sbrk>:
SYSCALL(sbrk)
 328:	b8 0c 00 00 00       	mov    $0xc,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <sleep>:
SYSCALL(sleep)
 330:	b8 0d 00 00 00       	mov    $0xd,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <uptime>:
SYSCALL(uptime)
 338:	b8 0e 00 00 00       	mov    $0xe,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <gettime>:
SYSCALL(gettime)
 340:	b8 16 00 00 00       	mov    $0x16,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <settickets>:
SYSCALL(settickets)
 348:	b8 17 00 00 00       	mov    $0x17,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	83 ec 18             	sub    $0x18,%esp
 356:	8b 45 0c             	mov    0xc(%ebp),%eax
 359:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 35c:	83 ec 04             	sub    $0x4,%esp
 35f:	6a 01                	push   $0x1
 361:	8d 45 f4             	lea    -0xc(%ebp),%eax
 364:	50                   	push   %eax
 365:	ff 75 08             	pushl  0x8(%ebp)
 368:	e8 53 ff ff ff       	call   2c0 <write>
 36d:	83 c4 10             	add    $0x10,%esp
}
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	53                   	push   %ebx
 376:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 379:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 380:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 384:	74 17                	je     39d <printint+0x2b>
 386:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 38a:	79 11                	jns    39d <printint+0x2b>
    neg = 1;
 38c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 393:	8b 45 0c             	mov    0xc(%ebp),%eax
 396:	f7 d8                	neg    %eax
 398:	89 45 ec             	mov    %eax,-0x14(%ebp)
 39b:	eb 06                	jmp    3a3 <printint+0x31>
  } else {
    x = xx;
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3ad:	8d 41 01             	lea    0x1(%ecx),%eax
 3b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b9:	ba 00 00 00 00       	mov    $0x0,%edx
 3be:	f7 f3                	div    %ebx
 3c0:	89 d0                	mov    %edx,%eax
 3c2:	8a 80 cc 0a 00 00    	mov    0xacc(%eax),%al
 3c8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d2:	ba 00 00 00 00       	mov    $0x0,%edx
 3d7:	f7 f3                	div    %ebx
 3d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e0:	75 c8                	jne    3aa <printint+0x38>
  if(neg)
 3e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e6:	74 0e                	je     3f6 <printint+0x84>
    buf[i++] = '-';
 3e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3eb:	8d 50 01             	lea    0x1(%eax),%edx
 3ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3f6:	eb 1c                	jmp    414 <printint+0xa2>
    putc(fd, buf[i]);
 3f8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fe:	01 d0                	add    %edx,%eax
 400:	8a 00                	mov    (%eax),%al
 402:	0f be c0             	movsbl %al,%eax
 405:	83 ec 08             	sub    $0x8,%esp
 408:	50                   	push   %eax
 409:	ff 75 08             	pushl  0x8(%ebp)
 40c:	e8 3f ff ff ff       	call   350 <putc>
 411:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 414:	ff 4d f4             	decl   -0xc(%ebp)
 417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 41b:	79 db                	jns    3f8 <printint+0x86>
    putc(fd, buf[i]);
}
 41d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 28             	sub    $0x28,%esp
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 42e:	8b 45 10             	mov    0x10(%ebp),%eax
 431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 434:	8b 45 e0             	mov    -0x20(%ebp),%eax
 437:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 43a:	89 d0                	mov    %edx,%eax
 43c:	31 d2                	xor    %edx,%edx
 43e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 441:	8b 45 e0             	mov    -0x20(%ebp),%eax
 444:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44b:	74 13                	je     460 <printlong+0x3e>
 44d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 450:	6a 00                	push   $0x0
 452:	6a 10                	push   $0x10
 454:	50                   	push   %eax
 455:	ff 75 08             	pushl  0x8(%ebp)
 458:	e8 15 ff ff ff       	call   372 <printint>
 45d:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 460:	8b 45 f0             	mov    -0x10(%ebp),%eax
 463:	6a 00                	push   $0x0
 465:	6a 10                	push   $0x10
 467:	50                   	push   %eax
 468:	ff 75 08             	pushl  0x8(%ebp)
 46b:	e8 02 ff ff ff       	call   372 <printint>
 470:	83 c4 10             	add    $0x10,%esp
}
 473:	c9                   	leave  
 474:	c3                   	ret    

00000475 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 475:	55                   	push   %ebp
 476:	89 e5                	mov    %esp,%ebp
 478:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 482:	8d 45 0c             	lea    0xc(%ebp),%eax
 485:	83 c0 04             	add    $0x4,%eax
 488:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 492:	e9 83 01 00 00       	jmp    61a <printf+0x1a5>
    c = fmt[i] & 0xff;
 497:	8b 55 0c             	mov    0xc(%ebp),%edx
 49a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49d:	01 d0                	add    %edx,%eax
 49f:	8a 00                	mov    (%eax),%al
 4a1:	0f be c0             	movsbl %al,%eax
 4a4:	25 ff 00 00 00       	and    $0xff,%eax
 4a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b0:	75 2c                	jne    4de <printf+0x69>
      if(c == '%'){
 4b2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b6:	75 0c                	jne    4c4 <printf+0x4f>
        state = '%';
 4b8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4bf:	e9 53 01 00 00       	jmp    617 <printf+0x1a2>
      } else {
        putc(fd, c);
 4c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c7:	0f be c0             	movsbl %al,%eax
 4ca:	83 ec 08             	sub    $0x8,%esp
 4cd:	50                   	push   %eax
 4ce:	ff 75 08             	pushl  0x8(%ebp)
 4d1:	e8 7a fe ff ff       	call   350 <putc>
 4d6:	83 c4 10             	add    $0x10,%esp
 4d9:	e9 39 01 00 00       	jmp    617 <printf+0x1a2>
      }
    } else if(state == '%'){
 4de:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e2:	0f 85 2f 01 00 00    	jne    617 <printf+0x1a2>
      if(c == 'd'){
 4e8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ec:	75 1e                	jne    50c <printf+0x97>
        printint(fd, *ap, 10, 1);
 4ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f1:	8b 00                	mov    (%eax),%eax
 4f3:	6a 01                	push   $0x1
 4f5:	6a 0a                	push   $0xa
 4f7:	50                   	push   %eax
 4f8:	ff 75 08             	pushl  0x8(%ebp)
 4fb:	e8 72 fe ff ff       	call   372 <printint>
 500:	83 c4 10             	add    $0x10,%esp
        ap++;
 503:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 507:	e9 04 01 00 00       	jmp    610 <printf+0x19b>
      } else if(c == 'l') {
 50c:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 510:	75 29                	jne    53b <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 512:	8b 45 e8             	mov    -0x18(%ebp),%eax
 515:	8b 50 04             	mov    0x4(%eax),%edx
 518:	8b 00                	mov    (%eax),%eax
 51a:	83 ec 0c             	sub    $0xc,%esp
 51d:	6a 00                	push   $0x0
 51f:	6a 0a                	push   $0xa
 521:	52                   	push   %edx
 522:	50                   	push   %eax
 523:	ff 75 08             	pushl  0x8(%ebp)
 526:	e8 f7 fe ff ff       	call   422 <printlong>
 52b:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 52e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 532:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 536:	e9 d5 00 00 00       	jmp    610 <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 53b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 53f:	74 06                	je     547 <printf+0xd2>
 541:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 545:	75 1e                	jne    565 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 547:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54a:	8b 00                	mov    (%eax),%eax
 54c:	6a 00                	push   $0x0
 54e:	6a 10                	push   $0x10
 550:	50                   	push   %eax
 551:	ff 75 08             	pushl  0x8(%ebp)
 554:	e8 19 fe ff ff       	call   372 <printint>
 559:	83 c4 10             	add    $0x10,%esp
        ap++;
 55c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 560:	e9 ab 00 00 00       	jmp    610 <printf+0x19b>
      } else if(c == 's'){
 565:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 569:	75 40                	jne    5ab <printf+0x136>
        s = (char*)*ap;
 56b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56e:	8b 00                	mov    (%eax),%eax
 570:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57b:	75 07                	jne    584 <printf+0x10f>
          s = "(null)";
 57d:	c7 45 f4 59 08 00 00 	movl   $0x859,-0xc(%ebp)
        while(*s != 0){
 584:	eb 1a                	jmp    5a0 <printf+0x12b>
          putc(fd, *s);
 586:	8b 45 f4             	mov    -0xc(%ebp),%eax
 589:	8a 00                	mov    (%eax),%al
 58b:	0f be c0             	movsbl %al,%eax
 58e:	83 ec 08             	sub    $0x8,%esp
 591:	50                   	push   %eax
 592:	ff 75 08             	pushl  0x8(%ebp)
 595:	e8 b6 fd ff ff       	call   350 <putc>
 59a:	83 c4 10             	add    $0x10,%esp
          s++;
 59d:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a3:	8a 00                	mov    (%eax),%al
 5a5:	84 c0                	test   %al,%al
 5a7:	75 dd                	jne    586 <printf+0x111>
 5a9:	eb 65                	jmp    610 <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ab:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5af:	75 1d                	jne    5ce <printf+0x159>
        putc(fd, *ap);
 5b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b4:	8b 00                	mov    (%eax),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	83 ec 08             	sub    $0x8,%esp
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 8b fd ff ff       	call   350 <putc>
 5c5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cc:	eb 42                	jmp    610 <printf+0x19b>
      } else if(c == '%'){
 5ce:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d2:	75 17                	jne    5eb <printf+0x176>
        putc(fd, c);
 5d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d7:	0f be c0             	movsbl %al,%eax
 5da:	83 ec 08             	sub    $0x8,%esp
 5dd:	50                   	push   %eax
 5de:	ff 75 08             	pushl  0x8(%ebp)
 5e1:	e8 6a fd ff ff       	call   350 <putc>
 5e6:	83 c4 10             	add    $0x10,%esp
 5e9:	eb 25                	jmp    610 <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5eb:	83 ec 08             	sub    $0x8,%esp
 5ee:	6a 25                	push   $0x25
 5f0:	ff 75 08             	pushl  0x8(%ebp)
 5f3:	e8 58 fd ff ff       	call   350 <putc>
 5f8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	83 ec 08             	sub    $0x8,%esp
 604:	50                   	push   %eax
 605:	ff 75 08             	pushl  0x8(%ebp)
 608:	e8 43 fd ff ff       	call   350 <putc>
 60d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 610:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 617:	ff 45 f0             	incl   -0x10(%ebp)
 61a:	8b 55 0c             	mov    0xc(%ebp),%edx
 61d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 620:	01 d0                	add    %edx,%eax
 622:	8a 00                	mov    (%eax),%al
 624:	84 c0                	test   %al,%al
 626:	0f 85 6b fe ff ff    	jne    497 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 62c:	c9                   	leave  
 62d:	c3                   	ret    

0000062e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62e:	55                   	push   %ebp
 62f:	89 e5                	mov    %esp,%ebp
 631:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	83 e8 08             	sub    $0x8,%eax
 63a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63d:	a1 e8 0a 00 00       	mov    0xae8,%eax
 642:	89 45 fc             	mov    %eax,-0x4(%ebp)
 645:	eb 24                	jmp    66b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64f:	77 12                	ja     663 <free+0x35>
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 657:	77 24                	ja     67d <free+0x4f>
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 661:	77 1a                	ja     67d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 671:	76 d4                	jbe    647 <free+0x19>
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67b:	76 ca                	jbe    647 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	8b 40 04             	mov    0x4(%eax),%eax
 683:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	01 c2                	add    %eax,%edx
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	39 c2                	cmp    %eax,%edx
 696:	75 24                	jne    6bc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	8b 50 04             	mov    0x4(%eax),%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	8b 40 04             	mov    0x4(%eax),%eax
 6a6:	01 c2                	add    %eax,%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	8b 10                	mov    (%eax),%edx
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	89 10                	mov    %edx,(%eax)
 6ba:	eb 0a                	jmp    6c6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 10                	mov    (%eax),%edx
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 40 04             	mov    0x4(%eax),%eax
 6cc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	01 d0                	add    %edx,%eax
 6d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6db:	75 20                	jne    6fd <free+0xcf>
    p->s.size += bp->s.size;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 50 04             	mov    0x4(%eax),%edx
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	8b 40 04             	mov    0x4(%eax),%eax
 6e9:	01 c2                	add    %eax,%edx
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	8b 10                	mov    (%eax),%edx
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	89 10                	mov    %edx,(%eax)
 6fb:	eb 08                	jmp    705 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 55 f8             	mov    -0x8(%ebp),%edx
 703:	89 10                	mov    %edx,(%eax)
  freep = p;
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	a3 e8 0a 00 00       	mov    %eax,0xae8
}
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <morecore>:

static Header*
morecore(uint nu)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 715:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71c:	77 07                	ja     725 <morecore+0x16>
    nu = 4096;
 71e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	c1 e0 03             	shl    $0x3,%eax
 72b:	83 ec 0c             	sub    $0xc,%esp
 72e:	50                   	push   %eax
 72f:	e8 f4 fb ff ff       	call   328 <sbrk>
 734:	83 c4 10             	add    $0x10,%esp
 737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 73a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 73e:	75 07                	jne    747 <morecore+0x38>
    return 0;
 740:	b8 00 00 00 00       	mov    $0x0,%eax
 745:	eb 26                	jmp    76d <morecore+0x5e>
  hp = (Header*)p;
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 750:	8b 55 08             	mov    0x8(%ebp),%edx
 753:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	83 c0 08             	add    $0x8,%eax
 75c:	83 ec 0c             	sub    $0xc,%esp
 75f:	50                   	push   %eax
 760:	e8 c9 fe ff ff       	call   62e <free>
 765:	83 c4 10             	add    $0x10,%esp
  return freep;
 768:	a1 e8 0a 00 00       	mov    0xae8,%eax
}
 76d:	c9                   	leave  
 76e:	c3                   	ret    

0000076f <malloc>:

void*
malloc(uint nbytes)
{
 76f:	55                   	push   %ebp
 770:	89 e5                	mov    %esp,%ebp
 772:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 775:	8b 45 08             	mov    0x8(%ebp),%eax
 778:	83 c0 07             	add    $0x7,%eax
 77b:	c1 e8 03             	shr    $0x3,%eax
 77e:	40                   	inc    %eax
 77f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 782:	a1 e8 0a 00 00       	mov    0xae8,%eax
 787:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78e:	75 23                	jne    7b3 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 790:	c7 45 f0 e0 0a 00 00 	movl   $0xae0,-0x10(%ebp)
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	a3 e8 0a 00 00       	mov    %eax,0xae8
 79f:	a1 e8 0a 00 00       	mov    0xae8,%eax
 7a4:	a3 e0 0a 00 00       	mov    %eax,0xae0
    base.s.size = 0;
 7a9:	c7 05 e4 0a 00 00 00 	movl   $0x0,0xae4
 7b0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c4:	72 4d                	jb     813 <malloc+0xa4>
      if(p->s.size == nunits)
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cf:	75 0c                	jne    7dd <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 10                	mov    (%eax),%edx
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	89 10                	mov    %edx,(%eax)
 7db:	eb 26                	jmp    803 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 40 04             	mov    0x4(%eax),%eax
 7e3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7e6:	89 c2                	mov    %eax,%edx
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	c1 e0 03             	shl    $0x3,%eax
 7f7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 800:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	a3 e8 0a 00 00       	mov    %eax,0xae8
      return (void*)(p + 1);
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	83 c0 08             	add    $0x8,%eax
 811:	eb 3b                	jmp    84e <malloc+0xdf>
    }
    if(p == freep)
 813:	a1 e8 0a 00 00       	mov    0xae8,%eax
 818:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81b:	75 1e                	jne    83b <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 81d:	83 ec 0c             	sub    $0xc,%esp
 820:	ff 75 ec             	pushl  -0x14(%ebp)
 823:	e8 e7 fe ff ff       	call   70f <morecore>
 828:	83 c4 10             	add    $0x10,%esp
 82b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 832:	75 07                	jne    83b <malloc+0xcc>
        return 0;
 834:	b8 00 00 00 00       	mov    $0x0,%eax
 839:	eb 13                	jmp    84e <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 849:	e9 6d ff ff ff       	jmp    7bb <malloc+0x4c>
}
 84e:	c9                   	leave  
 84f:	c3                   	ret    

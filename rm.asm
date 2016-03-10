
_rm:     file format elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 7d 08 00 00       	push   $0x87d
  21:	6a 02                	push   $0x2
  23:	e8 7a 04 00 00       	call   4a2 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 9d 02 00 00       	call   2cd <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4a                	jmp    83 <main+0x83>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 ca 02 00 00       	call   31d <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 91 08 00 00       	push   $0x891
  74:	6a 02                	push   $0x2
  76:	e8 27 04 00 00       	call   4a2 <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0a                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  80:	ff 45 f4             	incl   -0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 03                	cmp    (%ebx),%eax
  88:	7c af                	jl     39 <main+0x39>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  8a:	e8 3e 02 00 00       	call   2cd <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c0:	90                   	nop
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	8d 50 01             	lea    0x1(%eax),%edx
  c7:	89 55 08             	mov    %edx,0x8(%ebp)
  ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d3:	8a 12                	mov    (%edx),%dl
  d5:	88 10                	mov    %dl,(%eax)
  d7:	8a 00                	mov    (%eax),%al
  d9:	84 c0                	test   %al,%al
  db:	75 e4                	jne    c1 <strcpy+0xd>
    ;
  return os;
  dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e0:	c9                   	leave  
  e1:	c3                   	ret    

000000e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e5:	eb 06                	jmp    ed <strcmp+0xb>
    p++, q++;
  e7:	ff 45 08             	incl   0x8(%ebp)
  ea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8a 00                	mov    (%eax),%al
  f2:	84 c0                	test   %al,%al
  f4:	74 0e                	je     104 <strcmp+0x22>
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	8a 10                	mov    (%eax),%dl
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	8a 00                	mov    (%eax),%al
 100:	38 c2                	cmp    %al,%dl
 102:	74 e3                	je     e7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8a 00                	mov    (%eax),%al
 109:	0f b6 d0             	movzbl %al,%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	8a 00                	mov    (%eax),%al
 111:	0f b6 c0             	movzbl %al,%eax
 114:	29 c2                	sub    %eax,%edx
 116:	89 d0                	mov    %edx,%eax
}
 118:	5d                   	pop    %ebp
 119:	c3                   	ret    

0000011a <strlen>:

uint
strlen(char *s)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 127:	eb 03                	jmp    12c <strlen+0x12>
 129:	ff 45 fc             	incl   -0x4(%ebp)
 12c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	01 d0                	add    %edx,%eax
 134:	8a 00                	mov    (%eax),%al
 136:	84 c0                	test   %al,%al
 138:	75 ef                	jne    129 <strlen+0xf>
    ;
  return n;
 13a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13d:	c9                   	leave  
 13e:	c3                   	ret    

0000013f <memset>:

void*
memset(void *dst, int c, uint n)
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 142:	8b 45 10             	mov    0x10(%ebp),%eax
 145:	50                   	push   %eax
 146:	ff 75 0c             	pushl  0xc(%ebp)
 149:	ff 75 08             	pushl  0x8(%ebp)
 14c:	e8 3e ff ff ff       	call   8f <stosb>
 151:	83 c4 0c             	add    $0xc,%esp
  return dst;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <strchr>:

char*
strchr(const char *s, char c)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 04             	sub    $0x4,%esp
 15f:	8b 45 0c             	mov    0xc(%ebp),%eax
 162:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 165:	eb 12                	jmp    179 <strchr+0x20>
    if(*s == c)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	8a 00                	mov    (%eax),%al
 16c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16f:	75 05                	jne    176 <strchr+0x1d>
      return (char*)s;
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	eb 11                	jmp    187 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 176:	ff 45 08             	incl   0x8(%ebp)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	8a 00                	mov    (%eax),%al
 17e:	84 c0                	test   %al,%al
 180:	75 e5                	jne    167 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 182:	b8 00 00 00 00       	mov    $0x0,%eax
}
 187:	c9                   	leave  
 188:	c3                   	ret    

00000189 <gets>:

char*
gets(char *buf, int max)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 196:	eb 41                	jmp    1d9 <gets+0x50>
    cc = read(0, &c, 1);
 198:	83 ec 04             	sub    $0x4,%esp
 19b:	6a 01                	push   $0x1
 19d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a0:	50                   	push   %eax
 1a1:	6a 00                	push   $0x0
 1a3:	e8 3d 01 00 00       	call   2e5 <read>
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b2:	7f 02                	jg     1b6 <gets+0x2d>
      break;
 1b4:	eb 2c                	jmp    1e2 <gets+0x59>
    buf[i++] = c;
 1b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b9:	8d 50 01             	lea    0x1(%eax),%edx
 1bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1bf:	89 c2                	mov    %eax,%edx
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	01 c2                	add    %eax,%edx
 1c6:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1cb:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ce:	3c 0a                	cmp    $0xa,%al
 1d0:	74 10                	je     1e2 <gets+0x59>
 1d2:	8a 45 ef             	mov    -0x11(%ebp),%al
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 09                	je     1e2 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	40                   	inc    %eax
 1dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e0:	7c b6                	jl     198 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	01 d0                	add    %edx,%eax
 1ea:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f0:	c9                   	leave  
 1f1:	c3                   	ret    

000001f2 <stat>:

int
stat(char *n, struct stat *st)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f8:	83 ec 08             	sub    $0x8,%esp
 1fb:	6a 00                	push   $0x0
 1fd:	ff 75 08             	pushl  0x8(%ebp)
 200:	e8 08 01 00 00       	call   30d <open>
 205:	83 c4 10             	add    $0x10,%esp
 208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20f:	79 07                	jns    218 <stat+0x26>
    return -1;
 211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 216:	eb 25                	jmp    23d <stat+0x4b>
  r = fstat(fd, st);
 218:	83 ec 08             	sub    $0x8,%esp
 21b:	ff 75 0c             	pushl  0xc(%ebp)
 21e:	ff 75 f4             	pushl  -0xc(%ebp)
 221:	e8 ff 00 00 00       	call   325 <fstat>
 226:	83 c4 10             	add    $0x10,%esp
 229:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22c:	83 ec 0c             	sub    $0xc,%esp
 22f:	ff 75 f4             	pushl  -0xc(%ebp)
 232:	e8 be 00 00 00       	call   2f5 <close>
 237:	83 c4 10             	add    $0x10,%esp
  return r;
 23a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23d:	c9                   	leave  
 23e:	c3                   	ret    

0000023f <atoi>:

int
atoi(const char *s)
{
 23f:	55                   	push   %ebp
 240:	89 e5                	mov    %esp,%ebp
 242:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24c:	eb 24                	jmp    272 <atoi+0x33>
    n = n*10 + *s++ - '0';
 24e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 251:	89 d0                	mov    %edx,%eax
 253:	c1 e0 02             	shl    $0x2,%eax
 256:	01 d0                	add    %edx,%eax
 258:	01 c0                	add    %eax,%eax
 25a:	89 c1                	mov    %eax,%ecx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	8d 50 01             	lea    0x1(%eax),%edx
 262:	89 55 08             	mov    %edx,0x8(%ebp)
 265:	8a 00                	mov    (%eax),%al
 267:	0f be c0             	movsbl %al,%eax
 26a:	01 c8                	add    %ecx,%eax
 26c:	83 e8 30             	sub    $0x30,%eax
 26f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8a 00                	mov    (%eax),%al
 277:	3c 2f                	cmp    $0x2f,%al
 279:	7e 09                	jle    284 <atoi+0x45>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	8a 00                	mov    (%eax),%al
 280:	3c 39                	cmp    $0x39,%al
 282:	7e ca                	jle    24e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 284:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 295:	8b 45 0c             	mov    0xc(%ebp),%eax
 298:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29b:	eb 16                	jmp    2b3 <memmove+0x2a>
    *dst++ = *src++;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a0:	8d 50 01             	lea    0x1(%eax),%edx
 2a3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a9:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ac:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2af:	8a 12                	mov    (%edx),%dl
 2b1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b3:	8b 45 10             	mov    0x10(%ebp),%eax
 2b6:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b9:	89 55 10             	mov    %edx,0x10(%ebp)
 2bc:	85 c0                	test   %eax,%eax
 2be:	7f dd                	jg     29d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c3:	c9                   	leave  
 2c4:	c3                   	ret    

000002c5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c5:	b8 01 00 00 00       	mov    $0x1,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <exit>:
SYSCALL(exit)
 2cd:	b8 02 00 00 00       	mov    $0x2,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <wait>:
SYSCALL(wait)
 2d5:	b8 03 00 00 00       	mov    $0x3,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <pipe>:
SYSCALL(pipe)
 2dd:	b8 04 00 00 00       	mov    $0x4,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <read>:
SYSCALL(read)
 2e5:	b8 05 00 00 00       	mov    $0x5,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <write>:
SYSCALL(write)
 2ed:	b8 10 00 00 00       	mov    $0x10,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <close>:
SYSCALL(close)
 2f5:	b8 15 00 00 00       	mov    $0x15,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <kill>:
SYSCALL(kill)
 2fd:	b8 06 00 00 00       	mov    $0x6,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <exec>:
SYSCALL(exec)
 305:	b8 07 00 00 00       	mov    $0x7,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <open>:
SYSCALL(open)
 30d:	b8 0f 00 00 00       	mov    $0xf,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <mknod>:
SYSCALL(mknod)
 315:	b8 11 00 00 00       	mov    $0x11,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <unlink>:
SYSCALL(unlink)
 31d:	b8 12 00 00 00       	mov    $0x12,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <fstat>:
SYSCALL(fstat)
 325:	b8 08 00 00 00       	mov    $0x8,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <link>:
SYSCALL(link)
 32d:	b8 13 00 00 00       	mov    $0x13,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <mkdir>:
SYSCALL(mkdir)
 335:	b8 14 00 00 00       	mov    $0x14,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <chdir>:
SYSCALL(chdir)
 33d:	b8 09 00 00 00       	mov    $0x9,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <dup>:
SYSCALL(dup)
 345:	b8 0a 00 00 00       	mov    $0xa,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <getpid>:
SYSCALL(getpid)
 34d:	b8 0b 00 00 00       	mov    $0xb,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <sbrk>:
SYSCALL(sbrk)
 355:	b8 0c 00 00 00       	mov    $0xc,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <sleep>:
SYSCALL(sleep)
 35d:	b8 0d 00 00 00       	mov    $0xd,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <uptime>:
SYSCALL(uptime)
 365:	b8 0e 00 00 00       	mov    $0xe,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <gettime>:
SYSCALL(gettime)
 36d:	b8 16 00 00 00       	mov    $0x16,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <settickets>:
SYSCALL(settickets)
 375:	b8 17 00 00 00       	mov    $0x17,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
 380:	83 ec 18             	sub    $0x18,%esp
 383:	8b 45 0c             	mov    0xc(%ebp),%eax
 386:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 389:	83 ec 04             	sub    $0x4,%esp
 38c:	6a 01                	push   $0x1
 38e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 391:	50                   	push   %eax
 392:	ff 75 08             	pushl  0x8(%ebp)
 395:	e8 53 ff ff ff       	call   2ed <write>
 39a:	83 c4 10             	add    $0x10,%esp
}
 39d:	c9                   	leave  
 39e:	c3                   	ret    

0000039f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	53                   	push   %ebx
 3a3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ad:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b1:	74 17                	je     3ca <printint+0x2b>
 3b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b7:	79 11                	jns    3ca <printint+0x2b>
    neg = 1;
 3b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c3:	f7 d8                	neg    %eax
 3c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c8:	eb 06                	jmp    3d0 <printint+0x31>
  } else {
    x = xx;
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3da:	8d 41 01             	lea    0x1(%ecx),%eax
 3dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e6:	ba 00 00 00 00       	mov    $0x0,%edx
 3eb:	f7 f3                	div    %ebx
 3ed:	89 d0                	mov    %edx,%eax
 3ef:	8a 80 20 0b 00 00    	mov    0xb20(%eax),%al
 3f5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ff:	ba 00 00 00 00       	mov    $0x0,%edx
 404:	f7 f3                	div    %ebx
 406:	89 45 ec             	mov    %eax,-0x14(%ebp)
 409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40d:	75 c8                	jne    3d7 <printint+0x38>
  if(neg)
 40f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 413:	74 0e                	je     423 <printint+0x84>
    buf[i++] = '-';
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	8d 50 01             	lea    0x1(%eax),%edx
 41b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 423:	eb 1c                	jmp    441 <printint+0xa2>
    putc(fd, buf[i]);
 425:	8d 55 dc             	lea    -0x24(%ebp),%edx
 428:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	8a 00                	mov    (%eax),%al
 42f:	0f be c0             	movsbl %al,%eax
 432:	83 ec 08             	sub    $0x8,%esp
 435:	50                   	push   %eax
 436:	ff 75 08             	pushl  0x8(%ebp)
 439:	e8 3f ff ff ff       	call   37d <putc>
 43e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 441:	ff 4d f4             	decl   -0xc(%ebp)
 444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 448:	79 db                	jns    425 <printint+0x86>
    putc(fd, buf[i]);
}
 44a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 28             	sub    $0x28,%esp
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	89 45 e0             	mov    %eax,-0x20(%ebp)
 45b:	8b 45 10             	mov    0x10(%ebp),%eax
 45e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 461:	8b 45 e0             	mov    -0x20(%ebp),%eax
 464:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 467:	89 d0                	mov    %edx,%eax
 469:	31 d2                	xor    %edx,%edx
 46b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 46e:	8b 45 e0             	mov    -0x20(%ebp),%eax
 471:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 474:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 478:	74 13                	je     48d <printlong+0x3e>
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	6a 00                	push   $0x0
 47f:	6a 10                	push   $0x10
 481:	50                   	push   %eax
 482:	ff 75 08             	pushl  0x8(%ebp)
 485:	e8 15 ff ff ff       	call   39f <printint>
 48a:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 48d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 490:	6a 00                	push   $0x0
 492:	6a 10                	push   $0x10
 494:	50                   	push   %eax
 495:	ff 75 08             	pushl  0x8(%ebp)
 498:	e8 02 ff ff ff       	call   39f <printint>
 49d:	83 c4 10             	add    $0x10,%esp
}
 4a0:	c9                   	leave  
 4a1:	c3                   	ret    

000004a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4af:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b2:	83 c0 04             	add    $0x4,%eax
 4b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4bf:	e9 83 01 00 00       	jmp    647 <printf+0x1a5>
    c = fmt[i] & 0xff;
 4c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ca:	01 d0                	add    %edx,%eax
 4cc:	8a 00                	mov    (%eax),%al
 4ce:	0f be c0             	movsbl %al,%eax
 4d1:	25 ff 00 00 00       	and    $0xff,%eax
 4d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4dd:	75 2c                	jne    50b <printf+0x69>
      if(c == '%'){
 4df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e3:	75 0c                	jne    4f1 <printf+0x4f>
        state = '%';
 4e5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ec:	e9 53 01 00 00       	jmp    644 <printf+0x1a2>
      } else {
        putc(fd, c);
 4f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f4:	0f be c0             	movsbl %al,%eax
 4f7:	83 ec 08             	sub    $0x8,%esp
 4fa:	50                   	push   %eax
 4fb:	ff 75 08             	pushl  0x8(%ebp)
 4fe:	e8 7a fe ff ff       	call   37d <putc>
 503:	83 c4 10             	add    $0x10,%esp
 506:	e9 39 01 00 00       	jmp    644 <printf+0x1a2>
      }
    } else if(state == '%'){
 50b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 50f:	0f 85 2f 01 00 00    	jne    644 <printf+0x1a2>
      if(c == 'd'){
 515:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 519:	75 1e                	jne    539 <printf+0x97>
        printint(fd, *ap, 10, 1);
 51b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51e:	8b 00                	mov    (%eax),%eax
 520:	6a 01                	push   $0x1
 522:	6a 0a                	push   $0xa
 524:	50                   	push   %eax
 525:	ff 75 08             	pushl  0x8(%ebp)
 528:	e8 72 fe ff ff       	call   39f <printint>
 52d:	83 c4 10             	add    $0x10,%esp
        ap++;
 530:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 534:	e9 04 01 00 00       	jmp    63d <printf+0x19b>
      } else if(c == 'l') {
 539:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 53d:	75 29                	jne    568 <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 53f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 542:	8b 50 04             	mov    0x4(%eax),%edx
 545:	8b 00                	mov    (%eax),%eax
 547:	83 ec 0c             	sub    $0xc,%esp
 54a:	6a 00                	push   $0x0
 54c:	6a 0a                	push   $0xa
 54e:	52                   	push   %edx
 54f:	50                   	push   %eax
 550:	ff 75 08             	pushl  0x8(%ebp)
 553:	e8 f7 fe ff ff       	call   44f <printlong>
 558:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 55b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 55f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 563:	e9 d5 00 00 00       	jmp    63d <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 568:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 56c:	74 06                	je     574 <printf+0xd2>
 56e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 572:	75 1e                	jne    592 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 574:	8b 45 e8             	mov    -0x18(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	6a 00                	push   $0x0
 57b:	6a 10                	push   $0x10
 57d:	50                   	push   %eax
 57e:	ff 75 08             	pushl  0x8(%ebp)
 581:	e8 19 fe ff ff       	call   39f <printint>
 586:	83 c4 10             	add    $0x10,%esp
        ap++;
 589:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58d:	e9 ab 00 00 00       	jmp    63d <printf+0x19b>
      } else if(c == 's'){
 592:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 596:	75 40                	jne    5d8 <printf+0x136>
        s = (char*)*ap;
 598:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59b:	8b 00                	mov    (%eax),%eax
 59d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a8:	75 07                	jne    5b1 <printf+0x10f>
          s = "(null)";
 5aa:	c7 45 f4 aa 08 00 00 	movl   $0x8aa,-0xc(%ebp)
        while(*s != 0){
 5b1:	eb 1a                	jmp    5cd <printf+0x12b>
          putc(fd, *s);
 5b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b6:	8a 00                	mov    (%eax),%al
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 b6 fd ff ff       	call   37d <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
          s++;
 5ca:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d0:	8a 00                	mov    (%eax),%al
 5d2:	84 c0                	test   %al,%al
 5d4:	75 dd                	jne    5b3 <printf+0x111>
 5d6:	eb 65                	jmp    63d <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5dc:	75 1d                	jne    5fb <printf+0x159>
        putc(fd, *ap);
 5de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	83 ec 08             	sub    $0x8,%esp
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 8b fd ff ff       	call   37d <putc>
 5f2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f9:	eb 42                	jmp    63d <printf+0x19b>
      } else if(c == '%'){
 5fb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ff:	75 17                	jne    618 <printf+0x176>
        putc(fd, c);
 601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 604:	0f be c0             	movsbl %al,%eax
 607:	83 ec 08             	sub    $0x8,%esp
 60a:	50                   	push   %eax
 60b:	ff 75 08             	pushl  0x8(%ebp)
 60e:	e8 6a fd ff ff       	call   37d <putc>
 613:	83 c4 10             	add    $0x10,%esp
 616:	eb 25                	jmp    63d <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 618:	83 ec 08             	sub    $0x8,%esp
 61b:	6a 25                	push   $0x25
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 58 fd ff ff       	call   37d <putc>
 625:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	83 ec 08             	sub    $0x8,%esp
 631:	50                   	push   %eax
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	e8 43 fd ff ff       	call   37d <putc>
 63a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 63d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 644:	ff 45 f0             	incl   -0x10(%ebp)
 647:	8b 55 0c             	mov    0xc(%ebp),%edx
 64a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64d:	01 d0                	add    %edx,%eax
 64f:	8a 00                	mov    (%eax),%al
 651:	84 c0                	test   %al,%al
 653:	0f 85 6b fe ff ff    	jne    4c4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 659:	c9                   	leave  
 65a:	c3                   	ret    

0000065b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65b:	55                   	push   %ebp
 65c:	89 e5                	mov    %esp,%ebp
 65e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	83 e8 08             	sub    $0x8,%eax
 667:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66a:	a1 3c 0b 00 00       	mov    0xb3c,%eax
 66f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 672:	eb 24                	jmp    698 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67c:	77 12                	ja     690 <free+0x35>
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 684:	77 24                	ja     6aa <free+0x4f>
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68e:	77 1a                	ja     6aa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	89 45 fc             	mov    %eax,-0x4(%ebp)
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69e:	76 d4                	jbe    674 <free+0x19>
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a8:	76 ca                	jbe    674 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 40 04             	mov    0x4(%eax),%eax
 6b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	01 c2                	add    %eax,%edx
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	39 c2                	cmp    %eax,%edx
 6c3:	75 24                	jne    6e9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	8b 50 04             	mov    0x4(%eax),%edx
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	8b 40 04             	mov    0x4(%eax),%eax
 6d3:	01 c2                	add    %eax,%edx
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	8b 10                	mov    (%eax),%edx
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	89 10                	mov    %edx,(%eax)
 6e7:	eb 0a                	jmp    6f3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 10                	mov    (%eax),%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 40 04             	mov    0x4(%eax),%eax
 6f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	01 d0                	add    %edx,%eax
 705:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 708:	75 20                	jne    72a <free+0xcf>
    p->s.size += bp->s.size;
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	8b 40 04             	mov    0x4(%eax),%eax
 716:	01 c2                	add    %eax,%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	8b 10                	mov    (%eax),%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	89 10                	mov    %edx,(%eax)
 728:	eb 08                	jmp    732 <free+0xd7>
  } else
    p->s.ptr = bp;
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 730:	89 10                	mov    %edx,(%eax)
  freep = p;
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	a3 3c 0b 00 00       	mov    %eax,0xb3c
}
 73a:	c9                   	leave  
 73b:	c3                   	ret    

0000073c <morecore>:

static Header*
morecore(uint nu)
{
 73c:	55                   	push   %ebp
 73d:	89 e5                	mov    %esp,%ebp
 73f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 742:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 749:	77 07                	ja     752 <morecore+0x16>
    nu = 4096;
 74b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 752:	8b 45 08             	mov    0x8(%ebp),%eax
 755:	c1 e0 03             	shl    $0x3,%eax
 758:	83 ec 0c             	sub    $0xc,%esp
 75b:	50                   	push   %eax
 75c:	e8 f4 fb ff ff       	call   355 <sbrk>
 761:	83 c4 10             	add    $0x10,%esp
 764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 767:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 76b:	75 07                	jne    774 <morecore+0x38>
    return 0;
 76d:	b8 00 00 00 00       	mov    $0x0,%eax
 772:	eb 26                	jmp    79a <morecore+0x5e>
  hp = (Header*)p;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 77a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77d:	8b 55 08             	mov    0x8(%ebp),%edx
 780:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	83 c0 08             	add    $0x8,%eax
 789:	83 ec 0c             	sub    $0xc,%esp
 78c:	50                   	push   %eax
 78d:	e8 c9 fe ff ff       	call   65b <free>
 792:	83 c4 10             	add    $0x10,%esp
  return freep;
 795:	a1 3c 0b 00 00       	mov    0xb3c,%eax
}
 79a:	c9                   	leave  
 79b:	c3                   	ret    

0000079c <malloc>:

void*
malloc(uint nbytes)
{
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	8b 45 08             	mov    0x8(%ebp),%eax
 7a5:	83 c0 07             	add    $0x7,%eax
 7a8:	c1 e8 03             	shr    $0x3,%eax
 7ab:	40                   	inc    %eax
 7ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7af:	a1 3c 0b 00 00       	mov    0xb3c,%eax
 7b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bb:	75 23                	jne    7e0 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7bd:	c7 45 f0 34 0b 00 00 	movl   $0xb34,-0x10(%ebp)
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	a3 3c 0b 00 00       	mov    %eax,0xb3c
 7cc:	a1 3c 0b 00 00       	mov    0xb3c,%eax
 7d1:	a3 34 0b 00 00       	mov    %eax,0xb34
    base.s.size = 0;
 7d6:	c7 05 38 0b 00 00 00 	movl   $0x0,0xb38
 7dd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f1:	72 4d                	jb     840 <malloc+0xa4>
      if(p->s.size == nunits)
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fc:	75 0c                	jne    80a <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 10                	mov    (%eax),%edx
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	89 10                	mov    %edx,(%eax)
 808:	eb 26                	jmp    830 <malloc+0x94>
      else {
        p->s.size -= nunits;
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	8b 40 04             	mov    0x4(%eax),%eax
 810:	2b 45 ec             	sub    -0x14(%ebp),%eax
 813:	89 c2                	mov    %eax,%edx
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	8b 40 04             	mov    0x4(%eax),%eax
 821:	c1 e0 03             	shl    $0x3,%eax
 824:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 830:	8b 45 f0             	mov    -0x10(%ebp),%eax
 833:	a3 3c 0b 00 00       	mov    %eax,0xb3c
      return (void*)(p + 1);
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	83 c0 08             	add    $0x8,%eax
 83e:	eb 3b                	jmp    87b <malloc+0xdf>
    }
    if(p == freep)
 840:	a1 3c 0b 00 00       	mov    0xb3c,%eax
 845:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 848:	75 1e                	jne    868 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 84a:	83 ec 0c             	sub    $0xc,%esp
 84d:	ff 75 ec             	pushl  -0x14(%ebp)
 850:	e8 e7 fe ff ff       	call   73c <morecore>
 855:	83 c4 10             	add    $0x10,%esp
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85f:	75 07                	jne    868 <malloc+0xcc>
        return 0;
 861:	b8 00 00 00 00       	mov    $0x0,%eax
 866:	eb 13                	jmp    87b <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 876:	e9 6d ff ff ff       	jmp    7e8 <malloc+0x4c>
}
 87b:	c9                   	leave  
 87c:	c3                   	ret    


_lotterytest:     file format elf32-i386


Disassembly of section .text:

00000000 <spin>:
#include "types.h"
#include "user.h"
#include "date.h"

// Do some useless computations
void spin(int tix) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
    struct rtcdate end;
    unsigned x = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    unsigned y = 0;
   d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while (x < 100000) { // Changed from 100000
  14:	eb 18                	jmp    2e <spin+0x2e>
        y = 0;
  16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (y < 10000) {
  1d:	eb 03                	jmp    22 <spin+0x22>
            y++;
  1f:	ff 45 f0             	incl   -0x10(%ebp)
    struct rtcdate end;
    unsigned x = 0;
    unsigned y = 0;
    while (x < 100000) { // Changed from 100000
        y = 0;
        while (y < 10000) {
  22:	81 7d f0 0f 27 00 00 	cmpl   $0x270f,-0x10(%ebp)
  29:	76 f4                	jbe    1f <spin+0x1f>
            y++;
        }
        x++;
  2b:	ff 45 f4             	incl   -0xc(%ebp)
// Do some useless computations
void spin(int tix) {
    struct rtcdate end;
    unsigned x = 0;
    unsigned y = 0;
    while (x < 100000) { // Changed from 100000
  2e:	81 7d f4 9f 86 01 00 	cmpl   $0x1869f,-0xc(%ebp)
  35:	76 df                	jbe    16 <spin+0x16>
            y++;
        }
        x++;
    }

    gettime(&end);
  37:	83 ec 0c             	sub    $0xc,%esp
  3a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  3d:	50                   	push   %eax
  3e:	e8 ab 03 00 00       	call   3ee <gettime>
  43:	83 c4 10             	add    $0x10,%esp
    printf(0, "spin with %d tickets ended at %d hours %d minutes %d seconds\n", tix, end.hour, end.minute, end.second);
  46:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  4f:	83 ec 08             	sub    $0x8,%esp
  52:	51                   	push   %ecx
  53:	52                   	push   %edx
  54:	50                   	push   %eax
  55:	ff 75 08             	pushl  0x8(%ebp)
  58:	68 00 09 00 00       	push   $0x900
  5d:	6a 00                	push   $0x0
  5f:	e8 bf 04 00 00       	call   523 <printf>
  64:	83 c4 20             	add    $0x20,%esp
}
  67:	c9                   	leave  
  68:	c3                   	ret    

00000069 <main>:

int main() {
  69:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  6d:	83 e4 f0             	and    $0xfffffff0,%esp
  70:	ff 71 fc             	pushl  -0x4(%ecx)
  73:	55                   	push   %ebp
  74:	89 e5                	mov    %esp,%ebp
  76:	51                   	push   %ecx
  77:	83 ec 24             	sub    $0x24,%esp
    int pid1;
    int pid2;
    struct rtcdate start;
    gettime(&start);
  7a:	83 ec 0c             	sub    $0xc,%esp
  7d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80:	50                   	push   %eax
  81:	e8 68 03 00 00       	call   3ee <gettime>
  86:	83 c4 10             	add    $0x10,%esp
    printf(0, "starting test at %d hours %d minutes %d seconds\n", start.hour, start.minute, start.second);
  89:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  92:	83 ec 0c             	sub    $0xc,%esp
  95:	51                   	push   %ecx
  96:	52                   	push   %edx
  97:	50                   	push   %eax
  98:	68 40 09 00 00       	push   $0x940
  9d:	6a 00                	push   $0x0
  9f:	e8 7f 04 00 00       	call   523 <printf>
  a4:	83 c4 20             	add    $0x20,%esp
    if ((pid1 = fork()) == 0) {
  a7:	e8 9a 02 00 00       	call   346 <fork>
  ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  b3:	75 1f                	jne    d4 <main+0x6b>
        settickets(20);
  b5:	83 ec 0c             	sub    $0xc,%esp
  b8:	6a 14                	push   $0x14
  ba:	e8 37 03 00 00       	call   3f6 <settickets>
  bf:	83 c4 10             	add    $0x10,%esp
        spin(20);
  c2:	83 ec 0c             	sub    $0xc,%esp
  c5:	6a 14                	push   $0x14
  c7:	e8 34 ff ff ff       	call   0 <spin>
  cc:	83 c4 10             	add    $0x10,%esp
        exit();
  cf:	e8 7a 02 00 00       	call   34e <exit>
    }
    else if ((pid2 = fork()) == 0) {
  d4:	e8 6d 02 00 00       	call   346 <fork>
  d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  e0:	75 1f                	jne    101 <main+0x98>
        settickets(80);
  e2:	83 ec 0c             	sub    $0xc,%esp
  e5:	6a 50                	push   $0x50
  e7:	e8 0a 03 00 00       	call   3f6 <settickets>
  ec:	83 c4 10             	add    $0x10,%esp
        spin(80);
  ef:	83 ec 0c             	sub    $0xc,%esp
  f2:	6a 50                	push   $0x50
  f4:	e8 07 ff ff ff       	call   0 <spin>
  f9:	83 c4 10             	add    $0x10,%esp
        exit();
  fc:	e8 4d 02 00 00       	call   34e <exit>
    }
    // Go to sleep and wait for subprocesses to finish
    wait();
 101:	e8 50 02 00 00       	call   356 <wait>
    wait();
 106:	e8 4b 02 00 00       	call   356 <wait>
    exit();
 10b:	e8 3e 02 00 00       	call   34e <exit>

00000110 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 55 10             	mov    0x10(%ebp),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	89 cb                	mov    %ecx,%ebx
 120:	89 df                	mov    %ebx,%edi
 122:	89 d1                	mov    %edx,%ecx
 124:	fc                   	cld    
 125:	f3 aa                	rep stos %al,%es:(%edi)
 127:	89 ca                	mov    %ecx,%edx
 129:	89 fb                	mov    %edi,%ebx
 12b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	8a 12                	mov    (%edx),%dl
 156:	88 10                	mov    %dl,(%eax)
 158:	8a 00                	mov    (%eax),%al
 15a:	84 c0                	test   %al,%al
 15c:	75 e4                	jne    142 <strcpy+0xd>
    ;
  return os;
 15e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 161:	c9                   	leave  
 162:	c3                   	ret    

00000163 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 166:	eb 06                	jmp    16e <strcmp+0xb>
    p++, q++;
 168:	ff 45 08             	incl   0x8(%ebp)
 16b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	8a 00                	mov    (%eax),%al
 173:	84 c0                	test   %al,%al
 175:	74 0e                	je     185 <strcmp+0x22>
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	8a 10                	mov    (%eax),%dl
 17c:	8b 45 0c             	mov    0xc(%ebp),%eax
 17f:	8a 00                	mov    (%eax),%al
 181:	38 c2                	cmp    %al,%dl
 183:	74 e3                	je     168 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8a 00                	mov    (%eax),%al
 18a:	0f b6 d0             	movzbl %al,%edx
 18d:	8b 45 0c             	mov    0xc(%ebp),%eax
 190:	8a 00                	mov    (%eax),%al
 192:	0f b6 c0             	movzbl %al,%eax
 195:	29 c2                	sub    %eax,%edx
 197:	89 d0                	mov    %edx,%eax
}
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    

0000019b <strlen>:

uint
strlen(char *s)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a8:	eb 03                	jmp    1ad <strlen+0x12>
 1aa:	ff 45 fc             	incl   -0x4(%ebp)
 1ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b0:	8b 45 08             	mov    0x8(%ebp),%eax
 1b3:	01 d0                	add    %edx,%eax
 1b5:	8a 00                	mov    (%eax),%al
 1b7:	84 c0                	test   %al,%al
 1b9:	75 ef                	jne    1aa <strlen+0xf>
    ;
  return n;
 1bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1be:	c9                   	leave  
 1bf:	c3                   	ret    

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c3:	8b 45 10             	mov    0x10(%ebp),%eax
 1c6:	50                   	push   %eax
 1c7:	ff 75 0c             	pushl  0xc(%ebp)
 1ca:	ff 75 08             	pushl  0x8(%ebp)
 1cd:	e8 3e ff ff ff       	call   110 <stosb>
 1d2:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d8:	c9                   	leave  
 1d9:	c3                   	ret    

000001da <strchr>:

char*
strchr(const char *s, char c)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 04             	sub    $0x4,%esp
 1e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e6:	eb 12                	jmp    1fa <strchr+0x20>
    if(*s == c)
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	8a 00                	mov    (%eax),%al
 1ed:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f0:	75 05                	jne    1f7 <strchr+0x1d>
      return (char*)s;
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	eb 11                	jmp    208 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f7:	ff 45 08             	incl   0x8(%ebp)
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	8a 00                	mov    (%eax),%al
 1ff:	84 c0                	test   %al,%al
 201:	75 e5                	jne    1e8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 41                	jmp    25a <gets+0x50>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 3d 01 00 00       	call   366 <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7f 02                	jg     237 <gets+0x2d>
      break;
 235:	eb 2c                	jmp    263 <gets+0x59>
    buf[i++] = c;
 237:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23a:	8d 50 01             	lea    0x1(%eax),%edx
 23d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 240:	89 c2                	mov    %eax,%edx
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	01 c2                	add    %eax,%edx
 247:	8a 45 ef             	mov    -0x11(%ebp),%al
 24a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24c:	8a 45 ef             	mov    -0x11(%ebp),%al
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 10                	je     263 <gets+0x59>
 253:	8a 45 ef             	mov    -0x11(%ebp),%al
 256:	3c 0d                	cmp    $0xd,%al
 258:	74 09                	je     263 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25d:	40                   	inc    %eax
 25e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 261:	7c b6                	jl     219 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 263:	8b 55 f4             	mov    -0xc(%ebp),%edx
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	01 d0                	add    %edx,%eax
 26b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <stat>:

int
stat(char *n, struct stat *st)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	6a 00                	push   $0x0
 27e:	ff 75 08             	pushl  0x8(%ebp)
 281:	e8 08 01 00 00       	call   38e <open>
 286:	83 c4 10             	add    $0x10,%esp
 289:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 290:	79 07                	jns    299 <stat+0x26>
    return -1;
 292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 297:	eb 25                	jmp    2be <stat+0x4b>
  r = fstat(fd, st);
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	ff 75 0c             	pushl  0xc(%ebp)
 29f:	ff 75 f4             	pushl  -0xc(%ebp)
 2a2:	e8 ff 00 00 00       	call   3a6 <fstat>
 2a7:	83 c4 10             	add    $0x10,%esp
 2aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ad:	83 ec 0c             	sub    $0xc,%esp
 2b0:	ff 75 f4             	pushl  -0xc(%ebp)
 2b3:	e8 be 00 00 00       	call   376 <close>
 2b8:	83 c4 10             	add    $0x10,%esp
  return r;
 2bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2be:	c9                   	leave  
 2bf:	c3                   	ret    

000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cd:	eb 24                	jmp    2f3 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d2:	89 d0                	mov    %edx,%eax
 2d4:	c1 e0 02             	shl    $0x2,%eax
 2d7:	01 d0                	add    %edx,%eax
 2d9:	01 c0                	add    %eax,%eax
 2db:	89 c1                	mov    %eax,%ecx
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 08             	mov    %edx,0x8(%ebp)
 2e6:	8a 00                	mov    (%eax),%al
 2e8:	0f be c0             	movsbl %al,%eax
 2eb:	01 c8                	add    %ecx,%eax
 2ed:	83 e8 30             	sub    $0x30,%eax
 2f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	8a 00                	mov    (%eax),%al
 2f8:	3c 2f                	cmp    $0x2f,%al
 2fa:	7e 09                	jle    305 <atoi+0x45>
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	8a 00                	mov    (%eax),%al
 301:	3c 39                	cmp    $0x39,%al
 303:	7e ca                	jle    2cf <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 305:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 308:	c9                   	leave  
 309:	c3                   	ret    

0000030a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp
 30d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 316:	8b 45 0c             	mov    0xc(%ebp),%eax
 319:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31c:	eb 16                	jmp    334 <memmove+0x2a>
    *dst++ = *src++;
 31e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 321:	8d 50 01             	lea    0x1(%eax),%edx
 324:	89 55 fc             	mov    %edx,-0x4(%ebp)
 327:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32a:	8d 4a 01             	lea    0x1(%edx),%ecx
 32d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 330:	8a 12                	mov    (%edx),%dl
 332:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 334:	8b 45 10             	mov    0x10(%ebp),%eax
 337:	8d 50 ff             	lea    -0x1(%eax),%edx
 33a:	89 55 10             	mov    %edx,0x10(%ebp)
 33d:	85 c0                	test   %eax,%eax
 33f:	7f dd                	jg     31e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 341:	8b 45 08             	mov    0x8(%ebp),%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 346:	b8 01 00 00 00       	mov    $0x1,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <exit>:
SYSCALL(exit)
 34e:	b8 02 00 00 00       	mov    $0x2,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <wait>:
SYSCALL(wait)
 356:	b8 03 00 00 00       	mov    $0x3,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <pipe>:
SYSCALL(pipe)
 35e:	b8 04 00 00 00       	mov    $0x4,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <read>:
SYSCALL(read)
 366:	b8 05 00 00 00       	mov    $0x5,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <write>:
SYSCALL(write)
 36e:	b8 10 00 00 00       	mov    $0x10,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <close>:
SYSCALL(close)
 376:	b8 15 00 00 00       	mov    $0x15,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <kill>:
SYSCALL(kill)
 37e:	b8 06 00 00 00       	mov    $0x6,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <exec>:
SYSCALL(exec)
 386:	b8 07 00 00 00       	mov    $0x7,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <open>:
SYSCALL(open)
 38e:	b8 0f 00 00 00       	mov    $0xf,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <mknod>:
SYSCALL(mknod)
 396:	b8 11 00 00 00       	mov    $0x11,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <unlink>:
SYSCALL(unlink)
 39e:	b8 12 00 00 00       	mov    $0x12,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <fstat>:
SYSCALL(fstat)
 3a6:	b8 08 00 00 00       	mov    $0x8,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <link>:
SYSCALL(link)
 3ae:	b8 13 00 00 00       	mov    $0x13,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <mkdir>:
SYSCALL(mkdir)
 3b6:	b8 14 00 00 00       	mov    $0x14,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <chdir>:
SYSCALL(chdir)
 3be:	b8 09 00 00 00       	mov    $0x9,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <dup>:
SYSCALL(dup)
 3c6:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <getpid>:
SYSCALL(getpid)
 3ce:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <sbrk>:
SYSCALL(sbrk)
 3d6:	b8 0c 00 00 00       	mov    $0xc,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <sleep>:
SYSCALL(sleep)
 3de:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <uptime>:
SYSCALL(uptime)
 3e6:	b8 0e 00 00 00       	mov    $0xe,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <gettime>:
SYSCALL(gettime)
 3ee:	b8 16 00 00 00       	mov    $0x16,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <settickets>:
SYSCALL(settickets)
 3f6:	b8 17 00 00 00       	mov    $0x17,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 18             	sub    $0x18,%esp
 404:	8b 45 0c             	mov    0xc(%ebp),%eax
 407:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 40a:	83 ec 04             	sub    $0x4,%esp
 40d:	6a 01                	push   $0x1
 40f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 412:	50                   	push   %eax
 413:	ff 75 08             	pushl  0x8(%ebp)
 416:	e8 53 ff ff ff       	call   36e <write>
 41b:	83 c4 10             	add    $0x10,%esp
}
 41e:	c9                   	leave  
 41f:	c3                   	ret    

00000420 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	53                   	push   %ebx
 424:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 427:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 432:	74 17                	je     44b <printint+0x2b>
 434:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 438:	79 11                	jns    44b <printint+0x2b>
    neg = 1;
 43a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	f7 d8                	neg    %eax
 446:	89 45 ec             	mov    %eax,-0x14(%ebp)
 449:	eb 06                	jmp    451 <printint+0x31>
  } else {
    x = xx;
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 458:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 45b:	8d 41 01             	lea    0x1(%ecx),%eax
 45e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 461:	8b 5d 10             	mov    0x10(%ebp),%ebx
 464:	8b 45 ec             	mov    -0x14(%ebp),%eax
 467:	ba 00 00 00 00       	mov    $0x0,%edx
 46c:	f7 f3                	div    %ebx
 46e:	89 d0                	mov    %edx,%eax
 470:	8a 80 00 0c 00 00    	mov    0xc00(%eax),%al
 476:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 47a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 480:	ba 00 00 00 00       	mov    $0x0,%edx
 485:	f7 f3                	div    %ebx
 487:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48e:	75 c8                	jne    458 <printint+0x38>
  if(neg)
 490:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 494:	74 0e                	je     4a4 <printint+0x84>
    buf[i++] = '-';
 496:	8b 45 f4             	mov    -0xc(%ebp),%eax
 499:	8d 50 01             	lea    0x1(%eax),%edx
 49c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a4:	eb 1c                	jmp    4c2 <printint+0xa2>
    putc(fd, buf[i]);
 4a6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ac:	01 d0                	add    %edx,%eax
 4ae:	8a 00                	mov    (%eax),%al
 4b0:	0f be c0             	movsbl %al,%eax
 4b3:	83 ec 08             	sub    $0x8,%esp
 4b6:	50                   	push   %eax
 4b7:	ff 75 08             	pushl  0x8(%ebp)
 4ba:	e8 3f ff ff ff       	call   3fe <putc>
 4bf:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c2:	ff 4d f4             	decl   -0xc(%ebp)
 4c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c9:	79 db                	jns    4a6 <printint+0x86>
    putc(fd, buf[i]);
}
 4cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ce:	c9                   	leave  
 4cf:	c3                   	ret    

000004d0 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	83 ec 28             	sub    $0x28,%esp
 4d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 4dc:	8b 45 10             	mov    0x10(%ebp),%eax
 4df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 4e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4e8:	89 d0                	mov    %edx,%eax
 4ea:	31 d2                	xor    %edx,%edx
 4ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 4ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 4f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f9:	74 13                	je     50e <printlong+0x3e>
 4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fe:	6a 00                	push   $0x0
 500:	6a 10                	push   $0x10
 502:	50                   	push   %eax
 503:	ff 75 08             	pushl  0x8(%ebp)
 506:	e8 15 ff ff ff       	call   420 <printint>
 50b:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 50e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 511:	6a 00                	push   $0x0
 513:	6a 10                	push   $0x10
 515:	50                   	push   %eax
 516:	ff 75 08             	pushl  0x8(%ebp)
 519:	e8 02 ff ff ff       	call   420 <printint>
 51e:	83 c4 10             	add    $0x10,%esp
}
 521:	c9                   	leave  
 522:	c3                   	ret    

00000523 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 523:	55                   	push   %ebp
 524:	89 e5                	mov    %esp,%ebp
 526:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 529:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 530:	8d 45 0c             	lea    0xc(%ebp),%eax
 533:	83 c0 04             	add    $0x4,%eax
 536:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 540:	e9 83 01 00 00       	jmp    6c8 <printf+0x1a5>
    c = fmt[i] & 0xff;
 545:	8b 55 0c             	mov    0xc(%ebp),%edx
 548:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54b:	01 d0                	add    %edx,%eax
 54d:	8a 00                	mov    (%eax),%al
 54f:	0f be c0             	movsbl %al,%eax
 552:	25 ff 00 00 00       	and    $0xff,%eax
 557:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55e:	75 2c                	jne    58c <printf+0x69>
      if(c == '%'){
 560:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 564:	75 0c                	jne    572 <printf+0x4f>
        state = '%';
 566:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56d:	e9 53 01 00 00       	jmp    6c5 <printf+0x1a2>
      } else {
        putc(fd, c);
 572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	50                   	push   %eax
 57c:	ff 75 08             	pushl  0x8(%ebp)
 57f:	e8 7a fe ff ff       	call   3fe <putc>
 584:	83 c4 10             	add    $0x10,%esp
 587:	e9 39 01 00 00       	jmp    6c5 <printf+0x1a2>
      }
    } else if(state == '%'){
 58c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 590:	0f 85 2f 01 00 00    	jne    6c5 <printf+0x1a2>
      if(c == 'd'){
 596:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59a:	75 1e                	jne    5ba <printf+0x97>
        printint(fd, *ap, 10, 1);
 59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	6a 01                	push   $0x1
 5a3:	6a 0a                	push   $0xa
 5a5:	50                   	push   %eax
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 72 fe ff ff       	call   420 <printint>
 5ae:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b5:	e9 04 01 00 00       	jmp    6be <printf+0x19b>
      } else if(c == 'l') {
 5ba:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 5be:	75 29                	jne    5e9 <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 50 04             	mov    0x4(%eax),%edx
 5c6:	8b 00                	mov    (%eax),%eax
 5c8:	83 ec 0c             	sub    $0xc,%esp
 5cb:	6a 00                	push   $0x0
 5cd:	6a 0a                	push   $0xa
 5cf:	52                   	push   %edx
 5d0:	50                   	push   %eax
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 f7 fe ff ff       	call   4d0 <printlong>
 5d9:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 5dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 5e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e4:	e9 d5 00 00 00       	jmp    6be <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 5e9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ed:	74 06                	je     5f5 <printf+0xd2>
 5ef:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f3:	75 1e                	jne    613 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 5f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	6a 00                	push   $0x0
 5fc:	6a 10                	push   $0x10
 5fe:	50                   	push   %eax
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 19 fe ff ff       	call   420 <printint>
 607:	83 c4 10             	add    $0x10,%esp
        ap++;
 60a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60e:	e9 ab 00 00 00       	jmp    6be <printf+0x19b>
      } else if(c == 's'){
 613:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 617:	75 40                	jne    659 <printf+0x136>
        s = (char*)*ap;
 619:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 621:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 629:	75 07                	jne    632 <printf+0x10f>
          s = "(null)";
 62b:	c7 45 f4 71 09 00 00 	movl   $0x971,-0xc(%ebp)
        while(*s != 0){
 632:	eb 1a                	jmp    64e <printf+0x12b>
          putc(fd, *s);
 634:	8b 45 f4             	mov    -0xc(%ebp),%eax
 637:	8a 00                	mov    (%eax),%al
 639:	0f be c0             	movsbl %al,%eax
 63c:	83 ec 08             	sub    $0x8,%esp
 63f:	50                   	push   %eax
 640:	ff 75 08             	pushl  0x8(%ebp)
 643:	e8 b6 fd ff ff       	call   3fe <putc>
 648:	83 c4 10             	add    $0x10,%esp
          s++;
 64b:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 651:	8a 00                	mov    (%eax),%al
 653:	84 c0                	test   %al,%al
 655:	75 dd                	jne    634 <printf+0x111>
 657:	eb 65                	jmp    6be <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 659:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65d:	75 1d                	jne    67c <printf+0x159>
        putc(fd, *ap);
 65f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	0f be c0             	movsbl %al,%eax
 667:	83 ec 08             	sub    $0x8,%esp
 66a:	50                   	push   %eax
 66b:	ff 75 08             	pushl  0x8(%ebp)
 66e:	e8 8b fd ff ff       	call   3fe <putc>
 673:	83 c4 10             	add    $0x10,%esp
        ap++;
 676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67a:	eb 42                	jmp    6be <printf+0x19b>
      } else if(c == '%'){
 67c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 680:	75 17                	jne    699 <printf+0x176>
        putc(fd, c);
 682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 685:	0f be c0             	movsbl %al,%eax
 688:	83 ec 08             	sub    $0x8,%esp
 68b:	50                   	push   %eax
 68c:	ff 75 08             	pushl  0x8(%ebp)
 68f:	e8 6a fd ff ff       	call   3fe <putc>
 694:	83 c4 10             	add    $0x10,%esp
 697:	eb 25                	jmp    6be <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	6a 25                	push   $0x25
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 58 fd ff ff       	call   3fe <putc>
 6a6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ac:	0f be c0             	movsbl %al,%eax
 6af:	83 ec 08             	sub    $0x8,%esp
 6b2:	50                   	push   %eax
 6b3:	ff 75 08             	pushl  0x8(%ebp)
 6b6:	e8 43 fd ff ff       	call   3fe <putc>
 6bb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c5:	ff 45 f0             	incl   -0x10(%ebp)
 6c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 6cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ce:	01 d0                	add    %edx,%eax
 6d0:	8a 00                	mov    (%eax),%al
 6d2:	84 c0                	test   %al,%al
 6d4:	0f 85 6b fe ff ff    	jne    545 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6da:	c9                   	leave  
 6db:	c3                   	ret    

000006dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6dc:	55                   	push   %ebp
 6dd:	89 e5                	mov    %esp,%ebp
 6df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	83 e8 08             	sub    $0x8,%eax
 6e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6eb:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 6f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f3:	eb 24                	jmp    719 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fd:	77 12                	ja     711 <free+0x35>
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 705:	77 24                	ja     72b <free+0x4f>
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70f:	77 1a                	ja     72b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	89 45 fc             	mov    %eax,-0x4(%ebp)
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71f:	76 d4                	jbe    6f5 <free+0x19>
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 729:	76 ca                	jbe    6f5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	8b 40 04             	mov    0x4(%eax),%eax
 731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 738:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73b:	01 c2                	add    %eax,%edx
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	39 c2                	cmp    %eax,%edx
 744:	75 24                	jne    76a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	8b 50 04             	mov    0x4(%eax),%edx
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 40 04             	mov    0x4(%eax),%eax
 754:	01 c2                	add    %eax,%edx
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
 768:	eb 0a                	jmp    774 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 10                	mov    (%eax),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	01 d0                	add    %edx,%eax
 786:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 789:	75 20                	jne    7ab <free+0xcf>
    p->s.size += bp->s.size;
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 50 04             	mov    0x4(%eax),%edx
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	8b 40 04             	mov    0x4(%eax),%eax
 797:	01 c2                	add    %eax,%edx
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	8b 10                	mov    (%eax),%edx
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	89 10                	mov    %edx,(%eax)
 7a9:	eb 08                	jmp    7b3 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	a3 1c 0c 00 00       	mov    %eax,0xc1c
}
 7bb:	c9                   	leave  
 7bc:	c3                   	ret    

000007bd <morecore>:

static Header*
morecore(uint nu)
{
 7bd:	55                   	push   %ebp
 7be:	89 e5                	mov    %esp,%ebp
 7c0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ca:	77 07                	ja     7d3 <morecore+0x16>
    nu = 4096;
 7cc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d3:	8b 45 08             	mov    0x8(%ebp),%eax
 7d6:	c1 e0 03             	shl    $0x3,%eax
 7d9:	83 ec 0c             	sub    $0xc,%esp
 7dc:	50                   	push   %eax
 7dd:	e8 f4 fb ff ff       	call   3d6 <sbrk>
 7e2:	83 c4 10             	add    $0x10,%esp
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ec:	75 07                	jne    7f5 <morecore+0x38>
    return 0;
 7ee:	b8 00 00 00 00       	mov    $0x0,%eax
 7f3:	eb 26                	jmp    81b <morecore+0x5e>
  hp = (Header*)p;
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fe:	8b 55 08             	mov    0x8(%ebp),%edx
 801:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	83 c0 08             	add    $0x8,%eax
 80a:	83 ec 0c             	sub    $0xc,%esp
 80d:	50                   	push   %eax
 80e:	e8 c9 fe ff ff       	call   6dc <free>
 813:	83 c4 10             	add    $0x10,%esp
  return freep;
 816:	a1 1c 0c 00 00       	mov    0xc1c,%eax
}
 81b:	c9                   	leave  
 81c:	c3                   	ret    

0000081d <malloc>:

void*
malloc(uint nbytes)
{
 81d:	55                   	push   %ebp
 81e:	89 e5                	mov    %esp,%ebp
 820:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 823:	8b 45 08             	mov    0x8(%ebp),%eax
 826:	83 c0 07             	add    $0x7,%eax
 829:	c1 e8 03             	shr    $0x3,%eax
 82c:	40                   	inc    %eax
 82d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 830:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 835:	89 45 f0             	mov    %eax,-0x10(%ebp)
 838:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83c:	75 23                	jne    861 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 83e:	c7 45 f0 14 0c 00 00 	movl   $0xc14,-0x10(%ebp)
 845:	8b 45 f0             	mov    -0x10(%ebp),%eax
 848:	a3 1c 0c 00 00       	mov    %eax,0xc1c
 84d:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 852:	a3 14 0c 00 00       	mov    %eax,0xc14
    base.s.size = 0;
 857:	c7 05 18 0c 00 00 00 	movl   $0x0,0xc18
 85e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 861:	8b 45 f0             	mov    -0x10(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 40 04             	mov    0x4(%eax),%eax
 86f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 872:	72 4d                	jb     8c1 <malloc+0xa4>
      if(p->s.size == nunits)
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87d:	75 0c                	jne    88b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 10                	mov    (%eax),%edx
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	89 10                	mov    %edx,(%eax)
 889:	eb 26                	jmp    8b1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	8b 40 04             	mov    0x4(%eax),%eax
 891:	2b 45 ec             	sub    -0x14(%ebp),%eax
 894:	89 c2                	mov    %eax,%edx
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8b 40 04             	mov    0x4(%eax),%eax
 8a2:	c1 e0 03             	shl    $0x3,%eax
 8a5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ae:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	a3 1c 0c 00 00       	mov    %eax,0xc1c
      return (void*)(p + 1);
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	83 c0 08             	add    $0x8,%eax
 8bf:	eb 3b                	jmp    8fc <malloc+0xdf>
    }
    if(p == freep)
 8c1:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 8c6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c9:	75 1e                	jne    8e9 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 8cb:	83 ec 0c             	sub    $0xc,%esp
 8ce:	ff 75 ec             	pushl  -0x14(%ebp)
 8d1:	e8 e7 fe ff ff       	call   7bd <morecore>
 8d6:	83 c4 10             	add    $0x10,%esp
 8d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e0:	75 07                	jne    8e9 <malloc+0xcc>
        return 0;
 8e2:	b8 00 00 00 00       	mov    $0x0,%eax
 8e7:	eb 13                	jmp    8fc <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	8b 00                	mov    (%eax),%eax
 8f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f7:	e9 6d ff ff ff       	jmp    869 <malloc+0x4c>
}
 8fc:	c9                   	leave  
 8fd:	c3                   	ret    

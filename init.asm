
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 f0 08 00 00       	push   $0x8f0
  1b:	e8 5d 03 00 00       	call   37d <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 f0 08 00 00       	push   $0x8f0
  33:	e8 4d 03 00 00       	call   385 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 f0 08 00 00       	push   $0x8f0
  45:	e8 33 03 00 00       	call   37d <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 5e 03 00 00       	call   3b5 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 51 03 00 00       	call   3b5 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 f8 08 00 00       	push   $0x8f8
  6f:	6a 01                	push   $0x1
  71:	e8 9c 04 00 00       	call   512 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 b7 02 00 00       	call   335 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 0b 09 00 00       	push   $0x90b
  8f:	6a 01                	push   $0x1
  91:	e8 7c 04 00 00       	call   512 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 9f 02 00 00       	call   33d <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 2c                	jne    d0 <main+0xd0>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 ac 0b 00 00       	push   $0xbac
  ac:	68 ed 08 00 00       	push   $0x8ed
  b1:	e8 bf 02 00 00       	call   375 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 1e 09 00 00       	push   $0x91e
  c1:	6a 01                	push   $0x1
  c3:	e8 4a 04 00 00       	call   512 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 6d 02 00 00       	call   33d <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  d0:	eb 12                	jmp    e4 <main+0xe4>
      printf(1, "zombie!\n");
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	68 34 09 00 00       	push   $0x934
  da:	6a 01                	push   $0x1
  dc:	e8 31 04 00 00       	call   512 <printf>
  e1:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e4:	e8 5c 02 00 00       	call   345 <wait>
  e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  f0:	78 08                	js     fa <main+0xfa>
  f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  f8:	75 d8                	jne    d2 <main+0xd2>
      printf(1, "zombie!\n");
  }
  fa:	e9 68 ff ff ff       	jmp    67 <main+0x67>

000000ff <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	57                   	push   %edi
 103:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 55 10             	mov    0x10(%ebp),%edx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 cb                	mov    %ecx,%ebx
 10f:	89 df                	mov    %ebx,%edi
 111:	89 d1                	mov    %edx,%ecx
 113:	fc                   	cld    
 114:	f3 aa                	rep stos %al,%es:(%edi)
 116:	89 ca                	mov    %ecx,%edx
 118:	89 fb                	mov    %edi,%ebx
 11a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 120:	5b                   	pop    %ebx
 121:	5f                   	pop    %edi
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 130:	90                   	nop
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	8d 50 01             	lea    0x1(%eax),%edx
 137:	89 55 08             	mov    %edx,0x8(%ebp)
 13a:	8b 55 0c             	mov    0xc(%ebp),%edx
 13d:	8d 4a 01             	lea    0x1(%edx),%ecx
 140:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 143:	8a 12                	mov    (%edx),%dl
 145:	88 10                	mov    %dl,(%eax)
 147:	8a 00                	mov    (%eax),%al
 149:	84 c0                	test   %al,%al
 14b:	75 e4                	jne    131 <strcpy+0xd>
    ;
  return os;
 14d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 150:	c9                   	leave  
 151:	c3                   	ret    

00000152 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 155:	eb 06                	jmp    15d <strcmp+0xb>
    p++, q++;
 157:	ff 45 08             	incl   0x8(%ebp)
 15a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	8a 00                	mov    (%eax),%al
 162:	84 c0                	test   %al,%al
 164:	74 0e                	je     174 <strcmp+0x22>
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	8a 10                	mov    (%eax),%dl
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	8a 00                	mov    (%eax),%al
 170:	38 c2                	cmp    %al,%dl
 172:	74 e3                	je     157 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	0f b6 d0             	movzbl %al,%edx
 17c:	8b 45 0c             	mov    0xc(%ebp),%eax
 17f:	8a 00                	mov    (%eax),%al
 181:	0f b6 c0             	movzbl %al,%eax
 184:	29 c2                	sub    %eax,%edx
 186:	89 d0                	mov    %edx,%eax
}
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    

0000018a <strlen>:

uint
strlen(char *s)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 197:	eb 03                	jmp    19c <strlen+0x12>
 199:	ff 45 fc             	incl   -0x4(%ebp)
 19c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8a 00                	mov    (%eax),%al
 1a6:	84 c0                	test   %al,%al
 1a8:	75 ef                	jne    199 <strlen+0xf>
    ;
  return n;
 1aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ad:	c9                   	leave  
 1ae:	c3                   	ret    

000001af <memset>:

void*
memset(void *dst, int c, uint n)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1b2:	8b 45 10             	mov    0x10(%ebp),%eax
 1b5:	50                   	push   %eax
 1b6:	ff 75 0c             	pushl  0xc(%ebp)
 1b9:	ff 75 08             	pushl  0x8(%ebp)
 1bc:	e8 3e ff ff ff       	call   ff <stosb>
 1c1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    

000001c9 <strchr>:

char*
strchr(const char *s, char c)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	83 ec 04             	sub    $0x4,%esp
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d5:	eb 12                	jmp    1e9 <strchr+0x20>
    if(*s == c)
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	8a 00                	mov    (%eax),%al
 1dc:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1df:	75 05                	jne    1e6 <strchr+0x1d>
      return (char*)s;
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	eb 11                	jmp    1f7 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e6:	ff 45 08             	incl   0x8(%ebp)
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	8a 00                	mov    (%eax),%al
 1ee:	84 c0                	test   %al,%al
 1f0:	75 e5                	jne    1d7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <gets>:

char*
gets(char *buf, int max)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 206:	eb 41                	jmp    249 <gets+0x50>
    cc = read(0, &c, 1);
 208:	83 ec 04             	sub    $0x4,%esp
 20b:	6a 01                	push   $0x1
 20d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 210:	50                   	push   %eax
 211:	6a 00                	push   $0x0
 213:	e8 3d 01 00 00       	call   355 <read>
 218:	83 c4 10             	add    $0x10,%esp
 21b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 21e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 222:	7f 02                	jg     226 <gets+0x2d>
      break;
 224:	eb 2c                	jmp    252 <gets+0x59>
    buf[i++] = c;
 226:	8b 45 f4             	mov    -0xc(%ebp),%eax
 229:	8d 50 01             	lea    0x1(%eax),%edx
 22c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 22f:	89 c2                	mov    %eax,%edx
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	01 c2                	add    %eax,%edx
 236:	8a 45 ef             	mov    -0x11(%ebp),%al
 239:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 23b:	8a 45 ef             	mov    -0x11(%ebp),%al
 23e:	3c 0a                	cmp    $0xa,%al
 240:	74 10                	je     252 <gets+0x59>
 242:	8a 45 ef             	mov    -0x11(%ebp),%al
 245:	3c 0d                	cmp    $0xd,%al
 247:	74 09                	je     252 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 249:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24c:	40                   	inc    %eax
 24d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 250:	7c b6                	jl     208 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 252:	8b 55 f4             	mov    -0xc(%ebp),%edx
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	01 d0                	add    %edx,%eax
 25a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 260:	c9                   	leave  
 261:	c3                   	ret    

00000262 <stat>:

int
stat(char *n, struct stat *st)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 268:	83 ec 08             	sub    $0x8,%esp
 26b:	6a 00                	push   $0x0
 26d:	ff 75 08             	pushl  0x8(%ebp)
 270:	e8 08 01 00 00       	call   37d <open>
 275:	83 c4 10             	add    $0x10,%esp
 278:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 27b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 27f:	79 07                	jns    288 <stat+0x26>
    return -1;
 281:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 286:	eb 25                	jmp    2ad <stat+0x4b>
  r = fstat(fd, st);
 288:	83 ec 08             	sub    $0x8,%esp
 28b:	ff 75 0c             	pushl  0xc(%ebp)
 28e:	ff 75 f4             	pushl  -0xc(%ebp)
 291:	e8 ff 00 00 00       	call   395 <fstat>
 296:	83 c4 10             	add    $0x10,%esp
 299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 29c:	83 ec 0c             	sub    $0xc,%esp
 29f:	ff 75 f4             	pushl  -0xc(%ebp)
 2a2:	e8 be 00 00 00       	call   365 <close>
 2a7:	83 c4 10             	add    $0x10,%esp
  return r;
 2aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ad:	c9                   	leave  
 2ae:	c3                   	ret    

000002af <atoi>:

int
atoi(const char *s)
{
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2bc:	eb 24                	jmp    2e2 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c1:	89 d0                	mov    %edx,%eax
 2c3:	c1 e0 02             	shl    $0x2,%eax
 2c6:	01 d0                	add    %edx,%eax
 2c8:	01 c0                	add    %eax,%eax
 2ca:	89 c1                	mov    %eax,%ecx
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	8d 50 01             	lea    0x1(%eax),%edx
 2d2:	89 55 08             	mov    %edx,0x8(%ebp)
 2d5:	8a 00                	mov    (%eax),%al
 2d7:	0f be c0             	movsbl %al,%eax
 2da:	01 c8                	add    %ecx,%eax
 2dc:	83 e8 30             	sub    $0x30,%eax
 2df:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	8a 00                	mov    (%eax),%al
 2e7:	3c 2f                	cmp    $0x2f,%al
 2e9:	7e 09                	jle    2f4 <atoi+0x45>
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	8a 00                	mov    (%eax),%al
 2f0:	3c 39                	cmp    $0x39,%al
 2f2:	7e ca                	jle    2be <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 305:	8b 45 0c             	mov    0xc(%ebp),%eax
 308:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 30b:	eb 16                	jmp    323 <memmove+0x2a>
    *dst++ = *src++;
 30d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 310:	8d 50 01             	lea    0x1(%eax),%edx
 313:	89 55 fc             	mov    %edx,-0x4(%ebp)
 316:	8b 55 f8             	mov    -0x8(%ebp),%edx
 319:	8d 4a 01             	lea    0x1(%edx),%ecx
 31c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 31f:	8a 12                	mov    (%edx),%dl
 321:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 323:	8b 45 10             	mov    0x10(%ebp),%eax
 326:	8d 50 ff             	lea    -0x1(%eax),%edx
 329:	89 55 10             	mov    %edx,0x10(%ebp)
 32c:	85 c0                	test   %eax,%eax
 32e:	7f dd                	jg     30d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 335:	b8 01 00 00 00       	mov    $0x1,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <exit>:
SYSCALL(exit)
 33d:	b8 02 00 00 00       	mov    $0x2,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <wait>:
SYSCALL(wait)
 345:	b8 03 00 00 00       	mov    $0x3,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <pipe>:
SYSCALL(pipe)
 34d:	b8 04 00 00 00       	mov    $0x4,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <read>:
SYSCALL(read)
 355:	b8 05 00 00 00       	mov    $0x5,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <write>:
SYSCALL(write)
 35d:	b8 10 00 00 00       	mov    $0x10,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <close>:
SYSCALL(close)
 365:	b8 15 00 00 00       	mov    $0x15,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <kill>:
SYSCALL(kill)
 36d:	b8 06 00 00 00       	mov    $0x6,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <exec>:
SYSCALL(exec)
 375:	b8 07 00 00 00       	mov    $0x7,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <open>:
SYSCALL(open)
 37d:	b8 0f 00 00 00       	mov    $0xf,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <mknod>:
SYSCALL(mknod)
 385:	b8 11 00 00 00       	mov    $0x11,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <unlink>:
SYSCALL(unlink)
 38d:	b8 12 00 00 00       	mov    $0x12,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <fstat>:
SYSCALL(fstat)
 395:	b8 08 00 00 00       	mov    $0x8,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <link>:
SYSCALL(link)
 39d:	b8 13 00 00 00       	mov    $0x13,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <mkdir>:
SYSCALL(mkdir)
 3a5:	b8 14 00 00 00       	mov    $0x14,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <chdir>:
SYSCALL(chdir)
 3ad:	b8 09 00 00 00       	mov    $0x9,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <dup>:
SYSCALL(dup)
 3b5:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <getpid>:
SYSCALL(getpid)
 3bd:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <sbrk>:
SYSCALL(sbrk)
 3c5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <sleep>:
SYSCALL(sleep)
 3cd:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <uptime>:
SYSCALL(uptime)
 3d5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <gettime>:
SYSCALL(gettime)
 3dd:	b8 16 00 00 00       	mov    $0x16,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <settickets>:
SYSCALL(settickets)
 3e5:	b8 17 00 00 00       	mov    $0x17,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 18             	sub    $0x18,%esp
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f9:	83 ec 04             	sub    $0x4,%esp
 3fc:	6a 01                	push   $0x1
 3fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
 401:	50                   	push   %eax
 402:	ff 75 08             	pushl  0x8(%ebp)
 405:	e8 53 ff ff ff       	call   35d <write>
 40a:	83 c4 10             	add    $0x10,%esp
}
 40d:	c9                   	leave  
 40e:	c3                   	ret    

0000040f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
 412:	53                   	push   %ebx
 413:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 416:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 41d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 421:	74 17                	je     43a <printint+0x2b>
 423:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 427:	79 11                	jns    43a <printint+0x2b>
    neg = 1;
 429:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	f7 d8                	neg    %eax
 435:	89 45 ec             	mov    %eax,-0x14(%ebp)
 438:	eb 06                	jmp    440 <printint+0x31>
  } else {
    x = xx;
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 440:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 447:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 44a:	8d 41 01             	lea    0x1(%ecx),%eax
 44d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 450:	8b 5d 10             	mov    0x10(%ebp),%ebx
 453:	8b 45 ec             	mov    -0x14(%ebp),%eax
 456:	ba 00 00 00 00       	mov    $0x0,%edx
 45b:	f7 f3                	div    %ebx
 45d:	89 d0                	mov    %edx,%eax
 45f:	8a 80 b4 0b 00 00    	mov    0xbb4(%eax),%al
 465:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 469:	8b 5d 10             	mov    0x10(%ebp),%ebx
 46c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46f:	ba 00 00 00 00       	mov    $0x0,%edx
 474:	f7 f3                	div    %ebx
 476:	89 45 ec             	mov    %eax,-0x14(%ebp)
 479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47d:	75 c8                	jne    447 <printint+0x38>
  if(neg)
 47f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 483:	74 0e                	je     493 <printint+0x84>
    buf[i++] = '-';
 485:	8b 45 f4             	mov    -0xc(%ebp),%eax
 488:	8d 50 01             	lea    0x1(%eax),%edx
 48b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 493:	eb 1c                	jmp    4b1 <printint+0xa2>
    putc(fd, buf[i]);
 495:	8d 55 dc             	lea    -0x24(%ebp),%edx
 498:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49b:	01 d0                	add    %edx,%eax
 49d:	8a 00                	mov    (%eax),%al
 49f:	0f be c0             	movsbl %al,%eax
 4a2:	83 ec 08             	sub    $0x8,%esp
 4a5:	50                   	push   %eax
 4a6:	ff 75 08             	pushl  0x8(%ebp)
 4a9:	e8 3f ff ff ff       	call   3ed <putc>
 4ae:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b1:	ff 4d f4             	decl   -0xc(%ebp)
 4b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b8:	79 db                	jns    495 <printint+0x86>
    putc(fd, buf[i]);
}
 4ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4bd:	c9                   	leave  
 4be:	c3                   	ret    

000004bf <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 4bf:	55                   	push   %ebp
 4c0:	89 e5                	mov    %esp,%ebp
 4c2:	83 ec 28             	sub    $0x28,%esp
 4c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 4cb:	8b 45 10             	mov    0x10(%ebp),%eax
 4ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 4d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4d7:	89 d0                	mov    %edx,%eax
 4d9:	31 d2                	xor    %edx,%edx
 4db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 4de:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 4e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e8:	74 13                	je     4fd <printlong+0x3e>
 4ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ed:	6a 00                	push   $0x0
 4ef:	6a 10                	push   $0x10
 4f1:	50                   	push   %eax
 4f2:	ff 75 08             	pushl  0x8(%ebp)
 4f5:	e8 15 ff ff ff       	call   40f <printint>
 4fa:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 4fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 500:	6a 00                	push   $0x0
 502:	6a 10                	push   $0x10
 504:	50                   	push   %eax
 505:	ff 75 08             	pushl  0x8(%ebp)
 508:	e8 02 ff ff ff       	call   40f <printint>
 50d:	83 c4 10             	add    $0x10,%esp
}
 510:	c9                   	leave  
 511:	c3                   	ret    

00000512 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 512:	55                   	push   %ebp
 513:	89 e5                	mov    %esp,%ebp
 515:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 518:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 51f:	8d 45 0c             	lea    0xc(%ebp),%eax
 522:	83 c0 04             	add    $0x4,%eax
 525:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 528:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 52f:	e9 83 01 00 00       	jmp    6b7 <printf+0x1a5>
    c = fmt[i] & 0xff;
 534:	8b 55 0c             	mov    0xc(%ebp),%edx
 537:	8b 45 f0             	mov    -0x10(%ebp),%eax
 53a:	01 d0                	add    %edx,%eax
 53c:	8a 00                	mov    (%eax),%al
 53e:	0f be c0             	movsbl %al,%eax
 541:	25 ff 00 00 00       	and    $0xff,%eax
 546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 549:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 54d:	75 2c                	jne    57b <printf+0x69>
      if(c == '%'){
 54f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 553:	75 0c                	jne    561 <printf+0x4f>
        state = '%';
 555:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 55c:	e9 53 01 00 00       	jmp    6b4 <printf+0x1a2>
      } else {
        putc(fd, c);
 561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 564:	0f be c0             	movsbl %al,%eax
 567:	83 ec 08             	sub    $0x8,%esp
 56a:	50                   	push   %eax
 56b:	ff 75 08             	pushl  0x8(%ebp)
 56e:	e8 7a fe ff ff       	call   3ed <putc>
 573:	83 c4 10             	add    $0x10,%esp
 576:	e9 39 01 00 00       	jmp    6b4 <printf+0x1a2>
      }
    } else if(state == '%'){
 57b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 57f:	0f 85 2f 01 00 00    	jne    6b4 <printf+0x1a2>
      if(c == 'd'){
 585:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 589:	75 1e                	jne    5a9 <printf+0x97>
        printint(fd, *ap, 10, 1);
 58b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58e:	8b 00                	mov    (%eax),%eax
 590:	6a 01                	push   $0x1
 592:	6a 0a                	push   $0xa
 594:	50                   	push   %eax
 595:	ff 75 08             	pushl  0x8(%ebp)
 598:	e8 72 fe ff ff       	call   40f <printint>
 59d:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a4:	e9 04 01 00 00       	jmp    6ad <printf+0x19b>
      } else if(c == 'l') {
 5a9:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 5ad:	75 29                	jne    5d8 <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 5af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b2:	8b 50 04             	mov    0x4(%eax),%edx
 5b5:	8b 00                	mov    (%eax),%eax
 5b7:	83 ec 0c             	sub    $0xc,%esp
 5ba:	6a 00                	push   $0x0
 5bc:	6a 0a                	push   $0xa
 5be:	52                   	push   %edx
 5bf:	50                   	push   %eax
 5c0:	ff 75 08             	pushl  0x8(%ebp)
 5c3:	e8 f7 fe ff ff       	call   4bf <printlong>
 5c8:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 5cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 5cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d3:	e9 d5 00 00 00       	jmp    6ad <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 5d8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5dc:	74 06                	je     5e4 <printf+0xd2>
 5de:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e2:	75 1e                	jne    602 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 5e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e7:	8b 00                	mov    (%eax),%eax
 5e9:	6a 00                	push   $0x0
 5eb:	6a 10                	push   $0x10
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 19 fe ff ff       	call   40f <printint>
 5f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	e9 ab 00 00 00       	jmp    6ad <printf+0x19b>
      } else if(c == 's'){
 602:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 606:	75 40                	jne    648 <printf+0x136>
        s = (char*)*ap;
 608:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 610:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 618:	75 07                	jne    621 <printf+0x10f>
          s = "(null)";
 61a:	c7 45 f4 3d 09 00 00 	movl   $0x93d,-0xc(%ebp)
        while(*s != 0){
 621:	eb 1a                	jmp    63d <printf+0x12b>
          putc(fd, *s);
 623:	8b 45 f4             	mov    -0xc(%ebp),%eax
 626:	8a 00                	mov    (%eax),%al
 628:	0f be c0             	movsbl %al,%eax
 62b:	83 ec 08             	sub    $0x8,%esp
 62e:	50                   	push   %eax
 62f:	ff 75 08             	pushl  0x8(%ebp)
 632:	e8 b6 fd ff ff       	call   3ed <putc>
 637:	83 c4 10             	add    $0x10,%esp
          s++;
 63a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 640:	8a 00                	mov    (%eax),%al
 642:	84 c0                	test   %al,%al
 644:	75 dd                	jne    623 <printf+0x111>
 646:	eb 65                	jmp    6ad <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 648:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64c:	75 1d                	jne    66b <printf+0x159>
        putc(fd, *ap);
 64e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	83 ec 08             	sub    $0x8,%esp
 659:	50                   	push   %eax
 65a:	ff 75 08             	pushl  0x8(%ebp)
 65d:	e8 8b fd ff ff       	call   3ed <putc>
 662:	83 c4 10             	add    $0x10,%esp
        ap++;
 665:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 669:	eb 42                	jmp    6ad <printf+0x19b>
      } else if(c == '%'){
 66b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66f:	75 17                	jne    688 <printf+0x176>
        putc(fd, c);
 671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 674:	0f be c0             	movsbl %al,%eax
 677:	83 ec 08             	sub    $0x8,%esp
 67a:	50                   	push   %eax
 67b:	ff 75 08             	pushl  0x8(%ebp)
 67e:	e8 6a fd ff ff       	call   3ed <putc>
 683:	83 c4 10             	add    $0x10,%esp
 686:	eb 25                	jmp    6ad <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 688:	83 ec 08             	sub    $0x8,%esp
 68b:	6a 25                	push   $0x25
 68d:	ff 75 08             	pushl  0x8(%ebp)
 690:	e8 58 fd ff ff       	call   3ed <putc>
 695:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69b:	0f be c0             	movsbl %al,%eax
 69e:	83 ec 08             	sub    $0x8,%esp
 6a1:	50                   	push   %eax
 6a2:	ff 75 08             	pushl  0x8(%ebp)
 6a5:	e8 43 fd ff ff       	call   3ed <putc>
 6aa:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b4:	ff 45 f0             	incl   -0x10(%ebp)
 6b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bd:	01 d0                	add    %edx,%eax
 6bf:	8a 00                	mov    (%eax),%al
 6c1:	84 c0                	test   %al,%al
 6c3:	0f 85 6b fe ff ff    	jne    534 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c9:	c9                   	leave  
 6ca:	c3                   	ret    

000006cb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d1:	8b 45 08             	mov    0x8(%ebp),%eax
 6d4:	83 e8 08             	sub    $0x8,%eax
 6d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6da:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 6df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e2:	eb 24                	jmp    708 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ec:	77 12                	ja     700 <free+0x35>
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f4:	77 24                	ja     71a <free+0x4f>
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fe:	77 1a                	ja     71a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	89 45 fc             	mov    %eax,-0x4(%ebp)
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70e:	76 d4                	jbe    6e4 <free+0x19>
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 718:	76 ca                	jbe    6e4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	01 c2                	add    %eax,%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	39 c2                	cmp    %eax,%edx
 733:	75 24                	jne    759 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	8b 50 04             	mov    0x4(%eax),%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	01 c2                	add    %eax,%edx
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 00                	mov    (%eax),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 0a                	jmp    763 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 10                	mov    (%eax),%edx
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	01 d0                	add    %edx,%eax
 775:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 778:	75 20                	jne    79a <free+0xcf>
    p->s.size += bp->s.size;
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 50 04             	mov    0x4(%eax),%edx
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	01 c2                	add    %eax,%edx
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	8b 10                	mov    (%eax),%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	89 10                	mov    %edx,(%eax)
 798:	eb 08                	jmp    7a2 <free+0xd7>
  } else
    p->s.ptr = bp;
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a0:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	a3 d0 0b 00 00       	mov    %eax,0xbd0
}
 7aa:	c9                   	leave  
 7ab:	c3                   	ret    

000007ac <morecore>:

static Header*
morecore(uint nu)
{
 7ac:	55                   	push   %ebp
 7ad:	89 e5                	mov    %esp,%ebp
 7af:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b9:	77 07                	ja     7c2 <morecore+0x16>
    nu = 4096;
 7bb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	c1 e0 03             	shl    $0x3,%eax
 7c8:	83 ec 0c             	sub    $0xc,%esp
 7cb:	50                   	push   %eax
 7cc:	e8 f4 fb ff ff       	call   3c5 <sbrk>
 7d1:	83 c4 10             	add    $0x10,%esp
 7d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7db:	75 07                	jne    7e4 <morecore+0x38>
    return 0;
 7dd:	b8 00 00 00 00       	mov    $0x0,%eax
 7e2:	eb 26                	jmp    80a <morecore+0x5e>
  hp = (Header*)p;
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ed:	8b 55 08             	mov    0x8(%ebp),%edx
 7f0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f6:	83 c0 08             	add    $0x8,%eax
 7f9:	83 ec 0c             	sub    $0xc,%esp
 7fc:	50                   	push   %eax
 7fd:	e8 c9 fe ff ff       	call   6cb <free>
 802:	83 c4 10             	add    $0x10,%esp
  return freep;
 805:	a1 d0 0b 00 00       	mov    0xbd0,%eax
}
 80a:	c9                   	leave  
 80b:	c3                   	ret    

0000080c <malloc>:

void*
malloc(uint nbytes)
{
 80c:	55                   	push   %ebp
 80d:	89 e5                	mov    %esp,%ebp
 80f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	8b 45 08             	mov    0x8(%ebp),%eax
 815:	83 c0 07             	add    $0x7,%eax
 818:	c1 e8 03             	shr    $0x3,%eax
 81b:	40                   	inc    %eax
 81c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81f:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 824:	89 45 f0             	mov    %eax,-0x10(%ebp)
 827:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82b:	75 23                	jne    850 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 82d:	c7 45 f0 c8 0b 00 00 	movl   $0xbc8,-0x10(%ebp)
 834:	8b 45 f0             	mov    -0x10(%ebp),%eax
 837:	a3 d0 0b 00 00       	mov    %eax,0xbd0
 83c:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 841:	a3 c8 0b 00 00       	mov    %eax,0xbc8
    base.s.size = 0;
 846:	c7 05 cc 0b 00 00 00 	movl   $0x0,0xbcc
 84d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	8b 45 f0             	mov    -0x10(%ebp),%eax
 853:	8b 00                	mov    (%eax),%eax
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 858:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85b:	8b 40 04             	mov    0x4(%eax),%eax
 85e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 861:	72 4d                	jb     8b0 <malloc+0xa4>
      if(p->s.size == nunits)
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86c:	75 0c                	jne    87a <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	8b 10                	mov    (%eax),%edx
 873:	8b 45 f0             	mov    -0x10(%ebp),%eax
 876:	89 10                	mov    %edx,(%eax)
 878:	eb 26                	jmp    8a0 <malloc+0x94>
      else {
        p->s.size -= nunits;
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 40 04             	mov    0x4(%eax),%eax
 880:	2b 45 ec             	sub    -0x14(%ebp),%eax
 883:	89 c2                	mov    %eax,%edx
 885:	8b 45 f4             	mov    -0xc(%ebp),%eax
 888:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	8b 40 04             	mov    0x4(%eax),%eax
 891:	c1 e0 03             	shl    $0x3,%eax
 894:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a3:	a3 d0 0b 00 00       	mov    %eax,0xbd0
      return (void*)(p + 1);
 8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ab:	83 c0 08             	add    $0x8,%eax
 8ae:	eb 3b                	jmp    8eb <malloc+0xdf>
    }
    if(p == freep)
 8b0:	a1 d0 0b 00 00       	mov    0xbd0,%eax
 8b5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b8:	75 1e                	jne    8d8 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 8ba:	83 ec 0c             	sub    $0xc,%esp
 8bd:	ff 75 ec             	pushl  -0x14(%ebp)
 8c0:	e8 e7 fe ff ff       	call   7ac <morecore>
 8c5:	83 c4 10             	add    $0x10,%esp
 8c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cf:	75 07                	jne    8d8 <malloc+0xcc>
        return 0;
 8d1:	b8 00 00 00 00       	mov    $0x0,%eax
 8d6:	eb 13                	jmp    8eb <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	8b 00                	mov    (%eax),%eax
 8e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e6:	e9 6d ff ff ff       	jmp    858 <malloc+0x4c>
}
 8eb:	c9                   	leave  
 8ec:	c3                   	ret    

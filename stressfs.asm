
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 28 02 00 00    	sub    $0x228,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	8d 55 d6             	lea    -0x2a(%ebp),%edx
  1a:	bb 62 09 00 00       	mov    $0x962,%ebx
  1f:	b8 0a 00 00 00       	mov    $0xa,%eax
  24:	89 d7                	mov    %edx,%edi
  26:	89 de                	mov    %ebx,%esi
  28:	89 c1                	mov    %eax,%ecx
  2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	83 ec 08             	sub    $0x8,%esp
  2f:	68 3f 09 00 00       	push   $0x93f
  34:	6a 01                	push   $0x1
  36:	e8 29 05 00 00       	call   564 <printf>
  3b:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3e:	83 ec 04             	sub    $0x4,%esp
  41:	68 00 02 00 00       	push   $0x200
  46:	6a 61                	push   $0x61
  48:	8d 85 d6 fd ff ff    	lea    -0x22a(%ebp),%eax
  4e:	50                   	push   %eax
  4f:	e8 ad 01 00 00       	call   201 <memset>
  54:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  5e:	eb 0e                	jmp    6e <main+0x6e>
    if(fork() > 0)
  60:	e8 22 03 00 00       	call   387 <fork>
  65:	85 c0                	test   %eax,%eax
  67:	7e 02                	jle    6b <main+0x6b>
      break;
  69:	eb 09                	jmp    74 <main+0x74>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  6b:	ff 45 e4             	incl   -0x1c(%ebp)
  6e:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  72:	7e ec                	jle    60 <main+0x60>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  74:	83 ec 04             	sub    $0x4,%esp
  77:	ff 75 e4             	pushl  -0x1c(%ebp)
  7a:	68 52 09 00 00       	push   $0x952
  7f:	6a 01                	push   $0x1
  81:	e8 de 04 00 00       	call   564 <printf>
  86:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  89:	8a 45 de             	mov    -0x22(%ebp),%al
  8c:	88 c2                	mov    %al,%dl
  8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  91:	01 d0                	add    %edx,%eax
  93:	88 45 de             	mov    %al,-0x22(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  96:	83 ec 08             	sub    $0x8,%esp
  99:	68 02 02 00 00       	push   $0x202
  9e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
  a1:	50                   	push   %eax
  a2:	e8 28 03 00 00       	call   3cf <open>
  a7:	83 c4 10             	add    $0x10,%esp
  aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < 20; i++)
  ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  b4:	eb 1d                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b6:	83 ec 04             	sub    $0x4,%esp
  b9:	68 00 02 00 00       	push   $0x200
  be:	8d 85 d6 fd ff ff    	lea    -0x22a(%ebp),%eax
  c4:	50                   	push   %eax
  c5:	ff 75 e0             	pushl  -0x20(%ebp)
  c8:	e8 e2 02 00 00       	call   3af <write>
  cd:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  d0:	ff 45 e4             	incl   -0x1c(%ebp)
  d3:	83 7d e4 13          	cmpl   $0x13,-0x1c(%ebp)
  d7:	7e dd                	jle    b6 <main+0xb6>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 e0             	pushl  -0x20(%ebp)
  df:	e8 d3 02 00 00       	call   3b7 <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 5c 09 00 00       	push   $0x95c
  ef:	6a 01                	push   $0x1
  f1:	e8 6e 04 00 00       	call   564 <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 d6             	lea    -0x2a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 c8 02 00 00       	call   3cf <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 114:	eb 1d                	jmp    133 <main+0x133>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 d6 fd ff ff    	lea    -0x22a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 e0             	pushl  -0x20(%ebp)
 128:	e8 7a 02 00 00       	call   3a7 <read>
 12d:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 130:	ff 45 e4             	incl   -0x1c(%ebp)
 133:	83 7d e4 13          	cmpl   $0x13,-0x1c(%ebp)
 137:	7e dd                	jle    116 <main+0x116>
    read(fd, data, sizeof(data));
  close(fd);
 139:	83 ec 0c             	sub    $0xc,%esp
 13c:	ff 75 e0             	pushl  -0x20(%ebp)
 13f:	e8 73 02 00 00       	call   3b7 <close>
 144:	83 c4 10             	add    $0x10,%esp

  wait();
 147:	e8 4b 02 00 00       	call   397 <wait>
  
  exit();
 14c:	e8 3e 02 00 00       	call   38f <exit>

00000151 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	57                   	push   %edi
 155:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 156:	8b 4d 08             	mov    0x8(%ebp),%ecx
 159:	8b 55 10             	mov    0x10(%ebp),%edx
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	89 cb                	mov    %ecx,%ebx
 161:	89 df                	mov    %ebx,%edi
 163:	89 d1                	mov    %edx,%ecx
 165:	fc                   	cld    
 166:	f3 aa                	rep stos %al,%es:(%edi)
 168:	89 ca                	mov    %ecx,%edx
 16a:	89 fb                	mov    %edi,%ebx
 16c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 16f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 172:	5b                   	pop    %ebx
 173:	5f                   	pop    %edi
 174:	5d                   	pop    %ebp
 175:	c3                   	ret    

00000176 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 182:	90                   	nop
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	8d 50 01             	lea    0x1(%eax),%edx
 189:	89 55 08             	mov    %edx,0x8(%ebp)
 18c:	8b 55 0c             	mov    0xc(%ebp),%edx
 18f:	8d 4a 01             	lea    0x1(%edx),%ecx
 192:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 195:	8a 12                	mov    (%edx),%dl
 197:	88 10                	mov    %dl,(%eax)
 199:	8a 00                	mov    (%eax),%al
 19b:	84 c0                	test   %al,%al
 19d:	75 e4                	jne    183 <strcpy+0xd>
    ;
  return os;
 19f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a7:	eb 06                	jmp    1af <strcmp+0xb>
    p++, q++;
 1a9:	ff 45 08             	incl   0x8(%ebp)
 1ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1af:	8b 45 08             	mov    0x8(%ebp),%eax
 1b2:	8a 00                	mov    (%eax),%al
 1b4:	84 c0                	test   %al,%al
 1b6:	74 0e                	je     1c6 <strcmp+0x22>
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	8a 10                	mov    (%eax),%dl
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	8a 00                	mov    (%eax),%al
 1c2:	38 c2                	cmp    %al,%dl
 1c4:	74 e3                	je     1a9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	8a 00                	mov    (%eax),%al
 1cb:	0f b6 d0             	movzbl %al,%edx
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	8a 00                	mov    (%eax),%al
 1d3:	0f b6 c0             	movzbl %al,%eax
 1d6:	29 c2                	sub    %eax,%edx
 1d8:	89 d0                	mov    %edx,%eax
}
 1da:	5d                   	pop    %ebp
 1db:	c3                   	ret    

000001dc <strlen>:

uint
strlen(char *s)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e9:	eb 03                	jmp    1ee <strlen+0x12>
 1eb:	ff 45 fc             	incl   -0x4(%ebp)
 1ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	01 d0                	add    %edx,%eax
 1f6:	8a 00                	mov    (%eax),%al
 1f8:	84 c0                	test   %al,%al
 1fa:	75 ef                	jne    1eb <strlen+0xf>
    ;
  return n;
 1fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <memset>:

void*
memset(void *dst, int c, uint n)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 204:	8b 45 10             	mov    0x10(%ebp),%eax
 207:	50                   	push   %eax
 208:	ff 75 0c             	pushl  0xc(%ebp)
 20b:	ff 75 08             	pushl  0x8(%ebp)
 20e:	e8 3e ff ff ff       	call   151 <stosb>
 213:	83 c4 0c             	add    $0xc,%esp
  return dst;
 216:	8b 45 08             	mov    0x8(%ebp),%eax
}
 219:	c9                   	leave  
 21a:	c3                   	ret    

0000021b <strchr>:

char*
strchr(const char *s, char c)
{
 21b:	55                   	push   %ebp
 21c:	89 e5                	mov    %esp,%ebp
 21e:	83 ec 04             	sub    $0x4,%esp
 221:	8b 45 0c             	mov    0xc(%ebp),%eax
 224:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 227:	eb 12                	jmp    23b <strchr+0x20>
    if(*s == c)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	8a 00                	mov    (%eax),%al
 22e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 231:	75 05                	jne    238 <strchr+0x1d>
      return (char*)s;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	eb 11                	jmp    249 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 238:	ff 45 08             	incl   0x8(%ebp)
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	8a 00                	mov    (%eax),%al
 240:	84 c0                	test   %al,%al
 242:	75 e5                	jne    229 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 244:	b8 00 00 00 00       	mov    $0x0,%eax
}
 249:	c9                   	leave  
 24a:	c3                   	ret    

0000024b <gets>:

char*
gets(char *buf, int max)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 251:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 258:	eb 41                	jmp    29b <gets+0x50>
    cc = read(0, &c, 1);
 25a:	83 ec 04             	sub    $0x4,%esp
 25d:	6a 01                	push   $0x1
 25f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 262:	50                   	push   %eax
 263:	6a 00                	push   $0x0
 265:	e8 3d 01 00 00       	call   3a7 <read>
 26a:	83 c4 10             	add    $0x10,%esp
 26d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 274:	7f 02                	jg     278 <gets+0x2d>
      break;
 276:	eb 2c                	jmp    2a4 <gets+0x59>
    buf[i++] = c;
 278:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27b:	8d 50 01             	lea    0x1(%eax),%edx
 27e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 281:	89 c2                	mov    %eax,%edx
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	01 c2                	add    %eax,%edx
 288:	8a 45 ef             	mov    -0x11(%ebp),%al
 28b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 28d:	8a 45 ef             	mov    -0x11(%ebp),%al
 290:	3c 0a                	cmp    $0xa,%al
 292:	74 10                	je     2a4 <gets+0x59>
 294:	8a 45 ef             	mov    -0x11(%ebp),%al
 297:	3c 0d                	cmp    $0xd,%al
 299:	74 09                	je     2a4 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29e:	40                   	inc    %eax
 29f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2a2:	7c b6                	jl     25a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	01 d0                	add    %edx,%eax
 2ac:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <stat>:

int
stat(char *n, struct stat *st)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ba:	83 ec 08             	sub    $0x8,%esp
 2bd:	6a 00                	push   $0x0
 2bf:	ff 75 08             	pushl  0x8(%ebp)
 2c2:	e8 08 01 00 00       	call   3cf <open>
 2c7:	83 c4 10             	add    $0x10,%esp
 2ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2d1:	79 07                	jns    2da <stat+0x26>
    return -1;
 2d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d8:	eb 25                	jmp    2ff <stat+0x4b>
  r = fstat(fd, st);
 2da:	83 ec 08             	sub    $0x8,%esp
 2dd:	ff 75 0c             	pushl  0xc(%ebp)
 2e0:	ff 75 f4             	pushl  -0xc(%ebp)
 2e3:	e8 ff 00 00 00       	call   3e7 <fstat>
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ee:	83 ec 0c             	sub    $0xc,%esp
 2f1:	ff 75 f4             	pushl  -0xc(%ebp)
 2f4:	e8 be 00 00 00       	call   3b7 <close>
 2f9:	83 c4 10             	add    $0x10,%esp
  return r;
 2fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ff:	c9                   	leave  
 300:	c3                   	ret    

00000301 <atoi>:

int
atoi(const char *s)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 30e:	eb 24                	jmp    334 <atoi+0x33>
    n = n*10 + *s++ - '0';
 310:	8b 55 fc             	mov    -0x4(%ebp),%edx
 313:	89 d0                	mov    %edx,%eax
 315:	c1 e0 02             	shl    $0x2,%eax
 318:	01 d0                	add    %edx,%eax
 31a:	01 c0                	add    %eax,%eax
 31c:	89 c1                	mov    %eax,%ecx
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	8d 50 01             	lea    0x1(%eax),%edx
 324:	89 55 08             	mov    %edx,0x8(%ebp)
 327:	8a 00                	mov    (%eax),%al
 329:	0f be c0             	movsbl %al,%eax
 32c:	01 c8                	add    %ecx,%eax
 32e:	83 e8 30             	sub    $0x30,%eax
 331:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8a 00                	mov    (%eax),%al
 339:	3c 2f                	cmp    $0x2f,%al
 33b:	7e 09                	jle    346 <atoi+0x45>
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	8a 00                	mov    (%eax),%al
 342:	3c 39                	cmp    $0x39,%al
 344:	7e ca                	jle    310 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 346:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 351:	8b 45 08             	mov    0x8(%ebp),%eax
 354:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 357:	8b 45 0c             	mov    0xc(%ebp),%eax
 35a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 35d:	eb 16                	jmp    375 <memmove+0x2a>
    *dst++ = *src++;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 362:	8d 50 01             	lea    0x1(%eax),%edx
 365:	89 55 fc             	mov    %edx,-0x4(%ebp)
 368:	8b 55 f8             	mov    -0x8(%ebp),%edx
 36b:	8d 4a 01             	lea    0x1(%edx),%ecx
 36e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 371:	8a 12                	mov    (%edx),%dl
 373:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 375:	8b 45 10             	mov    0x10(%ebp),%eax
 378:	8d 50 ff             	lea    -0x1(%eax),%edx
 37b:	89 55 10             	mov    %edx,0x10(%ebp)
 37e:	85 c0                	test   %eax,%eax
 380:	7f dd                	jg     35f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 382:	8b 45 08             	mov    0x8(%ebp),%eax
}
 385:	c9                   	leave  
 386:	c3                   	ret    

00000387 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 387:	b8 01 00 00 00       	mov    $0x1,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <exit>:
SYSCALL(exit)
 38f:	b8 02 00 00 00       	mov    $0x2,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <wait>:
SYSCALL(wait)
 397:	b8 03 00 00 00       	mov    $0x3,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <pipe>:
SYSCALL(pipe)
 39f:	b8 04 00 00 00       	mov    $0x4,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <read>:
SYSCALL(read)
 3a7:	b8 05 00 00 00       	mov    $0x5,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <write>:
SYSCALL(write)
 3af:	b8 10 00 00 00       	mov    $0x10,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <close>:
SYSCALL(close)
 3b7:	b8 15 00 00 00       	mov    $0x15,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <kill>:
SYSCALL(kill)
 3bf:	b8 06 00 00 00       	mov    $0x6,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <exec>:
SYSCALL(exec)
 3c7:	b8 07 00 00 00       	mov    $0x7,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <open>:
SYSCALL(open)
 3cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <mknod>:
SYSCALL(mknod)
 3d7:	b8 11 00 00 00       	mov    $0x11,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <unlink>:
SYSCALL(unlink)
 3df:	b8 12 00 00 00       	mov    $0x12,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <fstat>:
SYSCALL(fstat)
 3e7:	b8 08 00 00 00       	mov    $0x8,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <link>:
SYSCALL(link)
 3ef:	b8 13 00 00 00       	mov    $0x13,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <mkdir>:
SYSCALL(mkdir)
 3f7:	b8 14 00 00 00       	mov    $0x14,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <chdir>:
SYSCALL(chdir)
 3ff:	b8 09 00 00 00       	mov    $0x9,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <dup>:
SYSCALL(dup)
 407:	b8 0a 00 00 00       	mov    $0xa,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <getpid>:
SYSCALL(getpid)
 40f:	b8 0b 00 00 00       	mov    $0xb,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <sbrk>:
SYSCALL(sbrk)
 417:	b8 0c 00 00 00       	mov    $0xc,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <sleep>:
SYSCALL(sleep)
 41f:	b8 0d 00 00 00       	mov    $0xd,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <uptime>:
SYSCALL(uptime)
 427:	b8 0e 00 00 00       	mov    $0xe,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <gettime>:
SYSCALL(gettime)
 42f:	b8 16 00 00 00       	mov    $0x16,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <settickets>:
SYSCALL(settickets)
 437:	b8 17 00 00 00       	mov    $0x17,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
 445:	8b 45 0c             	mov    0xc(%ebp),%eax
 448:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 44b:	83 ec 04             	sub    $0x4,%esp
 44e:	6a 01                	push   $0x1
 450:	8d 45 f4             	lea    -0xc(%ebp),%eax
 453:	50                   	push   %eax
 454:	ff 75 08             	pushl  0x8(%ebp)
 457:	e8 53 ff ff ff       	call   3af <write>
 45c:	83 c4 10             	add    $0x10,%esp
}
 45f:	c9                   	leave  
 460:	c3                   	ret    

00000461 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	53                   	push   %ebx
 465:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 468:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 46f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 473:	74 17                	je     48c <printint+0x2b>
 475:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 479:	79 11                	jns    48c <printint+0x2b>
    neg = 1;
 47b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 482:	8b 45 0c             	mov    0xc(%ebp),%eax
 485:	f7 d8                	neg    %eax
 487:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48a:	eb 06                	jmp    492 <printint+0x31>
  } else {
    x = xx;
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 499:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 49c:	8d 41 01             	lea    0x1(%ecx),%eax
 49f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a8:	ba 00 00 00 00       	mov    $0x0,%edx
 4ad:	f7 f3                	div    %ebx
 4af:	89 d0                	mov    %edx,%eax
 4b1:	8a 80 e8 0b 00 00    	mov    0xbe8(%eax),%al
 4b7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c1:	ba 00 00 00 00       	mov    $0x0,%edx
 4c6:	f7 f3                	div    %ebx
 4c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4cf:	75 c8                	jne    499 <printint+0x38>
  if(neg)
 4d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d5:	74 0e                	je     4e5 <printint+0x84>
    buf[i++] = '-';
 4d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4da:	8d 50 01             	lea    0x1(%eax),%edx
 4dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4e5:	eb 1c                	jmp    503 <printint+0xa2>
    putc(fd, buf[i]);
 4e7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ed:	01 d0                	add    %edx,%eax
 4ef:	8a 00                	mov    (%eax),%al
 4f1:	0f be c0             	movsbl %al,%eax
 4f4:	83 ec 08             	sub    $0x8,%esp
 4f7:	50                   	push   %eax
 4f8:	ff 75 08             	pushl  0x8(%ebp)
 4fb:	e8 3f ff ff ff       	call   43f <putc>
 500:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 503:	ff 4d f4             	decl   -0xc(%ebp)
 506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50a:	79 db                	jns    4e7 <printint+0x86>
    putc(fd, buf[i]);
}
 50c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 50f:	c9                   	leave  
 510:	c3                   	ret    

00000511 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 511:	55                   	push   %ebp
 512:	89 e5                	mov    %esp,%ebp
 514:	83 ec 28             	sub    $0x28,%esp
 517:	8b 45 0c             	mov    0xc(%ebp),%eax
 51a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 51d:	8b 45 10             	mov    0x10(%ebp),%eax
 520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 523:	8b 45 e0             	mov    -0x20(%ebp),%eax
 526:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 529:	89 d0                	mov    %edx,%eax
 52b:	31 d2                	xor    %edx,%edx
 52d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 530:	8b 45 e0             	mov    -0x20(%ebp),%eax
 533:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53a:	74 13                	je     54f <printlong+0x3e>
 53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53f:	6a 00                	push   $0x0
 541:	6a 10                	push   $0x10
 543:	50                   	push   %eax
 544:	ff 75 08             	pushl  0x8(%ebp)
 547:	e8 15 ff ff ff       	call   461 <printint>
 54c:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 54f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 552:	6a 00                	push   $0x0
 554:	6a 10                	push   $0x10
 556:	50                   	push   %eax
 557:	ff 75 08             	pushl  0x8(%ebp)
 55a:	e8 02 ff ff ff       	call   461 <printint>
 55f:	83 c4 10             	add    $0x10,%esp
}
 562:	c9                   	leave  
 563:	c3                   	ret    

00000564 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 56a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 571:	8d 45 0c             	lea    0xc(%ebp),%eax
 574:	83 c0 04             	add    $0x4,%eax
 577:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 57a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 581:	e9 83 01 00 00       	jmp    709 <printf+0x1a5>
    c = fmt[i] & 0xff;
 586:	8b 55 0c             	mov    0xc(%ebp),%edx
 589:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58c:	01 d0                	add    %edx,%eax
 58e:	8a 00                	mov    (%eax),%al
 590:	0f be c0             	movsbl %al,%eax
 593:	25 ff 00 00 00       	and    $0xff,%eax
 598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 59b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59f:	75 2c                	jne    5cd <printf+0x69>
      if(c == '%'){
 5a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a5:	75 0c                	jne    5b3 <printf+0x4f>
        state = '%';
 5a7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ae:	e9 53 01 00 00       	jmp    706 <printf+0x1a2>
      } else {
        putc(fd, c);
 5b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	83 ec 08             	sub    $0x8,%esp
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 7a fe ff ff       	call   43f <putc>
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	e9 39 01 00 00       	jmp    706 <printf+0x1a2>
      }
    } else if(state == '%'){
 5cd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d1:	0f 85 2f 01 00 00    	jne    706 <printf+0x1a2>
      if(c == 'd'){
 5d7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5db:	75 1e                	jne    5fb <printf+0x97>
        printint(fd, *ap, 10, 1);
 5dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	6a 01                	push   $0x1
 5e4:	6a 0a                	push   $0xa
 5e6:	50                   	push   %eax
 5e7:	ff 75 08             	pushl  0x8(%ebp)
 5ea:	e8 72 fe ff ff       	call   461 <printint>
 5ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f6:	e9 04 01 00 00       	jmp    6ff <printf+0x19b>
      } else if(c == 'l') {
 5fb:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 5ff:	75 29                	jne    62a <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 601:	8b 45 e8             	mov    -0x18(%ebp),%eax
 604:	8b 50 04             	mov    0x4(%eax),%edx
 607:	8b 00                	mov    (%eax),%eax
 609:	83 ec 0c             	sub    $0xc,%esp
 60c:	6a 00                	push   $0x0
 60e:	6a 0a                	push   $0xa
 610:	52                   	push   %edx
 611:	50                   	push   %eax
 612:	ff 75 08             	pushl  0x8(%ebp)
 615:	e8 f7 fe ff ff       	call   511 <printlong>
 61a:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 61d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 621:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 625:	e9 d5 00 00 00       	jmp    6ff <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 62a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62e:	74 06                	je     636 <printf+0xd2>
 630:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 634:	75 1e                	jne    654 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 636:	8b 45 e8             	mov    -0x18(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	6a 00                	push   $0x0
 63d:	6a 10                	push   $0x10
 63f:	50                   	push   %eax
 640:	ff 75 08             	pushl  0x8(%ebp)
 643:	e8 19 fe ff ff       	call   461 <printint>
 648:	83 c4 10             	add    $0x10,%esp
        ap++;
 64b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64f:	e9 ab 00 00 00       	jmp    6ff <printf+0x19b>
      } else if(c == 's'){
 654:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 658:	75 40                	jne    69a <printf+0x136>
        s = (char*)*ap;
 65a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 662:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 66a:	75 07                	jne    673 <printf+0x10f>
          s = "(null)";
 66c:	c7 45 f4 6c 09 00 00 	movl   $0x96c,-0xc(%ebp)
        while(*s != 0){
 673:	eb 1a                	jmp    68f <printf+0x12b>
          putc(fd, *s);
 675:	8b 45 f4             	mov    -0xc(%ebp),%eax
 678:	8a 00                	mov    (%eax),%al
 67a:	0f be c0             	movsbl %al,%eax
 67d:	83 ec 08             	sub    $0x8,%esp
 680:	50                   	push   %eax
 681:	ff 75 08             	pushl  0x8(%ebp)
 684:	e8 b6 fd ff ff       	call   43f <putc>
 689:	83 c4 10             	add    $0x10,%esp
          s++;
 68c:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 68f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 692:	8a 00                	mov    (%eax),%al
 694:	84 c0                	test   %al,%al
 696:	75 dd                	jne    675 <printf+0x111>
 698:	eb 65                	jmp    6ff <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 69e:	75 1d                	jne    6bd <printf+0x159>
        putc(fd, *ap);
 6a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	83 ec 08             	sub    $0x8,%esp
 6ab:	50                   	push   %eax
 6ac:	ff 75 08             	pushl  0x8(%ebp)
 6af:	e8 8b fd ff ff       	call   43f <putc>
 6b4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bb:	eb 42                	jmp    6ff <printf+0x19b>
      } else if(c == '%'){
 6bd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c1:	75 17                	jne    6da <printf+0x176>
        putc(fd, c);
 6c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c6:	0f be c0             	movsbl %al,%eax
 6c9:	83 ec 08             	sub    $0x8,%esp
 6cc:	50                   	push   %eax
 6cd:	ff 75 08             	pushl  0x8(%ebp)
 6d0:	e8 6a fd ff ff       	call   43f <putc>
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	eb 25                	jmp    6ff <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6da:	83 ec 08             	sub    $0x8,%esp
 6dd:	6a 25                	push   $0x25
 6df:	ff 75 08             	pushl  0x8(%ebp)
 6e2:	e8 58 fd ff ff       	call   43f <putc>
 6e7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ed:	0f be c0             	movsbl %al,%eax
 6f0:	83 ec 08             	sub    $0x8,%esp
 6f3:	50                   	push   %eax
 6f4:	ff 75 08             	pushl  0x8(%ebp)
 6f7:	e8 43 fd ff ff       	call   43f <putc>
 6fc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 706:	ff 45 f0             	incl   -0x10(%ebp)
 709:	8b 55 0c             	mov    0xc(%ebp),%edx
 70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70f:	01 d0                	add    %edx,%eax
 711:	8a 00                	mov    (%eax),%al
 713:	84 c0                	test   %al,%al
 715:	0f 85 6b fe ff ff    	jne    586 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 71b:	c9                   	leave  
 71c:	c3                   	ret    

0000071d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71d:	55                   	push   %ebp
 71e:	89 e5                	mov    %esp,%ebp
 720:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 723:	8b 45 08             	mov    0x8(%ebp),%eax
 726:	83 e8 08             	sub    $0x8,%eax
 729:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	a1 04 0c 00 00       	mov    0xc04,%eax
 731:	89 45 fc             	mov    %eax,-0x4(%ebp)
 734:	eb 24                	jmp    75a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73e:	77 12                	ja     752 <free+0x35>
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 746:	77 24                	ja     76c <free+0x4f>
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 00                	mov    (%eax),%eax
 74d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 750:	77 1a                	ja     76c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 760:	76 d4                	jbe    736 <free+0x19>
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76a:	76 ca                	jbe    736 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 76c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	01 c2                	add    %eax,%edx
 77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 781:	8b 00                	mov    (%eax),%eax
 783:	39 c2                	cmp    %eax,%edx
 785:	75 24                	jne    7ab <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	8b 50 04             	mov    0x4(%eax),%edx
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	01 c2                	add    %eax,%edx
 797:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	8b 10                	mov    (%eax),%edx
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	89 10                	mov    %edx,(%eax)
 7a9:	eb 0a                	jmp    7b5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 10                	mov    (%eax),%edx
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 40 04             	mov    0x4(%eax),%eax
 7bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	01 d0                	add    %edx,%eax
 7c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ca:	75 20                	jne    7ec <free+0xcf>
    p->s.size += bp->s.size;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 50 04             	mov    0x4(%eax),%edx
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	01 c2                	add    %eax,%edx
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e3:	8b 10                	mov    (%eax),%edx
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	89 10                	mov    %edx,(%eax)
 7ea:	eb 08                	jmp    7f4 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f2:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	a3 04 0c 00 00       	mov    %eax,0xc04
}
 7fc:	c9                   	leave  
 7fd:	c3                   	ret    

000007fe <morecore>:

static Header*
morecore(uint nu)
{
 7fe:	55                   	push   %ebp
 7ff:	89 e5                	mov    %esp,%ebp
 801:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 804:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 80b:	77 07                	ja     814 <morecore+0x16>
    nu = 4096;
 80d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	c1 e0 03             	shl    $0x3,%eax
 81a:	83 ec 0c             	sub    $0xc,%esp
 81d:	50                   	push   %eax
 81e:	e8 f4 fb ff ff       	call   417 <sbrk>
 823:	83 c4 10             	add    $0x10,%esp
 826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 829:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 82d:	75 07                	jne    836 <morecore+0x38>
    return 0;
 82f:	b8 00 00 00 00       	mov    $0x0,%eax
 834:	eb 26                	jmp    85c <morecore+0x5e>
  hp = (Header*)p;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	8b 55 08             	mov    0x8(%ebp),%edx
 842:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 845:	8b 45 f0             	mov    -0x10(%ebp),%eax
 848:	83 c0 08             	add    $0x8,%eax
 84b:	83 ec 0c             	sub    $0xc,%esp
 84e:	50                   	push   %eax
 84f:	e8 c9 fe ff ff       	call   71d <free>
 854:	83 c4 10             	add    $0x10,%esp
  return freep;
 857:	a1 04 0c 00 00       	mov    0xc04,%eax
}
 85c:	c9                   	leave  
 85d:	c3                   	ret    

0000085e <malloc>:

void*
malloc(uint nbytes)
{
 85e:	55                   	push   %ebp
 85f:	89 e5                	mov    %esp,%ebp
 861:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 864:	8b 45 08             	mov    0x8(%ebp),%eax
 867:	83 c0 07             	add    $0x7,%eax
 86a:	c1 e8 03             	shr    $0x3,%eax
 86d:	40                   	inc    %eax
 86e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 871:	a1 04 0c 00 00       	mov    0xc04,%eax
 876:	89 45 f0             	mov    %eax,-0x10(%ebp)
 879:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 87d:	75 23                	jne    8a2 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 87f:	c7 45 f0 fc 0b 00 00 	movl   $0xbfc,-0x10(%ebp)
 886:	8b 45 f0             	mov    -0x10(%ebp),%eax
 889:	a3 04 0c 00 00       	mov    %eax,0xc04
 88e:	a1 04 0c 00 00       	mov    0xc04,%eax
 893:	a3 fc 0b 00 00       	mov    %eax,0xbfc
    base.s.size = 0;
 898:	c7 05 00 0c 00 00 00 	movl   $0x0,0xc00
 89f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a5:	8b 00                	mov    (%eax),%eax
 8a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	8b 40 04             	mov    0x4(%eax),%eax
 8b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b3:	72 4d                	jb     902 <malloc+0xa4>
      if(p->s.size == nunits)
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 40 04             	mov    0x4(%eax),%eax
 8bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8be:	75 0c                	jne    8cc <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	8b 10                	mov    (%eax),%edx
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c8:	89 10                	mov    %edx,(%eax)
 8ca:	eb 26                	jmp    8f2 <malloc+0x94>
      else {
        p->s.size -= nunits;
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 40 04             	mov    0x4(%eax),%eax
 8d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8d5:	89 c2                	mov    %eax,%edx
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	8b 40 04             	mov    0x4(%eax),%eax
 8e3:	c1 e0 03             	shl    $0x3,%eax
 8e6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ef:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f5:	a3 04 0c 00 00       	mov    %eax,0xc04
      return (void*)(p + 1);
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	83 c0 08             	add    $0x8,%eax
 900:	eb 3b                	jmp    93d <malloc+0xdf>
    }
    if(p == freep)
 902:	a1 04 0c 00 00       	mov    0xc04,%eax
 907:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 90a:	75 1e                	jne    92a <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 90c:	83 ec 0c             	sub    $0xc,%esp
 90f:	ff 75 ec             	pushl  -0x14(%ebp)
 912:	e8 e7 fe ff ff       	call   7fe <morecore>
 917:	83 c4 10             	add    $0x10,%esp
 91a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 91d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 921:	75 07                	jne    92a <malloc+0xcc>
        return 0;
 923:	b8 00 00 00 00       	mov    $0x0,%eax
 928:	eb 13                	jmp    93d <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	8b 00                	mov    (%eax),%eax
 935:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 938:	e9 6d ff ff ff       	jmp    8aa <malloc+0x4c>
}
 93d:	c9                   	leave  
 93e:	c3                   	ret    

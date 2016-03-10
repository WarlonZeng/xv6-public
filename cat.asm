
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 00 0c 00 00       	push   $0xc00
  13:	6a 01                	push   $0x1
  15:	e8 51 03 00 00       	call   36b <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 00 0c 00 00       	push   $0xc00
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 31 03 00 00       	call   363 <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 fb 08 00 00       	push   $0x8fb
  4c:	6a 01                	push   $0x1
  4e:	e8 cd 04 00 00       	call   520 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 f0 02 00 00       	call   34b <exit>
  }
}
  5b:	c9                   	leave  
  5c:	c3                   	ret    

0000005d <main>:

int
main(int argc, char *argv[])
{
  5d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  61:	83 e4 f0             	and    $0xfffffff0,%esp
  64:	ff 71 fc             	pushl  -0x4(%ecx)
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	53                   	push   %ebx
  6b:	51                   	push   %ecx
  6c:	83 ec 10             	sub    $0x10,%esp
  6f:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  71:	83 3b 01             	cmpl   $0x1,(%ebx)
  74:	7f 12                	jg     88 <main+0x2b>
    cat(0);
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	6a 00                	push   $0x0
  7b:	e8 80 ff ff ff       	call   0 <cat>
  80:	83 c4 10             	add    $0x10,%esp
    exit();
  83:	e8 c3 02 00 00       	call   34b <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  8f:	eb 70                	jmp    101 <main+0xa4>
    if((fd = open(argv[i], 0)) < 0){
  91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9b:	8b 43 04             	mov    0x4(%ebx),%eax
  9e:	01 d0                	add    %edx,%eax
  a0:	8b 00                	mov    (%eax),%eax
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	6a 00                	push   $0x0
  a7:	50                   	push   %eax
  a8:	e8 de 02 00 00       	call   38b <open>
  ad:	83 c4 10             	add    $0x10,%esp
  b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b7:	79 29                	jns    e2 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c3:	8b 43 04             	mov    0x4(%ebx),%eax
  c6:	01 d0                	add    %edx,%eax
  c8:	8b 00                	mov    (%eax),%eax
  ca:	83 ec 04             	sub    $0x4,%esp
  cd:	50                   	push   %eax
  ce:	68 0c 09 00 00       	push   $0x90c
  d3:	6a 01                	push   $0x1
  d5:	e8 46 04 00 00       	call   520 <printf>
  da:	83 c4 10             	add    $0x10,%esp
      exit();
  dd:	e8 69 02 00 00       	call   34b <exit>
    }
    cat(fd);
  e2:	83 ec 0c             	sub    $0xc,%esp
  e5:	ff 75 f0             	pushl  -0x10(%ebp)
  e8:	e8 13 ff ff ff       	call   0 <cat>
  ed:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f0:	83 ec 0c             	sub    $0xc,%esp
  f3:	ff 75 f0             	pushl  -0x10(%ebp)
  f6:	e8 78 02 00 00       	call   373 <close>
  fb:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  fe:	ff 45 f4             	incl   -0xc(%ebp)
 101:	8b 45 f4             	mov    -0xc(%ebp),%eax
 104:	3b 03                	cmp    (%ebx),%eax
 106:	7c 89                	jl     91 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 108:	e8 3e 02 00 00       	call   34b <exit>

0000010d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	57                   	push   %edi
 111:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 112:	8b 4d 08             	mov    0x8(%ebp),%ecx
 115:	8b 55 10             	mov    0x10(%ebp),%edx
 118:	8b 45 0c             	mov    0xc(%ebp),%eax
 11b:	89 cb                	mov    %ecx,%ebx
 11d:	89 df                	mov    %ebx,%edi
 11f:	89 d1                	mov    %edx,%ecx
 121:	fc                   	cld    
 122:	f3 aa                	rep stos %al,%es:(%edi)
 124:	89 ca                	mov    %ecx,%edx
 126:	89 fb                	mov    %edi,%ebx
 128:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 12e:	5b                   	pop    %ebx
 12f:	5f                   	pop    %edi
 130:	5d                   	pop    %ebp
 131:	c3                   	ret    

00000132 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 138:	8b 45 08             	mov    0x8(%ebp),%eax
 13b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13e:	90                   	nop
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	8d 50 01             	lea    0x1(%eax),%edx
 145:	89 55 08             	mov    %edx,0x8(%ebp)
 148:	8b 55 0c             	mov    0xc(%ebp),%edx
 14b:	8d 4a 01             	lea    0x1(%edx),%ecx
 14e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 151:	8a 12                	mov    (%edx),%dl
 153:	88 10                	mov    %dl,(%eax)
 155:	8a 00                	mov    (%eax),%al
 157:	84 c0                	test   %al,%al
 159:	75 e4                	jne    13f <strcpy+0xd>
    ;
  return os;
 15b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15e:	c9                   	leave  
 15f:	c3                   	ret    

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 163:	eb 06                	jmp    16b <strcmp+0xb>
    p++, q++;
 165:	ff 45 08             	incl   0x8(%ebp)
 168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	8a 00                	mov    (%eax),%al
 170:	84 c0                	test   %al,%al
 172:	74 0e                	je     182 <strcmp+0x22>
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 10                	mov    (%eax),%dl
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	8a 00                	mov    (%eax),%al
 17e:	38 c2                	cmp    %al,%dl
 180:	74 e3                	je     165 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	8a 00                	mov    (%eax),%al
 187:	0f b6 d0             	movzbl %al,%edx
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	8a 00                	mov    (%eax),%al
 18f:	0f b6 c0             	movzbl %al,%eax
 192:	29 c2                	sub    %eax,%edx
 194:	89 d0                	mov    %edx,%eax
}
 196:	5d                   	pop    %ebp
 197:	c3                   	ret    

00000198 <strlen>:

uint
strlen(char *s)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a5:	eb 03                	jmp    1aa <strlen+0x12>
 1a7:	ff 45 fc             	incl   -0x4(%ebp)
 1aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	01 d0                	add    %edx,%eax
 1b2:	8a 00                	mov    (%eax),%al
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ef                	jne    1a7 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	pushl  0xc(%ebp)
 1c7:	ff 75 08             	pushl  0x8(%ebp)
 1ca:	e8 3e ff ff ff       	call   10d <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 12                	jmp    1f7 <strchr+0x20>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	8a 00                	mov    (%eax),%al
 1ea:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ed:	75 05                	jne    1f4 <strchr+0x1d>
      return (char*)s;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	eb 11                	jmp    205 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f4:	ff 45 08             	incl   0x8(%ebp)
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	8a 00                	mov    (%eax),%al
 1fc:	84 c0                	test   %al,%al
 1fe:	75 e5                	jne    1e5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 200:	b8 00 00 00 00       	mov    $0x0,%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <gets>:

char*
gets(char *buf, int max)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 214:	eb 41                	jmp    257 <gets+0x50>
    cc = read(0, &c, 1);
 216:	83 ec 04             	sub    $0x4,%esp
 219:	6a 01                	push   $0x1
 21b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 21e:	50                   	push   %eax
 21f:	6a 00                	push   $0x0
 221:	e8 3d 01 00 00       	call   363 <read>
 226:	83 c4 10             	add    $0x10,%esp
 229:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 230:	7f 02                	jg     234 <gets+0x2d>
      break;
 232:	eb 2c                	jmp    260 <gets+0x59>
    buf[i++] = c;
 234:	8b 45 f4             	mov    -0xc(%ebp),%eax
 237:	8d 50 01             	lea    0x1(%eax),%edx
 23a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23d:	89 c2                	mov    %eax,%edx
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	01 c2                	add    %eax,%edx
 244:	8a 45 ef             	mov    -0x11(%ebp),%al
 247:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 249:	8a 45 ef             	mov    -0x11(%ebp),%al
 24c:	3c 0a                	cmp    $0xa,%al
 24e:	74 10                	je     260 <gets+0x59>
 250:	8a 45 ef             	mov    -0x11(%ebp),%al
 253:	3c 0d                	cmp    $0xd,%al
 255:	74 09                	je     260 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 257:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25a:	40                   	inc    %eax
 25b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 25e:	7c b6                	jl     216 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 260:	8b 55 f4             	mov    -0xc(%ebp),%edx
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	01 d0                	add    %edx,%eax
 268:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26e:	c9                   	leave  
 26f:	c3                   	ret    

00000270 <stat>:

int
stat(char *n, struct stat *st)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 276:	83 ec 08             	sub    $0x8,%esp
 279:	6a 00                	push   $0x0
 27b:	ff 75 08             	pushl  0x8(%ebp)
 27e:	e8 08 01 00 00       	call   38b <open>
 283:	83 c4 10             	add    $0x10,%esp
 286:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 28d:	79 07                	jns    296 <stat+0x26>
    return -1;
 28f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 294:	eb 25                	jmp    2bb <stat+0x4b>
  r = fstat(fd, st);
 296:	83 ec 08             	sub    $0x8,%esp
 299:	ff 75 0c             	pushl  0xc(%ebp)
 29c:	ff 75 f4             	pushl  -0xc(%ebp)
 29f:	e8 ff 00 00 00       	call   3a3 <fstat>
 2a4:	83 c4 10             	add    $0x10,%esp
 2a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2aa:	83 ec 0c             	sub    $0xc,%esp
 2ad:	ff 75 f4             	pushl  -0xc(%ebp)
 2b0:	e8 be 00 00 00       	call   373 <close>
 2b5:	83 c4 10             	add    $0x10,%esp
  return r;
 2b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <atoi>:

int
atoi(const char *s)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ca:	eb 24                	jmp    2f0 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2cf:	89 d0                	mov    %edx,%eax
 2d1:	c1 e0 02             	shl    $0x2,%eax
 2d4:	01 d0                	add    %edx,%eax
 2d6:	01 c0                	add    %eax,%eax
 2d8:	89 c1                	mov    %eax,%ecx
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	8d 50 01             	lea    0x1(%eax),%edx
 2e0:	89 55 08             	mov    %edx,0x8(%ebp)
 2e3:	8a 00                	mov    (%eax),%al
 2e5:	0f be c0             	movsbl %al,%eax
 2e8:	01 c8                	add    %ecx,%eax
 2ea:	83 e8 30             	sub    $0x30,%eax
 2ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	8a 00                	mov    (%eax),%al
 2f5:	3c 2f                	cmp    $0x2f,%al
 2f7:	7e 09                	jle    302 <atoi+0x45>
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	8a 00                	mov    (%eax),%al
 2fe:	3c 39                	cmp    $0x39,%al
 300:	7e ca                	jle    2cc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 302:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 313:	8b 45 0c             	mov    0xc(%ebp),%eax
 316:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 319:	eb 16                	jmp    331 <memmove+0x2a>
    *dst++ = *src++;
 31b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31e:	8d 50 01             	lea    0x1(%eax),%edx
 321:	89 55 fc             	mov    %edx,-0x4(%ebp)
 324:	8b 55 f8             	mov    -0x8(%ebp),%edx
 327:	8d 4a 01             	lea    0x1(%edx),%ecx
 32a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 32d:	8a 12                	mov    (%edx),%dl
 32f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 331:	8b 45 10             	mov    0x10(%ebp),%eax
 334:	8d 50 ff             	lea    -0x1(%eax),%edx
 337:	89 55 10             	mov    %edx,0x10(%ebp)
 33a:	85 c0                	test   %eax,%eax
 33c:	7f dd                	jg     31b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 343:	b8 01 00 00 00       	mov    $0x1,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <exit>:
SYSCALL(exit)
 34b:	b8 02 00 00 00       	mov    $0x2,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <wait>:
SYSCALL(wait)
 353:	b8 03 00 00 00       	mov    $0x3,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <pipe>:
SYSCALL(pipe)
 35b:	b8 04 00 00 00       	mov    $0x4,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <read>:
SYSCALL(read)
 363:	b8 05 00 00 00       	mov    $0x5,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <write>:
SYSCALL(write)
 36b:	b8 10 00 00 00       	mov    $0x10,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <close>:
SYSCALL(close)
 373:	b8 15 00 00 00       	mov    $0x15,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <kill>:
SYSCALL(kill)
 37b:	b8 06 00 00 00       	mov    $0x6,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <exec>:
SYSCALL(exec)
 383:	b8 07 00 00 00       	mov    $0x7,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <open>:
SYSCALL(open)
 38b:	b8 0f 00 00 00       	mov    $0xf,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <mknod>:
SYSCALL(mknod)
 393:	b8 11 00 00 00       	mov    $0x11,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <unlink>:
SYSCALL(unlink)
 39b:	b8 12 00 00 00       	mov    $0x12,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <fstat>:
SYSCALL(fstat)
 3a3:	b8 08 00 00 00       	mov    $0x8,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <link>:
SYSCALL(link)
 3ab:	b8 13 00 00 00       	mov    $0x13,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <mkdir>:
SYSCALL(mkdir)
 3b3:	b8 14 00 00 00       	mov    $0x14,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <chdir>:
SYSCALL(chdir)
 3bb:	b8 09 00 00 00       	mov    $0x9,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <dup>:
SYSCALL(dup)
 3c3:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <getpid>:
SYSCALL(getpid)
 3cb:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <sbrk>:
SYSCALL(sbrk)
 3d3:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <sleep>:
SYSCALL(sleep)
 3db:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <uptime>:
SYSCALL(uptime)
 3e3:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <gettime>:
SYSCALL(gettime)
 3eb:	b8 16 00 00 00       	mov    $0x16,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <settickets>:
SYSCALL(settickets)
 3f3:	b8 17 00 00 00       	mov    $0x17,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	83 ec 18             	sub    $0x18,%esp
 401:	8b 45 0c             	mov    0xc(%ebp),%eax
 404:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 407:	83 ec 04             	sub    $0x4,%esp
 40a:	6a 01                	push   $0x1
 40c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 40f:	50                   	push   %eax
 410:	ff 75 08             	pushl  0x8(%ebp)
 413:	e8 53 ff ff ff       	call   36b <write>
 418:	83 c4 10             	add    $0x10,%esp
}
 41b:	c9                   	leave  
 41c:	c3                   	ret    

0000041d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	53                   	push   %ebx
 421:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 424:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42f:	74 17                	je     448 <printint+0x2b>
 431:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 435:	79 11                	jns    448 <printint+0x2b>
    neg = 1;
 437:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	f7 d8                	neg    %eax
 443:	89 45 ec             	mov    %eax,-0x14(%ebp)
 446:	eb 06                	jmp    44e <printint+0x31>
  } else {
    x = xx;
 448:	8b 45 0c             	mov    0xc(%ebp),%eax
 44b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 455:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 458:	8d 41 01             	lea    0x1(%ecx),%eax
 45b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 461:	8b 45 ec             	mov    -0x14(%ebp),%eax
 464:	ba 00 00 00 00       	mov    $0x0,%edx
 469:	f7 f3                	div    %ebx
 46b:	89 d0                	mov    %edx,%eax
 46d:	8a 80 b4 0b 00 00    	mov    0xbb4(%eax),%al
 473:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 477:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47d:	ba 00 00 00 00       	mov    $0x0,%edx
 482:	f7 f3                	div    %ebx
 484:	89 45 ec             	mov    %eax,-0x14(%ebp)
 487:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48b:	75 c8                	jne    455 <printint+0x38>
  if(neg)
 48d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 491:	74 0e                	je     4a1 <printint+0x84>
    buf[i++] = '-';
 493:	8b 45 f4             	mov    -0xc(%ebp),%eax
 496:	8d 50 01             	lea    0x1(%eax),%edx
 499:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a1:	eb 1c                	jmp    4bf <printint+0xa2>
    putc(fd, buf[i]);
 4a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a9:	01 d0                	add    %edx,%eax
 4ab:	8a 00                	mov    (%eax),%al
 4ad:	0f be c0             	movsbl %al,%eax
 4b0:	83 ec 08             	sub    $0x8,%esp
 4b3:	50                   	push   %eax
 4b4:	ff 75 08             	pushl  0x8(%ebp)
 4b7:	e8 3f ff ff ff       	call   3fb <putc>
 4bc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4bf:	ff 4d f4             	decl   -0xc(%ebp)
 4c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c6:	79 db                	jns    4a3 <printint+0x86>
    putc(fd, buf[i]);
}
 4c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    

000004cd <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 4cd:	55                   	push   %ebp
 4ce:	89 e5                	mov    %esp,%ebp
 4d0:	83 ec 28             	sub    $0x28,%esp
 4d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 4d9:	8b 45 10             	mov    0x10(%ebp),%eax
 4dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 4df:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4e5:	89 d0                	mov    %edx,%eax
 4e7:	31 d2                	xor    %edx,%edx
 4e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 4ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 4f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f6:	74 13                	je     50b <printlong+0x3e>
 4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fb:	6a 00                	push   $0x0
 4fd:	6a 10                	push   $0x10
 4ff:	50                   	push   %eax
 500:	ff 75 08             	pushl  0x8(%ebp)
 503:	e8 15 ff ff ff       	call   41d <printint>
 508:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 50b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50e:	6a 00                	push   $0x0
 510:	6a 10                	push   $0x10
 512:	50                   	push   %eax
 513:	ff 75 08             	pushl  0x8(%ebp)
 516:	e8 02 ff ff ff       	call   41d <printint>
 51b:	83 c4 10             	add    $0x10,%esp
}
 51e:	c9                   	leave  
 51f:	c3                   	ret    

00000520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 526:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52d:	8d 45 0c             	lea    0xc(%ebp),%eax
 530:	83 c0 04             	add    $0x4,%eax
 533:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 536:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53d:	e9 83 01 00 00       	jmp    6c5 <printf+0x1a5>
    c = fmt[i] & 0xff;
 542:	8b 55 0c             	mov    0xc(%ebp),%edx
 545:	8b 45 f0             	mov    -0x10(%ebp),%eax
 548:	01 d0                	add    %edx,%eax
 54a:	8a 00                	mov    (%eax),%al
 54c:	0f be c0             	movsbl %al,%eax
 54f:	25 ff 00 00 00       	and    $0xff,%eax
 554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 557:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55b:	75 2c                	jne    589 <printf+0x69>
      if(c == '%'){
 55d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 561:	75 0c                	jne    56f <printf+0x4f>
        state = '%';
 563:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56a:	e9 53 01 00 00       	jmp    6c2 <printf+0x1a2>
      } else {
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	83 ec 08             	sub    $0x8,%esp
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 7a fe ff ff       	call   3fb <putc>
 581:	83 c4 10             	add    $0x10,%esp
 584:	e9 39 01 00 00       	jmp    6c2 <printf+0x1a2>
      }
    } else if(state == '%'){
 589:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58d:	0f 85 2f 01 00 00    	jne    6c2 <printf+0x1a2>
      if(c == 'd'){
 593:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 597:	75 1e                	jne    5b7 <printf+0x97>
        printint(fd, *ap, 10, 1);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	6a 01                	push   $0x1
 5a0:	6a 0a                	push   $0xa
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	pushl  0x8(%ebp)
 5a6:	e8 72 fe ff ff       	call   41d <printint>
 5ab:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	e9 04 01 00 00       	jmp    6bb <printf+0x19b>
      } else if(c == 'l') {
 5b7:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 5bb:	75 29                	jne    5e6 <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 5bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c0:	8b 50 04             	mov    0x4(%eax),%edx
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	83 ec 0c             	sub    $0xc,%esp
 5c8:	6a 00                	push   $0x0
 5ca:	6a 0a                	push   $0xa
 5cc:	52                   	push   %edx
 5cd:	50                   	push   %eax
 5ce:	ff 75 08             	pushl  0x8(%ebp)
 5d1:	e8 f7 fe ff ff       	call   4cd <printlong>
 5d6:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 5d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 5dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e1:	e9 d5 00 00 00       	jmp    6bb <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 5e6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ea:	74 06                	je     5f2 <printf+0xd2>
 5ec:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f0:	75 1e                	jne    610 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 5f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	6a 00                	push   $0x0
 5f9:	6a 10                	push   $0x10
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	pushl  0x8(%ebp)
 5ff:	e8 19 fe ff ff       	call   41d <printint>
 604:	83 c4 10             	add    $0x10,%esp
        ap++;
 607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60b:	e9 ab 00 00 00       	jmp    6bb <printf+0x19b>
      } else if(c == 's'){
 610:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 614:	75 40                	jne    656 <printf+0x136>
        s = (char*)*ap;
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 626:	75 07                	jne    62f <printf+0x10f>
          s = "(null)";
 628:	c7 45 f4 21 09 00 00 	movl   $0x921,-0xc(%ebp)
        while(*s != 0){
 62f:	eb 1a                	jmp    64b <printf+0x12b>
          putc(fd, *s);
 631:	8b 45 f4             	mov    -0xc(%ebp),%eax
 634:	8a 00                	mov    (%eax),%al
 636:	0f be c0             	movsbl %al,%eax
 639:	83 ec 08             	sub    $0x8,%esp
 63c:	50                   	push   %eax
 63d:	ff 75 08             	pushl  0x8(%ebp)
 640:	e8 b6 fd ff ff       	call   3fb <putc>
 645:	83 c4 10             	add    $0x10,%esp
          s++;
 648:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64e:	8a 00                	mov    (%eax),%al
 650:	84 c0                	test   %al,%al
 652:	75 dd                	jne    631 <printf+0x111>
 654:	eb 65                	jmp    6bb <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 656:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65a:	75 1d                	jne    679 <printf+0x159>
        putc(fd, *ap);
 65c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	83 ec 08             	sub    $0x8,%esp
 667:	50                   	push   %eax
 668:	ff 75 08             	pushl  0x8(%ebp)
 66b:	e8 8b fd ff ff       	call   3fb <putc>
 670:	83 c4 10             	add    $0x10,%esp
        ap++;
 673:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 677:	eb 42                	jmp    6bb <printf+0x19b>
      } else if(c == '%'){
 679:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67d:	75 17                	jne    696 <printf+0x176>
        putc(fd, c);
 67f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 682:	0f be c0             	movsbl %al,%eax
 685:	83 ec 08             	sub    $0x8,%esp
 688:	50                   	push   %eax
 689:	ff 75 08             	pushl  0x8(%ebp)
 68c:	e8 6a fd ff ff       	call   3fb <putc>
 691:	83 c4 10             	add    $0x10,%esp
 694:	eb 25                	jmp    6bb <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 696:	83 ec 08             	sub    $0x8,%esp
 699:	6a 25                	push   $0x25
 69b:	ff 75 08             	pushl  0x8(%ebp)
 69e:	e8 58 fd ff ff       	call   3fb <putc>
 6a3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a9:	0f be c0             	movsbl %al,%eax
 6ac:	83 ec 08             	sub    $0x8,%esp
 6af:	50                   	push   %eax
 6b0:	ff 75 08             	pushl  0x8(%ebp)
 6b3:	e8 43 fd ff ff       	call   3fb <putc>
 6b8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c2:	ff 45 f0             	incl   -0x10(%ebp)
 6c5:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cb:	01 d0                	add    %edx,%eax
 6cd:	8a 00                	mov    (%eax),%al
 6cf:	84 c0                	test   %al,%al
 6d1:	0f 85 6b fe ff ff    	jne    542 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d7:	c9                   	leave  
 6d8:	c3                   	ret    

000006d9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d9:	55                   	push   %ebp
 6da:	89 e5                	mov    %esp,%ebp
 6dc:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	83 e8 08             	sub    $0x8,%eax
 6e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e8:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 6ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f0:	eb 24                	jmp    716 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 00                	mov    (%eax),%eax
 6f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fa:	77 12                	ja     70e <free+0x35>
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 702:	77 24                	ja     728 <free+0x4f>
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70c:	77 1a                	ja     728 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	89 45 fc             	mov    %eax,-0x4(%ebp)
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71c:	76 d4                	jbe    6f2 <free+0x19>
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 726:	76 ca                	jbe    6f2 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	8b 40 04             	mov    0x4(%eax),%eax
 72e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	01 c2                	add    %eax,%edx
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	39 c2                	cmp    %eax,%edx
 741:	75 24                	jne    767 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	8b 50 04             	mov    0x4(%eax),%edx
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	01 c2                	add    %eax,%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	8b 10                	mov    (%eax),%edx
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	89 10                	mov    %edx,(%eax)
 765:	eb 0a                	jmp    771 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 10                	mov    (%eax),%edx
 76c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 40 04             	mov    0x4(%eax),%eax
 777:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 781:	01 d0                	add    %edx,%eax
 783:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 786:	75 20                	jne    7a8 <free+0xcf>
    p->s.size += bp->s.size;
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	8b 50 04             	mov    0x4(%eax),%edx
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	8b 40 04             	mov    0x4(%eax),%eax
 794:	01 c2                	add    %eax,%edx
 796:	8b 45 fc             	mov    -0x4(%ebp),%eax
 799:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	8b 10                	mov    (%eax),%edx
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	89 10                	mov    %edx,(%eax)
 7a6:	eb 08                	jmp    7b0 <free+0xd7>
  } else
    p->s.ptr = bp;
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ae:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	a3 e8 0b 00 00       	mov    %eax,0xbe8
}
 7b8:	c9                   	leave  
 7b9:	c3                   	ret    

000007ba <morecore>:

static Header*
morecore(uint nu)
{
 7ba:	55                   	push   %ebp
 7bb:	89 e5                	mov    %esp,%ebp
 7bd:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c7:	77 07                	ja     7d0 <morecore+0x16>
    nu = 4096;
 7c9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d0:	8b 45 08             	mov    0x8(%ebp),%eax
 7d3:	c1 e0 03             	shl    $0x3,%eax
 7d6:	83 ec 0c             	sub    $0xc,%esp
 7d9:	50                   	push   %eax
 7da:	e8 f4 fb ff ff       	call   3d3 <sbrk>
 7df:	83 c4 10             	add    $0x10,%esp
 7e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e9:	75 07                	jne    7f2 <morecore+0x38>
    return 0;
 7eb:	b8 00 00 00 00       	mov    $0x0,%eax
 7f0:	eb 26                	jmp    818 <morecore+0x5e>
  hp = (Header*)p;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fb:	8b 55 08             	mov    0x8(%ebp),%edx
 7fe:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 801:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804:	83 c0 08             	add    $0x8,%eax
 807:	83 ec 0c             	sub    $0xc,%esp
 80a:	50                   	push   %eax
 80b:	e8 c9 fe ff ff       	call   6d9 <free>
 810:	83 c4 10             	add    $0x10,%esp
  return freep;
 813:	a1 e8 0b 00 00       	mov    0xbe8,%eax
}
 818:	c9                   	leave  
 819:	c3                   	ret    

0000081a <malloc>:

void*
malloc(uint nbytes)
{
 81a:	55                   	push   %ebp
 81b:	89 e5                	mov    %esp,%ebp
 81d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 820:	8b 45 08             	mov    0x8(%ebp),%eax
 823:	83 c0 07             	add    $0x7,%eax
 826:	c1 e8 03             	shr    $0x3,%eax
 829:	40                   	inc    %eax
 82a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 82d:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
 835:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 839:	75 23                	jne    85e <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 83b:	c7 45 f0 e0 0b 00 00 	movl   $0xbe0,-0x10(%ebp)
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	a3 e8 0b 00 00       	mov    %eax,0xbe8
 84a:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 84f:	a3 e0 0b 00 00       	mov    %eax,0xbe0
    base.s.size = 0;
 854:	c7 05 e4 0b 00 00 00 	movl   $0x0,0xbe4
 85b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	8b 00                	mov    (%eax),%eax
 863:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86f:	72 4d                	jb     8be <malloc+0xa4>
      if(p->s.size == nunits)
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87a:	75 0c                	jne    888 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 10                	mov    (%eax),%edx
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	89 10                	mov    %edx,(%eax)
 886:	eb 26                	jmp    8ae <malloc+0x94>
      else {
        p->s.size -= nunits;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 40 04             	mov    0x4(%eax),%eax
 88e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 891:	89 c2                	mov    %eax,%edx
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	c1 e0 03             	shl    $0x3,%eax
 8a2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ab:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b1:	a3 e8 0b 00 00       	mov    %eax,0xbe8
      return (void*)(p + 1);
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	83 c0 08             	add    $0x8,%eax
 8bc:	eb 3b                	jmp    8f9 <malloc+0xdf>
    }
    if(p == freep)
 8be:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 8c3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c6:	75 1e                	jne    8e6 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 8c8:	83 ec 0c             	sub    $0xc,%esp
 8cb:	ff 75 ec             	pushl  -0x14(%ebp)
 8ce:	e8 e7 fe ff ff       	call   7ba <morecore>
 8d3:	83 c4 10             	add    $0x10,%esp
 8d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8dd:	75 07                	jne    8e6 <malloc+0xcc>
        return 0;
 8df:	b8 00 00 00 00       	mov    $0x0,%eax
 8e4:	eb 13                	jmp    8f9 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f4:	e9 6d ff ff ff       	jmp    866 <malloc+0x4c>
}
 8f9:	c9                   	leave  
 8fa:	c3                   	ret    

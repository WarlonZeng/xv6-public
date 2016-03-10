
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 63                	jmp    85 <wc+0x85>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 52                	jmp    7d <wc+0x7d>
      c++;
  2b:	ff 45 e8             	incl   -0x18(%ebp)
      if(buf[i] == '\n')
  2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  31:	05 c0 0c 00 00       	add    $0xcc0,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 c0 0c 00 00       	add    $0xcc0,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	50                   	push   %eax
  50:	68 a3 09 00 00       	push   $0x9a3
  55:	e8 25 02 00 00       	call   27f <strchr>
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	85 c0                	test   %eax,%eax
  5f:	74 09                	je     6a <wc+0x6a>
        inword = 0;
  61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  68:	eb 10                	jmp    7a <wc+0x7a>
      else if(!inword){
  6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  6e:	75 0a                	jne    7a <wc+0x7a>
        w++;
  70:	ff 45 ec             	incl   -0x14(%ebp)
        inword = 1;
  73:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7a:	ff 45 f4             	incl   -0xc(%ebp)
  7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  83:	7c a6                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  85:	83 ec 04             	sub    $0x4,%esp
  88:	68 00 02 00 00       	push   $0x200
  8d:	68 c0 0c 00 00       	push   $0xcc0
  92:	ff 75 08             	pushl  0x8(%ebp)
  95:	e8 71 03 00 00       	call   40b <read>
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  a4:	0f 8f 78 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ae:	79 17                	jns    c7 <wc+0xc7>
    printf(1, "wc: read error\n");
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	68 a9 09 00 00       	push   $0x9a9
  b8:	6a 01                	push   $0x1
  ba:	e8 09 05 00 00       	call   5c8 <printf>
  bf:	83 c4 10             	add    $0x10,%esp
    exit();
  c2:	e8 2c 03 00 00       	call   3f3 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  c7:	83 ec 08             	sub    $0x8,%esp
  ca:	ff 75 0c             	pushl  0xc(%ebp)
  cd:	ff 75 e8             	pushl  -0x18(%ebp)
  d0:	ff 75 ec             	pushl  -0x14(%ebp)
  d3:	ff 75 f0             	pushl  -0x10(%ebp)
  d6:	68 b9 09 00 00       	push   $0x9b9
  db:	6a 01                	push   $0x1
  dd:	e8 e6 04 00 00       	call   5c8 <printf>
  e2:	83 c4 20             	add    $0x20,%esp
}
  e5:	c9                   	leave  
  e6:	c3                   	ret    

000000e7 <main>:

int
main(int argc, char *argv[])
{
  e7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  eb:	83 e4 f0             	and    $0xfffffff0,%esp
  ee:	ff 71 fc             	pushl  -0x4(%ecx)
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	53                   	push   %ebx
  f5:	51                   	push   %ecx
  f6:	83 ec 10             	sub    $0x10,%esp
  f9:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  fb:	83 3b 01             	cmpl   $0x1,(%ebx)
  fe:	7f 17                	jg     117 <main+0x30>
    wc(0, "");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 c6 09 00 00       	push   $0x9c6
 108:	6a 00                	push   $0x0
 10a:	e8 f1 fe ff ff       	call   0 <wc>
 10f:	83 c4 10             	add    $0x10,%esp
    exit();
 112:	e8 dc 02 00 00       	call   3f3 <exit>
  }

  for(i = 1; i < argc; i++){
 117:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 11e:	e9 82 00 00 00       	jmp    1a5 <main+0xbe>
    if((fd = open(argv[i], 0)) < 0){
 123:	8b 45 f4             	mov    -0xc(%ebp),%eax
 126:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 12d:	8b 43 04             	mov    0x4(%ebx),%eax
 130:	01 d0                	add    %edx,%eax
 132:	8b 00                	mov    (%eax),%eax
 134:	83 ec 08             	sub    $0x8,%esp
 137:	6a 00                	push   $0x0
 139:	50                   	push   %eax
 13a:	e8 f4 02 00 00       	call   433 <open>
 13f:	83 c4 10             	add    $0x10,%esp
 142:	89 45 f0             	mov    %eax,-0x10(%ebp)
 145:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 149:	79 29                	jns    174 <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 14b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 14e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 155:	8b 43 04             	mov    0x4(%ebx),%eax
 158:	01 d0                	add    %edx,%eax
 15a:	8b 00                	mov    (%eax),%eax
 15c:	83 ec 04             	sub    $0x4,%esp
 15f:	50                   	push   %eax
 160:	68 c7 09 00 00       	push   $0x9c7
 165:	6a 01                	push   $0x1
 167:	e8 5c 04 00 00       	call   5c8 <printf>
 16c:	83 c4 10             	add    $0x10,%esp
      exit();
 16f:	e8 7f 02 00 00       	call   3f3 <exit>
    }
    wc(fd, argv[i]);
 174:	8b 45 f4             	mov    -0xc(%ebp),%eax
 177:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 17e:	8b 43 04             	mov    0x4(%ebx),%eax
 181:	01 d0                	add    %edx,%eax
 183:	8b 00                	mov    (%eax),%eax
 185:	83 ec 08             	sub    $0x8,%esp
 188:	50                   	push   %eax
 189:	ff 75 f0             	pushl  -0x10(%ebp)
 18c:	e8 6f fe ff ff       	call   0 <wc>
 191:	83 c4 10             	add    $0x10,%esp
    close(fd);
 194:	83 ec 0c             	sub    $0xc,%esp
 197:	ff 75 f0             	pushl  -0x10(%ebp)
 19a:	e8 7c 02 00 00       	call   41b <close>
 19f:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a2:	ff 45 f4             	incl   -0xc(%ebp)
 1a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a8:	3b 03                	cmp    (%ebx),%eax
 1aa:	0f 8c 73 ff ff ff    	jl     123 <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b0:	e8 3e 02 00 00       	call   3f3 <exit>

000001b5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	57                   	push   %edi
 1b9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bd:	8b 55 10             	mov    0x10(%ebp),%edx
 1c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c3:	89 cb                	mov    %ecx,%ebx
 1c5:	89 df                	mov    %ebx,%edi
 1c7:	89 d1                	mov    %edx,%ecx
 1c9:	fc                   	cld    
 1ca:	f3 aa                	rep stos %al,%es:(%edi)
 1cc:	89 ca                	mov    %ecx,%edx
 1ce:	89 fb                	mov    %edi,%ebx
 1d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d6:	5b                   	pop    %ebx
 1d7:	5f                   	pop    %edi
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    

000001da <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e6:	90                   	nop
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	8d 50 01             	lea    0x1(%eax),%edx
 1ed:	89 55 08             	mov    %edx,0x8(%ebp)
 1f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f3:	8d 4a 01             	lea    0x1(%edx),%ecx
 1f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1f9:	8a 12                	mov    (%edx),%dl
 1fb:	88 10                	mov    %dl,(%eax)
 1fd:	8a 00                	mov    (%eax),%al
 1ff:	84 c0                	test   %al,%al
 201:	75 e4                	jne    1e7 <strcpy+0xd>
    ;
  return os;
 203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 20b:	eb 06                	jmp    213 <strcmp+0xb>
    p++, q++;
 20d:	ff 45 08             	incl   0x8(%ebp)
 210:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	8a 00                	mov    (%eax),%al
 218:	84 c0                	test   %al,%al
 21a:	74 0e                	je     22a <strcmp+0x22>
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	8a 10                	mov    (%eax),%dl
 221:	8b 45 0c             	mov    0xc(%ebp),%eax
 224:	8a 00                	mov    (%eax),%al
 226:	38 c2                	cmp    %al,%dl
 228:	74 e3                	je     20d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	8a 00                	mov    (%eax),%al
 22f:	0f b6 d0             	movzbl %al,%edx
 232:	8b 45 0c             	mov    0xc(%ebp),%eax
 235:	8a 00                	mov    (%eax),%al
 237:	0f b6 c0             	movzbl %al,%eax
 23a:	29 c2                	sub    %eax,%edx
 23c:	89 d0                	mov    %edx,%eax
}
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    

00000240 <strlen>:

uint
strlen(char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 246:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 24d:	eb 03                	jmp    252 <strlen+0x12>
 24f:	ff 45 fc             	incl   -0x4(%ebp)
 252:	8b 55 fc             	mov    -0x4(%ebp),%edx
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	01 d0                	add    %edx,%eax
 25a:	8a 00                	mov    (%eax),%al
 25c:	84 c0                	test   %al,%al
 25e:	75 ef                	jne    24f <strlen+0xf>
    ;
  return n;
 260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <memset>:

void*
memset(void *dst, int c, uint n)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 268:	8b 45 10             	mov    0x10(%ebp),%eax
 26b:	50                   	push   %eax
 26c:	ff 75 0c             	pushl  0xc(%ebp)
 26f:	ff 75 08             	pushl  0x8(%ebp)
 272:	e8 3e ff ff ff       	call   1b5 <stosb>
 277:	83 c4 0c             	add    $0xc,%esp
  return dst;
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <strchr>:

char*
strchr(const char *s, char c)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 04             	sub    $0x4,%esp
 285:	8b 45 0c             	mov    0xc(%ebp),%eax
 288:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 28b:	eb 12                	jmp    29f <strchr+0x20>
    if(*s == c)
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	8a 00                	mov    (%eax),%al
 292:	3a 45 fc             	cmp    -0x4(%ebp),%al
 295:	75 05                	jne    29c <strchr+0x1d>
      return (char*)s;
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	eb 11                	jmp    2ad <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 29c:	ff 45 08             	incl   0x8(%ebp)
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	8a 00                	mov    (%eax),%al
 2a4:	84 c0                	test   %al,%al
 2a6:	75 e5                	jne    28d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ad:	c9                   	leave  
 2ae:	c3                   	ret    

000002af <gets>:

char*
gets(char *buf, int max)
{
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2bc:	eb 41                	jmp    2ff <gets+0x50>
    cc = read(0, &c, 1);
 2be:	83 ec 04             	sub    $0x4,%esp
 2c1:	6a 01                	push   $0x1
 2c3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2c6:	50                   	push   %eax
 2c7:	6a 00                	push   $0x0
 2c9:	e8 3d 01 00 00       	call   40b <read>
 2ce:	83 c4 10             	add    $0x10,%esp
 2d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2d8:	7f 02                	jg     2dc <gets+0x2d>
      break;
 2da:	eb 2c                	jmp    308 <gets+0x59>
    buf[i++] = c;
 2dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2df:	8d 50 01             	lea    0x1(%eax),%edx
 2e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2e5:	89 c2                	mov    %eax,%edx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	01 c2                	add    %eax,%edx
 2ec:	8a 45 ef             	mov    -0x11(%ebp),%al
 2ef:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2f1:	8a 45 ef             	mov    -0x11(%ebp),%al
 2f4:	3c 0a                	cmp    $0xa,%al
 2f6:	74 10                	je     308 <gets+0x59>
 2f8:	8a 45 ef             	mov    -0x11(%ebp),%al
 2fb:	3c 0d                	cmp    $0xd,%al
 2fd:	74 09                	je     308 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 302:	40                   	inc    %eax
 303:	3b 45 0c             	cmp    0xc(%ebp),%eax
 306:	7c b6                	jl     2be <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 308:	8b 55 f4             	mov    -0xc(%ebp),%edx
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	01 d0                	add    %edx,%eax
 310:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 313:	8b 45 08             	mov    0x8(%ebp),%eax
}
 316:	c9                   	leave  
 317:	c3                   	ret    

00000318 <stat>:

int
stat(char *n, struct stat *st)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 31e:	83 ec 08             	sub    $0x8,%esp
 321:	6a 00                	push   $0x0
 323:	ff 75 08             	pushl  0x8(%ebp)
 326:	e8 08 01 00 00       	call   433 <open>
 32b:	83 c4 10             	add    $0x10,%esp
 32e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 331:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 335:	79 07                	jns    33e <stat+0x26>
    return -1;
 337:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 33c:	eb 25                	jmp    363 <stat+0x4b>
  r = fstat(fd, st);
 33e:	83 ec 08             	sub    $0x8,%esp
 341:	ff 75 0c             	pushl  0xc(%ebp)
 344:	ff 75 f4             	pushl  -0xc(%ebp)
 347:	e8 ff 00 00 00       	call   44b <fstat>
 34c:	83 c4 10             	add    $0x10,%esp
 34f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 352:	83 ec 0c             	sub    $0xc,%esp
 355:	ff 75 f4             	pushl  -0xc(%ebp)
 358:	e8 be 00 00 00       	call   41b <close>
 35d:	83 c4 10             	add    $0x10,%esp
  return r;
 360:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 363:	c9                   	leave  
 364:	c3                   	ret    

00000365 <atoi>:

int
atoi(const char *s)
{
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
 368:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 36b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 372:	eb 24                	jmp    398 <atoi+0x33>
    n = n*10 + *s++ - '0';
 374:	8b 55 fc             	mov    -0x4(%ebp),%edx
 377:	89 d0                	mov    %edx,%eax
 379:	c1 e0 02             	shl    $0x2,%eax
 37c:	01 d0                	add    %edx,%eax
 37e:	01 c0                	add    %eax,%eax
 380:	89 c1                	mov    %eax,%ecx
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	8d 50 01             	lea    0x1(%eax),%edx
 388:	89 55 08             	mov    %edx,0x8(%ebp)
 38b:	8a 00                	mov    (%eax),%al
 38d:	0f be c0             	movsbl %al,%eax
 390:	01 c8                	add    %ecx,%eax
 392:	83 e8 30             	sub    $0x30,%eax
 395:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	8a 00                	mov    (%eax),%al
 39d:	3c 2f                	cmp    $0x2f,%al
 39f:	7e 09                	jle    3aa <atoi+0x45>
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	8a 00                	mov    (%eax),%al
 3a6:	3c 39                	cmp    $0x39,%al
 3a8:	7e ca                	jle    374 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3b5:	8b 45 08             	mov    0x8(%ebp),%eax
 3b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c1:	eb 16                	jmp    3d9 <memmove+0x2a>
    *dst++ = *src++;
 3c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c6:	8d 50 01             	lea    0x1(%eax),%edx
 3c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3cf:	8d 4a 01             	lea    0x1(%edx),%ecx
 3d2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3d5:	8a 12                	mov    (%edx),%dl
 3d7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3d9:	8b 45 10             	mov    0x10(%ebp),%eax
 3dc:	8d 50 ff             	lea    -0x1(%eax),%edx
 3df:	89 55 10             	mov    %edx,0x10(%ebp)
 3e2:	85 c0                	test   %eax,%eax
 3e4:	7f dd                	jg     3c3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e9:	c9                   	leave  
 3ea:	c3                   	ret    

000003eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3eb:	b8 01 00 00 00       	mov    $0x1,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <exit>:
SYSCALL(exit)
 3f3:	b8 02 00 00 00       	mov    $0x2,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <wait>:
SYSCALL(wait)
 3fb:	b8 03 00 00 00       	mov    $0x3,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <pipe>:
SYSCALL(pipe)
 403:	b8 04 00 00 00       	mov    $0x4,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <read>:
SYSCALL(read)
 40b:	b8 05 00 00 00       	mov    $0x5,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <write>:
SYSCALL(write)
 413:	b8 10 00 00 00       	mov    $0x10,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <close>:
SYSCALL(close)
 41b:	b8 15 00 00 00       	mov    $0x15,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <kill>:
SYSCALL(kill)
 423:	b8 06 00 00 00       	mov    $0x6,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <exec>:
SYSCALL(exec)
 42b:	b8 07 00 00 00       	mov    $0x7,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <open>:
SYSCALL(open)
 433:	b8 0f 00 00 00       	mov    $0xf,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <mknod>:
SYSCALL(mknod)
 43b:	b8 11 00 00 00       	mov    $0x11,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <unlink>:
SYSCALL(unlink)
 443:	b8 12 00 00 00       	mov    $0x12,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <fstat>:
SYSCALL(fstat)
 44b:	b8 08 00 00 00       	mov    $0x8,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <link>:
SYSCALL(link)
 453:	b8 13 00 00 00       	mov    $0x13,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <mkdir>:
SYSCALL(mkdir)
 45b:	b8 14 00 00 00       	mov    $0x14,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <chdir>:
SYSCALL(chdir)
 463:	b8 09 00 00 00       	mov    $0x9,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <dup>:
SYSCALL(dup)
 46b:	b8 0a 00 00 00       	mov    $0xa,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <getpid>:
SYSCALL(getpid)
 473:	b8 0b 00 00 00       	mov    $0xb,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <sbrk>:
SYSCALL(sbrk)
 47b:	b8 0c 00 00 00       	mov    $0xc,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <sleep>:
SYSCALL(sleep)
 483:	b8 0d 00 00 00       	mov    $0xd,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <uptime>:
SYSCALL(uptime)
 48b:	b8 0e 00 00 00       	mov    $0xe,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <gettime>:
SYSCALL(gettime)
 493:	b8 16 00 00 00       	mov    $0x16,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <settickets>:
SYSCALL(settickets)
 49b:	b8 17 00 00 00       	mov    $0x17,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a3:	55                   	push   %ebp
 4a4:	89 e5                	mov    %esp,%ebp
 4a6:	83 ec 18             	sub    $0x18,%esp
 4a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ac:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4af:	83 ec 04             	sub    $0x4,%esp
 4b2:	6a 01                	push   $0x1
 4b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b7:	50                   	push   %eax
 4b8:	ff 75 08             	pushl  0x8(%ebp)
 4bb:	e8 53 ff ff ff       	call   413 <write>
 4c0:	83 c4 10             	add    $0x10,%esp
}
 4c3:	c9                   	leave  
 4c4:	c3                   	ret    

000004c5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c5:	55                   	push   %ebp
 4c6:	89 e5                	mov    %esp,%ebp
 4c8:	53                   	push   %ebx
 4c9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d7:	74 17                	je     4f0 <printint+0x2b>
 4d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4dd:	79 11                	jns    4f0 <printint+0x2b>
    neg = 1;
 4df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e9:	f7 d8                	neg    %eax
 4eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ee:	eb 06                	jmp    4f6 <printint+0x31>
  } else {
    x = xx;
 4f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 500:	8d 41 01             	lea    0x1(%ecx),%eax
 503:	89 45 f4             	mov    %eax,-0xc(%ebp)
 506:	8b 5d 10             	mov    0x10(%ebp),%ebx
 509:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50c:	ba 00 00 00 00       	mov    $0x0,%edx
 511:	f7 f3                	div    %ebx
 513:	89 d0                	mov    %edx,%eax
 515:	8a 80 70 0c 00 00    	mov    0xc70(%eax),%al
 51b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 51f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 522:	8b 45 ec             	mov    -0x14(%ebp),%eax
 525:	ba 00 00 00 00       	mov    $0x0,%edx
 52a:	f7 f3                	div    %ebx
 52c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 533:	75 c8                	jne    4fd <printint+0x38>
  if(neg)
 535:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 539:	74 0e                	je     549 <printint+0x84>
    buf[i++] = '-';
 53b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53e:	8d 50 01             	lea    0x1(%eax),%edx
 541:	89 55 f4             	mov    %edx,-0xc(%ebp)
 544:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 549:	eb 1c                	jmp    567 <printint+0xa2>
    putc(fd, buf[i]);
 54b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	01 d0                	add    %edx,%eax
 553:	8a 00                	mov    (%eax),%al
 555:	0f be c0             	movsbl %al,%eax
 558:	83 ec 08             	sub    $0x8,%esp
 55b:	50                   	push   %eax
 55c:	ff 75 08             	pushl  0x8(%ebp)
 55f:	e8 3f ff ff ff       	call   4a3 <putc>
 564:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 567:	ff 4d f4             	decl   -0xc(%ebp)
 56a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56e:	79 db                	jns    54b <printint+0x86>
    putc(fd, buf[i]);
}
 570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 573:	c9                   	leave  
 574:	c3                   	ret    

00000575 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 575:	55                   	push   %ebp
 576:	89 e5                	mov    %esp,%ebp
 578:	83 ec 28             	sub    $0x28,%esp
 57b:	8b 45 0c             	mov    0xc(%ebp),%eax
 57e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 581:	8b 45 10             	mov    0x10(%ebp),%eax
 584:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 587:	8b 45 e0             	mov    -0x20(%ebp),%eax
 58a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 58d:	89 d0                	mov    %edx,%eax
 58f:	31 d2                	xor    %edx,%edx
 591:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 594:	8b 45 e0             	mov    -0x20(%ebp),%eax
 597:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 59a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59e:	74 13                	je     5b3 <printlong+0x3e>
 5a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a3:	6a 00                	push   $0x0
 5a5:	6a 10                	push   $0x10
 5a7:	50                   	push   %eax
 5a8:	ff 75 08             	pushl  0x8(%ebp)
 5ab:	e8 15 ff ff ff       	call   4c5 <printint>
 5b0:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 5b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b6:	6a 00                	push   $0x0
 5b8:	6a 10                	push   $0x10
 5ba:	50                   	push   %eax
 5bb:	ff 75 08             	pushl  0x8(%ebp)
 5be:	e8 02 ff ff ff       	call   4c5 <printint>
 5c3:	83 c4 10             	add    $0x10,%esp
}
 5c6:	c9                   	leave  
 5c7:	c3                   	ret    

000005c8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 5c8:	55                   	push   %ebp
 5c9:	89 e5                	mov    %esp,%ebp
 5cb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d8:	83 c0 04             	add    $0x4,%eax
 5db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e5:	e9 83 01 00 00       	jmp    76d <printf+0x1a5>
    c = fmt[i] & 0xff;
 5ea:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f0:	01 d0                	add    %edx,%eax
 5f2:	8a 00                	mov    (%eax),%al
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	25 ff 00 00 00       	and    $0xff,%eax
 5fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 603:	75 2c                	jne    631 <printf+0x69>
      if(c == '%'){
 605:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 609:	75 0c                	jne    617 <printf+0x4f>
        state = '%';
 60b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 612:	e9 53 01 00 00       	jmp    76a <printf+0x1a2>
      } else {
        putc(fd, c);
 617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61a:	0f be c0             	movsbl %al,%eax
 61d:	83 ec 08             	sub    $0x8,%esp
 620:	50                   	push   %eax
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 7a fe ff ff       	call   4a3 <putc>
 629:	83 c4 10             	add    $0x10,%esp
 62c:	e9 39 01 00 00       	jmp    76a <printf+0x1a2>
      }
    } else if(state == '%'){
 631:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 635:	0f 85 2f 01 00 00    	jne    76a <printf+0x1a2>
      if(c == 'd'){
 63b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 63f:	75 1e                	jne    65f <printf+0x97>
        printint(fd, *ap, 10, 1);
 641:	8b 45 e8             	mov    -0x18(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	6a 01                	push   $0x1
 648:	6a 0a                	push   $0xa
 64a:	50                   	push   %eax
 64b:	ff 75 08             	pushl  0x8(%ebp)
 64e:	e8 72 fe ff ff       	call   4c5 <printint>
 653:	83 c4 10             	add    $0x10,%esp
        ap++;
 656:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65a:	e9 04 01 00 00       	jmp    763 <printf+0x19b>
      } else if(c == 'l') {
 65f:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 663:	75 29                	jne    68e <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 665:	8b 45 e8             	mov    -0x18(%ebp),%eax
 668:	8b 50 04             	mov    0x4(%eax),%edx
 66b:	8b 00                	mov    (%eax),%eax
 66d:	83 ec 0c             	sub    $0xc,%esp
 670:	6a 00                	push   $0x0
 672:	6a 0a                	push   $0xa
 674:	52                   	push   %edx
 675:	50                   	push   %eax
 676:	ff 75 08             	pushl  0x8(%ebp)
 679:	e8 f7 fe ff ff       	call   575 <printlong>
 67e:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 681:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 685:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 689:	e9 d5 00 00 00       	jmp    763 <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 68e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 692:	74 06                	je     69a <printf+0xd2>
 694:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 698:	75 1e                	jne    6b8 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 69a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	6a 00                	push   $0x0
 6a1:	6a 10                	push   $0x10
 6a3:	50                   	push   %eax
 6a4:	ff 75 08             	pushl  0x8(%ebp)
 6a7:	e8 19 fe ff ff       	call   4c5 <printint>
 6ac:	83 c4 10             	add    $0x10,%esp
        ap++;
 6af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b3:	e9 ab 00 00 00       	jmp    763 <printf+0x19b>
      } else if(c == 's'){
 6b8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6bc:	75 40                	jne    6fe <printf+0x136>
        s = (char*)*ap;
 6be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ce:	75 07                	jne    6d7 <printf+0x10f>
          s = "(null)";
 6d0:	c7 45 f4 db 09 00 00 	movl   $0x9db,-0xc(%ebp)
        while(*s != 0){
 6d7:	eb 1a                	jmp    6f3 <printf+0x12b>
          putc(fd, *s);
 6d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6dc:	8a 00                	mov    (%eax),%al
 6de:	0f be c0             	movsbl %al,%eax
 6e1:	83 ec 08             	sub    $0x8,%esp
 6e4:	50                   	push   %eax
 6e5:	ff 75 08             	pushl  0x8(%ebp)
 6e8:	e8 b6 fd ff ff       	call   4a3 <putc>
 6ed:	83 c4 10             	add    $0x10,%esp
          s++;
 6f0:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f6:	8a 00                	mov    (%eax),%al
 6f8:	84 c0                	test   %al,%al
 6fa:	75 dd                	jne    6d9 <printf+0x111>
 6fc:	eb 65                	jmp    763 <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6fe:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 702:	75 1d                	jne    721 <printf+0x159>
        putc(fd, *ap);
 704:	8b 45 e8             	mov    -0x18(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	0f be c0             	movsbl %al,%eax
 70c:	83 ec 08             	sub    $0x8,%esp
 70f:	50                   	push   %eax
 710:	ff 75 08             	pushl  0x8(%ebp)
 713:	e8 8b fd ff ff       	call   4a3 <putc>
 718:	83 c4 10             	add    $0x10,%esp
        ap++;
 71b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 71f:	eb 42                	jmp    763 <printf+0x19b>
      } else if(c == '%'){
 721:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 725:	75 17                	jne    73e <printf+0x176>
        putc(fd, c);
 727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72a:	0f be c0             	movsbl %al,%eax
 72d:	83 ec 08             	sub    $0x8,%esp
 730:	50                   	push   %eax
 731:	ff 75 08             	pushl  0x8(%ebp)
 734:	e8 6a fd ff ff       	call   4a3 <putc>
 739:	83 c4 10             	add    $0x10,%esp
 73c:	eb 25                	jmp    763 <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 73e:	83 ec 08             	sub    $0x8,%esp
 741:	6a 25                	push   $0x25
 743:	ff 75 08             	pushl  0x8(%ebp)
 746:	e8 58 fd ff ff       	call   4a3 <putc>
 74b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 74e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 751:	0f be c0             	movsbl %al,%eax
 754:	83 ec 08             	sub    $0x8,%esp
 757:	50                   	push   %eax
 758:	ff 75 08             	pushl  0x8(%ebp)
 75b:	e8 43 fd ff ff       	call   4a3 <putc>
 760:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 763:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 76a:	ff 45 f0             	incl   -0x10(%ebp)
 76d:	8b 55 0c             	mov    0xc(%ebp),%edx
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	01 d0                	add    %edx,%eax
 775:	8a 00                	mov    (%eax),%al
 777:	84 c0                	test   %al,%al
 779:	0f 85 6b fe ff ff    	jne    5ea <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 77f:	c9                   	leave  
 780:	c3                   	ret    

00000781 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 781:	55                   	push   %ebp
 782:	89 e5                	mov    %esp,%ebp
 784:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 787:	8b 45 08             	mov    0x8(%ebp),%eax
 78a:	83 e8 08             	sub    $0x8,%eax
 78d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	a1 a8 0c 00 00       	mov    0xca8,%eax
 795:	89 45 fc             	mov    %eax,-0x4(%ebp)
 798:	eb 24                	jmp    7be <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	8b 00                	mov    (%eax),%eax
 79f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a2:	77 12                	ja     7b6 <free+0x35>
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7aa:	77 24                	ja     7d0 <free+0x4f>
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b4:	77 1a                	ja     7d0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c4:	76 d4                	jbe    79a <free+0x19>
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ce:	76 ca                	jbe    79a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d3:	8b 40 04             	mov    0x4(%eax),%eax
 7d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e0:	01 c2                	add    %eax,%edx
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	39 c2                	cmp    %eax,%edx
 7e9:	75 24                	jne    80f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	8b 50 04             	mov    0x4(%eax),%edx
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 00                	mov    (%eax),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	01 c2                	add    %eax,%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	8b 10                	mov    (%eax),%edx
 808:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80b:	89 10                	mov    %edx,(%eax)
 80d:	eb 0a                	jmp    819 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 10                	mov    (%eax),%edx
 814:	8b 45 f8             	mov    -0x8(%ebp),%eax
 817:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 40 04             	mov    0x4(%eax),%eax
 81f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	01 d0                	add    %edx,%eax
 82b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 82e:	75 20                	jne    850 <free+0xcf>
    p->s.size += bp->s.size;
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	8b 50 04             	mov    0x4(%eax),%edx
 836:	8b 45 f8             	mov    -0x8(%ebp),%eax
 839:	8b 40 04             	mov    0x4(%eax),%eax
 83c:	01 c2                	add    %eax,%edx
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 844:	8b 45 f8             	mov    -0x8(%ebp),%eax
 847:	8b 10                	mov    (%eax),%edx
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	89 10                	mov    %edx,(%eax)
 84e:	eb 08                	jmp    858 <free+0xd7>
  } else
    p->s.ptr = bp;
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	8b 55 f8             	mov    -0x8(%ebp),%edx
 856:	89 10                	mov    %edx,(%eax)
  freep = p;
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	a3 a8 0c 00 00       	mov    %eax,0xca8
}
 860:	c9                   	leave  
 861:	c3                   	ret    

00000862 <morecore>:

static Header*
morecore(uint nu)
{
 862:	55                   	push   %ebp
 863:	89 e5                	mov    %esp,%ebp
 865:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 868:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 86f:	77 07                	ja     878 <morecore+0x16>
    nu = 4096;
 871:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 878:	8b 45 08             	mov    0x8(%ebp),%eax
 87b:	c1 e0 03             	shl    $0x3,%eax
 87e:	83 ec 0c             	sub    $0xc,%esp
 881:	50                   	push   %eax
 882:	e8 f4 fb ff ff       	call   47b <sbrk>
 887:	83 c4 10             	add    $0x10,%esp
 88a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 88d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 891:	75 07                	jne    89a <morecore+0x38>
    return 0;
 893:	b8 00 00 00 00       	mov    $0x0,%eax
 898:	eb 26                	jmp    8c0 <morecore+0x5e>
  hp = (Header*)p;
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a3:	8b 55 08             	mov    0x8(%ebp),%edx
 8a6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ac:	83 c0 08             	add    $0x8,%eax
 8af:	83 ec 0c             	sub    $0xc,%esp
 8b2:	50                   	push   %eax
 8b3:	e8 c9 fe ff ff       	call   781 <free>
 8b8:	83 c4 10             	add    $0x10,%esp
  return freep;
 8bb:	a1 a8 0c 00 00       	mov    0xca8,%eax
}
 8c0:	c9                   	leave  
 8c1:	c3                   	ret    

000008c2 <malloc>:

void*
malloc(uint nbytes)
{
 8c2:	55                   	push   %ebp
 8c3:	89 e5                	mov    %esp,%ebp
 8c5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c8:	8b 45 08             	mov    0x8(%ebp),%eax
 8cb:	83 c0 07             	add    $0x7,%eax
 8ce:	c1 e8 03             	shr    $0x3,%eax
 8d1:	40                   	inc    %eax
 8d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8d5:	a1 a8 0c 00 00       	mov    0xca8,%eax
 8da:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e1:	75 23                	jne    906 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8e3:	c7 45 f0 a0 0c 00 00 	movl   $0xca0,-0x10(%ebp)
 8ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ed:	a3 a8 0c 00 00       	mov    %eax,0xca8
 8f2:	a1 a8 0c 00 00       	mov    0xca8,%eax
 8f7:	a3 a0 0c 00 00       	mov    %eax,0xca0
    base.s.size = 0;
 8fc:	c7 05 a4 0c 00 00 00 	movl   $0x0,0xca4
 903:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 906:	8b 45 f0             	mov    -0x10(%ebp),%eax
 909:	8b 00                	mov    (%eax),%eax
 90b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 917:	72 4d                	jb     966 <malloc+0xa4>
      if(p->s.size == nunits)
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	8b 40 04             	mov    0x4(%eax),%eax
 91f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 922:	75 0c                	jne    930 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	8b 10                	mov    (%eax),%edx
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	89 10                	mov    %edx,(%eax)
 92e:	eb 26                	jmp    956 <malloc+0x94>
      else {
        p->s.size -= nunits;
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	8b 40 04             	mov    0x4(%eax),%eax
 936:	2b 45 ec             	sub    -0x14(%ebp),%eax
 939:	89 c2                	mov    %eax,%edx
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	c1 e0 03             	shl    $0x3,%eax
 94a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	8b 55 ec             	mov    -0x14(%ebp),%edx
 953:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 956:	8b 45 f0             	mov    -0x10(%ebp),%eax
 959:	a3 a8 0c 00 00       	mov    %eax,0xca8
      return (void*)(p + 1);
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	83 c0 08             	add    $0x8,%eax
 964:	eb 3b                	jmp    9a1 <malloc+0xdf>
    }
    if(p == freep)
 966:	a1 a8 0c 00 00       	mov    0xca8,%eax
 96b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 96e:	75 1e                	jne    98e <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 970:	83 ec 0c             	sub    $0xc,%esp
 973:	ff 75 ec             	pushl  -0x14(%ebp)
 976:	e8 e7 fe ff ff       	call   862 <morecore>
 97b:	83 c4 10             	add    $0x10,%esp
 97e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 985:	75 07                	jne    98e <malloc+0xcc>
        return 0;
 987:	b8 00 00 00 00       	mov    $0x0,%eax
 98c:	eb 13                	jmp    9a1 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 991:	89 45 f0             	mov    %eax,-0x10(%ebp)
 994:	8b 45 f4             	mov    -0xc(%ebp),%eax
 997:	8b 00                	mov    (%eax),%eax
 999:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 99c:	e9 6d ff ff ff       	jmp    90e <malloc+0x4c>
}
 9a1:	c9                   	leave  
 9a2:	c3                   	ret    

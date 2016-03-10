
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 b3 03 00 00       	call   3c5 <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	8b 55 08             	mov    0x8(%ebp),%edx
  18:	01 d0                	add    %edx,%eax
  1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1d:	eb 03                	jmp    22 <fmtname+0x22>
  1f:	ff 4d f4             	decl   -0xc(%ebp)
  22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  25:	3b 45 08             	cmp    0x8(%ebp),%eax
  28:	72 09                	jb     33 <fmtname+0x33>
  2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2d:	8a 00                	mov    (%eax),%al
  2f:	3c 2f                	cmp    $0x2f,%al
  31:	75 ec                	jne    1f <fmtname+0x1f>
    ;
  p++;
  33:	ff 45 f4             	incl   -0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	83 ec 0c             	sub    $0xc,%esp
  39:	ff 75 f4             	pushl  -0xc(%ebp)
  3c:	e8 84 03 00 00       	call   3c5 <strlen>
  41:	83 c4 10             	add    $0x10,%esp
  44:	83 f8 0d             	cmp    $0xd,%eax
  47:	76 05                	jbe    4e <fmtname+0x4e>
    return p;
  49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4c:	eb 60                	jmp    ae <fmtname+0xae>
  memmove(buf, p, strlen(p));
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	ff 75 f4             	pushl  -0xc(%ebp)
  54:	e8 6c 03 00 00       	call   3c5 <strlen>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f4             	pushl  -0xc(%ebp)
  63:	68 50 0e 00 00       	push   $0xe50
  68:	e8 c7 04 00 00       	call   534 <memmove>
  6d:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  70:	83 ec 0c             	sub    $0xc,%esp
  73:	ff 75 f4             	pushl  -0xc(%ebp)
  76:	e8 4a 03 00 00       	call   3c5 <strlen>
  7b:	83 c4 10             	add    $0x10,%esp
  7e:	ba 0e 00 00 00       	mov    $0xe,%edx
  83:	89 d3                	mov    %edx,%ebx
  85:	29 c3                	sub    %eax,%ebx
  87:	83 ec 0c             	sub    $0xc,%esp
  8a:	ff 75 f4             	pushl  -0xc(%ebp)
  8d:	e8 33 03 00 00       	call   3c5 <strlen>
  92:	83 c4 10             	add    $0x10,%esp
  95:	05 50 0e 00 00       	add    $0xe50,%eax
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	53                   	push   %ebx
  9e:	6a 20                	push   $0x20
  a0:	50                   	push   %eax
  a1:	e8 44 03 00 00       	call   3ea <memset>
  a6:	83 c4 10             	add    $0x10,%esp
  return buf;
  a9:	b8 50 0e 00 00       	mov    $0xe50,%eax
}
  ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b1:	c9                   	leave  
  b2:	c3                   	ret    

000000b3 <ls>:

void
ls(char *path)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	57                   	push   %edi
  b7:	56                   	push   %esi
  b8:	53                   	push   %ebx
  b9:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	6a 00                	push   $0x0
  c4:	ff 75 08             	pushl  0x8(%ebp)
  c7:	e8 ec 04 00 00       	call   5b8 <open>
  cc:	83 c4 10             	add    $0x10,%esp
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 1a                	jns    f2 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  d8:	83 ec 04             	sub    $0x4,%esp
  db:	ff 75 08             	pushl  0x8(%ebp)
  de:	68 28 0b 00 00       	push   $0xb28
  e3:	6a 02                	push   $0x2
  e5:	e8 63 06 00 00       	call   74d <printf>
  ea:	83 c4 10             	add    $0x10,%esp
    return;
  ed:	e9 dd 01 00 00       	jmp    2cf <ls+0x21c>
  }
  
  if(fstat(fd, &st) < 0){
  f2:	83 ec 08             	sub    $0x8,%esp
  f5:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fb:	50                   	push   %eax
  fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  ff:	e8 cc 04 00 00       	call   5d0 <fstat>
 104:	83 c4 10             	add    $0x10,%esp
 107:	85 c0                	test   %eax,%eax
 109:	79 28                	jns    133 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 10b:	83 ec 04             	sub    $0x4,%esp
 10e:	ff 75 08             	pushl  0x8(%ebp)
 111:	68 3c 0b 00 00       	push   $0xb3c
 116:	6a 02                	push   $0x2
 118:	e8 30 06 00 00       	call   74d <printf>
 11d:	83 c4 10             	add    $0x10,%esp
    close(fd);
 120:	83 ec 0c             	sub    $0xc,%esp
 123:	ff 75 e4             	pushl  -0x1c(%ebp)
 126:	e8 75 04 00 00       	call   5a0 <close>
 12b:	83 c4 10             	add    $0x10,%esp
    return;
 12e:	e9 9c 01 00 00       	jmp    2cf <ls+0x21c>
  }
  
  switch(st.type){
 133:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 139:	98                   	cwtl   
 13a:	83 f8 01             	cmp    $0x1,%eax
 13d:	74 47                	je     186 <ls+0xd3>
 13f:	83 f8 02             	cmp    $0x2,%eax
 142:	0f 85 79 01 00 00    	jne    2c1 <ls+0x20e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 148:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 14e:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 154:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 15a:	0f bf d8             	movswl %ax,%ebx
 15d:	83 ec 0c             	sub    $0xc,%esp
 160:	ff 75 08             	pushl  0x8(%ebp)
 163:	e8 98 fe ff ff       	call   0 <fmtname>
 168:	83 c4 10             	add    $0x10,%esp
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	57                   	push   %edi
 16f:	56                   	push   %esi
 170:	53                   	push   %ebx
 171:	50                   	push   %eax
 172:	68 50 0b 00 00       	push   $0xb50
 177:	6a 01                	push   $0x1
 179:	e8 cf 05 00 00       	call   74d <printf>
 17e:	83 c4 20             	add    $0x20,%esp
    break;
 181:	e9 3b 01 00 00       	jmp    2c1 <ls+0x20e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 186:	83 ec 0c             	sub    $0xc,%esp
 189:	ff 75 08             	pushl  0x8(%ebp)
 18c:	e8 34 02 00 00       	call   3c5 <strlen>
 191:	83 c4 10             	add    $0x10,%esp
 194:	83 c0 10             	add    $0x10,%eax
 197:	3d 00 02 00 00       	cmp    $0x200,%eax
 19c:	76 17                	jbe    1b5 <ls+0x102>
      printf(1, "ls: path too long\n");
 19e:	83 ec 08             	sub    $0x8,%esp
 1a1:	68 5d 0b 00 00       	push   $0xb5d
 1a6:	6a 01                	push   $0x1
 1a8:	e8 a0 05 00 00       	call   74d <printf>
 1ad:	83 c4 10             	add    $0x10,%esp
      break;
 1b0:	e9 0c 01 00 00       	jmp    2c1 <ls+0x20e>
    }
    strcpy(buf, path);
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	ff 75 08             	pushl  0x8(%ebp)
 1bb:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c1:	50                   	push   %eax
 1c2:	e8 98 01 00 00       	call   35f <strcpy>
 1c7:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1ca:	83 ec 0c             	sub    $0xc,%esp
 1cd:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d3:	50                   	push   %eax
 1d4:	e8 ec 01 00 00       	call   3c5 <strlen>
 1d9:	83 c4 10             	add    $0x10,%esp
 1dc:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1e2:	01 d0                	add    %edx,%eax
 1e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1ea:	8d 50 01             	lea    0x1(%eax),%edx
 1ed:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f0:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f3:	e9 a8 00 00 00       	jmp    2a0 <ls+0x1ed>
      if(de.inum == 0)
 1f8:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
 1fe:	66 85 c0             	test   %ax,%ax
 201:	75 05                	jne    208 <ls+0x155>
        continue;
 203:	e9 98 00 00 00       	jmp    2a0 <ls+0x1ed>
      memmove(p, de.name, DIRSIZ);
 208:	83 ec 04             	sub    $0x4,%esp
 20b:	6a 0e                	push   $0xe
 20d:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 213:	83 c0 02             	add    $0x2,%eax
 216:	50                   	push   %eax
 217:	ff 75 e0             	pushl  -0x20(%ebp)
 21a:	e8 15 03 00 00       	call   534 <memmove>
 21f:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 222:	8b 45 e0             	mov    -0x20(%ebp),%eax
 225:	83 c0 0e             	add    $0xe,%eax
 228:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 22b:	83 ec 08             	sub    $0x8,%esp
 22e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 234:	50                   	push   %eax
 235:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 23b:	50                   	push   %eax
 23c:	e8 5c 02 00 00       	call   49d <stat>
 241:	83 c4 10             	add    $0x10,%esp
 244:	85 c0                	test   %eax,%eax
 246:	79 1b                	jns    263 <ls+0x1b0>
        printf(1, "ls: cannot stat %s\n", buf);
 248:	83 ec 04             	sub    $0x4,%esp
 24b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 251:	50                   	push   %eax
 252:	68 3c 0b 00 00       	push   $0xb3c
 257:	6a 01                	push   $0x1
 259:	e8 ef 04 00 00       	call   74d <printf>
 25e:	83 c4 10             	add    $0x10,%esp
        continue;
 261:	eb 3d                	jmp    2a0 <ls+0x1ed>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 263:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 269:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 26f:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 275:	0f bf d8             	movswl %ax,%ebx
 278:	83 ec 0c             	sub    $0xc,%esp
 27b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 281:	50                   	push   %eax
 282:	e8 79 fd ff ff       	call   0 <fmtname>
 287:	83 c4 10             	add    $0x10,%esp
 28a:	83 ec 08             	sub    $0x8,%esp
 28d:	57                   	push   %edi
 28e:	56                   	push   %esi
 28f:	53                   	push   %ebx
 290:	50                   	push   %eax
 291:	68 50 0b 00 00       	push   $0xb50
 296:	6a 01                	push   $0x1
 298:	e8 b0 04 00 00       	call   74d <printf>
 29d:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2a0:	83 ec 04             	sub    $0x4,%esp
 2a3:	6a 10                	push   $0x10
 2a5:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2ab:	50                   	push   %eax
 2ac:	ff 75 e4             	pushl  -0x1c(%ebp)
 2af:	e8 dc 02 00 00       	call   590 <read>
 2b4:	83 c4 10             	add    $0x10,%esp
 2b7:	83 f8 10             	cmp    $0x10,%eax
 2ba:	0f 84 38 ff ff ff    	je     1f8 <ls+0x145>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2c0:	90                   	nop
  }
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 e4             	pushl  -0x1c(%ebp)
 2c7:	e8 d4 02 00 00       	call   5a0 <close>
 2cc:	83 c4 10             	add    $0x10,%esp
}
 2cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d2:	5b                   	pop    %ebx
 2d3:	5e                   	pop    %esi
 2d4:	5f                   	pop    %edi
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    

000002d7 <main>:

int
main(int argc, char *argv[])
{
 2d7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2db:	83 e4 f0             	and    $0xfffffff0,%esp
 2de:	ff 71 fc             	pushl  -0x4(%ecx)
 2e1:	55                   	push   %ebp
 2e2:	89 e5                	mov    %esp,%ebp
 2e4:	53                   	push   %ebx
 2e5:	51                   	push   %ecx
 2e6:	83 ec 10             	sub    $0x10,%esp
 2e9:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2eb:	83 3b 01             	cmpl   $0x1,(%ebx)
 2ee:	7f 15                	jg     305 <main+0x2e>
    ls(".");
 2f0:	83 ec 0c             	sub    $0xc,%esp
 2f3:	68 70 0b 00 00       	push   $0xb70
 2f8:	e8 b6 fd ff ff       	call   b3 <ls>
 2fd:	83 c4 10             	add    $0x10,%esp
    exit();
 300:	e8 73 02 00 00       	call   578 <exit>
  }
  for(i=1; i<argc; i++)
 305:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 30c:	eb 20                	jmp    32e <main+0x57>
    ls(argv[i]);
 30e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 311:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 318:	8b 43 04             	mov    0x4(%ebx),%eax
 31b:	01 d0                	add    %edx,%eax
 31d:	8b 00                	mov    (%eax),%eax
 31f:	83 ec 0c             	sub    $0xc,%esp
 322:	50                   	push   %eax
 323:	e8 8b fd ff ff       	call   b3 <ls>
 328:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 32b:	ff 45 f4             	incl   -0xc(%ebp)
 32e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 331:	3b 03                	cmp    (%ebx),%eax
 333:	7c d9                	jl     30e <main+0x37>
    ls(argv[i]);
  exit();
 335:	e8 3e 02 00 00       	call   578 <exit>

0000033a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp
 33d:	57                   	push   %edi
 33e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 342:	8b 55 10             	mov    0x10(%ebp),%edx
 345:	8b 45 0c             	mov    0xc(%ebp),%eax
 348:	89 cb                	mov    %ecx,%ebx
 34a:	89 df                	mov    %ebx,%edi
 34c:	89 d1                	mov    %edx,%ecx
 34e:	fc                   	cld    
 34f:	f3 aa                	rep stos %al,%es:(%edi)
 351:	89 ca                	mov    %ecx,%edx
 353:	89 fb                	mov    %edi,%ebx
 355:	89 5d 08             	mov    %ebx,0x8(%ebp)
 358:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 35b:	5b                   	pop    %ebx
 35c:	5f                   	pop    %edi
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    

0000035f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 36b:	90                   	nop
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	8d 50 01             	lea    0x1(%eax),%edx
 372:	89 55 08             	mov    %edx,0x8(%ebp)
 375:	8b 55 0c             	mov    0xc(%ebp),%edx
 378:	8d 4a 01             	lea    0x1(%edx),%ecx
 37b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 37e:	8a 12                	mov    (%edx),%dl
 380:	88 10                	mov    %dl,(%eax)
 382:	8a 00                	mov    (%eax),%al
 384:	84 c0                	test   %al,%al
 386:	75 e4                	jne    36c <strcpy+0xd>
    ;
  return os;
 388:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38b:	c9                   	leave  
 38c:	c3                   	ret    

0000038d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 390:	eb 06                	jmp    398 <strcmp+0xb>
    p++, q++;
 392:	ff 45 08             	incl   0x8(%ebp)
 395:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	8a 00                	mov    (%eax),%al
 39d:	84 c0                	test   %al,%al
 39f:	74 0e                	je     3af <strcmp+0x22>
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	8a 10                	mov    (%eax),%dl
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	8a 00                	mov    (%eax),%al
 3ab:	38 c2                	cmp    %al,%dl
 3ad:	74 e3                	je     392 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	8a 00                	mov    (%eax),%al
 3b4:	0f b6 d0             	movzbl %al,%edx
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	8a 00                	mov    (%eax),%al
 3bc:	0f b6 c0             	movzbl %al,%eax
 3bf:	29 c2                	sub    %eax,%edx
 3c1:	89 d0                	mov    %edx,%eax
}
 3c3:	5d                   	pop    %ebp
 3c4:	c3                   	ret    

000003c5 <strlen>:

uint
strlen(char *s)
{
 3c5:	55                   	push   %ebp
 3c6:	89 e5                	mov    %esp,%ebp
 3c8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d2:	eb 03                	jmp    3d7 <strlen+0x12>
 3d4:	ff 45 fc             	incl   -0x4(%ebp)
 3d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	01 d0                	add    %edx,%eax
 3df:	8a 00                	mov    (%eax),%al
 3e1:	84 c0                	test   %al,%al
 3e3:	75 ef                	jne    3d4 <strlen+0xf>
    ;
  return n;
 3e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e8:	c9                   	leave  
 3e9:	c3                   	ret    

000003ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ed:	8b 45 10             	mov    0x10(%ebp),%eax
 3f0:	50                   	push   %eax
 3f1:	ff 75 0c             	pushl  0xc(%ebp)
 3f4:	ff 75 08             	pushl  0x8(%ebp)
 3f7:	e8 3e ff ff ff       	call   33a <stosb>
 3fc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <strchr>:

char*
strchr(const char *s, char c)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 04             	sub    $0x4,%esp
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 410:	eb 12                	jmp    424 <strchr+0x20>
    if(*s == c)
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	8a 00                	mov    (%eax),%al
 417:	3a 45 fc             	cmp    -0x4(%ebp),%al
 41a:	75 05                	jne    421 <strchr+0x1d>
      return (char*)s;
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	eb 11                	jmp    432 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 421:	ff 45 08             	incl   0x8(%ebp)
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	8a 00                	mov    (%eax),%al
 429:	84 c0                	test   %al,%al
 42b:	75 e5                	jne    412 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 42d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <gets>:

char*
gets(char *buf, int max)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 43a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 441:	eb 41                	jmp    484 <gets+0x50>
    cc = read(0, &c, 1);
 443:	83 ec 04             	sub    $0x4,%esp
 446:	6a 01                	push   $0x1
 448:	8d 45 ef             	lea    -0x11(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	6a 00                	push   $0x0
 44e:	e8 3d 01 00 00       	call   590 <read>
 453:	83 c4 10             	add    $0x10,%esp
 456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45d:	7f 02                	jg     461 <gets+0x2d>
      break;
 45f:	eb 2c                	jmp    48d <gets+0x59>
    buf[i++] = c;
 461:	8b 45 f4             	mov    -0xc(%ebp),%eax
 464:	8d 50 01             	lea    0x1(%eax),%edx
 467:	89 55 f4             	mov    %edx,-0xc(%ebp)
 46a:	89 c2                	mov    %eax,%edx
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	01 c2                	add    %eax,%edx
 471:	8a 45 ef             	mov    -0x11(%ebp),%al
 474:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 476:	8a 45 ef             	mov    -0x11(%ebp),%al
 479:	3c 0a                	cmp    $0xa,%al
 47b:	74 10                	je     48d <gets+0x59>
 47d:	8a 45 ef             	mov    -0x11(%ebp),%al
 480:	3c 0d                	cmp    $0xd,%al
 482:	74 09                	je     48d <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 484:	8b 45 f4             	mov    -0xc(%ebp),%eax
 487:	40                   	inc    %eax
 488:	3b 45 0c             	cmp    0xc(%ebp),%eax
 48b:	7c b6                	jl     443 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 48d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	01 d0                	add    %edx,%eax
 495:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 498:	8b 45 08             	mov    0x8(%ebp),%eax
}
 49b:	c9                   	leave  
 49c:	c3                   	ret    

0000049d <stat>:

int
stat(char *n, struct stat *st)
{
 49d:	55                   	push   %ebp
 49e:	89 e5                	mov    %esp,%ebp
 4a0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a3:	83 ec 08             	sub    $0x8,%esp
 4a6:	6a 00                	push   $0x0
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 08 01 00 00       	call   5b8 <open>
 4b0:	83 c4 10             	add    $0x10,%esp
 4b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ba:	79 07                	jns    4c3 <stat+0x26>
    return -1;
 4bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4c1:	eb 25                	jmp    4e8 <stat+0x4b>
  r = fstat(fd, st);
 4c3:	83 ec 08             	sub    $0x8,%esp
 4c6:	ff 75 0c             	pushl  0xc(%ebp)
 4c9:	ff 75 f4             	pushl  -0xc(%ebp)
 4cc:	e8 ff 00 00 00       	call   5d0 <fstat>
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4d7:	83 ec 0c             	sub    $0xc,%esp
 4da:	ff 75 f4             	pushl  -0xc(%ebp)
 4dd:	e8 be 00 00 00       	call   5a0 <close>
 4e2:	83 c4 10             	add    $0x10,%esp
  return r;
 4e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4e8:	c9                   	leave  
 4e9:	c3                   	ret    

000004ea <atoi>:

int
atoi(const char *s)
{
 4ea:	55                   	push   %ebp
 4eb:	89 e5                	mov    %esp,%ebp
 4ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4f7:	eb 24                	jmp    51d <atoi+0x33>
    n = n*10 + *s++ - '0';
 4f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4fc:	89 d0                	mov    %edx,%eax
 4fe:	c1 e0 02             	shl    $0x2,%eax
 501:	01 d0                	add    %edx,%eax
 503:	01 c0                	add    %eax,%eax
 505:	89 c1                	mov    %eax,%ecx
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	8d 50 01             	lea    0x1(%eax),%edx
 50d:	89 55 08             	mov    %edx,0x8(%ebp)
 510:	8a 00                	mov    (%eax),%al
 512:	0f be c0             	movsbl %al,%eax
 515:	01 c8                	add    %ecx,%eax
 517:	83 e8 30             	sub    $0x30,%eax
 51a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	8a 00                	mov    (%eax),%al
 522:	3c 2f                	cmp    $0x2f,%al
 524:	7e 09                	jle    52f <atoi+0x45>
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	8a 00                	mov    (%eax),%al
 52b:	3c 39                	cmp    $0x39,%al
 52d:	7e ca                	jle    4f9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 52f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 540:	8b 45 0c             	mov    0xc(%ebp),%eax
 543:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 546:	eb 16                	jmp    55e <memmove+0x2a>
    *dst++ = *src++;
 548:	8b 45 fc             	mov    -0x4(%ebp),%eax
 54b:	8d 50 01             	lea    0x1(%eax),%edx
 54e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 551:	8b 55 f8             	mov    -0x8(%ebp),%edx
 554:	8d 4a 01             	lea    0x1(%edx),%ecx
 557:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 55a:	8a 12                	mov    (%edx),%dl
 55c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 55e:	8b 45 10             	mov    0x10(%ebp),%eax
 561:	8d 50 ff             	lea    -0x1(%eax),%edx
 564:	89 55 10             	mov    %edx,0x10(%ebp)
 567:	85 c0                	test   %eax,%eax
 569:	7f dd                	jg     548 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 56e:	c9                   	leave  
 56f:	c3                   	ret    

00000570 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 570:	b8 01 00 00 00       	mov    $0x1,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <exit>:
SYSCALL(exit)
 578:	b8 02 00 00 00       	mov    $0x2,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <wait>:
SYSCALL(wait)
 580:	b8 03 00 00 00       	mov    $0x3,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <pipe>:
SYSCALL(pipe)
 588:	b8 04 00 00 00       	mov    $0x4,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <read>:
SYSCALL(read)
 590:	b8 05 00 00 00       	mov    $0x5,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <write>:
SYSCALL(write)
 598:	b8 10 00 00 00       	mov    $0x10,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <close>:
SYSCALL(close)
 5a0:	b8 15 00 00 00       	mov    $0x15,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <kill>:
SYSCALL(kill)
 5a8:	b8 06 00 00 00       	mov    $0x6,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <exec>:
SYSCALL(exec)
 5b0:	b8 07 00 00 00       	mov    $0x7,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <open>:
SYSCALL(open)
 5b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <mknod>:
SYSCALL(mknod)
 5c0:	b8 11 00 00 00       	mov    $0x11,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <unlink>:
SYSCALL(unlink)
 5c8:	b8 12 00 00 00       	mov    $0x12,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <fstat>:
SYSCALL(fstat)
 5d0:	b8 08 00 00 00       	mov    $0x8,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <link>:
SYSCALL(link)
 5d8:	b8 13 00 00 00       	mov    $0x13,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <mkdir>:
SYSCALL(mkdir)
 5e0:	b8 14 00 00 00       	mov    $0x14,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <chdir>:
SYSCALL(chdir)
 5e8:	b8 09 00 00 00       	mov    $0x9,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <dup>:
SYSCALL(dup)
 5f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <getpid>:
SYSCALL(getpid)
 5f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <sbrk>:
SYSCALL(sbrk)
 600:	b8 0c 00 00 00       	mov    $0xc,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <sleep>:
SYSCALL(sleep)
 608:	b8 0d 00 00 00       	mov    $0xd,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <uptime>:
SYSCALL(uptime)
 610:	b8 0e 00 00 00       	mov    $0xe,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <gettime>:
SYSCALL(gettime)
 618:	b8 16 00 00 00       	mov    $0x16,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <settickets>:
SYSCALL(settickets)
 620:	b8 17 00 00 00       	mov    $0x17,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 628:	55                   	push   %ebp
 629:	89 e5                	mov    %esp,%ebp
 62b:	83 ec 18             	sub    $0x18,%esp
 62e:	8b 45 0c             	mov    0xc(%ebp),%eax
 631:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 634:	83 ec 04             	sub    $0x4,%esp
 637:	6a 01                	push   $0x1
 639:	8d 45 f4             	lea    -0xc(%ebp),%eax
 63c:	50                   	push   %eax
 63d:	ff 75 08             	pushl  0x8(%ebp)
 640:	e8 53 ff ff ff       	call   598 <write>
 645:	83 c4 10             	add    $0x10,%esp
}
 648:	c9                   	leave  
 649:	c3                   	ret    

0000064a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64a:	55                   	push   %ebp
 64b:	89 e5                	mov    %esp,%ebp
 64d:	53                   	push   %ebx
 64e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 658:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 65c:	74 17                	je     675 <printint+0x2b>
 65e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 662:	79 11                	jns    675 <printint+0x2b>
    neg = 1;
 664:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 66b:	8b 45 0c             	mov    0xc(%ebp),%eax
 66e:	f7 d8                	neg    %eax
 670:	89 45 ec             	mov    %eax,-0x14(%ebp)
 673:	eb 06                	jmp    67b <printint+0x31>
  } else {
    x = xx;
 675:	8b 45 0c             	mov    0xc(%ebp),%eax
 678:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 67b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 682:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 685:	8d 41 01             	lea    0x1(%ecx),%eax
 688:	89 45 f4             	mov    %eax,-0xc(%ebp)
 68b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 68e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 691:	ba 00 00 00 00       	mov    $0x0,%edx
 696:	f7 f3                	div    %ebx
 698:	89 d0                	mov    %edx,%eax
 69a:	8a 80 3c 0e 00 00    	mov    0xe3c(%eax),%al
 6a0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6aa:	ba 00 00 00 00       	mov    $0x0,%edx
 6af:	f7 f3                	div    %ebx
 6b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b8:	75 c8                	jne    682 <printint+0x38>
  if(neg)
 6ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6be:	74 0e                	je     6ce <printint+0x84>
    buf[i++] = '-';
 6c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c3:	8d 50 01             	lea    0x1(%eax),%edx
 6c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ce:	eb 1c                	jmp    6ec <printint+0xa2>
    putc(fd, buf[i]);
 6d0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d6:	01 d0                	add    %edx,%eax
 6d8:	8a 00                	mov    (%eax),%al
 6da:	0f be c0             	movsbl %al,%eax
 6dd:	83 ec 08             	sub    $0x8,%esp
 6e0:	50                   	push   %eax
 6e1:	ff 75 08             	pushl  0x8(%ebp)
 6e4:	e8 3f ff ff ff       	call   628 <putc>
 6e9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ec:	ff 4d f4             	decl   -0xc(%ebp)
 6ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f3:	79 db                	jns    6d0 <printint+0x86>
    putc(fd, buf[i]);
}
 6f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6f8:	c9                   	leave  
 6f9:	c3                   	ret    

000006fa <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 6fa:	55                   	push   %ebp
 6fb:	89 e5                	mov    %esp,%ebp
 6fd:	83 ec 28             	sub    $0x28,%esp
 700:	8b 45 0c             	mov    0xc(%ebp),%eax
 703:	89 45 e0             	mov    %eax,-0x20(%ebp)
 706:	8b 45 10             	mov    0x10(%ebp),%eax
 709:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 70c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 70f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 712:	89 d0                	mov    %edx,%eax
 714:	31 d2                	xor    %edx,%edx
 716:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 719:	8b 45 e0             	mov    -0x20(%ebp),%eax
 71c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 71f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 723:	74 13                	je     738 <printlong+0x3e>
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	6a 00                	push   $0x0
 72a:	6a 10                	push   $0x10
 72c:	50                   	push   %eax
 72d:	ff 75 08             	pushl  0x8(%ebp)
 730:	e8 15 ff ff ff       	call   64a <printint>
 735:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	6a 00                	push   $0x0
 73d:	6a 10                	push   $0x10
 73f:	50                   	push   %eax
 740:	ff 75 08             	pushl  0x8(%ebp)
 743:	e8 02 ff ff ff       	call   64a <printint>
 748:	83 c4 10             	add    $0x10,%esp
}
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 753:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 75a:	8d 45 0c             	lea    0xc(%ebp),%eax
 75d:	83 c0 04             	add    $0x4,%eax
 760:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 76a:	e9 83 01 00 00       	jmp    8f2 <printf+0x1a5>
    c = fmt[i] & 0xff;
 76f:	8b 55 0c             	mov    0xc(%ebp),%edx
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	01 d0                	add    %edx,%eax
 777:	8a 00                	mov    (%eax),%al
 779:	0f be c0             	movsbl %al,%eax
 77c:	25 ff 00 00 00       	and    $0xff,%eax
 781:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 784:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 788:	75 2c                	jne    7b6 <printf+0x69>
      if(c == '%'){
 78a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 78e:	75 0c                	jne    79c <printf+0x4f>
        state = '%';
 790:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 797:	e9 53 01 00 00       	jmp    8ef <printf+0x1a2>
      } else {
        putc(fd, c);
 79c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79f:	0f be c0             	movsbl %al,%eax
 7a2:	83 ec 08             	sub    $0x8,%esp
 7a5:	50                   	push   %eax
 7a6:	ff 75 08             	pushl  0x8(%ebp)
 7a9:	e8 7a fe ff ff       	call   628 <putc>
 7ae:	83 c4 10             	add    $0x10,%esp
 7b1:	e9 39 01 00 00       	jmp    8ef <printf+0x1a2>
      }
    } else if(state == '%'){
 7b6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7ba:	0f 85 2f 01 00 00    	jne    8ef <printf+0x1a2>
      if(c == 'd'){
 7c0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7c4:	75 1e                	jne    7e4 <printf+0x97>
        printint(fd, *ap, 10, 1);
 7c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	6a 01                	push   $0x1
 7cd:	6a 0a                	push   $0xa
 7cf:	50                   	push   %eax
 7d0:	ff 75 08             	pushl  0x8(%ebp)
 7d3:	e8 72 fe ff ff       	call   64a <printint>
 7d8:	83 c4 10             	add    $0x10,%esp
        ap++;
 7db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7df:	e9 04 01 00 00       	jmp    8e8 <printf+0x19b>
      } else if(c == 'l') {
 7e4:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 7e8:	75 29                	jne    813 <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 7ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ed:	8b 50 04             	mov    0x4(%eax),%edx
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	83 ec 0c             	sub    $0xc,%esp
 7f5:	6a 00                	push   $0x0
 7f7:	6a 0a                	push   $0xa
 7f9:	52                   	push   %edx
 7fa:	50                   	push   %eax
 7fb:	ff 75 08             	pushl  0x8(%ebp)
 7fe:	e8 f7 fe ff ff       	call   6fa <printlong>
 803:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 806:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 80a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80e:	e9 d5 00 00 00       	jmp    8e8 <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 813:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 817:	74 06                	je     81f <printf+0xd2>
 819:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 81d:	75 1e                	jne    83d <printf+0xf0>
        printint(fd, *ap, 16, 0);
 81f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	6a 00                	push   $0x0
 826:	6a 10                	push   $0x10
 828:	50                   	push   %eax
 829:	ff 75 08             	pushl  0x8(%ebp)
 82c:	e8 19 fe ff ff       	call   64a <printint>
 831:	83 c4 10             	add    $0x10,%esp
        ap++;
 834:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 838:	e9 ab 00 00 00       	jmp    8e8 <printf+0x19b>
      } else if(c == 's'){
 83d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 841:	75 40                	jne    883 <printf+0x136>
        s = (char*)*ap;
 843:	8b 45 e8             	mov    -0x18(%ebp),%eax
 846:	8b 00                	mov    (%eax),%eax
 848:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 84b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 84f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 853:	75 07                	jne    85c <printf+0x10f>
          s = "(null)";
 855:	c7 45 f4 72 0b 00 00 	movl   $0xb72,-0xc(%ebp)
        while(*s != 0){
 85c:	eb 1a                	jmp    878 <printf+0x12b>
          putc(fd, *s);
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	8a 00                	mov    (%eax),%al
 863:	0f be c0             	movsbl %al,%eax
 866:	83 ec 08             	sub    $0x8,%esp
 869:	50                   	push   %eax
 86a:	ff 75 08             	pushl  0x8(%ebp)
 86d:	e8 b6 fd ff ff       	call   628 <putc>
 872:	83 c4 10             	add    $0x10,%esp
          s++;
 875:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	8a 00                	mov    (%eax),%al
 87d:	84 c0                	test   %al,%al
 87f:	75 dd                	jne    85e <printf+0x111>
 881:	eb 65                	jmp    8e8 <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 883:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 887:	75 1d                	jne    8a6 <printf+0x159>
        putc(fd, *ap);
 889:	8b 45 e8             	mov    -0x18(%ebp),%eax
 88c:	8b 00                	mov    (%eax),%eax
 88e:	0f be c0             	movsbl %al,%eax
 891:	83 ec 08             	sub    $0x8,%esp
 894:	50                   	push   %eax
 895:	ff 75 08             	pushl  0x8(%ebp)
 898:	e8 8b fd ff ff       	call   628 <putc>
 89d:	83 c4 10             	add    $0x10,%esp
        ap++;
 8a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8a4:	eb 42                	jmp    8e8 <printf+0x19b>
      } else if(c == '%'){
 8a6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8aa:	75 17                	jne    8c3 <printf+0x176>
        putc(fd, c);
 8ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8af:	0f be c0             	movsbl %al,%eax
 8b2:	83 ec 08             	sub    $0x8,%esp
 8b5:	50                   	push   %eax
 8b6:	ff 75 08             	pushl  0x8(%ebp)
 8b9:	e8 6a fd ff ff       	call   628 <putc>
 8be:	83 c4 10             	add    $0x10,%esp
 8c1:	eb 25                	jmp    8e8 <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c3:	83 ec 08             	sub    $0x8,%esp
 8c6:	6a 25                	push   $0x25
 8c8:	ff 75 08             	pushl  0x8(%ebp)
 8cb:	e8 58 fd ff ff       	call   628 <putc>
 8d0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8d6:	0f be c0             	movsbl %al,%eax
 8d9:	83 ec 08             	sub    $0x8,%esp
 8dc:	50                   	push   %eax
 8dd:	ff 75 08             	pushl  0x8(%ebp)
 8e0:	e8 43 fd ff ff       	call   628 <putc>
 8e5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8ef:	ff 45 f0             	incl   -0x10(%ebp)
 8f2:	8b 55 0c             	mov    0xc(%ebp),%edx
 8f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f8:	01 d0                	add    %edx,%eax
 8fa:	8a 00                	mov    (%eax),%al
 8fc:	84 c0                	test   %al,%al
 8fe:	0f 85 6b fe ff ff    	jne    76f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 904:	c9                   	leave  
 905:	c3                   	ret    

00000906 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 906:	55                   	push   %ebp
 907:	89 e5                	mov    %esp,%ebp
 909:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90c:	8b 45 08             	mov    0x8(%ebp),%eax
 90f:	83 e8 08             	sub    $0x8,%eax
 912:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 915:	a1 68 0e 00 00       	mov    0xe68,%eax
 91a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 91d:	eb 24                	jmp    943 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 927:	77 12                	ja     93b <free+0x35>
 929:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92f:	77 24                	ja     955 <free+0x4f>
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 00                	mov    (%eax),%eax
 936:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 939:	77 1a                	ja     955 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 00                	mov    (%eax),%eax
 940:	89 45 fc             	mov    %eax,-0x4(%ebp)
 943:	8b 45 f8             	mov    -0x8(%ebp),%eax
 946:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 949:	76 d4                	jbe    91f <free+0x19>
 94b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94e:	8b 00                	mov    (%eax),%eax
 950:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 953:	76 ca                	jbe    91f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 955:	8b 45 f8             	mov    -0x8(%ebp),%eax
 958:	8b 40 04             	mov    0x4(%eax),%eax
 95b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 962:	8b 45 f8             	mov    -0x8(%ebp),%eax
 965:	01 c2                	add    %eax,%edx
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	8b 00                	mov    (%eax),%eax
 96c:	39 c2                	cmp    %eax,%edx
 96e:	75 24                	jne    994 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 970:	8b 45 f8             	mov    -0x8(%ebp),%eax
 973:	8b 50 04             	mov    0x4(%eax),%edx
 976:	8b 45 fc             	mov    -0x4(%ebp),%eax
 979:	8b 00                	mov    (%eax),%eax
 97b:	8b 40 04             	mov    0x4(%eax),%eax
 97e:	01 c2                	add    %eax,%edx
 980:	8b 45 f8             	mov    -0x8(%ebp),%eax
 983:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	8b 45 fc             	mov    -0x4(%ebp),%eax
 989:	8b 00                	mov    (%eax),%eax
 98b:	8b 10                	mov    (%eax),%edx
 98d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 990:	89 10                	mov    %edx,(%eax)
 992:	eb 0a                	jmp    99e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 994:	8b 45 fc             	mov    -0x4(%ebp),%eax
 997:	8b 10                	mov    (%eax),%edx
 999:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 99e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a1:	8b 40 04             	mov    0x4(%eax),%eax
 9a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ae:	01 d0                	add    %edx,%eax
 9b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9b3:	75 20                	jne    9d5 <free+0xcf>
    p->s.size += bp->s.size;
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	8b 50 04             	mov    0x4(%eax),%edx
 9bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9be:	8b 40 04             	mov    0x4(%eax),%eax
 9c1:	01 c2                	add    %eax,%edx
 9c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9cc:	8b 10                	mov    (%eax),%edx
 9ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d1:	89 10                	mov    %edx,(%eax)
 9d3:	eb 08                	jmp    9dd <free+0xd7>
  } else
    p->s.ptr = bp;
 9d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9db:	89 10                	mov    %edx,(%eax)
  freep = p;
 9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e0:	a3 68 0e 00 00       	mov    %eax,0xe68
}
 9e5:	c9                   	leave  
 9e6:	c3                   	ret    

000009e7 <morecore>:

static Header*
morecore(uint nu)
{
 9e7:	55                   	push   %ebp
 9e8:	89 e5                	mov    %esp,%ebp
 9ea:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9ed:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9f4:	77 07                	ja     9fd <morecore+0x16>
    nu = 4096;
 9f6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9fd:	8b 45 08             	mov    0x8(%ebp),%eax
 a00:	c1 e0 03             	shl    $0x3,%eax
 a03:	83 ec 0c             	sub    $0xc,%esp
 a06:	50                   	push   %eax
 a07:	e8 f4 fb ff ff       	call   600 <sbrk>
 a0c:	83 c4 10             	add    $0x10,%esp
 a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a12:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a16:	75 07                	jne    a1f <morecore+0x38>
    return 0;
 a18:	b8 00 00 00 00       	mov    $0x0,%eax
 a1d:	eb 26                	jmp    a45 <morecore+0x5e>
  hp = (Header*)p;
 a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a28:	8b 55 08             	mov    0x8(%ebp),%edx
 a2b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a31:	83 c0 08             	add    $0x8,%eax
 a34:	83 ec 0c             	sub    $0xc,%esp
 a37:	50                   	push   %eax
 a38:	e8 c9 fe ff ff       	call   906 <free>
 a3d:	83 c4 10             	add    $0x10,%esp
  return freep;
 a40:	a1 68 0e 00 00       	mov    0xe68,%eax
}
 a45:	c9                   	leave  
 a46:	c3                   	ret    

00000a47 <malloc>:

void*
malloc(uint nbytes)
{
 a47:	55                   	push   %ebp
 a48:	89 e5                	mov    %esp,%ebp
 a4a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a4d:	8b 45 08             	mov    0x8(%ebp),%eax
 a50:	83 c0 07             	add    $0x7,%eax
 a53:	c1 e8 03             	shr    $0x3,%eax
 a56:	40                   	inc    %eax
 a57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a5a:	a1 68 0e 00 00       	mov    0xe68,%eax
 a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a66:	75 23                	jne    a8b <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a68:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
 a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a72:	a3 68 0e 00 00       	mov    %eax,0xe68
 a77:	a1 68 0e 00 00       	mov    0xe68,%eax
 a7c:	a3 60 0e 00 00       	mov    %eax,0xe60
    base.s.size = 0;
 a81:	c7 05 64 0e 00 00 00 	movl   $0x0,0xe64
 a88:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8e:	8b 00                	mov    (%eax),%eax
 a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a96:	8b 40 04             	mov    0x4(%eax),%eax
 a99:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a9c:	72 4d                	jb     aeb <malloc+0xa4>
      if(p->s.size == nunits)
 a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa1:	8b 40 04             	mov    0x4(%eax),%eax
 aa4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa7:	75 0c                	jne    ab5 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	8b 10                	mov    (%eax),%edx
 aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab1:	89 10                	mov    %edx,(%eax)
 ab3:	eb 26                	jmp    adb <malloc+0x94>
      else {
        p->s.size -= nunits;
 ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab8:	8b 40 04             	mov    0x4(%eax),%eax
 abb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 abe:	89 c2                	mov    %eax,%edx
 ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac9:	8b 40 04             	mov    0x4(%eax),%eax
 acc:	c1 e0 03             	shl    $0x3,%eax
 acf:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ad8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ade:	a3 68 0e 00 00       	mov    %eax,0xe68
      return (void*)(p + 1);
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	83 c0 08             	add    $0x8,%eax
 ae9:	eb 3b                	jmp    b26 <malloc+0xdf>
    }
    if(p == freep)
 aeb:	a1 68 0e 00 00       	mov    0xe68,%eax
 af0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 af3:	75 1e                	jne    b13 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 af5:	83 ec 0c             	sub    $0xc,%esp
 af8:	ff 75 ec             	pushl  -0x14(%ebp)
 afb:	e8 e7 fe ff ff       	call   9e7 <morecore>
 b00:	83 c4 10             	add    $0x10,%esp
 b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b0a:	75 07                	jne    b13 <malloc+0xcc>
        return 0;
 b0c:	b8 00 00 00 00       	mov    $0x0,%eax
 b11:	eb 13                	jmp    b26 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1c:	8b 00                	mov    (%eax),%eax
 b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b21:	e9 6d ff ff ff       	jmp    a93 <malloc+0x4c>
}
 b26:	c9                   	leave  
 b27:	c3                   	ret    

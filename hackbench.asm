
_hackbench:     file format elf32-i386


Disassembly of section .text:

00000000 <rdtsc>:
{
  asm volatile("hlt");
}

static inline unsigned long long rdtsc(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
    unsigned long long ret;
    asm volatile ( "rdtsc" : "=A"(ret) );
   6:	0f 31                	rdtsc  
   8:	89 45 f8             	mov    %eax,-0x8(%ebp)
   b:	89 55 fc             	mov    %edx,-0x4(%ebp)
    return ret;
   e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  11:	8b 55 fc             	mov    -0x4(%ebp),%edx
}
  14:	c9                   	leave  
  15:	c3                   	ret    

00000016 <barf>:
}pollfd[512];



static void barf(const char *msg)
{
  16:	55                   	push   %ebp
  17:	89 e5                	mov    %esp,%ebp
  19:	83 ec 08             	sub    $0x8,%esp
  printf(STDOUT, "(Error: %s)\n", msg);
  1c:	83 ec 04             	sub    $0x4,%esp
  1f:	ff 75 08             	pushl  0x8(%ebp)
  22:	68 20 0e 00 00       	push   $0xe20
  27:	6a 01                	push   $0x1
  29:	e8 17 0a 00 00       	call   a45 <printf>
  2e:	83 c4 10             	add    $0x10,%esp
  exit();
  31:	e8 3a 08 00 00       	call   870 <exit>

00000036 <fdpair>:
}

static void fdpair(int fds[2])
{
  36:	55                   	push   %ebp
  37:	89 e5                	mov    %esp,%ebp
  39:	83 ec 08             	sub    $0x8,%esp
  if (use_pipes) {
  3c:	a1 28 13 00 00       	mov    0x1328,%eax
  41:	85 c0                	test   %eax,%eax
  43:	74 23                	je     68 <fdpair+0x32>
    // TODO: Implement myPipe
    //    pipe(fds[0], fds[1]);
    if (pipe(fds) == 0)
  45:	83 ec 0c             	sub    $0xc,%esp
  48:	ff 75 08             	pushl  0x8(%ebp)
  4b:	e8 30 08 00 00       	call   880 <pipe>
  50:	83 c4 10             	add    $0x10,%esp
  53:	85 c0                	test   %eax,%eax
  55:	75 0f                	jne    66 <fdpair+0x30>
      fd_count += 2;
  57:	a1 40 13 00 00       	mov    0x1340,%eax
  5c:	83 c0 02             	add    $0x2,%eax
  5f:	a3 40 13 00 00       	mov    %eax,0x1340
      return;
  64:	eb 12                	jmp    78 <fdpair+0x42>
  66:	eb 10                	jmp    78 <fdpair+0x42>
  } else {
    // This mode would not run correctly in xv6
    //if (socketpair(AF_UNIX, SOCK_STREAM, 0, fds) == 0)
    //  return;
    barf("Socket mode is running. (error)\n");
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	68 30 0e 00 00       	push   $0xe30
  70:	e8 a1 ff ff ff       	call   16 <barf>
  75:	83 c4 10             	add    $0x10,%esp
  }
  //barf("Creating fdpair");
}
  78:	c9                   	leave  
  79:	c3                   	ret    

0000007a <checkEvents>:

static void checkEvents(int id, int event, int caller, char *msg){
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	83 ec 08             	sub    $0x8,%esp
  if(event == POLLIN){
  80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  84:	75 5e                	jne    e4 <checkEvents+0x6a>
    if(caller == SENDER){
  86:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8a:	75 20                	jne    ac <checkEvents+0x32>
      printf(STDOUT, "send[%d] is %s ... (pollfd[%d].events = POLLIN)\n", id, msg, id);
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 08             	pushl  0x8(%ebp)
  92:	ff 75 14             	pushl  0x14(%ebp)
  95:	ff 75 08             	pushl  0x8(%ebp)
  98:	68 54 0e 00 00       	push   $0xe54
  9d:	6a 01                	push   $0x1
  9f:	e8 a1 09 00 00       	call   a45 <printf>
  a4:	83 c4 20             	add    $0x20,%esp
  a7:	e9 a6 00 00 00       	jmp    152 <checkEvents+0xd8>
    }else if(caller == RECEIVER){
  ac:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
  b0:	75 20                	jne    d2 <checkEvents+0x58>
      printf(STDOUT, "recv[%d] is %s ... (pollfd[%d].events = POLLIN)\n", id, msg, id);
  b2:	83 ec 0c             	sub    $0xc,%esp
  b5:	ff 75 08             	pushl  0x8(%ebp)
  b8:	ff 75 14             	pushl  0x14(%ebp)
  bb:	ff 75 08             	pushl  0x8(%ebp)
  be:	68 88 0e 00 00       	push   $0xe88
  c3:	6a 01                	push   $0x1
  c5:	e8 7b 09 00 00       	call   a45 <printf>
  ca:	83 c4 20             	add    $0x20,%esp
  cd:	e9 80 00 00 00       	jmp    152 <checkEvents+0xd8>
    }else{
      barf("checkEvents");
  d2:	83 ec 0c             	sub    $0xc,%esp
  d5:	68 b9 0e 00 00       	push   $0xeb9
  da:	e8 37 ff ff ff       	call   16 <barf>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	eb 6e                	jmp    152 <checkEvents+0xd8>
    }
  }else if(event == FREE){
  e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  e8:	75 58                	jne    142 <checkEvents+0xc8>
    if(caller == SENDER){
  ea:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  ee:	75 1d                	jne    10d <checkEvents+0x93>
      printf(STDOUT, "send[%d] is %s ... (pollfd[%d].events = FREE)\n", id, msg, id);
  f0:	83 ec 0c             	sub    $0xc,%esp
  f3:	ff 75 08             	pushl  0x8(%ebp)
  f6:	ff 75 14             	pushl  0x14(%ebp)
  f9:	ff 75 08             	pushl  0x8(%ebp)
  fc:	68 c8 0e 00 00       	push   $0xec8
 101:	6a 01                	push   $0x1
 103:	e8 3d 09 00 00       	call   a45 <printf>
 108:	83 c4 20             	add    $0x20,%esp
 10b:	eb 45                	jmp    152 <checkEvents+0xd8>
    }else if(caller == RECEIVER){
 10d:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
 111:	75 1d                	jne    130 <checkEvents+0xb6>
      printf(STDOUT, "recv[%d] is %s ... (pollfd[%d].events = FREE)\n", id, msg, id);
 113:	83 ec 0c             	sub    $0xc,%esp
 116:	ff 75 08             	pushl  0x8(%ebp)
 119:	ff 75 14             	pushl  0x14(%ebp)
 11c:	ff 75 08             	pushl  0x8(%ebp)
 11f:	68 f8 0e 00 00       	push   $0xef8
 124:	6a 01                	push   $0x1
 126:	e8 1a 09 00 00       	call   a45 <printf>
 12b:	83 c4 20             	add    $0x20,%esp
 12e:	eb 22                	jmp    152 <checkEvents+0xd8>
    }else{
      barf("checkEvents");
 130:	83 ec 0c             	sub    $0xc,%esp
 133:	68 b9 0e 00 00       	push   $0xeb9
 138:	e8 d9 fe ff ff       	call   16 <barf>
 13d:	83 c4 10             	add    $0x10,%esp
 140:	eb 10                	jmp    152 <checkEvents+0xd8>
    }
  }else{
    barf("checkEvents");
 142:	83 ec 0c             	sub    $0xc,%esp
 145:	68 b9 0e 00 00       	push   $0xeb9
 14a:	e8 c7 fe ff ff       	call   16 <barf>
 14f:	83 c4 10             	add    $0x10,%esp
  }	      
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <ready>:

/* Block until we're ready to go */
static void ready(int ready_out, int wakefd, int id, int caller)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 18             	sub    $0x18,%esp
  char dummy;
  dummy = 'a';
 15a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  // TODO: Implement myPoll function
  pollfd[id].fd = wakefd;
 15e:	8b 45 10             	mov    0x10(%ebp),%eax
 161:	8b 55 0c             	mov    0xc(%ebp),%edx
 164:	89 14 c5 60 13 00 00 	mov    %edx,0x1360(,%eax,8)
  if(caller == RECEIVER) pollfd[id].events = POLLIN;
 16b:	83 7d 14 02          	cmpl   $0x2,0x14(%ebp)
 16f:	75 0d                	jne    17e <ready+0x2a>
 171:	8b 45 10             	mov    0x10(%ebp),%eax
 174:	66 c7 04 c5 64 13 00 	movw   $0x1,0x1364(,%eax,8)
 17b:	00 01 00 

  /* Tell them we're ready. */
  if (write(ready_out, &dummy, 1) != 1)
 17e:	83 ec 04             	sub    $0x4,%esp
 181:	6a 01                	push   $0x1
 183:	8d 45 f7             	lea    -0x9(%ebp),%eax
 186:	50                   	push   %eax
 187:	ff 75 08             	pushl  0x8(%ebp)
 18a:	e8 01 07 00 00       	call   890 <write>
 18f:	83 c4 10             	add    $0x10,%esp
 192:	83 f8 01             	cmp    $0x1,%eax
 195:	74 10                	je     1a7 <ready+0x53>
    barf("CLIENT: ready write");
 197:	83 ec 0c             	sub    $0xc,%esp
 19a:	68 27 0f 00 00       	push   $0xf27
 19f:	e8 72 fe ff ff       	call   16 <barf>
 1a4:	83 c4 10             	add    $0x10,%esp

  /* Wait for "GO" signal */
  //TODO: Polling should be re-implemented for xv6.
  //if (poll(&pollfd, 1, -1) != 1)
  //        barf("poll");
  if(caller == SENDER){
 1a7:	83 7d 14 01          	cmpl   $0x1,0x14(%ebp)
 1ab:	75 13                	jne    1c0 <ready+0x6c>
    if(DEBUG) checkEvents(id, pollfd[id].events, caller, "waiting");
    while(pollfd[id].events == POLLIN);
 1ad:	90                   	nop
 1ae:	8b 45 10             	mov    0x10(%ebp),%eax
 1b1:	8b 04 c5 64 13 00 00 	mov    0x1364(,%eax,8),%eax
 1b8:	66 83 f8 01          	cmp    $0x1,%ax
 1bc:	74 f0                	je     1ae <ready+0x5a>
 1be:	eb 25                	jmp    1e5 <ready+0x91>
    if(DEBUG) checkEvents(id, pollfd[id].events, caller, "ready");
  }else if(caller == RECEIVER){
 1c0:	83 7d 14 02          	cmpl   $0x2,0x14(%ebp)
 1c4:	75 0f                	jne    1d5 <ready+0x81>
    pollfd[id].events = FREE;
 1c6:	8b 45 10             	mov    0x10(%ebp),%eax
 1c9:	66 c7 04 c5 64 13 00 	movw   $0x0,0x1364(,%eax,8)
 1d0:	00 00 00 
 1d3:	eb 10                	jmp    1e5 <ready+0x91>
    //while(getticks() < TIMEOUT);
    if(DEBUG) checkEvents(id, pollfd[id].events, caller, "ready");
  }else{
    barf("Failed being ready.");
 1d5:	83 ec 0c             	sub    $0xc,%esp
 1d8:	68 3b 0f 00 00       	push   $0xf3b
 1dd:	e8 34 fe ff ff       	call   16 <barf>
 1e2:	83 c4 10             	add    $0x10,%esp
  }
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <sender>:
static void sender(unsigned int num_fds,
                   unsigned int out_fd[num_fds],
                   int ready_out,
                   int wakefd,
		   int id)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	53                   	push   %ebx
 1eb:	81 ec 84 00 00 00    	sub    $0x84,%esp
  char data[DATASIZE];
  int k;
  for(k=0; k<DATASIZE-1 ; k++){
 1f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1f8:	eb 0e                	jmp    208 <sender+0x21>
    data[k] = 'b';
 1fa:	8d 55 80             	lea    -0x80(%ebp),%edx
 1fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	c6 00 62             	movb   $0x62,(%eax)
                   int wakefd,
		   int id)
{
  char data[DATASIZE];
  int k;
  for(k=0; k<DATASIZE-1 ; k++){
 205:	ff 45 f4             	incl   -0xc(%ebp)
 208:	83 7d f4 62          	cmpl   $0x62,-0xc(%ebp)
 20c:	7e ec                	jle    1fa <sender+0x13>
    data[k] = 'b';
  }
  data[k] = '\0';
 20e:	8d 55 80             	lea    -0x80(%ebp),%edx
 211:	8b 45 f4             	mov    -0xc(%ebp),%eax
 214:	01 d0                	add    %edx,%eax
 216:	c6 00 00             	movb   $0x0,(%eax)
  
  unsigned int i, j;

  //TODO: Fix Me?
  ready(ready_out, wakefd, id, SENDER);
 219:	6a 01                	push   $0x1
 21b:	ff 75 18             	pushl  0x18(%ebp)
 21e:	ff 75 14             	pushl  0x14(%ebp)
 221:	ff 75 10             	pushl  0x10(%ebp)
 224:	e8 2b ff ff ff       	call   154 <ready>
 229:	83 c4 10             	add    $0x10,%esp

  /* Now pump to every receiver. */
  for (i = 0; i < loops; i++) {
 22c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 233:	eb 7c                	jmp    2b1 <sender+0xca>
    for (j = 0; j < num_fds; j++) {
 235:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 23c:	eb 68                	jmp    2a6 <sender+0xbf>
      int ret, done = 0;
 23e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    again:
      ret = write(out_fd[j], data + done, sizeof(data)-done);
 245:	8b 45 e8             	mov    -0x18(%ebp),%eax
 248:	ba 64 00 00 00       	mov    $0x64,%edx
 24d:	29 c2                	sub    %eax,%edx
 24f:	89 d0                	mov    %edx,%eax
 251:	89 c2                	mov    %eax,%edx
 253:	8b 45 e8             	mov    -0x18(%ebp),%eax
 256:	8d 4d 80             	lea    -0x80(%ebp),%ecx
 259:	01 c1                	add    %eax,%ecx
 25b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 25e:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
 265:	8b 45 0c             	mov    0xc(%ebp),%eax
 268:	01 d8                	add    %ebx,%eax
 26a:	8b 00                	mov    (%eax),%eax
 26c:	83 ec 04             	sub    $0x4,%esp
 26f:	52                   	push   %edx
 270:	51                   	push   %ecx
 271:	50                   	push   %eax
 272:	e8 19 06 00 00       	call   890 <write>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(DEBUG) printf(STDOUT, "send[%d]: ret = %d. (%d/%d/%d)\n", id, ret, i, num_fds, loops);
      if (ret < 0)
 27d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 281:	79 10                	jns    293 <sender+0xac>
	barf("SENDER: write");
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	68 4f 0f 00 00       	push   $0xf4f
 28b:	e8 86 fd ff ff       	call   16 <barf>
 290:	83 c4 10             	add    $0x10,%esp
      done += ret;
 293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 296:	01 45 e8             	add    %eax,-0x18(%ebp)
      if (done < sizeof(data))
 299:	8b 45 e8             	mov    -0x18(%ebp),%eax
 29c:	83 f8 63             	cmp    $0x63,%eax
 29f:	77 02                	ja     2a3 <sender+0xbc>
	goto again;
 2a1:	eb a2                	jmp    245 <sender+0x5e>
  //TODO: Fix Me?
  ready(ready_out, wakefd, id, SENDER);

  /* Now pump to every receiver. */
  for (i = 0; i < loops; i++) {
    for (j = 0; j < num_fds; j++) {
 2a3:	ff 45 ec             	incl   -0x14(%ebp)
 2a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2a9:	3b 45 08             	cmp    0x8(%ebp),%eax
 2ac:	72 90                	jb     23e <sender+0x57>

  //TODO: Fix Me?
  ready(ready_out, wakefd, id, SENDER);

  /* Now pump to every receiver. */
  for (i = 0; i < loops; i++) {
 2ae:	ff 45 f0             	incl   -0x10(%ebp)
 2b1:	a1 24 13 00 00       	mov    0x1324,%eax
 2b6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
 2b9:	0f 82 76 ff ff ff    	jb     235 <sender+0x4e>
      if (done < sizeof(data))
	goto again;
      if(DEBUG) printf(STDOUT, "send[%d]'s task has done. (%d/%d/%d)\n", id, ret, i, num_fds, loops);
    }
  }
}
 2bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c2:	c9                   	leave  
 2c3:	c3                   	ret    

000002c4 <receiver>:
static void receiver(unsigned int num_packets,
                     int in_fd,
                     int ready_out,
                     int wakefd,
		     int id)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 78             	sub    $0x78,%esp
  unsigned int i;

  /* Wait for start... */
  ready(ready_out, wakefd, id, RECEIVER);
 2ca:	6a 02                	push   $0x2
 2cc:	ff 75 18             	pushl  0x18(%ebp)
 2cf:	ff 75 14             	pushl  0x14(%ebp)
 2d2:	ff 75 10             	pushl  0x10(%ebp)
 2d5:	e8 7a fe ff ff       	call   154 <ready>
 2da:	83 c4 10             	add    $0x10,%esp

  /* Receive them all */
  for (i = 0; i < num_packets; i++) {
 2dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e4:	eb 51                	jmp    337 <receiver+0x73>
    char data[DATASIZE];
    int ret, done = 0;
 2e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  again:
    ret = read(in_fd, data + done, DATASIZE - done);
 2ed:	b8 64 00 00 00       	mov    $0x64,%eax
 2f2:	2b 45 f0             	sub    -0x10(%ebp),%eax
 2f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
 2f8:	8d 4d 88             	lea    -0x78(%ebp),%ecx
 2fb:	01 ca                	add    %ecx,%edx
 2fd:	83 ec 04             	sub    $0x4,%esp
 300:	50                   	push   %eax
 301:	52                   	push   %edx
 302:	ff 75 0c             	pushl  0xc(%ebp)
 305:	e8 7e 05 00 00       	call   888 <read>
 30a:	83 c4 10             	add    $0x10,%esp
 30d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(DEBUG) printf(STDOUT, "recv[%d]: ret = %d. (%d/%d)\n", id, ret, i, num_packets);
    if (ret < 0)
 310:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 314:	79 10                	jns    326 <receiver+0x62>
      barf("SERVER: read");
 316:	83 ec 0c             	sub    $0xc,%esp
 319:	68 5d 0f 00 00       	push   $0xf5d
 31e:	e8 f3 fc ff ff       	call   16 <barf>
 323:	83 c4 10             	add    $0x10,%esp
    done += ret;
 326:	8b 45 ec             	mov    -0x14(%ebp),%eax
 329:	01 45 f0             	add    %eax,-0x10(%ebp)
    if (done < DATASIZE){
 32c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 330:	7f 02                	jg     334 <receiver+0x70>
      goto again;
 332:	eb b9                	jmp    2ed <receiver+0x29>

  /* Wait for start... */
  ready(ready_out, wakefd, id, RECEIVER);

  /* Receive them all */
  for (i = 0; i < num_packets; i++) {
 334:	ff 45 f4             	incl   -0xc(%ebp)
 337:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33a:	3b 45 08             	cmp    0x8(%ebp),%eax
 33d:	72 a7                	jb     2e6 <receiver+0x22>
    if (done < DATASIZE){
      goto again;
    }
    if(DEBUG) printf(STDOUT, "recv[%d]'s task has done. (%d/%d)\n", id, i, num_packets);
  }
}
 33f:	c9                   	leave  
 340:	c3                   	ret    

00000341 <group>:

/* One group of senders and receivers */
static unsigned int group(unsigned int num_fds,
                          int ready_out,
                          int wakefd)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	53                   	push   %ebx
 345:	83 ec 24             	sub    $0x24,%esp
 348:	89 e0                	mov    %esp,%eax
 34a:	89 c3                	mov    %eax,%ebx
  unsigned int i;
  unsigned int out_fds[num_fds];
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	89 c2                	mov    %eax,%edx
 351:	4a                   	dec    %edx
 352:	89 55 f0             	mov    %edx,-0x10(%ebp)
 355:	c1 e0 02             	shl    $0x2,%eax
 358:	8d 50 03             	lea    0x3(%eax),%edx
 35b:	b8 10 00 00 00       	mov    $0x10,%eax
 360:	48                   	dec    %eax
 361:	01 d0                	add    %edx,%eax
 363:	b9 10 00 00 00       	mov    $0x10,%ecx
 368:	ba 00 00 00 00       	mov    $0x0,%edx
 36d:	f7 f1                	div    %ecx
 36f:	6b c0 10             	imul   $0x10,%eax,%eax
 372:	29 c4                	sub    %eax,%esp
 374:	89 e0                	mov    %esp,%eax
 376:	83 c0 03             	add    $0x3,%eax
 379:	c1 e8 02             	shr    $0x2,%eax
 37c:	c1 e0 02             	shl    $0x2,%eax
 37f:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i = 0; i < num_fds; i++) {
 382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 389:	e9 91 00 00 00       	jmp    41f <group+0xde>
    int fds[2];

    /* Create the pipe between client and server */
    fdpair(fds);
 38e:	83 ec 0c             	sub    $0xc,%esp
 391:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 394:	50                   	push   %eax
 395:	e8 9c fc ff ff       	call   36 <fdpair>
 39a:	83 c4 10             	add    $0x10,%esp

    /* Fork the receiver. */
    switch (fork()) {
 39d:	e8 c6 04 00 00       	call   868 <fork>
 3a2:	83 f8 ff             	cmp    $0xffffffff,%eax
 3a5:	74 06                	je     3ad <group+0x6c>
 3a7:	85 c0                	test   %eax,%eax
 3a9:	74 12                	je     3bd <group+0x7c>
 3ab:	eb 52                	jmp    3ff <group+0xbe>
    case -1: barf("fork()");
 3ad:	83 ec 0c             	sub    $0xc,%esp
 3b0:	68 6a 0f 00 00       	push   $0xf6a
 3b5:	e8 5c fc ff ff       	call   16 <barf>
 3ba:	83 c4 10             	add    $0x10,%esp
    case 0:
      close(fds[1]);
 3bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 3c0:	83 ec 0c             	sub    $0xc,%esp
 3c3:	50                   	push   %eax
 3c4:	e8 cf 04 00 00       	call   898 <close>
 3c9:	83 c4 10             	add    $0x10,%esp
      fd_count++;
 3cc:	a1 40 13 00 00       	mov    0x1340,%eax
 3d1:	40                   	inc    %eax
 3d2:	a3 40 13 00 00       	mov    %eax,0x1340
      receiver(num_fds*loops, fds[0], ready_out, wakefd, i);
 3d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3dd:	a1 24 13 00 00       	mov    0x1324,%eax
 3e2:	0f af 45 08          	imul   0x8(%ebp),%eax
 3e6:	83 ec 0c             	sub    $0xc,%esp
 3e9:	51                   	push   %ecx
 3ea:	ff 75 10             	pushl  0x10(%ebp)
 3ed:	ff 75 0c             	pushl  0xc(%ebp)
 3f0:	52                   	push   %edx
 3f1:	50                   	push   %eax
 3f2:	e8 cd fe ff ff       	call   2c4 <receiver>
 3f7:	83 c4 20             	add    $0x20,%esp
      exit();
 3fa:	e8 71 04 00 00       	call   870 <exit>
    }

    out_fds[i] = fds[1];
 3ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 402:	89 c1                	mov    %eax,%ecx
 404:	8b 45 ec             	mov    -0x14(%ebp),%eax
 407:	8b 55 f4             	mov    -0xc(%ebp),%edx
 40a:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    close(fds[0]);
 40d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 410:	83 ec 0c             	sub    $0xc,%esp
 413:	50                   	push   %eax
 414:	e8 7f 04 00 00       	call   898 <close>
 419:	83 c4 10             	add    $0x10,%esp
                          int wakefd)
{
  unsigned int i;
  unsigned int out_fds[num_fds];

  for (i = 0; i < num_fds; i++) {
 41c:	ff 45 f4             	incl   -0xc(%ebp)
 41f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 422:	3b 45 08             	cmp    0x8(%ebp),%eax
 425:	0f 82 63 ff ff ff    	jb     38e <group+0x4d>
    out_fds[i] = fds[1];
    close(fds[0]);
  }

  /* Now we have all the fds, fork the senders */
  for (i = 0; i < num_fds; i++) {
 42b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 432:	eb 51                	jmp    485 <group+0x144>
    switch (fork()) {
 434:	e8 2f 04 00 00       	call   868 <fork>
 439:	83 f8 ff             	cmp    $0xffffffff,%eax
 43c:	74 06                	je     444 <group+0x103>
 43e:	85 c0                	test   %eax,%eax
 440:	74 12                	je     454 <group+0x113>
 442:	eb 3e                	jmp    482 <group+0x141>
    case -1: barf("fork()");
 444:	83 ec 0c             	sub    $0xc,%esp
 447:	68 6a 0f 00 00       	push   $0xf6a
 44c:	e8 c5 fb ff ff       	call   16 <barf>
 451:	83 c4 10             	add    $0x10,%esp
    case 0:
      fd_count += 2;
 454:	a1 40 13 00 00       	mov    0x1340,%eax
 459:	83 c0 02             	add    $0x2,%eax
 45c:	a3 40 13 00 00       	mov    %eax,0x1340
      sender(num_fds, out_fds, ready_out, wakefd, i);
 461:	8b 55 f4             	mov    -0xc(%ebp),%edx
 464:	8b 45 ec             	mov    -0x14(%ebp),%eax
 467:	83 ec 0c             	sub    $0xc,%esp
 46a:	52                   	push   %edx
 46b:	ff 75 10             	pushl  0x10(%ebp)
 46e:	ff 75 0c             	pushl  0xc(%ebp)
 471:	50                   	push   %eax
 472:	ff 75 08             	pushl  0x8(%ebp)
 475:	e8 6d fd ff ff       	call   1e7 <sender>
 47a:	83 c4 20             	add    $0x20,%esp
      exit();
 47d:	e8 ee 03 00 00       	call   870 <exit>
    out_fds[i] = fds[1];
    close(fds[0]);
  }

  /* Now we have all the fds, fork the senders */
  for (i = 0; i < num_fds; i++) {
 482:	ff 45 f4             	incl   -0xc(%ebp)
 485:	8b 45 f4             	mov    -0xc(%ebp),%eax
 488:	3b 45 08             	cmp    0x8(%ebp),%eax
 48b:	72 a7                	jb     434 <group+0xf3>
      exit();
    }
  }

  /* Close the fds we have left */
  for (i = 0; i < num_fds; i++)
 48d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 494:	eb 18                	jmp    4ae <group+0x16d>
    close(out_fds[i]);
 496:	8b 45 ec             	mov    -0x14(%ebp),%eax
 499:	8b 55 f4             	mov    -0xc(%ebp),%edx
 49c:	8b 04 90             	mov    (%eax,%edx,4),%eax
 49f:	83 ec 0c             	sub    $0xc,%esp
 4a2:	50                   	push   %eax
 4a3:	e8 f0 03 00 00       	call   898 <close>
 4a8:	83 c4 10             	add    $0x10,%esp
      exit();
    }
  }

  /* Close the fds we have left */
  for (i = 0; i < num_fds; i++)
 4ab:	ff 45 f4             	incl   -0xc(%ebp)
 4ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b1:	3b 45 08             	cmp    0x8(%ebp),%eax
 4b4:	72 e0                	jb     496 <group+0x155>
    close(out_fds[i]);

  /* Reap number of children to reap */
  return num_fds * 2;
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	01 c0                	add    %eax,%eax
 4bb:	89 dc                	mov    %ebx,%esp
}
 4bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4c0:	c9                   	leave  
 4c1:	c3                   	ret    

000004c2 <main>:

int main(int argc, char *argv[])
{
 4c2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 4c6:	83 e4 f0             	and    $0xfffffff0,%esp
 4c9:	ff 71 fc             	pushl  -0x4(%ecx)
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	51                   	push   %ecx
 4d0:	83 ec 44             	sub    $0x44,%esp
 4d3:	89 c8                	mov    %ecx,%eax
  unsigned int i, num_groups, total_children;
  //struct timeval start, stop, diff;
  unsigned long long start=0, stop=0, diff=0;
 4d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 4dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 4e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 4ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 4f1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 4f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  // NOTE: More than 8 causes error due to num of fds.
  unsigned int num_fds = NUM_FDS;  // Original this is 20
 4ff:	c7 45 d4 08 00 00 00 	movl   $0x8,-0x2c(%ebp)
    use_pipes = 1;
    argc--;
    argv++;
    }
  */
  use_pipes = 1;
 506:	c7 05 28 13 00 00 01 	movl   $0x1,0x1328
 50d:	00 00 00 
  argc--;
 510:	ff 08                	decl   (%eax)
  argv++;
 512:	83 40 04 04          	addl   $0x4,0x4(%eax)

  //if (argc != 2 || (num_groups = atoi(argv[1])) == 0)
  //        barf("Usage: hackbench [-pipe] <num groups>\n");

  // NOTE: More than 3 causes error due to num of processes.
  num_groups = NUM_GROUPS; // TODO: This may seriously be considered.
 516:	c7 45 d0 02 00 00 00 	movl   $0x2,-0x30(%ebp)

  fdpair(readyfds);
 51d:	83 ec 0c             	sub    $0xc,%esp
 520:	8d 45 c8             	lea    -0x38(%ebp),%eax
 523:	50                   	push   %eax
 524:	e8 0d fb ff ff       	call   36 <fdpair>
 529:	83 c4 10             	add    $0x10,%esp
  fdpair(wakefds);
 52c:	83 ec 0c             	sub    $0xc,%esp
 52f:	8d 45 c0             	lea    -0x40(%ebp),%eax
 532:	50                   	push   %eax
 533:	e8 fe fa ff ff       	call   36 <fdpair>
 538:	83 c4 10             	add    $0x10,%esp

  total_children = 0;
 53b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (i = 0; i < num_groups; i++)
 542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 549:	eb 1c                	jmp    567 <main+0xa5>
    total_children += group(num_fds, readyfds[1], wakefds[0]);
 54b:	8b 55 c0             	mov    -0x40(%ebp),%edx
 54e:	8b 45 cc             	mov    -0x34(%ebp),%eax
 551:	83 ec 04             	sub    $0x4,%esp
 554:	52                   	push   %edx
 555:	50                   	push   %eax
 556:	ff 75 d4             	pushl  -0x2c(%ebp)
 559:	e8 e3 fd ff ff       	call   341 <group>
 55e:	83 c4 10             	add    $0x10,%esp
 561:	01 45 f0             	add    %eax,-0x10(%ebp)

  fdpair(readyfds);
  fdpair(wakefds);

  total_children = 0;
  for (i = 0; i < num_groups; i++)
 564:	ff 45 f4             	incl   -0xc(%ebp)
 567:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
 56d:	72 dc                	jb     54b <main+0x89>
    total_children += group(num_fds, readyfds[1], wakefds[0]);

  /* Wait for everyone to be ready */
  for (i = 0; i < total_children; i++)
 56f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 576:	eb 2d                	jmp    5a5 <main+0xe3>
    if (read(readyfds[0], &dummy, 1) != 1)
 578:	8b 45 c8             	mov    -0x38(%ebp),%eax
 57b:	83 ec 04             	sub    $0x4,%esp
 57e:	6a 01                	push   $0x1
 580:	8d 55 bf             	lea    -0x41(%ebp),%edx
 583:	52                   	push   %edx
 584:	50                   	push   %eax
 585:	e8 fe 02 00 00       	call   888 <read>
 58a:	83 c4 10             	add    $0x10,%esp
 58d:	83 f8 01             	cmp    $0x1,%eax
 590:	74 10                	je     5a2 <main+0xe0>
      barf("Reading for readyfds");
 592:	83 ec 0c             	sub    $0xc,%esp
 595:	68 71 0f 00 00       	push   $0xf71
 59a:	e8 77 fa ff ff       	call   16 <barf>
 59f:	83 c4 10             	add    $0x10,%esp
  total_children = 0;
  for (i = 0; i < num_groups; i++)
    total_children += group(num_fds, readyfds[1], wakefds[0]);

  /* Wait for everyone to be ready */
  for (i = 0; i < total_children; i++)
 5a2:	ff 45 f4             	incl   -0xc(%ebp)
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 5ab:	72 cb                	jb     578 <main+0xb6>
    if (read(readyfds[0], &dummy, 1) != 1)
      barf("Reading for readyfds");

  //gettimeofday(&start, NULL);
  start = rdtsc();
 5ad:	e8 4e fa ff ff       	call   0 <rdtsc>
 5b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
 5b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  if(DEBUG) printf(STDOUT, "Start Watching Time ...\n");
  

  /* Kick them off */
  if (write(wakefds[1], &dummy, 1) != 1)
 5b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5bb:	83 ec 04             	sub    $0x4,%esp
 5be:	6a 01                	push   $0x1
 5c0:	8d 55 bf             	lea    -0x41(%ebp),%edx
 5c3:	52                   	push   %edx
 5c4:	50                   	push   %eax
 5c5:	e8 c6 02 00 00       	call   890 <write>
 5ca:	83 c4 10             	add    $0x10,%esp
 5cd:	83 f8 01             	cmp    $0x1,%eax
 5d0:	74 10                	je     5e2 <main+0x120>
    barf("Writing to start them");
 5d2:	83 ec 0c             	sub    $0xc,%esp
 5d5:	68 86 0f 00 00       	push   $0xf86
 5da:	e8 37 fa ff ff       	call   16 <barf>
 5df:	83 c4 10             	add    $0x10,%esp

  /* Reap them all */
  //TODO: Fix different specifications between xv6 and Linux
  for (i = 0; i < total_children; i++) {
 5e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5e9:	eb 08                	jmp    5f3 <main+0x131>
    //int status;
    //wait(&status); // TODO: Too Many Arguments???
    wait(); // Waiting for that all child's tasks finish.
 5eb:	e8 88 02 00 00       	call   878 <wait>
  if (write(wakefds[1], &dummy, 1) != 1)
    barf("Writing to start them");

  /* Reap them all */
  //TODO: Fix different specifications between xv6 and Linux
  for (i = 0; i < total_children; i++) {
 5f0:	ff 45 f4             	incl   -0xc(%ebp)
 5f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 5f9:	72 f0                	jb     5eb <main+0x129>
    // TODO: What's WIFEXITED ???
    //if (!WIFEXITED(status))
    //  exit();
  }
  
  stop = rdtsc();
 5fb:	e8 00 fa ff ff       	call   0 <rdtsc>
 600:	89 45 e0             	mov    %eax,-0x20(%ebp)
 603:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if(DEBUG) printf(STDOUT, "Stop Watching Time ...\n");
  diff = stop - start;
 606:	8b 45 e0             	mov    -0x20(%ebp),%eax
 609:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 60c:	2b 45 e8             	sub    -0x18(%ebp),%eax
 60f:	1b 55 ec             	sbb    -0x14(%ebp),%edx
 612:	89 45 d8             	mov    %eax,-0x28(%ebp)
 615:	89 55 dc             	mov    %edx,-0x24(%ebp)

  /* Print time... */
  printf(STDOUT, "Time: 0x%l [ticks]\n", diff);
 618:	ff 75 dc             	pushl  -0x24(%ebp)
 61b:	ff 75 d8             	pushl  -0x28(%ebp)
 61e:	68 9c 0f 00 00       	push   $0xf9c
 623:	6a 01                	push   $0x1
 625:	e8 1b 04 00 00       	call   a45 <printf>
 62a:	83 c4 10             	add    $0x10,%esp
  if(DEBUG) printf(STDOUT, "fd_count = %d\n", fd_count);
  exit();
 62d:	e8 3e 02 00 00       	call   870 <exit>

00000632 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 632:	55                   	push   %ebp
 633:	89 e5                	mov    %esp,%ebp
 635:	57                   	push   %edi
 636:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 637:	8b 4d 08             	mov    0x8(%ebp),%ecx
 63a:	8b 55 10             	mov    0x10(%ebp),%edx
 63d:	8b 45 0c             	mov    0xc(%ebp),%eax
 640:	89 cb                	mov    %ecx,%ebx
 642:	89 df                	mov    %ebx,%edi
 644:	89 d1                	mov    %edx,%ecx
 646:	fc                   	cld    
 647:	f3 aa                	rep stos %al,%es:(%edi)
 649:	89 ca                	mov    %ecx,%edx
 64b:	89 fb                	mov    %edi,%ebx
 64d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 650:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 653:	5b                   	pop    %ebx
 654:	5f                   	pop    %edi
 655:	5d                   	pop    %ebp
 656:	c3                   	ret    

00000657 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 657:	55                   	push   %ebp
 658:	89 e5                	mov    %esp,%ebp
 65a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 663:	90                   	nop
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	8d 50 01             	lea    0x1(%eax),%edx
 66a:	89 55 08             	mov    %edx,0x8(%ebp)
 66d:	8b 55 0c             	mov    0xc(%ebp),%edx
 670:	8d 4a 01             	lea    0x1(%edx),%ecx
 673:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 676:	8a 12                	mov    (%edx),%dl
 678:	88 10                	mov    %dl,(%eax)
 67a:	8a 00                	mov    (%eax),%al
 67c:	84 c0                	test   %al,%al
 67e:	75 e4                	jne    664 <strcpy+0xd>
    ;
  return os;
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 683:	c9                   	leave  
 684:	c3                   	ret    

00000685 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 685:	55                   	push   %ebp
 686:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 688:	eb 06                	jmp    690 <strcmp+0xb>
    p++, q++;
 68a:	ff 45 08             	incl   0x8(%ebp)
 68d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	8a 00                	mov    (%eax),%al
 695:	84 c0                	test   %al,%al
 697:	74 0e                	je     6a7 <strcmp+0x22>
 699:	8b 45 08             	mov    0x8(%ebp),%eax
 69c:	8a 10                	mov    (%eax),%dl
 69e:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a1:	8a 00                	mov    (%eax),%al
 6a3:	38 c2                	cmp    %al,%dl
 6a5:	74 e3                	je     68a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	8a 00                	mov    (%eax),%al
 6ac:	0f b6 d0             	movzbl %al,%edx
 6af:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b2:	8a 00                	mov    (%eax),%al
 6b4:	0f b6 c0             	movzbl %al,%eax
 6b7:	29 c2                	sub    %eax,%edx
 6b9:	89 d0                	mov    %edx,%eax
}
 6bb:	5d                   	pop    %ebp
 6bc:	c3                   	ret    

000006bd <strlen>:

uint
strlen(char *s)
{
 6bd:	55                   	push   %ebp
 6be:	89 e5                	mov    %esp,%ebp
 6c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6ca:	eb 03                	jmp    6cf <strlen+0x12>
 6cc:	ff 45 fc             	incl   -0x4(%ebp)
 6cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	01 d0                	add    %edx,%eax
 6d7:	8a 00                	mov    (%eax),%al
 6d9:	84 c0                	test   %al,%al
 6db:	75 ef                	jne    6cc <strlen+0xf>
    ;
  return n;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6e0:	c9                   	leave  
 6e1:	c3                   	ret    

000006e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 6e2:	55                   	push   %ebp
 6e3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 6e5:	8b 45 10             	mov    0x10(%ebp),%eax
 6e8:	50                   	push   %eax
 6e9:	ff 75 0c             	pushl  0xc(%ebp)
 6ec:	ff 75 08             	pushl  0x8(%ebp)
 6ef:	e8 3e ff ff ff       	call   632 <stosb>
 6f4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 6f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6fa:	c9                   	leave  
 6fb:	c3                   	ret    

000006fc <strchr>:

char*
strchr(const char *s, char c)
{
 6fc:	55                   	push   %ebp
 6fd:	89 e5                	mov    %esp,%ebp
 6ff:	83 ec 04             	sub    $0x4,%esp
 702:	8b 45 0c             	mov    0xc(%ebp),%eax
 705:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 708:	eb 12                	jmp    71c <strchr+0x20>
    if(*s == c)
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	8a 00                	mov    (%eax),%al
 70f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 712:	75 05                	jne    719 <strchr+0x1d>
      return (char*)s;
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	eb 11                	jmp    72a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 719:	ff 45 08             	incl   0x8(%ebp)
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
 71f:	8a 00                	mov    (%eax),%al
 721:	84 c0                	test   %al,%al
 723:	75 e5                	jne    70a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 725:	b8 00 00 00 00       	mov    $0x0,%eax
}
 72a:	c9                   	leave  
 72b:	c3                   	ret    

0000072c <gets>:

char*
gets(char *buf, int max)
{
 72c:	55                   	push   %ebp
 72d:	89 e5                	mov    %esp,%ebp
 72f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 739:	eb 41                	jmp    77c <gets+0x50>
    cc = read(0, &c, 1);
 73b:	83 ec 04             	sub    $0x4,%esp
 73e:	6a 01                	push   $0x1
 740:	8d 45 ef             	lea    -0x11(%ebp),%eax
 743:	50                   	push   %eax
 744:	6a 00                	push   $0x0
 746:	e8 3d 01 00 00       	call   888 <read>
 74b:	83 c4 10             	add    $0x10,%esp
 74e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 751:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 755:	7f 02                	jg     759 <gets+0x2d>
      break;
 757:	eb 2c                	jmp    785 <gets+0x59>
    buf[i++] = c;
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8d 50 01             	lea    0x1(%eax),%edx
 75f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 762:	89 c2                	mov    %eax,%edx
 764:	8b 45 08             	mov    0x8(%ebp),%eax
 767:	01 c2                	add    %eax,%edx
 769:	8a 45 ef             	mov    -0x11(%ebp),%al
 76c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 76e:	8a 45 ef             	mov    -0x11(%ebp),%al
 771:	3c 0a                	cmp    $0xa,%al
 773:	74 10                	je     785 <gets+0x59>
 775:	8a 45 ef             	mov    -0x11(%ebp),%al
 778:	3c 0d                	cmp    $0xd,%al
 77a:	74 09                	je     785 <gets+0x59>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	40                   	inc    %eax
 780:	3b 45 0c             	cmp    0xc(%ebp),%eax
 783:	7c b6                	jl     73b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 785:	8b 55 f4             	mov    -0xc(%ebp),%edx
 788:	8b 45 08             	mov    0x8(%ebp),%eax
 78b:	01 d0                	add    %edx,%eax
 78d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 790:	8b 45 08             	mov    0x8(%ebp),%eax
}
 793:	c9                   	leave  
 794:	c3                   	ret    

00000795 <stat>:

int
stat(char *n, struct stat *st)
{
 795:	55                   	push   %ebp
 796:	89 e5                	mov    %esp,%ebp
 798:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 79b:	83 ec 08             	sub    $0x8,%esp
 79e:	6a 00                	push   $0x0
 7a0:	ff 75 08             	pushl  0x8(%ebp)
 7a3:	e8 08 01 00 00       	call   8b0 <open>
 7a8:	83 c4 10             	add    $0x10,%esp
 7ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b2:	79 07                	jns    7bb <stat+0x26>
    return -1;
 7b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7b9:	eb 25                	jmp    7e0 <stat+0x4b>
  r = fstat(fd, st);
 7bb:	83 ec 08             	sub    $0x8,%esp
 7be:	ff 75 0c             	pushl  0xc(%ebp)
 7c1:	ff 75 f4             	pushl  -0xc(%ebp)
 7c4:	e8 ff 00 00 00       	call   8c8 <fstat>
 7c9:	83 c4 10             	add    $0x10,%esp
 7cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7cf:	83 ec 0c             	sub    $0xc,%esp
 7d2:	ff 75 f4             	pushl  -0xc(%ebp)
 7d5:	e8 be 00 00 00       	call   898 <close>
 7da:	83 c4 10             	add    $0x10,%esp
  return r;
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7e0:	c9                   	leave  
 7e1:	c3                   	ret    

000007e2 <atoi>:

int
atoi(const char *s)
{
 7e2:	55                   	push   %ebp
 7e3:	89 e5                	mov    %esp,%ebp
 7e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7ef:	eb 24                	jmp    815 <atoi+0x33>
    n = n*10 + *s++ - '0';
 7f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7f4:	89 d0                	mov    %edx,%eax
 7f6:	c1 e0 02             	shl    $0x2,%eax
 7f9:	01 d0                	add    %edx,%eax
 7fb:	01 c0                	add    %eax,%eax
 7fd:	89 c1                	mov    %eax,%ecx
 7ff:	8b 45 08             	mov    0x8(%ebp),%eax
 802:	8d 50 01             	lea    0x1(%eax),%edx
 805:	89 55 08             	mov    %edx,0x8(%ebp)
 808:	8a 00                	mov    (%eax),%al
 80a:	0f be c0             	movsbl %al,%eax
 80d:	01 c8                	add    %ecx,%eax
 80f:	83 e8 30             	sub    $0x30,%eax
 812:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	8a 00                	mov    (%eax),%al
 81a:	3c 2f                	cmp    $0x2f,%al
 81c:	7e 09                	jle    827 <atoi+0x45>
 81e:	8b 45 08             	mov    0x8(%ebp),%eax
 821:	8a 00                	mov    (%eax),%al
 823:	3c 39                	cmp    $0x39,%al
 825:	7e ca                	jle    7f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 82a:	c9                   	leave  
 82b:	c3                   	ret    

0000082c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 82c:	55                   	push   %ebp
 82d:	89 e5                	mov    %esp,%ebp
 82f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 832:	8b 45 08             	mov    0x8(%ebp),%eax
 835:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 838:	8b 45 0c             	mov    0xc(%ebp),%eax
 83b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 83e:	eb 16                	jmp    856 <memmove+0x2a>
    *dst++ = *src++;
 840:	8b 45 fc             	mov    -0x4(%ebp),%eax
 843:	8d 50 01             	lea    0x1(%eax),%edx
 846:	89 55 fc             	mov    %edx,-0x4(%ebp)
 849:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84c:	8d 4a 01             	lea    0x1(%edx),%ecx
 84f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 852:	8a 12                	mov    (%edx),%dl
 854:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 856:	8b 45 10             	mov    0x10(%ebp),%eax
 859:	8d 50 ff             	lea    -0x1(%eax),%edx
 85c:	89 55 10             	mov    %edx,0x10(%ebp)
 85f:	85 c0                	test   %eax,%eax
 861:	7f dd                	jg     840 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 863:	8b 45 08             	mov    0x8(%ebp),%eax
}
 866:	c9                   	leave  
 867:	c3                   	ret    

00000868 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 868:	b8 01 00 00 00       	mov    $0x1,%eax
 86d:	cd 40                	int    $0x40
 86f:	c3                   	ret    

00000870 <exit>:
SYSCALL(exit)
 870:	b8 02 00 00 00       	mov    $0x2,%eax
 875:	cd 40                	int    $0x40
 877:	c3                   	ret    

00000878 <wait>:
SYSCALL(wait)
 878:	b8 03 00 00 00       	mov    $0x3,%eax
 87d:	cd 40                	int    $0x40
 87f:	c3                   	ret    

00000880 <pipe>:
SYSCALL(pipe)
 880:	b8 04 00 00 00       	mov    $0x4,%eax
 885:	cd 40                	int    $0x40
 887:	c3                   	ret    

00000888 <read>:
SYSCALL(read)
 888:	b8 05 00 00 00       	mov    $0x5,%eax
 88d:	cd 40                	int    $0x40
 88f:	c3                   	ret    

00000890 <write>:
SYSCALL(write)
 890:	b8 10 00 00 00       	mov    $0x10,%eax
 895:	cd 40                	int    $0x40
 897:	c3                   	ret    

00000898 <close>:
SYSCALL(close)
 898:	b8 15 00 00 00       	mov    $0x15,%eax
 89d:	cd 40                	int    $0x40
 89f:	c3                   	ret    

000008a0 <kill>:
SYSCALL(kill)
 8a0:	b8 06 00 00 00       	mov    $0x6,%eax
 8a5:	cd 40                	int    $0x40
 8a7:	c3                   	ret    

000008a8 <exec>:
SYSCALL(exec)
 8a8:	b8 07 00 00 00       	mov    $0x7,%eax
 8ad:	cd 40                	int    $0x40
 8af:	c3                   	ret    

000008b0 <open>:
SYSCALL(open)
 8b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 8b5:	cd 40                	int    $0x40
 8b7:	c3                   	ret    

000008b8 <mknod>:
SYSCALL(mknod)
 8b8:	b8 11 00 00 00       	mov    $0x11,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <unlink>:
SYSCALL(unlink)
 8c0:	b8 12 00 00 00       	mov    $0x12,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <fstat>:
SYSCALL(fstat)
 8c8:	b8 08 00 00 00       	mov    $0x8,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <link>:
SYSCALL(link)
 8d0:	b8 13 00 00 00       	mov    $0x13,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <mkdir>:
SYSCALL(mkdir)
 8d8:	b8 14 00 00 00       	mov    $0x14,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <chdir>:
SYSCALL(chdir)
 8e0:	b8 09 00 00 00       	mov    $0x9,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <dup>:
SYSCALL(dup)
 8e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <getpid>:
SYSCALL(getpid)
 8f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <sbrk>:
SYSCALL(sbrk)
 8f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <sleep>:
SYSCALL(sleep)
 900:	b8 0d 00 00 00       	mov    $0xd,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <uptime>:
SYSCALL(uptime)
 908:	b8 0e 00 00 00       	mov    $0xe,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <gettime>:
SYSCALL(gettime)
 910:	b8 16 00 00 00       	mov    $0x16,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <settickets>:
SYSCALL(settickets)
 918:	b8 17 00 00 00       	mov    $0x17,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	83 ec 18             	sub    $0x18,%esp
 926:	8b 45 0c             	mov    0xc(%ebp),%eax
 929:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 92c:	83 ec 04             	sub    $0x4,%esp
 92f:	6a 01                	push   $0x1
 931:	8d 45 f4             	lea    -0xc(%ebp),%eax
 934:	50                   	push   %eax
 935:	ff 75 08             	pushl  0x8(%ebp)
 938:	e8 53 ff ff ff       	call   890 <write>
 93d:	83 c4 10             	add    $0x10,%esp
}
 940:	c9                   	leave  
 941:	c3                   	ret    

00000942 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 942:	55                   	push   %ebp
 943:	89 e5                	mov    %esp,%ebp
 945:	53                   	push   %ebx
 946:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 949:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 950:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 954:	74 17                	je     96d <printint+0x2b>
 956:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 95a:	79 11                	jns    96d <printint+0x2b>
    neg = 1;
 95c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 963:	8b 45 0c             	mov    0xc(%ebp),%eax
 966:	f7 d8                	neg    %eax
 968:	89 45 ec             	mov    %eax,-0x14(%ebp)
 96b:	eb 06                	jmp    973 <printint+0x31>
  } else {
    x = xx;
 96d:	8b 45 0c             	mov    0xc(%ebp),%eax
 970:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 973:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 97a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 97d:	8d 41 01             	lea    0x1(%ecx),%eax
 980:	89 45 f4             	mov    %eax,-0xc(%ebp)
 983:	8b 5d 10             	mov    0x10(%ebp),%ebx
 986:	8b 45 ec             	mov    -0x14(%ebp),%eax
 989:	ba 00 00 00 00       	mov    $0x0,%edx
 98e:	f7 f3                	div    %ebx
 990:	89 d0                	mov    %edx,%eax
 992:	8a 80 2c 13 00 00    	mov    0x132c(%eax),%al
 998:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 99c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 99f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9a2:	ba 00 00 00 00       	mov    $0x0,%edx
 9a7:	f7 f3                	div    %ebx
 9a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9b0:	75 c8                	jne    97a <printint+0x38>
  if(neg)
 9b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9b6:	74 0e                	je     9c6 <printint+0x84>
    buf[i++] = '-';
 9b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bb:	8d 50 01             	lea    0x1(%eax),%edx
 9be:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9c1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9c6:	eb 1c                	jmp    9e4 <printint+0xa2>
    putc(fd, buf[i]);
 9c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ce:	01 d0                	add    %edx,%eax
 9d0:	8a 00                	mov    (%eax),%al
 9d2:	0f be c0             	movsbl %al,%eax
 9d5:	83 ec 08             	sub    $0x8,%esp
 9d8:	50                   	push   %eax
 9d9:	ff 75 08             	pushl  0x8(%ebp)
 9dc:	e8 3f ff ff ff       	call   920 <putc>
 9e1:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9e4:	ff 4d f4             	decl   -0xc(%ebp)
 9e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9eb:	79 db                	jns    9c8 <printint+0x86>
    putc(fd, buf[i]);
}
 9ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 9f0:	c9                   	leave  
 9f1:	c3                   	ret    

000009f2 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 9f2:	55                   	push   %ebp
 9f3:	89 e5                	mov    %esp,%ebp
 9f5:	83 ec 28             	sub    $0x28,%esp
 9f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 9fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
 9fe:	8b 45 10             	mov    0x10(%ebp),%eax
 a01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a0a:	89 d0                	mov    %edx,%eax
 a0c:	31 d2                	xor    %edx,%edx
 a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 a17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a1b:	74 13                	je     a30 <printlong+0x3e>
 a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a20:	6a 00                	push   $0x0
 a22:	6a 10                	push   $0x10
 a24:	50                   	push   %eax
 a25:	ff 75 08             	pushl  0x8(%ebp)
 a28:	e8 15 ff ff ff       	call   942 <printint>
 a2d:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a33:	6a 00                	push   $0x0
 a35:	6a 10                	push   $0x10
 a37:	50                   	push   %eax
 a38:	ff 75 08             	pushl  0x8(%ebp)
 a3b:	e8 02 ff ff ff       	call   942 <printint>
 a40:	83 c4 10             	add    $0x10,%esp
}
 a43:	c9                   	leave  
 a44:	c3                   	ret    

00000a45 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 a45:	55                   	push   %ebp
 a46:	89 e5                	mov    %esp,%ebp
 a48:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a4b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a52:	8d 45 0c             	lea    0xc(%ebp),%eax
 a55:	83 c0 04             	add    $0x4,%eax
 a58:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a62:	e9 83 01 00 00       	jmp    bea <printf+0x1a5>
    c = fmt[i] & 0xff;
 a67:	8b 55 0c             	mov    0xc(%ebp),%edx
 a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6d:	01 d0                	add    %edx,%eax
 a6f:	8a 00                	mov    (%eax),%al
 a71:	0f be c0             	movsbl %al,%eax
 a74:	25 ff 00 00 00       	and    $0xff,%eax
 a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a80:	75 2c                	jne    aae <printf+0x69>
      if(c == '%'){
 a82:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a86:	75 0c                	jne    a94 <printf+0x4f>
        state = '%';
 a88:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a8f:	e9 53 01 00 00       	jmp    be7 <printf+0x1a2>
      } else {
        putc(fd, c);
 a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a97:	0f be c0             	movsbl %al,%eax
 a9a:	83 ec 08             	sub    $0x8,%esp
 a9d:	50                   	push   %eax
 a9e:	ff 75 08             	pushl  0x8(%ebp)
 aa1:	e8 7a fe ff ff       	call   920 <putc>
 aa6:	83 c4 10             	add    $0x10,%esp
 aa9:	e9 39 01 00 00       	jmp    be7 <printf+0x1a2>
      }
    } else if(state == '%'){
 aae:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 ab2:	0f 85 2f 01 00 00    	jne    be7 <printf+0x1a2>
      if(c == 'd'){
 ab8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 abc:	75 1e                	jne    adc <printf+0x97>
        printint(fd, *ap, 10, 1);
 abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ac1:	8b 00                	mov    (%eax),%eax
 ac3:	6a 01                	push   $0x1
 ac5:	6a 0a                	push   $0xa
 ac7:	50                   	push   %eax
 ac8:	ff 75 08             	pushl  0x8(%ebp)
 acb:	e8 72 fe ff ff       	call   942 <printint>
 ad0:	83 c4 10             	add    $0x10,%esp
        ap++;
 ad3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ad7:	e9 04 01 00 00       	jmp    be0 <printf+0x19b>
      } else if(c == 'l') {
 adc:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 ae0:	75 29                	jne    b0b <printf+0xc6>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 ae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ae5:	8b 50 04             	mov    0x4(%eax),%edx
 ae8:	8b 00                	mov    (%eax),%eax
 aea:	83 ec 0c             	sub    $0xc,%esp
 aed:	6a 00                	push   $0x0
 aef:	6a 0a                	push   $0xa
 af1:	52                   	push   %edx
 af2:	50                   	push   %eax
 af3:	ff 75 08             	pushl  0x8(%ebp)
 af6:	e8 f7 fe ff ff       	call   9f2 <printlong>
 afb:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 afe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 b02:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b06:	e9 d5 00 00 00       	jmp    be0 <printf+0x19b>
      } else if(c == 'x' || c == 'p'){
 b0b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b0f:	74 06                	je     b17 <printf+0xd2>
 b11:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b15:	75 1e                	jne    b35 <printf+0xf0>
        printint(fd, *ap, 16, 0);
 b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b1a:	8b 00                	mov    (%eax),%eax
 b1c:	6a 00                	push   $0x0
 b1e:	6a 10                	push   $0x10
 b20:	50                   	push   %eax
 b21:	ff 75 08             	pushl  0x8(%ebp)
 b24:	e8 19 fe ff ff       	call   942 <printint>
 b29:	83 c4 10             	add    $0x10,%esp
        ap++;
 b2c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b30:	e9 ab 00 00 00       	jmp    be0 <printf+0x19b>
      } else if(c == 's'){
 b35:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b39:	75 40                	jne    b7b <printf+0x136>
        s = (char*)*ap;
 b3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b3e:	8b 00                	mov    (%eax),%eax
 b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b43:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b4b:	75 07                	jne    b54 <printf+0x10f>
          s = "(null)";
 b4d:	c7 45 f4 b0 0f 00 00 	movl   $0xfb0,-0xc(%ebp)
        while(*s != 0){
 b54:	eb 1a                	jmp    b70 <printf+0x12b>
          putc(fd, *s);
 b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b59:	8a 00                	mov    (%eax),%al
 b5b:	0f be c0             	movsbl %al,%eax
 b5e:	83 ec 08             	sub    $0x8,%esp
 b61:	50                   	push   %eax
 b62:	ff 75 08             	pushl  0x8(%ebp)
 b65:	e8 b6 fd ff ff       	call   920 <putc>
 b6a:	83 c4 10             	add    $0x10,%esp
          s++;
 b6d:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b73:	8a 00                	mov    (%eax),%al
 b75:	84 c0                	test   %al,%al
 b77:	75 dd                	jne    b56 <printf+0x111>
 b79:	eb 65                	jmp    be0 <printf+0x19b>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b7b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b7f:	75 1d                	jne    b9e <printf+0x159>
        putc(fd, *ap);
 b81:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b84:	8b 00                	mov    (%eax),%eax
 b86:	0f be c0             	movsbl %al,%eax
 b89:	83 ec 08             	sub    $0x8,%esp
 b8c:	50                   	push   %eax
 b8d:	ff 75 08             	pushl  0x8(%ebp)
 b90:	e8 8b fd ff ff       	call   920 <putc>
 b95:	83 c4 10             	add    $0x10,%esp
        ap++;
 b98:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b9c:	eb 42                	jmp    be0 <printf+0x19b>
      } else if(c == '%'){
 b9e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ba2:	75 17                	jne    bbb <printf+0x176>
        putc(fd, c);
 ba4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ba7:	0f be c0             	movsbl %al,%eax
 baa:	83 ec 08             	sub    $0x8,%esp
 bad:	50                   	push   %eax
 bae:	ff 75 08             	pushl  0x8(%ebp)
 bb1:	e8 6a fd ff ff       	call   920 <putc>
 bb6:	83 c4 10             	add    $0x10,%esp
 bb9:	eb 25                	jmp    be0 <printf+0x19b>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 bbb:	83 ec 08             	sub    $0x8,%esp
 bbe:	6a 25                	push   $0x25
 bc0:	ff 75 08             	pushl  0x8(%ebp)
 bc3:	e8 58 fd ff ff       	call   920 <putc>
 bc8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bce:	0f be c0             	movsbl %al,%eax
 bd1:	83 ec 08             	sub    $0x8,%esp
 bd4:	50                   	push   %eax
 bd5:	ff 75 08             	pushl  0x8(%ebp)
 bd8:	e8 43 fd ff ff       	call   920 <putc>
 bdd:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 be0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 be7:	ff 45 f0             	incl   -0x10(%ebp)
 bea:	8b 55 0c             	mov    0xc(%ebp),%edx
 bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf0:	01 d0                	add    %edx,%eax
 bf2:	8a 00                	mov    (%eax),%al
 bf4:	84 c0                	test   %al,%al
 bf6:	0f 85 6b fe ff ff    	jne    a67 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bfc:	c9                   	leave  
 bfd:	c3                   	ret    

00000bfe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bfe:	55                   	push   %ebp
 bff:	89 e5                	mov    %esp,%ebp
 c01:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c04:	8b 45 08             	mov    0x8(%ebp),%eax
 c07:	83 e8 08             	sub    $0x8,%eax
 c0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c0d:	a1 4c 13 00 00       	mov    0x134c,%eax
 c12:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c15:	eb 24                	jmp    c3b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1a:	8b 00                	mov    (%eax),%eax
 c1c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c1f:	77 12                	ja     c33 <free+0x35>
 c21:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c24:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c27:	77 24                	ja     c4d <free+0x4f>
 c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2c:	8b 00                	mov    (%eax),%eax
 c2e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c31:	77 1a                	ja     c4d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c36:	8b 00                	mov    (%eax),%eax
 c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c41:	76 d4                	jbe    c17 <free+0x19>
 c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c46:	8b 00                	mov    (%eax),%eax
 c48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c4b:	76 ca                	jbe    c17 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c50:	8b 40 04             	mov    0x4(%eax),%eax
 c53:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c5d:	01 c2                	add    %eax,%edx
 c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c62:	8b 00                	mov    (%eax),%eax
 c64:	39 c2                	cmp    %eax,%edx
 c66:	75 24                	jne    c8c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c68:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c6b:	8b 50 04             	mov    0x4(%eax),%edx
 c6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c71:	8b 00                	mov    (%eax),%eax
 c73:	8b 40 04             	mov    0x4(%eax),%eax
 c76:	01 c2                	add    %eax,%edx
 c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c81:	8b 00                	mov    (%eax),%eax
 c83:	8b 10                	mov    (%eax),%edx
 c85:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c88:	89 10                	mov    %edx,(%eax)
 c8a:	eb 0a                	jmp    c96 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c8f:	8b 10                	mov    (%eax),%edx
 c91:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c94:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c99:	8b 40 04             	mov    0x4(%eax),%eax
 c9c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca6:	01 d0                	add    %edx,%eax
 ca8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cab:	75 20                	jne    ccd <free+0xcf>
    p->s.size += bp->s.size;
 cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb0:	8b 50 04             	mov    0x4(%eax),%edx
 cb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb6:	8b 40 04             	mov    0x4(%eax),%eax
 cb9:	01 c2                	add    %eax,%edx
 cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbe:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cc4:	8b 10                	mov    (%eax),%edx
 cc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc9:	89 10                	mov    %edx,(%eax)
 ccb:	eb 08                	jmp    cd5 <free+0xd7>
  } else
    p->s.ptr = bp;
 ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 cd3:	89 10                	mov    %edx,(%eax)
  freep = p;
 cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd8:	a3 4c 13 00 00       	mov    %eax,0x134c
}
 cdd:	c9                   	leave  
 cde:	c3                   	ret    

00000cdf <morecore>:

static Header*
morecore(uint nu)
{
 cdf:	55                   	push   %ebp
 ce0:	89 e5                	mov    %esp,%ebp
 ce2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ce5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cec:	77 07                	ja     cf5 <morecore+0x16>
    nu = 4096;
 cee:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 cf5:	8b 45 08             	mov    0x8(%ebp),%eax
 cf8:	c1 e0 03             	shl    $0x3,%eax
 cfb:	83 ec 0c             	sub    $0xc,%esp
 cfe:	50                   	push   %eax
 cff:	e8 f4 fb ff ff       	call   8f8 <sbrk>
 d04:	83 c4 10             	add    $0x10,%esp
 d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d0a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d0e:	75 07                	jne    d17 <morecore+0x38>
    return 0;
 d10:	b8 00 00 00 00       	mov    $0x0,%eax
 d15:	eb 26                	jmp    d3d <morecore+0x5e>
  hp = (Header*)p;
 d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d20:	8b 55 08             	mov    0x8(%ebp),%edx
 d23:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d29:	83 c0 08             	add    $0x8,%eax
 d2c:	83 ec 0c             	sub    $0xc,%esp
 d2f:	50                   	push   %eax
 d30:	e8 c9 fe ff ff       	call   bfe <free>
 d35:	83 c4 10             	add    $0x10,%esp
  return freep;
 d38:	a1 4c 13 00 00       	mov    0x134c,%eax
}
 d3d:	c9                   	leave  
 d3e:	c3                   	ret    

00000d3f <malloc>:

void*
malloc(uint nbytes)
{
 d3f:	55                   	push   %ebp
 d40:	89 e5                	mov    %esp,%ebp
 d42:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d45:	8b 45 08             	mov    0x8(%ebp),%eax
 d48:	83 c0 07             	add    $0x7,%eax
 d4b:	c1 e8 03             	shr    $0x3,%eax
 d4e:	40                   	inc    %eax
 d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d52:	a1 4c 13 00 00       	mov    0x134c,%eax
 d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d5e:	75 23                	jne    d83 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d60:	c7 45 f0 44 13 00 00 	movl   $0x1344,-0x10(%ebp)
 d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d6a:	a3 4c 13 00 00       	mov    %eax,0x134c
 d6f:	a1 4c 13 00 00       	mov    0x134c,%eax
 d74:	a3 44 13 00 00       	mov    %eax,0x1344
    base.s.size = 0;
 d79:	c7 05 48 13 00 00 00 	movl   $0x0,0x1348
 d80:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d86:	8b 00                	mov    (%eax),%eax
 d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8e:	8b 40 04             	mov    0x4(%eax),%eax
 d91:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d94:	72 4d                	jb     de3 <malloc+0xa4>
      if(p->s.size == nunits)
 d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d99:	8b 40 04             	mov    0x4(%eax),%eax
 d9c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d9f:	75 0c                	jne    dad <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da4:	8b 10                	mov    (%eax),%edx
 da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da9:	89 10                	mov    %edx,(%eax)
 dab:	eb 26                	jmp    dd3 <malloc+0x94>
      else {
        p->s.size -= nunits;
 dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db0:	8b 40 04             	mov    0x4(%eax),%eax
 db3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 db6:	89 c2                	mov    %eax,%edx
 db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc1:	8b 40 04             	mov    0x4(%eax),%eax
 dc4:	c1 e0 03             	shl    $0x3,%eax
 dc7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 dd0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dd6:	a3 4c 13 00 00       	mov    %eax,0x134c
      return (void*)(p + 1);
 ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dde:	83 c0 08             	add    $0x8,%eax
 de1:	eb 3b                	jmp    e1e <malloc+0xdf>
    }
    if(p == freep)
 de3:	a1 4c 13 00 00       	mov    0x134c,%eax
 de8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 deb:	75 1e                	jne    e0b <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 ded:	83 ec 0c             	sub    $0xc,%esp
 df0:	ff 75 ec             	pushl  -0x14(%ebp)
 df3:	e8 e7 fe ff ff       	call   cdf <morecore>
 df8:	83 c4 10             	add    $0x10,%esp
 dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e02:	75 07                	jne    e0b <malloc+0xcc>
        return 0;
 e04:	b8 00 00 00 00       	mov    $0x0,%eax
 e09:	eb 13                	jmp    e1e <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e14:	8b 00                	mov    (%eax),%eax
 e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e19:	e9 6d ff ff ff       	jmp    d8b <malloc+0x4c>
}
 e1e:	c9                   	leave  
 e1f:	c3                   	ret    

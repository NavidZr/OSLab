
_sem_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
  sem_init(MUTEX, 1);
  11:	6a 01                	push   $0x1
  13:	6a 00                	push   $0x0
  15:	e8 79 04 00 00       	call   493 <sem_init>
  sem_init(FULL, BUFF_SIZE);
  1a:	58                   	pop    %eax
  1b:	5a                   	pop    %edx
  1c:	6a 05                	push   $0x5
  1e:	6a 01                	push   $0x1
  20:	e8 6e 04 00 00       	call   493 <sem_init>
  sem_init(EMPTY, BUFF_SIZE);
  25:	59                   	pop    %ecx
  26:	58                   	pop    %eax
  27:	6a 05                	push   $0x5
  29:	6a 02                	push   $0x2
  2b:	e8 63 04 00 00       	call   493 <sem_init>

  if (fork() == 0)
  30:	e8 76 03 00 00       	call   3ab <fork>
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	75 0a                	jne    46 <main+0x46>
    consumer();
  3c:	e8 8f 00 00 00       	call   d0 <consumer>
  else
    producer();

  exit();
  41:	e8 6d 03 00 00       	call   3b3 <exit>
    producer();
  46:	e8 05 00 00 00       	call   50 <producer>
  4b:	eb f4                	jmp    41 <main+0x41>
  4d:	66 90                	xchg   %ax,%ax
  4f:	90                   	nop

00000050 <producer>:
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
    printf(1, "PRODUCER: wrote item %d to index %d\n", w_index, w_index % BUFF_SIZE);
  54:	be cd cc cc cc       	mov    $0xcccccccd,%esi
{
  59:	53                   	push   %ebx
  5a:	bb 0a 00 00 00       	mov    $0xa,%ebx
  5f:	90                   	nop
    sem_acquire(EMPTY);
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	6a 02                	push   $0x2
  65:	e8 31 04 00 00       	call   49b <sem_acquire>
    sem_acquire(MUTEX);
  6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  71:	e8 25 04 00 00       	call   49b <sem_acquire>
    printf(1, "PRODUCER: wrote item %d to index %d\n", w_index, w_index % BUFF_SIZE);
  76:	8b 0d 5c 0c 00 00    	mov    0xc5c,%ecx
  7c:	89 c8                	mov    %ecx,%eax
  7e:	f7 e6                	mul    %esi
  80:	89 d0                	mov    %edx,%eax
  82:	83 e2 fc             	and    $0xfffffffc,%edx
  85:	c1 e8 02             	shr    $0x2,%eax
  88:	01 c2                	add    %eax,%edx
  8a:	89 c8                	mov    %ecx,%eax
  8c:	29 d0                	sub    %edx,%eax
  8e:	50                   	push   %eax
  8f:	51                   	push   %ecx
  90:	68 a8 08 00 00       	push   $0x8a8
  95:	6a 01                	push   $0x1
  97:	e8 e4 04 00 00       	call   580 <printf>
    sem_release(MUTEX);
  9c:	83 c4 14             	add    $0x14,%esp
  9f:	6a 00                	push   $0x0
  a1:	e8 fd 03 00 00       	call   4a3 <sem_release>
    sem_release(FULL);
  a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ad:	e8 f1 03 00 00       	call   4a3 <sem_release>
    w_index++;
  b2:	83 05 5c 0c 00 00 01 	addl   $0x1,0xc5c
  while (i++ < 10) {
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	83 eb 01             	sub    $0x1,%ebx
  bf:	75 9f                	jne    60 <producer+0x10>
}
  c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  c4:	5b                   	pop    %ebx
  c5:	5e                   	pop    %esi
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    
  c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cf:	90                   	nop

000000d0 <consumer>:
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	56                   	push   %esi
    printf(1, "CONSUMER: read item %d from index %d\n", r_index, r_index % BUFF_SIZE);
  d4:	be cd cc cc cc       	mov    $0xcccccccd,%esi
{
  d9:	53                   	push   %ebx
  da:	bb 0a 00 00 00       	mov    $0xa,%ebx
  df:	90                   	nop
    sleep(5);
  e0:	83 ec 0c             	sub    $0xc,%esp
  e3:	6a 05                	push   $0x5
  e5:	e8 59 03 00 00       	call   443 <sleep>
    sem_acquire(FULL);
  ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f1:	e8 a5 03 00 00       	call   49b <sem_acquire>
    sem_acquire(MUTEX);
  f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  fd:	e8 99 03 00 00       	call   49b <sem_acquire>
    printf(1, "CONSUMER: read item %d from index %d\n", r_index, r_index % BUFF_SIZE);
 102:	8b 0d 58 0c 00 00    	mov    0xc58,%ecx
 108:	89 c8                	mov    %ecx,%eax
 10a:	f7 e6                	mul    %esi
 10c:	89 d0                	mov    %edx,%eax
 10e:	83 e2 fc             	and    $0xfffffffc,%edx
 111:	c1 e8 02             	shr    $0x2,%eax
 114:	01 c2                	add    %eax,%edx
 116:	89 c8                	mov    %ecx,%eax
 118:	29 d0                	sub    %edx,%eax
 11a:	50                   	push   %eax
 11b:	51                   	push   %ecx
 11c:	68 d0 08 00 00       	push   $0x8d0
 121:	6a 01                	push   $0x1
 123:	e8 58 04 00 00       	call   580 <printf>
    sem_release(MUTEX);
 128:	83 c4 14             	add    $0x14,%esp
 12b:	6a 00                	push   $0x0
 12d:	e8 71 03 00 00       	call   4a3 <sem_release>
    sem_release(EMPTY);
 132:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 139:	e8 65 03 00 00       	call   4a3 <sem_release>
    r_index++;
 13e:	83 05 58 0c 00 00 01 	addl   $0x1,0xc58
  while(i++ < 10) {
 145:	83 c4 10             	add    $0x10,%esp
 148:	83 eb 01             	sub    $0x1,%ebx
 14b:	75 93                	jne    e0 <consumer+0x10>
}
 14d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 150:	5b                   	pop    %ebx
 151:	5e                   	pop    %esi
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    
 154:	66 90                	xchg   %ax,%ax
 156:	66 90                	xchg   %ax,%ax
 158:	66 90                	xchg   %ax,%ax
 15a:	66 90                	xchg   %ax,%ax
 15c:	66 90                	xchg   %ax,%ax
 15e:	66 90                	xchg   %ax,%ax

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 160:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 161:	31 c0                	xor    %eax,%eax
{
 163:	89 e5                	mov    %esp,%ebp
 165:	53                   	push   %ebx
 166:	8b 4d 08             	mov    0x8(%ebp),%ecx
 169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 170:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 174:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 177:	83 c0 01             	add    $0x1,%eax
 17a:	84 d2                	test   %dl,%dl
 17c:	75 f2                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 17e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 181:	89 c8                	mov    %ecx,%eax
 183:	c9                   	leave  
 184:	c3                   	ret    
 185:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 55 08             	mov    0x8(%ebp),%edx
 197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 19a:	0f b6 02             	movzbl (%edx),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 17                	jne    1b8 <strcmp+0x28>
 1a1:	eb 3a                	jmp    1dd <strcmp+0x4d>
 1a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a7:	90                   	nop
 1a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1ac:	83 c2 01             	add    $0x1,%edx
 1af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1b2:	84 c0                	test   %al,%al
 1b4:	74 1a                	je     1d0 <strcmp+0x40>
    p++, q++;
 1b6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 1b8:	0f b6 19             	movzbl (%ecx),%ebx
 1bb:	38 c3                	cmp    %al,%bl
 1bd:	74 e9                	je     1a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1bf:	29 d8                	sub    %ebx,%eax
}
 1c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c4:	c9                   	leave  
 1c5:	c3                   	ret    
 1c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 1d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1d4:	31 c0                	xor    %eax,%eax
 1d6:	29 d8                	sub    %ebx,%eax
}
 1d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1db:	c9                   	leave  
 1dc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 1dd:	0f b6 19             	movzbl (%ecx),%ebx
 1e0:	31 c0                	xor    %eax,%eax
 1e2:	eb db                	jmp    1bf <strcmp+0x2f>
 1e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <strlen>:

uint
strlen(const char *s)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1f6:	80 3a 00             	cmpb   $0x0,(%edx)
 1f9:	74 15                	je     210 <strlen+0x20>
 1fb:	31 c0                	xor    %eax,%eax
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	83 c0 01             	add    $0x1,%eax
 203:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 207:	89 c1                	mov    %eax,%ecx
 209:	75 f5                	jne    200 <strlen+0x10>
    ;
  return n;
}
 20b:	89 c8                	mov    %ecx,%eax
 20d:	5d                   	pop    %ebp
 20e:	c3                   	ret    
 20f:	90                   	nop
  for(n = 0; s[n]; n++)
 210:	31 c9                	xor    %ecx,%ecx
}
 212:	5d                   	pop    %ebp
 213:	89 c8                	mov    %ecx,%eax
 215:	c3                   	ret    
 216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21d:	8d 76 00             	lea    0x0(%esi),%esi

00000220 <memset>:

void*
memset(void *dst, int c, uint n)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 227:	8b 4d 10             	mov    0x10(%ebp),%ecx
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 d7                	mov    %edx,%edi
 22f:	fc                   	cld    
 230:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 232:	8b 7d fc             	mov    -0x4(%ebp),%edi
 235:	89 d0                	mov    %edx,%eax
 237:	c9                   	leave  
 238:	c3                   	ret    
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000240 <strchr>:

char*
strchr(const char *s, char c)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 24a:	0f b6 10             	movzbl (%eax),%edx
 24d:	84 d2                	test   %dl,%dl
 24f:	75 12                	jne    263 <strchr+0x23>
 251:	eb 1d                	jmp    270 <strchr+0x30>
 253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 257:	90                   	nop
 258:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 25c:	83 c0 01             	add    $0x1,%eax
 25f:	84 d2                	test   %dl,%dl
 261:	74 0d                	je     270 <strchr+0x30>
    if(*s == c)
 263:	38 d1                	cmp    %dl,%cl
 265:	75 f1                	jne    258 <strchr+0x18>
      return (char*)s;
  return 0;
}
 267:	5d                   	pop    %ebp
 268:	c3                   	ret    
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 270:	31 c0                	xor    %eax,%eax
}
 272:	5d                   	pop    %ebp
 273:	c3                   	ret    
 274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 27f:	90                   	nop

00000280 <gets>:

char*
gets(char *buf, int max)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 285:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 288:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 289:	31 db                	xor    %ebx,%ebx
{
 28b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 28e:	eb 27                	jmp    2b7 <gets+0x37>
    cc = read(0, &c, 1);
 290:	83 ec 04             	sub    $0x4,%esp
 293:	6a 01                	push   $0x1
 295:	57                   	push   %edi
 296:	6a 00                	push   $0x0
 298:	e8 2e 01 00 00       	call   3cb <read>
    if(cc < 1)
 29d:	83 c4 10             	add    $0x10,%esp
 2a0:	85 c0                	test   %eax,%eax
 2a2:	7e 1d                	jle    2c1 <gets+0x41>
      break;
    buf[i++] = c;
 2a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a8:	8b 55 08             	mov    0x8(%ebp),%edx
 2ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2af:	3c 0a                	cmp    $0xa,%al
 2b1:	74 1d                	je     2d0 <gets+0x50>
 2b3:	3c 0d                	cmp    $0xd,%al
 2b5:	74 19                	je     2d0 <gets+0x50>
  for(i=0; i+1 < max; ){
 2b7:	89 de                	mov    %ebx,%esi
 2b9:	83 c3 01             	add    $0x1,%ebx
 2bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2bf:	7c cf                	jl     290 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2cb:	5b                   	pop    %ebx
 2cc:	5e                   	pop    %esi
 2cd:	5f                   	pop    %edi
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    
  buf[i] = '\0';
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	89 de                	mov    %ebx,%esi
 2d5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 2d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dc:	5b                   	pop    %ebx
 2dd:	5e                   	pop    %esi
 2de:	5f                   	pop    %edi
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    
 2e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	6a 00                	push   $0x0
 2fa:	ff 75 08             	push   0x8(%ebp)
 2fd:	e8 f1 00 00 00       	call   3f3 <open>
  if(fd < 0)
 302:	83 c4 10             	add    $0x10,%esp
 305:	85 c0                	test   %eax,%eax
 307:	78 27                	js     330 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	ff 75 0c             	push   0xc(%ebp)
 30f:	89 c3                	mov    %eax,%ebx
 311:	50                   	push   %eax
 312:	e8 f4 00 00 00       	call   40b <fstat>
  close(fd);
 317:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 31a:	89 c6                	mov    %eax,%esi
  close(fd);
 31c:	e8 ba 00 00 00       	call   3db <close>
  return r;
 321:	83 c4 10             	add    $0x10,%esp
}
 324:	8d 65 f8             	lea    -0x8(%ebp),%esp
 327:	89 f0                	mov    %esi,%eax
 329:	5b                   	pop    %ebx
 32a:	5e                   	pop    %esi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 330:	be ff ff ff ff       	mov    $0xffffffff,%esi
 335:	eb ed                	jmp    324 <stat+0x34>
 337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33e:	66 90                	xchg   %ax,%ax

00000340 <atoi>:

int
atoi(const char *s)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 347:	0f be 02             	movsbl (%edx),%eax
 34a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 34d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 350:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 355:	77 1e                	ja     375 <atoi+0x35>
 357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 360:	83 c2 01             	add    $0x1,%edx
 363:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 366:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 36a:	0f be 02             	movsbl (%edx),%eax
 36d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 370:	80 fb 09             	cmp    $0x9,%bl
 373:	76 eb                	jbe    360 <atoi+0x20>
  return n;
}
 375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 378:	89 c8                	mov    %ecx,%eax
 37a:	c9                   	leave  
 37b:	c3                   	ret    
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000380 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	8b 45 10             	mov    0x10(%ebp),%eax
 387:	8b 55 08             	mov    0x8(%ebp),%edx
 38a:	56                   	push   %esi
 38b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38e:	85 c0                	test   %eax,%eax
 390:	7e 13                	jle    3a5 <memmove+0x25>
 392:	01 d0                	add    %edx,%eax
  dst = vdst;
 394:	89 d7                	mov    %edx,%edi
 396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 3a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3a1:	39 f8                	cmp    %edi,%eax
 3a3:	75 fb                	jne    3a0 <memmove+0x20>
  return vdst;
}
 3a5:	5e                   	pop    %esi
 3a6:	89 d0                	mov    %edx,%eax
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret    

000003ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ab:	b8 01 00 00 00       	mov    $0x1,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <exit>:
SYSCALL(exit)
 3b3:	b8 02 00 00 00       	mov    $0x2,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <wait>:
SYSCALL(wait)
 3bb:	b8 03 00 00 00       	mov    $0x3,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <pipe>:
SYSCALL(pipe)
 3c3:	b8 04 00 00 00       	mov    $0x4,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <read>:
SYSCALL(read)
 3cb:	b8 05 00 00 00       	mov    $0x5,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <write>:
SYSCALL(write)
 3d3:	b8 10 00 00 00       	mov    $0x10,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <close>:
SYSCALL(close)
 3db:	b8 15 00 00 00       	mov    $0x15,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <kill>:
SYSCALL(kill)
 3e3:	b8 06 00 00 00       	mov    $0x6,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <exec>:
SYSCALL(exec)
 3eb:	b8 07 00 00 00       	mov    $0x7,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <open>:
SYSCALL(open)
 3f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <mknod>:
SYSCALL(mknod)
 3fb:	b8 11 00 00 00       	mov    $0x11,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <unlink>:
SYSCALL(unlink)
 403:	b8 12 00 00 00       	mov    $0x12,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <fstat>:
SYSCALL(fstat)
 40b:	b8 08 00 00 00       	mov    $0x8,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <link>:
SYSCALL(link)
 413:	b8 13 00 00 00       	mov    $0x13,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <mkdir>:
SYSCALL(mkdir)
 41b:	b8 14 00 00 00       	mov    $0x14,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <chdir>:
SYSCALL(chdir)
 423:	b8 09 00 00 00       	mov    $0x9,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <dup>:
SYSCALL(dup)
 42b:	b8 0a 00 00 00       	mov    $0xa,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <getpid>:
SYSCALL(getpid)
 433:	b8 0b 00 00 00       	mov    $0xb,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <sbrk>:
SYSCALL(sbrk)
 43b:	b8 0c 00 00 00       	mov    $0xc,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <sleep>:
SYSCALL(sleep)
 443:	b8 0d 00 00 00       	mov    $0xd,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <uptime>:
SYSCALL(uptime)
 44b:	b8 0e 00 00 00       	mov    $0xe,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <find_next_prime_number>:
SYSCALL(find_next_prime_number)
 453:	b8 16 00 00 00       	mov    $0x16,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <get_call_count>:
SYSCALL(get_call_count)
 45b:	b8 17 00 00 00       	mov    $0x17,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <get_most_caller>:
SYSCALL(get_most_caller)
 463:	b8 18 00 00 00       	mov    $0x18,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <wait_for_process>:
SYSCALL(wait_for_process)
 46b:	b8 19 00 00 00       	mov    $0x19,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <set_queue>:
SYSCALL(set_queue)
 473:	b8 1a 00 00 00       	mov    $0x1a,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <print_procs>:
SYSCALL(print_procs)
 47b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <set_global_bjf_params>:
SYSCALL(set_global_bjf_params)
 483:	b8 1c 00 00 00       	mov    $0x1c,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <set_bjf_params>:
SYSCALL(set_bjf_params)
 48b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <sem_init>:
SYSCALL(sem_init)
 493:	b8 1e 00 00 00       	mov    $0x1e,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <sem_acquire>:
SYSCALL(sem_acquire)
 49b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <sem_release>:
SYSCALL(sem_release)
 4a3:	b8 20 00 00 00       	mov    $0x20,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <initlock_rl>:
SYSCALL(initlock_rl)
 4ab:	b8 21 00 00 00       	mov    $0x21,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <acquire_rl>:
SYSCALL(acquire_rl)
 4b3:	b8 22 00 00 00       	mov    $0x22,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <release_rl>:
 4bb:	b8 23 00 00 00       	mov    $0x23,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    
 4c3:	66 90                	xchg   %ax,%ax
 4c5:	66 90                	xchg   %ax,%ax
 4c7:	66 90                	xchg   %ax,%ax
 4c9:	66 90                	xchg   %ax,%ax
 4cb:	66 90                	xchg   %ax,%ax
 4cd:	66 90                	xchg   %ax,%ax
 4cf:	90                   	nop

000004d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 3c             	sub    $0x3c,%esp
 4d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4dc:	89 d1                	mov    %edx,%ecx
{
 4de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4e1:	85 d2                	test   %edx,%edx
 4e3:	0f 89 7f 00 00 00    	jns    568 <printint+0x98>
 4e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4ed:	74 79                	je     568 <printint+0x98>
    neg = 1;
 4ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 4f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 4f8:	31 db                	xor    %ebx,%ebx
 4fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 500:	89 c8                	mov    %ecx,%eax
 502:	31 d2                	xor    %edx,%edx
 504:	89 cf                	mov    %ecx,%edi
 506:	f7 75 c4             	divl   -0x3c(%ebp)
 509:	0f b6 92 58 09 00 00 	movzbl 0x958(%edx),%edx
 510:	89 45 c0             	mov    %eax,-0x40(%ebp)
 513:	89 d8                	mov    %ebx,%eax
 515:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 518:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 51b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 51e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 521:	76 dd                	jbe    500 <printint+0x30>
  if(neg)
 523:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 526:	85 c9                	test   %ecx,%ecx
 528:	74 0c                	je     536 <printint+0x66>
    buf[i++] = '-';
 52a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 52f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 531:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 536:	8b 7d b8             	mov    -0x48(%ebp),%edi
 539:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 53d:	eb 07                	jmp    546 <printint+0x76>
 53f:	90                   	nop
    putc(fd, buf[i]);
 540:	0f b6 13             	movzbl (%ebx),%edx
 543:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 546:	83 ec 04             	sub    $0x4,%esp
 549:	88 55 d7             	mov    %dl,-0x29(%ebp)
 54c:	6a 01                	push   $0x1
 54e:	56                   	push   %esi
 54f:	57                   	push   %edi
 550:	e8 7e fe ff ff       	call   3d3 <write>
  while(--i >= 0)
 555:	83 c4 10             	add    $0x10,%esp
 558:	39 de                	cmp    %ebx,%esi
 55a:	75 e4                	jne    540 <printint+0x70>
}
 55c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55f:	5b                   	pop    %ebx
 560:	5e                   	pop    %esi
 561:	5f                   	pop    %edi
 562:	5d                   	pop    %ebp
 563:	c3                   	ret    
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 568:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 56f:	eb 87                	jmp    4f8 <printint+0x28>
 571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop

00000580 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 589:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 58c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 58f:	0f b6 13             	movzbl (%ebx),%edx
 592:	84 d2                	test   %dl,%dl
 594:	74 6a                	je     600 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 596:	8d 45 10             	lea    0x10(%ebp),%eax
 599:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 59c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 59f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 5a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5a4:	eb 36                	jmp    5dc <printf+0x5c>
 5a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
 5b0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5b3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 5b8:	83 f8 25             	cmp    $0x25,%eax
 5bb:	74 15                	je     5d2 <printf+0x52>
  write(fd, &c, 1);
 5bd:	83 ec 04             	sub    $0x4,%esp
 5c0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5c3:	6a 01                	push   $0x1
 5c5:	57                   	push   %edi
 5c6:	56                   	push   %esi
 5c7:	e8 07 fe ff ff       	call   3d3 <write>
 5cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 5cf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5d2:	0f b6 13             	movzbl (%ebx),%edx
 5d5:	83 c3 01             	add    $0x1,%ebx
 5d8:	84 d2                	test   %dl,%dl
 5da:	74 24                	je     600 <printf+0x80>
    c = fmt[i] & 0xff;
 5dc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 5df:	85 c9                	test   %ecx,%ecx
 5e1:	74 cd                	je     5b0 <printf+0x30>
      }
    } else if(state == '%'){
 5e3:	83 f9 25             	cmp    $0x25,%ecx
 5e6:	75 ea                	jne    5d2 <printf+0x52>
      if(c == 'd'){
 5e8:	83 f8 25             	cmp    $0x25,%eax
 5eb:	0f 84 07 01 00 00    	je     6f8 <printf+0x178>
 5f1:	83 e8 63             	sub    $0x63,%eax
 5f4:	83 f8 15             	cmp    $0x15,%eax
 5f7:	77 17                	ja     610 <printf+0x90>
 5f9:	ff 24 85 00 09 00 00 	jmp    *0x900(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 600:	8d 65 f4             	lea    -0xc(%ebp),%esp
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret    
 608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
 613:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 616:	6a 01                	push   $0x1
 618:	57                   	push   %edi
 619:	56                   	push   %esi
 61a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 61e:	e8 b0 fd ff ff       	call   3d3 <write>
        putc(fd, c);
 623:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 627:	83 c4 0c             	add    $0xc,%esp
 62a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 62d:	6a 01                	push   $0x1
 62f:	57                   	push   %edi
 630:	56                   	push   %esi
 631:	e8 9d fd ff ff       	call   3d3 <write>
        putc(fd, c);
 636:	83 c4 10             	add    $0x10,%esp
      state = 0;
 639:	31 c9                	xor    %ecx,%ecx
 63b:	eb 95                	jmp    5d2 <printf+0x52>
 63d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	b9 10 00 00 00       	mov    $0x10,%ecx
 648:	6a 00                	push   $0x0
 64a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 64d:	8b 10                	mov    (%eax),%edx
 64f:	89 f0                	mov    %esi,%eax
 651:	e8 7a fe ff ff       	call   4d0 <printint>
        ap++;
 656:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 65a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 65d:	31 c9                	xor    %ecx,%ecx
 65f:	e9 6e ff ff ff       	jmp    5d2 <printf+0x52>
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 668:	8b 45 d0             	mov    -0x30(%ebp),%eax
 66b:	8b 10                	mov    (%eax),%edx
        ap++;
 66d:	83 c0 04             	add    $0x4,%eax
 670:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 673:	85 d2                	test   %edx,%edx
 675:	0f 84 8d 00 00 00    	je     708 <printf+0x188>
        while(*s != 0){
 67b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 67e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 680:	84 c0                	test   %al,%al
 682:	0f 84 4a ff ff ff    	je     5d2 <printf+0x52>
 688:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 68b:	89 d3                	mov    %edx,%ebx
 68d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 690:	83 ec 04             	sub    $0x4,%esp
          s++;
 693:	83 c3 01             	add    $0x1,%ebx
 696:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 699:	6a 01                	push   $0x1
 69b:	57                   	push   %edi
 69c:	56                   	push   %esi
 69d:	e8 31 fd ff ff       	call   3d3 <write>
        while(*s != 0){
 6a2:	0f b6 03             	movzbl (%ebx),%eax
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	84 c0                	test   %al,%al
 6aa:	75 e4                	jne    690 <printf+0x110>
      state = 0;
 6ac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 6af:	31 c9                	xor    %ecx,%ecx
 6b1:	e9 1c ff ff ff       	jmp    5d2 <printf+0x52>
 6b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6c8:	6a 01                	push   $0x1
 6ca:	e9 7b ff ff ff       	jmp    64a <printf+0xca>
 6cf:	90                   	nop
        putc(fd, *ap);
 6d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 6d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6d6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 6d8:	6a 01                	push   $0x1
 6da:	57                   	push   %edi
 6db:	56                   	push   %esi
        putc(fd, *ap);
 6dc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6df:	e8 ef fc ff ff       	call   3d3 <write>
        ap++;
 6e4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6eb:	31 c9                	xor    %ecx,%ecx
 6ed:	e9 e0 fe ff ff       	jmp    5d2 <printf+0x52>
 6f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 6f8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	e9 2a ff ff ff       	jmp    62d <printf+0xad>
 703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 707:	90                   	nop
          s = "(null)";
 708:	ba f6 08 00 00       	mov    $0x8f6,%edx
        while(*s != 0){
 70d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 710:	b8 28 00 00 00       	mov    $0x28,%eax
 715:	89 d3                	mov    %edx,%ebx
 717:	e9 74 ff ff ff       	jmp    690 <printf+0x110>
 71c:	66 90                	xchg   %ax,%ax
 71e:	66 90                	xchg   %ax,%ax

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 74 0c 00 00       	mov    0xc74,%eax
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 72e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 738:	89 c2                	mov    %eax,%edx
 73a:	8b 00                	mov    (%eax),%eax
 73c:	39 ca                	cmp    %ecx,%edx
 73e:	73 30                	jae    770 <free+0x50>
 740:	39 c1                	cmp    %eax,%ecx
 742:	72 04                	jb     748 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	39 c2                	cmp    %eax,%edx
 746:	72 f0                	jb     738 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 748:	8b 73 fc             	mov    -0x4(%ebx),%esi
 74b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 74e:	39 f8                	cmp    %edi,%eax
 750:	74 30                	je     782 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 755:	8b 42 04             	mov    0x4(%edx),%eax
 758:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 75b:	39 f1                	cmp    %esi,%ecx
 75d:	74 3a                	je     799 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 75f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 761:	5b                   	pop    %ebx
  freep = p;
 762:	89 15 74 0c 00 00    	mov    %edx,0xc74
}
 768:	5e                   	pop    %esi
 769:	5f                   	pop    %edi
 76a:	5d                   	pop    %ebp
 76b:	c3                   	ret    
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	39 c2                	cmp    %eax,%edx
 772:	72 c4                	jb     738 <free+0x18>
 774:	39 c1                	cmp    %eax,%ecx
 776:	73 c0                	jae    738 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 778:	8b 73 fc             	mov    -0x4(%ebx),%esi
 77b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 77e:	39 f8                	cmp    %edi,%eax
 780:	75 d0                	jne    752 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 782:	03 70 04             	add    0x4(%eax),%esi
 785:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	8b 02                	mov    (%edx),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 78f:	8b 42 04             	mov    0x4(%edx),%eax
 792:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 795:	39 f1                	cmp    %esi,%ecx
 797:	75 c6                	jne    75f <free+0x3f>
    p->s.size += bp->s.size;
 799:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 79c:	89 15 74 0c 00 00    	mov    %edx,0xc74
    p->s.size += bp->s.size;
 7a2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7a5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7a8:	89 0a                	mov    %ecx,(%edx)
}
 7aa:	5b                   	pop    %ebx
 7ab:	5e                   	pop    %esi
 7ac:	5f                   	pop    %edi
 7ad:	5d                   	pop    %ebp
 7ae:	c3                   	ret    
 7af:	90                   	nop

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7bc:	8b 3d 74 0c 00 00    	mov    0xc74,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	8d 70 07             	lea    0x7(%eax),%esi
 7c5:	c1 ee 03             	shr    $0x3,%esi
 7c8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7cb:	85 ff                	test   %edi,%edi
 7cd:	0f 84 9d 00 00 00    	je     870 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 7d5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7d8:	39 f1                	cmp    %esi,%ecx
 7da:	73 6a                	jae    846 <malloc+0x96>
 7dc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7e1:	39 de                	cmp    %ebx,%esi
 7e3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7e6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7f0:	eb 17                	jmp    809 <malloc+0x59>
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7fa:	8b 48 04             	mov    0x4(%eax),%ecx
 7fd:	39 f1                	cmp    %esi,%ecx
 7ff:	73 4f                	jae    850 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 801:	8b 3d 74 0c 00 00    	mov    0xc74,%edi
 807:	89 c2                	mov    %eax,%edx
 809:	39 d7                	cmp    %edx,%edi
 80b:	75 eb                	jne    7f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 80d:	83 ec 0c             	sub    $0xc,%esp
 810:	ff 75 e4             	push   -0x1c(%ebp)
 813:	e8 23 fc ff ff       	call   43b <sbrk>
  if(p == (char*)-1)
 818:	83 c4 10             	add    $0x10,%esp
 81b:	83 f8 ff             	cmp    $0xffffffff,%eax
 81e:	74 1c                	je     83c <malloc+0x8c>
  hp->s.size = nu;
 820:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 823:	83 ec 0c             	sub    $0xc,%esp
 826:	83 c0 08             	add    $0x8,%eax
 829:	50                   	push   %eax
 82a:	e8 f1 fe ff ff       	call   720 <free>
  return freep;
 82f:	8b 15 74 0c 00 00    	mov    0xc74,%edx
      if((p = morecore(nunits)) == 0)
 835:	83 c4 10             	add    $0x10,%esp
 838:	85 d2                	test   %edx,%edx
 83a:	75 bc                	jne    7f8 <malloc+0x48>
        return 0;
  }
}
 83c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 83f:	31 c0                	xor    %eax,%eax
}
 841:	5b                   	pop    %ebx
 842:	5e                   	pop    %esi
 843:	5f                   	pop    %edi
 844:	5d                   	pop    %ebp
 845:	c3                   	ret    
    if(p->s.size >= nunits){
 846:	89 d0                	mov    %edx,%eax
 848:	89 fa                	mov    %edi,%edx
 84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 850:	39 ce                	cmp    %ecx,%esi
 852:	74 4c                	je     8a0 <malloc+0xf0>
        p->s.size -= nunits;
 854:	29 f1                	sub    %esi,%ecx
 856:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 859:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 85c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 85f:	89 15 74 0c 00 00    	mov    %edx,0xc74
}
 865:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 868:	83 c0 08             	add    $0x8,%eax
}
 86b:	5b                   	pop    %ebx
 86c:	5e                   	pop    %esi
 86d:	5f                   	pop    %edi
 86e:	5d                   	pop    %ebp
 86f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 870:	c7 05 74 0c 00 00 78 	movl   $0xc78,0xc74
 877:	0c 00 00 
    base.s.size = 0;
 87a:	bf 78 0c 00 00       	mov    $0xc78,%edi
    base.s.ptr = freep = prevp = &base;
 87f:	c7 05 78 0c 00 00 78 	movl   $0xc78,0xc78
 886:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 889:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 88b:	c7 05 7c 0c 00 00 00 	movl   $0x0,0xc7c
 892:	00 00 00 
    if(p->s.size >= nunits){
 895:	e9 42 ff ff ff       	jmp    7dc <malloc+0x2c>
 89a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8a0:	8b 08                	mov    (%eax),%ecx
 8a2:	89 0a                	mov    %ecx,(%edx)
 8a4:	eb b9                	jmp    85f <malloc+0xaf>

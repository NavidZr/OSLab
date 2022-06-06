
_reentrant_mutex:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    second_func(temp);
    return 0;
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    if(fork() == 0)
  11:	e8 d5 04 00 00       	call   4eb <fork>
  16:	85 c0                	test   %eax,%eax
  18:	75 0f                	jne    29 <main+0x29>
        initlock_rl();
  1a:	e8 cc 05 00 00       	call   5eb <initlock_rl>
    // {
    //     sleep(5);
    //     second_func(10);
    // }
    return 0;
  1f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  22:	31 c0                	xor    %eax,%eax
  24:	c9                   	leave  
  25:	8d 61 fc             	lea    -0x4(%ecx),%esp
  28:	c3                   	ret    
        sleep(5);
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 05                	push   $0x5
  2e:	e8 50 05 00 00       	call   583 <sleep>
        acquire_rl();
  33:	e8 bb 05 00 00       	call   5f3 <acquire_rl>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	eb e2                	jmp    1f <main+0x1f>
  3d:	66 90                	xchg   %ax,%ax
  3f:	90                   	nop

00000040 <first_func>:
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	56                   	push   %esi
  44:	53                   	push   %ebx
  45:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire_rl();
  48:	e8 a6 05 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
  4d:	85 db                	test   %ebx,%ebx
  4f:	0f 84 eb 00 00 00    	je     140 <first_func+0x100>
    printf(1,"first func run number %d \n",n);
  55:	83 ec 04             	sub    $0x4,%esp
    temp--;
  58:	8d 73 ff             	lea    -0x1(%ebx),%esi
    printf(1,"first func run number %d \n",n);
  5b:	53                   	push   %ebx
  5c:	68 f9 09 00 00       	push   $0x9f9
  61:	6a 01                	push   $0x1
  63:	e8 58 06 00 00       	call   6c0 <printf>
    acquire_rl();
  68:	e8 86 05 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
  6d:	83 c4 10             	add    $0x10,%esp
  70:	85 f6                	test   %esi,%esi
  72:	0f 84 a8 00 00 00    	je     120 <first_func+0xe0>
    printf(1,"first func run number %d \n",n);
  78:	83 ec 04             	sub    $0x4,%esp
  7b:	56                   	push   %esi
    temp--;
  7c:	8d 73 fe             	lea    -0x2(%ebx),%esi
    printf(1,"first func run number %d \n",n);
  7f:	68 f9 09 00 00       	push   $0x9f9
  84:	6a 01                	push   $0x1
  86:	e8 35 06 00 00       	call   6c0 <printf>
    acquire_rl();
  8b:	e8 63 05 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
  90:	83 c4 10             	add    $0x10,%esp
  93:	85 f6                	test   %esi,%esi
  95:	0f 84 85 00 00 00    	je     120 <first_func+0xe0>
    printf(1,"first func run number %d \n",n);
  9b:	83 ec 04             	sub    $0x4,%esp
  9e:	56                   	push   %esi
    temp--;
  9f:	8d 73 fd             	lea    -0x3(%ebx),%esi
    printf(1,"first func run number %d \n",n);
  a2:	68 f9 09 00 00       	push   $0x9f9
  a7:	6a 01                	push   $0x1
  a9:	e8 12 06 00 00       	call   6c0 <printf>
    acquire_rl();
  ae:	e8 40 05 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	85 f6                	test   %esi,%esi
  b8:	74 66                	je     120 <first_func+0xe0>
    printf(1,"first func run number %d \n",n);
  ba:	83 ec 04             	sub    $0x4,%esp
  bd:	56                   	push   %esi
    temp--;
  be:	8d 73 fc             	lea    -0x4(%ebx),%esi
    printf(1,"first func run number %d \n",n);
  c1:	68 f9 09 00 00       	push   $0x9f9
  c6:	6a 01                	push   $0x1
  c8:	e8 f3 05 00 00       	call   6c0 <printf>
    acquire_rl();
  cd:	e8 21 05 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	85 f6                	test   %esi,%esi
  d7:	74 47                	je     120 <first_func+0xe0>
    printf(1,"first func run number %d \n",n);
  d9:	83 ec 04             	sub    $0x4,%esp
  dc:	56                   	push   %esi
    temp--;
  dd:	8d 73 fb             	lea    -0x5(%ebx),%esi
    printf(1,"first func run number %d \n",n);
  e0:	68 f9 09 00 00       	push   $0x9f9
  e5:	6a 01                	push   $0x1
  e7:	e8 d4 05 00 00       	call   6c0 <printf>
    acquire_rl();
  ec:	e8 02 05 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
  f1:	83 c4 10             	add    $0x10,%esp
  f4:	85 f6                	test   %esi,%esi
  f6:	74 28                	je     120 <first_func+0xe0>
    printf(1,"first func run number %d \n",n);
  f8:	83 ec 04             	sub    $0x4,%esp
    temp--;
  fb:	83 eb 06             	sub    $0x6,%ebx
    printf(1,"first func run number %d \n",n);
  fe:	56                   	push   %esi
  ff:	68 f9 09 00 00       	push   $0x9f9
 104:	6a 01                	push   $0x1
 106:	e8 b5 05 00 00       	call   6c0 <printf>
    first_func(temp);
 10b:	89 1c 24             	mov    %ebx,(%esp)
 10e:	e8 2d ff ff ff       	call   40 <first_func>
    return 0;
 113:	83 c4 10             	add    $0x10,%esp
 116:	31 c0                	xor    %eax,%eax
 118:	eb 1f                	jmp    139 <first_func+0xf9>
 11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1,"first func done\n");
 120:	83 ec 08             	sub    $0x8,%esp
 123:	68 e8 09 00 00       	push   $0x9e8
 128:	6a 01                	push   $0x1
 12a:	e8 91 05 00 00       	call   6c0 <printf>
        release_rl();
 12f:	e8 c7 04 00 00       	call   5fb <release_rl>
        return 1;
 134:	83 c4 10             	add    $0x10,%esp
    return 0;
 137:	31 c0                	xor    %eax,%eax
}
 139:	8d 65 f8             	lea    -0x8(%ebp),%esp
 13c:	5b                   	pop    %ebx
 13d:	5e                   	pop    %esi
 13e:	5d                   	pop    %ebp
 13f:	c3                   	ret    
        printf(1,"first func done\n");
 140:	83 ec 08             	sub    $0x8,%esp
 143:	68 e8 09 00 00       	push   $0x9e8
 148:	6a 01                	push   $0x1
 14a:	e8 71 05 00 00       	call   6c0 <printf>
        release_rl();
 14f:	e8 a7 04 00 00       	call   5fb <release_rl>
        return 1;
 154:	83 c4 10             	add    $0x10,%esp
}
 157:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 1;
 15a:	b8 01 00 00 00       	mov    $0x1,%eax
}
 15f:	5b                   	pop    %ebx
 160:	5e                   	pop    %esi
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <second_func>:
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	56                   	push   %esi
 174:	53                   	push   %ebx
 175:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire_rl();
 178:	e8 76 04 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
 17d:	85 db                	test   %ebx,%ebx
 17f:	0f 84 eb 00 00 00    	je     270 <second_func+0x100>
    printf(1,"sec func run number %d \n",n);
 185:	83 ec 04             	sub    $0x4,%esp
    temp--;
 188:	8d 73 ff             	lea    -0x1(%ebx),%esi
    printf(1,"sec func run number %d \n",n);
 18b:	53                   	push   %ebx
 18c:	68 26 0a 00 00       	push   $0xa26
 191:	6a 01                	push   $0x1
 193:	e8 28 05 00 00       	call   6c0 <printf>
    acquire_rl();
 198:	e8 56 04 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	85 f6                	test   %esi,%esi
 1a2:	0f 84 a8 00 00 00    	je     250 <second_func+0xe0>
    printf(1,"sec func run number %d \n",n);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	56                   	push   %esi
    temp--;
 1ac:	8d 73 fe             	lea    -0x2(%ebx),%esi
    printf(1,"sec func run number %d \n",n);
 1af:	68 26 0a 00 00       	push   $0xa26
 1b4:	6a 01                	push   $0x1
 1b6:	e8 05 05 00 00       	call   6c0 <printf>
    acquire_rl();
 1bb:	e8 33 04 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
 1c0:	83 c4 10             	add    $0x10,%esp
 1c3:	85 f6                	test   %esi,%esi
 1c5:	0f 84 85 00 00 00    	je     250 <second_func+0xe0>
    printf(1,"sec func run number %d \n",n);
 1cb:	83 ec 04             	sub    $0x4,%esp
 1ce:	56                   	push   %esi
    temp--;
 1cf:	8d 73 fd             	lea    -0x3(%ebx),%esi
    printf(1,"sec func run number %d \n",n);
 1d2:	68 26 0a 00 00       	push   $0xa26
 1d7:	6a 01                	push   $0x1
 1d9:	e8 e2 04 00 00       	call   6c0 <printf>
    acquire_rl();
 1de:	e8 10 04 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
 1e3:	83 c4 10             	add    $0x10,%esp
 1e6:	85 f6                	test   %esi,%esi
 1e8:	74 66                	je     250 <second_func+0xe0>
    printf(1,"sec func run number %d \n",n);
 1ea:	83 ec 04             	sub    $0x4,%esp
 1ed:	56                   	push   %esi
    temp--;
 1ee:	8d 73 fc             	lea    -0x4(%ebx),%esi
    printf(1,"sec func run number %d \n",n);
 1f1:	68 26 0a 00 00       	push   $0xa26
 1f6:	6a 01                	push   $0x1
 1f8:	e8 c3 04 00 00       	call   6c0 <printf>
    acquire_rl();
 1fd:	e8 f1 03 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 f6                	test   %esi,%esi
 207:	74 47                	je     250 <second_func+0xe0>
    printf(1,"sec func run number %d \n",n);
 209:	83 ec 04             	sub    $0x4,%esp
 20c:	56                   	push   %esi
    temp--;
 20d:	8d 73 fb             	lea    -0x5(%ebx),%esi
    printf(1,"sec func run number %d \n",n);
 210:	68 26 0a 00 00       	push   $0xa26
 215:	6a 01                	push   $0x1
 217:	e8 a4 04 00 00       	call   6c0 <printf>
    acquire_rl();
 21c:	e8 d2 03 00 00       	call   5f3 <acquire_rl>
    if (n == 0){
 221:	83 c4 10             	add    $0x10,%esp
 224:	85 f6                	test   %esi,%esi
 226:	74 28                	je     250 <second_func+0xe0>
    printf(1,"sec func run number %d \n",n);
 228:	83 ec 04             	sub    $0x4,%esp
    temp--;
 22b:	83 eb 06             	sub    $0x6,%ebx
    printf(1,"sec func run number %d \n",n);
 22e:	56                   	push   %esi
 22f:	68 26 0a 00 00       	push   $0xa26
 234:	6a 01                	push   $0x1
 236:	e8 85 04 00 00       	call   6c0 <printf>
    second_func(temp);
 23b:	89 1c 24             	mov    %ebx,(%esp)
 23e:	e8 2d ff ff ff       	call   170 <second_func>
    return 0;
 243:	83 c4 10             	add    $0x10,%esp
 246:	31 c0                	xor    %eax,%eax
 248:	eb 1f                	jmp    269 <second_func+0xf9>
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1,"second func done\n");
 250:	83 ec 08             	sub    $0x8,%esp
 253:	68 14 0a 00 00       	push   $0xa14
 258:	6a 01                	push   $0x1
 25a:	e8 61 04 00 00       	call   6c0 <printf>
        release_rl();
 25f:	e8 97 03 00 00       	call   5fb <release_rl>
        return 1;
 264:	83 c4 10             	add    $0x10,%esp
    return 0;
 267:	31 c0                	xor    %eax,%eax
}
 269:	8d 65 f8             	lea    -0x8(%ebp),%esp
 26c:	5b                   	pop    %ebx
 26d:	5e                   	pop    %esi
 26e:	5d                   	pop    %ebp
 26f:	c3                   	ret    
        printf(1,"second func done\n");
 270:	83 ec 08             	sub    $0x8,%esp
 273:	68 14 0a 00 00       	push   $0xa14
 278:	6a 01                	push   $0x1
 27a:	e8 41 04 00 00       	call   6c0 <printf>
        release_rl();
 27f:	e8 77 03 00 00       	call   5fb <release_rl>
        return 1;
 284:	83 c4 10             	add    $0x10,%esp
}
 287:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 1;
 28a:	b8 01 00 00 00       	mov    $0x1,%eax
}
 28f:	5b                   	pop    %ebx
 290:	5e                   	pop    %esi
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
 293:	66 90                	xchg   %ax,%ax
 295:	66 90                	xchg   %ax,%ax
 297:	66 90                	xchg   %ax,%ax
 299:	66 90                	xchg   %ax,%ax
 29b:	66 90                	xchg   %ax,%ax
 29d:	66 90                	xchg   %ax,%ax
 29f:	90                   	nop

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a1:	31 c0                	xor    %eax,%eax
{
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	53                   	push   %ebx
 2a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2b7:	83 c0 01             	add    $0x1,%eax
 2ba:	84 d2                	test   %dl,%dl
 2bc:	75 f2                	jne    2b0 <strcpy+0x10>
    ;
  return os;
}
 2be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c1:	89 c8                	mov    %ecx,%eax
 2c3:	c9                   	leave  
 2c4:	c3                   	ret    
 2c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
 2d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2da:	0f b6 02             	movzbl (%edx),%eax
 2dd:	84 c0                	test   %al,%al
 2df:	75 17                	jne    2f8 <strcmp+0x28>
 2e1:	eb 3a                	jmp    31d <strcmp+0x4d>
 2e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e7:	90                   	nop
 2e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2ec:	83 c2 01             	add    $0x1,%edx
 2ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2f2:	84 c0                	test   %al,%al
 2f4:	74 1a                	je     310 <strcmp+0x40>
    p++, q++;
 2f6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 2f8:	0f b6 19             	movzbl (%ecx),%ebx
 2fb:	38 c3                	cmp    %al,%bl
 2fd:	74 e9                	je     2e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2ff:	29 d8                	sub    %ebx,%eax
}
 301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 304:	c9                   	leave  
 305:	c3                   	ret    
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 310:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 314:	31 c0                	xor    %eax,%eax
 316:	29 d8                	sub    %ebx,%eax
}
 318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 31b:	c9                   	leave  
 31c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 31d:	0f b6 19             	movzbl (%ecx),%ebx
 320:	31 c0                	xor    %eax,%eax
 322:	eb db                	jmp    2ff <strcmp+0x2f>
 324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 32f:	90                   	nop

00000330 <strlen>:

uint
strlen(const char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 336:	80 3a 00             	cmpb   $0x0,(%edx)
 339:	74 15                	je     350 <strlen+0x20>
 33b:	31 c0                	xor    %eax,%eax
 33d:	8d 76 00             	lea    0x0(%esi),%esi
 340:	83 c0 01             	add    $0x1,%eax
 343:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 347:	89 c1                	mov    %eax,%ecx
 349:	75 f5                	jne    340 <strlen+0x10>
    ;
  return n;
}
 34b:	89 c8                	mov    %ecx,%eax
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret    
 34f:	90                   	nop
  for(n = 0; s[n]; n++)
 350:	31 c9                	xor    %ecx,%ecx
}
 352:	5d                   	pop    %ebp
 353:	89 c8                	mov    %ecx,%eax
 355:	c3                   	ret    
 356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35d:	8d 76 00             	lea    0x0(%esi),%esi

00000360 <memset>:

void*
memset(void *dst, int c, uint n)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 367:	8b 4d 10             	mov    0x10(%ebp),%ecx
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 d7                	mov    %edx,%edi
 36f:	fc                   	cld    
 370:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 372:	8b 7d fc             	mov    -0x4(%ebp),%edi
 375:	89 d0                	mov    %edx,%eax
 377:	c9                   	leave  
 378:	c3                   	ret    
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000380 <strchr>:

char*
strchr(const char *s, char c)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 38a:	0f b6 10             	movzbl (%eax),%edx
 38d:	84 d2                	test   %dl,%dl
 38f:	75 12                	jne    3a3 <strchr+0x23>
 391:	eb 1d                	jmp    3b0 <strchr+0x30>
 393:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 397:	90                   	nop
 398:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 39c:	83 c0 01             	add    $0x1,%eax
 39f:	84 d2                	test   %dl,%dl
 3a1:	74 0d                	je     3b0 <strchr+0x30>
    if(*s == c)
 3a3:	38 d1                	cmp    %dl,%cl
 3a5:	75 f1                	jne    398 <strchr+0x18>
      return (char*)s;
  return 0;
}
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3b0:	31 c0                	xor    %eax,%eax
}
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret    
 3b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop

000003c0 <gets>:

char*
gets(char *buf, int max)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 3c5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 3c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 3c9:	31 db                	xor    %ebx,%ebx
{
 3cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 3ce:	eb 27                	jmp    3f7 <gets+0x37>
    cc = read(0, &c, 1);
 3d0:	83 ec 04             	sub    $0x4,%esp
 3d3:	6a 01                	push   $0x1
 3d5:	57                   	push   %edi
 3d6:	6a 00                	push   $0x0
 3d8:	e8 2e 01 00 00       	call   50b <read>
    if(cc < 1)
 3dd:	83 c4 10             	add    $0x10,%esp
 3e0:	85 c0                	test   %eax,%eax
 3e2:	7e 1d                	jle    401 <gets+0x41>
      break;
    buf[i++] = c;
 3e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e8:	8b 55 08             	mov    0x8(%ebp),%edx
 3eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3ef:	3c 0a                	cmp    $0xa,%al
 3f1:	74 1d                	je     410 <gets+0x50>
 3f3:	3c 0d                	cmp    $0xd,%al
 3f5:	74 19                	je     410 <gets+0x50>
  for(i=0; i+1 < max; ){
 3f7:	89 de                	mov    %ebx,%esi
 3f9:	83 c3 01             	add    $0x1,%ebx
 3fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3ff:	7c cf                	jl     3d0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 408:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40b:	5b                   	pop    %ebx
 40c:	5e                   	pop    %esi
 40d:	5f                   	pop    %edi
 40e:	5d                   	pop    %ebp
 40f:	c3                   	ret    
  buf[i] = '\0';
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	89 de                	mov    %ebx,%esi
 415:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 419:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41c:	5b                   	pop    %ebx
 41d:	5e                   	pop    %esi
 41e:	5f                   	pop    %edi
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop

00000430 <stat>:

int
stat(const char *n, struct stat *st)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 435:	83 ec 08             	sub    $0x8,%esp
 438:	6a 00                	push   $0x0
 43a:	ff 75 08             	push   0x8(%ebp)
 43d:	e8 f1 00 00 00       	call   533 <open>
  if(fd < 0)
 442:	83 c4 10             	add    $0x10,%esp
 445:	85 c0                	test   %eax,%eax
 447:	78 27                	js     470 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 449:	83 ec 08             	sub    $0x8,%esp
 44c:	ff 75 0c             	push   0xc(%ebp)
 44f:	89 c3                	mov    %eax,%ebx
 451:	50                   	push   %eax
 452:	e8 f4 00 00 00       	call   54b <fstat>
  close(fd);
 457:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 45a:	89 c6                	mov    %eax,%esi
  close(fd);
 45c:	e8 ba 00 00 00       	call   51b <close>
  return r;
 461:	83 c4 10             	add    $0x10,%esp
}
 464:	8d 65 f8             	lea    -0x8(%ebp),%esp
 467:	89 f0                	mov    %esi,%eax
 469:	5b                   	pop    %ebx
 46a:	5e                   	pop    %esi
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    
 46d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 470:	be ff ff ff ff       	mov    $0xffffffff,%esi
 475:	eb ed                	jmp    464 <stat+0x34>
 477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47e:	66 90                	xchg   %ax,%ax

00000480 <atoi>:

int
atoi(const char *s)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	53                   	push   %ebx
 484:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 487:	0f be 02             	movsbl (%edx),%eax
 48a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 48d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 490:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 495:	77 1e                	ja     4b5 <atoi+0x35>
 497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 4a0:	83 c2 01             	add    $0x1,%edx
 4a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4aa:	0f be 02             	movsbl (%edx),%eax
 4ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4b0:	80 fb 09             	cmp    $0x9,%bl
 4b3:	76 eb                	jbe    4a0 <atoi+0x20>
  return n;
}
 4b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4b8:	89 c8                	mov    %ecx,%eax
 4ba:	c9                   	leave  
 4bb:	c3                   	ret    
 4bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	8b 45 10             	mov    0x10(%ebp),%eax
 4c7:	8b 55 08             	mov    0x8(%ebp),%edx
 4ca:	56                   	push   %esi
 4cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ce:	85 c0                	test   %eax,%eax
 4d0:	7e 13                	jle    4e5 <memmove+0x25>
 4d2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4d4:	89 d7                	mov    %edx,%edi
 4d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4e1:	39 f8                	cmp    %edi,%eax
 4e3:	75 fb                	jne    4e0 <memmove+0x20>
  return vdst;
}
 4e5:	5e                   	pop    %esi
 4e6:	89 d0                	mov    %edx,%eax
 4e8:	5f                   	pop    %edi
 4e9:	5d                   	pop    %ebp
 4ea:	c3                   	ret    

000004eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4eb:	b8 01 00 00 00       	mov    $0x1,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <exit>:
SYSCALL(exit)
 4f3:	b8 02 00 00 00       	mov    $0x2,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <wait>:
SYSCALL(wait)
 4fb:	b8 03 00 00 00       	mov    $0x3,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <pipe>:
SYSCALL(pipe)
 503:	b8 04 00 00 00       	mov    $0x4,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <read>:
SYSCALL(read)
 50b:	b8 05 00 00 00       	mov    $0x5,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <write>:
SYSCALL(write)
 513:	b8 10 00 00 00       	mov    $0x10,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <close>:
SYSCALL(close)
 51b:	b8 15 00 00 00       	mov    $0x15,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <kill>:
SYSCALL(kill)
 523:	b8 06 00 00 00       	mov    $0x6,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <exec>:
SYSCALL(exec)
 52b:	b8 07 00 00 00       	mov    $0x7,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <open>:
SYSCALL(open)
 533:	b8 0f 00 00 00       	mov    $0xf,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <mknod>:
SYSCALL(mknod)
 53b:	b8 11 00 00 00       	mov    $0x11,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <unlink>:
SYSCALL(unlink)
 543:	b8 12 00 00 00       	mov    $0x12,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <fstat>:
SYSCALL(fstat)
 54b:	b8 08 00 00 00       	mov    $0x8,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <link>:
SYSCALL(link)
 553:	b8 13 00 00 00       	mov    $0x13,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <mkdir>:
SYSCALL(mkdir)
 55b:	b8 14 00 00 00       	mov    $0x14,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <chdir>:
SYSCALL(chdir)
 563:	b8 09 00 00 00       	mov    $0x9,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <dup>:
SYSCALL(dup)
 56b:	b8 0a 00 00 00       	mov    $0xa,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <getpid>:
SYSCALL(getpid)
 573:	b8 0b 00 00 00       	mov    $0xb,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <sbrk>:
SYSCALL(sbrk)
 57b:	b8 0c 00 00 00       	mov    $0xc,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <sleep>:
SYSCALL(sleep)
 583:	b8 0d 00 00 00       	mov    $0xd,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <uptime>:
SYSCALL(uptime)
 58b:	b8 0e 00 00 00       	mov    $0xe,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <find_next_prime_number>:
SYSCALL(find_next_prime_number)
 593:	b8 16 00 00 00       	mov    $0x16,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <get_call_count>:
SYSCALL(get_call_count)
 59b:	b8 17 00 00 00       	mov    $0x17,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <get_most_caller>:
SYSCALL(get_most_caller)
 5a3:	b8 18 00 00 00       	mov    $0x18,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <wait_for_process>:
SYSCALL(wait_for_process)
 5ab:	b8 19 00 00 00       	mov    $0x19,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <set_queue>:
SYSCALL(set_queue)
 5b3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <print_procs>:
SYSCALL(print_procs)
 5bb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <set_global_bjf_params>:
SYSCALL(set_global_bjf_params)
 5c3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <set_bjf_params>:
SYSCALL(set_bjf_params)
 5cb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <sem_init>:
SYSCALL(sem_init)
 5d3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <sem_acquire>:
SYSCALL(sem_acquire)
 5db:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <sem_release>:
SYSCALL(sem_release)
 5e3:	b8 20 00 00 00       	mov    $0x20,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <initlock_rl>:
SYSCALL(initlock_rl)
 5eb:	b8 21 00 00 00       	mov    $0x21,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <acquire_rl>:
SYSCALL(acquire_rl)
 5f3:	b8 22 00 00 00       	mov    $0x22,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <release_rl>:
 5fb:	b8 23 00 00 00       	mov    $0x23,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    
 603:	66 90                	xchg   %ax,%ax
 605:	66 90                	xchg   %ax,%ax
 607:	66 90                	xchg   %ax,%ax
 609:	66 90                	xchg   %ax,%ax
 60b:	66 90                	xchg   %ax,%ax
 60d:	66 90                	xchg   %ax,%ax
 60f:	90                   	nop

00000610 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 3c             	sub    $0x3c,%esp
 619:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 61c:	89 d1                	mov    %edx,%ecx
{
 61e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 621:	85 d2                	test   %edx,%edx
 623:	0f 89 7f 00 00 00    	jns    6a8 <printint+0x98>
 629:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 62d:	74 79                	je     6a8 <printint+0x98>
    neg = 1;
 62f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 636:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 638:	31 db                	xor    %ebx,%ebx
 63a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 640:	89 c8                	mov    %ecx,%eax
 642:	31 d2                	xor    %edx,%edx
 644:	89 cf                	mov    %ecx,%edi
 646:	f7 75 c4             	divl   -0x3c(%ebp)
 649:	0f b6 92 a0 0a 00 00 	movzbl 0xaa0(%edx),%edx
 650:	89 45 c0             	mov    %eax,-0x40(%ebp)
 653:	89 d8                	mov    %ebx,%eax
 655:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 658:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 65b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 65e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 661:	76 dd                	jbe    640 <printint+0x30>
  if(neg)
 663:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 666:	85 c9                	test   %ecx,%ecx
 668:	74 0c                	je     676 <printint+0x66>
    buf[i++] = '-';
 66a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 66f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 671:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 676:	8b 7d b8             	mov    -0x48(%ebp),%edi
 679:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 67d:	eb 07                	jmp    686 <printint+0x76>
 67f:	90                   	nop
    putc(fd, buf[i]);
 680:	0f b6 13             	movzbl (%ebx),%edx
 683:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 686:	83 ec 04             	sub    $0x4,%esp
 689:	88 55 d7             	mov    %dl,-0x29(%ebp)
 68c:	6a 01                	push   $0x1
 68e:	56                   	push   %esi
 68f:	57                   	push   %edi
 690:	e8 7e fe ff ff       	call   513 <write>
  while(--i >= 0)
 695:	83 c4 10             	add    $0x10,%esp
 698:	39 de                	cmp    %ebx,%esi
 69a:	75 e4                	jne    680 <printint+0x70>
}
 69c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69f:	5b                   	pop    %ebx
 6a0:	5e                   	pop    %esi
 6a1:	5f                   	pop    %edi
 6a2:	5d                   	pop    %ebp
 6a3:	c3                   	ret    
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6af:	eb 87                	jmp    638 <printint+0x28>
 6b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop

000006c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 6cc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 6cf:	0f b6 13             	movzbl (%ebx),%edx
 6d2:	84 d2                	test   %dl,%dl
 6d4:	74 6a                	je     740 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 6d6:	8d 45 10             	lea    0x10(%ebp),%eax
 6d9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 6dc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6df:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 6e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6e4:	eb 36                	jmp    71c <printf+0x5c>
 6e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ed:	8d 76 00             	lea    0x0(%esi),%esi
 6f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6f3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 6f8:	83 f8 25             	cmp    $0x25,%eax
 6fb:	74 15                	je     712 <printf+0x52>
  write(fd, &c, 1);
 6fd:	83 ec 04             	sub    $0x4,%esp
 700:	88 55 e7             	mov    %dl,-0x19(%ebp)
 703:	6a 01                	push   $0x1
 705:	57                   	push   %edi
 706:	56                   	push   %esi
 707:	e8 07 fe ff ff       	call   513 <write>
 70c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 70f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 712:	0f b6 13             	movzbl (%ebx),%edx
 715:	83 c3 01             	add    $0x1,%ebx
 718:	84 d2                	test   %dl,%dl
 71a:	74 24                	je     740 <printf+0x80>
    c = fmt[i] & 0xff;
 71c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 71f:	85 c9                	test   %ecx,%ecx
 721:	74 cd                	je     6f0 <printf+0x30>
      }
    } else if(state == '%'){
 723:	83 f9 25             	cmp    $0x25,%ecx
 726:	75 ea                	jne    712 <printf+0x52>
      if(c == 'd'){
 728:	83 f8 25             	cmp    $0x25,%eax
 72b:	0f 84 07 01 00 00    	je     838 <printf+0x178>
 731:	83 e8 63             	sub    $0x63,%eax
 734:	83 f8 15             	cmp    $0x15,%eax
 737:	77 17                	ja     750 <printf+0x90>
 739:	ff 24 85 48 0a 00 00 	jmp    *0xa48(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 740:	8d 65 f4             	lea    -0xc(%ebp),%esp
 743:	5b                   	pop    %ebx
 744:	5e                   	pop    %esi
 745:	5f                   	pop    %edi
 746:	5d                   	pop    %ebp
 747:	c3                   	ret    
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 756:	6a 01                	push   $0x1
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 75e:	e8 b0 fd ff ff       	call   513 <write>
        putc(fd, c);
 763:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 767:	83 c4 0c             	add    $0xc,%esp
 76a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 76d:	6a 01                	push   $0x1
 76f:	57                   	push   %edi
 770:	56                   	push   %esi
 771:	e8 9d fd ff ff       	call   513 <write>
        putc(fd, c);
 776:	83 c4 10             	add    $0x10,%esp
      state = 0;
 779:	31 c9                	xor    %ecx,%ecx
 77b:	eb 95                	jmp    712 <printf+0x52>
 77d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 10 00 00 00       	mov    $0x10,%ecx
 788:	6a 00                	push   $0x0
 78a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 78d:	8b 10                	mov    (%eax),%edx
 78f:	89 f0                	mov    %esi,%eax
 791:	e8 7a fe ff ff       	call   610 <printint>
        ap++;
 796:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 79a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 79d:	31 c9                	xor    %ecx,%ecx
 79f:	e9 6e ff ff ff       	jmp    712 <printf+0x52>
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7ab:	8b 10                	mov    (%eax),%edx
        ap++;
 7ad:	83 c0 04             	add    $0x4,%eax
 7b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7b3:	85 d2                	test   %edx,%edx
 7b5:	0f 84 8d 00 00 00    	je     848 <printf+0x188>
        while(*s != 0){
 7bb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 7be:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 7c0:	84 c0                	test   %al,%al
 7c2:	0f 84 4a ff ff ff    	je     712 <printf+0x52>
 7c8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 7cb:	89 d3                	mov    %edx,%ebx
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 7d0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7d3:	83 c3 01             	add    $0x1,%ebx
 7d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7d9:	6a 01                	push   $0x1
 7db:	57                   	push   %edi
 7dc:	56                   	push   %esi
 7dd:	e8 31 fd ff ff       	call   513 <write>
        while(*s != 0){
 7e2:	0f b6 03             	movzbl (%ebx),%eax
 7e5:	83 c4 10             	add    $0x10,%esp
 7e8:	84 c0                	test   %al,%al
 7ea:	75 e4                	jne    7d0 <printf+0x110>
      state = 0;
 7ec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 7ef:	31 c9                	xor    %ecx,%ecx
 7f1:	e9 1c ff ff ff       	jmp    712 <printf+0x52>
 7f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7fd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 800:	83 ec 0c             	sub    $0xc,%esp
 803:	b9 0a 00 00 00       	mov    $0xa,%ecx
 808:	6a 01                	push   $0x1
 80a:	e9 7b ff ff ff       	jmp    78a <printf+0xca>
 80f:	90                   	nop
        putc(fd, *ap);
 810:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 813:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 816:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 818:	6a 01                	push   $0x1
 81a:	57                   	push   %edi
 81b:	56                   	push   %esi
        putc(fd, *ap);
 81c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 81f:	e8 ef fc ff ff       	call   513 <write>
        ap++;
 824:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 828:	83 c4 10             	add    $0x10,%esp
      state = 0;
 82b:	31 c9                	xor    %ecx,%ecx
 82d:	e9 e0 fe ff ff       	jmp    712 <printf+0x52>
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 838:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 83b:	83 ec 04             	sub    $0x4,%esp
 83e:	e9 2a ff ff ff       	jmp    76d <printf+0xad>
 843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 847:	90                   	nop
          s = "(null)";
 848:	ba 3f 0a 00 00       	mov    $0xa3f,%edx
        while(*s != 0){
 84d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 850:	b8 28 00 00 00       	mov    $0x28,%eax
 855:	89 d3                	mov    %edx,%ebx
 857:	e9 74 ff ff ff       	jmp    7d0 <printf+0x110>
 85c:	66 90                	xchg   %ax,%ax
 85e:	66 90                	xchg   %ax,%ax

00000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 861:	a1 bc 0d 00 00       	mov    0xdbc,%eax
{
 866:	89 e5                	mov    %esp,%ebp
 868:	57                   	push   %edi
 869:	56                   	push   %esi
 86a:	53                   	push   %ebx
 86b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 86e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 878:	89 c2                	mov    %eax,%edx
 87a:	8b 00                	mov    (%eax),%eax
 87c:	39 ca                	cmp    %ecx,%edx
 87e:	73 30                	jae    8b0 <free+0x50>
 880:	39 c1                	cmp    %eax,%ecx
 882:	72 04                	jb     888 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	39 c2                	cmp    %eax,%edx
 886:	72 f0                	jb     878 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 888:	8b 73 fc             	mov    -0x4(%ebx),%esi
 88b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 88e:	39 f8                	cmp    %edi,%eax
 890:	74 30                	je     8c2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 895:	8b 42 04             	mov    0x4(%edx),%eax
 898:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 89b:	39 f1                	cmp    %esi,%ecx
 89d:	74 3a                	je     8d9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 89f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8a1:	5b                   	pop    %ebx
  freep = p;
 8a2:	89 15 bc 0d 00 00    	mov    %edx,0xdbc
}
 8a8:	5e                   	pop    %esi
 8a9:	5f                   	pop    %edi
 8aa:	5d                   	pop    %ebp
 8ab:	c3                   	ret    
 8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	39 c2                	cmp    %eax,%edx
 8b2:	72 c4                	jb     878 <free+0x18>
 8b4:	39 c1                	cmp    %eax,%ecx
 8b6:	73 c0                	jae    878 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 8b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8be:	39 f8                	cmp    %edi,%eax
 8c0:	75 d0                	jne    892 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 8c2:	03 70 04             	add    0x4(%eax),%esi
 8c5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c8:	8b 02                	mov    (%edx),%eax
 8ca:	8b 00                	mov    (%eax),%eax
 8cc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 8cf:	8b 42 04             	mov    0x4(%edx),%eax
 8d2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8d5:	39 f1                	cmp    %esi,%ecx
 8d7:	75 c6                	jne    89f <free+0x3f>
    p->s.size += bp->s.size;
 8d9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 8dc:	89 15 bc 0d 00 00    	mov    %edx,0xdbc
    p->s.size += bp->s.size;
 8e2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 8e5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 8e8:	89 0a                	mov    %ecx,(%edx)
}
 8ea:	5b                   	pop    %ebx
 8eb:	5e                   	pop    %esi
 8ec:	5f                   	pop    %edi
 8ed:	5d                   	pop    %ebp
 8ee:	c3                   	ret    
 8ef:	90                   	nop

000008f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	57                   	push   %edi
 8f4:	56                   	push   %esi
 8f5:	53                   	push   %ebx
 8f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8fc:	8b 3d bc 0d 00 00    	mov    0xdbc,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 902:	8d 70 07             	lea    0x7(%eax),%esi
 905:	c1 ee 03             	shr    $0x3,%esi
 908:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 90b:	85 ff                	test   %edi,%edi
 90d:	0f 84 9d 00 00 00    	je     9b0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 913:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 915:	8b 4a 04             	mov    0x4(%edx),%ecx
 918:	39 f1                	cmp    %esi,%ecx
 91a:	73 6a                	jae    986 <malloc+0x96>
 91c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 921:	39 de                	cmp    %ebx,%esi
 923:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 926:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 92d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 930:	eb 17                	jmp    949 <malloc+0x59>
 932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 93a:	8b 48 04             	mov    0x4(%eax),%ecx
 93d:	39 f1                	cmp    %esi,%ecx
 93f:	73 4f                	jae    990 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 941:	8b 3d bc 0d 00 00    	mov    0xdbc,%edi
 947:	89 c2                	mov    %eax,%edx
 949:	39 d7                	cmp    %edx,%edi
 94b:	75 eb                	jne    938 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 94d:	83 ec 0c             	sub    $0xc,%esp
 950:	ff 75 e4             	push   -0x1c(%ebp)
 953:	e8 23 fc ff ff       	call   57b <sbrk>
  if(p == (char*)-1)
 958:	83 c4 10             	add    $0x10,%esp
 95b:	83 f8 ff             	cmp    $0xffffffff,%eax
 95e:	74 1c                	je     97c <malloc+0x8c>
  hp->s.size = nu;
 960:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 963:	83 ec 0c             	sub    $0xc,%esp
 966:	83 c0 08             	add    $0x8,%eax
 969:	50                   	push   %eax
 96a:	e8 f1 fe ff ff       	call   860 <free>
  return freep;
 96f:	8b 15 bc 0d 00 00    	mov    0xdbc,%edx
      if((p = morecore(nunits)) == 0)
 975:	83 c4 10             	add    $0x10,%esp
 978:	85 d2                	test   %edx,%edx
 97a:	75 bc                	jne    938 <malloc+0x48>
        return 0;
  }
}
 97c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 97f:	31 c0                	xor    %eax,%eax
}
 981:	5b                   	pop    %ebx
 982:	5e                   	pop    %esi
 983:	5f                   	pop    %edi
 984:	5d                   	pop    %ebp
 985:	c3                   	ret    
    if(p->s.size >= nunits){
 986:	89 d0                	mov    %edx,%eax
 988:	89 fa                	mov    %edi,%edx
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 990:	39 ce                	cmp    %ecx,%esi
 992:	74 4c                	je     9e0 <malloc+0xf0>
        p->s.size -= nunits;
 994:	29 f1                	sub    %esi,%ecx
 996:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 999:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 99c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 99f:	89 15 bc 0d 00 00    	mov    %edx,0xdbc
}
 9a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9a8:	83 c0 08             	add    $0x8,%eax
}
 9ab:	5b                   	pop    %ebx
 9ac:	5e                   	pop    %esi
 9ad:	5f                   	pop    %edi
 9ae:	5d                   	pop    %ebp
 9af:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 9b0:	c7 05 bc 0d 00 00 c0 	movl   $0xdc0,0xdbc
 9b7:	0d 00 00 
    base.s.size = 0;
 9ba:	bf c0 0d 00 00       	mov    $0xdc0,%edi
    base.s.ptr = freep = prevp = &base;
 9bf:	c7 05 c0 0d 00 00 c0 	movl   $0xdc0,0xdc0
 9c6:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 9cb:	c7 05 c4 0d 00 00 00 	movl   $0x0,0xdc4
 9d2:	00 00 00 
    if(p->s.size >= nunits){
 9d5:	e9 42 ff ff ff       	jmp    91c <malloc+0x2c>
 9da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9e0:	8b 08                	mov    (%eax),%ecx
 9e2:	89 0a                	mov    %ecx,(%edx)
 9e4:	eb b9                	jmp    99f <malloc+0xaf>

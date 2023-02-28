.data
     del: .asciz " "
     s: .space 101
	 v: .space 400
	 a: .space 400
	 b: .space 400
	 k: .long 0
	 ok: .long 0
	 indexa: .long 0
	 index: .long 0
	 x: .long 0
	 y: .long 0
	 rez: .long 0
	 strmul: .asciz "mul"
	 strdiv: .asciz "div"
	 strsub: .asciz "sub"
	 stradd: .asciz "add"
	 strlet: .asciz "let"
     formatPrintf: .asciz "%d\n"
     formatScanf: .asciz "%[^\n]s"
	 formatPrintf2: .asciz "%s\n"
	 p: .space 4
	 formatPrintf3: .asciz "v[%d]=%d\n"

.text

.global main

main:
    pushl $s
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx
    
    pushl $del
    pushl $s
    call strtok
    popl %ebx
    popl %ebx
 
while_start:   
	movl %eax, p
	cmp $0, p
	je while_exit
	
 //       pushl p
//	pushl $formatPrintf2
//	call printf
//	popl %ebx
//	popl %ebx
	xorl %eax, %eax
	xorl %ecx, %ecx
	movl p, %ebx
	movb (%ebx, %ecx, 1), %al
	pushl %eax
	call isdigit
	popl %ebx
	cmp $0, %eax
	je eticheta_else
	
// 	 int nr=atoi(p);
//	  v[index]=nr;
//	  index++;
	
    pushl p
    call atoi
    popl %ebx
    
   movl $v, %ecx
    movl index, %ebx
    movl %eax, (%ecx, %ebx, 4)
    movl index, %ecx
   incl %ecx
    movl %ecx, index
    jmp eticheta_exitif

	
	
	
eticheta_else:
    
	pushl $strmul 
	pushl p
	call strcmp 
	popl %ebx
	popl %ebx
	cmp $0, %ecx
	jne eticheta_else2
//	x=v[index-1];
 //     y=v[index-2];
  //    index=index-2;
  //    rez=x*y;
  //    v[index]=rez;
  //   index++;
  
  movl index, %eax
  decl %eax 
  movl $v, %ebx
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, x 
  
  decl %eax 
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, y
  
  movl %eax, index
  movl x, %eax
  movl y, %edx
  mul %edx
  movl %eax, rez 
  movl index, %eax
  movl rez, %ecx
  movl %ecx, (%ebx, %eax, 4)
  incl %eax
  movl %eax, index   
  jmp eticheta_exitif
	
eticheta_else2:
    
	pushl $strdiv 
	pushl p
	call strcmp 
	popl %ebx
	popl %ebx
	cmp $0, %ecx
	jne eticheta_else3

  movl index, %eax
  decl %eax 
  movl $v, %ebx
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, x 
  
  decl %eax 
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, y
  
  movl %eax, index
  movl y, %eax
  movl $0, %edx
  movl x, %esi
  div %esi

  movl %eax, rez 
  movl index, %eax
  movl rez, %ecx
  movl %ecx, (%ebx, %eax, 4)
  incl %eax
  movl %eax, index   
  jmp eticheta_exitif



eticheta_else3:
	pushl $strsub 
	pushl p
	call strcmp 
	popl %ebx
	popl %ebx
	cmp $0, %ecx
	jne eticheta_else4

  movl index, %eax
  decl %eax 
  movl $v, %ebx
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, x 
  
  decl %eax 
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, y
  
  movl %eax, index
  movl y, %eax
  movl x, %esi
  sub %esi, %eax

  movl %eax, rez 
  movl index, %eax
  movl rez, %ecx
  movl %ecx, (%ebx, %eax, 4)
  incl %eax
  movl %eax, index   
  jmp eticheta_exitif



eticheta_else4:	
	pushl $stradd 
	pushl p
	call strcmp 
	popl %ebx
	popl %ebx
	cmp $0, %ecx
	jne eticheta_else5

  movl index, %eax
  decl %eax 
  movl $v, %ebx
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, x 
  
  decl %eax 
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, y
  
  movl %eax, index
  movl y, %eax
  movl x, %esi
  add %esi, %eax

  movl %eax, rez 
  movl index, %eax
  movl rez, %ecx
  movl %ecx, (%ebx, %eax, 4)
  incl %eax
  movl %eax, index   
  jmp eticheta_exitif
	
	
	
eticheta_else5:
	pushl $strlet 
	pushl p
	call strcmp 
	popl %ebx
	popl %ebx
	cmp $0, %ecx
	jne eticheta_else6

  movl index, %eax
  decl %eax 
  movl $v, %ebx
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, x 
  
  decl %eax 
  movl (%ebx, %eax, 4), %ecx
  movl %ecx, y
  
  movl %eax, index
  
    //  a[indexa]=y;
    //  b[indexa]=x;
    //  indexa++;
	
  movl $a, %ebx 
  movl indexa, %eax
  movl y, %ecx
  movl %ecx, (%ebx, %eax, 4)
  
  movl $b, %ebx 
  movl x, %ecx
  movl %ecx, (%ebx, %eax, 4)
  incl %eax 
  movl %eax, indexa 
  
  
  
  jmp eticheta_exitif




eticheta_else6:

//       else // in caz ca e variabila
//        { int k=p[0]; int ok=0;
//        for (int i=0;i<indexa;i++)
//        {
//          if (a[i]==k)
//          {
//              v[index]=b[i];
//              ok=1;
//             index++;
//              break;
//          }

   
   movl $0, ok
   movl p, %ebx 
   xorl %ecx, %ecx 
   movb (%ebx, %ecx, 1), %al
   movl %eax, k
   
   
eticheta_for2:   
   cmp indexa, %ecx
   jae eticheta_exitfor2
   movl $a, %ebx
   movl (%ebx, %ecx, 4), %eax
   cmp %eax, k
   jne eticheta_cont2
   movl $b, %ebx
   movl (%ebx, %ecx, 4), %eax
   movl $v, %ebx 
   movl index, %edx
   movl %eax, (%ebx, %edx, 4)
   movl $1, ok
   incl %edx
   movl %edx, index
   jmp eticheta_exitfor2

   
   
eticheta_cont2:
   
   
   incl %ecx
   jmp eticheta_for2
   
   

eticheta_exitfor2:

//       if (ok==0)
//            {v[index]= k;
//            index++;}

   cmp $0, ok
   jne eticheta_exitif 
   movl $v, %ebx 
   movl index, %edx
   movl k, %eax
   movl %eax, (%ebx, %edx, 4)   
   incl %edx 
   movl %edx, index
	
	
eticheta_exitif:
	
	
    pushl $del
    pushl $0
    call strtok
    popl %ebx
    popl %ebx
    jmp while_start
	
while_exit:

// printf("%d", v[index-1]);
   movl index, %eax
   decl %eax 
   movl $v, %ebx
   movl (%ebx, %eax, 4), %ecx
   
   pushl %ecx
   pushl $formatPrintf
   call printf
   popl %ebx
   popl %ecx
	
	

    pushl $0
    call fflush
    popl %ebx
    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

;---------------------------------------------------------
;Author:        Kien Truong
;Program name:  Assignment 6
;Course ID:     CPSC 240
;---------------------------------------------------------

extern printf

extern scanf

global harmonic_sum

segment .data

initialMess db "This program is running an Intel Celeron at 1.10GHz.",10,0

promptMess  db "Please enter the number of terms to be included in the harmonic"
            db " sum: ",0

clockMess1  db "The clock is now %ld tics and the computation will begin immediately.",10,10,0

clockMess2  db "The clock is now %ld and the computation is complete.",10,0

termMess    db "With %ld terms the sum is %6.10lf",10,0

;termSumMess db "the sum is %6.10lf",10,0

sumMess     db "The final sum is %6.10lf",10,10,0

elapsedMess db "The elapsed time was %ld tics. At 1.10GHz that is %5.8lf seconds.",10,10,0

testThis        db "Ten is %ld and eleven is %ld.", 10, 0

stringFormat db "%s",0

intFormat    db "%ld", 0

floatFormat  db "%lf %lf",0

segment .bss
;empty

segment .text
harmonic_sum:

  push rbp
  mov rbp, rsp
  push rbx
  push rcx
  push rdx
  push rdi
  push rsi
  push r8
  push r9
  push r10
  push r11
  push r12
  push r13
  push r14
  push r15

  ;====Show the initial message====
  mov qword rax, 0              ;No floating points
  mov       rdi, stringFormat   ;"%s"
  mov       rsi, initialMess    ;"This program is running an Intel Celeron at 1.10GHz."
  call      printf              ;output

  ;====Show the prompt message====
  mov qword rax, 0              ;No floating points
  mov       rdi, stringFormat   ;"%s"
  mov       rsi, promptMess     ;"Please enter the number of terms to be included in the harmonic sum: "
  call      printf              ;output

  ;===Getting input of the number of terms===
  push qword 0                  ;Reserves 8 bytes of memory
  mov qword rax, 0              ;No floating points
  mov       rdi, intFormat      ;"%ld"
  mov       rsi, rsp            ;points to top of the stack
  call      scanf               ;input
  pop       r15                 ;stores inputted number in r15 -- number of times to run the loop

  ;===Early time clock tics===
  cpuid
  rdtsc

  shl rdx, 32                   ;Shifting 8 Hex in lower half to upper half of rdx
  or  rdx, rax                  ;rdx = rdx or rax - putting lower half of rax to lower half of rdx
  mov r13, rdx                  ;Copying clock tics from rdx to r13

  ;===Output clock message===
  mov qword rax, 0              ;no floating points
  mov       rdi, clockMess1     ;"The clock is now %ld tics and the computation will begin immediately."
  mov       rsi, r13            ;for outputting
  call      printf              ;output

  cvtsi2sd xmm11, r13           ;backing up clock tics because of running out of regular register
                                ;Then it will convert back to long int at the end

  mov      r14, 1                     ;counter to output the sum during the loop
  mov      r12, 1                     ;counter to exit the loop

  mov    rbp, 0x3FF0000000000000     ;moves 1.0 to rbp
  push   rbp                         ;pushes rbp onto the stack
  movsd  xmm10, [rsp]                ;for incrementing
  movsd  xmm12, [rsp]                ;backup for 1.0
  movsd  xmm13, [rsp]                ;for divsd
  pop    rbp                         ;reserves for rbp

  mov    rbp, 0x0000000000000000     ;moves 0.0 to rbp
  push   rbp                         ;pushes rbp onto the stack
  movsd  xmm15,  [rsp]               ;sum
  pop    rbp                         ;reserves for rbp

  mov rax, r15                       ;number of terms tin harmonic sum
  mov r13, 10                        ;10 lines of sum output
  cqo
  idiv r13                           ;rax = rax / r13
  mov  r13, rax                      ;stores the number of terms to be outputted in r13

  loop_again:
  cmp r12, r15                       ;r15: number of terms -- r12: counter
  jle lessequal

  jmp otherstuff

  ;===This will execute when r10 >= r15===
  lessequal:

  divsd xmm13, xmm10            ;doing the division and put the result in xmm13
  addsd xmm15, xmm13            ;sum
  addsd xmm10, xmm12            ;incrementing by 1.0
  movsd xmm13, xmm12            ;xmm13 always has to be 1.0 to do the division

  cmp r14, r13
  je equal

  jmp next

  equal:
  push  qword -99               ;reserve space
  mov   qword rax, 1            ;1 float number to be outputted
  mov   rdi, termMess           ;"With %ld terms the sum is %6.10lf"
  mov   rsi, r12                ;counter
  movsd xmm0,xmm15              ;sum
  call  printf                  ;output
  pop   rax                     ;pop qword -99

  mov r14, 0                    ;resetting r14 for another output

  next:
  inc r14                 ;incrementing counter for terms output
  inc r12                 ;incrementing counter for outer loop

  jmp loop_again


  otherstuff:
  ;===Output sum message===
  push  qword -99
  mov   rax, 1                  ;1 float needs to be outputted
  mov   rdi, sumMess            ;"The final sum is %6.10lf"
  movsd xmm0, xmm15             ;sum
  call  printf                  ;output
  pop   rax

  ;===Late time clock tics===
  cpuid
  rdtsc

  shl rdx, 32                   ;Shifting 8 Hex in lower half to upper half of rdx
  or  rdx, rax                  ;rdx = rdx or rax - putting lower half of rax to lower half of rdx
  mov r14, rdx                  ;Copying clock tics from rdx to r13

  ;===Output clock message===
  mov qword rax, 0              ;no floating points
  mov       rdi, clockMess2     ;"The clock is now %ld tics and the computation will begin immediately."
  mov       rsi, r14            ;for outputting
  call      printf              ;output

  cvtsd2si r13, xmm11           ;converting the beginning tics we stored at the beginning of program to long int for calc.

  ;===Difference in run-time===
  sub r14, r13                  ;Elapsed time in tics (r14 -= 13)

  ;===Converting long integer to float number===
  cvtsi2sd xmm10, r14           ;converting long int to double

  mov r10, 1100000000           ;1.10GHz to Hz
  cvtsi2sd xmm11, r10           ;converting long int to double

  ;===Finding elapsed time in seconds===
  divsd  xmm10, xmm11

  ;===Output elapsed time===
  push  qword -99           ;Reserve 8 bytes of memory
  mov   rax, 1              ;1 float to be outputted
  mov   rdi, elapsedMess    ;"The elapsed time was %ld tics. At 1.10GHz that is %5.8lf seconds."
  mov   rsi, r14            ;Difference in run-time
  movsd xmm0, xmm10         ;Elapsed time in seconds
  call  printf              ;output
  pop   rax                 ;Pop qword -99

  movsd xmm0, xmm15         ;returning harmonic sum result to main


  pop r15
  pop r14
  pop r13
  pop r12
  pop r11
  pop r10
  pop r9
  pop r8
  pop rsi
  pop rdi
  pop rdx
  pop rcx
  pop rbx
  pop rbp

  ret

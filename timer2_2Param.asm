TIMER:  ;this function has 1 parameter
TIMER_OFFSET=$3000
mov r3,BASE
orr r3,TIMER_OFFSET
mov r4,r1  ;$80000 passed as a parameter
ldrd r6,r7,[r3,#4] 
mov r5,r6 
loopt1:  ;label still has to be different from one in _start
  ldrd r6,r7,[r3,#4] 
  sub r8,r6,r5  
  cmp  r8,r4  
  bls loopt1 
bx lr  ;return


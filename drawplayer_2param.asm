DrawPlayer:
; 3 PARAMS
; Screen address, x, y
     mov r4,r1
     mov r5,r1
     add r5,#5
     mov r6,r2
     mov r3,#1
     add r6,#40
     rectangleloop:
        mov r1,r4
        lineloop:
              push {lr}
              push {r0-r9}
              bl drawpixel
              pop {r0-r9}
              pop {lr}
              add r1,#1
              cmp r1,r5
        blo lineloop
        add r2,#1
        cmp r2,r6
     blo rectangleloop
bx lr
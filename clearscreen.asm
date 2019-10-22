ClearScreen:
        mov r2,#1
        mov r3,#0
        yloop:
                mov r1,#1
                xloop:
                        push {r0-r9,lr}
                        bl drawpixel
                        pop {r0-r9,lr}
                        add r1,#1
                        cmp r1,SCREEN_X
                bls xloop
                add r2,#1
                cmp r2,SCREEN_Y
        bls yloop
bx lr
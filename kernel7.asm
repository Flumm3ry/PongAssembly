; Raspberry Pi B+,2 'Bare Metal' 16BPP Draw Pixel at any XY:
; 1. Setup Frame Buffer
;    assemble struct with screen requirements
;    receive pointer to screen or NULL
; 2. Start loop
;    Send pixel colour to location on screen
;    increment counter and loop if < 640

;note: r6 (colour) is 32-bit/4 byte register.
;at 16 bits/pixel, writing 32bits to adjacent pixels overwrites every second pixel.
; soln: write lower 2 bytes only (STRH) or lower byte(STRB).
;r0 = pointer + x * BITS_PER_PIXEL/8 + y * SCREEN_X * BITS_PER_PIXEL/8
format binary as 'img'
;constants


;memory addresses of BASE
BASE = $3F000000 ; 2
;BASE = $20000000 ; B+

org $0000
mov sp,$1000

; Return CPU ID (0..3) Of The CPU Executed On
;mrc p15,0,r0,c0,c0,5 ; R0 = Multiprocessor Affinity Register (MPIDR)
;ands r0,3 ; R0 = CPU ID (Bits 0..1)
;bne CoreLoop ; IF (CPU ID != 0) Branch To Infinite Loop (Core ID 1..3)

mov r0,BASE
bl FB_Init
;r0 now contains address of screen
;SCREEN_X and BITS_PER_PIXEL are global constants populated by FB_Init

and r0,$3FFFFFFF ; Convert Mail Box Frame Buffer Pointer From BUS Address To Physical Address ($CXXXXXXX -> $3XXXXXXX)
str r0,[FB_POINTER] ; Store Frame Buffer Pointer Physical Address

mov r7,r0 ;back-up a copy of the screen address + channel number


; Draw Pixel at (X,Y)
;r0 = address of screen we write to (r7 = backup of screen start address)

mov r4, #5 ;x ordinate
mov r5, #5 ;y

;set colour - while for 8BPP, Yellow for 16BPP
mov r9,BITS_PER_PIXEL
cmp r9,#8; if BITS_PER_PIXEL == 8
beq sp_eight
;assume 16
mov r6,$FF00
orr r6,$000E  ; yellow
b sp_endif
sp_eight:
        mov r6,#1   ;white for 8-bit colour
sp_endif:

MainLoop:
                push {r0-r3}
                mov r0,r7
                mov r3,r6
                bl ClearScreen
                pop {r0-r3}


                push {r0-r9}
                mov r0,r7    ;screen address
                mov r1,r4 ;x
                mov r2,r5 ;y
                mov r3,r6 ;colour
                ;assume BITS_PER_PIXEL, SCREEN_X are shared constants
                bl DrawPlayer
                pop {r0-r9}

                add r5,#10

                push {r0-r9}
                mov r1, $FF000
                bl TIMER
                pop {r0-r9}

b MainLoop  ;loop forever

CoreLoop: ; Infinite Loop For Core 1..3
  b CoreLoop

include "clearscreen.asm"
include "drawplayer_2param.asm"
include "FBinit8.asm"
include "timer2_2Param.asm"
include "drawpixel.asm"



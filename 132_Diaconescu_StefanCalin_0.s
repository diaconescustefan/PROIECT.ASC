.data
    o: .space 4
    n: .space 4
    nr: .space 4
    op: .space 4
    v: .space 1024
    i: .long 4
    j: .space 4
    a: .space 4
    b: .space 4
    c: .space 4
    p: .space 4
    q: .space 4
    gasit: .space 4
    desc: .long 4
    dim: .space 4
    cnt0: .space 4
    index0: .space 4
    citire: .asciz "%d"
    afisare1: .asciz "%d\n"
    afisare: .asciz "%ld: (%ld, %ld)\n"
    afisareGET: .asciz "(%ld, %ld)\n"
    afisareEROARE: .asciz "Operatie invalida!\n"
    locuri_libere: .long 3
    num_locuri: .space 4
    stanga: .space 4
    dreapta: .space 4
    ok: .space 4

.text


ADD:
    pushl %ebp
    movl %esp, %ebp
    mov $0, %eax
    mov %eax, ok

    pushl $desc
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

    pushl $dim
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

    mov dim, %eax
    mov $8, %ebx
    xor %edx, %edx
    divl %ebx
    movl %eax, num_locuri


    mov $0, %ecx
    cmp %ecx, %edx
        jne incrementare

    continue:
        mov $0, %edx

   #for verificare
   movl $0, i
   movl $0, locuri_libere
   lea v, %edi
fors:
    cmp $1024, i           # Verificăm să nu depășim limitele vectorului
    jge forfinal

    movl i, %ebx           # Indexul curent
    mov (%edi, %ebx, 1), %dl  # Valoarea curentă din vector
    cmpb $0, %dl
    jne reset_loc          # Dacă nu e liber, resetăm locurile
    
    addl $1, locuri_libere
    movl num_locuri, %eax
    movl locuri_libere, %ebx
    cmp %eax, %ebx         # Comparăm locuri_libere cu num_locuri
    je gasirepoz        # Dacă sunt egale, găsim poziția
    movl locuri_libere, %eax
    movl %eax, locuri_libere
     

    incl i 
    jmp fors

gasirepoz:
    mov $1, %eax
    mov %eax, ok
    movl i, %eax
    movl locuri_libere, %ebx
    subl %ebx, %eax
    addl $1, %eax
    movl %eax, stanga      /*Salvăm indexul de start*/
    movl i, %ebx
    movl %ebx, dreapta     /* Salvăm indexul de dreapta*/
    /*for schimbare elemente vector*/
        mov stanga, %ecx
        mov dreapta, %ebx
        forschimbare:
            cmp %ebx, %ecx
                ja forschiF

            mov desc, %al
            mov %al, (%edi, %ecx, 1)
            incl %ecx
            jmp forschimbare

            forschiF:
                mov $1024, %ecx

    pushl dreapta
    pushl stanga
    pushl desc
    pushl $afisare
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx


    incl i
    jmp forfinal
   
reset_loc:
    movl $0, locuri_libere
    incl i
    jmp fors

increment_i:
    incl i
    jmp fors
    
incrementare:
    addl $1, num_locuri 
    mov $9,%edx
    jmp continue

forfinal:
    mov ok, %eax
    cmp $0, %eax
        je afisarecaz
    jmp end
    afisarecaz:
        mov $0, %eax
        mov %eax, stanga
        mov %eax, dreapta
        pushl dreapta
        pushl stanga
        pushl desc
        pushl $afisare
        call printf
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx
        jmp end

    end:
    popl %ebp
    ret



GET:
    pushl %ebp
    movl %esp, %ebp

    pushl $desc
    pushl $citire
    call scanf
    popl %eax
    popl %eax

    movl $0, %eax
    movl %eax, gasit


    movl $0, stanga
    movl $0, dreapta
    movl $0, i
    lea v, %edi
    forcaut:
        mov $1024, %eax
        mov i, %ebx
        cmp %eax, %ebx
        je forcautfin
        mov (%edi, %ebx, 1), %al
        mov %al, c
        mov c, %ecx
        mov desc, %edx
        cmp %ecx, %edx
        je incepereainter

        incl i
        jmp forcaut

        incepereainter:
            mov gasit, %eax
            mov $0, %ecx
            cmp %eax, %ecx
                je incepeintv
            mov i, %ecx
            mov %ecx, dreapta
            incl i
            jmp forcaut

            incepeintv:
                mov $1, %eax
                mov %eax, gasit 
                mov i, %ecx
                mov %ecx, stanga
                incl i
                jmp forcaut
    
    forcautfin:
        mov gasit, %eax
        mov $0, %ebx
        cmp %eax, %ebx
            je fisierneg
            jne fisiergas

        fisierneg:
            mov $0, %ecx
            mov %ecx, stanga
            mov %ecx, dreapta

            push dreapta
            push stanga
            push $afisareGET
            call printf
            popl %ecx 
            popl %ecx
            popl %ecx

            jmp final

        fisiergas:
            
            push dreapta
            push stanga
            pushl $afisareGET
            call printf
            popl %eax
            popl %eax
            popl %eax

            jmp final


    final:
        popl %ebp
        ret

DELETE:
    pushl %ebp
    movl %esp, %ebp

    pushl $desc
    pushl $citire
    call scanf
    popl %eax
    popl %eax

    mov $1024, %ebx
    mov $0, %eax
    mov %eax, i
    lea v, %edi


    foreliberare:
        mov i, %eax
        mov $1024, %ebx
        cmp %eax, %ebx
            je foreliberarefin
        mov $0, %ebx
        mov (%edi, %eax, 1), %bl
        mov desc, %edx
        cmp %ebx, %edx
            je eliberare

        incl i
        jmp foreliberare

        eliberare:
            mov $0, %ebx
            mov %bl, (%edi, %eax, 1)
            incl i
            jmp foreliberare

        foreliberarefin:
            mov $1024, %eax
            mov %eax, i
            jmp etafisare
    etafisare:
    mov $0, %eax
    mov %eax, i 
    lea v, %edi
    mov $0, %eax
    mov %eax, ok
    forafis:
        mov i, %eax
        mov $1024, %ebx
            cmp %eax, %ebx
                je forafisfin
        mov $0, %ebx
        mov (%edi, %eax, 1), %bl

        mov i, %eax
        cmp $0, %ebx
            jne poz
        incl i
        jmp forafis
        poz:
            mov i, %ecx
            mov %ecx, stanga


            fordreapta:
                mov %ecx, j
                cmp $1024, %ecx
                    je fordreaptafin
                mov $0, %eax
                mov (%edi, %ecx, 1), %al
                mov stanga, %ebx
                mov $0, %ecx
                mov (%edi, %ebx, 1), %cl
                mov %cl, c
                cmp %al, %cl
                    jne fordreapta1
                mov j, %ecx
                cmp $1023, %ecx
                    je fordreapta12
                incl %ecx
                jmp fordreapta

                fordreapta12:
                    mov $1, %eax
                    mov %eax, ok
                    mov $0, %eax
                    mov (%edi, %ecx, 1), %al
                    mov %eax, b
                    incl %ecx
                    cmp $0, %eax
                        je forafis
                    
                    decl %ecx
                    push %ecx
                    push stanga
                    push b
                    push $afisare
                    call printf
                    popl %eax
                    popl %eax
                    popl %eax
                    popl %eax

                    jmp cont


                fordreapta1:
                    mov j, %ecx
                    mov %ecx, ok
                    decl %ecx
                    movl %ecx, dreapta
                    movl %ecx, i
                    incl i

                    mov $1025, %ecx
                    pushl dreapta
                    pushl stanga
                    push c
                    pushl $afisare
                    call printf
                    popl %ebx
                    popl %ebx 
                    popl %ebx
                    popl %ebx
                    jmp forafis

                foradaugafin:
                    movl $1025, %ecx
                    jmp forafis

                fordreaptafin:
                    jmp forafisfin

    forafisfin:
        mov ok, %eax
        cmp $0, %eax
            je afisintv

        jmp cont 
        afisintv:
        mov $0, %eax
        mov $0, %ebx
        mov (%edi, %eax, 1), %bl
        mov %ebx, b 
        cmp $0, %ebx
            je cont
        mov $1023, %eax
        mov $0, %ebx
        mov (%edi, %eax, 1), %bl
        mov b, %eax
        cmp %eax, %ebx
            je intervalcomplet
        jmp cont

        intervalcomplet:
            mov $0, %eax
            mov $0, %ebx
            mov (%edi, %eax, 1) , %bl
            mov $1023, %ecx
            mov %ebx, c 
            mov %ecx, dreapta
            mov %eax, stanga
            push dreapta
            push stanga
            push c
            pushl $afisare
            call printf
            popl %eax
            popl %eax
            popl %eax
            popl %eax

            jmp cont

        cont:
        popl %ebp
        ret

    DEFRAG:
        push %ebp
        movl %esp, %ebp
        movl $0, %eax
        movl %eax, p
        movl %eax, q

        lea v, %edi
        formod:
            mov q, %eax
            mov $1024, %ebx
            cmp %eax, %ebx
                je afisarepas4
            
            mov $0, %ebx
            mov (%edi, %eax, 1), %bl
            cmp $0, %ebx
                jne interschimbare

            incl q
            jmp formod

            interschimbare:
                mov $0, %ebx
                mov (%edi, %eax, 1), %bl
                mov %ebx, c

                mov $0, %ebx
                mov %bl, (%edi, %eax, 1)
                mov p, %ecx
                mov c, %al
                mov %al, (%edi, %ecx, 1)
                incl p
                incl q
                jmp formod
    
    
    afisarepas4:
    mov $0, %eax
    mov %eax, i 
    lea v, %edi
    forafisdef:
        mov i, %eax
        mov $1024, %ebx
            cmp %eax, %ebx
                je forafisfindef
        mov $0, %ebx
        mov (%edi, %eax, 1), %bl

        mov i, %eax
        cmp $0, %ebx
            jne poz1
        incl i
        jmp forafisdef
        poz1:
            mov i, %ecx
            mov %ecx, stanga


            fordreaptadef:
                mov %ecx, j
                cmp $1024, %ecx
                    je fordreaptafindef
                mov $0, %eax
                mov (%edi, %ecx, 1), %al
                mov stanga, %ebx
                mov $0, %ecx
                mov (%edi, %ebx, 1), %cl
                mov %cl, c
                cmp %al, %cl
                    jne fordreapta1def
                mov j, %ecx
                cmp $1023, %ecx
                    je fordreapta12def 
                
                incl %ecx
                jmp fordreaptadef

                fordreapta12def:
                    mov $1, %eax
                    mov %eax, ok
                    mov $0, %eax
                    mov (%edi, %ecx, 1), %al
                    mov %eax, b
                    incl %ecx
                    cmp $0, %eax
                        je forafisdef
                    
                    decl %ecx
                    push %ecx
                    push stanga
                    push b
                    push $afisare
                    call printf
                    popl %eax
                    popl %eax
                    popl %eax
                    popl %eax

                    jmp forafisfindef



                fordreapta1def:
                    mov j, %ecx
                    mov %ecx, ok
                    decl %ecx
                    movl %ecx, dreapta
                    movl %ecx, i
                    incl i

                    mov $1025, %ecx
                    pushl dreapta
                    pushl stanga
                    push c
                    pushl $afisare
                    call printf
                    popl %ebx
                    popl %ebx 
                    popl %ebx
                    popl %ebx
                    jmp forafisdef

                foradaugafindef:
                    movl $1025, %ecx
                    jmp forafisdef

                fordreaptafindef:
                    jmp forafisfindef

    forafisfindef:
        mov ok, %eax
        cmp $0, %eax
            je afisintvdef

        jmp contdef 
        afisintvdef:
        mov $0, %eax
        mov $0, %ebx
        mov (%edi, %eax, 1), %bl
        mov %ebx, b 
        cmp $0, %ebx
            je contdef
        mov $1023, %eax
        mov $0, %ebx
        mov (%edi, %eax, 1), %bl
        mov b, %eax
        cmp %eax, %ebx
            je intervalcompletdef
        jmp contdef

        intervalcompletdef:
            mov $0, %eax
            mov $0, %ebx
            mov (%edi, %eax, 1) , %bl
            mov $1023, %ecx
            mov %ebx, c 
            mov %ecx, dreapta
            mov %eax, stanga
            push dreapta
            push stanga
            push c
            pushl $afisare
            call printf
            popl %eax
            popl %eax
            popl %eax
            popl %eax

            jmp contdef

        contdef:
        popl %ebp
        ret


                
.global main
main:
    pushl $n
    pushl $citire
    call scanf
    popl %ebx
    popl %ebx

    mov $0, %eax
    mov %eax, a
    forop:
         movl a, %ecx
         movl n, %ebx
         cmp %ecx, %ebx
         je forend

         pushl $op
         pushl $citire
         call scanf
         popl %ecx
         popl %ecx

         mov op, %eax
         mov $1, %ecx
         cmp %eax, %ecx
            je adauga

         mov op, %eax
         mov $2, %ecx
         cmp %eax, %ecx
            je get

         mov op, %eax
         mov $3, %ecx
         cmp %eax, %ecx
            je delete

         mov op, %eax
         mov $4, %ecx
         cmp %eax, %ecx
            je def

        adauga:

            pushl $nr
            pushl $citire
            call scanf
            popl %ebx
            popl %ebx
            
            movl $0, %ebx
            mov %ebx, j
            foradauga:
                mov nr, %eax
                mov j, %ebx
                cmp %eax, %ebx
                    je foradaugafin1

                pushl cnt0
                call ADD
                popl %ecx

                movl j, %edx
                incl %edx
                movl %edx, j
                jmp foradauga

            foradaugafin1:
                mov $265, %eax
                mov %eax, j
                incl a
                jmp forop


    get:
         
        pushl cnt0
        call GET
        popl %eax

        incl a
        jmp forop


        movl a, %edx
        incl %edx
        movl %edx, a



        jmp forop

    delete:
        pushl cnt0
        call DELETE
        popl %eax

        incl a
        jmp forop
    
    def:
        pushl cnt0
        call DEFRAG
        popl %eax

        incl a 
        jmp forop
    
    forend:

        movl $265, %eax
        movl %eax, a
        jmp etexit





etexit:
    pushl $0
    call fflush
    popl %ebx
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80


.section .note.GNU-stack,"",@progbits

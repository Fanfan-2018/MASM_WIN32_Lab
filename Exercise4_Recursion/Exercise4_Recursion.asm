;�ݹ���׳� ���ִ洢������˷���ͬ������BCD�����ʽ�洢���ⲿ����

INCLUDE Irvine32.inc

.data
Buffer DD 40 DUP(0)


.code
main PROC
	MOV esi, OFFSET Buffer
	ADD esi, 39 * TYPE Buffer
	MOV edi, [esi]
	MOV edi, 1						
	MOV [esi], edi			;�Դ洢�����ʼ��, 
	CALL ReadInt			;��������
	CALL Recursion			;���õݹ麯��			
	MOV esi, OFFSET Buffer	;���������ʼλ��
	MOV ecx, 40				;ѭ��40��
PRINT:
	MOV eax, [esi]
	CMP eax, 00H
	JZ SKIP					;��0��ת
PRINT_NUM:
	MOV eax, [esi]			;����0�����ӡѭ��
	ADD esi, TYPE Buffer	;i++
	CALL WriteDec
	LOOP PRINT_NUM
	INVOKE ExitProcess, 0	;ע����������˳�������Ϊ������˳��Ļ��ͻ����ecx=0��ִ�е������Լ�1����ecx=fffffffe
SKIP:
	ADD esi, TYPE Buffer	;i++
	LOOP PRINT
	INVOKE ExitProcess, 0
	main ENDP

Recursion PROC
	PUSH eax				;eax��ջ
	SUB eax, 1				;eax-1
	CMP eax, 0				
	JZ END_RECURE			;��eax = 0,����ջ��ʼ��ջ����
	CALL Recursion 
END_RECURE:
	POP eax					;eax��ջ
	MOV ecx, 40  
	MOV esi, OFFSET Buffer
	ADD esi, 39 * TYPE Buffer
MULTI:						;ÿ������ѭ��ʹ��eax*�洢����
	PUSH ecx				;MULTI: ÿһλ�ֱ��eax
	PUSH eax
	MOV ecx, [esi]
	MUL ecx
	MOV [esi], eax
	SUB esi, TYPE Buffer
	POP eax
	POP ecx
	LOOP MULTI
	MOV ecx, 39  
	MOV esi, OFFSET Buffer
	ADD esi, 39 * TYPE Buffer
DIVSION:					;ÿһλmod10ȡ�࣬�������λ
	MOV eax, [esi]
	MOV edx, 0
	MOV ebx, 0AH
	DIV ebx
	MOV [esi], edx
	SUB esi, TYPE Buffer
	ADD [esi], eax
	LOOP DIVSION
	RET
	Recursion ENDP

END main

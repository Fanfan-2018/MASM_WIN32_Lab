;���ļ���ȡ[-1024,1024]������100�����֣�����֮�������Console
INCLUDE Irvine32.inc

READ_SIZE = 500
NUM_SIZE = 100

.data 
ReadFileBuffer BYTE READ_SIZE DUP(?)
Filename  BYTE "D:\GithubLocalRepo\Asm_MASM_Lab\Exercise3_Sort\Debug\Input3.txt",0
ReadBytes DD ? 
FileHandle  DD ?
ErrorMsg BYTE "error",0
ConsoleOutHandle DD ?
BytesWritten DD ?
DataBuffer DD NUM_SIZE DUP(?)
SortTotal DD ?
Space DB " ",0


.code
main PROC
	PUSH eax	
	INVOKE CreateFile,
		ADDR filename, GENERIC_READ, 
		DO_NOT_SHARE, NULL, 
		OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0	;����createfile�����Զ�ģʽ���ļ�
	MOV FileHandle, eax							;�����ļ����
	cmp eax, INVALID_HANDLE_VALUE				;�Ƚ��ļ�����Ƿ�Ϸ�
	JZ FILE_ERROR								;�����Ϸ�����ת����
	INVOKE ReadFile,							;�Ϸ����ļ�
		fileHandle, OFFSET ReadFileBuffer, READ_SIZE,
		ADDR ReadBytes, 0
	MOV ecx, ReadBytes							;ecx�����ֽ���
	MOV esi, OFFSET ReadFileBuffer				;esi�����׵�ַ
	JMP NO_ERROR

FILE_ERROR:
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE 
    MOV ConsoleOutHandle, eax 
    PUSHAD  
    INVOKE WriteConsole, ConsoleOutHandle,		;��ӡ������Ϣ
			Offset ErrorMsg, SIZEOF ErrorMsg, 
			offset BytesWritten, 0
	POPAD
	POP edx
	INVOKE ExitProcess, 0

;���ļ�û�д���׼���������ֵ�����
NO_ERROR:
	MOV ebx, 0									;��ʼ������0
	MOV edx, 0									;Ĭ������
	MOV edi, OFFSET SortTotal
	MOV [edi], ebx								;���ּ�������
	MOV edi, OFFSET DataBuffer					;����λ��
	
;�ַ�ת���ֽ�������
LOAD_NUM:										;ѭ������
	CMP BYTE PTR [esi], 20H
	JNE Judge_Minus								;������ǿո�,ȥ�жϷ���
	CALL Load_To_Buffer							;����print��buffer
	JMP END_LOAD
Judge_Minus:
	CMP BYTE PTR [esi], 2DH
	JNE Judge_Plus								;������Ǹ���, ȥ�ж�����
	MOV edx, 1									;���򽫱�־λ�޸�Ϊ��
	JMP END_LOAD
Judge_Plus:
	CMP BYTE PTR [esi], 2BH						
	JNE CAL										;����������ŵ������ּ���
	JMP END_LOAD
CAL:
	CALL Calculate
END_LOAD:
	INC esi
	LOOP LOAD_NUM
	CALL Load_To_Buffer

;BubbleSort
	MOV ecx, OFFSET SortTotal
	MOV ecx, [ecx]
	SUB ecx, 1
	MOV esi, OFFSET DataBuffer
OUTLOOP:										;���ѭ����¼������11��������10�ˣ�ǰ���Ѿ�����1��
	PUSH ecx									;�������ѭ������
	PUSH esi
INLOOP:											;��������L>=R, �ͽ���
	MOV edi, [esi + 4]
	CMP [esi], edi
	JS SKIP										;ע������Ӧ��ʹ��JS(SF)����Ϊ��ʹ��JBΪCF��־λ��CF����޷���
	CALL Swap
SKIP:
	ADD esi, TYPE DataBuffer
	LOOP INLOOP
	POP esi										;�ָ���λ��
	POP ecx										;�ָ���ѭ����
	LOOP OUTLOOP

;print
	MOV esi, OFFSET DataBuffer
	MOV ecx, OFFSET SortTotal
	MOV ecx, [ecx]
PRINT:
	MOV eax, [esi]
	ADD eax, 0
	JNS PRINT_PLUS								;�����������ֱ�Ӵ�ӡ����
	PUSH eax									;�Ǹ����ȴ�ӡ"-", �ٽ�eaxȡ���õ�����
	MOV al, 2DH
	CALL WriteChar
	POP eax
	NEG eax
PRINT_PLUS:
	CALL WriteDec
	ADD esi, TYPE DataBuffer					;�����±���1
	MOV al, 20H									;��ӡ�ո�
	CALL WriteChar
	LOOP PRINT
	INVOKE ExitProcess,0
main ENDP

;��ebx�����ݴ���buffer�����Ǳ�־λ(����)
Load_To_Buffer proc								
	CMP edx, 0
	JE Load										;�������������ֱ��LOAD
	NEG ebx										;����ȡ��
Load:
	MOV [edi], ebx								;ebx������������ 
	ADD edi, TYPE DataBuffer
	MOV ebx, OFFSET SortTotal
	MOV edx, 1 									
	ADD [ebx], edx								;���ּ���++
	MOV ebx, 0									;������ʼ������0
	MOV edx, 0									;Ĭ������ 
	RET
Load_To_Buffer ENDP

;ebx <- ebx*10 + [esi]
Calculate proc
	PUSH edx									;edx�洢���Ƿ���λ���������ջ�ᱻ�˻���λ���ǣ�����
	MUL ebx
	MOV ebx, eax
	MOVZX eax, BYTE PTR [esi] 
	ADD ebx, eax
	SUB ebx, 30H
	MOV eax, 10
	POP edx
	RET
Calculate ENDP

;swap [esi], [esi + 4]
Swap proc
	MOV eax, [esi]
	MOV ebx, [esi + 4]
	MOV [esi], ebx
	MOV [esi + 4], eax
	RET
SWAP ENDP
END main

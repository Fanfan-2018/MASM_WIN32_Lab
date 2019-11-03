; Read From the Console         (ReadConsole.asm)

; Read a line of input from standard input.

INCLUDE Irvine32.inc

BUFFER_SIZE = 300

.data
ReadBuffer DB 3 DUP(?)
Buffer DB BUFFER_SIZE DUP(?)
stdInHandle DD ?
bytesRead  DD ?
ConsoleOutHandle DD ?
BytesWritten DD ?
Table DB " ",0

.code
main PROC
	INVOKE GetStdHandle, STD_INPUT_HANDLE
	MOV	stdInHandle,eax
	INVOKE ReadConsole, stdInHandle, ADDR ReadBuffer,
			01H, ADDR bytesRead, 0
	MOV	ecx, OFFSET ReadBuffer						;ȡ�������ecx
	MOVZX ecx, BYTE PTR [ecx]						;һ��Ҫע�����ֻ��MOVZX���ܱ�֤����
	SUB ecx, 30H									;���ѭ������
	MOV eax, ecx									
	MUL ecx											
	MOV ecx, eax									;ȡƽ��
	MOV esi, OFFSET Buffer							;ƫ�Ƶ�ַ
	MOV ebx, 01H									;����
STORE:												;ѭ������n^2��buffer
	MOV [esi], ebx
	ADD esi, TYPE Buffer
	INC ebx
	LOOP STORE

	MOV	ecx, OFFSET ReadBuffer						;ȡ�������ecx
	MOVZX ecx, BYTE PTR [ecx]
	SUB ecx, 30H
	MOV ebx, ecx									;ʹ��bx�ݴ�cx������֮��ֵ
	MOV esi, OFFSET Buffer							;esi��buffer�ĵ�ַ
PRINT_COLUMN:
	MOV edx, ecx									;edx���������ѭ����
	PUSH ecx										;�������ecx
	MOV ecx, ebx									;���ڲ�ѭ������ֵ6
PRINT_ROW:
	CMP ecx, edx
	JB SKIP											;���ǲ��������ǾͲ���ӡ
	MOVZX eax, BYTE PTR [esi]
	call WriteDec
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE			;��ӡ�ո�
    MOV ConsoleOutHandle, eax 
    PUSHAD										
    INVOKE WriteConsole, ConsoleOutHandle,		
			ADDR Table, 1, 
			offset BytesWritten, 0
	POPAD
SKIP:
	ADD esi, TYPE Buffer							;esi����
	LOOP PRINT_ROW
	CALL CRLF										;��ӡ�س�
	POP ecx											;��������ѭ����cx��ջ
	LOOP PRINT_COLUMN
	INVOKE ExitProcess, 0
main ENDP
END main
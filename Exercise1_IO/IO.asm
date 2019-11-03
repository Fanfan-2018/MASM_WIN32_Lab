; Reading a File and transing low into high

INCLUDE Irvine32.inc
INCLUDE macros.inc

BUFFER_SIZE = 500

.data
buffer BYTE BUFFER_SIZE DUP(?)
filename  BYTE "D:\GithubLocalRepo\Asm_MASM_Lab\Exercise1_IO\Debug\Input1.txt",0
fileHandle  DD ?
ErrorMsg BYTE "error",0
ALREADYREAD DD ?
ConsoleOutHandle DD ?
BytesWritten DD ?

.code
main PROC
	PUSH eax	
	INVOKE CreateFile,
		ADDR filename, GENERIC_READ, 
		DO_NOT_SHARE, NULL, 
		OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0	;����createfile�����Զ�ģʽ���ļ�
	MOV fileHandle, eax							;�����ļ����
	cmp eax, INVALID_HANDLE_VALUE				;�Ƚ��ļ�����Ƿ�Ϸ�
	JZ FILE_ERROR								;�����Ϸ�����ת����
	INVOKE ReadFile,							;�Ϸ����ļ�
		fileHandle, OFFSET buffer, BUFFER_SIZE,
		ADDR ALREADYREAD, 0
	MOV ecx, ALREADYREAD						;ecx�����ֽ���
	MOV esi, OFFSET buffer						;esi�����׵�ַ
CHANGE: 
	MOV bl, [esi]								;ѭ����ȡbuffer
	cmp bl, 60H
	JB WRITEBACK
	sub bl, 20H									;�����Сд��-20H
	MOV [esi], bl								;д��buffer
WRITEBACK:							
	ADD esi, TYPE buffer						;i++
	LOOP CHANGE									;ѭ������
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE		;��ȡ����ָ̨��
    MOV ConsoleOutHandle, eax 
    PUSHAD										;����洢��ֵ
    INVOKE WriteConsole, ConsoleOutHandle,		;��ӡbuffer
			ADDR buffer, ALREADYREAD, 
			offset BytesWritten, 0
	POPAD
	JMP SUCCESS
FILE_ERROR:
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE 
    MOV ConsoleOutHandle, eax 
    PUSHAD  
    INVOKE WriteConsole, ConsoleOutHandle,		;��ӡ������Ϣ
			Offset ErrorMsg, SIZEOF ErrorMsg, 
			offset BytesWritten, 0
	POPAD
	POP eax
	INVOKE ExitProcess, 0
SUCCESS:
	POP eax
	INVOKE ExitProcess, 0
main ENDP
END main
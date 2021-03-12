#pragma once

//���󷵻�
#define SUCCESS	              0   
#define FALSE_RECV            -1   //���հ�ʧ��
#define ERROR_STARTUP         -2	//��ʼ��socket����ʧ��
#define ERROR_SOCKET          -3	//����socketʧ��
#define ERROR_SET_SERVER      -4	//���÷�������ַʧ��
#define FALSE_SEND            -5	//����ʧ��
#define ERROR_UNKNOW          -6	//δ֪����
#define ERROR_CONNECT         -9	//sock����ʧ��
#define ERROR_SELECT          -10	//selectʧ��
#define ERROR_SOCKET_DOMAIN          -11	//��������ʧ��
#define ERROR_TIME_OUT				-12//��ʱ

//����
#define COMMAND_REGISTER			5050
#define COMMAND_BY_USERNAME			5030
#define COMMAND_BY_DEVICEID			5040
#define COMMAND_CHANGE_PSW			5060
#define COMMAND_ADD_DEVICE			5070
#define COMMAND_GET_DEVCOUNT        5080
#define COMMAND_CHANGE_DEVINFO		5090
#define COMMAND_DELETE_DEV			5100
#define COMMAND_UPDATE				5110
#define COMMAND_RESTORE_PSW			5120
#define COMMAND_CHECK_USER_VALID	5130

//buf����
#define MAX_DEVICE_COUNT			 100
#define SENDBUFLEN					 1024
#define XMLLEN						2048
#define RECVBUFLEN					100*1024

//�˿ڼ�ip
#define PORT_LOCAL					10001
#define IP_LOCAL					"192.168.53.200"

#ifndef WIN32
#define WORD	unsigned short
#define DWORD	unsigned long
#define LPDWORD	DWORD*
#define BOOL	int
#define TRUE	1
#define FALSE	0
#define BYTE	unsigned char
#define LONG	long
#define UINT	unsigned int
#define HDC		void*
#define HWND	void*
#define LPVOID	void*
#define LPCSTR  char*
#define LPCTSTR  const char*
#endif

//��ͷ
struct PacketHead
{
	int HeadFlag;				//���ı�ʶ
	int command;				//����
	int extlen;					//��ͷ֮�����Ϣ����
	int reserve;				//�����ֽڣ�����Ϊ���������ذ�����Ϣ��
};
#define PACKETHEADLEN 16


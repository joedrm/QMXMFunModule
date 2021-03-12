#ifndef __IRSDK_C_H__
#define __IRSDK_C_H__

#include "data_define.h"

// Brand
typedef struct 
{
	int brand_id;
	char brand_cn[32];
	char brand_tw[32];
	char brand_en[32];
	char brand_other[32];
	char brand_pinyin[32];
	char py[8];
	char remarks[32];
}Brand_c;

typedef struct
{
	int num;
	Brand_c Brand[128];
}Brands;

// Infrared
typedef struct 
{
	long key_id;
	int key_type;
	int func;
	char data[768];
	int freq;
	int mark;
	int ir_mark;
	int quality;
	int priority;
}Infrared_c;

typedef struct
{
	int num;
	Infrared_c Infrared[32];
}Infrareds;

// Key
typedef struct 
{
	long key_id;
	char name[32];
	int type;
	char remote_id[64];
	int protocol;
}Key_c;

typedef struct
{
	int num;
	Key_c Key[32];
}Keys;

// Remote
typedef struct 
{
	char remote_id[64];			//  ң����ID
	int type;
	char name[32];		// ң��������
	int brand_id;
	char model[32];
}Remote_c;

typedef struct
{
	int num;
	Remote_c Remote[32];
}Remotes;

// Room
typedef struct 
{
	int room_id;
	char name[32];
	int remote_num;
	char remote_name_list[32][16];
}Room_c;

typedef struct
{
	int num;
	Room_c Room[32];
}Rooms;

// MatchPage
typedef struct 
{
	int appliance_type;
	int brand_id;
	int num;
	char models[32][16];
	int page;
}MatchPage_c;

typedef struct
{
	int num;
	MatchPage_c MatchPage[32];
}MatchPages;

typedef struct 
{
	int key;
	char remote_id[64];
	char model[32];
	char code[768];
}MatchResult_c;

typedef struct
{
	int num;
	MatchResult_c MatchResult[32];
}MatchResults;

typedef struct 
{
	// δʹ��
	int wind_mask;
	// δʹ��
	int protocol;
	// δʹ��
	int current_key;
	// δʹ��
	int last_key;
	// δʹ��
	int click_count;
	// δʹ��
	int timer_value;
	// ���أ�0Ϊ�أ�1Ϊ��
	int power;
	// ģʽ, 0�Զ���1���䣬2��ʪ ��3�ͷ磬4��ů
	int mode;
	// �¶� 16-30
	int temp;
	// ���� 0�Զ���1��һ����2�ڶ�����3������
	int wind_amout;
	// δʹ��
	int wind_dir;
	// δʹ��
	int wind_hor;
	// δʹ��
	int wind_ver;
	// δʹ��
	int super_mode;
	// δʹ��
	int sleep;
	// δʹ��
	int aid_hot;
	// δʹ��
	int timer;
	// δʹ��
	int temp_display;
	// δʹ��
	int power_saving;
	// δʹ��
	int anion;
	// δʹ��
	int comport;
	// δʹ��
	int fresh_air;
	// δʹ��
	int light;
	// δʹ��
	int wet;
	// δʹ��
	int mute;
}AirRemoteState_c;

typedef struct
{
	int num;
	AirRemoteState_c AirRemoteState[32];
}AirRemoteStates;

void IRemoteClient_SetPath(char* path);

void IRemoteClient_LoadBrands(Brand_c* brands, int& num);
void IRemoteClient_GetBrandNum(int type, int& num);
void IRemoteClient_LoadBrands(int type, Brand_c* brands, int& num);
void IRemoteClient_GetRemoteNum(int& num);
void IRemoteClient_LoadRemotes(Remote_c* remotes, int &num);
void IRemoteClient_ExactMatchRemotes(MatchPage_c* page, Key_c* key, MatchResult_c* results, int& num);
void IRemoteClient_ExactMatchAirRemotes(MatchPage_c* page, Key_c* key, AirRemoteState_c* state, MatchResult_c* results, int& num);

void IRemoteManager_GetAllRooms(Room_c* rooms, int& num);
void IRemoteManager_GetRemoteFromRoom(Room_c room, Remote_c* remotes, int& num);
void IRemoteManager_GetRemoteByID(char* name, char* remote_id, Remote_c* remote);
void IRemoteManager_AddRemoteToRoom(Remote_c* remote, Room_c* room);
void IRemoteManager_DeleteRemoteFromRoom(Remote_c* remote, Room_c* room);
void IRemoteManager_AddRemote(Remote_c* remote);
void IRemoteManager_AddRoom(Room_c* room);
void IRemoteManager_DeleteRoom(Room_c* room);
void IRemoteManager_ChangeRoomName(Room_c* room, char* name);

void IInfraredFetcher_FetchInfrareds(Remote_c* remote, Key_c* key, Infrared_c* infrareds, int& num);
int IInfraredFetcher_GetAirRemoteStatus(Remote_c* remote, AirRemoteState_c* state);
int IInfraredFetcher_SetAirRemoteStatus(char* remote_name, AirRemoteState_c* state);
void IInfraredFetcher_FetchAirTimerInfrared(Remote_c* remote, Key_c* key, AirRemoteState_c* state, int time,  Infrared_c* infrareds, int& num);
void IInfraredFetcher_TranslateInfrared(char* code, unsigned char* data, int& num);

#endif

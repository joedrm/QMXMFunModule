#pragma once
#include "FunSDK/JObject.h"

#define JK_CombEncodeInfo "CombEncodeInfo" 
class CombEncodeInfo : public JObject
{
public:
	JIntHex		CompressionMask;
	JBoolObj		Enable;
	JBoolObj		HaveAudio;
	JIntHex		ResolutionMask;
	JStrObj		StreamType;

public:
	CombEncodeInfo(JObject *pParent = NULL, const char *szName = JK_CombEncodeInfo):
	JObject(pParent,szName),
	CompressionMask(this, "CompressionMask"),
	Enable(this, "Enable"),
	HaveAudio(this, "HaveAudio"),
	ResolutionMask(this, "ResolutionMask"),
	StreamType(this, "StreamType"){
	};

	~CombEncodeInfo(void){};
};

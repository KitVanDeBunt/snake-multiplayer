#pragma once

#define MAX_CLIENTS 10
//#define SERVER_PORT 60000
#include "TCPInterface.h"
#include "Enums.h"

using namespace RakNet;

struct ConSettings
{
	int port;
	int maxPlayers;
};

class Connector
{
private:
	void SendHello();
	int serverPort;
protected:
	void PingBack(RakNet::SystemAddress addres);
	TCPInterface *peer;
	bool isServer;
	Packet *pack;
	ConSettings settings_;
public:
	Connector(void);
	~Connector(void);
	virtual void Init(ConSettings settings);
	virtual void ProcessPack(Packet *pack);
	virtual void ExecuteMessage(MessageType messageType, int messageLength,SystemAddress caller);
	virtual void Loop();
	virtual void Close();
	int getServerPort(){
		return serverPort;
	}
	bool getIsServer(){
		return isServer;
	}
};


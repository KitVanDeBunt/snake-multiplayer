#include "Connector.h"
#include <stdio.h>
#include "Enums.h"
#include "ByteConvert.h"
#include <vector>
#include <iostream>
#include <stdio.h>

Connector::Connector(void)
{
	serverPort = 0;
}

Connector::~Connector(void)
{
}

void Connector::Init(ConSettings settings){
	settings_  = settings;
	serverPort = settings.port;
	peer = TCPInterface::GetInstance();
}
void Connector::Loop(){
	//recieve loop
	while(1){
		pack = peer->Receive();
		if(pack!=0){
			ProcessPack(pack);
			peer->DeallocatePacket(pack);
		}else{
			break;
		}
	}
	//send loop
	//this->SendHello();
}

void Connector::ProcessPack(RakNet::Packet *pack){
	printf("[--ProcessPack--]\n");
	//printf("data Lenght: %u\n",pack->length);
	unsigned int dataLength = pack->length;
	//printf("dataType: %i \n",pack->data[0]);

	unsigned char* data = pack->data;
	
	//int lenghtMessage = data[0] +(data[1]<<010)+(data[2]<<020)+(data[3]<<030);
	unsigned char byteMessageLength[4];
	byteMessageLength[0] = data[0];
	byteMessageLength[1] = data[1];
	byteMessageLength[2] = data[2];
	byteMessageLength[3] = data[3];
	int lenghtMessage = ByteConverter::UnsignedCharToInt(byteMessageLength);
	MessageType messageType = (MessageType)data[4];
	printf("[Process Pack]: Length Message: %i\n", lenghtMessage);
	printf("[Process Pack]: Length Data   : %i\n", dataLength);
	printf("[Process Pack]: MessageType   : %i\n", data[4]);
	printf("[Process Pack]: addres: %s\n",pack->systemAddress.ToString());

	ExecuteMessage(messageType,lenghtMessage,pack->systemAddress);
	
}

void Connector::ExecuteMessage(MessageType messageType, int MessageLenth ,SystemAddress caller){
	switch (messageType)
	{
	case MessageType::Ping:
		this->PingBack(pack->systemAddress);
		break;
	default:
		break;
	}
	printf("\n");
}

void Connector::PingBack(SystemAddress addres){
	printf("[--Ping Back--]\n\n");
	std::vector<unsigned char> dataLenght = ByteConverter::IntToUnsignedCharArray(5);
	unsigned char hello[5];
	hello[0]=dataLenght.at(0);
	hello[1]=dataLenght.at(1);
	hello[2]=dataLenght.at(2);
	hello[3]=dataLenght.at(3);
	hello[4]=(int)(MessageType::PingBack);

	peer->Send((const char *)hello, 5,addres,false);
	//peer->remoteClients[0]->outgoingDataMutex
	printf("\n");
}

void Connector::SendHello(){
	//printf("-Send hello-\n");
	std::vector<unsigned char> dataLenght = ByteConverter::IntToUnsignedCharArray(5);
	unsigned char hello[5];
	hello[0]=dataLenght.at(0);
	hello[1]=dataLenght.at(1);
	hello[2]=dataLenght.at(2);
	hello[3]=dataLenght.at(3);
	hello[4]=(int)(MessageType::Hello);

	peer->Send((const char *)hello, 5,"127.0.0.1",true);
}

void Connector::Close(){
	if(this->isServer){
		printf("Server Quit\n");
	}else{
		printf("Client Quit\n");
	}
	TCPInterface::DestroyInstance(this->peer);
}

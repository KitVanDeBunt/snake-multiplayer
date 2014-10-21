#include "PolicyServer.h"
#include "TCPInterface.h"
#include <iostream>


unsigned char policyCharArray[] = 
{ '<','p','o','l','i','c','y','-','f','i','l',
  'e','-','r','e','q','u','e','s','t','/','>','\0' };

//<?xml version="1.0"?>
//<cross-domain-policy><allow-access-from domain="*" to-ports="60000" /></cross-domain-policy>
unsigned char policyFile[] = 
{ 
'<','?','x','m','l',' ',
'v','e','r','s','i','o','n','=','"','1','.','0','"','?','>',
'<','c','r','o','s','s','-',
'd','o','m','a','i','n','-',
'p','o','l','i','c','y','>',
'<','a','l','l','o','w','-',
'a','c','c','e','s','s','-',
'f','r','o','m',' ',
'd','o','m','a','i','n','=','"','*','"',' ',
't','o','-','p','o','r','t','s','=','"','1','1','1','0','0','"',' ','/','>',
'<','/','c','r','o','s','s','-',
'd','o','m','a','i','n','-',
'p','o','l','i','c','y','>','0' 
};
unsigned char policyFileEndianReversed[114]; 


PolicyServer::PolicyServer(void)
{
}


PolicyServer::~PolicyServer(void)
{
}

void PolicyServer::ProcessPack(RakNet::Packet *pack){
	printf("-process package-\n");
	//printf("data Lenght: %u\n",pack->length);
	unsigned int dataLength = pack->length;
	//printf("dataType: %i \n",pack->data[0]);

	unsigned char* data = pack->data;
	std::string dataStr = ByteConverter::UnsignedCharToString((pack->data),dataLength);
	std::string plStr = ByteConverter::UnsignedCharToString(policyCharArray,23);
	//std::cout<<"data:"<<dataStr<<":"<<std::endl;
	int polecyFileSize = sizeof(policyFile);
	std::cout<<"file:"<<policyFile<<":\n"<<std::endl;
	std::cout<<"fileLength:"<<polecyFileSize<<":\n"<<std::endl;
	if(plStr == dataStr){
		printf("[policy file send back]\n");
		
		for (int i = 0;i<polecyFileSize;i++){
			int c = policyFile[polecyFileSize-i];
			printf("c:%u\n",c);
			policyFileEndianReversed[i] = policyFile[polecyFileSize-i];
			printf("e:%u\n",policyFileEndianReversed[i]);
		}
		std::cout<<"filepolicyFileEndianReversed:"<<policyFileEndianReversed<<":\n"<<std::endl;
		std::cout<<"policyFileEndianReversed:"<<sizeof(policyFileEndianReversed)<<":\n"<<std::endl;
		peer->Send((const char *)policyFileEndianReversed, sizeof(policyFileEndianReversed),pack->systemAddress,false);
		std::cout << "[addres]: "<<pack->systemAddress.ToString() <<std::endl;

		return;
	}
}
void PolicyServer::Init(ConSettings settings){
	Connector::Init(settings);
	printf("Policy Server Started Port: %d\n",settings.port);
	peer->Start(getServerPort(),2);
	//isServer = true;
}

void PolicyServer::Loop(){
	while(1){
		pack = peer->Receive();
		if(pack!=0){
			ProcessPack(pack);
			peer->DeallocatePacket(pack);
		}else{
			break;
		}
	}
	while(1){
		addresPolicy = peer->HasNewIncomingConnection();
		if(addresPolicy!=UNASSIGNED_SYSTEM_ADDRESS){
			std::cout << "[policy connected]: "<<addresPolicy.ToString() <<std::endl;
			peer->CloseConnection(addresPolicy);
		}else{
			//std::cout << "[]: "<<std::endl;
			break;
		}
	}
}

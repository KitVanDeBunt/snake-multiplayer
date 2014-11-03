// TCP.cpp : Defines the entry point for the console application.
//
#include <stdio.h>
#include <conio.h>
#include "stdafx.h"
#include "Server.h"
#include "PolicyServer.h"
#include "Client.h"
#include "Enums.h"
#include "RakSleep.h"
#include "iostream"
#include "ByteConvert.h"
#include "Settings.h"

char str[512];
Connector* con;
Connector* policyServer;

const int SERVER_PORT = 11100;
const int POLICY_SERVER_PORT = 843;

void WaitForEnter(void) { 
	printf("Press Enter to continue: "); 
	//fflush(stdout); 
	while ( _getch()){
		int key = _getch();
		if(key == (int)KeyCode::Enter){
			printf("Enter Pressed \n");
			break;
		}
		//printf("key: %i \n",_getch());
	}
} 

void Loop(){
	while(1){
		if(con->getIsServer()){
			//policyServer->Loop();
		}
		con->Loop();
		RakSleep(20);
	}
}

int _tmain(int argc, _TCHAR* argv[])
{
	/*unsigned char cha[] = { '<','p','o','l','i','c','y','\0' };
	std::cout<<cha<<std::endl;
	unsigned char cha2[8];
	for (int i = 0;i<8;i++){
		int c = cha[8-i];
		printf("c:%u\n",c);
		cha2[i] = cha[8-i];
		printf("e:%u\n",cha2[i]);
	}
	std::cout<<cha2[3]<<std::endl;
	*/
	/*
	string name = "kit";
	unsigned char *namC = ByteConverter::StringToUnsignedChar(name);
	std::cout<<name<<std::endl;
	std::cout<<namC[0];
	std::cout<<namC[1];
	std::cout<<namC[2];
	std::cout<<std::endl;
	*/
	/*
	Player *pl = new Player("Kit",UNASSIGNED_SYSTEM_ADDRESS);
	string name = pl->getName();
	std::cout << "hi:"<<name<<std::endl;
	delete pl;
	*/
	

	ConSettings conSettings;
	//printf("(C)lient or (S)erver?\n");
	
	//gets(str);
	/*if ((str[0]=='c')||(str[0]=='C')){
		con = new Client();
		conSettings.port = SERVER_PORT;
		conSettings.maxPlayers = 0;
	} else {*/
		con = new Server();
		conSettings.port = SERVER_PORT;
		conSettings.maxPlayers = Settings::maxPlayers;
		//policyServer = new PolicyServer();
		//policyServer->Init(POLICY_SERVER_PORT);
		
	//}
	con->Init(conSettings);
	
	Loop();

	return 0;
}


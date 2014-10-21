#include "Client.h"
#include <stdio.h>
#include <iostream>
#include <string>
#include <ctime>

Client::Client(void):Connector()
{
}


Client::~Client(void)
{
}

void Client::Init(ConSettings settings){
	Connector::Init(settings);
	printf("Client Started\n");
	peer->Start(getServerPort(),0);
	isServer = false;
	SystemAddress addres = peer->Connect("127.0.0.1",getServerPort());
	
	char hello[9];
	hello[0]=2;
	hello[1]='h';
	hello[2]='i';
	hello[3]='h';
	hello[4]='a';
	hello[5]='l';
	hello[6]='l';
	hello[7]='o';
	hello[8]='\0';

	peer->Send((const char *)hello, 9,addres,false);

	std::cout<<"data Send\n";

	hello[0]=1;
	peer->Send((const char *)hello, 9,addres,false);

	hello[0]=0;
	for(int i = 0;i<20000;i++){
		peer->Send((const char *)hello, 9,addres,false);
	}

	std::time_t result = std::time(NULL);
	long int timeInt = result;
    std::cout << std::asctime(std::localtime(&result))<< result <<" i:"<<timeInt << " seconds since the Epoch\n";

	for(int i = 0;i<10;i++){
		std::cout<<hello[i];
	}
}

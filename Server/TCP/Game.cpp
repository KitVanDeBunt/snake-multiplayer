#include "Game.h"
#include <iostream>
#include <string>
#include <TCPInterface.h>
#include "ByteConvert.h"
#include "Enums.h"
using std::cout;
using std::endl;
using std::string;
using namespace RakNet;



Game::Game(TCPInterface *peer,PlayerManager *playerManager){
	playerManager_ = playerManager;
	peer_ = peer;
	cout<<"\n[Game] Created: " <<endl;

	SetPlayerPositions();
	SendPlayerPositionList();
	SendPlayerDirectionList();
}


Game::~Game(void){
	cout<<"[Game] Destroyed: "<<endl;
}

void Game::Loop(){
	//cout<<"[GameLoop]"<<endl;
	SendPlayerDirectionList();
}

void Game::SetPlayerPositions(){
	printf("[Game]set player positions-\n");
	Player *players =playerManager_->GetPlayers();
	for(unsigned int i = 0;i<playerManager_->GetPlayerCount();i++){
		players[i].xPos(5);
		players[i].yPos(5*i);
	}
}

void Game::SendPlayerPositionList(){
	printf("[Game]Send Player Position List-\n");
	
	int playerCount = playerManager_->GetPlayerCount();
	int messageL = 9+(playerCount*3);
	
	unsigned char *message = new unsigned char[messageL];
	ByteConverter::PushIntToUnsignedCharArray(message,0,messageL);
	
	message[4]=(int)(MessageType::PLAYER_POSITION_LIST);
	ByteConverter::PushIntToUnsignedCharArray(message,5,playerCount);

	int currentMessageL = 9;
	for(int i = 0;i < playerCount;i++){
		message[currentMessageL] = playerManager_->GetPlayers()[i].id();
		message[currentMessageL+1] = playerManager_->GetPlayers()[i].xPos();
		message[currentMessageL+2] = playerManager_->GetPlayers()[i].yPos();
		currentMessageL+=3;
	}
	
	printf("-currentMessageL %d-\n",currentMessageL);
	printf("-messageL %d-\n",messageL);
	peer_->Send((const char *)message, messageL,"127.0.0.1",true);
	delete [] message;

	printf("\n");
}

void Game::SendPlayerDirectionList(){
	printf("[Game]Send Player Direction List-\n");
	
	int playerCount = playerManager_->GetPlayerCount();
	int messageL = 9+(playerCount*2);
	
	unsigned char *message = new unsigned char[messageL];
	ByteConverter::PushIntToUnsignedCharArray(message,0,messageL);
	
	message[4]=(int)(MessageType::PLAYER_DIRECTION_LIST);
	ByteConverter::PushIntToUnsignedCharArray(message,5,playerCount);

	int currentMessageL = 9;
	for(int i = 0;i < playerCount;i++){
		message[currentMessageL] = playerManager_->GetPlayers()[i].id();
		message[currentMessageL+1] = playerManager_->GetPlayers()[i].direction();
		cout<<"[Game] Dir: "<<(int)message[currentMessageL+1]<<" n:"<<playerManager_->GetPlayers()[i].getName()<<endl;
		printf("[Game] Dir: %u \n",message[currentMessageL+1]);
		currentMessageL+=2;
	}
	
	//printf("-currentMessageL %d-\n",currentMessageL);
	//printf("-messageL %d-\n",messageL);
	peer_->Send((const char *)message, messageL,"127.0.0.1",true);
	delete [] message;
	
	printf("\n");
}

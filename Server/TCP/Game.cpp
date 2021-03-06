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
	cout<<"\n[Game] Created: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" <<endl;
	playerManager_ = playerManager;
	peer_ = peer;
	
	nonPlayerEntityManager = NonPlayerEntityManager();

	nonPlayerEntityManager.CreatNewPickups();

	nonPlayerEntityManager.SendNonPlayerEntityList();
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
		if(playerManager_->GetPlayerCount()>8){
			players[i].yPos(2*(i+1));
		}else{
			players[i].yPos(5*(i+1));
		}
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
		cout<<"[Game] pos"<<" n:"<<playerManager_->GetPlayers()[i].getName()<<endl;
		printf("[Game] Pos: (%d,%d)\n",playerManager_->GetPlayers()[i].xPos(),playerManager_->GetPlayers()[i].yPos());
		currentMessageL+=3;
	}
	
	printf("-currentMessageL %d-\n",currentMessageL);
	printf("-messageL %d-\n",messageL);
	peer_->Send((const char *)message, messageL,"127.0.0.1",true);
	delete [] message;

	printf("\n");
}

void Game::SendPlayerDirectionList(){
	//printf("[Game]Send Player Direction List-\n");
	
	int playerCount = playerManager_->GetPlayerCount();
	int messageL = 9+(playerCount*4);
	
	unsigned char *message = new unsigned char[messageL];
	ByteConverter::PushIntToUnsignedCharArray(message,0,messageL);
	
	message[4]=(int)(MessageType::PLAYER_DIRECTION_LIST);
	ByteConverter::PushIntToUnsignedCharArray(message,5,playerCount);

	int currentMessageL = 9;
	for(int i = 0;i < playerCount;i++){
		message[currentMessageL] = playerManager_->GetPlayers()[i].id();
		message[currentMessageL+1] = playerManager_->GetPlayers()[i].direction();
		
		message[currentMessageL+2] = playerManager_->GetPlayers()[i].xPos();
		message[currentMessageL+3] = playerManager_->GetPlayers()[i].yPos();
		//cout<<"[Game] Dir: "<<(int)message[currentMessageL+1]<<" n:"<<playerManager_->GetPlayers()[i].getName()<<endl;
		//printf("[Game] Dir: %u \n",message[currentMessageL+1]);
		currentMessageL+=4;
	}
	
	//printf("-currentMessageL %d-\n",currentMessageL);
	//printf("-messageL %d-\n",messageL);
	peer_->Send((const char *)message, messageL,"127.0.0.1",true);
	delete [] message;
	
	//printf("\n");
}

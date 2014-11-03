#include "PlayerManager.h"
#include <iostream>
#include <string>
#include "TCPInterface.h"

using std::cout;
using std::endl;
using std::string;

//Player *players;
//unsigned int playerCount;

PlayerManager::PlayerManager(void)
{
	currentAdminId_ = -1;
	playerCount = 0;
}


PlayerManager::~PlayerManager(void)
{
}

Player * PlayerManager::GetPlayer(SystemAddress addres){
	for(unsigned int i = 0;i<playerCount;i++){
		if(players[i].getAddres()==addres){
			return (&players[i]);
		}
	}
	return NULL;
}
Player * PlayerManager::GetPlayer(unsigned char id){
	for(unsigned int i = 0;i<playerCount;i++){
		if(players[i].id()==id){
			return (&players[i]);
		}
	}
	return NULL;
}

string PlayerManager::GetPlayerName(SystemAddress addres){
	return GetPlayer(addres)->getName();
}

void PlayerManager::SetPlayerName(string name,SystemAddress addres){
	GetPlayer(addres)->setName(name);
}


unsigned char PlayerManager::GetPlayerDirection(SystemAddress addres){
	return GetPlayer(addres)->direction();
}

void PlayerManager::SetPlayerDirection(unsigned char direction,SystemAddress addres){
	GetPlayer(addres)->direction(direction);
}

void PlayerManager::SetPlayerPosition(unsigned char newXPos,unsigned char newYPos,SystemAddress addres){
	GetPlayer(addres)->xPos(newXPos);
	GetPlayer(addres)->yPos(newYPos);
}

unsigned char PlayerManager::GetPlayerId(SystemAddress addres){
	return GetPlayer(addres)->id();
}

void PlayerManager::SetPlayerId(unsigned char id,SystemAddress addres){
	GetPlayer(addres)->id(id);
}

void PlayerManager::SetPlayerReady(bool ready,SystemAddress addres){
	GetPlayer(addres)->ready(ready);
}

bool PlayerManager::GetPlayerReady(SystemAddress addres){
	return GetPlayer(addres)->ready();
}

bool PlayerManager::GetPlayersReady(){
	for(unsigned int i = 0;i<playerCount;i++){
		if(!players[i].ready()){
			return false;
		}
	}
	return true;
}

unsigned char PlayerManager::GetFirstUnUsedId(){
	for(unsigned char i = 0;i<256;i++){
		bool iIsUsed = false;
		for(unsigned int j = 0;j<playerCount;j++){
			if(players[j].id()==i){
				iIsUsed = true;
				break;
			}
		}
		if(!iIsUsed){
			printf( "[GetFirstUnUsedId] id: %u \n",i);
			return i;
			break;
		}
	}
}

unsigned char PlayerManager::CurrentAdminId(){
	bool newAdmin = false;
	if((playerCount > 0)){
		if(currentAdminId_== -1){
			newAdmin = true;
			printf("[CurrentAdminId]01\n");
		}else if(GetPlayer(currentAdminId_) == NULL){
			newAdmin = true;
			printf("[CurrentAdminId]02\n");
		}/*else if((playerCount > 1)&&GetPlayer(currentAdmdinAddres_)->id()!=currentAdminId_){
			newAdmin = true;
			printf("[CurrentAdminId]03\n");
		}*/
		if(newAdmin){
			unsigned char newAdminId = PlayerManager::NewAdminId();
			currentAdminId_ = newAdminId;
			currentAdmdinAddres_ = GetPlayer(newAdminId)->getAddres();
		}
	}else{
		printf("[CurrentAdminId] no players\n");
	}
	return currentAdminId_;
}

unsigned char PlayerManager::NewAdminId(){
	printf("[NEW Admin ID]\n");
	int lowestId = 256;
	for(unsigned int j = 0;j<playerCount;j++){
		if(players[j].id()<lowestId){
			lowestId = players[j].id();
		}
	}
	return lowestId;
}

void PlayerManager::AddPlayer(SystemAddress addres){
	printf("[--PlayerManager--]Add Player \n");
	Player newPlayer = Player("new Player",addres);
	
	if(players == NULL){
		printf("[PlayerManager]First Player \n");
		players = new Player[1];
		players[0] = newPlayer;
		playerCount++;
	}else{
		printf("[PlayerManager]Add Player \n");
		Player *temp = players;
		players = new Player[playerCount+1];
		for(unsigned int i = 0;i<playerCount;++i){
			players[i] =temp[i];
		}
		players[playerCount] = newPlayer;
		playerCount++;
		delete [] temp;
	}
	players[playerCount-1].id(GetFirstUnUsedId());
	cout << "[new player] created addres:"<<players[playerCount-1].getAddres().ToString()<<endl;
	printf( "[new player] created id: %u \n",players[playerCount-1].id());
	cout << "[new player] count	:"<<playerCount<<endl;
}

void PlayerManager::RemovePlayer(SystemAddress addres){
	printf("[--PlayerManager--]Remove Player \n");
	if(playerCount>1){
		Player *temp = players;
		players = new Player[playerCount-1];
		//pl[0] = new Player("Player",RakNet::UNASSIGNED_SYSTEM_ADDRESS);
		bool restmin = false;
		for(unsigned int i = 0;i<playerCount;i++){
			if(temp[i].getAddres()==addres){
				restmin = true;
			}else{
				if(!restmin){
					players[i] =temp[i];
				}else{
					players[i-1] =temp[i];
				}
			}
		}
		//string name = (players[playerCount].getName());
		playerCount--;
		delete [] temp;
	}else if(playerCount==1){
		delete [] players;
		playerCount--;
		players = NULL;

	}else{
		printf("[PlayerManager]NO PLAYER TO REMOVE!!!!!!! \n");
	}
}
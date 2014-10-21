#pragma once
#include "Player.h"

class PlayerManager
{
private:
	Player *players;
	int playerCount;
	
public:
	PlayerManager(void);
	~PlayerManager(void);
	void AddPlayer(SystemAddress addres);
	void RemovePlayer(SystemAddress addres);
	void SetPlayerName(string name,SystemAddress addres);
	void SetPlayerReady(bool ready,SystemAddress addres);
	bool GetPlayerReady(SystemAddress addres);
	bool GetPlayersReady();
	void SetPlayerId(unsigned char id,SystemAddress addres);
	unsigned char GetPlayerId(SystemAddress addres);
	unsigned char GetFirstUnUsedId();
	string GetPlayerName(SystemAddress addres);

	Player * GetPlayer(SystemAddress addres);
	Player * GetPlayers ()const{return players;};
	int GetPlayerCount ()const{return playerCount;};
	unsigned char CurrentAdminId ();
};


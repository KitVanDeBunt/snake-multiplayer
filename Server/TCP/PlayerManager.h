#pragma once
#include "Player.h"

class PlayerManager
{
private:
	Player *players;
	int playerCount;
	unsigned char NewAdminId ();
	int currentAdminId_;
	SystemAddress currentAdmdinAddres_;
public:
	PlayerManager(void);
	~PlayerManager(void);
	void AddPlayer(SystemAddress addres);
	void RemovePlayer(SystemAddress addres);
	void SetPlayerName(string name,SystemAddress addres);
	void SetPlayerDirection(unsigned char direction,SystemAddress addres);
	unsigned char GetPlayerDirection(SystemAddress addres);
	void SetPlayerReady(bool ready,SystemAddress addres);
	bool GetPlayerReady(SystemAddress addres);
	bool GetPlayersReady();
	void SetPlayerId(unsigned char id,SystemAddress addres);
	unsigned char GetPlayerId(SystemAddress addres);
	unsigned char GetFirstUnUsedId();
	string GetPlayerName(SystemAddress addres);

	Player * GetPlayer(SystemAddress addres);
	Player * GetPlayer(unsigned char id);
	Player * GetPlayers ()const{return players;};
	int GetPlayerCount ()const{return playerCount;};
	unsigned char CurrentAdminId ();
};


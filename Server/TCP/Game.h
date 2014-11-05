#pragma once
#include  "Entity.h"
#include  "PlayerManager.h"
#include <TCPInterface.h>
#include "NonPlayerEntityManager.h"
using namespace RakNet;
class Game
{
private :
	Entity *snakes;
	PlayerManager *playerManager_;
	TCPInterface *peer_;
	NonPlayerEntityManager nonPlayerEntityManager;
public:
	Game(TCPInterface *peer,PlayerManager *playerManager);
	//Game(PlayerManager *playerManager);
	~Game(void);
	void Loop();
	void SendPlayerPositionList();
	void SendPlayerDirectionList();
	void SetPlayerPositions();
};


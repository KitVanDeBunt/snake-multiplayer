#pragma once
#include  "Entity.h"
#include  "PlayerManager.h"
class Game
{
private :
	Entity *snakes;
	PlayerManager *playerManager;
public:
	Game();
	//Game(PlayerManager *playerManager);
	~Game(void);
};


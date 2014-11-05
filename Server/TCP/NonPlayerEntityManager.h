#pragma once
#include "NonPlayerEntity.h"

class NonPlayerEntityManager
{
private:
	NonPlayerEntity *entitys;
	int entityCount;
public:
	NonPlayerEntityManager(void);
	~NonPlayerEntityManager(void);

	void AddEntity(NonPlayerEntity newEntity);
	void RemoveEntity(long id);
	void CreatNewPickups();
	void SendNonPlayerEntityList();
};


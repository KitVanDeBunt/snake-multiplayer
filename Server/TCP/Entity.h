#pragma once

#ifndef _ENTITY_H
#define _ENTITY_H

class Entity
{
private:
	int x_;
	int y_;
public:
	Entity(int x = 0, int y =0);
	~Entity(void);
};

#endif


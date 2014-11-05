#pragma once

#ifndef _ENTITY_H
#define _ENTITY_H

class Entity
{
private:
	int x_;
	int y_;
	unsigned char id_;
public:
	Entity(int x = 0, int y =0);
	~Entity(void);

	unsigned char	id() const					{return id_;}
	void			id(unsigned char newId)		{id_ = newId;}
	unsigned char	xPos()const					{return x_;}
	void			xPos(unsigned char newXPos)	{x_ = newXPos;}
	unsigned char	yPos()const					{return y_;}
	void			yPos(unsigned char newYPos)	{y_ = newYPos;}
};

#endif


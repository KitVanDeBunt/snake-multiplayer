#pragma once
#include <iostream>
#include "TCPInterface.h"
using std::string;
using RakNet::SystemAddress;
class Player
{
private:
	string name_;
	SystemAddress addres_;
	bool ready_;
	unsigned char id_;
	unsigned char direction_;
	unsigned char xPos_;
	unsigned char yPos_;
public:
	Player(string name = "new Player",SystemAddress addres = RakNet::UNASSIGNED_SYSTEM_ADDRESS);
	~Player(void);
	unsigned char	id() const{return id_;}
	void			id(unsigned char newId){id_ = newId;}
	unsigned char	direction() const{return direction_;}
	void			direction(unsigned char newDirection){direction_ = newDirection;}
	unsigned char	xPos() const{return xPos_;}
	void			xPos(unsigned char newXPos){xPos_ = newXPos;}
	unsigned char	yPos() const{return yPos_;}
	void			yPos(unsigned char newYPos){yPos_ = newYPos;}
	string			getName() const{return name_;}
	void			setName(string name){name_ = name;}
	SystemAddress	getAddres() const{return addres_;}
	bool			ready() const {return ready_;};
    void			ready(const bool isReady) {ready_ = isReady;}
};


#include "Player.h"
#include <iostream>
#include <string>
using std::cout;
using std::endl;
using std::string;

	//  Client Game.as
	//directions
	//1 = up
	//2 = right
	//3 = down
	//4 = left

Player::Player(string name,SystemAddress addres){
	name_ = name; 
	addres_ = addres;
	cout<<"[Player] Created: "<< name_ <<endl;
	ready_ = false;
	direction_ = 2;
}
Player::~Player(void){
	cout<<"[Player] Destroyed: "<<name_<<endl;
}


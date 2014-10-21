#include "Player.h"
#include <iostream>
#include <string>
using std::cout;
using std::endl;
using std::string;


Player::Player(string name,SystemAddress addres){
	name_ = name; 
	addres_ = addres;
	cout<<"[Player] Created: "<< name_ <<endl;
	ready_ = false;
}
Player::~Player(void){
	cout<<"[Player] Destroyed: "<<name_<<endl;
}


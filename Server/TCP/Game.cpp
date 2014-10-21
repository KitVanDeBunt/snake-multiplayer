#include "Game.h"
#include <iostream>
#include <string>
using std::cout;
using std::endl;
using std::string;



Game::Game(){
//Game::Game(PlayerManager *playerManager){
	//playerManager_ = playerManager;
	cout<<"[Game] Created: " <<endl;
}


Game::~Game(void){
	cout<<"[Game] Destroyed: "<<endl;
}

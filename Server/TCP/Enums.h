#pragma once

enum class MessageType { 
	Ping = 20, 
	PingBack = 21, 
	Hello = 22, 
	//client to server
	PLAYER_SET_NAME = 30, 
	PLAYER_SET_NEW_DIRECTION = 31,
	PLAYER_READY = 32,
	ADMIN_START = 33,
	//server to client
		//menu
	PLAYER_LIST = 100,
	PLAYER_LIST_UPDATE = 105,
	PLAYER_IS_ADMIN = 103,
	
		//game
	PLAYER_DIRECTION_LIST = 101,
	PLAYER_POSITION_LIST = 102,
	
	SERVER_ERROR = 104,
	GAME_START = 106,
	PLAYER_SET_ID = 107
};
enum class KeyCode { Enter = 13, S = 115, C = 99 };
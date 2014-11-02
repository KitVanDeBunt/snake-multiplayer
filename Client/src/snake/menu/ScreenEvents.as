package snake.menu {
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class ScreenEvents 
	{
		public static const CONNECT:String = "connectEvent";
		public static const DISCONNECT:String = "disconnectEvent";
		public static const PLAY_BUTTON:String = "playButtonEvent";
		public static const SERVER_ERROR_RECIEVED:String = "serverErrorRecieved";
		public static const SERVER_GAME_START:String = "serverStartGame"; // when the menu recieve this it dispatches a ScreenEvents.PLAY event to the eventManager
		public static const PLAY:String = "playEvent"; // event switchs to game screen
		public static const BACK:String = "back";
		public static const PING:String = "pingEvent";
		public static const NEW_PLAYERLIST:String = "newPlayerList"; // starts game on recieved
	}

}
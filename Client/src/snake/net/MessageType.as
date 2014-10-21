package snake.net {
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class MessageType 
	{
		public static const PING:int = 20;
		public static const PING_BACK:int = 21;
		public static const HELLO:int = 22;
		
		//client to server
		public static const PLAYER_SET_NAME:int = 30;
		public static const PLAYER_SET_NEW_DIRECTION:int = 31;
		public static const PLAYER_READY:int = 32;
		public static const ADMIN_START:int = 33;
		
		
		//server to client
		public static const PLAYER_LIST:int = 100;
		public static const PLAYER_DIRECTION_LIST:int = 101;
		public static const PLAYER_POSITION_LIST:int = 102;
		public static const PLAYER_IS_ADMIN:int = 103;
		public static const SERVER_ERROR:int = 104;
		public static const PLAYER_LIST_UPDATE:int = 105;
		public static const GAME_START:int = 106;
		public static const PLAYER_SET_ID:int = 107;
		
	}
}
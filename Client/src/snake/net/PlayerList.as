package snake.net 
{
	import snake.Main;
	import snake.utils.debug.Debug;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class PlayerList
	{
		private static var eventDispatcher:EventDispatcher;
		public static var players:Vector.<Player>;
		private static var playerID_:int = -1;
		private static var adminId_:int = -1;
		
		public static function Init():void {
			players = new Vector.<Player>();
			eventDispatcher = new EventDispatcher();
		}
		public static function get playerCount():int {
			return players.length;
		}
		public static function player(i:int):Player {
			return players[i];
		}
		public static function add(newPlayer:Player):void {
			players.push(newPlayer);
		}
		public static function get thisPlayer():Player {
			var playerReturn:Player;
			for (var i:int = 0; i < players.length; i++) {
				if(players[i].id == playerID_){
					playerReturn = players[i];
					break;
				}
			}
			if (playerReturn == null) {
				playerReturn = new Player("Player Error", -1);
				Main.debug.print("[Error]player not found: ", Debug.Server_2);
			}
			return playerReturn;
		}
		public static function get playerID():int {
			return playerID_;
		}
		public static function set playerID(id:int):void {
			playerID_ = id;
		}
		public static function get adminID():int {
			return adminId_;
		}
		public static function set adminID(id:int):void {
			adminId_ = id;
			for (var i:int = 0; i < players.length; i++) {
				if(players[i].id == adminId_){
					players[i].isAdmin = true;
				}else {
					players[i].isAdmin = false;
				}
			}
		}
		public static function get isAdmin():Boolean {
			if (adminId_ == -1) {
				Main.debug.print("[Error]Admin Id Not Set: ", Debug.Server_2);
				return false;
			}
			
			if (playerID_ == -1) {
				Main.debug.print("[Error]Player Id Not Set: ", Debug.Server_2);
				return false;
			}
			if(playerID_ == adminId_){
				return true;
			}else {
				return false;
			}
		}
		public static function playersReady():Boolean {
			var ready:Boolean = true;
			for (var i:int = 0; i < players.length; i++) {
				if(!players[i].isReady){
					ready = false;
					break;
				}
			}
			return ready;
		}
	}

}
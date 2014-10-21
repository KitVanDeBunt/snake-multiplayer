package snake.net 
{
	import snake.Main;
	import snake.utils.debug.Debug;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class PlayerList 
	{
		public static var players:Vector.<Player>;
		private static var playerID_:int;
		private static var adminId_:int = -1;
		
		public static function Init():void {
			players = new Vector.<Player>();
		}
		public static function get player():Player {
			var playerReturn:Player;
			for (var i:int = 0; i < players.length; i++) {
				if(players[i].id == playerID_){
					playerReturn = players[i];
					break;
				}
			}
			if (playerReturn == null) {
				playerReturn = new Player("Player Error", 0, -1);
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
		}
		public static function get isAdmin():Boolean {
			if (adminId_ == -1) {
				Main.debug.print("[Error]Admin Id Not Set: ", Debug.Server_2);
				return false;
			}
			Main.debug.print("[IsAdmin]admin__--: "+adminId_, Debug.Server_2);
			Main.debug.print("[IsAdmin]playr__--: "+playerID_, Debug.Server_2);
			if(playerID_ == adminId_){
				return true;
			}else {
				return false;
			}
		}
	}

}
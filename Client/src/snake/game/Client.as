package snake.game 
{
	import snake.net.PlayerList;
	import snake.net.Player;
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	public class Client 
	{
		public var id:int;
		private var dir:int;
		private var x:int;
		private var y:int;
		
		public function getid():void {
			id = 0;
			//id = get id from server per player
		}
		
		public function getDir():int {
			for (var i:int = 0; i < PlayerList.players.length; i++) 
			{
				if (i == id) {
					trace(PlayerList.players[i].dir);
					dir = PlayerList.players[i].dir;
				}
			}
			return dir;
		}
		
		public function getPositionX():int {
			if(PlayerList.players[id] != null){
				x = PlayerList.players[id].xPos;
			}
			return x;
		}
		
		public function getPositionY():int {
			if(PlayerList.players[id] != null){
				y = PlayerList.players[id].yPos;
			}
			return y;
		}
		
	}

}
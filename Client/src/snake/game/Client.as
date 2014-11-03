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
		
		public function setId(id:int):void {
			id = id;
		}
		
		public function getPosition():void {
			trace(PlayerList.players.length);
			for (var i:int = 0; i < PlayerList.players.length; i++) 
			{
				if (i != id) {
					trace(PlayerList.players[i].dir);
				}
			}
		}
		
		public function setPositions():void {
			
		}
		
	}

}
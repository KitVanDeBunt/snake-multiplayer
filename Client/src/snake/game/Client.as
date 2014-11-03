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
		
		public function getId(id:int):void {
			id = 0;
		}
		
		public function getPositions():void {
			for (var i:int = 0; i < PlayerList.players.length; i++) 
			{
				trace(i);
			}
		}
		
		public function setPositions():void {
			
		}
		
	}

}
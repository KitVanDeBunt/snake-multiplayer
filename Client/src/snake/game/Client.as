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
			id = 1;
		}
		
		public function getPositions():void {
			trace(PlayerList.players.length);
		}
		
		public function setPositions():void {
			
		}
		
	}

}
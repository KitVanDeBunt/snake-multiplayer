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
		public function getPositions():void {
			if(PlayerList != null){
				trace(PlayerList.players);
			}
		}
		
		public function setPositions():void {
			
		}
		
	}

}
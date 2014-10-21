package snake.net 
{
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Player 
	{
		public var name:String;
		public var dir:int;
		public var id:int;
		public var isAdmin:Boolean;
		public var isReady:Boolean;
		
		public function Player(_name:String , _dir:int, _id:int) 
		{
			name = _name;
			dir = _dir;
			id = _id;
		}
		
	}

}
package snake.net 
{
	import snake.Main;
	import snake.utils.debug.Debug;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Player 
	{
		public var name:String;
		public var dir:int;
		public var id:int;
		private var isAdmin_:Boolean;
		public var isReady:Boolean;
		
		public function Player(_name:String , _dir:int, _id:int) 
		{
			name = _name;
			dir = _dir;
			id = _id;
		}
		
		public function get isAdmin ():Boolean {
			return isAdmin_;
		}
		
		
		public function set isAdmin (newIsAdmin:Boolean):void {
			Main.debug.print("[set is admin]", Debug.Server_2);
			isAdmin_= newIsAdmin;
		}
	}

}
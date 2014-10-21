package snake.utils.misc 
{
	/**
	 * ...
	 * @author Jesse Stam
	 */
	public class Vector2 
	{
		private var _x:Number, y:Number;
		
		public function Vector2(var __x:Number, var __y:Number){
			_x = __x;
			_y = __y;
		}
		public function get x():Number 
		{
			return _x;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
		}
		
		public function get int_y():int 
		{
			return Math.floor(_y)as int;
		}
		public function get int_x():int 
		{
			return Math.floor(_x)as int;
		}
	}

}
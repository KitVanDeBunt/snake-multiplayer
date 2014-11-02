package snake.game
{
	import starling.display.Shape;
	import starling.display.Sprite;
		
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	public class PickUp extends Sprite
	{
		public var pickUp:Shape;
		public var id:int = -1;
		
		public function addPickUp(PosX:int, posY:int, color:uint):void
		{
			pickUp = new Shape();
			pickUp.graphics.beginFill(color);
			pickUp.graphics.drawRect(PosX, posY, 10, 10);
			pickUp.graphics.endFill();
			addChild(pickUp);
		}
		
	}

}
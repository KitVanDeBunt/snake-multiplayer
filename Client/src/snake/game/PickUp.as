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
		
		public function addPickUp(PosX:int, posY:int):void
		{
			pickUp = new Shape();
			pickUp.graphics.beginFill(0x000000);
			pickUp.graphics.drawRect(PosX, posY, 10, 10);
			pickUp.graphics.endFill();
			addChild(pickUp);
		}
		
	}

}
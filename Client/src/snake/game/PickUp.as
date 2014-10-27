package snake.game
{
	import starling.display.Sprite;
	import flash.desktop.InteractiveIcon;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.Graphics;
		
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	public class PickUp extends Sprite
	{
		public var pickUp:Sprite;
		
		public function addPickUp(PosX:int, posY:int):void
		{
			pickUp = new Sprite();
			pickUp.graphics.beginFill(0x000000);
			pickUp.graphics.drawRect(PosX, posY, 10, 10);
			pickUp.graphics.endFill();
			addChild(pickUp);
		}
		
	}

}
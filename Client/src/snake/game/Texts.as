package snake.game 
{
	import starling.display.Sprite;
	import starling.text.TextField;
	import snake.game.Game;
	
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	public class Texts extends Sprite
	{
		public var rounds:TextField;
		
		public function ShowScore(text:String, posX:Number):void {
			if (rounds != null) {
				removeChild(rounds);
			}
//			rounds.x = 50;
			rounds = new TextField(posX*2, 50, text,"Verdana", 12, 0, false);
			addChild(rounds);
		}
		
		public function removeScore():void {
			removeChild(rounds);
		}
	}
}
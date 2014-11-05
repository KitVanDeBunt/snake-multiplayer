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
		private var rounds:TextField;
		private var start:TextField;
		private var end:TextField;
		
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
		
		public function startMenu(width:int,height:int):void {
			start = new TextField(width, height, "Multiplayer snake!", "Verdana", 35, 0, true);
			addChild(start);
		}
		
		public function removeStart():void {
			removeChild(start);
		}
		
		public function endGame(winner:int):void {
			if(winner == 2){
				end = new TextField(400, 400, "Tie Game!", "Verdana", 35, 0, true);
			}
			else {
				end = new TextField(400, 400, "Player" + winner + "wins!", "Verdana", 35, 0, true);
			}
			addChild(end);
		}
		
		public function removeEnd():void {
			removeChild(end);
		}
	}
}

package snake {
	import flash.display.Sprite;
	import starling.core.Starling;
	import snake.Main;
	//[SWF(width="400", height="300", frameRate="60", backgroundColor="#ffffff")]
	public class StartUp extends Sprite
	{
		private var _starling:Starling;
		
		public function StartUp():void
		{
			_starling = new Starling(Main, stage);
			_starling.start();
			trace("start");
		}
	}

}
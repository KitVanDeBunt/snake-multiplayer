package snake.menu.screens 
{
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import starling.events.Event;
	import snake.game.Game;
	import starling.display.Sprite;
	import snake.menu.ScreenEvents;
	import snake.Main;
	import snake.utils.debug.Debug;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class GameScreen extends Screen
	{
		
		private var gameLayer:Game;
		
		private var buttons:ButtonGroup;
		private var buttonList:ListCollection = new ListCollection([
			{ label: "Exit", triggered: onExitButton },
		]);
		
		override protected function draw():void {}
		
		override protected function initialize():void {
			buttons = new ButtonGroup();
			this.addChild(buttons);
			buttons.dataProvider = buttonList;
			
			gameLayer = new Game();
			addChild(gameLayer);
			
			Main.debug.print("[gameCreated]",Debug.Menu_1);
		}
		
		private function onExitButton(e:Event):void { 
			gameLayer = null;
			removeChild(gameLayer);
			dispatchEventWith( ScreenEvents.BACK );
		};
		
	}

}
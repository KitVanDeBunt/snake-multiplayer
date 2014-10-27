package snake.menu.screens 
{
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import starling.events.Event;
	import snake.game.Main;
	import starling.display.Sprite;
	import snake.menu.ScreenEvents;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class GameScreen extends Screen
	{
		
		private var gameLayer:Main;
		
		private var buttons:ButtonGroup;
		private var buttonList:ListCollection = new ListCollection([
			{ label: "Exit", triggered: onExitButton },
		]);
		
		override protected function draw():void {}
		
		override protected function initialize():void {
			buttons = new ButtonGroup();
			this.addChild(buttons);
			buttons.dataProvider = buttonList;
			
			gameLayer = new Main();
			addChild(gameLayer);
			
			trace("StartGame");
		}
		
		private function onExitButton(e:Event):void { 
			gameLayer = null;
			removeChild(gameLayer);
			dispatchEventWith( ScreenEvents.BACK );
		};
		
	}

}
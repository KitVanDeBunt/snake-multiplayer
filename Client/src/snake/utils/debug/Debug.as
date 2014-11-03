package snake.utils.debug {
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import flash.events.MouseEvent;
	import snake.StartUp;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Debug extends Sprite
	{
		//example
		
		/*Debug.test(function():void { 
			//draw stuff
			drawStuff();
			//print info
			trace("info");
		} , Debug.Server_1);*/
		
		public static const Server_1:String = "Server_1";
		public static const Server_2:String = "Server_2";
		public static const Server_3:String = "Server_3";
		public static const Menu_1:String = "Menu_1";
		private static const OFF:String = "off";
		//private static var USER:Vector.<String> = new <String>[Kit,ALL,Kit_Draw_Objects,Kit_bounce];
		private static var USER:Vector.<String> = new <String>[Server_3]; 
		
		private var parentDisplayObjectContainer_:DisplayObjectContainer;
		private var textFields:Vector.<TextField>;
		private const textStep:int = 20;
		private const textBufferSize:int = 250;
		private var textDisplaysment:int = 0;
		private var screenHeight:int;
		private var textDisplaysmentMin:int = 0;
		private var moveUp:int = 0;
		private var moveDown:int = 0;
		private const speed:Number = 5;
		
		public static function test(func:Function,user:String):Function 
		{
			for (var i:int = 0; i < USER.length; i++) 
			{
				if (USER[i]== user){
					return func();
					break;
				}
			}
			return null;
		}

		public function mouseWheel(event:MouseEvent):void{
			trace("The delta value is: " + event.delta);
		}
		
		public function Debug(parentDisplayObjectContainer:DisplayObjectContainer) {
			parentDisplayObjectContainer_ = parentDisplayObjectContainer;
			parentDisplayObjectContainer_.addChild(this);
			textFields = new Vector.<TextField>();
			parentDisplayObjectContainer.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			parentDisplayObjectContainer.addEventListener(KeyboardEvent.KEY_UP, keyyUp);
			parentDisplayObjectContainer.addEventListener(Event.ENTER_FRAME, loop);
			screenHeight = Starling.current.backBufferHeight;
			//addEventListener(Event.ADDED_TO_STAGE, AddedToStage);
			
		}
		
		private function AddedToStage(e:Event):void {
			
		}
		
		private function loop(e:Event):void {
			var canMove:Boolean = true;
			var move:int = (moveUp+moveDown)*speed;
			if(move<0){//< down
				if (((this.y + move) <= 0)) {
					if((this.y + move)<0){
						canMove = false;
						//this.y = 0;
					}
				}
			}else if (move > 0) {//> up
				var top:int = ((textFields.length * textStep)-screenHeight);
				if (((this.y + move) >= top)) {
					if((this.y +move)>top){
						canMove = false;
						//this.y = top;
					}
				}
			}else {
				canMove = false;
			}
			if(canMove){
				
				textDisplaysment += move;
				this.y += move;
				for (var i:int = textFields.length-1; i > -1; i--) {
					//textFields[i].y +=  move;
				}
			}
		}
		
		private function keyDown(e:KeyboardEvent):void {
			if (e.keyCode == 188 ) {//<<
				moveUp = -1;
			}
			if (e.keyCode == 190 ) {//>>
				moveDown = 1;
			}
			if (e.keyCode == 191 ) {//?
				toggleView();
			}
		}
		
		private function keyyUp(e:KeyboardEvent):void {
			if (e.keyCode == 188 ) {//<
				moveUp = 0;
			}
			if (e.keyCode == 190 ) {//>
				moveDown = 0;
			}
		}
		private function toggleView():void {
			if(this.parent == null){
				parentDisplayObjectContainer_.addChild(this);
			}else {
				parentDisplayObjectContainer_.removeChild(this);
			}
		}
		
		private function addText(text:String):void {
			//move text
			for (var i:int = textFields.length-1; i > -1; i--) {
				textFields[i].y -=  textStep;
			}
			//delete text
			if (textFields.length > textBufferSize) {
				var deleteCount:int = (textFields.length-textBufferSize);
				for (var j:int = 0; j < deleteCount; j++) 
				{
					removeChild(textFields[j]);
				}
				textFields.splice(0, deleteCount);
			}
			//spawn new
			textFields[textFields.length] = new TextField(stage.stageWidth, 20, text);
			textFields[textFields.length - 1].hAlign = HAlign.LEFT;
			textFields[textFields.length - 1].y = stage.stageHeight - 20;
			addChild(textFields[textFields.length-1]);
		}
		
		public function print(string:String,user:String):Function 
		{
			for (var i:int = 0; i < USER.length; i++) 
			{
				if (USER[i]== user){
					trace(string);
					addText(string);
					break;
				}
			}
			return null;
		}
	}
}
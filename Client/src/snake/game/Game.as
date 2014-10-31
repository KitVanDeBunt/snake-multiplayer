package snake.game 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Stage;
	import starling.display.DisplayObjectContainer;
	import starling.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	
	 [SWF(width = "792", height = "792", frameRate = "30")]
	 
	public class Game extends Sprite 
	{
		private var playerAmount:int = 1;
		private var moveTime:int = 3;
		private var amountOfLines:int = 40;
		private var gridSnap:int = 11;
		
		private var gameWidth:int;
		private var gameHeight:int;
		private var pickUp:PickUp;
		private var player:Block;
		private var players:Array = new Array();
		private var pickUps:Array = new Array();
		private var timer:int;
		private var randomX:Number;
		private var randomY:Number;
		private var reset:Boolean = false;
		private var switchone:Boolean = true;
		
		public function Game() {
			//stage.scaleMode = StageScaleMode.EXACT_FIT;
			startGame();
		}
		
		private function startGame():void {
			gameWidth = amountOfLines * gridSnap;
			gameHeight = amountOfLines * gridSnap;
			for (var i:int = 0; i < playerAmount; i++) 
			{
				player = new Block();
				randomX = Math.floor(Math.random()/2 * amountOfLines)* (gameWidth/amountOfLines);
				randomY = Math.floor(Math.random() * amountOfLines)* (gameHeight/amountOfLines);
				player.Id = i;
				player.DrawSnake(randomX, randomY, 4);
				addChild(player);
				players.push(player);
			}
			
			addPickUp(4);
			
			addEventListener(Event.ENTER_FRAME, Update);
			addEventListener(KeyboardEvent.KEY_DOWN, Control);
		}
		
		private function Update(e:Event):void {
			timer += 1;
			if (timer >= moveTime){
				if (reset == false) {
					for each (var item:Block in players) 
					{
						item.moveSnake();
						item.pressed = false;
					}
					checkColl();
					timer = 0;
				}
			}
			if (pickUps.length == 0)
			{
				addPickUp(4);
			}
		}
		
		public function ResetGame():void {
			for each (var player:Block in players) 
			{
				removeChild(player);
			}
			for each (var pickup:PickUp in pickUps) 
			{
				removeChild(pickup);
			}
			players.splice(0,playerAmount);
			pickUps.splice(0, pickUps.length);
			startGame();
		}
		
		private function addPickUp(Amount:int):void {
			for (var i:int = 0; i < Amount; i++) 
			{
			pickUp = new PickUp;
			addChild(pickUp);
			randomX = Math.floor(Math.random() * amountOfLines)*(gameWidth/amountOfLines);
			randomY = Math.floor(Math.random() * amountOfLines)*(gameHeight/amountOfLines);
			if (randomX == 0 && randomY == 0 ||
				randomX == gameWidth && randomY == 0 ||
				randomX == 0 && randomY == gameHeight ||
				randomX == gameWidth && randomY == gameHeight) {
					removeChild(pickUp);
					Amount -= 1;
			}
			else {
				pickUp.addPickUp(randomX, randomY);
				pickUps.push(pickUp);
			}
			trace(randomX + " " + randomY);
		}
	}
		
		private function Control(e:KeyboardEvent):void {
			if(players[0] != null/* && players[0].pressed == false*/){
				if (e.keyCode == 87 && players[0].moveDir != 3) {//w
					players[0].moveDir = 1;
					//players[0].pressed = true;
				}
				if (e.keyCode == 68 && players[0].moveDir != 4) {//d
					players[0].moveDir = 2;
					//players[0].pressed = true;
				}
				if (e.keyCode == 83 && players[0].moveDir != 1) {//s
					players[0].moveDir = 3;
					//players[0].pressed = true;
				}
				if (e.keyCode == 65 && players[0].moveDir != 2) {//a
					players[0].moveDir = 4;
					//players[0].pressed = true;
				}
			}
			
			if(players[1] != null/* && players[1].pressed == false*/){
				if (e.keyCode == 38 && players[1].moveDir != 3) {//up
					players[1].moveDir = 1;
					//players[1].pressed = true;
				}
				if (e.keyCode == 39 && players[1].moveDir != 4) {//right
					players[1].moveDir = 2;
					//players[1].pressed = true;
				}
				if (e.keyCode == 40 && players[1].moveDir != 1) {//down
					players[1].moveDir = 3;
					//players[1].pressed = true;
				}
				if (e.keyCode == 37 && players[1].moveDir != 2) {//left
					players[1].moveDir = 4;
					//players[1].pressed = true;
				}
			}
		}
		
		private function checkColl():void {
			for (var i:int = 0; i < players.length; i++) 
			{
				for (var k:int = 0; k < pickUps.length; k++) 
				{
					//if (players[i].square.hitTestObject(pickUps[k])) {
					if (intersectsTest(players[i].square,pickUps[k])){
						removeChild(pickUps[k]);
						pickUps.splice(k, 1);
						players[i].addBlock();
						trace("Player " + i + " has picked up a block and is now " + players[i].squares.length + " blocks long");
					}
				}
		//		for each (var item:Block in players) 
			//	{
					for (var j:int = 0; j < players[i].squares.length; j++) 
					{
						if (intersectsTest(players[i].square,players[i].squares[j]))
						{
							if (players[i].square != players[i].squares[j])
							{
								ResetGame();
								trace("Player " + i + " hitted player " + players[i].Id);
							}
						}
					}
			//	}
				if (players[i].lastPos.x < 0 || players[i].lastPos.x >= gameWidth ||
					players[i].lastPos.y < 0 || players[i].lastPos.y > gameHeight)
					{
					ResetGame();
				}
			}
		}
		
		private function intersectsTest(obj1:DisplayObjectContainer,obj2:DisplayObjectContainer):Boolean {
			return obj1.getBounds(obj1.parent).intersects(obj2.getBounds(obj2.parent))
		}
	}
}
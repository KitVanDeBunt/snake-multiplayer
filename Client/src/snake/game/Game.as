package snake.game 
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.display.Stage;
	import starling.display.DisplayObjectContainer;
	import starling.events.KeyboardEvent;
	import snake.menu.ScreenEvents;
	import snake.Main;
	import feathers.data.ListCollection;
	import starling.display.Shape;
	import flash.geom.Vector3D;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	
	 [SWF(width = "792", height = "792", frameRate = "30")]
	 
	public class Game extends Sprite 
	{
		private var playerAmount:int = 2;
		private var startLength:int = 4;
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
		private var countDownIndex:int = 0;
		private var wallX:Shape;
		private var wallY:Shape;
		private var wallWidth:int = 20;
		private var roundsLeft:int = 3;
		private var normalPickups:int = 0;
		
		public function Game() {
			addEventListener(ScreenEvents.NEW_PLAYERLIST , menu);
			trace("3!");
			startGame();
			addEventListener(EnterFrameEvent.ENTER_FRAME, countDown);
			//stage.scaleMode = StageScaleMode.EXACT_FIT;
		}
		
		private function menu(e:ScreenEvents):void {
			//show players or connect or whatever
			removeEventListener(ScreenEvents.NEW_PLAYERLIST, menu);
			addEventListener(ScreenEvents.PLAY , startCountDown);
		}
		
		private function startCountDown(e:ScreenEvents):void {
			trace("3!");
			//addEventListener(EnterFrameEvent.ENTER_FRAME, countDown);
			removeEventListener(ScreenEvents.PLAY, startCountDown);
		}
		
		private function countDown():void {
			countDownIndex++
			if (countDownIndex / 30 == 1) {
				trace("2!");
			}
			if (countDownIndex / 30 == 2) {
				trace("1!");
			}
			if (countDownIndex / 30 == 3) {
				addEventListener(Event.ENTER_FRAME, Update);
				addEventListener(KeyboardEvent.KEY_DOWN, Control);
			}
		}
		
		private function startGame():void {
			removeEventListener(EnterFrameEvent.ENTER_FRAME, countDown);
			countDownIndex = 0;
			removeEventListener(KeyboardEvent.KEY_DOWN, startGame);
			gameWidth = amountOfLines * gridSnap;
			gameHeight = amountOfLines * gridSnap;
			for (var i:int = 0; i < playerAmount; i++) 
			{
				player = new Block();
				randomX = Math.floor(Math.random()/2 * amountOfLines)* gridSnap;
				randomY = Math.floor(Math.random() * amountOfLines)* gridSnap;
				player.Id = i;
				player.DrawSnake(randomX, randomY, startLength);
				addChild(player);
				players.push(player);
			}
			drawWall();
		}
		
		private function Update(e:Event):void {
			timer += 1;
			normalPickups = 0;
			for each (var thing:PickUp in pickUps) 
			{
				if (thing.id == -1) {
					normalPickups += 1;
				}
			}
			if (normalPickups == 0) {
				if(roundsLeft > 0){
					addPickUp(4);
				}
				else {
					ResetGame();
				}
				roundsLeft -= 1;
			}
			if (timer >= moveTime){
				if (reset == false) {
					for each (var item:Block in players) 
					{
						item.moveSnake();
					}
					checkColl();
					timer = 0;
				}
			}
		}
		
		private function resetPlayer(Player:Block, playersIndex:int, length:int):void {
			Player.removeSnake();
			player = new Block();
			randomX = Math.floor(Math.random()/2 * amountOfLines)* gridSnap;
			randomY = Math.floor(Math.random() * amountOfLines)* gridSnap;
			player.Id = playersIndex;
			player.DrawSnake(randomX, randomY, length);
			addChild(player);
			players[playersIndex] = player;
		}
		
		public function ResetGame():void {
			if (players[0].squares.length == players[1].squares.length) {
				trace("tie game!");
			}
			if (players[0].squares.length > players[1].squares.length) {
				trace("player 0 won with " + players[0].squares.length + " blocks!");
			}
			else {
				trace("player 1 won with " + players[1].squares.length + " blocks!");
			}
			for each (var player:Block in players) 
			{
				removeChild(player);
			}
			for each (var pickup:PickUp in pickUps) 
			{
				removeChild(pickup);
			}
			removeChild(wallX);
			removeChild(wallY);
			players.splice(0,playerAmount);
			pickUps.splice(0, pickUps.length);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, Update);
		}
		
		private function dropBlock(playerIndex:int , playerColor:uint):void {
			if(players[playerIndex].squares.length > 1){
				pickUp = new PickUp;
				pickUp.id = playerIndex;
				addChild(pickUp);
				pickUp.addPickUp(players[playerIndex].squares[0].x, players[playerIndex].squares[0].y, playerColor);
				players[playerIndex].removeLastBlock();
				pickUps.push(pickUp);
			}
		}
		
		private function addPickUp(Amount:int):void {
			trace(roundsLeft + "Rounds left");
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
				pickUp.addPickUp(randomX, randomY, 0x000000);
				pickUps.push(pickUp);
			}
		}
	}
		
		private function Control(e:KeyboardEvent):void {
			if(players[0] != null){
				if (e.keyCode == 87 && players[0].lastMoveDir != 3) {//w
					players[0].moveDir = 1;
				}
				if (e.keyCode == 68 && players[0].lastMoveDir != 4) {//d
					players[0].moveDir = 2;
				}
				if (e.keyCode == 83 && players[0].lastMoveDir != 1) {//s
					players[0].moveDir = 3;
				}
				if (e.keyCode == 65 && players[0].lastMoveDir != 2) {//a
					players[0].moveDir = 4;
				}
				if (e.keyCode == 81) {
					dropBlock(0, players[0].color);
				}
			}
			
			if(players[1] != null){
				if (e.keyCode == 38 && players[1].lastMoveDir != 3) {//up
					players[1].moveDir = 1;
				}
				if (e.keyCode == 39 && players[1].lastMoveDir != 4) {//right
					players[1].moveDir = 2;
				}
				if (e.keyCode == 40 && players[1].lastMoveDir != 1) {//down
					players[1].moveDir = 3;
				}
				if (e.keyCode == 37 && players[1].lastMoveDir != 2) {//left
					players[1].moveDir = 4;
				}
				if (e.keyCode == 13) {
					dropBlock(1, players[1].color);
				}
			}
		}
		
		private function checkColl():void {
			for (var i:int = 0; i < players.length; i++) 
			{
				if (players[i].lastPos.x < 0 || players[i].lastPos.x >= gameWidth ||
					players[i].lastPos.y < 0 || players[i].lastPos.y >= gameHeight)
					{
						//removeEventListener(Event.ENTER_FRAME, Update);
						resetPlayer(players[i],players[i].Id,players[i].squares.length - 2);
						break;
				}
				for (var o:int = 0; o < players[i].squares.length; o++) 
					{
						if (intersectsTest(players[i].square,players[i].squares[o]))
						{
							if (players[i].square != players[i].squares[o])
							{
								resetPlayer(players[i],players[i].Id,players[i].squares.length - 2);
								break;
							}
						}
				}
				for (var k:int = 0; k < pickUps.length; k++) 
				{
					if (intersectsTest(players[i].square, pickUps[k])) {
						if(pickUps[k].id == -1 || pickUps[k].id == players[i].Id){
							removeChild(pickUps[k]);
							pickUps.splice(k, 1);
							players[i].addBlock();
							trace("Player " + i + " has picked up a block and is now " + players[i].squares.length + " blocks long");
						}
						else {
							resetPlayer(players[i],players[i].Id,players[i].squares.length - 2);
							break;
						}
					}
				}
			}
		}
		
		private function drawWall():void {
			wallX = new Shape;
			wallX.graphics.beginFill(0x000000);
			wallX.graphics.drawRect(gameWidth, 0, wallWidth, gameHeight);
			wallX.graphics.endFill();
			addChild(wallX);
			
			wallY = new Shape;
			wallY.graphics.beginFill(0x000000);
			wallY.graphics.drawRect(0, gameHeight, gameWidth + wallWidth, wallWidth);
			wallY.graphics.endFill();
			addChild(wallY);
		}
		
		private function intersectsTest(obj1:DisplayObjectContainer,obj2:DisplayObjectContainer):Boolean {
			return obj1.getBounds(obj1.parent).intersects(obj2.getBounds(obj2.parent))
		}
	}
}
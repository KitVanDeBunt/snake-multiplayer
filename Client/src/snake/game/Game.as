package snake.game 
{
	import snake.net.Connection;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.display.Stage;
	import starling.display.DisplayObjectContainer;
	import starling.events.KeyboardEvent;
	import snake.menu.ScreenEvents;
	import snake.Main;
	import snake.game.Client;
	import snake.game.Texts;
	import feathers.data.ListCollection;
	import starling.display.Shape;
	import flash.geom.Vector3D;
	import starling.utils.Color;
	import snake.net.PlayerList;
	import snake.net.Player;
	import snake.utils.debug.Debug;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	
	 [SWF(width = "792", height = "792", frameRate = "30")]
	 
	public class Game extends Sprite 
	{
		private var playerAmount:int;
		private var startLength:int = 4;
		private var moveTime:int = 3;
		private var amountOfLines:int = 40;
		private var gridSnap:int = 11;
		
		//private var client:Client = new Client;
		private var TextScript:Texts = new Texts;
		public var gameWidth:int;
		private var gameHeight:int;
		private var pickUp:PickUp;
		private var player:Block;
		private var players:Vector.<Block> = new Vector.<Block>();
		private var pickUps:Array = new Array();
		private var timer:int;
		private var randomX:int;
		private var randomY:int;
		private var reset:Boolean = false;
		private var switchone:Boolean = true;
		private var countDownIndex:int = 0;
		private var wallX:Shape;
		private var wallY:Shape;
		public var wallWidth:int = 20;
		private var roundsLeft:int = 3;
		private var originalRoundsLeft:int;
		private var normalPickups:int = 0;
		private var con:Connection;
		private var press:Boolean = false;
	//	private var move:Boolean = true;
		
		public function Game() {
			//addEventListener(ScreenEvents.NEW_PLAYERLIST , menu);
			menu();
			//stage.scaleMode = StageScaleMode.EXACT_FIT;
			con = Connection.GetInstance();
		}
		
		private function menu():void {
			/*-get player playeramount, startlength,movetime,amountoflines, gridsnap.
			 */
			trace("menu");
			//removeEventListener(ScreenEvents.NEW_PLAYERLIST, menu);
			startCountDown();
			//addEventListener(KeyboardEvent.KEY_DOWN , startCountDown);
			//Main.eventManager.addEventListener(ScreenEvents.SERVER_PLAYER_POSITION_LIST, startCountDown);
		}
		
		private function startCountDown():void {
				trace("3!");
				addEventListener(EnterFrameEvent.ENTER_FRAME, countDown);
				removeEventListener(KeyboardEvent.KEY_DOWN, startCountDown);
		}
		
		private function countDown(e:EnterFrameEvent):void {
			countDownIndex++
			if (countDownIndex / 30 == 1) {
				trace("2!");
			}
			if (countDownIndex / 30 == 2) {
				trace("1!");
			}
			if (countDownIndex / 30 == 3) {
				addEventListener(Event.ENTER_FRAME, Update);
				startGame();
				addEventListener(KeyboardEvent.KEY_DOWN, Control);
				addEventListener(KeyboardEvent.KEY_UP, keyUp);
			}
		}
		
		private function startGame():void {
			addChild(TextScript);
			removeEventListener(EnterFrameEvent.ENTER_FRAME, countDown);
			countDownIndex = 0;
			originalRoundsLeft = roundsLeft;
			removeEventListener(KeyboardEvent.KEY_DOWN, startGame);
			gameWidth = amountOfLines * gridSnap;
			gameHeight = amountOfLines * gridSnap;
			
			playerAmount = PlayerList.players.length;
			
			trace("startgame players: "+playerAmount);
			
			for (var i:int = 0; i < playerAmount; i++) 
			{
					player = new Block();
				/*if (PlayerList.players[i].id == PlayerList.playerID){
						randomX = Math.floor(Math.random()/2 * amountOfLines)*(gameWidth/amountOfLines);
						randomY = Math.floor(Math.random() * amountOfLines) * (gameHeight / amountOfLines);
					}
				else{*/
						randomX = PlayerList.players[i].xPos * gridSnap;
						randomY = PlayerList.players[i].yPos * gridSnap;
					//}
					//randomX = 33;
					//randomY = PlayerList.players[i].id * gridSnap * 2 + 22;
					trace( "playerID:" + PlayerList.players[i].id);
					trace(PlayerList.players[i].xPos);
					player.Id = PlayerList.players[i].id;
					player.DrawSnake(randomX, randomY, startLength);
					addChild(player);
					players.push(player);
			}
			drawWall();
		}
		
		private function Update(e:Event):void {
			 /* - get other movedirections
			 */
			timer += 1;
			normalPickups = 0;
			for each (var thing:PickUp in pickUps) 
			{
				if (thing.id == -1) {
					normalPickups += 1;
				}
			}
			if (normalPickups == 0) {
				if (roundsLeft > 0) {
					//get pickup positions
					addPickUp(4);
				}
				else {
					ResetGame();
					endScreen();
					roundsLeft = originalRoundsLeft;
				}
				roundsLeft -= 1;
			}
			if (timer >= moveTime){
				if (reset == false) {
					for (var i:int = 0; i < PlayerList.playerCount; i++)
					{
						//item.moveDir = client.getDir();
						players[i].moveSnake(PlayerList.players[i].dir, i);
					}
					checkColl();
					TextScript.ShowScore("Rounds Left:"+ (roundsLeft + 1), gameWidth+wallWidth+60);
					timer = 0;
				}
			}
		}
		
		private function resetPlayer(Player:Block, playersIndex:int, length:int):void {
			/* - get new x,y somehow
			 */
			trace("reset");
			Player.removeSnake();
			player = new Block();
			randomX = 33;
			randomY = PlayerList.players[playersIndex].id * gridSnap;
			player.Id = playersIndex;
			player.moveDir = 2;
			player.DrawSnake(randomX, randomY, length);
			addChild(player);
			players[playersIndex] = player;
			con.dataSenderTCP.SendPlayerPosition(randomX, randomY);
			con.dataSenderTCP.SendPlayerDirection(getPlayerById(PlayerList.playerID).moveDir);
		}
		
		public function ResetGame():void {
			if (playerAmount > 1 ){
				if (players[0].squares.length == players[1].squares.length) {
					trace("tie game!");
				}
				if (players[0].squares.length > players[1].squares.length) {
					trace("player 0 won with " + players[0].squares.length + " blocks!");
				}
				else {
					trace("player 1 won with " + players[1].squares.length + " blocks!");
				}
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
			removeEventListener(KeyboardEvent.KEY_DOWN, Control);
			removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		private function endScreen():void {
			trace("endscreen");
			addEventListener(KeyboardEvent.KEY_DOWN, goToMenu);
		}
		
		private function goToMenu(e:KeyboardEvent):void {
			if (e.keyCode == 13) {
				removeEventListener(KeyboardEvent.KEY_DOWN, goToMenu);
				menu();
			}
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
			randomX = 110;
			randomY = 22 * i;
			/*get randomX & randomY from server*/
			if (randomX == 0 && randomY == 0 ||
				randomX == gameWidth - gridSnap && randomY == 0 ||
				randomX == 0 && randomY == gameHeight -gridSnap ||
				randomX == gameWidth -gridSnap && randomY == gameHeight -gridSnap) {
					removeChild(pickUp);
					Amount += 1;
			}
			else {
				pickUp.addPickUp(randomX, randomY, 0x000000);
				pickUps.push(pickUp);
			}
		}
	}
	
		private function keyUp(e:KeyboardEvent):void {
			press = false;
		}
		
		private function Control(e:KeyboardEvent):void {
			var me:Block = getPlayerById(PlayerList.playerID);
			if(me != null && press == false){
				if (e.keyCode == 87 && me.lastMoveDir != 3) {//w
					me.moveDir = 1;
				}
				if (e.keyCode == 68 && me.lastMoveDir != 4) {//d
					me.moveDir = 2;
				}
				if (e.keyCode == 83 && me.lastMoveDir != 1) {//s
					me.moveDir = 3;
				}
				if (e.keyCode == 65 && me.lastMoveDir != 2) {//a
					me.moveDir = 4;
				}
				if (e.keyCode == 81) {
					dropBlock(me.Id, me.color);
				}
				con.dataSenderTCP.SendPlayerDirection(me.moveDir);
				con.dataSenderTCP.SendPlayerPosition(me.lastPos.x/11, me.lastPos.y/11);
				press = true;
				//move = true;
				/* - send dropblock
				 */
			}
		}
		
		private function getPlayerById(id:int):Block {
			for (var i:int = 0; i < players.length; i++) {
				if (id == players[i].Id) {
					return players[i];
				}
			}
			throw Error("player not found");
			return players[0];
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
								trace("hit");
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
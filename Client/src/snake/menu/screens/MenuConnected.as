package snake.menu.screens 
{
	import feathers.controls.Alert;
	import feathers.controls.ButtonGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import snake.net.Connection
	import snake.net.Player;
	import snake.net.PlayerList;
	import starling.display.Sprite;
	import starling.events.Event;
	import snake.menu.ScreenEvents;
	import snake.Main;
	import snake.utils.debug.Debug;
	import feathers.core.PopUpManager;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class MenuConnected extends Screen
	{
		private var buttonGroup:ButtonGroup;
		private var playerList:List;
		private var con:Connection;
		private var playerListCollection:ListCollection;
		
		private var menuConected:ListCollection ;
		
		public function MenuConnected() 
		{
			con = Connection.GetInstance();
		}
		
		override protected function initialize():void {
			con = Connection.GetInstance();
			
			BuildPlayerList();
			
			BuildButtons();
			
			Main.eventManager.addEventListener(ScreenEvents.NEW_PLAYERLIST, newPlayerList);
			Main.eventManager.addEventListener(ScreenEvents.SERVER_ERROR_RECIEVED, serverErrorRecieved);
			Main.eventManager.addEventListener(ScreenEvents.SERVER_GAME_START, serverStartGame);
		}
		
		private function serverErrorRecieved():void {
			/*var popShape:Shape = new Shape();
			popShape.graphics.drawRect( -100, -50, 200, 100);
			PopUpManager.addPopUp( popShape, true, true );*/
			SpawnAlert("server Error Recieved");
		}
		
		private function SpawnAlert(message:String):void {
			var alert:Alert = Alert.show(message, "Warning", new ListCollection(
			[
				{ label: "OK", triggered: removeAlert }
			]) );
		}
		
		private function removeAlert(e:Event):void {
			
		}
		
		private function BuildButtons():void {
			Main.debug.print("[build buttons]",Debug.Menu_1);
			if(buttonGroup ==null){
				buttonGroup = new ButtonGroup();
				addChild(buttonGroup);
			}
			if (PlayerList.isAdmin)
			{
				menuConected = new ListCollection([
					{ label: "Ping", triggered: OnButtonPing },
					{ label: "Start Game", triggered: OnButtonPlay },
					{ label: "Ready", triggered: OnButtonReady },
					{ label: "Disconnect", triggered: OnButtonDisconnect }
				]);
			}
			else {
				menuConected = new ListCollection([
					{ label: "Ping", triggered: OnButtonPing },
					{ label: "Ready", triggered: OnButtonReady },
					{ label: "Disconnect", triggered: OnButtonDisconnect }
				]);
			}
			buttonGroup.dataProvider = menuConected;
		}
		
		private function BuildPlayerList():void {
			Main.debug.print("[build player list]",Debug.Menu_1);
			BuildButtons();
			
			var items:Array = [];
			var player:Player;
			var showingTxt:String;
			if (playerList != null) {
				removeChild(playerList);
			}
			playerList = new List();
			items = [];
			if (playerList != null) {
				for(var i:int = 0; i < PlayerList.playerCount; i++)
				{
					
					player = PlayerList.player(i);
					/*if (player.id == PlayerList.playerID) {
						player = PlayerList.player;
					}*/
					showingTxt = player.name;
					if (player.id == PlayerList.playerID) {
						showingTxt += ("(ME)");
					}else {
						showingTxt += ("(00)");
					}
					if (player.isReady){
						showingTxt += ("(    Ready)");
					}
					else {
						showingTxt += ("(Not Ready)");
					}
					showingTxt += (" id:"+PlayerList.player(i).id+" ")
					if (player.isAdmin){
						showingTxt += "(admin)";
					}else {
						showingTxt += "(no admin)";
					}
					var item:Object = {text: showingTxt};
					items[i] = item;
					//items.push(item);
				}
				items.fixed = true;
				
				playerList.dataProvider = new ListCollection(items);
			}
			
			playerList.dataProvider = new ListCollection(items);
			playerList.width = 250;
			playerList.x = 250;
			playerList.y = 50;
			playerList.height = 700;
			
			playerList.isSelectable = false;
			playerList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.isQuickHitAreaEnabled = true;
				renderer.labelField = "text";
				//renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
				return renderer;
			};
			addChild(playerList);
			
		}
		
		private function OnButtonPing(e:Event):void { 		
			dispatchEventWith( ScreenEvents.PING ) 
		};
		
		private function newPlayerList(e:Event):void { 	
			Main.debug.print("[newPlayerList]",Debug.Menu_1);
			BuildPlayerList();
		}
		
		private function OnButtonPlay(e:Event):void { 		
			if(PlayerList.playersReady()){
				dispatchEventWith( ScreenEvents.PLAY_BUTTON );
				con.dataSenderTCP.SendAdminStart();
			}else {
				SpawnAlert("[Client]players not ready");
			}
		}
		
		private function serverStartGame(e:Event):void {
			dispatchEventWith( ScreenEvents.PLAY );
		}
		
		private function OnButtonDisconnect(e:Event):void {	
			Main.eventManager.removeEventListener(ScreenEvents.NEW_PLAYERLIST, newPlayerList);
			Main.eventManager.removeEventListener(ScreenEvents.SERVER_ERROR_RECIEVED, serverErrorRecieved);
			dispatchEventWith( ScreenEvents.DISCONNECT );
		}
		
		private function OnButtonReady(e:Event):void {
			con.dataSenderTCP.SendPlayerReady(!PlayerList.thisPlayer.isReady);
		}
	}
}
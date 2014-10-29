package snake.menu.screens 
{
	import feathers.controls.ButtonGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
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
			var items:Array = [];
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
		
		private function OnButtonPing(e:Event):void { 		dispatchEventWith( ScreenEvents.PING ) };
		
		private function newPlayerList(e:Event):void { 	
			Main.debug.print("[newPlayerList]",Debug.Menu_1);
			BuildPlayerList();
		};
		private function OnButtonPlay(e:Event):void { 		dispatchEventWith( ScreenEvents.PLAY ) };
		private function OnButtonDisconnect(e:Event):void {	
			Main.eventManager.removeEventListener(ScreenEvents.NEW_PLAYERLIST, newPlayerList);
			dispatchEventWith( ScreenEvents.DISCONNECT ) 
		};
		private function OnButtonReady(e:Event):void {
			con.SendPlayerReady(!PlayerList.thisPlayer.isReady);
		}
	}

}
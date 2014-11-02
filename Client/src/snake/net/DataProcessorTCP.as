package snake.net 
{
	import flash.net.Socket;
	import snake.Main;
	import snake.utils.debug.Debug;
	import flash.utils.ByteArray;
	import starling.events.Event;
	import snake.menu.ScreenEvents;
	
	public class DataProcessorTCP 
	{
		private var socket_:Socket;
		public function DataProcessorTCP(socket:Socket) 
		{
			socket_ = socket;
		}
		
		public function ProcessPlayerList(_bytes:ByteArray):void {
				
				var listLength:int = _bytes.readInt();
				PlayerList.Init();
				Main.debug.print(("[Set Player List] Length:" + listLength) , Debug.Server_2);
				
				var nameL:int;
				var id:int = 0;
				var dir:int = 0;
				for (var j:int = 0; j < listLength; j++) 
				{
					//gettting name
					var name:String = new String();
					id = _bytes.readByte(); // renable when bug is fixed
					nameL = _bytes.readInt();
					
					Main.debug.print("[Set Player List] Name Length: " + nameL, Debug.Server_2);
					
					for (var i:int = 0; i < nameL; i++) 
					{
						var newLLetter:String = String.fromCharCode(_bytes.readUnsignedByte());
						name = name+newLLetter ;
					}
					
					PlayerList.add(new Player(name,dir,id));
					Main.debug.print(("[Set Player List] Player: " + name + " ID: " + id) , Debug.Server_2);	
				}
				Main.eventManager.dispatchEvent(new starling.events.Event( ScreenEvents.NEW_PLAYERLIST ));
			}
			
			public function ProcessDirections(_bytes:ByteArray):void {
				var listLength:int = _bytes.readInt();
				var data:Vector.<Player> = new Vector.<Player>();
				
				var id:int;
				var dir:int;
				for (var i:int = 0; i < listLength; i++) 
				{
					id = _bytes.readByte();
					dir = _bytes.readByte();
					
					data.push(new Player("", dir, id));
				}
				
				for (var j:int = 0; j < PlayerList.playerCount; j++) 
				{
					for (var k:int = 0; k < data.length; k++) 
					{
						if (PlayerList.player(j).id == data[k].id) {
							PlayerList.player(j).dir = data[k].dir;
							return;
						}
					}
				}
			}
			
			public function ProcessPlayerListUpdate(_bytes:ByteArray):void {
				var listLength:int = _bytes.readInt();
				var listId:Vector.<int> = new Vector.<int>();
				var listReady:Vector.<Boolean> = new Vector.<Boolean>();
				
				for (var i:int = 0; i < listLength; i++) 
				{
					listId.push(_bytes.readByte());
					listReady.push(_bytes.readBoolean());
				}
				
				for (var j:int = 0; j < listId.length; j++) 
				{
					for (var k:int = 0; k < PlayerList.playerCount; k++) 
					{
						if (listId[j] == PlayerList.player(k).id) {
							PlayerList.player(k).isReady = listReady[j];
						}
					}
				}
				Main.eventManager.dispatchEvent(new starling.events.Event( ScreenEvents.NEW_PLAYERLIST ));
			}
			
			public function ProcessPlayerIsAdmin(_bytes:ByteArray):void {
				PlayerList.adminID = _bytes.readByte();
				
				Main.debug.print("[ProcessPlayerIsAdmin] Admin    : " + PlayerList.isAdmin, Debug.Server_2);
				Main.debug.print("[ProcessPlayerIsAdmin] idAdmin  : " + PlayerList.adminID, Debug.Server_2);
				Main.debug.print("[ProcessPlayerIsAdmin] playerid : " + PlayerList.playerID, Debug.Server_2);
				
				
				Main.eventManager.dispatchEvent(new starling.events.Event( ScreenEvents.NEW_PLAYERLIST ));
				//playerId = true;
				//Main.debug.print(("[playerIsAdmin]: "+playerSelf.isAdmin+" id:"+playerSelf.id+" idAdminID:"+idAdmin) , Debug.Server_2);
			}
			
			public function ProcessServerError(_bytes:ByteArray):void {
				var stringlength:int = _bytes.readInt();
				var msg:String = new String();
				
				for (var i:int = 0; i < stringlength; i++) {
					msg += String.fromCharCode(_bytes.readUnsignedByte);
				}
				Main.debug.print("[ProcessServerError]:" +msg,Debug.Server_2);
			}
			//sending to the server
			public function ProcessNewPlayerDir(_bytes:ByteArray):void {
				var dir:int = _bytes.readByte();
			}
	}
}
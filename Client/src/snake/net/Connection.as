
package snake.net 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.events.OutputProgressEvent;
	import snake.menu.ScreenEvents;
	import snake.utils.debug.Debug;
	import snake.Main;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.themes.AeonDesktopTheme;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import snake.net.Connection;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.text.TextField;
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import snake.net.MessageType;
	import snake.utils.debug.Debug;
	import snake.BitUtil;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Connection {
		
			static public const port:int = 11100;
			//static public const address:String = "192.168.0.101";
			//static public const address:String = "84.80.98.251";
			static public const address:String = "127.0.0.1";
			private var socket_:Socket;
			private var pingTime:Number;
			private var currentTime:Date;
			
			private var clientName:String;
			
			//public var playerSelf:Player = new Player("", -1, -1);
			//public var playerId:int;
			
			public var GameStart:Boolean;
			
			public function get socket():Socket {
				return socket_;
			}
			
			private static var _instance:Connection = null;
			private static function CreateKey():void { }
			
			public function Connection(key:Function = null){
				if (key != CreateKey) {
					throw new Error("Creation of Conection without calling GetInstance is not valid");
				}
				createSocket();
			}
			
			public static function GetInstance():Connection {
				if (_instance == null) {
					_instance = new Connection(CreateKey);
				}
				return _instance;
			}
			
			public function WriteBytes(_bytes:ByteArray):void {
				socket_.writeBytes(_bytes);
				socket_.flush();
			}
			
			public function Connect(name:String, ip:String = address):void {
				
				socket_.connect(ip, port);
				
				clientName = name;
				socket_.timeout = 2000;
				PlayerList.Init();
				Main.debug.print(("[client Timeout]:"+socket_.timeout.toString()+"ms"),Debug.Server_2);
			}
			
			public function DisConnect():void {
				if(socket_.connected){
					socket_.close();
					socket_.dispatchEvent(new Event(Event.CLOSE));
					Main.debug.print(("[State]DisConnect"), Debug.Server_2);
				}else {
					Main.debug.print(("[State]Not Connected Cannot Disconnect"), Debug.Server_2);
				}
			}
			
			private function createSocket():void {   
				Main.debug.print(("[State]createSocket addres"), Debug.Server_2);
				//Main.debug.print(("[State]createSocket addres>" + address + "<"), Debug.Server_2);
				
				socket_ = new Socket();
				
				socket_.addEventListener(Event.CONNECT,onConnected);
				socket_.addEventListener(ProgressEvent.SOCKET_DATA, onData);
				socket_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				socket_.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				socket_.addEventListener(Event.CLOSE, onClose);
				socket_.addEventListener(Event.DEACTIVATE, onDeactivate);
				socket_.addEventListener(Event.ACTIVATE, onActivate);
				socket_.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				socket_.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onDataOut);
				
				
				/*
				if(socket.connected){
					Main.debug.print(("Connected"), Debug.Server_2);
				}else {
					Main.debug.print(("Not Connected"), Debug.Server_2);
				}
				*/
			}
			
			private function onDataOut(e:OutputProgressEvent):void {
				Main.debug.print("[State]onDataOut",Debug.Server_2);
			}
			private function onClose(e:Event):void {
				Main.debug.print("[State]onClose",Debug.Server_2);
			}
			private function onDeactivate(e:Event):void {
				Main.debug.print("[State]onDeactivate",Debug.Server_1);
			}
			private function onActivate(e:Event):void {
				Main.debug.print("[State]onActivate",Debug.Server_1);
			}
			private function onSecurityError(e:SecurityErrorEvent):void {
				Main.debug.print("[State]onSecurityError",Debug.Server_2);
			}
			private function onIOError(e:IOErrorEvent):void {
				Main.debug.print("[State]IOErrorEvent",Debug.Server_2);
			}
			
			private function onConnected(e:Event):void {
				Main.debug.print("client - socket connected",Debug.Server_2);
				
				SendPlayerSetName(clientName);
			}
			
			private function onData(e:ProgressEvent):void {
				
				Main.debug.print(("") , Debug.Server_2);
				Main.debug.print(("[On Data]Process Packege") , Debug.Server_2);
				
				var bytes:ByteArray = new ByteArray;
				bytes.endian = Endian.LITTLE_ENDIAN;
				socket_.readBytes(bytes);
				
				var messageNum:int = 0;
				
				while (bytes.bytesAvailable > 0) {
					messageNum++;
					var messageLength:int = bytes.readInt();
					var messageType:int = bytes.readByte();
					
					
					Main.debug.print(("") , Debug.Server_2);
					Main.debug.print(("[Message]Num:" + messageNum + " Type: " + messageType+" L: " + messageLength) , Debug.Server_2);
					
					
					switch(messageType) {
						case MessageType.PING_BACK:
							currentTime = new Date();
							var thisPingTime:Number = currentTime.time-pingTime;
							Main.debug.print(("[Message]Ping: " + thisPingTime + "ms") , Debug.Server_2);
							break;
							
						case MessageType.HELLO:
							Main.debug.print(("[Message]MessageType.HELLO") , Debug.Server_2);
							break;
							
						case MessageType.PLAYER_LIST:
							Main.debug.print(("[Message]MessageType.PLAYER_LIST") , Debug.Server_2);
							ProcessPlayerList(bytes);
							break;
							
						case MessageType.PLAYER_DIRECTION_LIST:
							Main.debug.print(("[Message]MessageType.PLAYER_DIRECTION_LIST") , Debug.Server_2);
							ProcessNewPlayerDir(bytes)
							break;
							
						case MessageType.PLAYER_IS_ADMIN:
							Main.debug.print(("[Message]MessageType.PLAYER_IS_ADMIN") , Debug.Server_2);
							ProcessPlayerIsAdmin(bytes);
							break;
							
						case MessageType.PLAYER_SET_ID:
							PlayerList.playerID = bytes.readByte();
							Main.debug.print(("[Message]MessageType.PLAYER_SET_ID :"+PlayerList.playerID) , Debug.Server_2);
							break;
							
						case MessageType.PLAYER_LIST_UPDATE:
							Main.debug.print(("[Message]MessageType.PLAYER_LIST_UPDATE") , Debug.Server_2);
							ProcessPlayerListUpdate(bytes);
							break;
							
						case MessageType.GAME_START:
							Main.debug.print(("[Message]MessageType.GAME_START") , Debug.Server_2);
							GameStart = true;
							break;
							
						case MessageType.SERVER_ERROR:
							Main.debug.print(("[Message]MessageType.SERVER_ERROR") , Debug.Server_2);
							ProcessServerError(bytes);
							break;
				   }
				}
			}
			
			
			public function SendPing():void {
				trace("[Ping]connected :"+socket_.connected);
				var messageData:ByteArray = new ByteArray();
				messageData.endian = Endian.LITTLE_ENDIAN;
				
				var messageL:int = 5;
				messageData.writeInt(messageL);
				
				var messageType:int = MessageType.PING;
				messageData.writeByte(messageType);
				
				socket_.writeBytes(messageData);
				socket_.flush();
				currentTime = new Date();
				pingTime = currentTime.time;
				trace("[Ping]pingTime : "+pingTime);
			}
			
			private function SendPlayerSetName(name:String):void {
				trace("[Player Set Name]connected:"+socket_.connected);
				trace("[Player Set Name]PLAYER_SET_NAME");
				var messageData:ByteArray = new ByteArray();
				messageData.endian = Endian.LITTLE_ENDIAN;
				
				var playerName:String = name;
				//playerSelf.name = name;
				
				var messageL:int = 5+playerName.length;
				messageData.writeInt(messageL);
				
				var messageType:int = MessageType.PLAYER_SET_NAME;
				messageData.writeByte(messageType);
				
				messageData.writeInt(playerName.length);
				
				BitUtil.stringToByteArray(playerName, messageData);
				
				socket_.writeBytes(messageData);
				socket_.flush();
			}
			
			private function ProcessPlayerList(_bytes:ByteArray):void {
				
				var listLength:int = _bytes.readInt();
				PlayerList.players = new Vector.<Player>();
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
					
					PlayerList.players.push(new Player(name,dir,id));
					Main.debug.print(("[Set Player List] Player: " + name + " ID: " + id) , Debug.Server_2);	
				}
				Main.eventManager.dispatchEvent(new starling.events.Event( ScreenEvents.NEW_PLAYERLIST ));
			}
			
			private function ProcessDirections(_bytes:ByteArray):void {
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
				
				for (var j:int = 0; j < PlayerList.players.length; j++) 
				{
					for (var k:int = 0; k < data.length; k++) 
					{
						if (PlayerList.players[j].id == data[k].id) {
							PlayerList.players[j].dir = data[k].dir;
							return;
						}
					}
				}
			}
			
			private function ProcessPlayerListUpdate(_bytes:ByteArray):void {
				var listLength:int = _bytes.readInt();
				var data:Vector.<Object> = new Vector.<Object>();
				
				var obj:Object;
				for (var i:int = 0; i < listLength; i++) 
				{
					obj = new Object();
					
					obj.id = _bytes.readByte();
					obj.ready = _bytes.readBoolean();
					
					data.push(obj);
				}
				
				for (var j:int = 0; j < data.length; j++) 
				{
					for (var k:int = 0; k < PlayerList.players.length; k++) 
					{
						if (data[j].id == PlayerList.players[k].id) {
							PlayerList.players[k].isReady = data[j].ready;
						}
					}
				}
				Main.eventManager.dispatchEvent(new starling.events.Event( ScreenEvents.NEW_PLAYERLIST ));
			}
			
			private function ProcessPlayerIsAdmin(_bytes:ByteArray):void {
				PlayerList.adminID = _bytes.readByte();
				Main.debug.print("[ProcessPlayerIsAdmin] idAdmin: " + PlayerList.adminID, Debug.Server_2);
				Main.eventManager.dispatchEvent(new starling.events.Event( ScreenEvents.NEW_PLAYERLIST ));
				//playerId = true;
				//Main.debug.print(("[playerIsAdmin]: "+playerSelf.isAdmin+" id:"+playerSelf.id+" idAdminID:"+idAdmin) , Debug.Server_2);
			}
			
			private function ProcessServerError(_bytes:ByteArray):void {
				var stringlength:int = _bytes.readInt();
				var msg:String = new String();
				
				for (var i:int = 0; i < stringlength; i++) {
					msg += String.fromCharCode(_bytes.readUnsignedByte);
				}
			}
			//sending to the server
			public function ProcessNewPlayerDir(_bytes:ByteArray):void {
				var dir:int = _bytes.readByte();
			}
			
			public function SendPlayerReady(value:Boolean = false):void {
				//send bool player ready to server
				
				PlayerList.player.isReady = value;
				
				var messageLength:int = 6;
				
				var bytes:ByteArray = new ByteArray();
				bytes.endian = Endian.LITTLE_ENDIAN;
				
				bytes.writeInt(messageLength);
				bytes.writeByte(MessageType.PLAYER_READY);
				
				if (value)
				{
					bytes.writeByte(1);
				}
				else
				{
					bytes.writeByte(0);
				}
				
				WriteBytes(bytes);
				socket_.flush();
			}
			
			public function SendAdminStart(value:Boolean = false):void {
			var messageLength:int = 5;
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeInt(messageLength);
			bytes.writeByte(MessageType.ADMIN_START);
			
			WriteBytes(bytes);
		}
	}
}
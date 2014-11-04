
package snake.net 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.events.OutputProgressEvent;
	import snake.menu.ScreenEvents;
	import snake.utils.debug.Debug;
	import snake.Main;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import starling.events.StarlingEvent;
	
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Connection {
		
		static public const port:int = 4000;
		static public const address:String = "127.0.0.1";
		private var socket_:Socket;
		
		private var clientName:String;
		
		//public var playerSelf:Player = new Player("", -1, -1);
		//public var playerId:int;
		
		private var dataProcessorTCP:DataProcessorTCP;
		public var dataSenderTCP:DataSenderTCP;
		
		public function get socket():Socket {
			return socket_;
		}
		
		private static var _instance:Connection = null;
		private static function CreateKey():void { }
		
		public function Connection(key:Function = null){
			if (key != CreateKey) {
				throw new Error("Creation of Conection without calling GetInstance is not valid");
			}
			
		}
		
		public static function GetInstance():Connection {
			if (_instance == null) {
				_instance = new Connection(CreateKey);
				Main.debug.print("[new instance]!!!!!!!!!!!!!!!!!!!!!!!!!",Debug.Server_2);
			}
			return _instance;
		}
		
		public function Connect(name:String, ip:String = address):void {
			createSocket();
			
			trace("connected:" + socket_.connected);
			socket_.connect(ip, port);
			
			clientName = name;
			socket_.timeout = 2000;
			PlayerList.Init();
			Main.debug.print(("[client Timeout]:"+socket_.timeout.toString()+"ms"),Debug.Server_2);
		}
		
		public function DisConnect():void {
			if (socket_.connected) {
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
			dataProcessorTCP = new DataProcessorTCP(socket_);
			dataSenderTCP = new DataSenderTCP(socket_);
			
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
			Main.debug.print("[------------------------------------------]",Debug.Server_2);
			Main.debug.print("client - socket connected",Debug.Server_2);
			Main.debug.print("[------------------------------------------]",Debug.Server_2);
			
			dataSenderTCP.SendPlayerSetName(clientName);
		}
		
		private function onData(e:ProgressEvent):void {
			
			Main.debug.print(("") , Debug.Server_3);
			Main.debug.print(("[On Data]Process Packege") , Debug.Server_3);
			
			var bytes:ByteArray = new ByteArray;
			bytes.endian = Endian.LITTLE_ENDIAN;
			socket_.readBytes(bytes);
			
			var messageNum:int = 0;
			
			while (bytes.bytesAvailable > 0) {
				messageNum++;
				var messageLength:int = bytes.readInt();
				var messageType:int = bytes.readByte();
				
				
				Main.debug.print(("") , Debug.Server_3);
				Main.debug.print(("[Message]Num:" + messageNum + " Type: " + messageType+" L: " + messageLength) , Debug.Server_3);
				
				
				switch(messageType) {
					case MessageType.PING_BACK:
						dataSenderTCP.currentTime = new Date();
						var thisPingTime:Number = dataSenderTCP.currentTime.time-dataSenderTCP.pingTime;
						Main.debug.print(("[Message]Ping: " + thisPingTime + "ms") , Debug.Server_2);
						break;
						
					case MessageType.HELLO:
						Main.debug.print(("[Message]MessageType.HELLO") , Debug.Server_2);
						break;
						
					case MessageType.PLAYER_LIST:
						Main.debug.print(("[Message]MessageType.PLAYER_LIST") , Debug.Server_2);
						dataProcessorTCP.ProcessPlayerList(bytes);
						break;
						
					case MessageType.PLAYER_DIRECTION_LIST:
						Main.debug.print(("[Message]MessageType.PLAYER_DIRECTION_LIST") , Debug.Server_3);
						dataProcessorTCP.ProcessDirections(bytes)
						break;
						
					case MessageType.PLAYER_POSITION_LIST:
						Main.debug.print(("[Message]MessageType.PLAYER_POSITION_LIST") , Debug.Server_2);
						dataProcessorTCP.ProcessPlayerPositions(bytes)
						break;
						
					case MessageType.PLAYER_IS_ADMIN:
						Main.debug.print(("[Message]MessageType.PLAYER_IS_ADMIN") , Debug.Server_2);
						dataProcessorTCP.ProcessPlayerIsAdmin(bytes);
						break;
						
					case MessageType.PLAYER_SET_ID:
						PlayerList.playerID = bytes.readByte();
						Main.debug.print(("[Message]MessageType.PLAYER_SET_ID :"+PlayerList.playerID) , Debug.Server_2);
						break;
						
					case MessageType.PLAYER_LIST_UPDATE:
						Main.debug.print(("[Message]MessageType.PLAYER_LIST_UPDATE") , Debug.Server_2);
						dataProcessorTCP.ProcessPlayerListUpdate(bytes);
						break;
						
					case MessageType.GAME_START:
						Main.debug.print(("[Message]MessageType.GAME_START") , Debug.Server_2);
						Main.eventManager.dispatchEvent((new StarlingEvent(ScreenEvents.SERVER_GAME_START)));
						break;
						
					case MessageType.SERVER_ERROR:
						Main.debug.print(("[Message]MessageType.SERVER_ERROR") , Debug.Server_2);
						dataProcessorTCP.ProcessServerError(bytes);
						break;
			   }
			}
		}
	}
}
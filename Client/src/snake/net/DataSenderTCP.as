package snake.net 
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import snake.Main;
	import flash.utils.Endian;
	import snake.BitUtil;
	import snake.utils.debug.Debug
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class DataSenderTCP 
	{
		
		public var pingTime:Number;
		public var currentTime:Date;
		
		private var socket_:Socket;
		
		public function DataSenderTCP(socket:Socket) 
		{
			socket_ = socket;
		}
		
		private function WriteBytes(_bytes:ByteArray):void {
			socket_.writeBytes(_bytes);
			socket_.flush();
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
		
		public function SendPlayerSetName(name:String):void {
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
		
		public function SendPlayerReady(value:Boolean):void {
			//send bool player ready to server
			
			//PlayerList.thisPlayer.isReady = value;
			
			var messageLength:int = 6;
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeInt(messageLength);
			bytes.writeByte(MessageType.PLAYER_READY);
			
			Main.debug.print(("SendPlayerReady:" + value), Debug.Server_2);
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
		
		public function SendAdminStart():void {
			var messageLength:int = 5;
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeInt(messageLength);
			bytes.writeByte(MessageType.ADMIN_START);
			
			WriteBytes(bytes);
		}
	}
}
package  
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class NewClient extends EventDispatcher
	{
		private var sock:Socket;
		public function NewClient(e:ServerSocketConnectEvent) {
			sock = e.socket;
			e.socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
		}
		
		private function onData(e:ProgressEvent):void {
			sock.writeUTFBytes('<cross-domain-policy><allow-access-from domain="*" to-ports="11100" /></cross-domain-policy>');
			sock.writeByte(0);
			sock.flush();
			sock.close();
			dispatchEvent(new Event(ClientEvents.DATA_SEND));
		}
	}

}
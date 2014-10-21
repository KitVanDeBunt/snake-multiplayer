package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class Main extends Sprite {
		private var sock:ServerSocket;
		private var texts:Vector.<TextField>;
		private var date:Date;
		
		private var clients:Vector.<NewClient>;
		
		public function Main():void {
			texts = new Vector.<TextField>();
			clients = new Vector.<NewClient>();
			sock = new ServerSocket();
			sock.addEventListener(ServerSocketConnectEvent.CONNECT, OnConnect);
			sock.bind(843);
			sock.listen();
			
			if (!sock.listening || !sock.bound){
				Print("Cannot start");
			}else {
				Print("started port: 843");
			}
		}
		
		private function UpdatePrintList():void {
			for (var i:int = texts.length-1; i > -1; i--) {
				texts[i].y -= 20;
				if (texts[i].y < 0) {
					removeChild(texts[i]);
					texts.splice(i, 1);
				}
			}
		}
		
		private function Print(text:String):void {
			date = new Date();
			
			var nexText:TextField = new TextField();
			nexText.textColor = 0xffffff;
			nexText.text = "["+date.toLocaleTimeString()+":"+date.getMilliseconds()+"]"+text;
			nexText.y = stage.stageHeight;
			nexText.width = stage.stageWidth;
			addChild(nexText);
			texts.push(nexText);
			UpdatePrintList();
		}
		
		private function OnConnect(e:ServerSocketConnectEvent):void {
			Print("new connect");
			clients.push(new NewClient(e).addEventListener(ClientEvents.DATA_SEND,dataSend));
		}
		
		private function dataSend(e:Event):void {
			for (var i:int = 0; i < clients.length; i++) {
				if (e.target == clients[i]) {
					clients.splice(i, 1);
					Print("socked removed");
				}
			}
			
		}
	}
}
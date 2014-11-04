package snake.game
{
	import starling.display.Shape;
	import starling.display.Sprite;
	import flash.geom.Vector3D;
	import starling.utils.Color;
	import snake.net.Connection;
	
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	 
	public class Block extends Sprite
	{
		public var Id:int = -1;
		
		public var square:Shape;
		public var squares:Array = new Array();
		public var lastPos:Vector3D;
		
		public var moveDir:int = 2;
		public var lastMoveDir:int = 2;
		
		public var color:uint;
		private var con:Connection;
		//1 = up
		//2 = right
		//3 = down
		//4 = left
		 
		public function DrawSnake(PosX:int, PosY:int, length:int):void 
		{
			if (length <= 0) {
				length = 1;
			}
			for (var i:int = 0; i < length; i++) {
				square = new Shape();
				square.graphics.beginFill(checkColor(Id));
				square.graphics.drawRect(PosX + (11*i),PosY,10,10);
				square.graphics.endFill();
				addChild(square);
				squares.push(square);
				lastPos = new Vector3D(PosX + (11*i), PosY, length, 0);
			}
			con = Connection.GetInstance();
			con.dataSenderTCP.SendPlayerPosition(PosX, PosY);
		}
		
		public function removeSnake():void {
			for each (var item:Shape in squares) 
			{
				removeChild(item);
			}
			squares.splice(0, squares.length);
		}
		
		private function checkColor ( Id:int): uint {
			if (Id == 0) {
				color = 0xFF0000;
			}
			if (Id == 1) {
				color = 0x00FF00;
			}
			if (Id == 2) {
				color = 0x0000FF;
			}
			return color
		}
		
		public function addBlock(dir:int):void {
			switch(dir) {
				/*up*/case 1:
					lastPos.y = lastPos.y -= 11;
					break;
				/*right*/case 2:
					lastPos.x = lastPos.x += 11;
					break;
				/*down*/case 3:
					lastPos.y = lastPos.y += 11;
					break;
				/*left*/case 4:
					lastPos.x = lastPos.x -= 11;
					break;
			}
			square = new Shape();
			square.graphics.beginFill(checkColor(Id));
			//square.graphics.drawRect(lastPos.x,lastPos.y,10,10);
			square.x = lastPos.x;
			square.y = lastPos.y;
			square.graphics.drawRect(0, 0, 10, 10);
			square.graphics.endFill();
			addChild(square);
			squares.push(square);
		}
		
		public function moveSnake(dir:int):void {
			removeChild(squares[0]);
			squares.splice(0, 1);
			switch(dir) {
				/*up*/case 1:
					lastPos.y = lastPos.y -= 11;
					break;
				/*right*/case 2:
					lastPos.x = lastPos.x += 11;
					break;
				/*down*/case 3:
					lastPos.y = lastPos.y += 11;
					break;
				/*left*/case 4:
					lastPos.x = lastPos.x -= 11;
					break;
			}
			lastMoveDir = moveDir;
			square = new Shape();
			square.graphics.beginFill(checkColor(Id));
			//square.graphics.drawRect(lastPos.x, lastPos.y, 10, 10);
			square.x = lastPos.x;
			square.y = lastPos.y;
			square.graphics.drawRect(0, 0, 10, 10);
			square.graphics.endFill();
			addChild(square);
			squares.push(square);
		}
		
		public function removeLastBlock():void {
			removeChild(squares[0]);
			squares.splice(0, 1);
		}
	}
}
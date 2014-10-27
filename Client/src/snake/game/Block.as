package snake.game
{
	import starling.display.Shape;
	import starling.display.Sprite;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Tom Verkerk
	 */
	 
	public class Block extends Sprite
	{
		public var Id:int;
		
		public var square:Shape;
		public var squares:Array = new Array();
		public var lastPos:Vector3D;
		public var pressed:Boolean = false;
		
		public var moveDir:int = 2;
		//1 = up
		//2 = right
		//3 = down
		//4 = left
		 
		public function DrawSnake(PosX:int, PosY:int, length:int):void 
		{
			for (var i:int = 0; i < length; i++) {
				square = new Shape();
				square.graphics.beginFill(0x000000);
				square.graphics.drawRect(PosX + (11*i),PosY,10,10);
				square.graphics.endFill();
				addChild(square);
				squares.push(square);
				lastPos = new Vector3D(PosX + (11*i), PosY, length, 0);
			}
		}
		
		public function addBlock():void {
			switch(moveDir) {
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
			square.graphics.beginFill(0x000000);
			square.graphics.drawRect(lastPos.x,lastPos.y,10,10);
			square.graphics.endFill();
			addChild(square);
			squares.push(square);
		}
		
		public function moveSnake():void {
			removeChild(squares[0]);
			squares.splice(0, 1);
			switch(moveDir) {
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
			square.graphics.beginFill(0x000000);
			square.graphics.drawRect(lastPos.x, lastPos.y, 10, 10);
			square.graphics.endFill();
			addChild(square);
			squares.push(square);
		}
	}
}
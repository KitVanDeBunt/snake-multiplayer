package starling.events
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Kit van de Bunt
	 */
	public class StarlingEvent extends Event
	{
		public function StarlingEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
		}
	}
}
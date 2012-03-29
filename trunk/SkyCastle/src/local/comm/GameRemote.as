package local.comm
{
	import bing.amf3.FaultEvent;
	import bing.amf3.RemoteObject;
	
	/**
	 * AMF3通信基类 
	 * @author zzhanglin
	 */	
	public class GameRemote extends RemoteObject
	{
		public static var gateWay:String = "" ;
		
		public function GameRemote(servicePath:String)
		{
			super(gateWay, servicePath);
			this.addEventListener( FaultEvent.FAULT , onFaultHandler );
		}
		
		private function onFaultHandler( e:FaultEvent ):void
		{
			trace(e.faultObj );
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.removeEventListener( FaultEvent.FAULT , onFaultHandler );
		}
	}
}
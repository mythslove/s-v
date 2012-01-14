package comm
{
	import bing.amf3.RemoteObject;
	
	public class GameRemote extends RemoteObject
	{
		public function GameRemote(gateWay:String, servicePath:String)
		{
			super(gateWay, servicePath);
		}
	}
}
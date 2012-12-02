package game.vos
{
	public class TrackVO
	{
		public var id:int ;
		public var name:String ;
		public var costCoin:int ;
		public var costCash:int ;
		public var requireLevel:int ;
		public var info:String;
		public var elasticity:Number ;
		public var dynamicFriction:Number ;
		public var staticFriction:Number ;
		public var density:Number ;
		public var rollingFriction:Number ;
		
		public function get roadUrl():String
		{
			return "track/Road"+id+".png";
		}
		public function get roadXMLUrl():String
		{
			return "track/Road"+id+".xml";
		}
	}
}
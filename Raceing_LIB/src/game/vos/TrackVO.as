package game.vos
{
	import game.comm.GameSetting;
	

	public class TrackVO
	{
		public var id:int ;
		public var name:String ;
		public var requireLevel:int ;
		public var costCoin:int ;
		public var costCash:int ;
		public var info:String;
		public var elasticity:Number;
		public var dynamicFriction:Number;
		public var staticFriction:Number;
		public var density:Number;
		public var rollingFriction:Number;
		public var bgColors:Array ;
		public var gravity:int ;
		public var position:int ;
		public var gameMode:int ;
		public var competitors:Vector.<AIVO> ;
		
		public function get roadUrl():String
		{
			return "track/Road"+id+GameSetting.TEXTURE_TYPE;
		}
		public function get roadXMLUrl():String
		{
			return "track/Road"+id+".xml";
		}
	}
}
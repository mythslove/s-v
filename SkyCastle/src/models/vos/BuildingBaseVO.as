package models.vos
{
	public class BuildingBaseVO
	{
		public var baseId:int;
		public var title:String;
		public var type:int ;
		public var alias:String;
		public var xSpan:int;
		public var zSpan:int;
		public var url:String;
		public var thumb:String;
		public var offsetX:Number;
		public var offsetY:Number;
		
		//用于动画
		public var row:int;
		public var col:int;
		public var frames:int;
	}
}
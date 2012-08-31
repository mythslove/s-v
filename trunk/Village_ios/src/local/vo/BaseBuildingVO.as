package local.vo
{
	import local.enum.BuildingType;

	public class BaseBuildingVO
	{
		public var name:String="" ;
		public var xSpan:int =1 ;
		public var zSpan:int = 1;
		public var type:String = BuildingType.HOUSE ;
	}
}
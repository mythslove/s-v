package local.vo
{
	import local.enum.BuildingType;

	public class BaseBuildingVO
	{
		public var name:String="" ;
		public var title:String ="";//默认和name相同，用于不同语言包时
		public var xSpan:int =1 ;
		public var zSpan:int = 1;
		public var type:String = BuildingType.HOME ; //主类型
		public var subClass:String ; //子类型
	}
}
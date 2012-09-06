package local.vo
{
	import local.enum.BuildingType;

	public class BaseBuildingVO
	{
		public var name:String="" ;
		public var title:String ="";//默认和name相同，用于不同语言包时
		public var span:int = 1 ; //占用的格子数
		public var type:String = BuildingType.HOME ; //主类型
		public var subClass:String ; //子类型
		public var buildClick:int ; //修建时的点击次数
		
		/**
		 * 返回资源url 
		 * @return 
		 */		
		public function get url():String
		{
			switch( type ){
				case BuildingType.BASIC :
					return "basic/"+name+".bd" ;
					break ;
				case BuildingType.HOME :
					return "home/"+name+".bd" ;
					break ;
				case BuildingType.INDUSTRY :
					return "industry/"+name+".bd" ;
					break ;
				case BuildingType.BUSINESS :
					return "business/"+name+".bd" ;
					break ;
				case BuildingType.DECORATION :
					if( subClass==BuildingType.DECORATION_ROAD || subClass==BuildingType.DECORATION_WATER ){
						return "decoration/"+name+".rd" ;
					}
					return "decoration/"+name+".bd" ;
					break ;
				case BuildingType.COMMUNITY :
					return "community/"+name+".bd" ;
					break ;
				case BuildingType.WONDERS :
					return "wonder"+name+".bd" ;
					break ;
			}
			return null;
		}
	}
}
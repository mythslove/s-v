package local.vo
{
	import local.enum.BuildingStatus;
	import local.model.ShopModel;

	public class BuildingVO
	{
		public var id:String ;
		public var name:String ;
		public var status:int=BuildingStatus.NONE;			//建筑状态
		public var statusTime:Number=0;		//状态时间
		public var nodeX:int;					//X网格坐标
		public var nodeZ:int;					//z网格坐标
		public var rotation:int = 1 ; //方向
		public var buildClick:int ; //当前修建点击了的次数
		
		public var direction:String = "";//用于路和水
		
		public var product:ProductVO ; //要生产的东西，主要用于Industry
		
		private var _baseVO:BaseBuildingVO;
		public function get baseVO():BaseBuildingVO
		{
			if(!_baseVO) { 
				_baseVO = ShopModel.instance.allBuildingHash["name"] ;
			}
			return _baseVO;
		}
		public function set baseVO( value:BaseBuildingVO ):void{
			_baseVO = value ;
		}
	}
}
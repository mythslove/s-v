package local.vo
{
	import local.enum.BuildingStatus;

	public class BuildingVO
	{
		public var id:String ;
		public var name:String ;
		public var status:int=BuildingStatus.NONE;			//建筑状态
		public var statusTime:Number=0;		//状态时间
		public var nodeX:int;					//X网格坐标
		public var nodeZ:int;					//z网格坐标
		
		private var _baseVO:BaseBuildingVO;
		public function get baseVO():BaseBuildingVO
		{
			if(!_baseVO) {}
			return _baseVO;
		}
		public function set baseVO( value:BaseBuildingVO ):void{
			_baseVO = value ;
		}
	}
}
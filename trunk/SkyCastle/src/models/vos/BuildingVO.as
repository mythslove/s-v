package models.vos
{
	import models.BuildingBaseModel;

	public class BuildingVO
	{
		public var id:int;
		public var baseId:int; //BuildingBaseVO的id
		public var price:int;
		public var scale:int = 1; //方向1为正，-1为旋转后
		
		private var _baseVO:BuildingBaseVO ;
		public function get baseVO():BuildingBaseVO
		{
			if(!_baseVO){
				_baseVO = BuildingBaseModel.instance.getBaseVOById( baseId );
			}
			return _baseVO;
		}
	}
}
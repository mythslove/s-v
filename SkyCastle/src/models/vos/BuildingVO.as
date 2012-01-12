package models.vos
{
	import models.BuildingBaseModel;

	public class BuildingVO
	{
		public var id:int;
		public var baseId:int; //BuildingBaseVO的id
		public var price:int;
		public var scale:int = 1; //1为没有旋转过，-1 为旋转过
		
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
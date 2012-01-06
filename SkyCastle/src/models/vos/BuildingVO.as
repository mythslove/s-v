package models.vos
{
	import models.BuildingBaseModel;

	public class BuildingVO
	{
		public var id:int;
		public var baseId:int;
		public var price:int;
		public var scale:int = 1;
		
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
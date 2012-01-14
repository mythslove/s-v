package models.vos
{
	import models.BuildingBaseModel;

	public class BuildingVO
	{
		public var id:String; 
		public var baseId:String; //BuildingBaseVO的id
		public var price:int; //价格
		public var scale:int = 1; //1为没有旋转过，-1 为旋转过
		public var nodeX:int ; //位置
		public var nodeZ:int;
		public var direction:String="NONE"; //主要用于自动方向的路
		
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
package local.vo
{
	import local.model.ShopModel;

	public class ItemVO
	{
		public var id:String ;
		public var name:String ;
		public var statusTime:Number=0;		//状态时间
		public var nodeX:int;					//X网格坐标
		public var nodeZ:int;					//z网格坐标
		public var direction:int = 2 ; //方向
		
		public function get baseVO():BaseItemVO {
			return ShopModel.instance.allItemsHash[name];
		}
	}
}
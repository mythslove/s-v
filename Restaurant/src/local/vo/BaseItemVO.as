package local.vo
{
	import local.enum.ItemType;

	public class BaseItemVO
	{
		public var name:String="" ;
		public var type:String="" ;
		public var costCash:int ;
		public var costCoin:int ;
		public var requireLv:int ;
		public var xSpan:int =1 ;
		public var zSpan:int = 1; 
		public var earnExp:int =1 ;
		public var directions:int = 2 ;// 有几个方向
		public var onSale:Boolean = true ;
		
		/**
		 * 返回资源url 
		 * @return 
		 */		
		public function get url():String
		{
			return type+"/"+name+".bd" ;
		}
		
		/**
		 * @param forward 1和2
		 * @return 
		 */		
		public function getDirectionUrl( forward:int ):String{
			return type+"/"+name+"_"+forward+".bd" ;
		}
	}
}
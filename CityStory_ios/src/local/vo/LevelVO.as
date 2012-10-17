package local.vo
{
	import flash.net.URLVariables;

	public class LevelVO
	{
		public var level:int ; //从1开始，表示当前为第几级
		public var maxExp:int ; //最大经验
		public var maxEnergy:int ; //能量容量
		public var maxGoods:int ; //商品容量
		public var rewards:String ="" ; //URLVariable 升级奖励
		
		/**
		 * 将rewards字符串转化成对象 
		 * @return 
		 */		
		public function getRawardsObject():Object
		{
			if( rewards){
				var urlVar:URLVariables = new URLVariables();
				urlVar.decode( rewards);
				return urlVar ;
			}
			return null ;
		}
	}
}
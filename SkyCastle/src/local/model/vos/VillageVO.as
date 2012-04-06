package local.model.vos
{
	import local.model.map.vos.MapVO;

	/**
	 * 游戏初始化时取得的vo 
	 * @author zhouzhanglin
	 */	
	public class VillageVO
	{
		/**
		 *玩家信息 
		 */		
		public var me:PlayerVO ;
		/**
		 * 玩家初始地图信息 
		 */		
		public var mapVO:MapVO ;
	}
}
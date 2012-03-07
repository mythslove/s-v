package local.utils
{
	import local.enum.BasicPickup;
	import local.game.GameWorld;
	import local.views.icon.PickupImage;

	/**
	 * pickup工具类 
	 * @author zzhanglin
	 */	
	public class PickupUtil
	{
		
		/**
		 * 添加pickup到世界场景上 
		 * @param name pickup的名称
		 * @param value 添加的值
		 */		
		public static function addPickup2Wold( name:String , value:int ):void
		{
			var world:GameWorld = GameWorld.instance ;
			var img:PickupImage ;
			switch(name)
			{
				case BasicPickup.PICKUP_COIN:
					
					
					
					break ;
				case BasicPickup.PICKUP_ENERGY:
					break ;
				case BasicPickup.PICKUP_EXP:
					break ;
				case BasicPickup.PICKUP_WOOD:
					break ;
				case BasicPickup.PICKUP_STONE:
					break ;
				default:
					break ;
			}
		}
	}
}
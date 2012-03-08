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
		 * @param x
		 * @param y
		 */		
		public static function addPickup2Wold( name:String , value:int , x:Number , y:Number ):void
		{
			var world:GameWorld = GameWorld.instance ;
			var img:PickupImage ;
			var max:int =0 ;
			switch(name)
			{
				case BasicPickup.PICKUP_COIN:
					max = BasicPickup.COIN ;
					break ;
				case BasicPickup.PICKUP_ENERGY:
					max = BasicPickup.ENERGY ;
					break ;
				case BasicPickup.PICKUP_EXP:
					max = BasicPickup.EXP ;
					break ;
				case BasicPickup.PICKUP_WOOD:
					max = BasicPickup.WOOD ;
					break ;
				case BasicPickup.PICKUP_STONE:
					max = BasicPickup.STONE ;
					break ;
			}
			if(max>0)
			{
				//基本物品
				var type:int = max ;
				while( value>0 && max>0 )
				{
					if(value>=max*5)
					{
						img = new PickupImage(name+max,max*5,type);
						world.addEffect(img,x,y);
						value-=max*5;
					}else{
						max-=5;
						if(max<5){
							img = new PickupImage(name+Math.ceil(value/5),max,type);
							world.addEffect(img,x,y);
						}
					}
				}
			}
			else
			{
				//特殊的物品
				img = new PickupImage(name+max,value);
				world.addEffect(img,x,y);
			}
		}
	}
}
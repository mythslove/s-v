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
			switch(name)
			{
				case BasicPickup.PICKUP_COIN:
					if(value>70){
						img = new PickupImage(name+3,value,name);
					}else if( value>30){
						img = new PickupImage(name+2,value,name);
					}else{
						img = new PickupImage(name+1,value,name);
					}
					break ;
				case BasicPickup.PICKUP_ENERGY:
					if(value>2){
						img = new PickupImage(name+2,value,name);
					}else{
						img = new PickupImage(name+1,value,name);
					}
					break ;
				case BasicPickup.PICKUP_EXP:
				case BasicPickup.PICKUP_WOOD:
					if(value>100){
						img = new PickupImage(name+3,value,name);
					}else if( value>50){
						img = new PickupImage(name+2,value,name);
					}else{
						img = new PickupImage(name+1,value,name);
					}
					break ;
				case BasicPickup.PICKUP_STONE:
					if(value>50){
						img = new PickupImage(name+2,value,name);
					}else{
						img = new PickupImage(name+1,value,name);
					}
					break ;
				default:
					//特殊的物品
					img = new PickupImage(name,value);
					break ;
			}
			world.addEffect(img,x,y);
		}
	}
}
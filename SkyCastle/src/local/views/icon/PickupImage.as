package local.views.icon
{
	import local.views.base.Image;
	
	public class PickupImage extends Image
	{
		public var value:int ;
		/**
		 * 构造
		 * @param name pickup的名字，如pickupExp ,pickupWood
		 * @param value 值
		 */		
		public function PickupImage(name:String , value:int )
		{
			super(name, "res/pickup/"+name+".png", true);
			this.value = value ;
		}
	}
}
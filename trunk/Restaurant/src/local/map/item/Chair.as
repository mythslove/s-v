package local.map.item
{
	import local.vo.ItemVO;
	
	public class Chair extends BaseItem
	{
		public function Chair(itemVO:ItemVO)
		{
			super(itemVO);
		}
		
		override public function storageToWorld():void{
			super.storageToWorld();
			place();
		}
		override public function shopToWorld():void{
			super.shopToWorld();
			place();
		}
		private function place():void
		{
			
		}
	}
}
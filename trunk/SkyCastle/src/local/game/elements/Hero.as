package local.game.elements
{
	import local.enum.BasicPickup;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CollectQueueUtil;
	import local.utils.PickupUtil;
	
	public class Hero extends Character
	{
		
		public function Hero(vo:BuildingVO)
		{
			super(vo);
		}
		
		/**
		 * 英雄到达目的地了 
		 */		
		override protected function arrived():void
		{
			var building:Building = CollectQueueUtil.instance.currentBuilding ;
			if( building){
				building.execute();
			}
		}
		
		
		override public function onClick():void
		{
			if(!CollectQueueUtil.instance.currentBuilding)
			{
				//说话
			}
		}
	}
}
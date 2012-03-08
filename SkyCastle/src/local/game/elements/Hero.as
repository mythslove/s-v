package local.game.elements
{
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CollectQueueUtil;
	
	public class Hero extends Character
	{
		
		public function Hero(vo:BuildingVO)
		{
			super(vo);
		}
		
		override public function searchToRun(endNodeX:int, endNodeZ:int):Boolean
		{
			var result:Boolean = super.searchToRun( endNodeX, endNodeZ);
			if(result && !nextPoint){
				//如果有路，但英雄就在此路的终点
				arrived();
			}
			return result ;
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
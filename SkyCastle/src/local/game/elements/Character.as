package local.game.elements
{
	import flash.geom.Point;
	
	import local.model.buildings.vos.BuildingVO;
	
	/**
	 * 地图上的人 
	 * @author zzhanglin
	 */	
	public class Character extends BaseBuilding
	{
		public function Character(vo:BuildingVO)
		{
			super(vo);
		}
		
		public function moveToPoint( p:Point ):Boolean{
			return false;
		}
		
		public function searchToRun( startNodeX:int , startNodeZ:int , endNodeX:int , endNodeZ:int ):void
		{
			
		}
		
		override public function update():void
		{
			super.update() ;
			
		}
	}
}
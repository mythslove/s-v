package map.elements
{
	import flash.geom.Point;
	
	import models.vos.BuildingVO;
	
	/**
	 * 行走的人 
	 * @author zhouzhanglin
	 */	
	public class Character extends BuildingBase
	{
		public function Character(buildingVO:BuildingVO)
		{
			super(buildingVO);
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
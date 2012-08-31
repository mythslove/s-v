package local.map.item
{
	import local.comm.GameSetting;
	import local.map.cell.BuildingObject;
	import local.map.cell.RoadObject;
	import local.util.GameTimer;
	import local.vo.BuildingVO;

	public class BaseBuilding extends BaseMapObject
	{
		public var buildingObject:BuildingObject ;
		public var roadObject:RoadObject ;
		public var buildingVO:BuildingVO ;
		public var gameTimer:GameTimer;
		
		public function BaseBuilding(buildingVO:BuildingVO )
		{
			super(GameSetting.GRID_SIZE,buildingVO.baseVO.xSpan , buildingVO.baseVO.zSpan);
			this.mouseEnabled = false ;
			this.buildingVO = buildingVO ;
		}
		
		public function recoverStatus():void
		{
			
		}
		
		public function flash( value:Boolean):void
		{
			if(buildingObject) buildingObject.flash( value );
			if(roadObject) roadObject.flash( value );
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(buildingObject) buildingObject.dispose();
			if(roadObject) roadObject.dispose();
			buildingObject = null ;
			roadObject = null ;
		}
	}
}
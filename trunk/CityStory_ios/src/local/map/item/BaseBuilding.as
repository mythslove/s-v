package local.map.item
{
	import flash.display.Bitmap;
	
	import local.comm.GameSetting;
	import local.map.cell.BuildingObject;
	import local.map.cell.RoadObject;
	import local.util.GameTimer;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.BuildingVO;

	public class BaseBuilding extends BaseMapObject
	{
		public var gameTimer:GameTimer;
		public var buildingObject:BuildingObject ;
		public var roadObject:RoadObject ;
		public var buildingVO:BuildingVO ;
		public var statusIcon:Bitmap ; //显示当前状态的icon
		
		public function BaseBuilding(buildingVO:BuildingVO )
		{
			super(GameSetting.GRID_SIZE,buildingVO.baseVO.span , buildingVO.baseVO.span);
			name = buildingVO.name ;
			nodeX = buildingVO.nodeX ;
			nodeZ = buildingVO.nodeZ ;
			this.mouseEnabled = false ;
			this.buildingVO = buildingVO ;
		}
		
		public function recoverStatus():void
		{
			
		}
		
		override public function update():void
		{
			if(buildingObject) {
				buildingObject.update() ;
			}
			if(gameTimer){
				gameTimer.update() ;
			}
			if(statusIcon.bitmapData){
//				statusIcon.y+=Math.sin(5)
			}
		}
		
		override public function showUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			buildingObject = new BuildingObject(barvo);
			addChildAt(buildingObject,0);
			
			statusIcon = new Bitmap();
			statusIcon.y = buildingVO.baseVO.span*_size-buildingObject.height - _size ;
			addChild(statusIcon);
		}
		
		public function flash( value:Boolean):void
		{
			if(buildingObject) 
				buildingObject.flash( value );
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
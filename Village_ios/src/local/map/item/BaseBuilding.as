package local.map.item
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResVO;
	
	import local.comm.GameSetting;
	import local.map.cell.BuildingObject;
	import local.map.cell.RoadObject;
	import local.util.GameTimer;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
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
			name = buildingVO.name ;
			nodeX = buildingVO.nodeX ;
			nodeZ = buildingVO.nodeZ ;
			this.mouseEnabled = false ;
			this.buildingVO = buildingVO ;
		}
		
		public function recoverStatus():void
		{
			
		}
		
		override public function showUI():void
		{
			if(ResourceUtil.instance.checkResLoaded(name)){
				changeUI();
			}else{
				ResourceUtil.instance.addEventListener( name , resLoadedHandler );
				ResourceUtil.instance.loadRes( new ResVO(name,  buildingVO.baseVO.type+"/"+name+".bd"));
			}
		}
		
		private function resLoadedHandler( e:ResLoadedEvent):void
		{
			ResourceUtil.instance.removeEventListener( name , resLoadedHandler );
			changeUI();
		}
		
		private function changeUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			buildingObject = new BuildingObject(barvo);
			addChildAt(buildingObject,0);
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
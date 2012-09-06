package local.map.item
{
	import flash.display.Bitmap;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.map.cell.BuildingBottomGrid;
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
		public var bottom:BuildingBottomGrid ;
		public var statusIcon:Bitmap ; //显示当前状态的icon
		
		public function BaseBuilding(buildingVO:BuildingVO )
		{
			super(GameSetting.GRID_SIZE,buildingVO.baseVO.span , buildingVO.baseVO.span);
			this.mouseEnabled = false ;
			this.buildingVO = buildingVO ;
			name = buildingVO.name ;
			nodeX = buildingVO.nodeX ;
			nodeZ = buildingVO.nodeZ ;
		}
		
		public function recoverStatus():void
		{
			
		}
		
		override public function update():void
		{
			if(buildingObject) {
				buildingObject.update() ;
			}
			if(!GameData.villageEditor && gameTimer){
				gameTimer.update() ;
			}
		}
		
		override public function showUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			buildingObject = new BuildingObject(barvo);
			addChildAt(buildingObject,0);
			this.scaleX = buildingVO.rotation ;
			
//			statusIcon = new Bitmap();
//			statusIcon.y = buildingVO.baseVO.span*_size-buildingObject.height - _size ;
//			addChild(statusIcon);
		}
		
		public function onClick():void
		{
			if(GameData.villageEditor){
				if(this is Road){
					GameWorld.instance.roadScene.removeRoad( this as Road );
				}else{
					GameWorld.instance.buildingScene.removeBuilding( this );
				}
				GameWorld.instance.topScene.addIsoObject( this );
				GameWorld.instance.buildingScene.mouseChildren = false ;
				GameWorld.instance.roadScene.mouseChildren = false ;
				GameWorld.instance.iconScene.visible = false ;
				GameWorld.instance.topScene.visible = true ;
				this.drawBottomGrid();
				
			}else{
				flash(true);
			}
		}
		
		/**
		 * 闪烁 
		 * @param value
		 */		
		public function flash( value:Boolean):void
		{
			if(buildingObject) {
				buildingObject.flash( value );
			}
		}
		
		override public function set scaleX(value:Number):void
		{
			var flag:Boolean = value==1?false:true;
			this.rotateX( flag );
			buildingObject.scaleX = value ;
			this.buildingVO.rotation = value ;
		}
		
		override public function get scaleX():Number
		{
			return buildingObject.scaleX ;
		}
		
		/**添加底座*/		
		public function drawBottomGrid():void
		{
			if(!bottom){
				bottom = new BuildingBottomGrid(this);
				addChildAt(bottom,0);
				bottom.drawGrid();
				if(buildingObject){
					buildingObject.y -= GameSetting.GRID_SIZE*0.3 ;
					buildingObject.alpha = 0.6 ;
				}else if( roadObject){
					roadObject.y -= GameSetting.GRID_SIZE*0.3 ;
					roadObject.alpha = 0.6 ;
				}
			}
		}
		
		/** 移除底座*/
		public function removeBottomGrid():void
		{
			if(bottom) {
				bottom.dispose();
				if(bottom.parent){
					bottom.parent.removeChild(bottom);
				}
				bottom = null ;
				if(buildingObject){
					buildingObject.y += GameSetting.GRID_SIZE*0.3 ;
					buildingObject.alpha = 1 ;
				}else if( roadObject){
					roadObject.y += GameSetting.GRID_SIZE*0.3 ;
					roadObject.alpha = 1 ;
				}
			}
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
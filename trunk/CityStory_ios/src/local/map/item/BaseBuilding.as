package local.map.item
{
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.cell.BuildingBottomGrid;
	import local.map.cell.BuildingObject;
	import local.map.cell.RoadObject;
	import local.model.StorageModel;
	import local.util.GameTimer;
	import local.util.ResourceUtil;
	import local.view.building.EditorBuildingButtons;
	import local.vo.BitmapAnimResVO;
	import local.vo.BuildingVO;

	public class BaseBuilding extends BaseMapObject
	{
		public var gameTimer:GameTimer;
		public var buildingObject:BuildingObject ;
		public var roadObject:RoadObject ;
		public var buildingVO:BuildingVO ;
		public var bottom:BuildingBottomGrid ;
		
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
		{ }
		
		override public function update():void
		{
			if(buildingObject) {
				buildingObject.update() ;
			}
			if(!GameData.villageMode && gameTimer){
				gameTimer.update() ;
			}
		}
		
		override public function showUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			buildingObject = new BuildingObject(barvo);
			addChildAt(buildingObject,0);
			this.scaleX = buildingVO.rotation ;
		}
		
		public function onClick():void
		{
			var world:GameWorld = GameWorld.instance ;
			if(GameData.villageMode==VillageMode.EDIT){
				if(this is Road){
					world.roadScene.removeRoad( this as Road );
				}else{
					world.buildingScene.removeBuilding( this );
				}
				world.topScene.addIsoObject( this );
				world.roadScene.mouseChildren = world.buildingScene.mouseChildren = false ;
				this.drawBottomGrid();
				addChild( EditorBuildingButtons.instance );
			}else{
				flash(true);
			}
		}
		
		/**
		 * 从topScene添加到场景上 
		 */		
		public function addToSceneFromTopScene():void
		{
			var world:GameWorld = GameWorld.instance ;
			world.topScene.removeIsoObject( this );
			if(this is Road){
				world.roadScene.addRoad( this as Road );
			}else{
				world.buildingScene.addBuilding( this );
			}
			world.roadScene.mouseChildren = world.buildingScene.mouseChildren = true ;
			this.removeBottomGrid();
		}
		
		/**
		 * 从收藏箱中添加到游戏世界中 
		 */		
		public function storageToWorld():void
		{
			addToSceneFromTopScene();
		}
		
		/**
		 * 从商店中添加到世界中
		 */		
		public function shopToWorld():void
		{
			//减钱
			addToSceneFromTopScene();
			if(buildingVO.baseVO.type!=BuildingType.DECORATION)
			{
				//显示修建状态
				buildingVO.status=BuildingStatus.BUILDING ;
			}
		}
		
		/**
		 * 收到收藏箱 
		 */		
		public function stash():void
		{
			StorageModel.instance.addBuildingToStorage( this );
			GameWorld.instance.topScene.removeIsoObject( this );
			GameWorld.instance.roadScene.mouseChildren = GameWorld.instance.buildingScene.mouseChildren = true ;
			this.dispose();
		}
		
		/**
		 * 售出 
		 */		
		public function sell():void
		{
			GameWorld.instance.topScene.removeIsoObject( this );
			GameWorld.instance.roadScene.mouseChildren = GameWorld.instance.buildingScene.mouseChildren = true ;
			this.dispose();
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
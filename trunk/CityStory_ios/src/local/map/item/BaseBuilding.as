package local.map.item
{
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.enum.PickupType;
	import local.enum.QuestType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.cell.BuildStatusObject;
	import local.map.cell.BuildingBottomGrid;
	import local.map.cell.BuildingObject;
	import local.map.cell.RoadObject;
	import local.map.cell.TimeAnimObject;
	import local.map.pk.FlyLabelImage;
	import local.model.BuildingModel;
	import local.model.PlayerModel;
	import local.model.StorageModel;
	import local.util.EmbedsManager;
	import local.util.ObjectPool;
	import local.util.QuestUtil;
	import local.util.ResourceUtil;
	import local.view.CenterViewLayer;
	import local.view.building.EditorBuildingButtons;
	import local.vo.BitmapAnimResVO;
	import local.vo.BuildingVO;

	public class BaseBuilding extends BaseMapObject
	{
		public static var cachePos:Point = new Point();
		
		protected var _buildingObject:BuildingObject ;
		protected var _roadObject:RoadObject ;
		protected var _buildStatusObj:BuildStatusObject ; //修建状态
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
		
		override public function update():void
		{
			if(_buildingObject) {
				_buildingObject.update() ;
			}else if(_buildStatusObj){
				_buildStatusObj.update() ;
			}
		}
		
		override public function showUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			_buildingObject = new BuildingObject(barvo);
			addChildAt(_buildingObject,0);
			this.scaleX = buildingVO.rotation ;
		}
		
		public function onClick():void
		{
			var world:GameWorld = GameWorld.instance ;
			if(GameData.villageMode==VillageMode.EDIT){
				cachePos.x = nodeX;
				cachePos.y = nodeZ;
				if(this is Road){
					world.roadScene.removeRoad( this as Road );
				}else{
					world.buildingScene.removeBuilding( this );
				}
				world.topScene.addIsoObject( this );
				world.roadScene.mouseChildren = world.buildingScene.mouseChildren = false ;
				this.drawBottomGrid();
				
				var editorBtns:EditorBuildingButtons = EditorBuildingButtons.instance ;
				addChild( editorBtns );
				editorBtns.stashButton.enabled = editorBtns.rotateButton.enabled = editorBtns.sellButton.enabled = true ;
				if( buildingVO.status==BuildingStatus.BUILDING){
					editorBtns.stashButton.enabled = editorBtns.rotateButton.enabled = false ;
				}else if( buildingVO.baseVO.type==BuildingType.DECORATION){
					editorBtns.rotateButton.enabled = false ;
				}
				
			}else{
				flash(true);
			}
			CenterViewLayer.instance.gameTip.showBuildingTip(this);
		}
		
		/**
		 * 从topScene添加到场景上 
		 */		
		public function addToWorldFromTopScene():void
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
			//显示放置特效
			var barvo:BitmapAnimResVO = EmbedsManager.instance.getAnimResVOByName("PlaceBuildingEffect")[0] ;
			var effect:TimeAnimObject = ObjectPool.instance.getTimeAnim( "PlaceBuildingEffect" );
			if(xSpan==1){
				effect.scaleX = effect.scaleY = 0.6 ;
				effect.x = -50 ;
				effect.y = -5 ;
			}else if(xSpan==2){
				effect.scaleX = effect.scaleY = 1 ;
				effect.x = barvo.offsetX ;
				effect.y = barvo.offsetY ;
			}else if(xSpan==3){
				effect.scaleX = effect.scaleY = 1.8 ;
				effect.x = -150 ;
				effect.y = -10 ;
			}
			this.addChildAt( effect , 0 );  
		}
		
		/**
		 * 从收藏箱中添加到游戏世界中 
		 */		
		public function storageToWorld():void
		{
			addToWorldFromTopScene();
			
			//添加到地图数据中，并且从收藏箱数据中删除
			BuildingModel.instance.addBuildingVO( buildingVO );
			StorageModel.instance.deleteStorageVO( buildingVO.name , buildingVO.baseVO.type );
			
			//加人口和人口容量
			PlayerModel.instance.changePop( buildingVO.baseVO.addPop);
			PlayerModel.instance.changeCap( buildingVO.baseVO.addCap);
			
			//任务判断
			QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_NAME , buildingVO.name );
			QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_TYPE , buildingVO.baseVO.type );
			QuestUtil.instance.handleCount( QuestType.PLACE_BY_TYPE , buildingVO.baseVO.type );
		}
		
		/**
		 * 从商店中添加到世界中
		 */		
		public function shopToWorld():void
		{
			//减钱
			var flyImg:FlyLabelImage ;
			if( buildingVO.baseVO.priceCash>0 ){
				PlayerModel.instance.changeCash( -buildingVO.baseVO.priceCash );
				flyImg = new FlyLabelImage( PickupType.CASH , -buildingVO.baseVO.priceCash ) ;
			}else if(buildingVO.baseVO.priceCoin>0 ){
				PlayerModel.instance.changeCoin( -buildingVO.baseVO.priceCoin );
				flyImg = new FlyLabelImage( PickupType.COIN , -buildingVO.baseVO.priceCoin ) ;
			}
			if(flyImg){
				flyImg.x = screenX ;
				flyImg.y = screenY-20 ;
				GameWorld.instance.effectScene.addChild( flyImg );
			}
			//添加到地图上
			addToWorldFromTopScene();
			if(buildingVO.baseVO.type!=BuildingType.DECORATION)
			{
				//显示修建状态
				buildingVO.status=BuildingStatus.BUILDING ;
				this.removeChild( _buildingObject );
				_buildingObject.dispose() ;
				_buildingObject = null ;
				showUI() ;
			}
			else
			{
				//修建完成后的任务判断
				QuestUtil.instance.handleCount( QuestType.BUILD_BD_BY_NAME  , buildingVO.name );
				QuestUtil.instance.handleCount( QuestType.BUILD_BD_BY_TYPE  , buildingVO.baseVO.type );
				QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_NAME , buildingVO.name );
				QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_TYPE , buildingVO.baseVO.type );
			}
			//添加到地图数据中
			BuildingModel.instance.addBuildingVO( buildingVO );
			//加人口和人口容量
			PlayerModel.instance.changePop( buildingVO.baseVO.addPop);
			PlayerModel.instance.changeCap( buildingVO.baseVO.addCap);
			
			//任务
			QuestUtil.instance.handleCount( QuestType.PLACE_BY_TYPE , buildingVO.baseVO.type );
		}
		
		/**
		 * 收到收藏箱 
		 */		
		public function stash():void
		{
			GameWorld.instance.topScene.removeIsoObject( this );
			GameWorld.instance.roadScene.mouseChildren = GameWorld.instance.buildingScene.mouseChildren = true ;
			//添加到收藏箱中，并且从地图数据中移除
			BuildingModel.instance.removeBuildingVO( buildingVO );
			StorageModel.instance.addBuildingVOToStorage(buildingVO);
			//减人口和人口容量
			PlayerModel.instance.changePop( -buildingVO.baseVO.addPop);
			PlayerModel.instance.changeCap( -buildingVO.baseVO.addCap);
			
			//任务判断
			QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_NAME , buildingVO.name );
			QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_TYPE , buildingVO.baseVO.type );
			
			this.dispose();
		}
		
		/**
		 * 售出 
		 */		
		public function sell():void
		{
			GameWorld.instance.topScene.removeIsoObject( this );
			GameWorld.instance.roadScene.mouseChildren = GameWorld.instance.buildingScene.mouseChildren = true ;
			
			BuildingModel.instance.removeBuildingVO( buildingVO );
			//减人口和人口容量
			PlayerModel.instance.changePop( -buildingVO.baseVO.addPop);
			PlayerModel.instance.changeCap( -buildingVO.baseVO.addCap);
			
			//任务判断
			QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_NAME , buildingVO.name );
			QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_TYPE , buildingVO.baseVO.type );
			
			this.dispose();
		}
		
		/**
		 * 闪烁 
		 * @param value
		 */		
		public function flash( value:Boolean):void
		{
			if(_buildingObject) {
				_buildingObject.flash( value );
			}else if(_buildStatusObj){
				_buildStatusObj.flash( value );
			}
		}
		
		override public function set scaleX(value:Number):void
		{
			_buildingObject.scaleX = value ;
			this.buildingVO.rotation = value ;
		}
		
		override public function get scaleX():Number
		{
			return _buildingObject.scaleX ;
		}
		
		/**添加底座*/		
		public function drawBottomGrid():void
		{
			if(!bottom){
				bottom = new BuildingBottomGrid(this);
				addChildAt(bottom,0);
				bottom.drawGrid();
				if(_buildingObject){
					_buildingObject.y -= GameSetting.GRID_SIZE*0.25 ;
					_buildingObject.alpha = 0.6 ;
				}else if( _roadObject){
					_roadObject.y -= GameSetting.GRID_SIZE*0.25 ;
					_roadObject.alpha = 0.6 ;
				}else if(_buildStatusObj){
					_buildStatusObj.y -= GameSetting.GRID_SIZE*0.25 ;
					_buildStatusObj.alpha = 0.6 ;
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
				if(_buildingObject){
					_buildingObject.y += GameSetting.GRID_SIZE*0.25 ;
					_buildingObject.alpha = 1 ;
				}else if( _roadObject){
					_roadObject.y += GameSetting.GRID_SIZE*0.25 ;
					_roadObject.alpha = 1 ;
				}else if(_buildStatusObj){
					_buildStatusObj.y += GameSetting.GRID_SIZE*0.25 ;
					_buildStatusObj.alpha =1 ;
				}
			}
		}
		
		override public function set nodeX(value:int):void{
			super.nodeX = value ;
			buildingVO.nodeX = value ;
		}
		override public function set nodeZ(value:int):void{
			super.nodeZ = value ;
			buildingVO.nodeZ = value ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_buildingObject) _buildingObject.dispose();
			if(_roadObject) _roadObject.dispose();
			if(_buildStatusObj) _buildStatusObj.dispose();
			_buildingObject = null ;
			_roadObject = null ;
			_buildStatusObj = null ;
		}
	}
}
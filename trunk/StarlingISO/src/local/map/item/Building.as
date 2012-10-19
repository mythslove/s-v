package local.map.item
{
	import flash.events.Event;
	
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.enum.PickupType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.cell.BuildStatusObject;
	import local.map.cell.StatusIcon;
	import local.map.pk.FlyLabelImage;
	import local.map.pk.PickupImages;
	import local.model.CompsModel;
	import local.model.MapGridDataModel;
	import local.model.PlayerModel;
	import local.util.EmbedManager;
	import local.util.GameTimer;
	import local.util.GameUtil;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.BuildingVO;
	import local.vo.PlayerVO;
	
	public class Building extends BaseBuilding
	{
		public var gameTimer:GameTimer ;
		public var statusIcon:StatusIcon ; //显示当前状态的icon
		
		private var _gameTimerTick:int ;
		
		public function Building(buildingVO:BuildingVO)
		{
			super(buildingVO);
			statusIcon = new StatusIcon(this);
			addChild(statusIcon);
		}
		
		
		
		
		
		//============在buildingScene里遍历执行================================================
		
		public function recoverStatus():void
		{
			clearGameTimer();
			if(buildingVO.status == BuildingStatus.PRODUCTION || buildingVO.status==BuildingStatus.EXPANDING ) 
			{
				var cha:Number =  ( (buildingVO.statusTime-GameData.commDate.time)*0.001 )>>0 ;
				if(cha>0){
					buildingVO.statusTime = cha ;
					createGameTimer( buildingVO.statusTime );
				}else{
					gameTimerCompleteHandler( null );
				}
			}
		}
		
		public function checkRoadAndIcon():void
		{
			//修建和扩地时不判断
			if( buildingVO.status!=BuildingStatus.BUILDING && buildingVO.status!=BuildingStatus.EXPANDING && buildingVO.status!=BuildingStatus.NONE  )
			{ 
				//是否在路边
				var flag:Boolean = MapGridDataModel.instance.checkAroundBuilding(this,BuildingType.DECORATION,BuildingType.DECORATION_ROAD) ;
				if(flag){
					if( buildingVO.status == BuildingStatus.NO_ROAD ){
						startProduct();
					}
				}else{
					if(buildingVO.status==BuildingStatus.PRODUCTION ){
						clearGameTimer() ;
					}
					buildingVO.status=BuildingStatus.NO_ROAD ;
				}
			}
			showBuildingFlagIcon()
			//修正图标位置
			if( _buildingObject && statusIcon && statusIcon.parent ){
				statusIcon.x = screenX;
				statusIcon.y = screenY+buildingVO.baseVO.span*_size-_buildingObject.height - statusIcon.height*0.75 ;
			}
		}
		//============在buildingScene里遍历执行=====================================================
		
		
		
		
		
		
		
		
		
		
		
		//============计时====================================================
		/*创建计时器, @param duration时间，单位为秒*/
		protected function createGameTimer( duration:int ):void
		{
			if(!gameTimer){
				gameTimer = new GameTimer(duration);
				gameTimer.addEventListener(Event.COMPLETE , gameTimerCompleteHandler);
				if(duration<=0){
					gameTimer.update();
				}
			}else{
				gameTimer.reset();
			}
		}
		/*清除计时器*/
		protected function clearGameTimer():void
		{
			if(gameTimer){
				gameTimer.removeEventListener(Event.COMPLETE , gameTimerCompleteHandler);
				gameTimer = null ;
			}
		}
		/*计时完成*/
		protected function gameTimerCompleteHandler( e:Event ):void
		{
			clearGameTimer();
			buildingVO.statusTime = GameData.commDate.time ; //记录完成时间,单位毫秒
			buildingVO.status = BuildingStatus.PRODUCTION_COMPLETE ; //生产完成
			showBuildingFlagIcon();//显示建筑当前的标识
		}
		//============计时====================================================
		
		
		
		
		
		
		
		
		
		
		
		//============显示和移除图标====================================================
		/*显示建筑当前的标识 */		
		protected function showBuildingFlagIcon():void
		{
			if( this is ExpandLandBuilding ||  this is BasicBuilding ){
				return ;
			}
			switch( buildingVO.status )
			{
				case BuildingStatus.BUILDING:
					if(buildingVO.buildClick>0){
						//显示修建的次数的图标
					}
					break ;
				case BuildingStatus.NO_ROAD:
					statusIcon.texture = EmbedManager.getUITexture("NeedRoadsFlag") ;
					GameWorld.instance.iconScene.addChild(statusIcon);
					break ;
				case BuildingStatus.PRODUCTION:
					removeBuildingFlagIcon();
					break ;
				case BuildingStatus.PRODUCTION_COMPLETE:
					if( buildingVO.baseVO.type==BuildingType.INDUSTRY) {
						statusIcon.texture = EmbedManager.getUITexture("CollectGoodsFlag");
					}else{
						statusIcon.texture = EmbedManager.getUITexture("CollectCoinFlag");
					}
					GameWorld.instance.iconScene.addChild(statusIcon);
					break ;
				case BuildingStatus.LACK_MATERIAL:
					if( buildingVO.baseVO.type==BuildingType.INDUSTRY) { //工厂
						statusIcon.texture = EmbedManager.getUITexture("AddProductFlag");
					}else if( buildingVO.baseVO.type==BuildingType.BUSINESS) { //商业
						statusIcon.texture = EmbedManager.getUITexture("AddGoodsFlag");
					}
					GameWorld.instance.iconScene.addChild(statusIcon);
					break ;
				case BuildingStatus.EXPIRED :
					statusIcon.texture = EmbedManager.getUITexture("ProductsExpiredFlag");
					GameWorld.instance.iconScene.addChild(statusIcon);
					break;
				default:
					removeBuildingFlagIcon();
					break ;
			}
			statusIcon.x = screenX;
			var het:Number = _buildingObject? _buildingObject.height : _buildStatusObj.height ;
			statusIcon.y = screenY+buildingVO.baseVO.span*_size- het - statusIcon.height*0.75 ;
		}
		/*移除建筑当前的标识 */		
		protected function removeBuildingFlagIcon():void
		{
			if(statusIcon.parent){
				statusIcon.parent.removeChild(statusIcon);
			}
		}
		
		//============显示和移除图标====================================================
		
		
		
		
		
		
		
		override public function showUI():void 
		{
			if( buildingVO.status==BuildingStatus.BUILDING)
			{
				if( buildingVO.buildClick<=1){ 
					if(!_buildStatusObj) {
						var barvs:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( "BuildStatus_"+xSpan+"_0" ).resObject as  Vector.<BitmapAnimResVO>;
						_buildStatusObj = new BuildStatusObject(barvs[0].resName+"_000" ,barvs  );
					}
					addChildAt( _buildStatusObj , 0 );
				}else{
					if(_buildStatusObj){
						removeChild( _buildStatusObj , true );
					}
					barvs = ResourceUtil.instance.getResVOByResId( "BuildStatus_"+xSpan+"_1" ).resObject as  Vector.<BitmapAnimResVO>;
					_buildStatusObj = new BuildStatusObject(barvs[0].resName+"_000" ,barvs  );
					addChildAt( _buildStatusObj , 0 );
				}
			}else{
				super.showUI();
			}
			showBuildingFlagIcon() ;
		} 
		
		/**
		 * 收集Component 
		 * @param name
		 * @param value
		 */		
		public function collectComp( name:String , value:int ):void
		{
			CompsModel.instance.addComp( name , value );
			
//			var flyImg:FlyLabelImage = new FlyLabelImage(  name , value ) ;
//			flyImg.x = screenX  ;
//			flyImg.y = screenY  ;
//			GameWorld.instance.effectScene.addChild( flyImg );
		}
		
		
		
		/**
		 * 立即完成
		 */		
		public function instant():void
		{
			var cashCost:int = GameUtil.timeToCash( gameTimer.duration ) ;
			if(cashCost>0){
				if(PlayerModel.instance.me.cash >= cashCost )
				{
					if(gameTimer ){
						//扣cash
						PlayerModel.instance.changeCash( -cashCost );
						
						var flyImg:FlyLabelImage = new FlyLabelImage( PickupType.CASH , -cashCost ) ;
						flyImg.x = screenX-20 ;
						flyImg.y = screenY-70 ;
						GameWorld.instance.effectScene.addChild( flyImg );
						
						gameTimerCompleteHandler(null);
					}
				}
				else
				{
					trace(" cash不足");
				}
			}
		}
		
		/* 减能量*/
		protected function reduceEnergy():Boolean
		{
			var me:PlayerVO = PlayerModel.instance.me ;
			if( me.energy>0){
				var flyImg:FlyLabelImage = new FlyLabelImage( PickupType.ENERGY , -1 ) ;
				flyImg.x = screenX ;
				var het:Number = _buildingObject? _buildingObject.height : _buildStatusObj.height ;
				flyImg.y = screenY+buildingVO.baseVO.span*_size- het - statusIcon.height*0.5 ;
				GameWorld.instance.effectScene.addChild( flyImg );
				PlayerModel.instance.changeEnergy( -1 ) ;
				return true ;
			}else{
				//显示没有能量提示
//				CenterViewLayer.instance.gameTip.showLackEnergy( this ) ;
			}
			return false ;
		}
		
		/** 开始生产，从头开始计时  */		
		public function startProduct():void
		{
			clearGameTimer();
			//判断是否可以生产，Business的goods够不够，Industry的Product有没有
			switch( buildingVO.baseVO.type)
			{
				case BuildingType.BUSINESS: //消耗物品
					if( buildingVO.haveGoods){
						buildingVO.status = BuildingStatus.PRODUCTION ;
						createGameTimer( buildingVO.baseVO.time );
					}else{
						buildingVO.status = BuildingStatus.LACK_MATERIAL ;
					}
					break;
				case BuildingType.INDUSTRY: //需要产品
					if( buildingVO.product){
						buildingVO.status = BuildingStatus.PRODUCTION ;
						createGameTimer( buildingVO.product.time );
					}else{
						buildingVO.status = BuildingStatus.LACK_MATERIAL ;
					}
					break ;
				case BuildingType.HOME: 
				case BuildingType.COMMUNITY: 
				case BuildingType.WONDERS:
					buildingVO.status = BuildingStatus.PRODUCTION ;
					createGameTimer( buildingVO.baseVO.time );
					break ;
			}
		}
		
		
		override public function update():void
		{
			super.update();
			if(gameTimer && _gameTimerTick>10 ){
				gameTimer.update() ;
				_gameTimerTick = 0;
			}
			++_gameTimerTick ;
		}
		
		override public function onClick():void
		{
			if( GameData.villageMode==VillageMode.NORMAL && buildingVO.status==BuildingStatus.BUILDING){
				flash(true);
				//点击一次修一次 ，并加经验，判断能量是否足够
				if(reduceEnergy()){
					buildClick();
				}
			}
			else
			{
				super.onClick();
			}
		}
		
		/*修建时点击*/
		protected function buildClick():void
		{
			++buildingVO.buildClick ;
			//掉修建时的经验
			if(buildingVO.baseVO.clickExp>0){
				var pkImgs:PickupImages = new PickupImages();
				pkImgs.addPK( PickupType.EXP , buildingVO.baseVO.clickExp );
				pkImgs.x = screenX ;
				pkImgs.y = screenY ;
				GameWorld.instance.effectScene.addChild( pkImgs );
			}
			
			if( buildingVO.buildClick >= buildingVO.baseVO.click )
			{
				var flag:Boolean = MapGridDataModel.instance.checkAroundBuilding(this,BuildingType.DECORATION,BuildingType.DECORATION_ROAD) ;
				if(flag){
					if( buildingVO.baseVO.type==BuildingType.BUSINESS || buildingVO.baseVO.type==BuildingType.INDUSTRY ){
						buildingVO.status = BuildingStatus.LACK_MATERIAL ;
					}else{
						buildingVO.status = BuildingStatus.PRODUCTION ;
						startProduct();
					}
				}else{
					buildingVO.status = BuildingStatus.NO_ROAD ;
				}
				removeChild(_buildStatusObj);
				_buildStatusObj.dispose();
				_buildStatusObj = null ;
				
				//修建完成后的任务判断
//				QuestUtil.instance.handleCount( QuestType.BUILD_BD_BY_NAME  , buildingVO.name );
//				QuestUtil.instance.handleCount( QuestType.BUILD_BD_BY_TYPE  , buildingVO.baseVO.type );
//				QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_NAME , buildingVO.name );
//				QuestUtil.instance.handleOwn( QuestType.OWN_BD_BY_TYPE , buildingVO.baseVO.type );
//				
//				if(GameData.isShowTutor){
//					PlayerModel.instance.changeTutorStep();
//					CenterViewLayer.instance.enable = true ;
//					CenterViewLayer.instance.questBtn.showTutor();
//				}
			}
			showUI();
		}
		override public function dispose():void
		{
			super.dispose();
			clearGameTimer();
			removeBuildingFlagIcon();
			if(statusIcon) statusIcon.dispose() ;
			statusIcon =  null ;
		}
		
	}
}
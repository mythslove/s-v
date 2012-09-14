package local.map.item
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.model.MapGridDataModel;
	import local.util.EmbedsManager;
	import local.util.GameTimer;
	import local.vo.BuildingVO;
	
	/**
	 * 除了装饰以外其他的建筑 
	 * 这些建筑包括Business,wonder,community,home,industry
	 * 可以产东西，修建时需要点击
	 * @author zhouzhanglin
	 */	
	public class Building extends BaseBuilding
	{
		public var gameTimer:GameTimer;
		public var statusIcon:Bitmap = new Bitmap() ; //显示当前状态的icon
		
		public function Building(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		public function recoverStatus():void
		{
			clearGameTimer();
			if(buildingVO.status == BuildingStatus.PRODUCTION || buildingVO.status==BuildingStatus.EXPANDING ) 
			{
				buildingVO.statusTime =  ( (buildingVO.statusTime-GameData.commDate.time)*0.001 )>>0 ;
				createGameTimer( buildingVO.statusTime );
			}
		}
		
		override public function addToSceneFromTopScene():void
		{
			super.addToSceneFromTopScene();
			//是否在路边
			var flag:Boolean = MapGridDataModel.instance.checkAroundBuilding(this,BuildingType.DECORATION,BuildingType.DECORATION_ROAD) ;
			if(flag){
				if( buildingVO.status==BuildingStatus.NO_ROAD ){
					startProduct();
				}
			}else if( buildingVO.status==BuildingStatus.PRODUCTION ){
				clearGameTimer();
				buildingVO.status=BuildingStatus.NO_ROAD ;
				showBuildingFlagIcon();
			}
			//修正图标位置
			if(statusIcon && statusIcon.parent ){
				statusIcon.x = screenX-statusIcon.width*0.5;
				statusIcon.y = screenY+buildingVO.baseVO.span*_size-buildingObject.height - _size ;
			}
		}
		
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
			buildingVO.status = BuildingStatus.PRODUCTION_COMPLETE ; //生产完成
			showBuildingFlagIcon();//显示建筑当前的标识
		}
		
		override public function showUI():void 
		{
			if(buildingVO.status==BuildingStatus.BUILDING){
				//显示修建时的状态
			}else{
				super.showUI();
				showBuildingFlagIcon();
			}
		} 
		
		/**
		 * 开始生产 
		 */		
		protected function startProduct():void
		{
			//判断是否可以生产，Business的goods够不够，Industry的Product有没有
			removeBuildingFlagIcon();
		}
		
		/**
		 * 显示建筑当前的标识 
		 */		
		protected function showBuildingFlagIcon():void
		{
			switch( buildingVO.status )
			{
				case BuildingStatus.NO_ROAD:
					statusIcon.bitmapData = EmbedsManager.instance.getBitmapByName("NeedRoadsFlag").bitmapData;
					GameWorld.instance.iconScene.addChild(statusIcon);
					break ;
				case BuildingStatus.PRODUCTION:
					
					break ;
				case BuildingStatus.PRODUCTION_COMPLETE:
					if( buildingVO.baseVO.type==BuildingType.INDUSTRY) {
						statusIcon.bitmapData = EmbedsManager.instance.getBitmapByName("CollectGoodsFlag").bitmapData;
					}else{
						statusIcon.bitmapData = EmbedsManager.instance.getBitmapByName("CollectCoinFlag").bitmapData;
					}
					GameWorld.instance.iconScene.addChild(statusIcon);
					break ;
				case BuildingStatus.LACK_MATERIAL:
					statusIcon.bitmapData = EmbedsManager.instance.getBitmapByName("AddGoodsFlag").bitmapData;
					GameWorld.instance.iconScene.addChild(statusIcon);
					break ;
				default:
					removeBuildingFlagIcon();
					break ;
			}
			statusIcon.x = screenX-statusIcon.width*0.5;
			statusIcon.y = screenY+buildingVO.baseVO.span*_size-buildingObject.height - _size ;
		}
		
		/**
		 * 移除建筑当前的标识 
		 */		
		protected function removeBuildingFlagIcon():void
		{
			if(statusIcon.parent){
				statusIcon.parent.removeChild(statusIcon);
				statusIcon.bitmapData=null;
			}
		}
		
		override public function update():void
		{
			super.update();
			if(gameTimer){
				gameTimer.update() ;
			}
		}
		
		override public function storageToWorld():void
		{
			super.storageToWorld();
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			clearGameTimer();
			removeBuildingFlagIcon();
			statusIcon =  null ;
		}
	}
}
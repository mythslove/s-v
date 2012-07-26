package local.game.elements
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BuildingStatus;
	import local.model.buildings.MapBuildingModel;
	import local.model.buildings.vos.BuildingVO;
	
	public class NPC extends Character
	{
		private var _currentBuilding:Building ;
		private var _actionsFuns:Vector.<Function> ;
		private var _delayShow:int ;
		private var _isToHouse:Boolean ; //是否走到了房子边
		
		/**
		 * npc基类
		 * @param vo
		 * @param delay 延迟显示
		 */		
		public function NPC(vo:BuildingVO , delay:int )
		{
			super(vo);
			visible = false ;
			this.speed = 4 ;
			this. _delayShow = delay ;
			_actionsFuns = Vector.<Function>([
				freeWay,actionIdle,actionShop,actionIdle,searchHouse,freeWay,actionRunwayBack,
				actionIdle,actionAdmire,freeWay,searchHouse,freeWay,actionIdle,actionRunwayBack,freeWay
			]);
		}
		
		/* 添加到舞台上*/
		override protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			showSkin(); //加载资源
		}
		/*资源下载完成*/
		override protected function resLoadedHandler(e:Event):void
		{
			super.resLoadedHandler(e);
			_timeoutId = setTimeout( searchHouse , _delayShow );
		}
		
		/*自动 ，除了走动*/		
		protected function auto():void
		{
			_currentBuilding = null  ;
			var len:int = _actionsFuns.length - 1;
			var index:int = Math.round( Math.random()*len );
			var fun:Function = _actionsFuns[index] as Function;
			fun();
		}
		
		protected function searchHouse():void
		{
			visible = true ;
			var houses:Array = MapBuildingModel.instance.houses ;
			var ran:Number = Math.random() ;
			if(!_isToHouse && ran>=.6 && houses && houses.length>0){
				var index:int = (Math.random()*houses.length )>>0 ;
				_currentBuilding = houses[index] as Architecture ;
				if(_currentBuilding.parent==parent  && _currentBuilding.buildingVO.buildingStatus!=BuildingStatus.BUILDING && 
					Point.distance(new Point(_currentBuilding.screenX,_currentBuilding.screenY),new Point(screenX,screenY))<500){
					_currentBuilding.characterMoveTo( this );
				}
				else
				{
					freeWay();
					_currentBuilding = null ;
				}
					
			}else{
				freeWay();
			}
		}
		
		override protected function arrived():void
		{
			if(_currentBuilding && _currentBuilding is House)
			{
				_isToHouse = true ;
				(_currentBuilding as House).showBuildingEffect() ;
				actionRunway();
			}
			else
			{
				_isToHouse = false ;
				auto();
			}
			_currentBuilding = null ;
		}
		
		protected function freeWay():void
		{
			var p:Point = getFreeRoad();
			if( !p || !this.searchToRun(p.x , p.y)){
				this.actionIdle();
			}
		}
		
		protected function actionShop():void{
			this.gotoAndPlay(AvatarAction.SHOP);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(auto,5000);
		}
		
		protected function actionRunway():void{
			this.gotoAndPlay(AvatarAction.RUNAWAY);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(searchHouse,5000);
		}
		
		protected function actionRunwayBack():void{
			this.gotoAndPlay(AvatarAction.RUNAWAYBACK);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(auto,5000);
		}
		
		protected function actionIdle():void{
			this.gotoAndPlay(AvatarAction.IDLE);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(auto,8000);
		}
		
		protected function actionAdmire():void {
			this.gotoAndPlay(AvatarAction.ADMIRE);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(auto,5000);
		}
		
		public function actionCow():void{
			this.gotoAndPlay(AvatarAction.COWER);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(auto,10000);
		}
		
		override public function onClick():void
		{
			
		}
		
		override public function dispose():void
		{
			_actionsFuns = null ;
			_currentBuilding = null ;
		}
	}
}
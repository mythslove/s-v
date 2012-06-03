package local.game.elements
{
	import flash.events.Event;
	import flash.geom.Point;
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
		/**
		 * npc基灯 
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
				searchHouse,actionIdle,actionShop,actionIdle,searchHouse,
				actionIdle,actionAdmire,searchHouse,actionIdle,actionRunwayBack
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
			if( ran>=.6 && houses && houses.length>0){
				var index:int = (Math.random()*houses.length )>>0 ;
				_currentBuilding = houses[index] as Architecture ;
				if(_currentBuilding.parent==parent  && _currentBuilding.buildingVO.buildingStatus!=BuildingStatus.BUILDING && 
					Point.distance(new Point(_currentBuilding.screenX,_currentBuilding.screenY),new Point(screenX,screenY))<500){
					_currentBuilding.characterMoveTo( this );
				}
				else
				{
					var p:Point = getFreeRoad();
					if( !p || !this.searchToRun(p.x , p.y)){
						this.actionIdle();
					}
					_currentBuilding = null ;
				}
					
			}else{
				p = getFreeRoad();
				if( !p || !this.searchToRun(p.x , p.y)){
					this.actionIdle();
				}
			}
		}
		
		override protected function arrived():void
		{
			if(_currentBuilding && _currentBuilding is House){
				(_currentBuilding as House).showBuildingEffect() ;
				actionRunway();
			}
			else
			{
				auto();
			}
			_currentBuilding = null ;
		}
		
		protected function actionShop():void{
			this.gotoAndPlay(AvatarAction.SHOP);
			_timeoutId = setTimeout(auto,5000);
		}
		
		protected function actionRunway():void{
			this.gotoAndPlay(AvatarAction.RUNAWAY);
			_timeoutId = setTimeout(auto,5000);
		}
		
		protected function actionRunwayBack():void{
			this.gotoAndPlay(AvatarAction.RUNAWAYBACK);
			_timeoutId = setTimeout(auto,5000);
		}
		
		protected function actionIdle():void{
			this.gotoAndPlay(AvatarAction.IDLE);
			_timeoutId = setTimeout(auto,15000);
		}
		
		protected function actionAdmire():void {
			this.gotoAndPlay(AvatarAction.ADMIRE);
			_timeoutId = setTimeout(auto,5000);
		}
		
		protected function actionCow():void{
			this.gotoAndPlay(AvatarAction.COWER);
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
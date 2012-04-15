package local.game.elements
{
	import bing.iso.IsoScene;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import local.comm.GameSetting;
	import local.enum.AvatarAction;
	import local.game.GameWorld;
	import local.model.MapGridDataModel;
	import local.model.buildings.MapBuildingModel;
	import local.model.buildings.vos.BuildingVO;
	
	public class NPC extends Character
	{
		private var _currentBuilding:Building ;
		private var _actionsFuns:Vector.<Function> ;
		
		public function NPC(vo:BuildingVO)
		{
			super(vo);
			this.speed = 4;
			_actionsFuns = Vector.<Function>([
				searchHouse,actionIdle,actionShop,actionIdle,
				actionIdle,actionRunway,actionIdle,actionRunwayBack,searchHouse,
			]);
		}
		
		/* 添加到舞台上*/
		override protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			loadRes(); //加载资源
		}
		/*资源下载完成*/
		override protected function resLoadedHandler(e:Event):void
		{
			super.resLoadedHandler(e);
			searchHouse();
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
			var houses:Array = MapBuildingModel.instance.houses ;
			if( houses && houses.length>0){
				var len:int = houses.length - 1;
				var index:int = Math.round( Math.random()*len );
				_currentBuilding = houses[index] as Architecture ;
				_currentBuilding.characterMoveTo( this );
			}else{
				var p:Point = getFreeRoad();
				if( !p || !this.searchToRun(p.x , p.y)){
					this.actionIdle();
				}
			}
		}
		/*返回一个可以走动的点*/
		private function getFreeRoad():Point{
			var p:Point ;
			var pos:Array =[] ;
			var radius:int = 5 ;
			for(var i:int = nodeX-radius ; i<nodeX+radius ; ++i){
				for(var j:int = nodeZ-radius ; j<nodeZ+radius ; ++j){
					if(i>1&& j>1&&i+1<=GameSetting.GRID_X&&j+1<=GameSetting.GRID_Z ){
						if( !(i==nodeX&&j==nodeZ) && MapGridDataModel.instance.astarGrid.getNode(i,j).walkable)
						{
							var newScene:IsoScene = GameWorld.instance.getBuildingScene(i,j) ;
							var currScene:IsoScene = GameWorld.instance.getBuildingScene(nodeX,nodeZ) ;
							if(newScene&&newScene==currScene)	pos.push( new Point(i,j));
						}
					}
				}
			}
			if(pos.length>0){
				var len:int = pos.length-1 ;
				var index:int = Math.round(Math.random()*len);
				return pos[index] ;
			}
			return null ;
		}
		
		override protected function arrived():void{
			actionAdmire();
			_currentBuilding = null ;
		}
		
		protected function actionShop():void{
			this.gotoAndPlay(AvatarAction.SHOP);
			_timeoutId = setTimeout(searchHouse,1500);
		}
		
		protected function actionRunway():void{
			this.gotoAndPlay(AvatarAction.RUNAWAY);
			_timeoutId = setTimeout(searchHouse,5000);
		}
		
		protected function actionRunwayBack():void{
			this.gotoAndPlay(AvatarAction.RUNAWAYBACK);
			_timeoutId = setTimeout(searchHouse,5000);
		}
		
		protected function actionIdle():void{
			this.gotoAndPlay(AvatarAction.IDLE);
			_timeoutId = setTimeout(searchHouse,10000);
		}
		
		protected function actionAdmire():void {
			this.gotoAndPlay(AvatarAction.ADMIRE);
			_timeoutId = setTimeout(searchHouse,5000);
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
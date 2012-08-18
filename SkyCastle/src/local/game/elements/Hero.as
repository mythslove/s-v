package local.game.elements
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.enum.AvatarAction;
	import local.enum.ItemType;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BaseCharacterVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CollectQueueUtil;
	import local.utils.SettingCookieUtil;

	/**
	 * 英雄 
	 * @author zzhanglin
	 */	
	public class Hero extends Character
	{
		private var _actionsFuns:Vector.<Function> ;
		private var _idleTimeId:int ;
		
		public function Hero()
		{
			var baseVO:BaseCharacterVO = new BaseCharacterVO();
			baseVO.resId="Basic_Avatar";
			baseVO.alias="Basic_AvatarMale";
			baseVO.walkable=1 ;
			baseVO.xSpan = 1 ;
			baseVO.zSpan = 1 ;
			baseVO.layer = 2 ;
			baseVO.name="Sky Castle";
			baseVO.description = "Hello ! I am "+PlayerModel.instance.me.name+" .";
			baseVO.type = ItemType.CHACTERS ;
			var vo:BuildingVO = new BuildingVO();
			vo.baseVO = baseVO ;
			super(vo);
			
			_actionsFuns = Vector.<Function>([	actionShop,actionAdmire,actionShop,actionRunwayBack,actionDazed,actionActivatewonder,actionDazed ]);
		}
		
		/* 添加到舞台上*/
		override protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			createCharacterSkin();
			this.gotoAndPlay(AvatarAction.ACTIVATEWONDER );
		}
		
		override public function searchToRun(endNodeX:int, endNodeZ:int):Boolean
		{
			var result:Boolean = super.searchToRun( endNodeX, endNodeZ);
			if(result && !nextPoint){
				//如果有路，但英雄就在此路的终点
				arrived();
			}
			return result ;
		}
		
		/**
		 * 英雄到达目的地了 
		 */		
		override protected function arrived():void
		{
			var building:Building = CollectQueueUtil.instance.currentBuilding ;
			if( building){
				if(this.screenX>building.screenX){
					this.scaleX = -1;
				}else{
					this.scaleX = 1;
				}
				building.execute();
			}
			if(GameData.isHome){
				SettingCookieUtil.saveHeroPoint( nodeX , nodeZ );
			}
		}
		
		
		override public function onClick():void
		{
			if(!CollectQueueUtil.instance.currentBuilding)
			{
				//说话
			}
		}
		
		protected function autoAction():void
		{
			var len:int = _actionsFuns.length - 1;
			var index:int = Math.round( Math.random()*len );
			var fun:Function = _actionsFuns[index] as Function;
			fun();
		}
		
		protected function actionShop():void{
			this.gotoAndPlay(AvatarAction.SHOP);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(actionIdle,5000);
		}
		
		protected function actionRunwayBack():void{
			this.gotoAndPlay(AvatarAction.RUNAWAYBACK);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(actionIdle,5000);
		}
		
		protected function actionAdmire():void {
			this.gotoAndPlay(AvatarAction.ADMIRE);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(actionIdle,5000);
		}
		
		protected function actionDazed():void {
			this.gotoAndPlay(AvatarAction.DAZED);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(actionIdle,5000);
		}
		
		protected function actionActivatewonder():void {
			this.gotoAndPlay(AvatarAction.ACTIVATEWONDER);
			clearTimeout(_timeoutId);
			_timeoutId = setTimeout(actionIdle,5000);
		}
		
		protected function actionIdle():void{
			this.gotoAndPlay(AvatarAction.IDLE);
		}
		
		
		
		override public function gotoAndPlay(action:String):void
		{
			super.gotoAndPlay(action);
			clearTimeout(_timeoutId);
			if(action==AvatarAction.IDLE){
				clearTimeout(_idleTimeId);
				_idleTimeId = setTimeout(autoAction , 15000 );
			}else if(_idleTimeId>0){
				clearTimeout(_idleTimeId);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_timeoutId>0) clearTimeout(_timeoutId);
			if(_idleTimeId>0) clearTimeout(_idleTimeId);
			_actionsFuns = null ;
		}
	}
}
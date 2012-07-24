package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.MouseStatus;
	import local.enum.QuestType;
	import local.game.GameWorld;
	import local.model.MapGridDataModel;
	import local.model.QuestModel;
	import local.model.buildings.vos.BaseMobVO;
	import local.model.buildings.vos.BuildingVO;
	import local.model.vos.RewardsVO;
	import local.utils.CharacterManager;
	import local.utils.MouseManager;
	import local.utils.SoundManager;
	import local.views.loading.BuildingExecuteLoading;

	/**
	 * 怪(ATTACK,DAMAGE,IDLE,WALK,DEFEAT)
	 * @author zzhanglin
	 */	
	public class Mob extends Character
	{
		private var canMove:Boolean ;
		
		public function Mob(vo:BuildingVO)
		{
			super(vo);
			this.speed = 4 ;
		}
		
		/** 获取此建筑的基础VO */
		public function get baseMobVO():BaseMobVO{
			return buildingVO.baseVO as BaseMobVO ;
		}
		
		/** 攻击 */
		public function attack():void
		{
			_bmpMC.loopTime = 1 ;
			gotoAndPlay( AvatarAction.ATTACK );
		}
		
		/** 被打 */
		public function damage():void
		{
			_bmpMC.loopTime = 2 ;
			gotoAndPlay( AvatarAction.DAMAGE );
		}
		
		/** 死亡，被战胜 */
		public function defeat():void
		{
			_bmpMC.loopTime = 1 ;
			gotoAndPlay( AvatarAction.DEFEAT );
		}
		
		
		override public function set enable( value:Boolean ):void{
			itemLayer.enabled = value ;
			if(value){
				itemLayer.alpha = 1 ;
			}else{
				itemLayer.alpha = .6 ;
			}
		}
		
		override protected function createCharacterSkin():void
		{
			super.createCharacterSkin();
			if(_bmpMC){
				_bmpMC.addEventListener(Event.COMPLETE , animComHandler );
			}
		}
		
		private function animComHandler( e:Event ):void
		{
			if( _bmpMC.currentLabel==AvatarAction.DEFEAT.toUpperCase())
			{
				//死亡，从场景中移除
			}
			else if( _bmpMC.currentLabel==AvatarAction.DAMAGE.toUpperCase() || _bmpMC.currentLabel==AvatarAction.ATTACK.toUpperCase() )
			{
				gotoAndPlay(AvatarAction.IDLE);
			}
		}
		
		override public function onClick():void
		{
			if( !nextPoint &&_currentActions==AvatarAction.IDLE){
				if(roads){
					if(roads.length==0) super.onClick() ;
				}else{
					super.onClick() ;
				}
			}
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
		}
		
		override public function move():void
		{
			if(canMove) super.move() ;
		}
		
		override public function execute():Boolean
		{
			if(executeReduceEnergy())
			{
				itemLayer.alpha=1 ;
				_currentRewards = null ;
				_executeBack = false ;
				
				var endPoint:Point = new Point(nodeX, nodeZ) ;
				if(Math.random()>0.9){
					var p:Point = getFreeRoad(4);
					if( !p || !this.searchToRun(p.x , p.y)){
						endPoint = p ;
						MapGridDataModel.instance.buildingGrid.setWalkable( p.x,p.y,false);
						canMove = false ;
					}
				}
				
				ro.getOperation("attackMob").send( buildingVO.id , endPoint.x , endPoint.y );
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.HIT);
				SoundManager.instance.playSoundHitMonster() ;
				_timeoutFlag = false ;
				_timeoutId = setTimeout( timeoutHandler , 2000 );
				GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(3000));
			}
			return true;
		}
		
		override protected function onResultHandler(e:ResultEvent):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result);
			switch(e.method)
			{
				case "attackMob": 
					_executeBack = true ;
					_currentRewards = e.result as RewardsVO ;
					if(_currentRewards){
						//打死了怪
						this.showPickup();
						//统计quest ,战胜怪
						QuestModel.instance.updateQuests( QuestType.DEFEAT_MOB  ) ;
					}
					break ;
			}
		}
		
		override public function showPickup():void
		{
			if( _timeoutFlag && _executeBack)
			{
				//特殊物品
				showRewardsPickup();
				//-------------------------------------
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
				
				canMove = true ;
			}
		}
		
		
		override public function dispose():void
		{
			if( _bmpMC ) _bmpMC.removeEventListener(Event.COMPLETE , animComHandler );
			super.dispose();
		}
	}
}
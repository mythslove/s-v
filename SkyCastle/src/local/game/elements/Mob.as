package local.game.elements
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.buildings.vos.BaseMobVO;
	import local.model.buildings.vos.BuildingVO;
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
			gotoAndPlay( AvatarAction.ATTACK );
		}
		
		/** 被打 */
		public function damage():void
		{
			gotoAndPlay( AvatarAction.DAMAGE );
		}
		
		/** 死亡，被战胜 */
		public function defeat():void
		{
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
				if(Math.random()>0.8){
					var p:Point = getFreeRoad(6);
					if( !p || !this.searchToRun(p.x , p.y)){
						gotoAndPlay( AvatarAction.IDLE );
					}
				}
			}
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
		}
		
		override public function execute():Boolean
		{
			if(executeReduceEnergy())
			{
				itemLayer.alpha=1 ;
				_currentRewards = null ;
				_executeBack = false ;
				ro.getOperation("attack").send( buildingVO.id );
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.HIT);
				SoundManager.instance.playSoundHitMonster() ;
				_timeoutFlag = false ;
				_timeoutId = setTimeout( timeoutHandler , 2000 );
				GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(3000));
			}
			return true;
		}
		
		override public function dispose():void
		{
			if( _bmpMC ) _bmpMC.removeEventListener(Event.COMPLETE , animComHandler );
			super.dispose();
		}
	}
}
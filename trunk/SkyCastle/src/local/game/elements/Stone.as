package local.game.elements
{
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.buildings.vos.BaseStoneVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.MouseManager;
	import local.utils.PickupUtil;
	import local.utils.SoundManager;
	import local.views.loading.BuildingExecuteLoading;

	/**
	 * 装饰之石头 
	 * @author zzhanglin
	 */	
	public class Stone extends BasicDecoration
	{
		public function Stone(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseStoneVO():BaseStoneVO{
			return buildingVO.baseVO as BaseStoneVO ;
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(!MouseManager.instance.checkControl() )
			{
				MouseManager.instance.mouseStatus = MouseStatus.BEAT_STONE ;
				this.showStep( buildingVO.currentStep , baseStoneVO.step);
			}
		}
		
		override public function get description():String  {
			return "";
		}
		/** 获取此建筑的标题 */
		override public function get title():String  {
			return baseBuildingVO.name+"  ("+buildingVO.currentStep+"/"+baseStoneVO.step+")";
		}
		
		override public function execute():Boolean
		{
			if(checkEnergyAndMob())
			{
				super.execute();
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.PICKAXE);
				SoundManager.instance.playSoundChopStone() ;
				_timeoutFlag = false ;
				_timeoutId = setTimeout( timeoutHandler , 2000 );
				GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(3000));
			}
			return true ;
		}
		
		override public function showPickup():void
		{
			if( _timeoutFlag && _executeBack)
			{
				//掉pickup
				var value:int = baseStoneVO.earnCoin;
				if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , value,screenX,screenY+offsetY*0.5);
				value = baseStoneVO.earnStone ;
				if(value)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE , value,screenX,screenY+offsetY*0.5);
				value = baseStoneVO.earnExp ;
				if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY+offsetY*0.5);
				//特殊物品
				showRewardsPickup();
				//-------------------------------------
				buildingVO.currentStep++;
				_timeoutFlag=false ;
				_executeBack = false ;
				super.showPickup();
				if(buildingVO.currentStep>=baseStoneVO.step){
					showStashEffect();
					GameWorld.instance.removeBuildFromScene(this) ; 
					//添加怪
					if(_currentRewards && _currentRewards.mob ) addMob();
					
					this.dispose();
				}else if(_skin){
					_skin.gotoAndStop( buildingVO.currentStep+1);
				}
				_currentRewards = null ;
			}
		}
	}
}
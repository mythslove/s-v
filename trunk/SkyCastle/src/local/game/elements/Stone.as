package local.game.elements
{
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BaseStoneVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.MouseManager;
	import local.utils.PickupUtil;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;
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
			return baseBuildingVO.name+": "+buildingVO.currentStep+"/"+baseStoneVO.step;
		}
		
		override public function execute():Boolean
		{
			if(executeReduceEnergy())
			{
				super.execute();
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.PICKAXE);
				_timeoutFlag = false ;
				_timeoutId = setTimeout( timeoutHandler , 3000 );
				GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(4000));
			}
			return true ;
		}
		
		override public function showPickup():void
		{
			if( _timeoutFlag && _executeBack)
			{
				//掉pickup
				var value:int = baseStoneVO.earnCoin;
				if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , value,screenX,screenY-offsetY);
				value = baseStoneVO.earnStone ;
				if(value)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE , value,screenX,screenY-offsetY);
				value = baseStoneVO.earnExp ;
				if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY-offsetY);
				//特殊物品
				showRewardsPickup();
				//-------------------------------------
				buildingVO.currentStep++;
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
				if(buildingVO.currentStep>=baseStoneVO.step){
					GameWorld.instance.removeBuildFromScene(this) ; 
					this.dispose();
				}else if(_skin){
					_skin.gotoAndStop( buildingVO.currentStep+1);
				}
			}
		}
	}
}
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
		
		override public function execute():void
		{
			if(executeReduceEnergy())
			{
				super.execute();
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.PICKAXE);
				_timeoutId = setTimeout( showPickup , 3500 );
				GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(4000));
			}
		}
		
		override public function showPickup():void
		{
			super.showPickup();
			//掉pickup
			var value:int = baseStoneVO.earnCoins[buildingVO.currentStep] ;
			if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , value,screenX,screenY-offsetY);
			value = baseStoneVO.earnStones[buildingVO.currentStep] ;
			if(value)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE , value,screenX,screenY-offsetY);
			value = baseStoneVO.earnExps[buildingVO.currentStep] ;
			if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY-offsetY);
			//物品
			//-------------------------------------
			buildingVO.currentStep++;
			if(buildingVO.currentStep>=baseStoneVO.step){
				GameWorld.instance.removeBuilding(this); //删除这棵树
			}else if(_skin){
				_skin.gotoAndStop( buildingVO.currentStep+1);
			}
		}
	}
}
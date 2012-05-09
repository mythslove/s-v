package local.game.elements
{
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BaseRockVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.MouseManager;
	import local.utils.PickupUtil;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;
	import local.views.loading.BuildingExecuteLoading;

	/**
	 * 磐石，岩石，结合了石头和树的特点 
	 * @author zzhanglin
	 */	
	public class Rock extends BasicDecoration
	{
		public function Rock(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseRockVO():BaseRockVO{
			return buildingVO.baseVO as BaseRockVO ;
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(!MouseManager.instance.checkControl() )
			{
				if( baseRockVO.step==0 || buildingVO.currentStep+1<baseRockVO.step){
					MouseManager.instance.mouseStatus = MouseStatus.BEAT_STONE ;
				}else{
					MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
				}
				this.showStep( buildingVO.currentStep , baseRockVO.step);
			}
			
		}
		
		override public function get description():String  {
			return "";
		}
		/** 获取此建筑的标题 */
		override public function get title():String  {
			return baseBuildingVO.name+": "+buildingVO.currentStep+"/"+baseRockVO.step;
		}
		
		override public function execute():Boolean
		{
			if(executeReduceEnergy())
			{
				super.execute();
				if( baseRockVO.step==0 || buildingVO.currentStep+1<baseRockVO.step){
					CharacterManager.instance.hero.gotoAndPlay(AvatarAction.PICKAXE);
				}else{
					CharacterManager.instance.hero.gotoAndPlay(AvatarAction.DIG);
				}
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
				var value:int = baseRockVO.earnCoin ;
				if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , value,screenX,screenY+offsetY*0.5);
				value = baseRockVO.earnWood ;
				if(value)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_WOOD , value,screenX,screenY+offsetY*0.5);
				value = baseRockVO.earnExp ;
				if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY+offsetY*0.5);
				value = baseRockVO.earnStone ;
				if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE , value,screenX,screenY+offsetY*0.5);
				//特殊物品
				showRewardsPickup();
				//-------------------------------------
				buildingVO.currentStep++;
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
				
				if(buildingVO.currentStep>=baseRockVO.step){
					GameWorld.instance.removeBuildFromScene(this); 
					this.dispose();
				}else if(_skin){
					_skin.gotoAndStop( buildingVO.currentStep+1);
				}
			}
		}
	}
}
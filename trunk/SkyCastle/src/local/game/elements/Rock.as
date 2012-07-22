package local.game.elements
{
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.buildings.vos.BaseRockVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.MouseManager;
	import local.utils.PickupUtil;
	import local.utils.SoundManager;
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
				SoundManager.instance.playSoundChopRock() ;
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
					showStashEffect();
					GameWorld.instance.removeBuildFromScene(this); 
					//添加怪
					if(_currentRewards && _currentRewards.mob )  addMob();
					this.dispose();
				}else if(_skin){
					_skin.gotoAndStop( buildingVO.currentStep+1);
				}
			}
		}
	}
}
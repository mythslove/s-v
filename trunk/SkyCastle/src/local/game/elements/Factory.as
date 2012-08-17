package local.game.elements
{
	import local.enum.BasicPickup;
	import local.enum.BuildingStatus;
	import local.enum.QuestType;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.QuestModel;
	import local.model.buildings.vos.BaseFactoryVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.PickupUtil;
	import local.utils.SoundManager;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;

	/**
	 * 工厂 
	 * @author zzhanglin
	 */	
	public class Factory extends Architecture
	{
		public function Factory(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseFactoryVO():BaseFactoryVO{
			return buildingVO.baseVO as BaseFactoryVO ;
		}
		
		/**
		 * 掉物品 ，并接着下一个收集
		 */		
		override public function showPickup():void
		{
			if( _timeoutFlag && _executeBack)
			{
				clearEffect();
				//如果是修建状态，掉修建的pickup。
				if( buildingVO.buildingStatus==BuildingStatus.BUILDING)
				{
					//减木头和石头
					var effect:MapWordEffect ;
					if(PlayerModel.instance.me.wood<baseFactoryVO.buildWood ){
						effect = new MapWordEffect("You don't have enough Wood!");
						GameWorld.instance.addEffect(effect,screenX-120,screenY);
						return ;
					}else if(PlayerModel.instance.me.stone<baseFactoryVO.buildStone){
						effect = new MapWordEffect("You don't have enough Stone!");
						GameWorld.instance.addEffect(effect,screenX+120,screenY);
						return ;
					}
					
					var value:int =baseFactoryVO.buildWood ;
					if(value>0) effect = new MapWordEffect("Wood -"+value,MapWordEffect.WOOD_COLOR);
					PlayerModel.instance.me.wood-=value ; 
					GameWorld.instance.addEffect(effect,screenX-120 , screenY);
					value = baseFactoryVO.buildStone ;
					if(value>0) effect = new MapWordEffect("Stone -"+value,MapWordEffect.STONE_COLOR);
					PlayerModel.instance.me.stone-=value ; 
					GameWorld.instance.addEffect(effect , screenX+120 , screenY);
					//增加经验
					value = baseBuildingVO.buildEarnExp ;
					PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP ,  value , screenX,screenY+offsetY*0.5);
				}
				else if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
				{
					//如果是收获，掉收获的pickup
					value = baseFactoryVO.earnCoin ;
					if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN ,  value , screenX,screenY+offsetY*0.5);
					value = baseFactoryVO.earnExp ;
					if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP ,  value , screenX,screenY+offsetY*0.5);
					value = baseFactoryVO.earnStone ;
					if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE ,  value , screenX,screenY+offsetY*0.5);
					value = baseFactoryVO.earnWood ;
					if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_WOOD ,  value , screenX,screenY+offsetY*0.5);
					//重新生产
					buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
					createGameTimer( baseFactoryVO.earnTime );
					//统计 quest
					QuestModel.instance.updateQuests( QuestType.COLLECT_BUILDING );
				}
				else if( buildingVO.buildingStatus==BuildingStatus.PRODUCT)
				{
					if(!_gameTimer){ //最后一次修建完成
						PlayerModel.instance.me.rank+=buildingVO.baseVO.rank ;
						CenterViewContainer.instance.topBar.updateRank();
						itemLayer.visible=true ;
						this.showSkin();
						this.startProduct(); //开始生产
						//显示建造完成的动画
						this.showBuildCompleteEffect();
						//任务统计
						QuestModel.instance.updateQuests( QuestType.BUILD_NUM , baseBuildingVO.baseId ,1 , buildingVO.buildTime );
						QuestModel.instance.updateQuests( QuestType.OWN_BUILDING , baseBuildingVO.baseId );
						SoundManager.instance.playSoundFinishBuilding();
					}
				}
				//特殊物品
				showRewardsPickup();
				//=======================
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
			}
		}
	}
}
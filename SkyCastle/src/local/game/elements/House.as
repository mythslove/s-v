package local.game.elements
{
	import local.enum.BasicPickup;
	import local.enum.BuildingStatus;
	import local.game.GameWorld;
	import local.views.effects.BitmapMovieClip;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BaseHouseVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CollectQueueUtil;
	import local.utils.PickupUtil;
	import local.views.CenterViewContainer;
	import local.views.effects.BaseMovieClipEffect;
	import local.views.effects.MapWordEffect;

	/**
	 * 房子 
	 * @author zzhanglin
	 */	
	public class House extends Architecture
	{
		
		private var _effect:BitmapMovieClip ;
		
		public function House(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseHouseVO():BaseHouseVO{
			return buildingVO.baseVO as BaseHouseVO ;
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if( buildingVO.buildingStatus==BuildingStatus.PRODUCT && _gameTimer)
			{
				var value:int = ( (baseHouseVO.earnTime-_gameTimer.duration)/baseHouseVO.earnTime*baseHouseVO.earnCoin)>>0 ;
				this.showStep( value , baseHouseVO.earnCoin );
			}
		}
		
		
		override public function onClick():void
		{
			super.onClick();
			if(buildingVO.buildingStatus==BuildingStatus.PRODUCT)
			{
				var value:int = ( (baseHouseVO.earnTime-_gameTimer.duration)/baseHouseVO.earnTime*baseHouseVO.earnCoin)>>0 ;
				if(value>0){
					enable = false ;
					CollectQueueUtil.instance.addBuilding( this ); //添加到处理队列中
				}
			}
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
				if( buildingVO.buildingStatus==BuildingStatus.BUILDING )
				{
					//减木头和石头
					var effect:MapWordEffect ;
					if(PlayerModel.instance.me.wood<baseHouseVO.buildWood){
						effect = new MapWordEffect("You don't have enough Wood!");
						GameWorld.instance.addEffect(effect,screenX-120,screenY);
						return ;
					}else if(PlayerModel.instance.me.stone<baseHouseVO.buildStone){
						effect = new MapWordEffect("You don't have enough Stone!");
						GameWorld.instance.addEffect(effect,screenX+120,screenY);
						return ;
					}
					
					var value:int = baseHouseVO.buildWood ;
					if(value>0) effect = new MapWordEffect("Wood -"+value,MapWordEffect.WOOD_COLOR);
					PlayerModel.instance.me.wood-=value ; 
					GameWorld.instance.addEffect(effect,screenX-120,screenY);
					value = baseHouseVO.buildStone ;
					if(value>0) effect = new MapWordEffect("Stone -"+value,MapWordEffect.STONE_COLOR);
					PlayerModel.instance.me.stone-=value ; 
					GameWorld.instance.addEffect(effect,screenX+120,screenY);
					//增加经验
					value = baseBuildingVO.buildEarnExp ;
					PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP ,  value , screenX,screenY+offsetY*0.5);
				}
				else if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
				{
					//如果是收获，掉收获的pickup
					value = baseHouseVO.earnCoin ;
					if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN ,  value , screenX,screenY+offsetY*0.5);
					value = baseHouseVO.earnExp ;
					if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP ,  value , screenX,screenY+offsetY*0.5);
					//重新生产
					buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
					createGameTimer( baseHouseVO.earnTime );
				}
				else if( buildingVO.buildingStatus==BuildingStatus.PRODUCT)
				{
					if(_gameTimer)
					{
						//提前收获
						value = ( (baseHouseVO.earnTime-_gameTimer.duration)/baseHouseVO.earnTime*baseHouseVO.earnCoin)>>0 ;
						if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN ,  value , screenX,screenY+offsetY*0.5);
						value =  ( (baseHouseVO.earnTime-_gameTimer.duration)/baseHouseVO.earnTime*baseHouseVO.earnExp)>>0 ;
						if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP ,  value , screenX,screenY+offsetY*0.5);
						//重新生产
						buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
						createGameTimer( baseHouseVO.earnTime );
					}
					else(_gameTimer)
					{
						//最后一次修建完成
						PlayerModel.instance.me.rank+=buildingVO.baseVO.rank ;
						CenterViewContainer.instance.topBar.updateRank();
						itemLayer.visible=true ;
						this.showSkin();
						this.startProduct(); //开始生产
						//显示建造完成的动画
					}
				}
				//特殊物品
				showRewardsPickup();
				//==========================
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_effect){
				_effect.dispose();
				_effect = null ;
			}
		}
	}
}
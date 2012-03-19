package local.game.elements
{
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.buildings.vos.BaseStoneVO;
	import local.model.buildings.vos.BuildingVO;
	import local.model.VillageModel;
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
	public class Stone extends Decortation
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
				this.showStep( buildingVO.step-1 , baseStoneVO.earnStep);
			}
		}
		
		override public function get description():String  {
			return "";
		}
		/** 获取此建筑的标题 */
		override public function get title():String  {
			return baseBuildingVO.name+": "+(buildingVO.step-1)+"/"+baseStoneVO.earnStep;
		}
		
		override public function onClick():void
		{
			//减能量
			if(VillageModel.instance.me.energy<1){
				var effect:MapWordEffect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				super.onClick();
			}
		}
		
		override public function execute():void
		{
			//减能量
			var effect:MapWordEffect ;
			if(VillageModel.instance.me.energy>=1){
				effect = new MapWordEffect("Energy -1");
				VillageModel.instance.me.energy-- ;
				CenterViewContainer.instance.topBar.updateTopBar();
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				CollectQueueUtil.instance.clear();
				effect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
				//能量不够，弹出购买能量的窗口
				return ;
			}
			super.execute();
			CharacterManager.instance.hero.gotoAndPlay(AvatarAction.PICKAXE);
			_timeoutId = setTimeout( showPickup , 3000 );
			GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(3000));
		}
		
		override public function showPickup():void
		{
			super.showPickup();
			//掉pickup
			var value:int = baseStoneVO.earnCoins[buildingVO.step-1] ;
			if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , value,screenX,screenY-offsetY);
			value = baseStoneVO.earnStones[buildingVO.step-1] ;
			if(value)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE , value,screenX,screenY-offsetY);
			value = baseStoneVO.earnExps[buildingVO.step-1] ;
			if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY-offsetY);
			//物品
			//-------------------------------------
			buildingVO.step++;
			if(buildingVO.step>baseStoneVO.earnStep){
				GameWorld.instance.removeBuilding(this); //删除这棵树
			}else if(_skin){
				_skin.gotoAndStop( buildingVO.step);
			}
		}
	}
}
package local.game.elements
{
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.VillageModel;
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
				if( baseRockVO.earnStep==1 || baseRockVO.earnStep>buildingVO.step){
					MouseManager.instance.mouseStatus = MouseStatus.BEAT_STONE ;
				}else{
					MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
				}
				this.showStep( buildingVO.step-1 , baseRockVO.earnStep);
			}
			
		}
		
		override public function get description():String  {
			return "";
		}
		/** 获取此建筑的标题 */
		override public function get title():String  {
			return baseBuildingVO.name+": "+(buildingVO.step-1)+"/"+baseRockVO.earnStep;
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
			if( baseRockVO.earnStep==1 || baseRockVO.earnStep>buildingVO.step){
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.PICKAXE);
			}else{
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.DIG);
			}
			_timeoutId = setTimeout( showPickup , 3000 );
			GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(3000));
		}
		
		override public function showPickup():void
		{
			super.showPickup();
			//掉pickup
			var value:int = baseRockVO.earnCoins[buildingVO.step-1] ;
			if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , value,screenX,screenY-offsetY);
			value = baseRockVO.earnWoods[buildingVO.step-1] ;
			if(value)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_WOOD , value,screenX,screenY-offsetY);
			value = baseRockVO.earnExps[buildingVO.step-1] ;
			if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY-offsetY);
			value = baseRockVO.earnStones[buildingVO.step-1] ;
			if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_STONE , value,screenX,screenY-offsetY);
			//物品
			//-------------------------------------
			buildingVO.step++;
			if(buildingVO.step>baseRockVO.earnStep){
				GameWorld.instance.removeBuilding(this); //删除这棵树
			}else if(_skin){
				_skin.gotoAndStop( buildingVO.step);
			}
		}
	}
}
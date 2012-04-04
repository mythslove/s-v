package local.game.elements
{
	import bing.amf3.ResultEvent;
	
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.VillageModel;
	import local.model.buildings.vos.BaseTreeVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.MouseManager;
	import local.utils.PickupUtil;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;
	import local.views.loading.BuildingExecuteLoading;

	/**
	 * 装饰之树，树藤 
	 * @author zzhanglin
	 */	
	public class Tree extends BasicDecoration
	{
		public function Tree(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseTreeVO():BaseTreeVO{
			return buildingVO.baseVO as BaseTreeVO ;
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(!MouseManager.instance.checkControl() )
			{
				if(baseTreeVO.earnStep==1 || baseTreeVO.earnStep>buildingVO.step){
					MouseManager.instance.mouseStatus = MouseStatus.CUT_TREES ;
				}else{
					MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
				}
				this.showStep( buildingVO.step-1,baseTreeVO.earnStep);
			}
		}
		
		override public function get description():String  {
			return "";
		}
		/** 获取此建筑的标题 */
		override public function get title():String  {
			return baseBuildingVO.name+": "+(buildingVO.step-1)+"/"+baseTreeVO.earnStep;
		}
		
		override protected function onResultHandler(e:ResultEvent):void
		{
			switch(e.method)
			{
				case "chop": //砍
					
					break ;
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
			if(baseTreeVO.earnStep==1 || baseTreeVO.earnStep>buildingVO.step){
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.CHOPPING);
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
			var value:int =baseTreeVO.earnCoins[buildingVO.step-1] ;
			if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , value,screenX,screenY-offsetY);
			value = baseTreeVO.earnWoods[buildingVO.step-1] ;
			if(value)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_WOOD , value,screenX,screenY-offsetY);
			value = baseTreeVO.earnExps[buildingVO.step-1] ;
			if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY-offsetY);
			//特殊物品
			//-------------------------------------
			buildingVO.step++;
			if(buildingVO.step>baseTreeVO.earnStep){
				GameWorld.instance.removeBuilding(this); //删除这棵树
			}else if(_skin){
				_skin.gotoAndStop( buildingVO.step);
			}
		}
	}
}
package local.game.elements
{
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.buildings.vos.BaseTreeVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.MouseManager;
	import local.utils.PickupUtil;

	/**
	 * 装饰之树，树藤 
	 * @author zzhanglin
	 */	
	public class Tree extends Decortation
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
				if(baseTreeVO.earnStep>buildingVO.step){
					MouseManager.instance.mouseStatus = MouseStatus.CUT_TREES ;
				}else{
					MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
				}
			}
		}
		
		override public function execute():void
		{
			super.execute();
			if(baseTreeVO.earnStep>buildingVO.step){
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.CHOPPING);
			}else{
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.DIG);
			}
			_timeoutId = setTimeout( showPickup , 3000 );
		}
		
		override public function showPickup():void
		{
			super.showPickup();
			buildingVO.step++;
			if(buildingVO.step>baseTreeVO.earnStep){
				//删除个树
				GameWorld.instance.removeBuilding(this);
			}else if(_skin){
				_skin.gotoAndStop( buildingVO.step);
			}
			//掉pickup
			if(baseTreeVO.earnCoins[buildingVO.step-1]>0){
				PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , baseTreeVO.earnCoins[buildingVO.step-1],screenX,screenY-offsetY);
			}
			if(baseTreeVO.earnWoods[buildingVO.step-1]>0){
				PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , baseTreeVO.earnWoods[buildingVO.step-1],screenX,screenY-offsetY);
			}
			if(baseTreeVO.earnExps[buildingVO.step-1]>0){
				PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , baseTreeVO.earnExps[buildingVO.step-1],screenX,screenY-offsetY);
			}
			//物品
		}
	}
}
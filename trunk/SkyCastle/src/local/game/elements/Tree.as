package local.game.elements
{
	import flash.utils.setTimeout;
	
	import local.enum.AvatarAction;
	import local.enum.BasicPickup;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.PlayerModel;
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
		private var _shakeFlag:Boolean ;
		private var _shakeFrame:int ;
		
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
				if(baseTreeVO.step==1 || baseTreeVO.step>buildingVO.currentStep){
					MouseManager.instance.mouseStatus = MouseStatus.CUT_TREES ;
				}else{
					MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
				}
				this.showStep( buildingVO.currentStep,baseTreeVO.step);
			}
		}
		
		override public function get description():String  {
			return "";
		}
		/** 获取此建筑的标题 */
		override public function get title():String  {
			return baseBuildingVO.name+": "+buildingVO.currentStep+"/"+baseTreeVO.step;
		}
		
		override public function execute():void
		{
			if(executeReduceEnergy())
			{
				super.execute();
				if(baseTreeVO.step==1 || baseTreeVO.step>buildingVO.currentStep){
					CharacterManager.instance.hero.gotoAndPlay(AvatarAction.CHOPPING);
				}else{
					CharacterManager.instance.hero.gotoAndPlay(AvatarAction.DIG);
				}
				_timeoutFlag = false ;
				_timeoutId = setTimeout( timeoutHandler , 4000 );
				GameWorld.instance.effectScene.addChild( BuildingExecuteLoading.getInstance(screenX,screenY-itemLayer.height).setTime(4000));
			}
		}
		
		override public function showPickup():void
		{
			if( _timeoutFlag && _executeBack)
			{
				super.showPickup();
				//掉pickup
				var value:int =baseTreeVO.earnCoins[buildingVO.currentStep] ;
				if(value>0)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN , value,screenX,screenY-offsetY);
				value = baseTreeVO.earnWoods[buildingVO.currentStep] ;
				if(value)PickupUtil.addPickup2Wold(BasicPickup.PICKUP_WOOD , value,screenX,screenY-offsetY);
				value = baseTreeVO.earnExps[buildingVO.currentStep] ;
				if(value>0) PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , value,screenX,screenY-offsetY);
				//特殊物品
				//-------------------------------------
				buildingVO.currentStep++;
				if(buildingVO.currentStep>=baseTreeVO.step){
					GameWorld.instance.removeBuilding(this); //删除这棵树
				}else if(_skin){
					_skin.gotoAndStop( buildingVO.currentStep+1);
				}
			}
		}
		
		/**
		 * 摇动 
		 */		
		public function shake():void
		{
			_shakeFlag = true ;
			_shakeFrame = 0 ;
		}
		
		override public function update():void
		{
			if(_shakeFlag && _skin )
			{
				if(_skin.x>=0){
					_skin.x  = -2 ;
				}else if(_skin.x<0){
					_skin.x = 2;
				}
				++_shakeFrame ;
				if(_shakeFrame==10)
				{
					_shakeFlag = false ;
					_skin.x = 0 ;
				}
			}
		}
	}
}
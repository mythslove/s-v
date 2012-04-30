package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.enum.BuildingStatus;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.MouseManager;
	import local.utils.PopUpManager;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;
	import local.views.pickup.BuildCompleteMaterialPopUp;
	
	/**
	 * 工厂，房子的等建筑的基类 
	 * 修建完成时最后一步，需要判断材料
	 * @author zzhanglin
	 */	
	public class Architecture extends Building
	{
		public function Architecture(vo:BuildingVO)
		{
			super(vo);
		}
		
		override public function onClick():void
		{
			//减能量
			if(PlayerModel.instance.me.energy<1){
				var effect:MapWordEffect = new MapWordEffect("You don't have enough Energy!");
				GameWorld.instance.addEffect(effect,screenX,screenY);
			}else{
				super.onClick();
				this.showStep( buildingVO.currentStep,baseBuildingVO["step"]);
			}
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(!MouseManager.instance.checkControl() )
			{
				if(buildingVO.buildingStatus == BuildingStatus.BUILDING )
				{
					MouseManager.instance.mouseStatus = MouseStatus.BUILD_BUILDING ;
				}
				else if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
				{
					MouseManager.instance.mouseStatus = MouseStatus.EARN_COIN ;
				}
			}
		}
		
		override protected function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug(e.service+"."+e.method , e.result);
			super.onResultHandler(e);
			switch( e.method)
			{
				case "build":
					this.showBuidStatus() ;
					break ;
				case "buildComplete":
					this.clearEffect() ;
					PlayerModel.instance.me.rank+=buildingVO.baseVO.rank ;
					CenterViewContainer.instance.topBar.updateRank();
					this.buildingVO.buildingStatus=BuildingStatus.PRODUCT ;
					
					break ;
			}
		}
		
		override public function execute():Boolean
		{
			super.execute();
			if( buildingVO.buildingStatus==BuildingStatus.BUILDING)
			{
				if(buildingVO.currentStep<buildingVO.baseVO.step)
				{
					ro.getOperation("build").send(buildingVO.id , buildingVO.currentStep);
				}
				else if(buildingVO.currentStep==buildingVO.baseVO.step && baseBuildingVO.materials)
				{
					//弹出判断材料的窗口
					var buildComPopup:BuildCompleteMaterialPopUp = new BuildCompleteMaterialPopUp(this);
					PopUpManager.instance.addPopUp( buildComPopup);
				}
				return false ;
			}
			return true ;
		}
		
		/**
		 * 发送建造完成的消息到服务器 
		 */		
		public function sendBuildComplete():void
		{
			buildingVO.buildingStatus=BuildingStatus.NONE ;
			ro.getOperation("buildComplete").send(buildingVO.id);
		}
	}
}
package local.view.building
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.PlayerModel;
	import local.util.BuildingFactory;
	import local.view.CenterViewLayer;
	import local.view.base.BaseView;
	import local.vo.BaseBuildingVO;
	import local.vo.PlayerVO;
	
	/**
	 * 建筑移动时，上面的确定和取消按钮 
	 * @author zhouzhanglin
	 */	
	public class MoveBuildingButtons extends BaseView
	{
		private static var _instance:MoveBuildingButtons;
		public static function get instance():MoveBuildingButtons{
			if(!_instance) _instance = new MoveBuildingButtons();
			return _instance ;
		}
		//===========================================
		
		public var cancelBtn:BuildingCancelButton ;
		public var okBtn:BuildingOKButton ;
		
		public function MoveBuildingButtons()
		{
			super();
			mouseEnabled = false ;
			cancelBtn = new BuildingCancelButton();
			cancelBtn.x = -100 ;
			cancelBtn.y = -100 ;
			okBtn = new BuildingOKButton();
			okBtn.x = 100 ;
			okBtn.y = -100 ;
			addChild(okBtn);
			addChild(cancelBtn);
			
			addEventListener( MouseEvent.CLICK  , onClickHandler , false , 0  , true );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			scaleX = scaleY = 0 ;
			var value:Number = 1/GameWorld.instance.scaleX ;
			TweenLite.to( this , 0.25 , { scaleX:value , scaleY:value } );
			if(GameData.isShowTutor){
				cancelBtn.enabled = false ;
			}else{
				cancelBtn.enabled = true ;
			}
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			var building:BaseBuilding = GameWorld.instance.topScene.getChildAt(0) as BaseBuilding ;
			switch( e.target)
			{
				case okBtn:
					if( GameData.villageMode==VillageMode.BUILDING_STORAGE)
					{
						building.storageToWorld();
						GameData.villageMode = VillageMode.EDIT ;
					}
					else if( GameData.villageMode==VillageMode.BUILDING_SHOP)
					{
						building.shopToWorld();						
						var baseVO:BaseBuildingVO = building.buildingVO.baseVO ;
						if( baseVO.type==BuildingType.DECORATION ){
							var me:PlayerVO = PlayerModel.instance.me ;
							if( me.cash>= baseVO.priceCash && me.coin>= baseVO.priceCoin ){
								building = BuildingFactory.createBuildingByBaseVO( baseVO );
								GameWorld.instance.addBuildingToTopScene( building );
								return ;
							}else if( (baseVO.priceCash>0 && me.cash<baseVO.priceCash)||(baseVO.priceCoin>0 && me.coin<baseVO.priceCoin) ){
								GameData.villageMode = VillageMode.NORMAL ;
							}
						}
						else
						{
							GameData.villageMode = VillageMode.NORMAL ;
						}
						if(GameData.isShowTutor){
							CenterViewLayer.instance.questBtn.showTutor();
						}
					}
					break ;
				case cancelBtn:
					if( GameData.villageMode==VillageMode.BUILDING_STORAGE){
						GameData.villageMode = VillageMode.EDIT ;
					}else if( GameData.villageMode==VillageMode.BUILDING_SHOP){
						GameData.villageMode = VillageMode.NORMAL ;
					}
					break ;
			}
			if(parent) parent.removeChild(this);
		}
	}
}
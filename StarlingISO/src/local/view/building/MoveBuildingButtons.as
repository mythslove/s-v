package local.view.building
{
	import com.greensock.TweenLite;
	
	import local.comm.GameData;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.PlayerModel;
	import local.util.BuildingFactory;
	import local.util.EmbedManager;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	import local.vo.BaseBuildingVO;
	import local.vo.PlayerVO;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class MoveBuildingButtons extends BaseView
	{
		private static var _instance:MoveBuildingButtons;
		public static function get instance():MoveBuildingButtons{
			if(!_instance) _instance = new MoveBuildingButtons();
			return _instance ;
		}
		//===========================================
		
		public var cancelBtn:GameButton ;
		public var okBtn:GameButton ;
		
		public function MoveBuildingButtons()
		{
			super();
			cancelBtn = new GameButton(EmbedManager.getUIImage("BuildingCancelButtonUp")  );
			cancelBtn.x = -100 ;
			cancelBtn.y = -100 ;
			
			okBtn = new GameButton(EmbedManager.getUIImage("BuildingOKButtonUp"));
			okBtn.x = 100 ;
			okBtn.y = -100 ;
			addChild(okBtn);
			addChild(cancelBtn);
			
			cancelBtn.onRelease.add( onClickHandler );
			okBtn.onRelease.add( onClickHandler );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			scaleX = scaleY = 0 ;
			var value:Number = 1/GameWorld.instance.scaleX ;
			TweenLite.to( this , 0.25 , { scaleX:value , scaleY:value } );
//			if(GameData.isShowTutor){
//				cancelBtn.enabled = false ;
//			}else{
//				cancelBtn.enabled = true ;
//			}
		}
		
		private function onClickHandler( btn:GameButton ):void
		{
			var building:BaseBuilding = GameWorld.instance.topScene.getChildAt(0) as BaseBuilding ;
			switch( btn )
			{
				case okBtn:
					if( GameData.villageMode==VillageMode.BUILDING_STORAGE)
					{
//							building.storageToWorld();
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
						//						if(GameData.isShowTutor){
						//							PlayerModel.instance.changeTutorStep();
						//							GameWorld.instance.showTutor();
						//						}
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
		
		/**
		 * 防止被清除 
		 */		
		override public function dispose():void{}
	}
}
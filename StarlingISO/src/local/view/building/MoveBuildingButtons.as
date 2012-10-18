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
	
	import starling.display.Image;
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
			var img:Image = EmbedManager.getUIImage("BuildingCancelButtonUp") ;
			cancelBtn = new GameButton(img );
			cancelBtn.pivotX = img.width>>1 ;
			cancelBtn.pivotY = img.height>>1 ;
			cancelBtn.x = -100 ;
			cancelBtn.y = -100 ;
			
			img = EmbedManager.getUIImage("BuildingOKButtonUp") ;
			okBtn = new GameButton(img);
			okBtn.pivotX = img.width>>1 ;
			okBtn.pivotY = img.height>>1 ;
			okBtn.x = 100 ;
			okBtn.y = -100 ;
			addChild(okBtn);
			addChild(cancelBtn);
			
			cancelBtn.addEventListener( TouchEvent.TOUCH , onClickHandler);
			okBtn.addEventListener( TouchEvent.TOUCH , onClickHandler);
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
		
		private function onClickHandler( e:TouchEvent ):void
		{
			e.stopPropagation() ;
			if(e.touches.length==0) return ;
			
			var touch:Touch = e.touches[0] ;
			if( touch.target is GameButton && touch.phase==TouchPhase.ENDED)
			{
				var building:BaseBuilding = GameWorld.instance.topScene.getChildAt(0) as BaseBuilding ;
				switch( e.target)
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
		}
	}
}
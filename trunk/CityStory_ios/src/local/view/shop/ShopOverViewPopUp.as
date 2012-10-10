package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.PopUpCloseButton;
	
	public class ShopOverViewPopUp extends BaseView
	{
		private static var _instance:ShopOverViewPopUp;
		public static function get instance():ShopOverViewPopUp{
			if(!_instance) _instance = new ShopOverViewPopUp();
			return _instance ;
		}
		//=====================================
		public var btnClose:PopUpCloseButton ;
		public var btnHomes:ShopOverViewHomeButton ;
		public var btnIndustry:ShopOverViewIndustryButton ;
		public var btnBusiness:ShopOverViewBusinessButton ;
		public var btnDecor:ShopOverViewDecorButton ;
		public var btnCommunity:ShopOverViewCommunityButton ;
		public var btnWonders:ShopOverViewWondersButton ;
		//=====================================
		
		public function ShopOverViewPopUp(){
			super();
			addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			mouseChildren=true;
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			TweenLite.from( this , 0.2 , { x:x-200 , ease: Back.easeOut });
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			switch( e.target )
			{
				case btnClose:
					close();
					break ;
				case btnHomes:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , false );
					ShopPopUp.instance.show(BuildingType.HOME);
					PopUpManager.instance.removeCurrentPopup() ;
					break ;
				case btnDecor:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , false );
					ShopPopUp.instance.show(BuildingType.DECORATION);
					PopUpManager.instance.removeCurrentPopup() ;
					break ;
				case btnBusiness:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , false );
					ShopPopUp.instance.show(BuildingType.BUSINESS);
					PopUpManager.instance.removeCurrentPopup() ;
					break ;
				case btnIndustry:
					PopUpManager.instance.addQueuePopUp( ShopPopUp.instance , false );
					ShopPopUp.instance.show(BuildingType.INDUSTRY);
					PopUpManager.instance.removeCurrentPopup() ;
					break ;
				case btnCommunity:
					break ;
				case btnWonders:
					break ;
			}
		}
		
		private function close():void{
			mouseChildren=false;
			TweenLite.to( this , 0.2 , { x:x+200 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
		}
	}
}
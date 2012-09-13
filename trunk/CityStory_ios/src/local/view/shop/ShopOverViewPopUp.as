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
	import local.view.btn.TabMenuButton;
	
	public class ShopOverViewPopUp extends BaseView
	{
		private static var _instance:ShopOverViewPopUp;
		public static function get instance():ShopOverViewPopUp{
			if(!_instance) _instance = new ShopOverViewPopUp();
			return _instance ;
		}
		//=====================================
		public var btnClose:PopUpCloseButton ;
		public var btnHomes:TabMenuButton ;
		public var btnBusiness:TabMenuButton ;
		public var btnDecor:TabMenuButton ;
		//=====================================
		
		public function ShopOverViewPopUp(){
			super();
			
			btnHomes.label="Homes";
			btnBusiness.label="Business";
			btnDecor.label="Decor";
			
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
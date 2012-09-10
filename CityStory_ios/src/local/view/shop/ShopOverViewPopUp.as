package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
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
		
		//=====================================
		
		public function ShopOverViewPopUp(){
			super();
			
			btnClose.addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		override protected function addedToStage():void
		{
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
			}
		}
		
		private function close():void{
			mouseChildren=false;
			TweenLite.to( this , 0.2 , { x:x+200 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		
		private function onTweenCom():void{
			GameWorld.instance.run();
			PopUpManager.instance.removeCurrentPopup() ;
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler , false , 0 , true );
		}
	}
}
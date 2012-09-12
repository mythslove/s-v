package local.view.shop
{
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.PopUpCloseButton;
	
	public class ShopPopUp extends BaseView
	{
		private static var _instance:ShopPopUp;
		public static function get instance():ShopPopUp{
			if(!_instance) _instance = new ShopPopUp();
			return _instance ;
		}
		//=====================================
		public var btnClose:PopUpCloseButton ;
		public var container:Sprite;
		//=====================================
		
		public function ShopPopUp()
		{
			super();
			btnClose.addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		override protected function addedToStageHandler( e:Event ):void
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
			}
		}
		
		/**
		 * 显示 
		 * @param type BuildingType
		 */		
		public function show( type:String ):void
		{
			ContainerUtil.removeChildren( container );
			switch( type )
			{
				case BuildingType.HOME:
					container.addChild(HomePanel.instance) ;
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
package local.view.shop
{
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.BackButton;
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
		public var btnBack:BackButton ;
		//=====================================
		
		public function ShopPopUp()
		{
			super();
			btnClose.addEventListener(MouseEvent.CLICK , onMouseHandler );
			btnBack.addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
			mouseChildren=true;
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			TweenLite.from( this , 0.2 , { x:x-200 , ease: Back.easeOut , onComplete:showTweenOver });
		}
		
		private function showTweenOver():void{
			if(GameSetting.SCREEN_WIDTH<1024) {
				GameWorld.instance.visible=false;
			}
			if(GameData.isShowTutor && HomePanel.instance.content.numChildren>0 ){
				(HomePanel.instance.content.getChildAt(0) as ShopItemRenderer).showTutor() ;
			}
		}
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			switch( e.target )
			{
				case btnClose:
					close();
					break ;
				case btnBack:
					close();
					PopUpManager.instance.addQueuePopUp( ShopOverViewPopUp.instance );
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
				case BuildingType.DECORATION:
					container.addChild(DecorationPanel.instance) ;
					break ;
				case BuildingType.BUSINESS:
					container.addChild(BusinessPanel.instance) ;
					break ;
				case BuildingType.INDUSTRY:
					container.addChild(IndustryPanel.instance) ;
					break ;
				case BuildingType.COMMUNITY:
					container.addChild(CommunityPanel.instance) ;
					break ;
				case BuildingType.WONDERS:
					container.addChild(WonderPanel.instance) ;
					break ;
			}
		}
		
		/**
		 *  跳转到相应的选项，并滚到name建筑位置
		 * @type 建筑的大类型 
		 * @param name
		 */		
		public function scrollToBuilding( type:String , buildName:String ):void
		{
			show(type) ;
			if( container.numChildren>0 && container.getChildAt(0) is ShopPanel)
			{
				(  container.getChildAt(0) as ShopPanel ).scrollToBuilding( buildName );
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
			GameWorld.instance.visible=true;
		}
	}
}
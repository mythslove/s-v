package local.view.shop
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import feathers.display.Scale9Image;
	
	import local.comm.GameSetting;
	import local.util.EmbedManager;
	import local.util.PopUpManager;
	import local.util.StyleSetting;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ShopPopUp extends BaseView
	{
		private static var _instance:ShopPopUp; 
		public static function get instance():ShopPopUp {
			if(!_instance)  _instance= new ShopPopUp();
			return _instance ;
		}
		//-----------------------------------------------------------
		private var _closeButton:GameButton ;
		private var _bg:Scale9Image ;
		
		public function ShopPopUp()
		{
			super();
			pivotX = GameSetting.SCREEN_WIDTH >> 1 ;
			pivotY = GameSetting.SCREEN_HEIGHT >> 1 ;
			init();
			configListeners();
		}
		private function init():void
		{
			//背景
			_bg = new Scale9Image(StyleSetting.instance.popup2Texture );
			_bg.touchable = false ;
			_bg.width = GameSetting.SCREEN_WIDTH ;
			_bg.height = GameSetting.SCREEN_HEIGHT ;
			addChild( _bg );
			//关闭按钮
			_closeButton = new GameButton(EmbedManager.getUIImage("PopUpCloseButton"));
			_closeButton.x = _bg.width - _closeButton.defaultSkin.width*0.5-10;
			_closeButton.y =  _closeButton.defaultSkin.height*0.5 + 5;
			addChild(_closeButton);
			//标题
			var title:TextField = new TextField(300 , 70,"MARKET","TitleFont",70,0 ,false);
			title.touchable = false ;
			title.x = _bg.width>>1 ;
			title.y = 10 ;
			title.hAlign = HAlign.CENTER ;
			title.pivotX = title.width>> 1 ;
			addChild( title );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			scaleX = scaleY = 0 ;
			TweenLite.to( this , 0.3 , {  scaleX:1 , scaleY:1 , ease: Back.easeOut });
		}
		
		private function configListeners():void
		{
			_closeButton.addEventListener(Event.TRIGGERED , onCloseHandler );
		}
		
		
		
		
		
		
		private function onCloseHandler( e:Event ):void{
			close();
		}
		private function close():void
		{
			touchable = false ;
			TweenLite.to( this , 0.3 , {  scaleX:0 , scaleY:0 , ease: Back.easeIn , onComplete:onCloseTweenOver });
		}
		private function onCloseTweenOver():void
		{
			touchable = true ;
			PopUpManager.instance.removeCurrentPopup() ;
		}
	}
}
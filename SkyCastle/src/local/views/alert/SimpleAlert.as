package local.views.alert
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameSetting;
	import local.utils.PopUpManager;
	import local.views.BaseView;

	/**
	 * 简单的确认窗口 
	 * @author zzhanglin
	 */	
	public class SimpleAlert extends BaseView
	{
		public var canvas:Sprite;
		public var txtInfo:TextField;
		public var btnYes:BaseButton;
		public var btnNo:BaseButton;
		//========================
		private var _yesFun:Function = null ;
		private var _noFun:Function = null ;
		
		public function SimpleAlert(info:String ,  yesFun:Function = null , noFun:Function = null )
		{
			super();
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			txtInfo.text = info ;
			txtInfo.y = canvas.y+(canvas.height-txtInfo.height)*0.5 ;
			_yesFun = yesFun ;
			_noFun = noFun ;
		}
		
		override protected function added():void
		{
			TweenLite.from( this ,0.2 , { scaleX:0 , scaleY:0 , ease:Back.easeOut } );
			btnYes.addEventListener(MouseEvent.CLICK , onClickHandler );
			btnNo.addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch( e.target )
			{
				case btnYes:
					if(_yesFun!=null ) _yesFun();
					break ;
				case btnNo:
					if(_noFun!=null)  _noFun();
					break ;
			}
			
			TweenLite.to( this , 0.2 ,  { scaleX:0 , scaleY:0 ,ease:Back.easeIn , onComplete:onTweenCom } );
			mouseChildren = false; 
		}
		
		private function onTweenCom():void{
			PopUpManager.instance.removePopUp( this );
		}
		
		override protected function removed():void
		{
			btnYes.removeEventListener(MouseEvent.CLICK , onClickHandler );
			btnNo.removeEventListener(MouseEvent.CLICK , onClickHandler );
			_yesFun = null ;
			_noFun = null ;
		}
		
		public static function show( info:String ,  yesFun:Function = null , noFun:Function = null  ):void
		{
			var alert:SimpleAlert = new SimpleAlert(info ,  yesFun, noFun);
			PopUpManager.instance.addPopUp( alert , true , true , 0.4 );
		}
	}
}
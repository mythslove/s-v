package game.gui.app
{
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import game.comm.GameSetting;
	
	public class ColorPicker extends Sprite
	{
		public var colorBtn1:Sprite,colorBtn2:Sprite,colorBtn3:Sprite,colorBtn4:Sprite,colorBtn5:Sprite,colorBtn6:Sprite;
		public var colorPicker:Sprite , colorSliderBar:SimpleButton ;
		public var sizeBarBg:Sprite , sizeBar:Sprite , btnSize:SimpleButton ;
		public var alphaBarBg:Sprite , alphaBar:Sprite , btnAlpha:SimpleButton ;
		public var blurBarBg:Sprite , blurBar:Sprite , btnBlur:SimpleButton ;
		public var txtSize:TextField , txtAlpha:TextField , txtBlur:TextField;
		public var txtSizeValue:TextField , txtAlphaValue:TextField , txtBlurValue:TextField;
		public var txtColor:TextField ;
		//==============================================
		private static var _instance:ColorPicker ;
		public static function get instance():ColorPicker{
			if(!_instance) _instance = new ColorPicker();
			return _instance ;
		}
		//===============================================
		private var multiColorBar:Bitmap ;
		
		public function ColorPicker()
		{
			super();
			init();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function init():void
		{
			var obj:InteractiveObject ;
			for( var i:int = 0 ; i<numChildren ; ++i){
				obj = getChildAt( i ) as InteractiveObject ;
				if(obj){
					obj.mouseEnabled = false ;
					if( obj.name.indexOf("btn")>-1 || obj == colorPicker || obj==colorSliderBar )
					{
						obj.mouseEnabled = true ;
					}
				}
			}
			//创建取色控件
			multiColorBar = new Bitmap( new MultiColorBmd());
			multiColorBar.x = colorSliderBar.x-multiColorBar.width*0.5 ;
			multiColorBar.y = colorSliderBar.y ;
			addChildAt( multiColorBar , getChildIndex(colorSliderBar)-1 );
		}
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			x = GameSetting.SCREEN_WIDTH - 800 ;
			y = (GameSetting.SCREEN_HEIGHT-550)>>1 ;
		}
				
	}
}
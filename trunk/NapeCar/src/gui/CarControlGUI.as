package gui
{
	import comm.GameSetting;
	
	import feathers.controls.Button;
	
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class CarControlGUI extends Sprite
	{
		[Embed(source="../assets/Button.png")]
		private const BUTTON:Class;
		
		private var _rightBtn:Button ;
		private var _leftBtn:Button ;
		public var direction:int = 0 ; 
		
		public function CarControlGUI()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , addedHandler );
			
			var texture:Texture = Texture.fromBitmap( new BUTTON() as Bitmap);
			_leftBtn = new Button();
			_leftBtn.pivotX = texture.width>>1 ;
			_leftBtn.pivotY = texture.height>>1 ;
			_leftBtn.upSkin = new Image (texture);
			_leftBtn.downSkin = _leftBtn.upSkin;
			_leftBtn.scaleX = -1 ;
			_leftBtn.x = 100 ;
			_leftBtn.y = GameSetting.SCREEN_HEIGHT-_leftBtn.upSkin.height  ;
			addChild(_leftBtn);
			
			_rightBtn = new Button();
			_rightBtn.pivotX = texture.width>>1 ;
			_rightBtn.pivotY = texture.height>>1 ;
			_rightBtn.upSkin = new Image (texture);;
			_rightBtn.downSkin = _rightBtn.upSkin;
			_rightBtn.x = GameSetting.SCREEN_WIDTH-100 ;
			_rightBtn.y = GameSetting.SCREEN_HEIGHT-_rightBtn.upSkin.height  ;
			addChild(_rightBtn);
			
			_leftBtn.addEventListener(TouchEvent.TOUCH , leftTouch);
			_rightBtn.addEventListener(TouchEvent.TOUCH , righTouch);
		}
		
		private function leftTouch(e:TouchEvent):void
		{
			direction = 1;
			if(e.getTouch(_leftBtn,TouchPhase.ENDED))
			{
				direction = 0;
			}
		}
		
		private function righTouch(e:TouchEvent):void
		{
			direction = 2;
			if(e.getTouch(_leftBtn,TouchPhase.ENDED))
			{
				direction = 0;
			}
		}
	}
}
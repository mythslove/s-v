package game.gui.app
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import game.comm.GameSetting;
	import game.util.GameUtil;
	
	public class ColorPicker extends Sprite
	{
		public var colorBtn1:Sprite,colorBtn2:Sprite,colorBtn3:Sprite,colorBtn4:Sprite,colorBtn5:Sprite,colorBtn6:Sprite;
		public var colorPicker:Sprite , colorSliderBar:Sprite ;
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
		private var _multiColorSprite:Sprite = new Sprite();
		private var _multiColorBar:Bitmap ;
		private var _colors:Array= [0x000000, 0x000000];  
		private var _alphas:Array=[0, 1]; 
		private var _ratios:Array=[0,255];
		private var _matr:Matrix;
		private var _colorSprite:Sprite ;
		private var _blackWhiteShape:Shape = new Shape();
		private var _colorShape:Shape = new Shape();
		private var _colorBitmap:Bitmap ;
		private var _width:Number = 500 ;
		private var _height:Number = 300 ;
		private var _colorHueTarget:uint = 0xff0000 ;
		private var _selectedShape:Shape = new Shape();
		
		public function ColorPicker()
		{
			super();
			init();
			addListeners();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function init():void
		{
			var obj:InteractiveObject ;
			for( var i:int = 0 ; i<numChildren ; ++i){
				obj = getChildAt( i ) as InteractiveObject ;
				if(obj){
					obj.mouseEnabled = false ;
					if( obj.name.toLowerCase().indexOf("btn")>-1 || obj == colorPicker )
					{
						obj.mouseEnabled = true ;
					}
				}
			}
			//创建取色控件
			_multiColorBar = new Bitmap( new MultiColorBmd());
			_multiColorSprite = new Sprite();
			_multiColorSprite.mouseChildren = false ;
			_multiColorSprite.x = colorSliderBar.x-_multiColorBar.width*0.5 ;
			_multiColorSprite.y = colorSliderBar.y ;
			addChild(_multiColorSprite);
			_multiColorSprite.addChild( _multiColorBar);
			colorSliderBar.y= 0 ; colorSliderBar.x = _multiColorBar.width>>1 ;
			_multiColorSprite.addChild( colorSliderBar);
			//色彩
			_colorSprite = new Sprite();
			_colorSprite.x = 140 ;
			_colorSprite.y = 20 ;
			_colorSprite.mouseChildren = false ;
			addChildAt(_colorSprite, getChildIndex(colorPicker));
			_colorBitmap = new Bitmap( new BitmapData(_width,_height));
			_colorSprite.addChild(_colorBitmap);
			colorPicker.x = colorPicker.y = 0 ;
			_colorSprite.addChild(colorPicker);
			
			_matr = new Matrix();
			_matr.createGradientBox( _width, _height,Math.PI/2, 0, 0 );
			_blackWhiteShape.graphics.beginGradientFill( GradientType.LINEAR, _colors, _alphas, _ratios, _matr, SpreadMethod.PAD );
			_blackWhiteShape.graphics.drawRect( 0, 0, _width, _height );
			redrawBigGradient();
			
			//选择的颜色
			txtColor.text = "#ffffff";
			_selectedShape.x = 700;
			_selectedShape.y = 480;
			_selectedShape.graphics.beginFill(GameSetting.color);
			_selectedShape.graphics.drawRect(0,0,60,50);
			_selectedShape.graphics.endFill();
			addChild(_selectedShape);
		}
		
		private function addListeners():void
		{
			_colorSprite.addEventListener(TouchEvent.TOUCH_BEGIN , onColorSpriteHandler );
			_colorSprite.addEventListener(TouchEvent.TOUCH_END , onColorSpriteHandler );
			_colorSprite.addEventListener(TouchEvent.TOUCH_MOVE , onColorSpriteHandler );

			_multiColorSprite.addEventListener(TouchEvent.TOUCH_BEGIN , onColorSpriteSliderHandler );
			_multiColorSprite.addEventListener(TouchEvent.TOUCH_END , onColorSpriteSliderHandler );
			_multiColorSprite.addEventListener(TouchEvent.TOUCH_MOVE , onColorSpriteSliderHandler );
			
			addEventListener(TouchEvent.TOUCH_TAP , onClickHandler );
		}
		
		private function onColorSpriteHandler( e:TouchEvent ):void
		{
			e.stopPropagation();
			switch( e.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					colorPicker.startTouchDrag(e.touchPointID , true , new Rectangle(1,1,_width-2,_height-2));
					break ;
				case TouchEvent.TOUCH_MOVE:
					setSelectedColor();
					break ;
				default:
					colorPicker.stopTouchDrag( e.touchPointID );
					break ;
			}
		}
		
		
		private function onColorSpriteSliderHandler( e:TouchEvent ):void
		{
			e.stopPropagation();
			switch(e.type)
			{
				case TouchEvent.TOUCH_END:
					_colorHueTarget = _multiColorBar.bitmapData.getPixel( 5 , colorSliderBar.y - _colorSprite.y);
					redrawBigGradient();
					setSelectedColor();
					break ;
				default:
					colorSliderBar.y = e.localY+_colorSprite.y+5 ;
					if(colorSliderBar.y>_colorSprite.y+_multiColorBar.height){
						colorSliderBar.y = _colorSprite.y + _multiColorBar.height ;
					}else if( colorSliderBar.y<_colorSprite.y){
						colorSliderBar.y = _colorSprite.y ;
					}
					break ;
			}
		}
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			x = GameSetting.SCREEN_WIDTH - 800 ;
			y = (GameSetting.SCREEN_HEIGHT-550)>>1 ;
		}
		
		private function onClickHandler( e:TouchEvent ):void
		{
			e.stopPropagation();
			switch(e.target)
			{
				case colorBtn1:
					_colorHueTarget = 0xff0000;
					redrawBigGradient();
					setSelectedColor();
					break;
				case colorBtn2:
					_colorHueTarget = 0x00ff00;
					redrawBigGradient();
					setSelectedColor();
					break;
				case colorBtn3:
					_colorHueTarget = 0x0000ff;
					redrawBigGradient();
					setSelectedColor();
					break;
				case colorBtn4:
					_colorHueTarget = 0xffff00;
					redrawBigGradient();
					setSelectedColor();
					break;
				case colorBtn5:
					_colorHueTarget = 0x00ffff;
					redrawBigGradient();
					setSelectedColor();
					break;
				case colorBtn6:
					_colorHueTarget = 0xff00ff;
					redrawBigGradient();
					setSelectedColor();
					break;
			}
		}
		
		private function setSelectedColor():void
		{
			_selectedShape.graphics.clear();
			GameSetting.color =  _colorBitmap.bitmapData.getPixel(colorPicker.x,colorPicker.y )  ;
			_selectedShape.graphics.lineStyle(2,0xffffff);
			_selectedShape.graphics.beginFill(GameSetting.color);
			_selectedShape.graphics.drawRect(0,0,60,50);
			_selectedShape.graphics.endFill();
			txtColor .text = GameUtil.rgb2String(GameSetting.color);
		}
				
		
		private  function redrawBigGradient():void{
			_ratios = [ 0, 255 ];
			_matr.identity();
			_matr.createGradientBox( _width, _height,0, 0, 0 );
			_colorShape.graphics.clear();
			_colors = [_colorHueTarget, _colorHueTarget ];
			_colorShape.graphics.beginGradientFill( GradientType.LINEAR, _colors, _alphas, _ratios, _matr, SpreadMethod.PAD );
			_colorShape.graphics.drawRect( 0, 0, _width, _height);
			_colorBitmap.bitmapData.fillRect( _colorBitmap.bitmapData.rect , 0xffffffff);
			_colorBitmap.bitmapData.draw( _colorShape );
			_colorBitmap.bitmapData.draw( _blackWhiteShape );
		}
	}
}
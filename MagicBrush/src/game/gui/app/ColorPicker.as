package game.gui.app
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import game.comm.GameSetting;
	import game.gui.control.PopupCloseButton;
	import game.util.GameUtil;
	import game.util.PopUpManager;
	
	public class ColorPicker extends Sprite
	{
		public var colorBtn1:Sprite,colorBtn2:Sprite,colorBtn3:Sprite,colorBtn4:Sprite,colorBtn5:Sprite,colorBtn6:Sprite;
		public var colorPicker:Sprite , colorSliderBar:Sprite ;
		public var sizeBarBg:Sprite , sizeBar:Sprite , btnSize:Sprite ;
		public var alphaBarBg:Sprite , alphaBar:Sprite , btnAlpha:Sprite ;
		public var blurBarBg:Sprite , blurBar:Sprite , btnBlur:Sprite ;
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
		private var btnClose:PopupCloseButton ;
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
			//关闭按钮
			btnClose = new PopupCloseButton();
			btnClose.x=-btnClose.width+10;
			btnClose.y=-btnClose.height+30;
			addChild(btnClose);
			//创建取色控件
			_multiColorBar = new Bitmap( new MultiColorBmd(),"auto",true);
			_multiColorSprite = new Sprite();
			_multiColorSprite.mouseChildren = false ;
			_multiColorSprite.x = colorSliderBar.x-_multiColorBar.width*0.5 ;
			_multiColorSprite.y = colorSliderBar.y ;
			addChild(_multiColorSprite);
			_multiColorSprite.addChild( _multiColorBar);
			colorSliderBar.y= 0 ; colorSliderBar.x = _multiColorBar.width>>1 ;
			_multiColorSprite.addChild( colorSliderBar);
			_multiColorSprite.graphics.beginFill(0,0);
			_multiColorSprite.graphics.drawRect(colorSliderBar.x,0,colorSliderBar.width , _multiColorBar.height);
			_multiColorSprite.graphics.endFill();
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
			//下面的slider
			sizeBar.width = GameSetting.penSize*sizeBarBg.width/21 ;
			btnSize.x = sizeBar.x + sizeBar.width ;
			txtSizeValue.text = GameSetting.penSize+"";
			alphaBar.width = GameSetting.penAlpha*100*alphaBarBg.width/101  ;
			blurBar.width = GameSetting.blur*blurBarBg.width/21  ;
			btnAlpha.x = alphaBar.x + alphaBar.width ;
			btnBlur.x = blurBar.x + blurBar.width ;
			txtBlurValue.text = GameSetting.blur+"";
			txtAlphaValue.text = GameSetting.penAlpha*100+"";
		}
		
		private function addListeners():void
		{
			_colorSprite.addEventListener(TouchEvent.TOUCH_BEGIN , onColorSpriteHandler );
			_colorSprite.addEventListener(TouchEvent.TOUCH_END , onColorSpriteHandler );
			_colorSprite.addEventListener(TouchEvent.TOUCH_MOVE , onColorSpriteHandler );

			_multiColorSprite.addEventListener(TouchEvent.TOUCH_BEGIN , onColorSpriteSliderHandler );
			_multiColorSprite.addEventListener(TouchEvent.TOUCH_END , onColorSpriteSliderHandler );
			_multiColorSprite.addEventListener(TouchEvent.TOUCH_OUT, onColorSpriteSliderHandler );
			
			btnSize.addEventListener(TouchEvent.TOUCH_BEGIN , onSizeBtnHandler);
			btnSize.addEventListener(TouchEvent.TOUCH_END , onSizeBtnHandler );
			btnSize.addEventListener(TouchEvent.TOUCH_OUT , onSizeBtnHandler );
			
			btnAlpha.addEventListener(TouchEvent.TOUCH_BEGIN , onAlphaBtnHandler);
			btnAlpha.addEventListener(TouchEvent.TOUCH_END , onAlphaBtnHandler );
			btnAlpha.addEventListener(TouchEvent.TOUCH_OUT , onAlphaBtnHandler );
			
			btnBlur.addEventListener(TouchEvent.TOUCH_BEGIN , onBlurBtnHandler);
			btnBlur.addEventListener(TouchEvent.TOUCH_END , onBlurBtnHandler );
			btnBlur.addEventListener(TouchEvent.TOUCH_OUT , onBlurBtnHandler );
			
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
				case TouchEvent.TOUCH_BEGIN:
					colorSliderBar.startTouchDrag(e.touchPointID , true , new Rectangle(colorSliderBar.x,1,0,_multiColorBar.height-2));
					break ;
				default:
					colorSliderBar.stopTouchDrag( e.touchPointID );
					_colorHueTarget = _multiColorBar.bitmapData.getPixel( 5 , colorSliderBar.y);
					redrawBigGradient();
					setSelectedColor();
					break ;
			}
		}
		
		private function addedHandler(e:Event):void
		{
			x = GameSetting.SCREEN_WIDTH - 800 ;
			y = (GameSetting.SCREEN_HEIGHT-550)>>1 ;
			
			sizeBar.width = GameSetting.penSize*sizeBarBg.width/21 ;
			btnSize.x = sizeBar.x + sizeBar.width ;
			txtSizeValue.text = GameSetting.penSize+"";
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
				case btnClose:
					PopUpManager.instance.removePopUp( this );
					break ;
			}
		}
		
		private function onSizeBtnHandler( e:TouchEvent ):void
		{
			e.stopPropagation();
			switch(e.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					btnSize.startTouchDrag( e.touchPointID , true , new Rectangle(sizeBarBg.x,sizeBarBg.y,sizeBarBg.width,0));
					stage.addEventListener(TouchEvent.TOUCH_MOVE , onSizeBtnHandler );
					break ;
				default:
					sizeBar.width = btnSize.x-sizeBar.x ;
					//1-20
					GameSetting.penSize =( 21* sizeBar.width / sizeBarBg.width )>> 0 ;
					GameSetting.penSize = GameSetting.penSize==0?1:GameSetting.penSize ;					
					txtSizeValue.text = GameSetting.penSize+"";
					if(e.type==TouchEvent.TOUCH_END){
						btnSize.stopTouchDrag(e.touchPointID);
						stage.removeEventListener(TouchEvent.TOUCH_MOVE , onSizeBtnHandler );
					}
					break ;
			}
		}
		
		private function onAlphaBtnHandler( e:TouchEvent ):void
		{
			e.stopPropagation();
			switch(e.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					btnAlpha.startTouchDrag( e.touchPointID , true , new Rectangle(alphaBarBg.x,alphaBarBg.y,alphaBarBg.width,0));
					stage.addEventListener(TouchEvent.TOUCH_MOVE , onAlphaBtnHandler );
					break ;
				default:
					alphaBar.width = btnAlpha.x-alphaBar.x ;
					//1-100
					var alpha:int =( 101* alphaBar.width / alphaBarBg.width )>> 0 ;
					txtAlphaValue.text = alpha+"";
					GameSetting.penAlpha = alpha*0.01;
					if(e.type==TouchEvent.TOUCH_END){
						btnAlpha.stopTouchDrag(e.touchPointID);
						stage.removeEventListener(TouchEvent.TOUCH_MOVE , onAlphaBtnHandler );
					}
					break ;
			}
		}
		
		private function onBlurBtnHandler( e:TouchEvent ):void
		{
			e.stopPropagation();
			switch(e.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					btnBlur.startTouchDrag( e.touchPointID , true , new Rectangle(blurBarBg.x,blurBarBg.y,blurBarBg.width,0));
					stage.addEventListener(TouchEvent.TOUCH_MOVE , onBlurBtnHandler );
					break ;
				default:
					blurBar.width = btnBlur.x-blurBar.x ;
					//0-20
					GameSetting.blur = ( 21* blurBar.width / blurBarBg.width )>> 0 ;
					txtBlurValue.text = GameSetting.blur+"";
					if(e.type==TouchEvent.TOUCH_END){
						btnBlur.stopTouchDrag(e.touchPointID);
						stage.removeEventListener(TouchEvent.TOUCH_MOVE , onBlurBtnHandler );
					}
					break ;
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
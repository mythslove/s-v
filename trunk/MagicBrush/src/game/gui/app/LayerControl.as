package game.gui.app
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import game.comm.GameSetting;
	import game.gui.control.Button;
	
	[Event(name="layerChanged", type="flash.events.Event")]
	public class LayerControl extends Sprite
	{
		[Embed(source="../assets/layer/LayerSelectedBg.png")]
		public static const LayerSelectedBg:Class ;
		[Embed(source="../assets/layer/LayerNormalBg.png")]
		public static const LayerNormalBg:Class ;
		[Embed(source="../assets/layer/LayerShowButtonUp.png")]
		public static const LayerShowButtonUp:Class ;
		[Embed(source="../assets/layer/LayerShowButtonDown.png")]
		public static const LayerShowButtonDown:Class ;
		//===========================================
		
		private const layerNormalBmd:BitmapData = (new LayerNormalBg() as Bitmap).bitmapData  ;
		private const layerSelectedBmd:BitmapData = (new LayerSelectedBg() as Bitmap).bitmapData ;
		
		private var _layer1:Sprite, _layer2:Sprite , _layer3:Sprite ;
		private var _layer1Text:TextField, _layer2Text:TextField , _layer3Text:TextField ;
		private var _layer1Bmp:Bitmap , _layer2Bmp:Bitmap , _layer3Bmp:Bitmap ;
		
		public var selectedLayer:int = 1 ;
		
		private var btn:Button ;
		
		public function LayerControl()
		{
			super();
			init();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function init():void
		{
			//创建layer
			_layer3 = new Sprite();
			_layer3.mouseChildren = false ;
			_layer3Bmp = new Bitmap(layerNormalBmd);
			_layer3.addChild(_layer3Bmp);
			_layer3Text = new TextField();
			_layer3Text.x = 50;  _layer3Text.y = 15 ;
			_layer3Text.autoSize = TextFieldAutoSize.LEFT;
			layerTextStyle(_layer3Text);
			_layer3Text.text = "Layer 3";
			_layer3.addChild(_layer3Text);
			
			_layer2 = new Sprite();
			_layer2.mouseChildren = false ;
			_layer2.y = 70 ;
			_layer2Bmp = new Bitmap(layerNormalBmd);
			_layer2.addChild(_layer2Bmp);
			_layer2Text = new TextField();
			_layer2Text.x = 50;  _layer2Text.y = 15 ;
			_layer2Text.autoSize = TextFieldAutoSize.LEFT;
			layerTextStyle(_layer2Text);
			_layer2Text.text = "Layer 2";
			_layer2.addChild(_layer2Text);
			
			_layer1 = new Sprite();
			_layer1.mouseChildren = false ;
			_layer1.y = 140 ;
			_layer1Bmp = new Bitmap(layerSelectedBmd);
			_layer1.addChild(_layer1Bmp);
			_layer1Text = new TextField();
			_layer1Text.x = 50;  _layer1Text.y = 15 ;
			_layer1Text.autoSize = TextFieldAutoSize.LEFT;
			layerTextStyle(_layer1Text,true);
			_layer1Text.text = "Layer 1";
			_layer1.addChild(_layer1Text);
			
			_layer1.visible = _layer2.visible = _layer3.visible = false ;
			addChild(_layer3);
			addChild(_layer2);
			addChild(_layer1);
			
			//按钮
			btn = new Button( LayerShowButtonUp , LayerShowButtonDown,null,null,true);
			btn.x = -btn.width-10 ;
			btn.y = height-btn.height ;
			addChild(btn);
		}
		
		
		private function addedHandler(e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			x = GameSetting.SCREEN_WIDTH ;
			addEventListener(TouchEvent.TOUCH_TAP , onTapHandler );
		}
		
		private function onTapHandler( e:Event):void
		{
			e.stopPropagation();
			switch(e.target)
			{
				case _layer1:
					if(selectedLayer!=1){
						setBtnNormal();
						selectedLayer = 1 ;
						_layer1Bmp.bitmapData = layerSelectedBmd ;
						layerTextStyle(_layer1Text,true);
						dispatchEvent( new Event("layerChanged"));
					}
					break ;
				case _layer2:
					if(selectedLayer!=2){
						setBtnNormal();
						selectedLayer = 2 ;
						_layer2Bmp.bitmapData = layerSelectedBmd ;
						layerTextStyle(_layer2Text,true);
						dispatchEvent( new Event("layerChanged"));
					}
					break ;
				case _layer3:
					if(selectedLayer!=3){
						setBtnNormal();
						selectedLayer = 3 ;
						_layer3Bmp.bitmapData = layerSelectedBmd ;
						layerTextStyle(_layer3Text,true);
						dispatchEvent( new Event("layerChanged"));
					}
					break ;
				case btn:
					if(x>=GameSetting.SCREEN_WIDTH){
						x = GameSetting.SCREEN_WIDTH-120;
						_layer1.visible = _layer2.visible = _layer3.visible = true ;
						btn.scaleX = -1; 
						btn.x+=btn.width;
					}else{
						x = GameSetting.SCREEN_WIDTH ;
						_layer1.visible = _layer2.visible = _layer3.visible = false ;
						btn.scaleX = 1; 
						btn.x =- btn.width-10 ;
					}
					break ;
			}
		}
		
		private function setBtnNormal():void
		{
			if(selectedLayer==1){
				_layer1Bmp.bitmapData = layerNormalBmd ;
				layerTextStyle(_layer1Text);
			}else if(selectedLayer==2){
				_layer2Bmp.bitmapData = layerNormalBmd ;
				layerTextStyle(_layer2Text);
			}else if(selectedLayer==3){
				_layer3Bmp.bitmapData = layerNormalBmd ;
				layerTextStyle(_layer3Text);
			}
		}
		
		private function layerTextStyle( textField:TextField , isSelected:Boolean=false ):void
		{
			var tf:TextFormat = textField.defaultTextFormat ;
			tf.size = 16 ;
			tf.bold = true ;
			tf.font="Verdana";
			if(isSelected){
				tf.color = 0x33ccff;
			}else{
				tf.color = 0xcccccc ;
			}
			textField.defaultTextFormat = tf ;
			textField.text = textField.text;
		}
	}
}
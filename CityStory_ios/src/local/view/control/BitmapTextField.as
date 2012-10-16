package  local.view.control
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class BitmapTextField extends Sprite
	{
		
		[Inspectable(type = "String",defaultValue = "Verdana")]
		public function set font( value:String ):void
		{
			var format:TextFormat = txt.defaultTextFormat;
			format.font = value;
			txt.defaultTextFormat = format;
		}
		public function get font():String
		{
			return txt.defaultTextFormat.font;
		}
		[Inspectable(defaultValue = "20")]
		public function set size(value:String ):void
		{
			var format:TextFormat = txt.defaultTextFormat;
			format.size = value;
			txt.defaultTextFormat = format;
		}
		public function get size():String
		{
			return String(txt.defaultTextFormat.size);
		}
		[Inspectable(type = "String",defaultValue = "center")]
		public function set align(value:String ):void
		{
			var format:TextFormat = txt.defaultTextFormat;
			format.align = value;
			txt.defaultTextFormat = format;
		}
		public function get align():String
		{
			return txt.defaultTextFormat.align;
		}
		[Inspectable(type = "Boolean",defaultValue = true)]
		public function set bold(value:Boolean ):void
		{
			var format:TextFormat = txt.defaultTextFormat;
			format.bold = value;
			txt.defaultTextFormat = format;
		}
		public function get bold():Boolean
		{
			return txt.defaultTextFormat.bold;
		}
		[ Inspectable( type = "Color" , defaultValue = "#ffffff" ) ]
		public function set textColor( value:uint ):void
		{
			txt.textColor = value ;
		}
		public function get textColor():uint
		{
			return txt.textColor ;
		}
		
		
		override public function set width(value:Number):void{
			txt.width = value ;
		}
		override public function set height(value:Number):void{
			txt.height = value ;
		}
		public function setSize( w:Number , h:Number):void{
			txt.width = w ;
			txt.height =  h ;
		}
		
		public function set  defaultTextFormat( value:TextFormat ):void
		{
			txt.defaultTextFormat = value ;
		}
		public function get defaultTextFormat():TextFormat
		{
			return txt.defaultTextFormat;
		}
		
		
		
		
		public var txt:TextField;
		private var _bmp:Bitmap = new Bitmap();
		
		public function BitmapTextField()
		{
			super();
			mouseChildren = mouseEnabled = false;
			
			txt.width = width;
			txt.height = height;
			
			var format:TextFormat = txt.defaultTextFormat ;
			format.bold = true ;
			format.align="center";
			format.font="Verdana";
			format.size = 10 ;
			txt.defaultTextFormat = format ;
			txt.textColor = 0xffffff ;
			
			while(numChildren>0){
				removeChildAt(0);
			}
			addChild(_bmp);
		}
		
		public function draw():void
		{
			scaleX = scaleY = 1;
			if(_bmp.bitmapData){
				if(txt.width!=_bmp.bitmapData.width || txt.height!=_bmp.bitmapData.height){
					_bmp.bitmapData = new BitmapData(txt.width,txt.height,true,0xffffff);
				}else{
					_bmp.bitmapData.fillRect( _bmp.bitmapData.rect , 0xffffff );
				}
			}
			else
			{
				_bmp.bitmapData = new BitmapData(txt.width,txt.height,true,0xffffff);
			}
			_bmp.bitmapData.draw( txt );
		}
		
		public function set text( value:String ):void
		{
			if (txt.text != value)
			{
				txt.text = value;
				draw();
			}
		}
		public function get text():String{
			return txt.text;
		}
		
		override public function set filters( value:Array):void
		{
			txt.filters = value;
		}
		override public function get filters():Array
		{
			return txt.filters;
		}
		
		public function removeTextFiled():void
		{
			txt.filters = null ;
			txt = null ;
		}
		
		public function dispose():void
		{
			if(_bmp.bitmapData){
				_bmp.bitmapData.dispose();
			}
			_bmp = null ;
			txt.filters = null ;
			txt = null ;
		}
	}
	
}
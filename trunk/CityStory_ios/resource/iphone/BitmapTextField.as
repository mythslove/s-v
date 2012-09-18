package 
{

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		[Inspectable(defaultValue = "12")]
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
			this.graphics.clear();
			removeChild(txt);

			addChild(_bmp);
		}


		public function set text( value:String ):void
		{
			if (txt.text != value)
			{
				txt.width = width;
				txt.height = height;
				_bmp.bitmapData = new BitmapData(width,height,true,0xffffff);
				scaleX = scaleY = 1;
				txt.text = value;
				_bmp.bitmapData.draw( txt );
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
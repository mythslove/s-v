package local.view.control
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	/**
	 * 用代码生成的位图字体 
	 * @author zhouzhanglin
	 */	
	public class DynamicBitmapTF extends Bitmap
	{
		public var textField:TextField ;
		
		public function DynamicBitmapTF(w:Number,h:Number,
										fontName:String ,
										text:String = "",
										align:String = TextAlign.CENTER, 
										space:int = 2 ,
										size:int =20 , 
										bold:Boolean=false,
										color:uint = 0xffffff ,
										embedFonts:Boolean = false , 
										filters:Array = null )
		{
			super();
			textField = new TextField();
			textField.embedFonts = embedFonts ;
			textField.width = w ;
			textField.height = h ;
			textField.textColor = color ;
			var tf:TextFormat = textField.defaultTextFormat ;
			tf.align = align ;
			tf.size = size ;
			tf.font = fontName;
			tf.bold = bold ;
			tf.letterSpacing = space ;
			textField.defaultTextFormat = tf ;
			textField.text = text;
			textField.filters = filters ;
			if(text){
				draw();
			}
		}
		
		public function set text( value:String):void
		{
			if(textField.text!=value){
				textField.text=value;
				draw();
			}
		}
		
		public function draw():void
		{
			if(bitmapData){
				if(textField.width!=bitmapData.width || textField.height!=bitmapData.height){
					bitmapData = new BitmapData(textField.width,textField.height,true,0xffffff);
				}else{
					bitmapData.fillRect( bitmapData.rect , 0xffffff );
				}
			}
			else
			{
				bitmapData = new BitmapData(textField.width,textField.height,true,0xffffff);
			}
			bitmapData.draw( textField );
		}
		
		public function dispose():void
		{
			if(bitmapData){
				bitmapData.dispose();
			}
			textField.filters = null ;
			textField = null ;
		}
	}
}
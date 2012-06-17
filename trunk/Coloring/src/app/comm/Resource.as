package app.comm
{
	import flash.display.Bitmap;

	public class Resource
	{
		[Embed(source="../resource/imgs/Pen_0xD96F1E.png")]
		public static const PEN_0xD96F1E:Class ;
		[Embed(source="../resource/imgs/Pen_0xFF4A4A.png")]
		public static const PEN_0xFF4A4A:Class ;
		[Embed(source="../resource/imgs/Pen_0x15CA15.png")]
		public static const PEN_0x15CA15:Class ;
		[Embed(source="../resource/imgs/Pen_0x6E6EFF.png")]
		public static const PEN_0x6E6EFF:Class ;
		[Embed(source="../resource/imgs/Pen_0x919101.png")]
		public static const PEN_0x919101:Class ;
		[Embed(source="../resource/imgs/Pen_0x01B5B5.png")]
		public static const PEN_0x01B5B5:Class ;
		[Embed(source="../resource/imgs/Pen_0x7D7D7D.png")]
		public static const PEN_0x7D7D7D:Class ;
		[Embed(source="../resource/imgs/Pen_0xB54AFD.png")]
		public static const PEN_0xB54AFD:Class ;
		[Embed(source="../resource/imgs/Pen_0x63A301.png")]
		public static const PEN_0x63A301:Class ;
		
		public static function getPenBmp( color:uint ):Bitmap
		{
			var bmp:Bitmap ;
			switch( color)
			{
				case 0xD96F1E:
					bmp = new PEN_0xD96F1E();
					break ;
				case 0xFF4A4A:
					bmp = new PEN_0xFF4A4A();
					break ;
				case 0x15CA15:
					bmp = new PEN_0x15CA15();
					break ;
				case 0x6E6EFF:
					bmp = new PEN_0x6E6EFF();
					break ;
				case 0x919101:
					bmp = new PEN_0x919101();
					break ;
				case 0x01B5B5:
					bmp = new PEN_0x01B5B5();
					break ;
				case 0x7D7D7D:
					bmp = new PEN_0x7D7D7D();
					break ;
				case 0xB54AFD:
					bmp = new PEN_0xB54AFD();
					break ;
				case 0x63A301:
					bmp = new PEN_0x63A301();
					break ;
			}
			return bmp ;
		}
	}
}
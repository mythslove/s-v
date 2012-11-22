package game.comm
{
	import game.enums.AppStatus;

	public class GameSetting
	{
		public static var SCREEN_HEIGHT:Number ;
		public static var SCREEN_WIDTH:Number ;
		public static var isPad:Boolean ;
		
		public static var color:uint = 0xffff00 ; 
		
		public static var status:String = AppStatus.DRAW ;
		
		public static var blur:Number = 2.0 ;
		
		public static var penSize:Number = 10 ;
		
		public static var penAlpha:Number = 1.0 ;
		
		public static var canvasW:int = 640 ;
		public static var canvasH:int = 480 ;
	}
}
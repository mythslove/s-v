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
	}
}
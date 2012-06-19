package app.comm
{
	import app.core.GameScene;

	public class Data
	{
		/**
		 * 所有的画笔的颜色 
		 */		
		public static var penColors:Vector.<uint> = Vector.<uint>([
			
			0xFFff9933,0xFFff99cc,0xFFff00ff,0xFFffccFF,0xFFFF0000,0xFFcccccc,
			0xFF660099,0xFF6600FF,0xFF6666FF,0xFF669999,0xFFff6600,0xFFffcc00,0xFF996699,0xFF9999cc,
			0xFF003300,0xFF00ff00,0xFF0000FF,0xFF00ffff,0xFF330000,0xFF333300,0xFF660000,0xFF666600
		]);
		
		/**当前选择的type*/
		public static var currentType:String = "animal";
		
		/** 默认编辑状态 */
		public static var editorStatus:String = "buchket" ;
		
		/**  游戏场景 */
		public static var gameScene:GameScene ;
	}
}
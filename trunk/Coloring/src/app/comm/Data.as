package app.comm
{
	public class Data
	{
		/**
		 * 所有的画笔的颜色 
		 */		
		public static var penColors:Vector.<uint> = Vector.<uint>([
			0x003300,0x00ff00,0x0000FF,0x00ffff,0x330000,0x333300,0x660000,0x666600,
			0x660099,0x6600FF,0x6666FF,0x669999,0xff6600,0xffcc00,0x996699,0x9999cc,
			0xff9933,0xff99cc,0xff00ff,0xffccFF,0xcccccc
		]);
		
		/**当前选择的type*/
		public static var currentType:String = "animal";
	}
}
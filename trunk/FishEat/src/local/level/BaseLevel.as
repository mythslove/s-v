package local.level
{
	/**
	 * fish1得1分，2得2分，3得3分 
	 * @author zhouzhanglin
	 * levelName[0] = "Level 0: The beginning...";
levelName[1] = "Level 1: Calm water...";
levelName[2] = "Level 2: Blue ocean...";
levelName[3] = "Level 3: Fishes World...";
levelName[4] = "Level 4: The Pacific";
levelName[5] = "Level 5: The Pacific";
levelName[6] = "Level 6: The Pacific";
levelName[7] = "Level 7: The Pacific";
levelName[8] = "Level 8: The Pacific";
levelName[9] = "Level 9: The Pacific";
levelName[10] = "Level 10: The Pacific";
levelName[11] = "Level 11: The Pacific";
levelName[12] = "Level 12: The Pacific";
levelName[13] = "Level 13: The Pacific";
levelName[14] = "Level 14: The Pacific";
	 */	
	public class BaseLevel
	{
		public var level:int ; //从0开始
		public var name:String="The Pacific..." ;
		public var speed:Number = 0 ; //速度增长量
		public var fish1Count:int ;
		public var fish2Count:int ;
		public var fish3Count:int ;
		public var fish4Count:int ;
		public var fish5Count:int ;
		public var starCount:int ;
		public var requireFish:Array ;//需要3个值 , 表示吃几个会长大一级
		public var requireScore:int ; //需要的分数，达到该分数才能过关
		
		public var fish1Speed:Number ;
		public var fish2Speed:Number ;
		public var fish3Speed:Number ;
		public var fish4Speed:Number ;
		public var fish5Speed:Number ;
		public var starSpeed:Number ;
	}
}
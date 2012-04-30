package local.views.effects
{
	import flash.display.MovieClip;
	/**
	 * 建筑修建时的状态 
	 * @author zzhanglin
	 */	
	public class BuildStatus extends MovieClip
	{
		
		/**
		 * 1_1 , 2_2 , 3_3 , 1_2 , 2_1
		 * 
		 */		
		public function BuildStatus()
		{
			super();
			mouseEnabled = mouseChildren = false ;
			stop();
		}
	}
}
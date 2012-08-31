package bing.utils
{
	import flash.display.DisplayObject;
	
	public class FixScale
	{
		/**
		 * 将元件等比例设置宽高 
		 * @param mc
		 * @param fixWid
		 * @param fixHet
		 * @return 
		 */		
		public static function setScale(mc:DisplayObject , fixWid:int , fixHet:int ):DisplayObject
		{
			if(mc.width<fixWid && mc.height<fixHet )
			{
				return mc;
			}
			if(mc.width/mc.height>fixWid/fixHet)
			{
				//根据宽度
				mc.height = mc.height/mc.width * fixHet ;
				mc.width = fixWid ;
			}else{
				//根据高度
				mc.width = mc.width/mc.height * fixWid ;
				mc.height = fixHet ;
			}
			return mc
		}
	
	}
}
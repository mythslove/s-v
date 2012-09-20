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
			if(mc.width<fixWid && mc.height<fixHet ) return mc;
			
			if(mc.height>fixHet) {
				var scale:Number = fixHet/mc.height ;
				mc.height *= scale ;
				mc.width *= scale ;
			}
			if(mc.width>fixWid){
				scale = fixWid/mc.width ;
				mc.height *= scale ;
				mc.width *= scale ;
			}
			return mc ;
		}
	
	}
}
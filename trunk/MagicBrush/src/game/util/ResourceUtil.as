package game.util
{
	import bing.res.ResPool;
	
	public class ResourceUtil extends ResPool
	{
		private static var _instance:ResourceUtil; 
		
		public function ResourceUtil()
		{
			if(_instance){
				throw new Error("重复实例化");
			}
			this.cdns = Vector.<String>(["res/",""]); 
			this.maxLoadNum = 4 ;
			this.isRemote = false ;
		}
		public static function get instance():ResourceUtil
		{
			if(!_instance) _instance = new ResourceUtil();
			return _instance ;
		}
		//====================================
	}
}
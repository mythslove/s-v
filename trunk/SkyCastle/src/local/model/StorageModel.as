package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameRemote;
	

	/**
	 * 收藏箱的Model 
	 * @author zzhanglin
	 */	
	public class StorageModel
	{
		private static var _instance:StorageModel;
		public static function get instance():StorageModel
		{
			if(!_instance) _instance = new StorageModel();
			return _instance; 
		}
		//=================================
		
		private var _ro:GameRemote ;
		public function PlayerModel()
		{
			_ro = new GameRemote("PlayerService");
			_ro.addEventListener(ResultEvent.RESULT ,  onResultHandler );
		}
		private function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result );
			switch( e.method )
			{
				case "getStroage":
					break ;
			}
		}
		
		/**
		 * 获取收藏箱中的内容 
		 */		
		public function getStorageItems():void
		{
			_ro.getOperation("getStroage").send();
		}
	}
}
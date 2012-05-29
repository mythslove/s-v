package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameRemote;
	import local.comm.GlobalDispatcher;
	import local.events.FriendEvent;
	import local.model.vos.FriendVO;
	import local.model.vos.PageVO;

	/**
	 * 好友 
	 * @author zhouzhanglin
	 */	
	public class FriendModel
	{
		private static var _instance:FriendModel;
		public static function get instance():FriendModel
		{
			if(!_instance) _instance = new FriendModel();
			return _instance; 
		}
		//=================================
		/** 好友列表 */
		public var friends:PageVO ;
		
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
				case "getFriends":
					friends = e.result as PageVO ;
					if(friends.data){
						var evt:FriendEvent = new FriendEvent( FriendEvent.GET_FRIENDS );
						evt.friends = Vector.<FriendVO>(friends.data);
						GlobalDispatcher.instance.dispatchEvent( evt );
					}
					break ;
			}
		}
		
		/**
		 * 获取好友列表 
		 * @param page 显示第几页
		 * @param num 每页显示几个数据
		 */		
		public function getFriends( page:int , num:int ):void
		{
			_ro.getOperation("getFriends").send( page , num );
		}
	}
}
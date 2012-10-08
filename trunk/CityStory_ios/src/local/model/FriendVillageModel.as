package local.model
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.util.PopUpManager;
	import local.util.ResourceUtil;
	import local.vo.BuildingVO;
	import local.vo.LandVO;
	import local.vo.PlayerVO;

	/**
	 * 好友村庄 
	 * @author zhouzhanglin
	 */	
	public class FriendVillageModel
	{
		private static var _instance:FriendVillageModel;
		public static function get instance():FriendVillageModel
		{
			if(!_instance) _instance = new FriendVillageModel();
			return _instance; 
		}
		//=================================
		
		/** 正在扩地的部分 */
		public var expandBuilding:BuildingVO;
		
		/** 基本的建筑 */
		public var basicTrees:Vector.<BuildingVO> ; 
		
		/** 家 */
		public var homes:Vector.<BuildingVO>;
		
		/** 装饰 */
		public var decorations:Vector.<BuildingVO>;
		
		/** 工厂*/
		public var industry:Vector.<BuildingVO> ;
		
		/** 商业*/
		public var business:Vector.<BuildingVO> ;
		
		/** 奇迹*/
		public var wonders:Vector.<BuildingVO> ;
		
		/** 交流场所 */
		public var community:Vector.<BuildingVO> ;
		
		/** 当前玩家拥有的地钱 */
		public var lands:Vector.<LandVO> ;
		
		public var playerVO:PlayerVO ;
		
		public var id:String ;
		
		
		/**
		 * 加载好友的村庄
		 * @param id
		 */		
		public function loadFridendVillage( id:String ):void
		{
			this.id = id ;
			//添加loadding界面
			GameWorld.instance.runUpdate = false ;
			PopUpManager.instance.clearAll();
			var loading:Sprite = new Sprite();
			PopUpManager.instance.addQueuePopUp( loading );
			
			//加载好友的村庄文件
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE , loadedHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR , errorHandler );
			urlLoader.load( new URLRequest("C:\\village.bin") );
		}
		
		/**
		 * 好友村庄数据加载成功后 
		 * @param e
		 */		
		private function loadedHandler( e:Event  ):void
		{
			var urlLoader:URLLoader = e.target as URLLoader ;
			urlLoader.removeEventListener(Event.COMPLETE , loadedHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , errorHandler );
			var bytes:ByteArray = e.target.data as ByteArray ;
			
			//读玩家信息
			playerVO = bytes.readObject() as PlayerVO ;
			//读取地图信息
			expandBuilding = bytes.readObject() as BuildingVO ;
			basicTrees = bytes.readObject() as Vector.<BuildingVO> ;
			homes =  bytes.readObject() as Vector.<BuildingVO> ;
			community =  bytes.readObject() as Vector.<BuildingVO> ;
			decorations =  bytes.readObject() as Vector.<BuildingVO> ;
			industry =  bytes.readObject() as Vector.<BuildingVO> ;
			wonders =  bytes.readObject() as Vector.<BuildingVO> ;
			business =  bytes.readObject() as Vector.<BuildingVO> ;
			//lands
			lands = bytes.readObject() as Vector.<LandVO> ;
			
			//删除资源
			ResourceUtil.instance.deleteRes( id );
			
			//移除loading
			PopUpManager.instance.removeCurrentPopup();
			
			//显示村庄
			GameWorld.instance.clearWorldAndData();
			GameWorld.instance.initMap( false ) ;
			GameWorld.instance.showBuildings(false);
			GameData.villageMode = VillageMode.VISIT ;
		}
		
		/**
		 * 加载失败 
		 * @param e
		 */		
		private function errorHandler( e:IOErrorEvent ):void
		{
			var urlLoader:URLLoader = e.target as URLLoader ;
			urlLoader.removeEventListener(Event.COMPLETE , loadedHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR , errorHandler );
			//移除loading，回到自己的村庄
			GameWorld.instance.goHome();
		}
		
		
		/**
		 * 清除好友的村庄数据 
		 */		
		public function clear():void
		{
			basicTrees = null ;
			homes = null ;
			decorations = null ;
			industry  = null ;
			business = null ;
			wonders  = null ;
			community = null ;
			lands  = null ;
			playerVO = null ;
		}
	}
}
package local.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.event.VillageEvent;
	import local.model.BuildingModel;
	import local.model.CompsModel;
	import local.model.LandModel;
	import local.model.PlayerModel;
	import local.model.QuestModel;
	import local.model.StorageModel;
	import local.vo.BuildingVO;
	import local.vo.LandVO;
	import local.vo.PlayerVO;
	import local.vo.QuestVO;
	import local.vo.StorageBuildingVO;
	
	public class VillageUtil
	{
		private static var _instance:VillageUtil ;
		public static function get instance():VillageUtil
		{
			if(!_instance) _instance = new VillageUtil();
			return _instance;
		}
		//=======================================
		
		private var _bytes:ByteArray = new ByteArray();
		
		/**
		 * 一分钟保存一次数据 
		 */		
		public function startIntervalSave():void
		{
			setInterval( saveVillage , 60000 );
		}
		
		/**
		 * 保存村庄信息 
		 */		
		public function saveVillage():void
		{
			//保存文件
			var file:File = new File( File.applicationStorageDirectory.url+"res/"+GameSetting.fdId+".bin");
			_bytes.clear();
			var stream:FileStream = new FileStream();
			stream.open( file , FileMode.WRITE );
			try
			{
				//写玩家信息
				_bytes.writeObject( PlayerModel.instance.me );
				//地图上的建筑
				_bytes.writeObject( BuildingModel.instance.expandBuilding );
				_bytes.writeObject( BuildingModel.instance.basicTrees );
				_bytes.writeObject( BuildingModel.instance.homes );
				_bytes.writeObject( BuildingModel.instance.community );
				_bytes.writeObject( BuildingModel.instance.decorations );
				_bytes.writeObject( BuildingModel.instance.industry );
				_bytes.writeObject( BuildingModel.instance.wonders );
				_bytes.writeObject( BuildingModel.instance.business );
				//lands
				_bytes.writeObject( LandModel.instance.lands );
				//收藏箱中的信息
				_bytes.writeObject( StorageModel.instance.homes );
				_bytes.writeObject( StorageModel.instance.community );
				_bytes.writeObject( StorageModel.instance.decors );
				_bytes.writeObject( StorageModel.instance.industry );
				_bytes.writeObject( StorageModel.instance.wonders );
				_bytes.writeObject( StorageModel.instance.business );
				//写任务
				_bytes.writeObject(QuestModel.instance.currentQuests );
				_bytes.writeObject(QuestModel.instance.completedQuests );
				//Component
				_bytes.writeObject( CompsModel.instance.myComps ) ;
			}
			catch( e:Error)
			{
				trace(e.message);
			}
			finally
			{
				stream.writeBytes( _bytes );
				stream.close();
			}
		}
		
		
		/**
		 * 读取玩家村庄信息 
		 */		
		public function readVillage():void
		{
			var file:File = new File( File.applicationStorageDirectory.url+"res/"+GameSetting.fdId+".bin");
			trace(file.nativePath);
			if(!file.exists) {
				file = new File(File.applicationDirectory.url+"res/village.bin");
			}
			if(file.exists)
			{
				var stream:FileStream = new FileStream();
				try
				{
					stream.open( file , FileMode.READ );
					//读玩家信息
					var player:PlayerVO = stream.readObject() as PlayerVO ;
					if(player){
						PlayerModel.instance.me = player ;
					}else{
						PlayerModel.instance.createPlayer() ;
					}
					
					/*-----------------测试数据---------------------------------------*/
					PlayerModel.instance.me.energy = 400 ;
					PlayerModel.instance.me.goods = 400 ;
					PlayerModel.instance.me.cash = 10000 ;
					PlayerModel.instance.me.coin = 10000 ;
					/*-----------------测试数据---------------------------------------*/
					//读取地图信息
					BuildingModel.instance.expandBuilding = stream.readObject() as BuildingVO ;
					BuildingModel.instance.basicTrees = stream.readObject() as Vector.<BuildingVO> ;
					BuildingModel.instance.homes =  stream.readObject() as Vector.<BuildingVO> ;
					BuildingModel.instance.community =  stream.readObject() as Vector.<BuildingVO> ;
					BuildingModel.instance.decorations =  stream.readObject() as Vector.<BuildingVO> ;
					BuildingModel.instance.industry =  stream.readObject() as Vector.<BuildingVO> ;
					BuildingModel.instance.wonders =  stream.readObject() as Vector.<BuildingVO> ;
					BuildingModel.instance.business =  stream.readObject() as Vector.<BuildingVO> ;
					//lands
					LandModel.instance.lands = stream.readObject() as Vector.<LandVO> ;
					if(!LandModel.instance.lands) LandModel.instance.initLands() ;
					//读取收藏箱信息
					StorageModel.instance.homes =  stream.readObject() as Vector.<StorageBuildingVO> ;
					StorageModel.instance.community =  stream.readObject() as Vector.<StorageBuildingVO> ;
					StorageModel.instance.decors =  stream.readObject() as Vector.<StorageBuildingVO> ;
					StorageModel.instance.industry =  stream.readObject() as Vector.<StorageBuildingVO> ;
					StorageModel.instance.wonders =  stream.readObject() as Vector.<StorageBuildingVO> ;
					StorageModel.instance.business =  stream.readObject() as Vector.<StorageBuildingVO> ;
					//读任务
					QuestModel.instance.currentQuests = stream.readObject() as Vector.<QuestVO>;
					QuestModel.instance.completedQuests = stream.readObject() as Dictionary ;
					//掉落物
					var bytes:ByteArray = new ByteArray();
					stream.readBytes( bytes );
					CompsModel.instance.myComps = bytes.readObject() as Dictionary ;
				}
				finally
				{
					stream.close();
					//村庄信息已经读取完成
					GlobalDispatcher.instance.dispatchEvent( new VillageEvent(VillageEvent.READED_VILLAGE));
				}
			}
			else
			{
				GlobalDispatcher.instance.dispatchEvent( new VillageEvent(VillageEvent.NEW_VILLAGE));
			}
		}
	}
}
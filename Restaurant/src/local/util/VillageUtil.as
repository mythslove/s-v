package local.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	
	import local.comm.GlobalDispatcher;
	import local.event.VillageEvent;
	import local.model.PlayerModel;
	import local.model.RoomItemsModel;
	import local.vo.ItemVO;
	import local.vo.PlayerVO;
	
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
			var file:File = new File( File.applicationStorageDirectory.url+"res/room.bin");
			_bytes.clear();
			var stream:FileStream = new FileStream();
			stream.open( file , FileMode.WRITE );
			try
			{
				//写玩家信息
				_bytes.writeObject( PlayerModel.instance.me );
				//地图上的建筑
				_bytes.writeObject( RoomItemsModel.instance.wallDecors);
				_bytes.writeObject( RoomItemsModel.instance.wallPapers);
				_bytes.writeObject( RoomItemsModel.instance.floors);
				_bytes.writeObject( RoomItemsModel.instance.chairs);
				_bytes.writeObject( RoomItemsModel.instance.tables);
				_bytes.writeObject( RoomItemsModel.instance.counters);
				_bytes.writeObject( RoomItemsModel.instance.decorations);
				_bytes.writeObject( RoomItemsModel.instance.stoves);
				//收藏箱中的信息
				//写任务
				//Component
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
			var file:File = new File( File.applicationStorageDirectory.url+"res/room.bin");
			trace(file.nativePath);
			if(!file.exists) {
				file = new File(File.applicationDirectory.url+"res/config/room.bin");
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
					PlayerModel.instance.me.cash = 10000 ;
					PlayerModel.instance.me.coin = 10000 ;
					/*-----------------测试数据---------------------------------------*/
					//读取地图信息
					RoomItemsModel.instance.wallDecors = stream.readObject() as Vector.<ItemVO>;
					RoomItemsModel.instance.wallPapers = stream.readObject() as Vector.<ItemVO>;
					RoomItemsModel.instance.floors = stream.readObject() as Vector.<ItemVO>;
					RoomItemsModel.instance.chairs = stream.readObject() as Vector.<ItemVO>;
					RoomItemsModel.instance.tables = stream.readObject() as Vector.<ItemVO>;
					RoomItemsModel.instance.counters = stream.readObject() as Vector.<ItemVO>;
					RoomItemsModel.instance.decorations = stream.readObject() as Vector.<ItemVO>;
					RoomItemsModel.instance.stoves = stream.readObject() as Vector.<ItemVO>;
					//读取收藏箱信息
					//读任务
					//掉落物
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
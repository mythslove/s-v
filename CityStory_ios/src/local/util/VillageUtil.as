package local.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getTimer;
	
	import local.comm.GlobalDispatcher;
	import local.event.VillageEvent;
	import local.model.LandModel;
	import local.model.PlayerModel;
	import local.vo.LandVO;
	
	public class VillageUtil
	{
		private static var _instance:VillageUtil ;
		public static function get instance():VillageUtil
		{
			if(!_instance) _instance = new VillageUtil();
			return _instance;
		}
		//=======================================
		
		private var _time:int ;
		
		/**
		 * 保存村庄信息 
		 */		
		public function saveVillage(enforce:Boolean):void
		{
			if(!enforce){
				if(getTimer()-_time<2000){
					return ;
				}
				_time = getTimer() ;
			}
			//保存文件
			var file:File = new File( File.applicationStorageDirectory.url+"res/village.amf");
			var stream:FileStream = new FileStream();
			try
			{
				stream.open( file , FileMode.WRITE );
				//写玩家信息
				stream.writeObject( PlayerModel.instance.me );
			}
			catch( e:Error)
			{
				trace(e.message);
			}
			finally
			{
				stream.close();
			}
		}
		
		
		public function readVillage():void
		{
			
			var lands:Vector.<LandVO> = LandModel.instance.lands ;
			if(!lands) LandModel.instance.initLands() ;
			
			GlobalDispatcher.instance.dispatchEvent( new VillageEvent(VillageEvent.NEW_VILLAGE));
		}
	}
}
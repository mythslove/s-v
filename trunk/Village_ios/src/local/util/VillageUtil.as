package local.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getTimer;
	
	import local.model.PlayerModel;
	
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
		public function saveVillage():void
		{
			if(getTimer()-_time<2000){
				return ;
			}
			_time = getTimer() ;
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
		
	}
}
package local.util
{
	public class SoundManager
	{
		private static var _instance:SoundManager;
		public static function get instance():SoundManager
		{
			if(!_instance) _instance = new SoundManager();
			return _instance; 
		}
		//=================================
		
		public function playButtonSound():void
		{
			
		}
	}
}
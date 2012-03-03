package local.utils
{
	import local.game.elements.Hero;

	/**
	 * 场景上的人管理类 
	 * @author zzhanglin
	 */	
	public class CharacterManager
	{
		private static var _instance:CharacterManager ;
		public static function get instance():CharacterManager
		{
			if(!_instance) _instance = new CharacterManager();
			return _instance ;
		}
		//================================
		
		/**英雄*/
		public var hero:Hero ;
	}
}
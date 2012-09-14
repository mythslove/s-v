package local.model
{
	import flash.utils.Dictionary;
	
	import local.vo.PlayerVO;

	public class PlayerModel
	{
		private static var _instance:PlayerModel ;
		public static function get instance():PlayerModel
		{
			if(!_instance) _instance = new PlayerModel();
			return _instance;
		}
		//=======================================
		
		/** key为等级，value为LevelVO*/
		public var levels:Dictionary  ;
		
		public var me:PlayerVO ;
		
		public function addCoin( value:int ):void
		{
			me.coin+=value ;
		}
		
		public function addCash( value:int ):void
		{
			me.cash+=value ;
		}
		
		public function addEnergy( value:int ):void
		{
			
		}
		
		
		public function createPlayer():void
		{
			
		}
	}
}
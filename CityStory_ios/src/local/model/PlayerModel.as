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
		
		public function changeCoin( value:int ):void
		{
			me.coin+=value ;
		}
		
		public function changeCash( value:int ):void
		{
			me.cash+=value ;
		}
		
		public function changeEnergy( value:int ):void
		{
			me.energy+=value ;
		}
		
		public function createPlayer():void
		{
			me = new PlayerVO();
		}
	}
}
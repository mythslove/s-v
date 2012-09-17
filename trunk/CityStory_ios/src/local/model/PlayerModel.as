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
			if(value==0) return ;
			me.coin+=value ;
		}
		
		public function changeCash( value:int ):void
		{
			if(value==0) return ;
			me.cash+=value ;
		}
		
		public function changeExp( value:int ):void
		{
			if(value==0) return ;
			me.exp+=value ;
		}
		
		public function changeEnergy( value:int ):void
		{
			if(value==0) return ;
			me.energy+=value ;
		}
		
		public function changeGoods( value:int ):void
		{
			if(value==0) return ;
			me.goods+=value ;
		}
		
		public function changePop( value:int ):void
		{
			if(value==0) return ;
			me.pop+=value;
		}
		
		public function changeCap( value:int ):void
		{
			if(value==0) return ;
			me.cap += value ;
		}
		
		public function createPlayer():void
		{
			me = new PlayerVO();
		}
	}
}
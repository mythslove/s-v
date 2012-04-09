package local.model.vos
{
	import local.model.PlayerModel;
	import local.model.map.vos.MapVO;

	/**
	 * 玩家 
	 * @author zzhanglin
	 */	
	public class PlayerVO
	{
		public var uid:String ; //玩家id
		
		public var pfid:String ; //第三方平台id
		
		public var name:String ; //名称 
		
		public var buildings:Array ; //建筑
		
		/** 已经砍过的基础建筑 ，key为nodeX_nodeZ，value为currentStep*/
		public var basicItems:Object ;
		
		public var gender:int ;  //0 , 1, 2为未知
		
		public var platform:String ;
		
		private var _level:int ; //等级
		
		private var _wood:int ; //木材
		
		private var _stone:int ; //石料
		
		private var _coin:int ; //金币
		
		private var _cash:int ; //钱
		
		public var maxExp:int =100;//最大经验值
		
		public var minExp:int ; //最小经验值
		
		private var _exp:int ; //当前经验值
		
		public var maxEnergy:int =10; //最大能量
		
		private var _energy:int ; //能量
		
		public function get energy():int
		{
			return _energy;
		}

		public function set energy(value:int):void
		{
			if(value<0) value=0 ;
			else if(value>maxEnergy) value = maxEnergy ;
			_energy = value;
		}

		public function get exp():int
		{
			return _exp;
		}

		public function set exp(value:int):void
		{
			if(value>maxExp) {
				PlayerModel.instance.sendLevelUp(_level);
			}
			_exp = value;
		}

		public function get cash():int
		{
			return _cash;
		}

		public function set cash(value:int):void
		{
			_cash = value;
		}

		public function get coin():int
		{
			return _coin;
		}

		public function set coin(value:int):void
		{
			_coin = value;
		}

		public function get stone():int
		{
			return _stone;
		}

		public function set stone(value:int):void
		{
			_stone = value;
		}

		public function get wood():int
		{
			return _wood;
		}

		public function set wood(value:int):void
		{
			_wood = value;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

	}
}
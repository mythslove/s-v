package local.model.village.vos
{
	/**
	 * 玩家 
	 * @author zzhanglin
	 */	
	public class PlayerVO
	{
		public var id:String ; //玩家id
		
		public var name:String ; //名称 
		
		private var _level:int ; //等级
		
		private var _wood:int ; //木材
		
		private var _stone:int ; //石料
		
		private var _coin:int ; //金币
		
		private var _cash:int ; //钱
		
		public var maxExp:int ;//最大经验值
		
		public var minExp:int ; //最小经验值
		
		private var _exp:int ; //当前经验值
		
		public var maxEnergy:int ; //最大能量
		
		public var minEnergy:int ; //最小能量
		
		private var _energy:int ; //能量
		
		public function get energy():int
		{
			return _energy;
		}

		public function set energy(value:int):void
		{
			_energy = value;
		}

		public function get exp():int
		{
			return _exp;
		}

		public function set exp(value:int):void
		{
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
package game.vos
{
	import flash.utils.Dictionary;
	
	import game.comm.GameSetting;

	public class CarVO
	{
		public var id:int ; //车子的id
		public var name:String; //车的名称
		public var costCoin:int ; //买/解锁需要花多少coin
		public var costCash:int ; //买/解锁需要花多少cash
		public var requireLevel:int ; //买/解锁需要玩家的等级
		public var carParams:Dictionary ;//参数，key为CarParamVO的name , value为CarParamVO对象
		
		public function get carUrl():String
		{
			return "car/Car"+id+GameSetting.TEXTURE_TYPE ;
		}
		public function get carXMLUrl():String
		{
			return "car/Car"+id+".xml";
		}
	}
}
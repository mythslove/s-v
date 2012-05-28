package local.model.vos
{
	import local.comm.GameData;
	import local.enum.QuestType;
	import local.model.PlayerModel;
	import local.model.QuestModel;
	import local.model.map.vos.MapVO;
	import local.views.CenterViewContainer;
	
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
		
		/** 玩家已经收集了的pickup ,key 为pickupId，value为数量*/
		public var pickups:Object ; 
		
		/** 玩家的收集统计, key为groupId , value为兑换等级*/
		public var collections:Object ;
		
		public var gender:int ;  //0 , 1, 2为未知
		
		public var platform:String ;
		
		private var _rank:int ; //繁荣度
		
		private var _level:int ; //等级
		
		private var _wood:int ; //木材
		
		private var _stone:int ; //石料
		
		private var _coin:int ; //金币
		
		private var _cash:int ; //钱
		
		public var maxExp:int =100;//最大经验值
		
		private var _exp:int ; //当前经验值
		
		public var maxEnergy:int =10; //最大能量
		
		private var _energy:int ; //能量
		
		public function get rank():int
		{
			return _rank;
		}
		
		public function set rank(value:int):void
		{
			_rank = value;
			if(GameData.isHome){
				CenterViewContainer.instance.topBar.updateRank() ;
			}
		}
		
		public function get energy():int
		{
			return _energy;
		}
		
		public function set energy(value:int):void
		{
			if(value<0) value=0 ;
			else if(value>maxEnergy) value = maxEnergy ;
			_energy = value;
			if(GameData.isHome){
				CenterViewContainer.instance.topBar.updateEnergy() ;
			}
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
			if(GameData.isHome){
				CenterViewContainer.instance.topBar.updateExp();
			}
		}
		
		public function get cash():int
		{
			return _cash;
		}
		
		public function set cash(value:int):void
		{
			_cash = value;
			if(GameData.isHome){
				CenterViewContainer.instance.topBar.updateCash();
			}
		}
		
		public function get coin():int
		{
			return _coin;
		}
		
		public function set coin(value:int):void
		{
			_coin = value;
			if(GameData.isHome){
				CenterViewContainer.instance.topBar.updateCoin();
			}
		}
		
		public function get stone():int
		{
			return _stone;
		}
		
		public function set stone(value:int):void
		{
			_stone = value;
			
			if(GameData.isHome){
				CenterViewContainer.instance.topBar.updateStone();
			}
		}
		
		public function get wood():int
		{
			return _wood;
		}
		
		public function set wood(value:int):void
		{
			_wood = value;
			if(GameData.isHome){
				CenterViewContainer.instance.topBar.updateWood();
			}
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set level(value:int):void
		{
			_level = value;
			if(GameData.isHome){
				CenterViewContainer.instance.topBar.updateExp();
			}
		}
		
	}
}
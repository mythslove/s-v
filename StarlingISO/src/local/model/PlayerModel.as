package local.model
{
	import flash.utils.Dictionary;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.QuestType;
	import local.map.GameWorld;
	import local.view.CenterViewLayer;
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
//			CenterViewLayer.instance.topBar.coinBar.show( me.coin );
		}
		
		public function changeCash( value:int ):void
		{
			if(value==0) return ;
			me.cash+=value ;
//			CenterViewLayer.instance.topBar.cashBar.show( me.cash );
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
//			CenterViewLayer.instance.topBar.energyBar.show( me.energy , me.maxEnergy );
		}
		
		public function changeGoods( value:int ):void
		{
			if(value==0) return ;
			me.goods+=value ;
			if(me.goods>me.maxGoods){
				me.goods = me.maxGoods ;
			}
//			CenterViewLayer.instance.topBar.goodsBar.show( me.goods );
		}
		
		public function changePop( value:int ):void
		{
			if(value==0) return ;
			me.pop+=value;
			
			//人口任务
//			QuestUtil.instance.handleOwn( QuestType.HAVE_POP );
		}
		
		public function changeCap( value:int ):void
		{
			if(value==0) return ;
			me.cap += value ;
		}
		
		/** 返回当前的人口，不超过容量*/
		public function getCurrentPop():int
		{
			if(me.pop>me.cap) return me.cap;
			return me.pop;
		}
		
		/**
		 * 改玩家新手指引的步数 
		 * @param value
		 */		
		public function changeTutorStep( value:int =1  ):void
		{
//			me.tutorStep+= value ;
//			if(me.tutorStep>= GameSetting.TUTOR_STEP){
//				trace("新手指引完成");
//				GameData.isShowTutor = false ;
//				TutorView.instance.dispose();
//				TutorView.instance.parent.removeChild( TutorView.instance );
//				CenterViewLayer.instance.topBar.mouseChildren = true ;
//				GameWorld.instance.iconScene.mouseChildren = true ;
//			}
		}
		
		public function createPlayer():void
		{
			me = new PlayerVO();
		}
		
	}
}
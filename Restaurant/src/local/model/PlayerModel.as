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
		
		public function changeHappy( value:int ):void
		{
			if(value==0) return ;
			me.happy+=value;
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
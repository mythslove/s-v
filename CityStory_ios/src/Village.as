package
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import local.comm.GlobalDispatcher;
	import local.event.VillageEvent;
	import local.map.GameWorld;
	import local.model.PlayerModel;
	import local.util.VillageUtil;
	import local.view.CenterViewLayer;
	import local.vo.PlayerVO;
	
	import net.hires.debug.Stats;

	public class Village extends BaseVillage
	{
		protected var _villageUtil:VillageUtil ;
		
		public function Village()
		{
			super();
		}
		
		override protected function initGame():void
		{
			super.initGame();
			
			GlobalDispatcher.instance.addEventListener( VillageEvent.READED_VILLAGE , villageEvtHandler );
			GlobalDispatcher.instance.addEventListener( VillageEvent.NEW_VILLAGE , villageEvtHandler );
			_villageUtil = new VillageUtil();
			_villageUtil.readVillage();
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE , activateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE , deactivateHandler );
		}
		
		private function activateHandler( e:Event ):void {
			GameWorld.instance.buildingScene.refreshBuildingStatus();
		}
		
		private function deactivateHandler( e:Event ):void {
			_villageUtil.saveVillage( true );
		}
		
		private function villageEvtHandler( e:VillageEvent ):void
		{
			GlobalDispatcher.instance.removeEventListener( VillageEvent.READED_VILLAGE , villageEvtHandler );
			GlobalDispatcher.instance.removeEventListener( VillageEvent.NEW_VILLAGE , villageEvtHandler );
			
			addChild( GameWorld.instance );
			addChild( CenterViewLayer.instance );
			addChild( new Stats() );
			
			
//			showDailyRewards();
			GameWorld.instance.showBuildings();
		}
		
		//显示每日奖励
		private function showDailyRewards():void
		{
			var me:PlayerVO = PlayerModel.instance.me;
			var result:int = 0 ; //0为第一天奖励，1为奖励天数+1
			var tempDate:Date = new Date();
			var today:Date = new Date(tempDate.fullYear,tempDate.month,tempDate.date);
			if(me.dailyRewardsTime)
			{
				var last:Date = new Date(me.dailyRewardsTime[0],me.dailyRewardsTime[1],me.dailyRewardsTime[2]);
				result = (today.time-last.time)/86400000;
				if(result==0){
					return ; //同一天
				}
				result= result==1?1:0 ;
			}
//			var dailyRewardsPop:DailyRewardsPopUp = new DailyRewardsPopUp(today,result);
//			PopUpManager.instance.addQueuePopUp(dailyRewardsPop);
		}
	}
}
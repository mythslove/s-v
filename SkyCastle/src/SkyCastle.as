package
{
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
	import local.model.PlayerModel;
	import local.model.buildings.vos.*;
	import local.model.map.vos.MapVO;
	import local.model.vos.*;
	import local.utils.SoundManager;
	
	
	/**
	 * http://199.68.199.132/phpmyadmin/index.php  root	3bear#lcx@
	 *  
	 */	
	[SWF( width="760",height="640",backgroundColor="#ffffff",frameRate="30")]
	public class SkyCastle extends BaseGame
	{
		/**
		 * 游戏主类构造函数 
		 */		
		public function SkyCastle()
		{
			super();
			stage.align="TL";
			stage.scaleMode = "noScale";
			stage.showDefaultContextMenu = false ;
			Security.allowDomain("*");
			GameData.APP = this ;
			TweenPlugin.activate([BezierPlugin, GlowFilterPlugin]);
		}
		
		override protected function init():void
		{
			super.init();
			//获取参数
			var params:Object = loaderInfo.parameters ;
			GameData.me_uid = params["player_id"];
			GameData.me_uid= "1";
			//注册vo
			registerVOs();
		}
		
		/**
		 * 资源下载完成
		 */		
		override protected function inited():void
		{
			super.inited();
			GlobalDispatcher.instance.addEventListener(UserInfoEvent.USER_INFO_UPDATED , getMeInfoHandler );
			PlayerModel.instance.getPlayer( GameData.me_uid , GameData.currentMapId ) ;
		}
		
		/**
		 *  注册vo 
		 */		
		private function registerVOs():void
		{
			registerClassAlias("BaseBuildingVO",BaseBuildingVO) ;
			registerClassAlias("BaseCharacterVO",BaseCharacterVO) ;
			registerClassAlias("BaseMobVO",BaseMobVO) ;
			registerClassAlias("BasePlantVO",BasePlantVO) ;
			registerClassAlias("BaseDecorationVO",BaseDecorationVO) ;
			registerClassAlias("BaseFactoryVO",BaseFactoryVO) ;
			registerClassAlias("BaseHouseVO",BaseHouseVO) ;
			registerClassAlias("BaseRoadVO",BaseRoadVO) ;
			registerClassAlias("BaseStoneVO",BaseStoneVO) ;
			registerClassAlias("BaseRockVO",BaseRockVO) ;
			registerClassAlias("BaseTreeVO",BaseTreeVO) ;
			registerClassAlias("BuildingVO",BuildingVO) ;
			registerClassAlias("PlayerVO",PlayerVO) ;
			registerClassAlias("FriendVO",FriendVO) ;
			registerClassAlias("LevelVO",LevelVO) ;
			registerClassAlias("RewardsVO",RewardsVO) ;
			registerClassAlias("ShopVO",ShopVO) ;
			registerClassAlias("ShopItemVO",ShopItemVO) ;
			registerClassAlias("StorageItemVO",StorageItemVO) ;
			registerClassAlias("ConfigBaseVO",ConfigBaseVO) ;
			registerClassAlias("MapVO",MapVO) ;
			registerClassAlias("PickupVO",PickupVO) ;
			registerClassAlias("CollectionVO",CollectionVO) ;
			registerClassAlias("QuestVO",QuestVO) ;
			registerClassAlias("QuestItemVO",QuestItemVO) ;
			registerClassAlias("PageVO",PageVO) ;
		}
		
		/*获得了玩家信息后，进入游戏*/
		private function getMeInfoHandler( e:Event ):void
		{
			GlobalDispatcher.instance.removeEventListener(UserInfoEvent.USER_INFO_UPDATED , getMeInfoHandler );
			removeLoading();
			setTimeout( SoundManager.instance.playMusicBackground , 1000 );
		}
	}
}
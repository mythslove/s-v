package
{
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.system.Security;
	
	import local.comm.GameData;
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.*;
	import local.model.map.vos.MapVO;
	import local.model.vos.*;
	import local.views.CenterViewContainer;
	import local.views.LeftBar;
	
	[SWF( width="760",height="640",backgroundColor="#ffffff")]
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
		}
		
		override protected function init():void
		{
			//获取参数
			var params:Object = loaderInfo.parameters ;
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
			PlayerModel.instance.getMeInfo( GameData.currentMapId ) ;
		}
		
		/**
		 *  注册vo 
		 */		
		private function registerVOs():void
		{
			registerClassAlias("BaseBuildingVO",BaseBuildingVO) ;
			registerClassAlias("BaseCharacterVO",BaseCharacterVO) ;
			registerClassAlias("BasePlantVO",BasePlantVO) ;
			registerClassAlias("BaseCropVO",BaseCropVO) ;
			registerClassAlias("BaseDecorationVO",BaseDecorationVO) ;
			registerClassAlias("BaseFactoryVO",BaseFactoryVO) ;
			registerClassAlias("BaseHouseVO",BaseHouseVO) ;
			registerClassAlias("BaseLandVO",BaseLandVO) ;
			registerClassAlias("BaseRoadVO",BaseRoadVO) ;
			registerClassAlias("BaseStoneVO",BaseStoneVO) ;
			registerClassAlias("BaseRockVO",BaseRockVO) ;
			registerClassAlias("BaseTreeVO",BaseTreeVO) ;
			registerClassAlias("BuildingVO",BuildingVO) ;
			registerClassAlias("PlayerVO",PlayerVO) ;
			registerClassAlias("FriendVO",FriendVO) ;
			registerClassAlias("LevelUpVO",LevelUpVO) ;
			registerClassAlias("RewardsVO",RewardsVO) ;
			registerClassAlias("ShopVO",ShopVO) ;
			registerClassAlias("ShopItemVO",ShopItemVO) ;
			registerClassAlias("StorageItemVO",StorageItemVO) ;
			registerClassAlias("ConfigBaseVO",ConfigBaseVO) ;
			registerClassAlias("MapVO",MapVO) ;
		}
		
		/*获得了玩家信息后，进入游戏*/
		private function getMeInfoHandler( e:Event ):void
		{
			GlobalDispatcher.instance.removeEventListener(UserInfoEvent.USER_INFO_UPDATED , getMeInfoHandler );
			initGame();
		}
		
		/**
		 * 初始化游戏 
		 */	
		private function initGame():void
		{
			addChild(GameWorld.instance); //添加游戏世界
			addChild( new LeftBar()); //居左的容器
			addChild( CenterViewContainer.instance); //添加UI的容器
			
			GameWorld.instance.initWorld();
			
			//显示玩家信息
			CenterViewContainer.instance.topBar.setUserInfo( PlayerModel.instance.me);
		}
	}
}
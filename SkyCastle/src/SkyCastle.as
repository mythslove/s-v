package
{
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.system.Security;
	
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
	import local.game.GameWorld;
	import local.model.buildings.vos.*;
	import local.model.village.VillageModel;
	import local.model.village.vos.PlayerVO;
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
			stage.quality = StageQuality.MEDIUM;
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
			VillageModel.instance.getMeInfo() ;
		}
		
		/**
		 *  注册vo 
		 */		
		private function registerVOs():void
		{
			registerClassAlias("local.model.buildings.vos.BaseBuildingVO",BaseBuildingVO) ;
			registerClassAlias("local.model.buildings.vos.BaseCharacterVO",BaseCharacterVO) ;
			registerClassAlias("local.model.buildings.vos.BaseCropVO",BaseCropVO) ;
			registerClassAlias("local.model.buildings.vos.BaseDecorationVO",BaseDecorationVO) ;
			registerClassAlias("local.model.buildings.vos.BaseFactoryVO",BaseFactoryVO) ;
			registerClassAlias("local.model.buildings.vos.BaseHouseVO",BaseHouseVO) ;
			registerClassAlias("local.model.buildings.vos.BaseLandVO",BaseLandVO) ;
			registerClassAlias("local.model.buildings.vos.BaseRoadVO",BaseRoadVO) ;
			registerClassAlias("local.model.buildings.vos.BaseStoneVO",BaseStoneVO) ;
			registerClassAlias("local.model.buildings.vos.BaseTreeVO",BaseTreeVO) ;
			registerClassAlias("local.model.buildings.vos.BuildingVO",BuildingVO) ;
			registerClassAlias("local.model.village.vos.PlayerVO",PlayerVO) ;
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
			GameWorld.instance.start();
			
			//显示玩家信息
			CenterViewContainer.instance.topBar.setUserInfo( VillageModel.instance.me);
		}
	}
}
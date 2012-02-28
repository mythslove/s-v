package
{
	import flash.events.Event;
	import flash.net.registerClassAlias;
	
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
	import local.game.GameWorld;
	import local.model.buildings.vos.*;
	import local.model.village.VillageModel;
	import local.views.CenterViewContainer;
	import local.views.LeftBar;
	
	[SWF( width="760",height="620",backgroundColor="#ffffff")]
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
		}
		
		/**
		 * 重写父类方法
		 */		
		override protected function inited():void
		{
			super.inited();
			registerVOs();
			GlobalDispatcher.instance.addEventListener(UserInfoEvent.USER_INFO_UPDATED , getMeInfoHandler );
			VillageModel.instance.getMeInfo() ;
		}
		
		/**
		 *  注册vo 
		 */		
		private function registerVOs():void
		{
			registerClassAlias("local.model.buildings.vos.BuildingBaseVO",BaseBuildingVO) ;
			registerClassAlias("local.model.buildings.vos.BuildingVO",BuildingVO) ;
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
			
			GameWorld.instance.start();
		}
	}
}
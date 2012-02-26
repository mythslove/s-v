package
{
	import flash.net.registerClassAlias;
	
	import local.game.GameWorld;
	import local.model.buildings.vos.*;
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
			initGame();
		}
		
		/**
		 *  注册vo 
		 */		
		private function registerVOs():void
		{
			registerClassAlias("local.model.buildings.vos.BuildingBaseVO",BaseBuildingVO) ;
			registerClassAlias("local.model.buildings.vos.BuildingVO",BuildingVO) ;
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
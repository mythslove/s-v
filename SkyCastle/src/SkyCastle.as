package
{
	import map.GameWorld;
	
	import views.CenterViewContainer;
	import views.LeftBar;
	
	/**
	 * 游戏主类 
	 */	
	[SWF( width="760",height="640")]
	public class SkyCastle extends BaseGame
	{
		/**
		 * 游戏主类构造函数 
		 */		
		public function SkyCastle()
		{
			super();
		}
		
		/**
		 * 重写父类方法
		 */		
		override protected function inited():void
		{
			registerVOs();
			initGame();
		}
		
		/**
		 *  注册vo 
		 */		
		private function registerVOs():void
		{
		}
		
		/**
		 * 初始化游戏 
		 */	
		private function initGame():void
		{
			addChild(GameWorld.instance); //添加游戏世界
			addChild( new LeftBar()); //居左的容器
			addChild( CenterViewContainer.instance); //添加居中的容器
		}
	}
}
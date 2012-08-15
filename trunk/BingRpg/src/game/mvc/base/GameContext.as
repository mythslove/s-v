package game.mvc.base
{
	import bing.mvc.core.Context;
	
	import flash.display.DisplayObjectContainer;
	import flash.net.registerClassAlias;
	
	import game.mvc.control.StartUpCommand;
	import game.mvc.model.vo.*;
	
	public class GameContext extends Context
	{
		private static var _instance:GameContext ;
		
		public static function get instance():GameContext
		{
			if(_instance==null) throw new Error("未实例化此类")
			return _instance ;
		}
		
		public function GameContext(displayObjectContainer:DisplayObjectContainer)
		{
			_instance = this ;
			super(displayObjectContainer);
		}
		
		override public function preStart():void
		{
			super.preStart();
			registerVO();
		}
		
		private function registerVO():void 
		{
			registerClassAlias("game.mvc.model.vo.AniBaseVO" , AniBaseVO );
			registerClassAlias("game.mvc.model.vo.NpcVO" , NpcVO );
			registerClassAlias("game.mvc.model.vo.ItemVO" , ItemVO );
			registerClassAlias("game.mvc.model.vo.MapVO" , MapVO );
			registerClassAlias("game.mvc.model.vo.MagicVO" , MagicVO );
		}
		
		override public function startUp():void
		{
			this.contextView.stage.scaleMode="noScale" ;
			this.contextView.stage.showDefaultContextMenu = false ;
			new StartUpCommand();
		}
	}
}
package game.mvc.control
{
	import game.mvc.base.GameCommand;
	import game.mvc.view.loading.MainLoading;
	/**
	 * 游戏启动 
	 * @author zhouzhanglin
	 */	
	public class StartUpCommand extends GameCommand
	{
		public function StartUpCommand()
		{
			super();
			var loading:MainLoading = new MainLoading(2);
			contextView.addChild( loading );
		}
	}
}
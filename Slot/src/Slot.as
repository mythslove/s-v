package
{
	import game.views.CenterView;
	import game.views.topbars.TopbarBg;
	
	[SWF(width="760",height="620",backgroundColor="#000000")]
	public class Slot extends BaseGame
	{
		protected var _topbarBg:TopbarBg;
		
		public function Slot()
		{
			super();
		}
		
		override protected function inited():void
		{
			super.inited();
			
			_topbarBg = new TopbarBg();
			addChild(_topbarBg);
			
			addChild(CenterView.instance);
		}
	}
}
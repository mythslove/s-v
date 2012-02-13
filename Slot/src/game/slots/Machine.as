package game.slots
{
	import game.views.BaseView;
	
	public class Machine extends BaseView
	{
		public var logo:Logo ;
		public var lineButtons:LineButtons;
		public var iconFrames:IconFrames;
		public var iconContainer:IconContainer;
		public var linesContainer:LinesContainer;
		public var controlBar:ControlBar;
		//-------------------------------------------
		
		public function Machine()
		{
			super();
		}
	}
}
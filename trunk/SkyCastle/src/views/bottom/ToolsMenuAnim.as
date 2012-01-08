package views.bottom
{
	import flash.display.MovieClip;
	
	public class ToolsMenuAnim extends MovieClip
	{
		public var toolsMenu:ToolsMenu;
		//=========================
		
		public function ToolsMenuAnim()
		{
			super();
			this.mouseEnabled = false ;
			init();
		}
		
		private function init():void
		{
			this.addFrameScript( 0,addScript,6,addScript);
			function addScript():void{
				stop();
			}
		}
	}
}
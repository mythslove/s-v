package local.view.shop
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import local.view.control.ToggleBar;
	import local.view.control.ToggleBarEvent;
	import local.view.btn.TabMenuButton;
	
	public class HomePanel extends Sprite
	{
		private static var _instance:HomePanel;
		public static function get instance():HomePanel{
			if(!_instance) _instance = new HomePanel();
			return _instance ;
		}
		//=====================================
		
		public var mainTypeBar:ToggleBar;
		public var container:Sprite ;
		
		public function HomePanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			container = new Sprite();
			container.y = 100 ;
			addChild(container);
			
			mainTypeBar = new ToggleBar();
			var mcs:Vector.<MovieClip>= Vector.<MovieClip>([
				new TabMenuButton("ALL") ,new TabMenuButton("RESIDENCE"),new TabMenuButton("CONDOS") ,new TabMenuButton("MANSIONS") 
			]);
			mainTypeBar.buttons = mcs ;
			addChild(mainTypeBar);
			mainTypeBar.x = 10 ;
			mainTypeBar.addEventListener(ToggleBarEvent.TOGGLE_CHANGE , toggleChangeHandler);
			mainTypeBar.selected = mcs[0];
		}
		
		private function toggleChangeHandler( e:ToggleBarEvent ):void
		{
			switch(e.selectedName)
			{
				case "ALL":
					
					break;
				case "RESIDENCE":
					
					break ;
				case "CONDOS":
					
					break ;
				case "MANSIONS":
					
					break ;
			}
		}
	}
}
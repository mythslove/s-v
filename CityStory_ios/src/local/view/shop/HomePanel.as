package local.view.shop
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import local.view.control.ToggleBar;
	import local.view.control.ToggleBarEvent;
	
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
				new ShopTabButton("ALL") ,new ShopTabButton("RESIDENCE"),new ShopTabButton("CONDOS") ,new ShopTabButton("MANSIONS") 
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
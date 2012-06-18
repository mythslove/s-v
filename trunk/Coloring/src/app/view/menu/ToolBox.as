package app.view.menu
{
	import bing.components.button.ToggleBar;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	public class ToolBox extends ToggleBar
	{
		public var brushButton:MenuBrushButton ;
		public var buchketButton:MenuPaintBuchketButton ;
		//=============================
		public var status:String = "hide";
		
		public function ToolBox()
		{
			super();
			mouseEnabled = false ;
		}
		
		public function show():void
		{
			TweenLite.to(this,0.5,{y:-this.height, ease:Back.easeOut , onComplete:showTweenOver });
			mouseChildren = false ;
		}
		
		private function showTweenOver():void
		{
			mouseChildren = true ;
			status = "show";
		}
		
		public function hide():void
		{
			TweenLite.to(this,0.5,{y: -30 , ease:Back.easeIn , onComplete:hideTweenOver });
			mouseChildren = false ;
		}
		
		private function hideTweenOver():void
		{
			status = "hide";
		}
	}
}
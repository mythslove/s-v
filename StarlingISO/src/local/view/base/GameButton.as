package local.view.base
{
	import feathers.controls.Button;
	
	import local.util.GameUtil;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class GameButton extends Button
	{
		public function GameButton( defaultSkin:DisplayObject =null)
		{
			super();
			if(!defaultSkin) this.defaultSkin = defaultSkin ;
			addEventListener(TouchEvent.TOUCH , onTouchHandler );
		}
		
		private function onTouchHandler( e:TouchEvent ):void
		{
			if(e.touches.length>0){
				var touch:Touch = e.touches[0] ;
				if(touch.phase==TouchPhase.BEGAN){
					GameUtil.dark( this );
				}else if(touch.phase==TouchPhase.ENDED){
					GameUtil.light( this );
				}
			}
		}
		
		override public function dispose():void{
			super.dispose();
			removeEventListener(TouchEvent.TOUCH , onTouchHandler );
		}
	}
}
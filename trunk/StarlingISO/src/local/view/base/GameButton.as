package local.view.base
{
	import feathers.controls.Button;
	
	import local.util.GameUtil;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameButton extends Button
	{
		public function GameButton( defaultSkin:DisplayObject =null)
		{
			super();
			if(defaultSkin) this.defaultSkin = defaultSkin ;
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
		
		public function set enabled( value:Boolean ):void{
			if(value){
				GameUtil.light( this );
			}else{
				GameUtil.dark( this );
			}
			touchable = value ;
		}
		public function get enabled():Boolean{
			return touchable;
		}
		
		override public function dispose():void{
			super.dispose();
			removeEventListener(TouchEvent.TOUCH , onTouchHandler );
		}
	}
}
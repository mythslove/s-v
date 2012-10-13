package local.view.base
{
	import feathers.controls.Button;
	
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameButton extends Button
	{
		public function GameButton()
		{
			super();
			addEventListener(TouchEvent.TOUCH , onTouchHandler );
		}
		
		private function onTouchHandler( e:TouchEvent ):void
		{
			if(e.touches.length>0){
				var touch:Touch = e.touches[0] ;
				if(touch.phase==TouchPhase.BEGAN){
					for( var i:int  = 0 ; i<numChildren ; ++i ){
						if(getChildAt(i) is Quad ){
							(getChildAt(i) as Quad).color = 0x666666 ;
						}
					}
				}else if(touch.phase==TouchPhase.ENDED){
					for( i  = 0 ; i<numChildren ; ++i ){
						if(getChildAt(i) is Quad ){
							(getChildAt(i) as Quad).color = 0xffffff ;
						}
					}
				}
			}
		}
		
	}
}
package local.view.control
{
	import flash.events.MouseEvent;
	
	import local.view.base.MovieClipView;

	public class Button extends MovieClipView
	{
		protected var _enabled:Boolean = true ;
		override public function get enabled():Boolean {return _enabled;}
		override public function set enabled(value:Boolean):void {
			super.enabled = value ;
			_enabled = value;
			if(!value){
				this.gotoAndStop("disabled");
				mouseEnabled = false ;
			}else{
				this.gotoAndStop("up");
				mouseEnabled = true ;
			}
		}
		
		public function Button()
		{
			super();
			mouseChildren = false ;
		}

		override protected function addedToStage():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseHandler , false , 0 , true );
			addEventListener(MouseEvent.MOUSE_UP , onMouseHandler , false , 0 , true );
			addEventListener(MouseEvent.RELEASE_OUTSIDE,onMouseHandler , false , 0 , true );
		}
		
		protected function onMouseHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					this.gotoAndStop("down");
					break ;
				default:
					this.gotoAndStop("up");
					break ;
			}
		}
		
		override protected function removedFromStage():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN , onMouseHandler);
			removeEventListener(MouseEvent.MOUSE_UP , onMouseHandler);
			removeEventListener(MouseEvent.RELEASE_OUTSIDE , onMouseHandler );
		}
	}
}
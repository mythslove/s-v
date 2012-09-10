package local.view.control
{
	import flash.events.MouseEvent;

	public class ToggleButton extends Button
	{
		private var _selected:Boolean;
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			_selected = value;
			if(_selected){
				this.gotoAndStop("selected-up");
			}else{
				this.gotoAndStop("up");
			}
		}
		
		override public function set enabled(value:Boolean):void {
			_enabled = value;
			if(!value){
				this.gotoAndStop("disabled");
				mouseEnabled = false ;
			}else{
				var temp:String = _selected?"selected-":"";
				this.gotoAndStop(temp+"up");
				mouseEnabled = true ;
			}
		}
		
		public function ToggleButton()
		{
			super();
		}

		
		override protected function addedToStage():void
		{
			super.addedToStage() ;
			addEventListener(MouseEvent.CLICK , onMouseHandler , false , 0 , true );
		}
		
		override protected function onMouseHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					if(_selected){
						this.gotoAndStop("selected-down");
					}else{
						this.gotoAndStop("down");
					}
					break ;
				case MouseEvent.CLICK:
					_selected = !_selected ;
				case MouseEvent.MOUSE_UP:
					if(_selected){
						this.gotoAndStop("selected-up");
					}else{
						this.gotoAndStop("up");
					}
					break ;
				default:
					this.gotoAndStop("up");
					break ;
			}
		}
		
		override protected function removedFromStage():void
		{
			super.removedFromStage() ;
			removeEventListener(MouseEvent.CLICK , onMouseHandler );
		}
	}
}
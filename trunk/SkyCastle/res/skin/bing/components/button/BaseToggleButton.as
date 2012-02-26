package bing.components.button
{
	import bing.components.BingComponent;
	
	import flash.display.FrameLabel;
	import flash.events.MouseEvent;

	/**
	 * 标签包括:
	 * up , over , down , disabled
	 * selected-up , selected-over , selected-down
	 */	
	public class BaseToggleButton extends BingComponent
	{
		private var _selected:Boolean = false;

		public function BaseToggleButton()
		{
			this.stop();
		}
		
		override protected function addedToStage():void
		{
			this.buttonMode=true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER , mouseEventHandler , false, 0 , true );
			this.addEventListener(MouseEvent.MOUSE_OUT , mouseEventHandler , false, 0 , true );
			this.addEventListener(MouseEvent.MOUSE_UP , mouseEventHandler , false, 0 , true );
			this.addEventListener(MouseEvent.MOUSE_DOWN , mouseEventHandler , false, 0 , true );
		}
		
		override public function set enabled( value:Boolean ):void
		{
			super.enabled = value ;
			this.mouseEnabled = value ;
			if(value)
			{
				if(this._selected){
					this.gotoAndStop("selected-up");
				}else {
					this.gotoAndStop("up")
				}
			}
			else
			{
				this.gotoAndStop("disabled")
			}
		}

		public function set selected( value:Boolean ):void
		{
			this._selected = value;
			
			if(!this.enabled) return ;
			
			if (value){
				this.gotoAndStop( "selected-up");
			}else{
				this.gotoAndStop( "up");
			}
		}
		
		public function get selected():Boolean
		{
			return this._selected;
		}

		private function mouseEventHandler(event:MouseEvent):void
		{
			var temp:String = this.selected ? "selected-":"";
			switch (event.type)
			{
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OUT :
					if(this.enabled){
						this.gotoAndStop( temp+"up");
					}
					break;
				case MouseEvent.MOUSE_OVER :
					this.gotoAndStop( temp+"over");
					break;
				case MouseEvent.MOUSE_DOWN :
					this.gotoAndStop( temp+"down");
					this._selected = ! this.selected;
					break;
			}
		}
		
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			if(this.currentLabels){
				const LEN:int = this.currentLabels.length ;
				var bool:Boolean=false ;
				for( var i:int =0  ; i<LEN ; i++){
					if(frame is String  && (this.currentLabels[i] as FrameLabel).name==frame.toString()  )
					{
						bool = true ;
						break ;
					}
				}
				if(bool){
					super.gotoAndStop(frame,scene);
				}
			}
		}
	}

}
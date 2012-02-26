package bing.components.button
{
	import bing.components.BingComponent;
	
	import flash.display.FrameLabel;
	import flash.events.MouseEvent;

	/**
	 *标签包括
	 * up , over , down , disabled
	 */	
	public class BaseButton extends BingComponent
	{
		
		public function BaseButton()
		{
			this.stop();
		}
		
		override protected function addedToStage():void
		{
			this.buttonMode = true ;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER , mouseEventHandler , false , 0 , true );
			this.addEventListener(MouseEvent.MOUSE_UP , mouseEventHandler , false , 0 , true );
			this.addEventListener(MouseEvent.MOUSE_DOWN , mouseEventHandler , false , 0 , true );
			this.addEventListener(MouseEvent.MOUSE_OUT , mouseEventHandler , false , 0 , true );
		}

		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			this.mouseEnabled = value;
			if (value) {
				this.gotoAndStop("up");
			} else {
				this.gotoAndStop("disabled");
			}
		}

		private function mouseEventHandler(event:MouseEvent):void
		{
			switch ( event.type )
			{
				case MouseEvent.MOUSE_OUT:
					this.gotoAndStop("up");
					break ;
				case MouseEvent.MOUSE_UP :
					if(this.enabled) {
						this.gotoAndStop("over");
					}
					break;
				case MouseEvent.MOUSE_OVER :
					this.gotoAndStop("over");
					break;
				case MouseEvent.MOUSE_DOWN :
					this.gotoAndStop("down");
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
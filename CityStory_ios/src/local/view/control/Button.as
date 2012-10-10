package local.view.control
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import local.view.base.MovieClipView;

	public class Button extends MovieClipView
	{
		/** down的时候自动变暗 */
		public var autoColor:Boolean = true ;
		
		protected var _enabled:Boolean = true ;
		override public function get enabled():Boolean {return _enabled;}
		override public function set enabled(value:Boolean):void {
			super.enabled = value ;
			_enabled = value;
			if(value){
				this.gotoAndStop("up");
			}else{
				this.gotoAndStop("disabled");
			}
			mouseEnabled = value ;
		}
		
		public function Button()
		{
			super();
			mouseChildren = false ;
		}

		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
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
					if(autoColor){
						var colorTf:ColorTransform = transform.colorTransform ;
						colorTf.redMultiplier = 0.5 ;
						colorTf.greenMultiplier = 0.5 ;
						colorTf.blueMultiplier = 0.5 ;
						transform.colorTransform = colorTf ;
					}
					break ;
				default:
					this.gotoAndStop("up");
					if(autoColor){
						colorTf = transform.colorTransform ;
						if( colorTf.redMultiplier != 1 ){
							colorTf.redMultiplier = 1 ;
							colorTf.greenMultiplier = 1 ;
							colorTf.blueMultiplier = 1 ;
							transform.colorTransform = colorTf ;
						}
					}
					break ;
			}
		}
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
			removeEventListener(MouseEvent.MOUSE_DOWN , onMouseHandler);
			removeEventListener(MouseEvent.MOUSE_UP , onMouseHandler);
			removeEventListener(MouseEvent.RELEASE_OUTSIDE , onMouseHandler );
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void{
			if(totalFrames>1){
				super.gotoAndStop( frame, scene );
			}
		}
	}
}
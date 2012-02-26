package bing.components.button
{
	import flash.display.FrameLabel;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class AnimationButton extends BaseButton
	{
		protected var _lblHash:Dictionary = new Dictionary();
		
		public function AnimationButton()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			super.addedToStage();
			var len:int = currentLabels.length ;
			var frameLabel:FrameLabel ;
			for ( var i:int = 0 ; i< len ;++i )
			{
				frameLabel = currentLabels[i] ;
				if(frameLabel.frame+1<=this.totalFrames){
					_lblHash[frameLabel.name] = frameLabel.frame+1 ;
				}else{
					_lblHash[frameLabel.name] = frameLabel.frame ;
				}
				this.addFrameScript(frameLabel.frame-1,function():void{stop();});
				if( frameLabel.name=="end"){
					this.addFrameScript(frameLabel.frame-1,function():void{stop();gotoAndStop("up");});
				}
			}
		}
		
		
		override protected function mouseEventHandler(event:MouseEvent):void
		{
			switch ( event.type )
			{
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_OUT:
					this.gotoAndPlay(_lblHash["out"]);
					break ;
				case MouseEvent.MOUSE_UP :
					if(this.enabled) {
						this.gotoAndPlay(_lblHash["over"]);
					}
					break;
				case MouseEvent.MOUSE_OVER :
					this.gotoAndPlay(_lblHash["over"]);
					break;
				case MouseEvent.MOUSE_DOWN :
					this.gotoAndPlay(_lblHash["down"]);
					break;
			}
		}
	}
}
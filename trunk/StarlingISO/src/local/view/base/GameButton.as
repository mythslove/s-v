package local.view.base
{
	import com.greensock.TweenLite;
	
	import feathers.controls.Button;
	
	import local.util.GameUtil;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameButton extends Button
	{
		public function GameButton( defaultSkin:DisplayObject =null , disabledSkin:DisplayObject = null )
		{
			super();
			if(defaultSkin) this.defaultSkin = defaultSkin ;
			if(disabledSkin) this.disabledSkin = disabledSkin ;
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
				if(!disabledSkin) GameUtil.light( this );
			}else{
				if(!disabledSkin) GameUtil.dark( this );
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
		
		
		
		
		
		
		
		
		public function setVisible( value:Boolean ):void
		{
			_tempVisible = super.visible = value ;
		}
		
		private var _tempVisible:Boolean ;
		override public function set visible(value:Boolean):void
		{
			if(_tempVisible==value) return ;
			_tempVisible = value ;
			if( value){
				alpha = 0 ;
				TweenLite.to( this , 0.3 , {alpha:1 , onComplete: onTweenCom} );
			}else{
				alpha = 1 ;
				TweenLite.to( this , 0.3 , {alpha:0 , onComplete: onTweenCom} );
			}
		}
		
		private function onTweenCom():void{
			super.visible = _tempVisible ;
		}
		
	}
}
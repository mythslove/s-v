package game.gui.base
{
	import feathers.controls.Button;
	
	import game.util.GameUtil;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 游戏中的按钮，默认居中对齐 
	 * @author zhouzhanglin
	 */	
	public class GameButton extends Button
	{
		/**
		 *  按下时变暗
		 * @param defaultSkin 默认图片
		 * @param disabledSkin 不可用时的图片
		 * 
		 */		
		public function GameButton( defaultSkin:DisplayObject =null , disabledSkin:DisplayObject = null )
		{
			super();
			if(defaultSkin) {
				this.defaultSkin = defaultSkin ;
				pivotX = defaultSkin.width>>1 ;
				pivotY = defaultSkin.height>>1;
			}
			if(disabledSkin) this.disabledSkin = disabledSkin ;
			addEventListener(TouchEvent.TOUCH , onTouchHandler );
		}
		
		override public function set defaultSkin(value:DisplayObject):void{
			super.defaultSkin = value ;
			pivotX = defaultSkin.width>>1 ;
			pivotY = defaultSkin.height>>1;
		}
		
		private function onTouchHandler( e:TouchEvent ):void
		{
			if(e.touches.length>0){
				var touch:Touch = e.touches[0] ;
				if(touch.phase==TouchPhase.BEGAN){
					scaleX = scaleY = 0.8 ;
				}else if(touch.phase==TouchPhase.ENDED){
					scaleX = scaleY = 1 ;
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
			isEnabled = value ;
		}
		public function get enabled():Boolean{
			return touchable;
		}
	}
}
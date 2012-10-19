package local.view.base
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import feathers.controls.Button;
	
	import local.util.GameUtil;
	
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
			isEnabled = value ;
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
		
		private var _tempScaleX:Number = 1;
		private var _tempScaleY:Number= 1 ;
		private var _tempVisible:Boolean = true ;
		override public function set visible(value:Boolean):void
		{
			if(_tempVisible==value) return ;
			_tempVisible = value ;
			if( value){
				scaleY = scaleX = 0 ;
				touchable = false ;
				TweenLite.to( this , 0.3 , { scaleX: _tempScaleX , scaleY:_tempScaleY , ease:Back.easeOut , onComplete: onTweenCom} );
			}else{
				_tempScaleX = scaleX<0 ? -1 :1  ;
				_tempScaleY = scaleY<0 ? -1 :1  ;
				touchable = false ;
				TweenLite.to( this , 0.3 , {scaleX: 0 , scaleY:0 , ease:Back.easeIn  , onComplete: onTweenCom} );
			}
		}
		
		private function onTweenCom():void{
			super.visible = _tempVisible ;
			touchable = true ;
		}
		
	}
}
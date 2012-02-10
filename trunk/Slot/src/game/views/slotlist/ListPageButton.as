package game.views.slotlist
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	public class ListPageButton extends BaseButton
	{
		private var _visible:Boolean=true ;
		
		public function ListPageButton()
		{
			super();
			mouseChildren=false;
			buttonMode=true;
		}
		
		override public function set visible( value:Boolean ):void
		{
			_visible = value ;
			if(value){
				super.visible=true;
				TweenLite.to(this,0.5,{scaleX:1,scaleY:1,alpha:1,onComplete:tweenCom,ease:Back.easeInOut});
			}else{
				scaleX=scaleY = alpha =1;
				mouseEnabled=false;
				TweenLite.to(this,0.5,{scaleX:0,scaleY:0,alpha:0,onComplete:tweenCom,ease:Back.easeInOut});
			}
		}
		
		private function tweenCom():void
		{
			super.visible = _visible ;
			mouseEnabled=_visible;
		}
	}
}
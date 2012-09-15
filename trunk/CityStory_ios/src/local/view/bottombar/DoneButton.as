package local.view.bottombar
{
	import com.greensock.TweenLite;
	
	import local.view.control.Button;
	
	/**
	 * 地图编辑确认按钮 
	 * @author zzhanglin
	 */	
	public class DoneButton extends Button
	{
		public function DoneButton()
		{
			super();
			super.visible = false ;
		}
		
		private var _tempVisible:Boolean ;
		override public function set visible(value:Boolean):void
		{
			if(super.visible==value) return ;
			_tempVisible = value ;
			if( value){
				alpha = 0 ;
				TweenLite.to( this , 0.2 , {alpha:1 , onComplete: onTweenCom} );
			}else{
				alpha = 1 ;
				TweenLite.to( this , 0.2 , {alpha:0 , onComplete: onTweenCom} );
			}
		}
		
		private function onTweenCom():void{
			super.visible = _tempVisible ;
		}
	}
}
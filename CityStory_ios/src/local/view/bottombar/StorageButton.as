package local.view.bottombar
{
	import com.greensock.TweenLite;
	
	import local.view.control.Button;
	
	public class StorageButton extends Button
	{
		public function StorageButton()
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
				TweenLite.to( this , 0.25 , {alpha:1 , onComplete: onTweenCom} );
			}else{
				alpha = 1 ;
				TweenLite.to( this , 0.25 , {alpha:0 , onComplete: onTweenCom} );
			}
		}
		
		private function onTweenCom():void{
			super.visible = _tempVisible ;
		}
	}
}
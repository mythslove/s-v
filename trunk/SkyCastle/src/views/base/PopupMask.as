package  views.base
{
	import comm.GameSetting;
	
	import flash.display.Sprite;
	
	public class PopupMask extends Sprite
	{
		public function PopupMask( color:uint=0 , alpha:Number =0 )
		{
			super();
			this.graphics.beginFill( color , alpha );
			this.graphics.drawRect(0,0,GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT );
			this.graphics.endFill() ;
		}
		
	}
}
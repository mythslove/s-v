package local.views.loading
{
	import flash.display.Sprite;
	
	import local.comm.GameSetting;
	
	public class MapChangeLoading extends Sprite
	{
		public function MapChangeLoading()
		{
			super();
			this.x = GameSetting.SCREEN_WIDTH>>1 ;
			this.y = GameSetting.SCREEN_HEIGHT>>1 ;
		}
	}
}
package local.views.effects
{
	import bing.iso.IsoScene;
	
	import local.comm.GameSetting;
	
	public class Cloud extends IsoScene
	{
		private const SPEED:Number=  1;
		
		public function Cloud()
		{
			super(GameSetting.GRID_SIZE);
		}
		
		override public function update():void
		{
			this.x-=SPEED;
			if(this.x==-500 ){
				nodeX = GameSetting.GRID_X ;
			}
		}
	}
}
package local.map.scene
{
	import bing.starling.iso.SIsoScene;
	
	import local.comm.GameSetting;
	
	public class FloorScene extends SIsoScene
	{
		public function FloorScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.MAX_SIZE , GameSetting.MAX_SIZE);
		}
	}
}
package local.map.scene
{
	import bing.starling.iso.SIsoScene;
	
	import local.comm.GameSetting;
	
	public class WallPaperScene extends SIsoScene
	{
		public function WallPaperScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.MAX_SIZE , GameSetting.MAX_SIZE);
		}
	}
}
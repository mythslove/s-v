package local.game.scenes
{
	import bing.iso.IsoScene;
	
	import local.comm.GameSetting;
	
	public class BuildingScene extends IsoScene
	{
		public function BuildingScene()
		{
			super(GameSetting.GRID_SIZE);
			mouseEnabled = false ;
		}
		
		
		
	}
}
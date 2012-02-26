package local.game.scenes
{
	import bing.iso.IsoScene;
	
	import local.comm.GameSetting;

	/**
	 * 建筑层场景 
	 * @author zzhanglin
	 */	
	public class BuildingScene extends IsoScene
	{
		public function BuildingScene()
		{
			super(GameSetting.GRID_SIZE);
		}
	}
}
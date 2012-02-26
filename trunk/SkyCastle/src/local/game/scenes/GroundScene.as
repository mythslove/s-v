package local.game.scenes
{
	import bing.iso.IsoScene;
	
	import local.comm.GameSetting;

	/**
	 * 地面层场景 
	 * @author zzhanglin
	 */	
	public class GroundScene extends IsoScene
	{
		public function GroundScene()
		{
			super(GameSetting.GRID_SIZE);
		}
	}
}
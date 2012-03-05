package map
{
	import bing.iso.IsoWorld;
	
	import comm.GameSetting;
	
	public class GameWorld extends IsoWorld
	{
		
		public function GameWorld()
		{
			super(GameSetting.MAP_WIDTH, GameSetting.MAP_HEIGHT, GameSetting.GRID_X, GameSetting.GRID_Z, GameSetting.GRID_SIZE);
		}
	}
}
package map
{
	import bing.iso.IsoWorld;
	
	public class GameWorld extends IsoWorld
	{
		public function GameWorld(width:Number, height:Number, gridX:int, gridZ:int, size:int)
		{
			super(width, height, gridX, gridZ, size);
		}
	}
}
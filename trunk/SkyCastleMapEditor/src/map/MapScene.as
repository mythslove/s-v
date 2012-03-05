package map
{
	import bing.iso.IsoScene;
	
	import comm.GameSetting;
	
	public class MapScene extends IsoScene
	{
		public function MapScene()
		{
			super( GameSetting.GRID_SIZE ,GameSetting.GRID_X, GameSetting.GRID_Z );
		}
		
		public function toString():String{
			if(parent){
				return "Layer"+parent.getChildIndex(this);
			}
			return "Layer0";
		}
		
		override public function update():void{}
	}
}
package map
{
	import bing.iso.IsoScene;
	
	import comm.GameSetting;
	
	public class MapScene extends IsoScene
	{
		public function MapScene()
		{
			super();
		}
		
		override public function toString():String{
			if(parent){
				return "Layer"+parent.getChildIndex(this);
			}
			return "Layer0";
		}
		
		override public function update():void{}
	}
}
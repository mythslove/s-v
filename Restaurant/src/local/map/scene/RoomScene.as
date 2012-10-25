package local.map.scene
{
	import bing.starling.iso.SIsoScene;
	
	import local.comm.GameSetting;
	import local.model.MapGridDataModel;
	
	public class RoomScene extends SIsoScene
	{
		public function RoomScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.MAX_SIZE , GameSetting.MAX_SIZE );
			this.gridData = MapGridDataModel.instance.gameGridData ;
		}
	}
}
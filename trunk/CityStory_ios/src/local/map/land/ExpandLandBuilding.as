package local.map.land
{
	import local.comm.GameSetting;
	import local.map.item.BaseMapObject;
	
	/**
	 * 扩地时的占位建筑
	 * @author zhouzhanglin
	 */	
	public class ExpandLandBuilding extends BaseMapObject
	{
		public function ExpandLandBuilding()
		{
			super(GameSetting.GRID_SIZE , 4 , 4);
		}
	}
}
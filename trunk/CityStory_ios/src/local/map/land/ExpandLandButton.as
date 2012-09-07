package local.map.land
{
	import local.comm.GameSetting;
	import local.map.item.BaseMapObject;

	/**
	 * 扩地的按钮 
	 * @author zhouzhanglin
	 */	
	public class ExpandLandButton extends BaseMapObject
	{
		public function ExpandLandButton()
		{
			super( GameSetting.GRID_SIZE , 4 , 4);
			mouseEnabled = mouseChildren = false ;
		}
		
		override public function showUI():void
		{
			
		}
	}
}
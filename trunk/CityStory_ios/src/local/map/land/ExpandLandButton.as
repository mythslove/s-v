package local.map.land
{
	import flash.display.Bitmap;
	
	import local.comm.GameSetting;
	import local.map.item.BaseMapObject;
	import local.util.EmbedsManager;

	/**
	 * 扩地的按钮 
	 * @author zhouzhanglin
	 */	
	public class ExpandLandButton extends BaseMapObject
	{
		public function ExpandLandButton()
		{
			super( GameSetting.GRID_SIZE*4 );
			mouseEnabled = mouseChildren = false ;
		}
		
		override public function showUI():void
		{
			var bmp:Bitmap = new Bitmap(EmbedsManager.instance.getBitmapByName("ExpandLandButton").bitmapData );
			bmp.x -= bmp.width>>1 ;
			addChild(bmp);
		}
	}
}
package local.map.land
{
	import flash.display.Bitmap;
	
	import local.comm.GameSetting;
	import local.map.item.BaseMapObject;
	import local.util.EmbedsManager;
	import local.vo.BitmapAnimResVO;
	
	/**
	 * 扩地标识 1*1 
	 * @author zhouzhanglin
	 * 
	 */	
	public class ExpandSign extends BaseMapObject
	{
		public function ExpandSign()
		{
			super(GameSetting.GRID_SIZE);
			mouseChildren = false ;
		}
		
		override public function showUI():void
		{
			var brvo:BitmapAnimResVO = EmbedsManager.instance.getAnimResVOByName("ExpandSign")[0] ;
			var bmp:Bitmap = new Bitmap(brvo.bmds[0] ) ;
			bmp.x = brvo.offsetX;
			bmp.y = brvo.offsetY;
			addChild(bmp);
		}
	}
}
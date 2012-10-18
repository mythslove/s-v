package local.map.land
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import local.comm.GameSetting;
	import local.map.item.BaseMapObject;
	import local.util.EmbedsManager;
	import local.vo.BitmapAnimResVO;
	
	/**
	 * 扩地标识 1*1 
	 * @author zhouzhanglin
	 */	
	public class ExpandSign extends BaseMapObject
	{
		private var _container:Sprite ;
		
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
			bmp.scaleX = brvo.scaleX ;
			bmp.scaleY = brvo.scaleY ;
			
			_container = new Sprite();
			addChild(_container);
			_container.addChild(bmp);
		}
		
		override public function dispose():void
		{
			super.dispose() ;
			_container = null ;
		}
	}
}
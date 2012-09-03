package local.map.item
{
	import flash.display.Bitmap;
	
	import local.comm.GameSetting;
	import local.vo.BitmapAnimResVO;

	/**
	 * 地图上基础建筑，主要是为了好看用的 
	 * @author zzhanglin
	 */	
	public class BasicBuilding extends BaseMapObject
	{
		private var _bavos:Vector.<BitmapAnimResVO> ;
		
		public function BasicBuilding( bavos:Vector.<BitmapAnimResVO> , xSpan:int=1, zSpan:int=1)
		{
			super( GameSetting.GRID_SIZE , xSpan, zSpan);
			this._bavos = bavos ;
			mouseChildren = mouseEnabled = false ;
		}
		
		override public function showUI():void
		{
			var bmp:Bitmap = new Bitmap( _bavos[0].bmds[0] );
			bmp.x =  _bavos[0].offsetX ;
			bmp.y =  _bavos[0].offsetY ;
			addChild(bmp);
		}
		
		override public function dispose():void
		{
			super.dispose() ;
			_bavos = null ;
		}
	}
}
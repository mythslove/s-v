package local.view.base
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import local.map.item.Building;
	
	public class StatusIcon extends Sprite
	{
		public var building:Building ;
		private var _bmp:Bitmap = new Bitmap() ;
		
		public function StatusIcon( building:Building )
		{
			super();
			this.building =  building ;
			addChild(_bmp);
		}
		
		public function set bitmapData( value:BitmapData ):void
		{
			_bmp.bitmapData = value ;
		}
		
		public function dispose():void
		{
			_bmp.bitmapData = null ;
			_bmp = null ;
			building = null ;
		}
	}
}
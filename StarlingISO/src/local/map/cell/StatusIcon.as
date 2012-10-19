package local.map.cell
{
	import local.map.item.Building;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class StatusIcon extends Sprite
	{
		public var building:Building ;
		private var _bmp:Image ;
		
		public function StatusIcon( building:Building)
		{
			super();
			this.building =  building ;
		}
		
		public function set texture( value:Texture ):void
		{
			if(!_bmp){
				_bmp = new Image( value );
			}else{
				_bmp.texture = value;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_bmp = null ;
			building = null ;
		}
	}
}
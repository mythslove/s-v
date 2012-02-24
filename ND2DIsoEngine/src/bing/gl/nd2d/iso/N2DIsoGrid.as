package bing.gl.nd2d.iso
{
	import bing.iso.IsoGrid;
	
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	import flash.display.BitmapData;
	
	public class N2DIsoGrid extends N2DIsoSprite
	{
		private var _isoGrid:IsoGrid ;
		
		public function N2DIsoGrid( gridX:int , gridZ:int , size:int  )
		{
			super();
			_isoGrid= new IsoGrid(gridX,gridZ,size);
		}
		
		public function render():void
		{
			_isoGrid.render();
			var bmd:BitmapData = new BitmapData( _isoGrid.width , _isoGrid.height , true , 0xffffff );
			bmd.draw( _isoGrid);
			var texture:Texture2D = Texture2D.textureFromBitmapData( bmd );
			this.setTexture( texture);
		}
	}
}
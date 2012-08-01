package bing.starling.iso
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class SIsoGrid extends Image
	{
		protected var _gridX:int ;
		protected var _gridZ:int ;
		protected var _size:int ;
		
		public function SIsoGrid( gridX:int , gridZ:int ,size:int )
		{
			super( createTexture() );
			this._gridX = gridX ;
			this._gridZ = gridZ ;
			this._size = size ;
			this.x = this.y = 100 ;
		}
		
		private function createTexture():Texture 
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle( 1 , 0xcccccc );
			var p:Vector3D =new Vector3D();
			for( var i:int =0  ; i<=_gridX ; i++ )
			{
				p.x = i*_size ;
				p.z = 0 ;
				var isoPoint:Point = SIsoUtils.isoToScreen( p);
				shape.graphics.moveTo( isoPoint.x, isoPoint.y);
				
				p.z = _gridZ*_size ;
				isoPoint = SIsoUtils.isoToScreen( p);
				shape.graphics.lineTo(  isoPoint.x, isoPoint.y);
			}
			for ( i = 0 ; i<=_gridZ ; i++)
			{
				p.z = i*_size ;
				p.x = 0 ;
				isoPoint = SIsoUtils.isoToScreen( p);
				shape.graphics.moveTo( isoPoint.x, isoPoint.y);
				
				p.x = _gridX*_size ;
				isoPoint = SIsoUtils.isoToScreen( p);
				shape.graphics.lineTo(  isoPoint.x, isoPoint.y);
			}

			var bmd:BitmapData = new BitmapData( shape.width , shape.height , true , 0xffffff );
			bmd.draw( shape );
			return  Texture.fromBitmapData(bmd,false) ;
		}
	}
}
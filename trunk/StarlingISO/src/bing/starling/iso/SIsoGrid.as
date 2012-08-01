package bing.starling.iso
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class SIsoGrid extends Sprite
	{
		public function SIsoGrid( gridX:int , gridZ:int ,size:int )
		{
			createTexture( gridX , gridZ ,size);
		}
		
		private function createTexture(gridX:int , gridZ:int ,size:int ):void 
		{
			var shape:Shape = new Shape();
			var color:uint = 0xFFFFFF ;
			shape.graphics.lineStyle(1,color);
			shape.graphics.moveTo( size , 0 );
			shape.graphics.lineTo( 2*size , size/2 );
			shape.graphics.lineTo( size , size );
			shape.graphics.lineTo( 0 , size/2 );
			shape.graphics.lineTo( size , 0);
			
			var bmd:BitmapData = new BitmapData(size*2 , size , true , 0xffffff );
			bmd.draw( shape );
			var texture:Texture = Texture.fromBitmapData(bmd,false) ;
			
			var img:Image ;
			var p:Vector3D =new Vector3D();
			for( var i:int = 0 ; i<gridX ; i++){
				for( var j:int = 0 ; j<gridZ ; j++){
					p.x = j*size ;
					p.z = i*size ;
					var isoPoint:Point = SIsoUtils.isoToScreen( p);
					img = new Image(texture) ;
					img.pivotX = size;
					img.x = isoPoint.x; 
					img.y = isoPoint.y ;
					addChild(img);
				}
			}
			this.flatten() ;
		}
	}
}
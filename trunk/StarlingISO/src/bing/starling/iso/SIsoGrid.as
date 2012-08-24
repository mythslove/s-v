package bing.starling.iso
{
	import bing.starling.component.Line;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import starling.display.Sprite;
	
	public class SIsoGrid extends Sprite
	{
		public function SIsoGrid( gridX:int , gridZ:int ,size:int )
		{
			createTexture( gridX , gridZ ,size);
		}
		
		private function createTexture(gridX:int , gridZ:int ,size:int ):void 
		{
			var line:Line;
			var p:Vector3D =new Vector3D();
			for( var i:int =0  ; i<=gridX ; i++ )
			{
				p.x = i*size ;
				p.z = 0 ;
				var isoPoint:Point = SIsoUtils.isoToScreen( p);
				line = new Line(2,0xffffff);
				line.moveTo( isoPoint.x, isoPoint.y);
				
				p.z = gridZ*size ;
				isoPoint = SIsoUtils.isoToScreen( p);
				line.lineTo(  isoPoint.x, isoPoint.y);
				addChild(line);
			}
			for ( i = 0 ; i<=gridZ ; i++)
			{
				p.z = i*size ;
				p.x = 0 ;
				isoPoint = SIsoUtils.isoToScreen( p);
				line = new Line(2,0xffffff);
				line.moveTo( isoPoint.x, isoPoint.y);
				
				p.x = gridX*size ;
				isoPoint = SIsoUtils.isoToScreen( p);
				line.lineTo(  isoPoint.x, isoPoint.y);
				addChild(line);
			}
		}
	}
}
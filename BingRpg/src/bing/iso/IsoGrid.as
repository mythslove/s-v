package bing.iso
{
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 网格 
	 * @author zhouzhanglin
	 */	
	public class IsoGrid extends Shape
	{
		protected var _gridX:int ;
		protected var _gridZ:int ;
		protected var _size:int ;
		
		public function IsoGrid( gridX:int , gridZ:int ,size:int )
		{
			super();
			this._gridX = gridX ;
			this._gridZ = gridZ ;
			this._size = size ;
		}
		
		public function render():void
		{
			this.graphics.lineStyle(1 , 0xcccccc , 0.5 );
			var p:Vector3D =new Vector3D();
			for( var i:int =0  ; i<=_gridX ; i++ )
			{
				p.x = i*_size ;
				p.z = 0 ;
				var isoPoint:Point = IsoUtils.isoToScreen( p);
				this.graphics.moveTo( isoPoint.x, isoPoint.y);
				
				p.z = _gridZ*_size ;
				isoPoint = IsoUtils.isoToScreen( p);
				this.graphics.lineTo(  isoPoint.x, isoPoint.y);
			}
			for ( i = 0 ; i<=_gridZ ; i++)
			{
				p.z = i*_size ;
				p.x = 0 ;
				isoPoint = IsoUtils.isoToScreen( p);
				this.graphics.moveTo( isoPoint.x, isoPoint.y);
				
				p.x = _gridX*_size ;
				isoPoint = IsoUtils.isoToScreen( p);
				this.graphics.lineTo(  isoPoint.x, isoPoint.y);
			}
		}
	}
}
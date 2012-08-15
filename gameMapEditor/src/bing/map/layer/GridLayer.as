package bing.map.layer
{
	import bing.map.data.MapData;
	
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * 网格 
	 * @author zhouzhanglin
	 */	
	public class GridLayer extends Sprite
	{
		
		
		private var _mapWidth:int;		//地图网格宽度
		private var _mapHeight:int;		//地图网格高度
		
		private var _tilePixelWidth:int;	//一个网格的象素宽
		private var _tilePixelHeight:int;	//一个网格的象素高
		
		private var _gridLineColor:uint = 0xbbbbbb;//线条颜色
		
		
		private var _wHalfTile:int;	//网格象素宽的一半
		private var _hHalfTile:int;	//网格象素高的一半
		
		/**
		 * 绘制网格 
		 * @param mapWidth地图网格宽度
		 * @param mapHeight地图网格高度 
		 * @param tilePixelWidth一个网格的象素宽
		 * @param tilePixelHeight一个网格的象素高
		 * 
		 */		
		public function drawGrid(mapWidth:int, mapHeight:int, tilePixelWidth:int, tilePixelHeight:int):void
		{
			this._mapWidth = mapWidth;
			this._mapHeight = mapHeight;
			this._tilePixelWidth = tilePixelWidth;
			this._tilePixelHeight = tilePixelHeight;
			var row:int = this._mapHeight/this._tilePixelHeight;
			var col:int = this._mapWidth/this._tilePixelWidth; 
			this._wHalfTile = int(this._tilePixelWidth*0.5);
			this._hHalfTile = int(this._tilePixelHeight*0.5); 
			
			this.graphics.lineStyle(1, _gridLineColor, 1);
			
			var dblMapWidth:int = col*2 + 1;
			var dblMapHeight:int = row*2 + 1;
			for (var i:int=1; i<dblMapWidth; i=i+2)
			{
				
				this.graphics.moveTo( i*this._wHalfTile, 0 );
				if (dblMapHeight+i >= dblMapWidth)
				{
					this.graphics.lineTo( dblMapWidth*this._wHalfTile, (dblMapWidth-i)*this._hHalfTile );
				}
				else
				{
					this.graphics.lineTo( (dblMapHeight+i)*this._wHalfTile, dblMapHeight*this._hHalfTile );
				}
				
				this.graphics.moveTo( i*this._wHalfTile, 0 );
				if (i <= dblMapHeight)
				{
					this.graphics.lineTo( 0, i*this._hHalfTile );
				}
				else
				{
					this.graphics.lineTo( (i-row-1)*this._wHalfTile, dblMapHeight*this._hHalfTile );
				}
			}
			
			for (var j:int=1; j<dblMapHeight; j=j+2)
			{
				
				this.graphics.moveTo( 0, j*this._hHalfTile );
				if (dblMapHeight-j >= dblMapWidth)
				{
					this.graphics.lineTo( dblMapWidth*this._wHalfTile, (dblMapWidth+j)*this._hHalfTile );
				}
				else
				{
					this.graphics.lineTo( (dblMapHeight-j)*this._wHalfTile, dblMapHeight*this._hHalfTile );
				}
			}
			
			for (var m:int=0; m<dblMapHeight; m=m+2)
			{
				this.graphics.moveTo( dblMapWidth*this._wHalfTile, m*this._hHalfTile );
				if (dblMapWidth-dblMapHeight+m < 0)
				{
					this.graphics.lineTo( 0, (dblMapWidth+m)*this._hHalfTile );
				}
				else
				{
					this.graphics.lineTo( (dblMapWidth-dblMapHeight+m)*this._wHalfTile, dblMapHeight*this._hHalfTile );
				}
			}
		}
		
		/**
		 * 刷新显示 
		 */		
		public function refresh():void{
			this.drawGrid(MapData.mapWidth,MapData.mapHeight , MapData.tileWidth , MapData.tileHeight );
		}
		
		/**
		 * 清空显示 
		 */		
		public function clearShow():void{
			this.graphics.clear();
		}
	}
}
package  bing.utils
{ 
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class GraphicsScale9Bitmap extends Shape
	{

		private var _srcBmd:BitmapData;
		private var _scale9Grid:Rectangle;
		private var _smooth:Boolean;

		public function GraphicsScale9Bitmap( srcBmd:BitmapData , $scale9Grid : Rectangle , smooth:Boolean=false)
		{
			this._srcBmd = srcBmd;
			this._smooth = smooth;
			this._scale9Grid = $scale9Grid;
		}

		public function setSize(w:Number , h:Number):void
		{
			if (this.width != w && this.height != h)
			{
				resizeGraphic(w,h);
			}
		}

		protected function resizeGraphic(w : Number, h : Number):void
		{
			var rows:Array = [0,_scale9Grid.top,_scale9Grid.bottom,_srcBmd.height];
			var cols:Array = [0,_scale9Grid.left,_scale9Grid.right,_srcBmd.width];

			var dRows : Array = [0, _scale9Grid.top, h - (_srcBmd.height - _scale9Grid.bottom), h];
			var dCols : Array = [0, _scale9Grid.left, w - (_srcBmd.width - _scale9Grid.right), w];

			var origin:Rectangle= new Rectangle();
			var draw:Rectangle = new Rectangle  ;
			var mat :Matrix = new Matrix();

			graphics.clear();
			for (var cx : int = 0; cx < 3; cx++)
			{
				for (var cy : int = 0; cy < 3; cy++)
				{
					origin.x = cols[cx];
					origin.y = rows[cy];
					origin.width = cols[cx + 1] - cols[cx];
					origin.height = rows[cy + 1] - rows[cy];

					draw.x = dCols[cx];
					draw.y = dRows[cy];
					draw.width = dCols[cx + 1] - dCols[cx];
					draw.height = dRows[cy + 1] - dRows[cy];

					mat.identity();
					mat.a = draw.width / origin.width;
					mat.d = draw.height / origin.height;
					mat.tx = draw.x - origin.x * mat.a;
					mat.ty = draw.y - origin.y * mat.d;

					graphics.beginBitmapFill(_srcBmd,mat,false,_smooth);
					graphics.drawRect(draw.x,draw.y,draw.width,draw.height);
				}
			}
			graphics.endFill();
		}

		/**
		 * setter width
		 */
		override public function set width(w : Number):void
		{
			if (w != width)
			{
				setSize(w, height);
			}
		}

		/**
		 * setter height
		 */
		override public function set height(h : Number):void
		{
			if (h != height)
			{
				setSize(width, h);
			}
		}

		public function dispose():void
		{
			_scale9Grid = null;
			_srcBmd = null;
			graphics.clear();
		}
	}

}
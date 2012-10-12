package  bing.utils
{

	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class GraphicsScale3Bitmap extends Shape
	{

		private var _srcBmd:BitmapData;
		private var _smooth:Boolean;
		private var _firstPos:Number;
		private var _len:Number;

		public function GraphicsScale3Bitmap( srcBmd:BitmapData , firstPos:Number , len:Number , smooth:Boolean=false)
		{
			this._srcBmd = srcBmd;
			this._smooth = smooth;
			this._firstPos = firstPos;
			this._len = len;
		}

		/**
		 * setter width
		 */
		override public function set width(w : Number):void
		{
			if (w != width)
			{
				var cols:Array = [0,_firstPos,_firstPos + _len,_srcBmd.width];
				var dCols : Array = [0, _firstPos , w - (_srcBmd.width - _firstPos-_len), w];

				var origin:Rectangle = new Rectangle(0,0,0,_srcBmd.height);
				var draw:Rectangle = new Rectangle(0,0,0,_srcBmd.height);
				var mat :Matrix = new Matrix();
				graphics.clear();
				for (var i : int = 0; i < 3; i++)
				{
					origin.x = cols[i];
					origin.width = cols[i + 1] - cols[i];

					draw.x = dCols[i];
					draw.width = dCols[i + 1] - dCols[i];

					mat.identity();
					mat.a = draw.width / origin.width;
					mat.tx = draw.x - origin.x * mat.a;

					graphics.beginBitmapFill(_srcBmd,mat,false,_smooth);
					graphics.drawRect(draw.x,draw.y,draw.width,draw.height);
				}
				graphics.endFill();
			}
		}

		/**
		 * setter height
		 */
		override public function set height(h : Number):void
		{
			if (h != height)
			{
				var rows:Array = [0,_firstPos,_firstPos + _len,_srcBmd.height];
				var dRows : Array = [0, _firstPos , h - (_srcBmd.height - _firstPos-_len), h];

				var origin:Rectangle = new Rectangle(0,_srcBmd.width,0);
				var draw:Rectangle = new Rectangle(0,0,_srcBmd.width,0);
				var mat :Matrix = new Matrix();
				graphics.clear();
				for (var i : int = 0; i < 3; i++)
				{
					origin.y = rows[i];
					origin.height = rows[i + 1] - rows[i];

					draw.y = dRows[i];
					draw.height = dRows[i + 1] - dRows[i];

					mat.identity();
					mat.d = draw.height / origin.height;
					mat.ty = draw.y - origin.y * mat.d;

					graphics.beginBitmapFill(_srcBmd,mat,false,_smooth);
					graphics.drawRect(draw.x,draw.y,draw.width,draw.height);
				}
				graphics.endFill();
			}
		}
		
		public function forceWidth( w:Number ):void
		{
			if(width!=w) width = w ;
		}
		
		public function forceHeight( h:Number ):void
		{
			if(height!=h) height = h ;
		}

		public function dispose():void
		{
			_srcBmd = null;
			graphics.clear();
		}

	}

}
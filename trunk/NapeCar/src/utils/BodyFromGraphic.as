package utils {
	
	//translation of the bitmapToBody and graphicToBody methods only.
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	
	import nape.geom.AABB;
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.MarchingSquares;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	
	public class BodyFromGraphic {
		//take a BitmapData object with alpha channel
		//and produce a nape body from the alpha threshold
		//with input bitmap used to create an assigned graphic displayed
		//appropriately
		public static function bitmapToBody( bodyType:BodyType , material:Material , bitmap:BitmapData,threshold:int=0x80,granularity:Vec2=null):Body {
			var body:Body = new Body(bodyType);
			
			var bounds:AABB = new AABB(0,0,bitmap.width,bitmap.height);
			var iso:Function = function(x:Number,y:Number):Number {
				//take 4 nearest pixels to interpolate linearlly
				var ix:int = int(x); var iy:int = int(y);
				//clamp in-case of numerical inaccuracies
				if(ix<0) ix = 0; if(iy<0) iy = 0;
				if(ix>=bitmap.width)  ix = bitmap.width-1;
				if(iy>=bitmap.height) iy = bitmap.height-1;
				//
				var fx:Number = x - ix; var fy:Number = y - iy;
				
				var a11:int = threshold - (bitmap.getPixel32(ix,iy)>>>24);
				var a12:int = threshold - (bitmap.getPixel32(ix+1,iy)>>>24);
				var a21:int = threshold - (bitmap.getPixel32(ix,iy+1)>>>24);
				var a22:int = threshold - (bitmap.getPixel32(ix+1,iy+1)>>>24);
				
				return a11*(1-fx)*(1-fy) + a12*fx*(1-fy) + a21*(1-fx)*fy + a22*fx*fy;
			}
			
			//iso surface is smooth from alpha channel + interpolation
			//so less iterations are needed in extraction
			var grain:Vec2 = (granularity==null) ? new Vec2(8,8) : granularity;
			var polys:GeomPolyList = MarchingSquares.run(iso, bounds, grain, 1);
			polys.foreach(function (p:GeomPoly):void {
				var qolys:GeomPolyList = p.simplify(1).convex_decomposition();
				qolys.foreach(function (q:GeomPoly):void {
					body.shapes.add(new Polygon(q,material));
				});
			});
			
			body.graphic = new Bitmap(bitmap, PixelSnapping.AUTO, true);
			return body;
		}
	
		}
	}
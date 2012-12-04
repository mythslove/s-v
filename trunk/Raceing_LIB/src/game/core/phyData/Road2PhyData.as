package game.core.phyData{
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import nape.callbacks.CbType;
	import nape.callbacks.CbTypeList;
	import nape.dynamics.InteractionFilter;
	import nape.geom.AABB;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.FluidProperties;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	
	import starling.display.DisplayObject;
	
	public class Road2PhyData {
		
		public static function createBody(name:String,graphic:DisplayObject=null):Body {
			var xret:BodyPair = lookup(name);
			if(graphic==null) return xret.body.copy();
			
			var ret:Body = xret.body.copy();
			graphic.x = graphic.y = 0;
			graphic.rotation = 0;
			var bounds:Rectangle = graphic.getBounds(graphic);
			var offset:Vec2 = Vec2.get(bounds.x-xret.anchor.x, bounds.y-xret.anchor.y);
			
			ret.graphic = graphic;
			ret.graphicOffset = offset;
			
			return ret;
		}
		
		public static function registerMaterial(name:String,material:Material):void {
			if(materials==null) materials = new Dictionary();
			materials[name] = material;	
		}
		public static function registerFilter(name:String,filter:InteractionFilter):void {
			if(filters==null) filters = new Dictionary();
			filters[name] = filter;
		}
		public static function registerFluidProperties(name:String,properties:FluidProperties):void {
			if(fprops==null) fprops = new Dictionary();
			fprops[name] = properties;
		}
		public static function registerCbType(name:String,cbType:CbType):void {
			if(types==null) types = new Dictionary();
			types[name] = cbType;
		}
		
		//----------------------------------------------------------------------	
		
		private static var bodies   :Dictionary;
		private static var materials:Dictionary;
		private static var filters  :Dictionary;
		private static var fprops   :Dictionary;
		private static var types    :Dictionary;
		private static function material(name:String):Material {
			if(name=="default") return new Material();
			else {
				if(materials==null || materials[name] === undefined)
					throw "Error: Material with name '"+name+"' has not been registered";
				return materials[name] as Material;
			}
		}
		private static function filter(name:String):InteractionFilter {
			if(name=="default") return new InteractionFilter();
			else {
				if(filters==null || filters[name] === undefined)
					throw "Error: InteractionFilter with name '"+name+"' has not been registered";
				return filters[name] as InteractionFilter;
			}
		}
		private static function fprop(name:String):FluidProperties {
			if(name=="default") return new FluidProperties();
			else {
				if(fprops==null || fprops[name] === undefined)
					throw "Error: FluidProperties with name '"+name+"' has not been registered";
				return fprops[name] as FluidProperties;
			}
		}
		private static function cbtype(outtypes:CbTypeList, name:String):void {
			var names:Array = name.split(",");
			for(var i:int = 0; i<names.length; i++) {
				var name:String = names[i].replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
				if(name=="") continue;
				
				if(types[name] === undefined)
					throw "Error: CbType with name '"+name+"' has not been registered";
				
				outtypes.add(types[name] as CbType);
			}
		}
		
		private static function lookup(name:String):BodyPair {
			if(bodies==null) init();
			if(bodies[name] === undefined) throw "Error: Body with name '"+name+"' does not exist";
			return bodies[name] as BodyPair;
		}
		
		//----------------------------------------------------------------------	
		
		private static function init():void {
			bodies = new Dictionary();
			
			var body:Body;
			var mat:Material;
			var filt:InteractionFilter;
			var prop:FluidProperties;
			var cbType:CbType;
			var s:Shape;
			var anchor:Vec2;
			
			
			body = new Body();
			cbtype(body.cbTypes,"");
			
			
			mat = material("default");
			filt = filter("default");
			prop = fprop("default");
			
			
			
			s = new Polygon(
				[   Vec2.weak(-0.5,159)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(2044.5,511)   ,  Vec2.weak(511,158.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1299,211.5)   ,  Vec2.weak(1277,218.5)   ,  Vec2.weak(1246,232.5)   ,  Vec2.weak(1391,217.5)   ,  Vec2.weak(1325,209.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(2045,105.5)   ,  Vec2.weak(2004,105.5)   ,  Vec2.weak(1967,108.5)   ,  Vec2.weak(1925,118.5)   ,  Vec2.weak(1885,131.5)   ,  Vec2.weak(1857,142.5)   ,  Vec2.weak(1817,161.5)   ,  Vec2.weak(2044.5,511)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1817,161.5)   ,  Vec2.weak(1751,201.5)   ,  Vec2.weak(2044.5,511)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1514,191.5)   ,  Vec2.weak(1471,197.5)   ,  Vec2.weak(1410,214.5)   ,  Vec2.weak(1614,203.5)   ,  Vec2.weak(1564,193.5)   ,  Vec2.weak(1543,191.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(868,102.5)   ,  Vec2.weak(833,101.5)   ,  Vec2.weak(1131,211.5)   ,  Vec2.weak(1103,186.5)   ,  Vec2.weak(1086,174.5)   ,  Vec2.weak(963,119.5)   ,  Vec2.weak(920,110.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(998,130.5)   ,  Vec2.weak(963,119.5)   ,  Vec2.weak(1086,174.5)   ,  Vec2.weak(1033,145.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1614,203.5)   ,  Vec2.weak(1410,214.5)   ,  Vec2.weak(1391,217.5)   ,  Vec2.weak(2044.5,511)   ,  Vec2.weak(1674,212.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1751,201.5)   ,  Vec2.weak(1737,208.5)   ,  Vec2.weak(2044.5,511)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1246,232.5)   ,  Vec2.weak(1224,240.5)   ,  Vec2.weak(2044.5,511)   ,  Vec2.weak(1391,217.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1737,208.5)   ,  Vec2.weak(1722,213.5)   ,  Vec2.weak(2044.5,511)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1722,213.5)   ,  Vec2.weak(1696,214.5)   ,  Vec2.weak(2044.5,511)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(800,103.5)   ,  Vec2.weak(750,110.5)   ,  Vec2.weak(590,144.5)   ,  Vec2.weak(1166,231.5)   ,  Vec2.weak(833,101.5)   ,  Vec2.weak(832,101.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1696,214.5)   ,  Vec2.weak(1674,212.5)   ,  Vec2.weak(2044.5,511)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(511,158.5)   ,  Vec2.weak(2044.5,511)   ,  Vec2.weak(1203,243.5)   ,  Vec2.weak(590,144.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1131,211.5)   ,  Vec2.weak(833,101.5)   ,  Vec2.weak(1147,222.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1224,240.5)   ,  Vec2.weak(1211,243.5)   ,  Vec2.weak(2044.5,511)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1147,222.5)   ,  Vec2.weak(833,101.5)   ,  Vec2.weak(1166,231.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1211,243.5)   ,  Vec2.weak(1203,243.5)   ,  Vec2.weak(2044.5,511)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1203,243.5)   ,  Vec2.weak(1166,231.5)   ,  Vec2.weak(590,144.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			
			
			
			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,512);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);
			
			bodies["road1"] = new BodyPair(body,anchor);
			
			body = new Body();
			cbtype(body.cbTypes,"");
			
			
			mat = material("default");
			filt = filter("default");
			prop = fprop("default");
			
			
			
			s = new Polygon(
				[   Vec2.weak(2047.5,511)   ,  Vec2.weak(2047,144.5)   ,  Vec2.weak(2025,139.5)   ,  Vec2.weak(867,239.5)   ,  Vec2.weak(0,511.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(24.5,102)   ,  Vec2.weak(-0.5,468)   ,  Vec2.weak(268,166.5)   ,  Vec2.weak(230,146.5)   ,  Vec2.weak(184,127.5)   ,  Vec2.weak(157,118.5)   ,  Vec2.weak(117,107.5)   ,  Vec2.weak(87,102.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1783,137.5)   ,  Vec2.weak(1744,136.5)   ,  Vec2.weak(1722,142.5)   ,  Vec2.weak(1697,153.5)   ,  Vec2.weak(1828,153.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1560,148.5)   ,  Vec2.weak(1535,159.5)   ,  Vec2.weak(1677,153.5)   ,  Vec2.weak(1630,146.5)   ,  Vec2.weak(1591,144.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(764,206.5)   ,  Vec2.weak(729,206.5)   ,  Vec2.weak(694,212.5)   ,  Vec2.weak(823,228.5)   ,  Vec2.weak(792,214.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1411,122.5)   ,  Vec2.weak(1398,115.5)   ,  Vec2.weak(1368,105.5)   ,  Vec2.weak(1343,100.5)   ,  Vec2.weak(1307,96.5)   ,  Vec2.weak(1243,95.5)   ,  Vec2.weak(1423,131.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1857,143.5)   ,  Vec2.weak(1835,153.5)   ,  Vec2.weak(2025,139.5)   ,  Vec2.weak(1985,133.5)   ,  Vec2.weak(1957,131.5)   ,  Vec2.weak(1923,131.5)   ,  Vec2.weak(1882,136.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(268,166.5)   ,  Vec2.weak(-0.5,468)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(320,198.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(990,166.5)   ,  Vec2.weak(964,184.5)   ,  Vec2.weak(940,206.5)   ,  Vec2.weak(1242,95.5)   ,  Vec2.weak(1210,97.5)   ,  Vec2.weak(1178,102.5)   ,  Vec2.weak(1061,136.5)   ,  Vec2.weak(1016,153.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(598,193.5)   ,  Vec2.weak(554,187.5)   ,  Vec2.weak(526,187.5)   ,  Vec2.weak(506,189.5)   ,  Vec2.weak(444,201.5)   ,  Vec2.weak(647,207.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1097,114.5)   ,  Vec2.weak(1061,136.5)   ,  Vec2.weak(1178,102.5)   ,  Vec2.weak(1132,106.5)   ,  Vec2.weak(1110,110.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(320,198.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(337,206.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(823,228.5)   ,  Vec2.weak(694,212.5)   ,  Vec2.weak(678,213.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(845,236.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(444,201.5)   ,  Vec2.weak(404,207.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(678,213.5)   ,  Vec2.weak(647,207.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(337,206.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(353,210.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(353,210.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(373,210.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(373,210.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(404,207.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1423,131.5)   ,  Vec2.weak(1243,95.5)   ,  Vec2.weak(1446,141.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(940,206.5)   ,  Vec2.weak(922,218.5)   ,  Vec2.weak(1242,95.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1446,141.5)   ,  Vec2.weak(1243,95.5)   ,  Vec2.weak(1242,95.5)   ,  Vec2.weak(898,229.5)   ,  Vec2.weak(1478,151.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(845,236.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(858,239.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1677,153.5)   ,  Vec2.weak(1535,159.5)   ,  Vec2.weak(898,229.5)   ,  Vec2.weak(1835,153.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(922,218.5)   ,  Vec2.weak(898,229.5)   ,  Vec2.weak(1242,95.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(858,239.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(867,239.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(867,239.5)   ,  Vec2.weak(1835,153.5)   ,  Vec2.weak(898,229.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1478,151.5)   ,  Vec2.weak(898,229.5)   ,  Vec2.weak(1518,159.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1518,159.5)   ,  Vec2.weak(898,229.5)   ,  Vec2.weak(1535,159.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			
			
			
			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,512);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);
			
			bodies["road2"] = new BodyPair(body,anchor);
			
			body = new Body();
			cbtype(body.cbTypes,"");
			
			
			mat = material("default");
			filt = filter("default");
			prop = fprop("default");
			
			
			
			s = new Polygon(
				[   Vec2.weak(0,378.5)   ,  Vec2.weak(2047.5,378)   ,  Vec2.weak(-0.5,20)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1058,12.5)   ,  Vec2.weak(1040,6.5)   ,  Vec2.weak(981,6.5)   ,  Vec2.weak(935,13.5)   ,  Vec2.weak(895,21.5)   ,  Vec2.weak(1072,22.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1748,73.5)   ,  Vec2.weak(1731,77.5)   ,  Vec2.weak(2047.5,378)   ,  Vec2.weak(1993.5,163)   ,  Vec2.weak(1940,119.5)   ,  Vec2.weak(1854,92.5)   ,  Vec2.weak(1795,77.5)   ,  Vec2.weak(1768,73.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(2047,185.5)   ,  Vec2.weak(2026,183.5)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(683,8.5)   ,  Vec2.weak(640,26.5)   ,  Vec2.weak(875,23.5)   ,  Vec2.weak(833,12.5)   ,  Vec2.weak(790,4.5)   ,  Vec2.weak(771,2.5)   ,  Vec2.weak(718,2.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1966,136.5)   ,  Vec2.weak(1940,119.5)   ,  Vec2.weak(1993.5,163)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(2026,183.5)   ,  Vec2.weak(2009,175.5)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(512,37.5)   ,  Vec2.weak(487,45.5)   ,  Vec2.weak(441,67.5)   ,  Vec2.weak(621,31.5)   ,  Vec2.weak(556,31.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(221,8.5)   ,  Vec2.weak(196,2.5)   ,  Vec2.weak(172,-0.5)   ,  Vec2.weak(112,-0.5)   ,  Vec2.weak(296,52.5)   ,  Vec2.weak(251,21.5)   ,  Vec2.weak(242,16.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(2009,175.5)   ,  Vec2.weak(1993.5,163)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1342,72.5)   ,  Vec2.weak(1304,73.5)   ,  Vec2.weak(1252,79.5)   ,  Vec2.weak(2047.5,378)   ,  Vec2.weak(1405,80.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1529,54.5)   ,  Vec2.weak(1491,59.5)   ,  Vec2.weak(1425,77.5)   ,  Vec2.weak(2047.5,378)   ,  Vec2.weak(1635,67.5)   ,  Vec2.weak(1579,56.5)   ,  Vec2.weak(1558,54.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(38,9.5)   ,  Vec2.weak(-0.5,20)   ,  Vec2.weak(344,76.5)   ,  Vec2.weak(315,63.5)   ,  Vec2.weak(112,-0.5)   ,  Vec2.weak(111,-0.5)   ,  Vec2.weak(80,2.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1731,77.5)   ,  Vec2.weak(1699,76.5)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1699,76.5)   ,  Vec2.weak(1635,67.5)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1084,27.5)   ,  Vec2.weak(1072,22.5)   ,  Vec2.weak(895,21.5)   ,  Vec2.weak(1121,49.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(296,52.5)   ,  Vec2.weak(112,-0.5)   ,  Vec2.weak(315,63.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1121,49.5)   ,  Vec2.weak(895,21.5)   ,  Vec2.weak(1139,57.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1139,57.5)   ,  Vec2.weak(895,21.5)   ,  Vec2.weak(441,67.5)   ,  Vec2.weak(421,74.5)   ,  Vec2.weak(2047.5,378)   ,  Vec2.weak(1224,79.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(640,26.5)   ,  Vec2.weak(621,31.5)   ,  Vec2.weak(875,23.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(621,31.5)   ,  Vec2.weak(441,67.5)   ,  Vec2.weak(875,23.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1425,77.5)   ,  Vec2.weak(1405,80.5)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1252,79.5)   ,  Vec2.weak(1224,79.5)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(421,74.5)   ,  Vec2.weak(388,82.5)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(388,82.5)   ,  Vec2.weak(369,82.5)   ,  Vec2.weak(2047.5,378)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(344,76.5)   ,  Vec2.weak(-0.5,20)   ,  Vec2.weak(369,82.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			
			
			
			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,379);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);
			
			bodies["road3"] = new BodyPair(body,anchor);
			
			body = new Body();
			cbtype(body.cbTypes,"");
			
			
			mat = material("default");
			filt = filter("default");
			prop = fprop("default");
			
			
			
			s = new Polygon(
				[   Vec2.weak(2047.5,511)   ,  Vec2.weak(2047.5,154)   ,  Vec2.weak(2045,151.5)   ,  Vec2.weak(0,511.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(-0.5,316)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(19,304.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(19,304.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(292,235.5)   ,  Vec2.weak(287,233.5)   ,  Vec2.weak(269,231.5)   ,  Vec2.weak(194,232.5)   ,  Vec2.weak(67,261.5)   ,  Vec2.weak(53.5,272)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1080,89.5)   ,  Vec2.weak(1051,83.5)   ,  Vec2.weak(1020,82.5)   ,  Vec2.weak(1135,117.5)   ,  Vec2.weak(1105,99.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1783,148.5)   ,  Vec2.weak(1765,158.5)   ,  Vec2.weak(1718,190.5)   ,  Vec2.weak(1978,138.5)   ,  Vec2.weak(1935,133.5)   ,  Vec2.weak(1876,131.5)   ,  Vec2.weak(1835,134.5)   ,  Vec2.weak(1805,140.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(87,250.5)   ,  Vec2.weak(67,261.5)   ,  Vec2.weak(194,232.5)   ,  Vec2.weak(131,239.5)   ,  Vec2.weak(102,245.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(479,189.5)   ,  Vec2.weak(446,189.5)   ,  Vec2.weak(422,193.5)   ,  Vec2.weak(397,200.5)   ,  Vec2.weak(327,227.5)   ,  Vec2.weak(564,218.5)   ,  Vec2.weak(538,206.5)   ,  Vec2.weak(502,193.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1506,169.5)   ,  Vec2.weak(1466,164.5)   ,  Vec2.weak(1401,164.5)   ,  Vec2.weak(1589,203.5)   ,  Vec2.weak(1530,176.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1978,138.5)   ,  Vec2.weak(1718,190.5)   ,  Vec2.weak(1684,207.5)   ,  Vec2.weak(2045,151.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(930,102.5)   ,  Vec2.weak(906,116.5)   ,  Vec2.weak(867,147.5)   ,  Vec2.weak(1019,82.5)   ,  Vec2.weak(994,84.5)   ,  Vec2.weak(972,88.5)   ,  Vec2.weak(947,95.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(670,206.5)   ,  Vec2.weak(649,211.5)   ,  Vec2.weak(611,225.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(735,205.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1210,121.5)   ,  Vec2.weak(1147,122.5)   ,  Vec2.weak(1377,157.5)   ,  Vec2.weak(1360,149.5)   ,  Vec2.weak(1335,140.5)   ,  Vec2.weak(1260,126.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(867,147.5)   ,  Vec2.weak(816,180.5)   ,  Vec2.weak(1147,122.5)   ,  Vec2.weak(1020,82.5)   ,  Vec2.weak(1019,82.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(564,218.5)   ,  Vec2.weak(327,227.5)   ,  Vec2.weak(300,235.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(592,226.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(292,235.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(300,235.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1377,157.5)   ,  Vec2.weak(1147,122.5)   ,  Vec2.weak(1401,164.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1401,164.5)   ,  Vec2.weak(1147,122.5)   ,  Vec2.weak(816,180.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(1634,215.5)   ,  Vec2.weak(1589,203.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(592,226.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(611,225.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1135,117.5)   ,  Vec2.weak(1020,82.5)   ,  Vec2.weak(1147,122.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(735,205.5)   ,  Vec2.weak(0,511.5)   ,  Vec2.weak(796,188.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1684,207.5)   ,  Vec2.weak(1654,215.5)   ,  Vec2.weak(2045,151.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			s = new Polygon(
				[   Vec2.weak(1654,215.5)   ,  Vec2.weak(1634,215.5)   ,  Vec2.weak(0,511.5)   ],
				mat,
				filt
			);
			s.body = body;
			s.fluidEnabled = false;
			s.fluidProperties = prop;
			cbtype(s.cbTypes,"");
			
			
			
			
			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,512);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);
			
			bodies["road4"] = new BodyPair(body,anchor);
			
		}
	}
}

import nape.phys.Body;
import nape.geom.Vec2;

class BodyPair {
	public var body:Body;
	public var anchor:Vec2;
	public function BodyPair(body:Body,anchor:Vec2):void {
		this.body = body;
		this.anchor = anchor;
	}
}

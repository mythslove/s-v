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
							[   Vec2.weak(1969,120.5)   ,  Vec2.weak(1959,131.5)   ,  Vec2.weak(2047.5,396)   ,  Vec2.weak(2047,130.5)   ,  Vec2.weak(2034,124.5)   ,  Vec2.weak(2014,118.5)   ,  Vec2.weak(2000,116.5)   ,  Vec2.weak(1982,116.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1530,0.5)   ,  Vec2.weak(1506,-0.5)   ,  Vec2.weak(1505,-0.5)   ,  Vec2.weak(1284,88.5)   ,  Vec2.weak(1706.5,144)   ,  Vec2.weak(1691.5,129)   ,  Vec2.weak(1556,13.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1886,132.5)   ,  Vec2.weak(1875,131.5)   ,  Vec2.weak(1856,137.5)   ,  Vec2.weak(1834,149.5)   ,  Vec2.weak(1896,137.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1635,71.5)   ,  Vec2.weak(1625,69.5)   ,  Vec2.weak(1691.5,129)   ,  Vec2.weak(1666,97.5)   ,  Vec2.weak(1651,81.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1125,83.5)   ,  Vec2.weak(1111,87.5)   ,  Vec2.weak(1092.5,101)   ,  Vec2.weak(1079,120.5)   ,  Vec2.weak(1208,100.5)   ,  Vec2.weak(1143,83.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(634,138.5)   ,  Vec2.weak(586,155.5)   ,  Vec2.weak(532,184.5)   ,  Vec2.weak(698,152.5)   ,  Vec2.weak(652,139.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(775,141.5)   ,  Vec2.weak(762,145.5)   ,  Vec2.weak(741,157.5)   ,  Vec2.weak(883,189.5)   ,  Vec2.weak(828,151.5)   ,  Vec2.weak(816,145.5)   ,  Vec2.weak(802,141.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1101.5,93)   ,  Vec2.weak(1092.5,101)   ,  Vec2.weak(1111,87.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1834,149.5)   ,  Vec2.weak(1800,163.5)   ,  Vec2.weak(2047.5,396)   ,  Vec2.weak(1905,139.5)   ,  Vec2.weak(1896,137.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(993,167.5)   ,  Vec2.weak(964,192.5)   ,  Vec2.weak(1233,100.5)   ,  Vec2.weak(1208,100.5)   ,  Vec2.weak(1073,126.5)   ,  Vec2.weak(1019,151.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(375,152.5)   ,  Vec2.weak(350,152.5)   ,  Vec2.weak(308,156.5)   ,  Vec2.weak(267,163.5)   ,  Vec2.weak(215,177.5)   ,  Vec2.weak(138,201.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(396,155.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(725,154.5)   ,  Vec2.weak(698,152.5)   ,  Vec2.weak(532,184.5)   ,  Vec2.weak(503,192.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(735,157.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1428,10.5)   ,  Vec2.weak(1413,14.5)   ,  Vec2.weak(1377,32.5)   ,  Vec2.weak(1308,76.5)   ,  Vec2.weak(1466,8.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(-0.5,142)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(78,193.5)   ,  Vec2.weak(13,148.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(78,193.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(91,200.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(91,200.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(102,203.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(102,203.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(125,203.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1959,131.5)   ,  Vec2.weak(1946,136.5)   ,  Vec2.weak(2047.5,396)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1946,136.5)   ,  Vec2.weak(1924,139.5)   ,  Vec2.weak(2047.5,396)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1924,139.5)   ,  Vec2.weak(1905,139.5)   ,  Vec2.weak(2047.5,396)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(125,203.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(138,201.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1800,163.5)   ,  Vec2.weak(1775,168.5)   ,  Vec2.weak(2047.5,396)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2047.5,396)   ,  Vec2.weak(1775,168.5)   ,  Vec2.weak(1758,168.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(0,396.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1079,120.5)   ,  Vec2.weak(1073,126.5)   ,  Vec2.weak(1208,100.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1466,8.5)   ,  Vec2.weak(1308,76.5)   ,  Vec2.weak(1284,88.5)   ,  Vec2.weak(1505,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(405,158.5)   ,  Vec2.weak(396,155.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(442,178.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(442,178.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(462,187.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(883,189.5)   ,  Vec2.weak(741,157.5)   ,  Vec2.weak(735,157.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(898,197.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(462,187.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(481,192.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1625,69.5)   ,  Vec2.weak(1615,63.5)   ,  Vec2.weak(1691.5,129)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(481,192.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(503,192.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1233,100.5)   ,  Vec2.weak(964,192.5)   ,  Vec2.weak(959,195.5)   ,  Vec2.weak(1745,166.5)   ,  Vec2.weak(1726,158.5)   ,  Vec2.weak(1259,96.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(898,197.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(907,200.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(907,200.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(944,199.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1706.5,144)   ,  Vec2.weak(1284,88.5)   ,  Vec2.weak(1259,96.5)   ,  Vec2.weak(1726,158.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(959,195.5)   ,  Vec2.weak(944,199.5)   ,  Vec2.weak(1745,166.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(944,199.5)   ,  Vec2.weak(-0.5,395)   ,  Vec2.weak(1758,168.5)   ,  Vec2.weak(1745,166.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,397);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road5"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(25,279)   ,  Vec2.weak(25,0)   ,  Vec2.weak(0,0)   ,  Vec2.weak(0,279)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,279);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road1"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(1109,88.5)   ,  Vec2.weak(1096,80.5)   ,  Vec2.weak(1083,75.5)   ,  Vec2.weak(1055,69.5)   ,  Vec2.weak(1023,67.5)   ,  Vec2.weak(954,81.5)   ,  Vec2.weak(929,92.5)   ,  Vec2.weak(1117.5,122)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1192.5,403)   ,  Vec2.weak(1192,160.5)   ,  Vec2.weak(1155,151.5)   ,  Vec2.weak(788,208.5)   ,  Vec2.weak(0,403.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(313,138.5)   ,  Vec2.weak(307,132.5)   ,  Vec2.weak(275,118.5)   ,  Vec2.weak(254,114.5)   ,  Vec2.weak(234,113.5)   ,  Vec2.weak(324.5,170)   ,  Vec2.weak(318.5,149)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(730,213.5)   ,  Vec2.weak(704,224.5)   ,  Vec2.weak(775,211.5)   ,  Vec2.weak(750,211.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(6.5,14)   ,  Vec2.weak(-0.5,23)   ,  Vec2.weak(0,403.5)   ,  Vec2.weak(345,196.5)   ,  Vec2.weak(38,-0.5)   ,  Vec2.weak(37,-0.5)   ,  Vec2.weak(29,0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(53,0.5)   ,  Vec2.weak(38,-0.5)   ,  Vec2.weak(189.5,94)   ,  Vec2.weak(142,50.5)   ,  Vec2.weak(108,25.5)   ,  Vec2.weak(73,6.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(981,66.5)   ,  Vec2.weak(954,81.5)   ,  Vec2.weak(1023,67.5)   ,  Vec2.weak(1006,63.5)   ,  Vec2.weak(995,63.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(929,92.5)   ,  Vec2.weak(882.5,130)   ,  Vec2.weak(818,187.5)   ,  Vec2.weak(1128.5,137)   ,  Vec2.weak(1117.5,122)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(617,223.5)   ,  Vec2.weak(606,227.5)   ,  Vec2.weak(574,247.5)   ,  Vec2.weak(684,224.5)   ,  Vec2.weak(657,220.5)   ,  Vec2.weak(641,220.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(324.5,170)   ,  Vec2.weak(234,113.5)   ,  Vec2.weak(213,108.5)   ,  Vec2.weak(329.5,181)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(385,205.5)   ,  Vec2.weak(345,196.5)   ,  Vec2.weak(0,403.5)   ,  Vec2.weak(482,245.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(818,187.5)   ,  Vec2.weak(788,208.5)   ,  Vec2.weak(1138,143.5)   ,  Vec2.weak(1128.5,137)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(574,247.5)   ,  Vec2.weak(555,256.5)   ,  Vec2.weak(704,224.5)   ,  Vec2.weak(684,224.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(329.5,181)   ,  Vec2.weak(189.5,94)   ,  Vec2.weak(345,196.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1138,143.5)   ,  Vec2.weak(788,208.5)   ,  Vec2.weak(1155,151.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(555,256.5)   ,  Vec2.weak(0,403.5)   ,  Vec2.weak(775,211.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(482,245.5)   ,  Vec2.weak(0,403.5)   ,  Vec2.weak(506,253.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(506,253.5)   ,  Vec2.weak(0,403.5)   ,  Vec2.weak(535,259.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(535,259.5)   ,  Vec2.weak(0,403.5)   ,  Vec2.weak(555,256.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,404);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road3"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(720,149.5)   ,  Vec2.weak(706,146.5)   ,  Vec2.weak(688,148.5)   ,  Vec2.weak(749.5,178)   ,  Vec2.weak(731,156.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1073,150.5)   ,  Vec2.weak(1055,143.5)   ,  Vec2.weak(1027,142.5)   ,  Vec2.weak(1007,146.5)   ,  Vec2.weak(990,153.5)   ,  Vec2.weak(972.5,166)   ,  Vec2.weak(1099.5,179)   ,  Vec2.weak(1086,161.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1851,95.5)   ,  Vec2.weak(1832,91.5)   ,  Vec2.weak(1816,91.5)   ,  Vec2.weak(1805,93.5)   ,  Vec2.weak(1780,105.5)   ,  Vec2.weak(1874,109.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(-0.5,131)   ,  Vec2.weak(0,409.5)   ,  Vec2.weak(2047.5,409)   ,  Vec2.weak(38,129.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(596,20.5)   ,  Vec2.weak(569,9.5)   ,  Vec2.weak(542,3.5)   ,  Vec2.weak(504,-0.5)   ,  Vec2.weak(666.5,132)   ,  Vec2.weak(653.5,91)   ,  Vec2.weak(640.5,67)   ,  Vec2.weak(615,35.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1194,143.5)   ,  Vec2.weak(1172,152.5)   ,  Vec2.weak(1129,179.5)   ,  Vec2.weak(1236,147.5)   ,  Vec2.weak(1208,142.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1606,27.5)   ,  Vec2.weak(1571,19.5)   ,  Vec2.weak(1539,18.5)   ,  Vec2.weak(1516,20.5)   ,  Vec2.weak(1482,26.5)   ,  Vec2.weak(1357,109.5)   ,  Vec2.weak(1692,82.5)   ,  Vec2.weak(1635,41.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(127,98.5)   ,  Vec2.weak(94,117.5)   ,  Vec2.weak(286,99.5)   ,  Vec2.weak(263,89.5)   ,  Vec2.weak(241,85.5)   ,  Vec2.weak(186,85.5)   ,  Vec2.weak(154,90.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(972.5,166)   ,  Vec2.weak(962,178.5)   ,  Vec2.weak(1099.5,179)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1421,48.5)   ,  Vec2.weak(1393.5,68)   ,  Vec2.weak(1374.5,87)   ,  Vec2.weak(1357,109.5)   ,  Vec2.weak(1482,26.5)   ,  Vec2.weak(1459,32.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(273,92.5)   ,  Vec2.weak(263,89.5)   ,  Vec2.weak(286,99.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2041.5,36)   ,  Vec2.weak(2033.5,51)   ,  Vec2.weak(2047.5,409)   ,  Vec2.weak(2047.5,29)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(504,-0.5)   ,  Vec2.weak(477,-0.5)   ,  Vec2.weak(312,90.5)   ,  Vec2.weak(302,96.5)   ,  Vec2.weak(672.5,141)   ,  Vec2.weak(666.5,132)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1236,147.5)   ,  Vec2.weak(1129,179.5)   ,  Vec2.weak(1118,183.5)   ,  Vec2.weak(2047.5,409)   ,  Vec2.weak(1270,147.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(436,5.5)   ,  Vec2.weak(410,16.5)   ,  Vec2.weak(390.5,28)   ,  Vec2.weak(368,44.5)   ,  Vec2.weak(312,90.5)   ,  Vec2.weak(477,-0.5)   ,  Vec2.weak(453,1.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(962,178.5)   ,  Vec2.weak(945,184.5)   ,  Vec2.weak(1108,183.5)   ,  Vec2.weak(1099.5,179)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2033.5,51)   ,  Vec2.weak(2016.5,76)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1692,82.5)   ,  Vec2.weak(1357,109.5)   ,  Vec2.weak(1347,119.5)   ,  Vec2.weak(2047.5,409)   ,  Vec2.weak(1716,93.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2016.5,76)   ,  Vec2.weak(2006,87.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2006,87.5)   ,  Vec2.weak(1996,95.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1996,95.5)   ,  Vec2.weak(1985,100.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1985,100.5)   ,  Vec2.weak(1962,105.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1962,105.5)   ,  Vec2.weak(1916,109.5)   ,  Vec2.weak(1894,113.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1874,109.5)   ,  Vec2.weak(1780,105.5)   ,  Vec2.weak(1767,105.5)   ,  Vec2.weak(2047.5,409)   ,  Vec2.weak(1884,113.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(945,184.5)   ,  Vec2.weak(897,190.5)   ,  Vec2.weak(2047.5,409)   ,  Vec2.weak(1118,183.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1894,113.5)   ,  Vec2.weak(1884,113.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1767,105.5)   ,  Vec2.weak(1736,99.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1736,99.5)   ,  Vec2.weak(1716,93.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(688,148.5)   ,  Vec2.weak(678,145.5)   ,  Vec2.weak(293,99.5)   ,  Vec2.weak(749.5,178)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(94,117.5)   ,  Vec2.weak(76,123.5)   ,  Vec2.weak(286,99.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1347,119.5)   ,  Vec2.weak(1335,128.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1335,128.5)   ,  Vec2.weak(1321,135.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1321,135.5)   ,  Vec2.weak(1296,143.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1296,143.5)   ,  Vec2.weak(1270,147.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(76,123.5)   ,  Vec2.weak(38,129.5)   ,  Vec2.weak(2047.5,409)   ,  Vec2.weak(286,99.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(302,96.5)   ,  Vec2.weak(293,99.5)   ,  Vec2.weak(678,145.5)   ,  Vec2.weak(672.5,141)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(749.5,178)   ,  Vec2.weak(293,99.5)   ,  Vec2.weak(286,99.5)   ,  Vec2.weak(759,182.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(897,190.5)   ,  Vec2.weak(830,190.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(830,190.5)   ,  Vec2.weak(790,187.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(790,187.5)   ,  Vec2.weak(759,182.5)   ,  Vec2.weak(2047.5,409)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,410);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road2"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(702,69.5)   ,  Vec2.weak(692,65.5)   ,  Vec2.weak(683,63.5)   ,  Vec2.weak(665,63.5)   ,  Vec2.weak(629,79.5)   ,  Vec2.weak(547,133.5)   ,  Vec2.weak(706.5,74)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(151,73.5)   ,  Vec2.weak(141,76.5)   ,  Vec2.weak(121,94.5)   ,  Vec2.weak(218,89.5)   ,  Vec2.weak(205,82.5)   ,  Vec2.weak(189,77.5)   ,  Vec2.weak(161,73.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1622,6.5)   ,  Vec2.weak(1603,6.5)   ,  Vec2.weak(1590,9.5)   ,  Vec2.weak(1704.5,68)   ,  Vec2.weak(1667,29.5)   ,  Vec2.weak(1650,17.5)   ,  Vec2.weak(1638,11.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(340,70.5)   ,  Vec2.weak(316,70.5)   ,  Vec2.weak(307,73.5)   ,  Vec2.weak(286,84.5)   ,  Vec2.weak(269,97.5)   ,  Vec2.weak(417.5,124)   ,  Vec2.weak(378,83.5)   ,  Vec2.weak(362,75.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(835,64.5)   ,  Vec2.weak(818,60.5)   ,  Vec2.weak(789,63.5)   ,  Vec2.weak(738,82.5)   ,  Vec2.weak(945.5,161)   ,  Vec2.weak(922,134.5)   ,  Vec2.weak(878,92.5)   ,  Vec2.weak(847,70.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1508,4.5)   ,  Vec2.weak(1490,14.5)   ,  Vec2.weak(1455.5,38)   ,  Vec2.weak(1397,81.5)   ,  Vec2.weak(1755,104.5)   ,  Vec2.weak(1734,91.5)   ,  Vec2.weak(1525,-0.5)   ,  Vec2.weak(1524,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(591,90.5)   ,  Vec2.weak(576.5,100)   ,  Vec2.weak(547,133.5)   ,  Vec2.weak(629,79.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1280,91.5)   ,  Vec2.weak(1256,100.5)   ,  Vec2.weak(1230,114.5)   ,  Vec2.weak(1217.5,124)   ,  Vec2.weak(1192,151.5)   ,  Vec2.weak(1372,84.5)   ,  Vec2.weak(1312,86.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(805,60.5)   ,  Vec2.weak(789,63.5)   ,  Vec2.weak(818,60.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1906,74.5)   ,  Vec2.weak(1885,83.5)   ,  Vec2.weak(1845,108.5)   ,  Vec2.weak(2047.5,338)   ,  Vec2.weak(2021,75.5)   ,  Vec2.weak(1994,71.5)   ,  Vec2.weak(1920,71.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2046,82.5)   ,  Vec2.weak(2021,75.5)   ,  Vec2.weak(2047.5,338)   ,  Vec2.weak(2047.5,85)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(218,89.5)   ,  Vec2.weak(121,94.5)   ,  Vec2.weak(235,95.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1845,108.5)   ,  Vec2.weak(1828,116.5)   ,  Vec2.weak(2047.5,338)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(706.5,74)   ,  Vec2.weak(547,133.5)   ,  Vec2.weak(718,80.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1536,-0.5)   ,  Vec2.weak(1525,-0.5)   ,  Vec2.weak(1734,91.5)   ,  Vec2.weak(1704.5,68)   ,  Vec2.weak(1575,9.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1828,116.5)   ,  Vec2.weak(1809,120.5)   ,  Vec2.weak(2047.5,338)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2047.5,338)   ,  Vec2.weak(1809,120.5)   ,  Vec2.weak(1797,119.5)   ,  Vec2.weak(1028,187.5)   ,  Vec2.weak(-0.5,337)   ,  Vec2.weak(0,338.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1590,9.5)   ,  Vec2.weak(1575,9.5)   ,  Vec2.weak(1704.5,68)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(417.5,124)   ,  Vec2.weak(269,97.5)   ,  Vec2.weak(263,99.5)   ,  Vec2.weak(436,134.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(51,94.5)   ,  Vec2.weak(1,95.5)   ,  Vec2.weak(-0.5,96)   ,  Vec2.weak(-0.5,337)   ,  Vec2.weak(479,140.5)   ,  Vec2.weak(105,97.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(945.5,161)   ,  Vec2.weak(738,82.5)   ,  Vec2.weak(725,82.5)   ,  Vec2.weak(547,133.5)   ,  Vec2.weak(534,139.5)   ,  Vec2.weak(967,177.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1372,84.5)   ,  Vec2.weak(1192,151.5)   ,  Vec2.weak(1171,162.5)   ,  Vec2.weak(1766,109.5)   ,  Vec2.weak(1755,104.5)   ,  Vec2.weak(1397,81.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(235,95.5)   ,  Vec2.weak(121,94.5)   ,  Vec2.weak(117,96.5)   ,  Vec2.weak(248,98.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(718,80.5)   ,  Vec2.weak(547,133.5)   ,  Vec2.weak(725,82.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(534,139.5)   ,  Vec2.weak(512,142.5)   ,  Vec2.weak(977,182.5)   ,  Vec2.weak(967,177.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(263,99.5)   ,  Vec2.weak(248,98.5)   ,  Vec2.weak(117,96.5)   ,  Vec2.weak(105,97.5)   ,  Vec2.weak(436,134.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(977,182.5)   ,  Vec2.weak(479,140.5)   ,  Vec2.weak(-0.5,337)   ,  Vec2.weak(996,187.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(996,187.5)   ,  Vec2.weak(-0.5,337)   ,  Vec2.weak(1028,187.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1766,109.5)   ,  Vec2.weak(1171,162.5)   ,  Vec2.weak(1145,170.5)   ,  Vec2.weak(1797,119.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1145,170.5)   ,  Vec2.weak(1113,177.5)   ,  Vec2.weak(1797,119.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1113,177.5)   ,  Vec2.weak(1073,183.5)   ,  Vec2.weak(1797,119.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,339);
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

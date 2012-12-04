package  game.core.phyData{

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
							[   Vec2.weak(57,111.5)   ,  Vec2.weak(47,118.5)   ,  Vec2.weak(-0.5,259)   ,  Vec2.weak(67,111.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(387.5,42)   ,  Vec2.weak(383,47.5)   ,  Vec2.weak(457,47.5)   ,  Vec2.weak(433,39.5)   ,  Vec2.weak(395,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1271,39.5)   ,  Vec2.weak(1259,47.5)   ,  Vec2.weak(1283,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1172,64.5)   ,  Vec2.weak(1165,70.5)   ,  Vec2.weak(1186,63.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1127,79.5)   ,  Vec2.weak(1115,87.5)   ,  Vec2.weak(1143,78.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(578,79.5)   ,  Vec2.weak(573,74.5)   ,  Vec2.weak(566,71.5)   ,  Vec2.weak(552,71.5)   ,  Vec2.weak(580.5,87)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(503,56.5)   ,  Vec2.weak(489,54.5)   ,  Vec2.weak(383,47.5)   ,  Vec2.weak(304,55.5)   ,  Vec2.weak(513,63.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(477,47.5)   ,  Vec2.weak(383,47.5)   ,  Vec2.weak(489,54.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(92,96.5)   ,  Vec2.weak(85,103.5)   ,  Vec2.weak(-0.5,259)   ,  Vec2.weak(119,94.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1485,16.5)   ,  Vec2.weak(1475,23.5)   ,  Vec2.weak(2017,7.5)   ,  Vec2.weak(1559,7.5)   ,  Vec2.weak(1498,13.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(847,85.5)   ,  Vec2.weak(835,83.5)   ,  Vec2.weak(813,83.5)   ,  Vec2.weak(794,87.5)   ,  Vec2.weak(852,89.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(79,103.5)   ,  Vec2.weak(67,111.5)   ,  Vec2.weak(-0.5,259)   ,  Vec2.weak(85,103.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(145,82.5)   ,  Vec2.weak(141,86.5)   ,  Vec2.weak(203,79.5)   ,  Vec2.weak(152,79.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1085,91.5)   ,  Vec2.weak(1081,95.5)   ,  Vec2.weak(1115,87.5)   ,  Vec2.weak(1094,87.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(269,56.5)   ,  Vec2.weak(246,64.5)   ,  Vec2.weak(239,68.5)   ,  Vec2.weak(-0.5,259)   ,  Vec2.weak(0,260.5)   ,  Vec2.weak(582,87.5)   ,  Vec2.weak(580.5,87)   ,  Vec2.weak(304,55.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(32,121.5)   ,  Vec2.weak(23,126.5)   ,  Vec2.weak(-0.5,259)   ,  Vec2.weak(47,118.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1196,57.5)   ,  Vec2.weak(1186,63.5)   ,  Vec2.weak(1475,23.5)   ,  Vec2.weak(1371,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2047.5,260)   ,  Vec2.weak(2047,7.5)   ,  Vec2.weak(2017,7.5)   ,  Vec2.weak(1081,95.5)   ,  Vec2.weak(0,260.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(128,89.5)   ,  Vec2.weak(119,94.5)   ,  Vec2.weak(-0.5,259)   ,  Vec2.weak(203,79.5)   ,  Vec2.weak(141,86.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1152,73.5)   ,  Vec2.weak(1143,78.5)   ,  Vec2.weak(1165,70.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(531,64.5)   ,  Vec2.weak(304,55.5)   ,  Vec2.weak(580.5,87)   ,  Vec2.weak(552,71.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1227,48.5)   ,  Vec2.weak(1218,53.5)   ,  Vec2.weak(1259,47.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(219,72.5)   ,  Vec2.weak(203,79.5)   ,  Vec2.weak(-0.5,259)   ,  Vec2.weak(239,68.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1295,31.5)   ,  Vec2.weak(1283,39.5)   ,  Vec2.weak(1371,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(7,127.5)   ,  Vec2.weak(-0.5,130)   ,  Vec2.weak(-0.5,259)   ,  Vec2.weak(23,126.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1507,8.5)   ,  Vec2.weak(1498,13.5)   ,  Vec2.weak(1559,7.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1383,23.5)   ,  Vec2.weak(1371,31.5)   ,  Vec2.weak(1475,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(852,89.5)   ,  Vec2.weak(702,85.5)   ,  Vec2.weak(700,87.5)   ,  Vec2.weak(872,95.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1570,-0.5)   ,  Vec2.weak(1563,6.5)   ,  Vec2.weak(2017,7.5)   ,  Vec2.weak(2005,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(354,47.5)   ,  Vec2.weak(304,55.5)   ,  Vec2.weak(383,47.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1283,39.5)   ,  Vec2.weak(1259,47.5)   ,  Vec2.weak(1371,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1143,78.5)   ,  Vec2.weak(1475,23.5)   ,  Vec2.weak(1186,63.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(700,87.5)   ,  Vec2.weak(582,87.5)   ,  Vec2.weak(0,260.5)   ,  Vec2.weak(872,95.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1143,78.5)   ,  Vec2.weak(1115,87.5)   ,  Vec2.weak(1475,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1115,87.5)   ,  Vec2.weak(1081,95.5)   ,  Vec2.weak(2017,7.5)   ,  Vec2.weak(1475,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1563,6.5)   ,  Vec2.weak(1559,7.5)   ,  Vec2.weak(2017,7.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1081,95.5)   ,  Vec2.weak(872,95.5)   ,  Vec2.weak(0,260.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,261);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road4"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(2047,31.5)   ,  Vec2.weak(1993,31.5)   ,  Vec2.weak(2047.5,188)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1316,48.5)   ,  Vec2.weak(1307,55.5)   ,  Vec2.weak(1339,47.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1459,17.5)   ,  Vec2.weak(1451,23.5)   ,  Vec2.weak(1669,4.5)   ,  Vec2.weak(1547,7.5)   ,  Vec2.weak(1469,14.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1351,39.5)   ,  Vec2.weak(1339,47.5)   ,  Vec2.weak(1386,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1956,17.5)   ,  Vec2.weak(1949,15.5)   ,  Vec2.weak(1758,15.5)   ,  Vec2.weak(1394,37.5)   ,  Vec2.weak(1386,39.5)   ,  Vec2.weak(1962,21.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1424,25.5)   ,  Vec2.weak(1418,29.5)   ,  Vec2.weak(1451,23.5)   ,  Vec2.weak(1431,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1752,8.5)   ,  Vec2.weak(1749,7.5)   ,  Vec2.weak(1680,7.5)   ,  Vec2.weak(1394,37.5)   ,  Vec2.weak(1758,15.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1199,63.5)   ,  Vec2.weak(1181,70.5)   ,  Vec2.weak(1235,63.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1403,32.5)   ,  Vec2.weak(1394,37.5)   ,  Vec2.weak(1680,7.5)   ,  Vec2.weak(1669,4.5)   ,  Vec2.weak(1451,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1255,55.5)   ,  Vec2.weak(1235,63.5)   ,  Vec2.weak(1307,55.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1556,0.5)   ,  Vec2.weak(1547,7.5)   ,  Vec2.weak(1669,4.5)   ,  Vec2.weak(1659,-0.5)   ,  Vec2.weak(1560,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1126,71.5)   ,  Vec2.weak(1100,79.5)   ,  Vec2.weak(1174,71.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1977,24.5)   ,  Vec2.weak(1962,21.5)   ,  Vec2.weak(-0.5,187)   ,  Vec2.weak(0,188.5)   ,  Vec2.weak(2047.5,188)   ,  Vec2.weak(1993,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1479,7.5)   ,  Vec2.weak(1469,14.5)   ,  Vec2.weak(1547,7.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1339,47.5)   ,  Vec2.weak(1307,55.5)   ,  Vec2.weak(1962,21.5)   ,  Vec2.weak(1386,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(-0.5,81)   ,  Vec2.weak(-0.5,187)   ,  Vec2.weak(1100,79.5)   ,  Vec2.weak(1,80.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1174,71.5)   ,  Vec2.weak(1962,21.5)   ,  Vec2.weak(1307,55.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1100,79.5)   ,  Vec2.weak(1962,21.5)   ,  Vec2.weak(1174,71.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,189);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road1"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(2047,7.5)   ,  Vec2.weak(1996,7.5)   ,  Vec2.weak(1974,15.5)   ,  Vec2.weak(2047.5,156)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(992.5,40)   ,  Vec2.weak(989,46.5)   ,  Vec2.weak(1011,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1023,31.5)   ,  Vec2.weak(1011,39.5)   ,  Vec2.weak(1043,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1707,2.5)   ,  Vec2.weak(1700,-0.5)   ,  Vec2.weak(971,55.5)   ,  Vec2.weak(931,63.5)   ,  Vec2.weak(1709.5,6)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(8,0.5)   ,  Vec2.weak(2,-0.5)   ,  Vec2.weak(1,-0.5)   ,  Vec2.weak(-0.5,0)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(17,7.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(45,7.5)   ,  Vec2.weak(17,7.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(65,15.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1741,7.5)   ,  Vec2.weak(1713,7.5)   ,  Vec2.weak(931,63.5)   ,  Vec2.weak(1761,15.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(93,16.5)   ,  Vec2.weak(65,15.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(106,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1974,15.5)   ,  Vec2.weak(1761,15.5)   ,  Vec2.weak(798,71.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(2047.5,156)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1059,24.5)   ,  Vec2.weak(1043,31.5)   ,  Vec2.weak(1079,22.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(937,58.5)   ,  Vec2.weak(931,63.5)   ,  Vec2.weak(971,55.5)   ,  Vec2.weak(944,55.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(221,32.5)   ,  Vec2.weak(193,31.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(232,38.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(977,50.5)   ,  Vec2.weak(971,55.5)   ,  Vec2.weak(1700,-0.5)   ,  Vec2.weak(1179,7.5)   ,  Vec2.weak(1079,22.5)   ,  Vec2.weak(1011,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(289,47.5)   ,  Vec2.weak(257,47.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(314,55.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1088,17.5)   ,  Vec2.weak(1079,22.5)   ,  Vec2.weak(1179,7.5)   ,  Vec2.weak(1103,14.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(357,55.5)   ,  Vec2.weak(314,55.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(378,63.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1122,7.5)   ,  Vec2.weak(1103,14.5)   ,  Vec2.weak(1179,7.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(173,23.5)   ,  Vec2.weak(106,23.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(193,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(232,38.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(257,47.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(816,63.5)   ,  Vec2.weak(803,70.5)   ,  Vec2.weak(931,63.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(490,63.5)   ,  Vec2.weak(378,63.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(526,71.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(526,71.5)   ,  Vec2.weak(0,156.5)   ,  Vec2.weak(798,71.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1192,-0.5)   ,  Vec2.weak(1179,7.5)   ,  Vec2.weak(1700,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(803,70.5)   ,  Vec2.weak(798,71.5)   ,  Vec2.weak(931,63.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1709.5,6)   ,  Vec2.weak(931,63.5)   ,  Vec2.weak(1713,7.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,157);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road2"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(554,31.5)   ,  Vec2.weak(547,39.5)   ,  Vec2.weak(673,39.5)   ,  Vec2.weak(567,30.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1683,10.5)   ,  Vec2.weak(1677,7.5)   ,  Vec2.weak(1617,7.5)   ,  Vec2.weak(1611,12.5)   ,  Vec2.weak(1686.5,17)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(972,32.5)   ,  Vec2.weak(962,39.5)   ,  Vec2.weak(987,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1250,15.5)   ,  Vec2.weak(1224,15.5)   ,  Vec2.weak(1257,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(519,39.5)   ,  Vec2.weak(507,47.5)   ,  Vec2.weak(673,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2029,24.5)   ,  Vec2.weak(2019,31.5)   ,  Vec2.weak(2047.5,148)   ,  Vec2.weak(2039,22.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(205,31.5)   ,  Vec2.weak(174,31.5)   ,  Vec2.weak(0,148.5)   ,  Vec2.weak(217,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1263,24.5)   ,  Vec2.weak(1257,23.5)   ,  Vec2.weak(1271,30.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(21,-0.5)   ,  Vec2.weak(1,-0.5)   ,  Vec2.weak(-0.5,0)   ,  Vec2.weak(0,148.5)   ,  Vec2.weak(41,7.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1717,24.5)   ,  Vec2.weak(1696,23.5)   ,  Vec2.weak(1727,30.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1523,24.5)   ,  Vec2.weak(1510,30.5)   ,  Vec2.weak(1539,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(169,24.5)   ,  Vec2.weak(156,17.5)   ,  Vec2.weak(145,15.5)   ,  Vec2.weak(41,7.5)   ,  Vec2.weak(0,148.5)   ,  Vec2.weak(174,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1991,31.5)   ,  Vec2.weak(1971,39.5)   ,  Vec2.weak(2047.5,148)   ,  Vec2.weak(2019,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1018.5,15)   ,  Vec2.weak(1013,22.5)   ,  Vec2.weak(1216,11.5)   ,  Vec2.weak(1095,7.5)   ,  Vec2.weak(1029,8.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1500,32.5)   ,  Vec2.weak(1489,39.5)   ,  Vec2.weak(1510,30.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(238,39.5)   ,  Vec2.weak(217,39.5)   ,  Vec2.weak(0,148.5)   ,  Vec2.weak(255,45.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1318,39.5)   ,  Vec2.weak(994,29.5)   ,  Vec2.weak(962,39.5)   ,  Vec2.weak(1344,47.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1000,25.5)   ,  Vec2.weak(994,29.5)   ,  Vec2.weak(1224,15.5)   ,  Vec2.weak(1216,11.5)   ,  Vec2.weak(1013,22.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1740,33.5)   ,  Vec2.weak(1696,23.5)   ,  Vec2.weak(1433,45.5)   ,  Vec2.weak(1421,47.5)   ,  Vec2.weak(1746,37.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1551,15.5)   ,  Vec2.weak(1539,23.5)   ,  Vec2.weak(1603,15.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1279,32.5)   ,  Vec2.weak(1271,30.5)   ,  Vec2.weak(1289,38.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(660,30.5)   ,  Vec2.weak(638,23.5)   ,  Vec2.weak(583,23.5)   ,  Vec2.weak(567,30.5)   ,  Vec2.weak(673,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1451,39.5)   ,  Vec2.weak(1433,45.5)   ,  Vec2.weak(1489,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1204,1.5)   ,  Vec2.weak(1198,-0.5)   ,  Vec2.weak(1120,-0.5)   ,  Vec2.weak(1095,7.5)   ,  Vec2.weak(1216,11.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(133,7.5)   ,  Vec2.weak(41,7.5)   ,  Vec2.weak(145,15.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1510,30.5)   ,  Vec2.weak(1489,39.5)   ,  Vec2.weak(1696,23.5)   ,  Vec2.weak(1691.5,22)   ,  Vec2.weak(1603,15.5)   ,  Vec2.weak(1539,23.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1257,23.5)   ,  Vec2.weak(1224,15.5)   ,  Vec2.weak(1271,30.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(2047,18.5)   ,  Vec2.weak(2039,22.5)   ,  Vec2.weak(2047.5,148)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1971,39.5)   ,  Vec2.weak(1421,47.5)   ,  Vec2.weak(0,148.5)   ,  Vec2.weak(2047.5,148)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1686.5,17)   ,  Vec2.weak(1611,12.5)   ,  Vec2.weak(1603,15.5)   ,  Vec2.weak(1691.5,22)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1271,30.5)   ,  Vec2.weak(1224,15.5)   ,  Vec2.weak(994,29.5)   ,  Vec2.weak(1289,38.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(255,45.5)   ,  Vec2.weak(0,148.5)   ,  Vec2.weak(266,47.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(266,47.5)   ,  Vec2.weak(0,148.5)   ,  Vec2.weak(507,47.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(507,47.5)   ,  Vec2.weak(0,148.5)   ,  Vec2.weak(1344,47.5)   ,  Vec2.weak(673,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1746,37.5)   ,  Vec2.weak(1421,47.5)   ,  Vec2.weak(1753,39.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1421,47.5)   ,  Vec2.weak(1344,47.5)   ,  Vec2.weak(0,148.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,149);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road3"] = new BodyPair(body,anchor);
		
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

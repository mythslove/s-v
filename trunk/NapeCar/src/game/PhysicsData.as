package  game{

import flash.geom.Rectangle;
import flash.utils.Dictionary;

import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.FluidProperties;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Shape;

import starling.display.DisplayObject;

public class PhysicsData {

	public static function createBody(name:String,graphic:DisplayObject=null):Body {
		var xret:BodyPair = lookup(name);
		if(graphic==null) return xret.body.copy();

		var ret:Body = xret.body.copy();
		graphic.x = graphic.y = 0;
		graphic.rotation = 0;
		var bounds:Rectangle = graphic.getBounds(graphic);
		var offset:Vec2 = Vec2.get(bounds.x-xret.anchor.x, bounds.y-xret.anchor.y);

		ret.graphic = graphic;
		ret.graphicUpdate = function(b:Body):void {
			var gp:Vec2 = b.localToWorld(offset);
			graphic.x = gp.x;
			graphic.y = gp.y;
			graphic.rotation = (b.rotation*180/Math.PI)%360;
		}	

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
	private static function cbtype(name:String):CbType {
		if(name=="null") return null;
		else {
			if(types==null || types[name] === undefined)
				throw "Error: CbType with name '"+name+"' has not been registered";
			return types[name] as CbType;
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
			body.cbType = cbtype("null");

			
				mat = material("tie");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(160,40)   ,  Vec2.weak(154.5,37)   ,  Vec2.weak(158,50)   ,  Vec2.weak(160,46)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(-0.5,54)   ,  Vec2.weak(0,61.5)   ,  Vec2.weak(13,52.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(145,22.5)   ,  Vec2.weak(128,17.5)   ,  Vec2.weak(120,20.5)   ,  Vec2.weak(145.5,28)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(154.5,37)   ,  Vec2.weak(145.5,28)   ,  Vec2.weak(120,20.5)   ,  Vec2.weak(113,20)   ,  Vec2.weak(13,52.5)   ,  Vec2.weak(0,61.5)   ,  Vec2.weak(119,64)   ,  Vec2.weak(158,50)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(158,60)   ,  Vec2.weak(158,50)   ,  Vec2.weak(119,64)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(106,5.5)   ,  Vec2.weak(96,0.5)   ,  Vec2.weak(66,-0.5)   ,  Vec2.weak(35.5,14)   ,  Vec2.weak(20.5,32)   ,  Vec2.weak(13,52.5)   ,  Vec2.weak(113,20)   ,  Vec2.weak(111.5,13)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(49,4.5)   ,  Vec2.weak(35.5,14)   ,  Vec2.weak(66,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,0);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["CarBody"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("road");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(0,392.5)   ,  Vec2.weak(1023.5,392)   ,  Vec2.weak(804,236.5)   ,  Vec2.weak(792,232.5)   ,  Vec2.weak(39,131.5)   ,  Vec2.weak(-0.5,132)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(985,131.5)   ,  Vec2.weak(977,135.5)   ,  Vec2.weak(961.5,149)   ,  Vec2.weak(916,194.5)   ,  Vec2.weak(1023.5,392)   ,  Vec2.weak(1023,130.5)   ,  Vec2.weak(992,130.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(916,194.5)   ,  Vec2.weak(892,212.5)   ,  Vec2.weak(1023.5,392)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(892,212.5)   ,  Vec2.weak(872,223.5)   ,  Vec2.weak(1023.5,392)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(872,223.5)   ,  Vec2.weak(839,234.5)   ,  Vec2.weak(1023.5,392)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(839,234.5)   ,  Vec2.weak(813,237.5)   ,  Vec2.weak(1023.5,392)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(678,156.5)   ,  Vec2.weak(656,152.5)   ,  Vec2.weak(608,152.5)   ,  Vec2.weak(779.5,225)   ,  Vec2.weak(737,186.5)   ,  Vec2.weak(717,172.5)   ,  Vec2.weak(704,165.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(423,20.5)   ,  Vec2.weak(404,10.5)   ,  Vec2.weak(371,0.5)   ,  Vec2.weak(324,-0.5)   ,  Vec2.weak(521.5,113)   ,  Vec2.weak(446,37.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(388,4.5)   ,  Vec2.weak(371,0.5)   ,  Vec2.weak(404,10.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(289,6.5)   ,  Vec2.weak(264,14.5)   ,  Vec2.weak(202,40.5)   ,  Vec2.weak(110,88.5)   ,  Vec2.weak(39,131.5)   ,  Vec2.weak(552,135.5)   ,  Vec2.weak(324,-0.5)   ,  Vec2.weak(323,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(608,152.5)   ,  Vec2.weak(592,150.5)   ,  Vec2.weak(792,232.5)   ,  Vec2.weak(779.5,225)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(813,237.5)   ,  Vec2.weak(804,236.5)   ,  Vec2.weak(1023.5,392)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(521.5,113)   ,  Vec2.weak(324,-0.5)   ,  Vec2.weak(552,135.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(592,150.5)   ,  Vec2.weak(576,146.5)   ,  Vec2.weak(39,131.5)   ,  Vec2.weak(792,232.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(576,146.5)   ,  Vec2.weak(552,135.5)   ,  Vec2.weak(39,131.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,0);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road1"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("road");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(1023.5,393)   ,  Vec2.weak(1023,132.5)   ,  Vec2.weak(219,191.5)   ,  Vec2.weak(205,197.5)   ,  Vec2.weak(0,393.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(-0.5,132)   ,  Vec2.weak(0,393.5)   ,  Vec2.weak(101,169.5)   ,  Vec2.weak(57,140.5)   ,  Vec2.weak(39,132.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(629,3.5)   ,  Vec2.weak(589,14.5)   ,  Vec2.weak(555,29.5)   ,  Vec2.weak(503,57.5)   ,  Vec2.weak(673,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(309,100.5)   ,  Vec2.weak(293,112.5)   ,  Vec2.weak(270.5,135)   ,  Vec2.weak(242,170.5)   ,  Vec2.weak(418,80.5)   ,  Vec2.weak(366,80.5)   ,  Vec2.weak(345,84.5)   ,  Vec2.weak(328,90.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(708,1.5)   ,  Vec2.weak(674,-0.5)   ,  Vec2.weak(984,132.5)   ,  Vec2.weak(934,101.5)   ,  Vec2.weak(865,63.5)   ,  Vec2.weak(799,31.5)   ,  Vec2.weak(759,15.5)   ,  Vec2.weak(734,7.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(101,169.5)   ,  Vec2.weak(0,393.5)   ,  Vec2.weak(134,186.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(134,186.5)   ,  Vec2.weak(0,393.5)   ,  Vec2.weak(155,193.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(155,193.5)   ,  Vec2.weak(0,393.5)   ,  Vec2.weak(174,197.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(174,197.5)   ,  Vec2.weak(0,393.5)   ,  Vec2.weak(205,197.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(418,80.5)   ,  Vec2.weak(242,170.5)   ,  Vec2.weak(226,186.5)   ,  Vec2.weak(437,78.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(437,78.5)   ,  Vec2.weak(226,186.5)   ,  Vec2.weak(461,73.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(461,73.5)   ,  Vec2.weak(226,186.5)   ,  Vec2.weak(984,132.5)   ,  Vec2.weak(674,-0.5)   ,  Vec2.weak(673,-0.5)   ,  Vec2.weak(503,57.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(219,191.5)   ,  Vec2.weak(1023,132.5)   ,  Vec2.weak(984,132.5)   ,  Vec2.weak(226,186.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,0);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road2"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("road");

			
				mat = material("road");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(1023.5,314)   ,  Vec2.weak(1023,52.5)   ,  Vec2.weak(989,51.5)   ,  Vec2.weak(642,113.5)   ,  Vec2.weak(618,119.5)   ,  Vec2.weak(0,314.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(53,59.5)   ,  Vec2.weak(26,54.5)   ,  Vec2.weak(-0.5,54)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(93,92.5)   ,  Vec2.weak(66,68.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(369,25.5)   ,  Vec2.weak(346,32.5)   ,  Vec2.weak(307,52.5)   ,  Vec2.weak(521,95.5)   ,  Vec2.weak(468,59.5)   ,  Vec2.weak(438,41.5)   ,  Vec2.weak(417,31.5)   ,  Vec2.weak(396,25.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(307,52.5)   ,  Vec2.weak(275,73.5)   ,  Vec2.weak(521,95.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(275,73.5)   ,  Vec2.weak(230,99.5)   ,  Vec2.weak(555,114.5)   ,  Vec2.weak(521,95.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(93,92.5)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(113,105.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(113,105.5)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(139,114.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(139,114.5)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(168,117.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(793,4.5)   ,  Vec2.weak(763,17.5)   ,  Vec2.weak(751.5,26)   ,  Vec2.weak(735.5,42)   ,  Vec2.weak(721,59.5)   ,  Vec2.weak(827,-0.5)   ,  Vec2.weak(813,0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(856,0.5)   ,  Vec2.weak(828,-0.5)   ,  Vec2.weak(827,-0.5)   ,  Vec2.weak(676,98.5)   ,  Vec2.weak(989,51.5)   ,  Vec2.weak(920,18.5)   ,  Vec2.weak(883,5.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(721,59.5)   ,  Vec2.weak(699,81.5)   ,  Vec2.weak(827,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(168,117.5)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(186,115.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(230,99.5)   ,  Vec2.weak(201,111.5)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(580,122.5)   ,  Vec2.weak(555,114.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(186,115.5)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(201,111.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(699,81.5)   ,  Vec2.weak(676,98.5)   ,  Vec2.weak(827,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(580,122.5)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(596,122.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(596,122.5)   ,  Vec2.weak(0,314.5)   ,  Vec2.weak(618,119.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(642,113.5)   ,  Vec2.weak(989,51.5)   ,  Vec2.weak(676,98.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,0);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road3"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("road");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(50,52.5)   ,  Vec2.weak(-0.5,53)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(120,93.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(120,93.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(184,122.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(1023,51.5)   ,  Vec2.weak(991,51.5)   ,  Vec2.weak(978,54.5)   ,  Vec2.weak(963,62.5)   ,  Vec2.weak(924,88.5)   ,  Vec2.weak(1023.5,313)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(924,88.5)   ,  Vec2.weak(891,105.5)   ,  Vec2.weak(1023.5,313)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(184,122.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(213,132.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(670,2.5)   ,  Vec2.weak(645,-0.5)   ,  Vec2.weak(623,-0.5)   ,  Vec2.weak(780.5,90)   ,  Vec2.weak(742,43.5)   ,  Vec2.weak(724,27.5)   ,  Vec2.weak(709,17.5)   ,  Vec2.weak(693,9.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(589,3.5)   ,  Vec2.weak(559,11.5)   ,  Vec2.weak(532,21.5)   ,  Vec2.weak(483,44.5)   ,  Vec2.weak(390,97.5)   ,  Vec2.weak(622,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(891,105.5)   ,  Vec2.weak(875,111.5)   ,  Vec2.weak(1023.5,313)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(875,111.5)   ,  Vec2.weak(855,116.5)   ,  Vec2.weak(1023.5,313)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(1023.5,313)   ,  Vec2.weak(855,116.5)   ,  Vec2.weak(840,118.5)   ,  Vec2.weak(0,313.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(213,132.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(236,138.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(236,138.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(260,142.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(260,142.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(280,142.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(780.5,90)   ,  Vec2.weak(623,-0.5)   ,  Vec2.weak(622,-0.5)   ,  Vec2.weak(350,118.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(797.5,107)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(280,142.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(303,137.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(390,97.5)   ,  Vec2.weak(350,118.5)   ,  Vec2.weak(622,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(303,137.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(318,132.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(318,132.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(350,118.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(797.5,107)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(809,114.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(809,114.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(823,118.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(823,118.5)   ,  Vec2.weak(0,313.5)   ,  Vec2.weak(840,118.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,0);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road4"] = new BodyPair(body,anchor);
		
	}
}
}

import nape.geom.Vec2;
import nape.phys.Body;

class BodyPair {
	public var body:Body;
	public var anchor:Vec2;
	public function BodyPair(body:Body,anchor:Vec2):void {
		this.body = body;
		this.anchor = anchor;
	}
}

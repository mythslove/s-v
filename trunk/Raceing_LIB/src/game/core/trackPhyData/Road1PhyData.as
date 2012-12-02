package game.core.trackPhyData{

import flash.geom.Rectangle;
import flash.utils.Dictionary;

import nape.callbacks.CbType;
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

public class Road1PhyData {

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
			graphic.rotation = b.rotation ;
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

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(1024,293)   ,  Vec2.weak(1024,31)   ,  Vec2.weak(550,74)   ,  Vec2.weak(464,87)   ,  Vec2.weak(0,293)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(0,32)   ,  Vec2.weak(0,293)   ,  Vec2.weak(187,59)   ,  Vec2.weak(44,35)   ,  Vec2.weak(20,32)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(187,59)   ,  Vec2.weak(0,293)   ,  Vec2.weak(314,77)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(314,77)   ,  Vec2.weak(0,293)   ,  Vec2.weak(405,86)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(872,0)   ,  Vec2.weak(835,4)   ,  Vec2.weak(819,8)   ,  Vec2.weak(801,15)   ,  Vec2.weak(1024,31)   ,  Vec2.weak(969,13)   ,  Vec2.weak(940,6)   ,  Vec2.weak(907,1)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(405,86)   ,  Vec2.weak(0,293)   ,  Vec2.weak(464,87)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(801,15)   ,  Vec2.weak(781,21)   ,  Vec2.weak(1024,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(781,21)   ,  Vec2.weak(760,27)   ,  Vec2.weak(1024,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(760,27)   ,  Vec2.weak(733,34)   ,  Vec2.weak(1024,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(733,34)   ,  Vec2.weak(693,44)   ,  Vec2.weak(1024,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(639,55)   ,  Vec2.weak(621,60)   ,  Vec2.weak(1024,31)   ,  Vec2.weak(680,47)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(550,74)   ,  Vec2.weak(1024,31)   ,  Vec2.weak(621,60)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(693,44)   ,  Vec2.weak(680,47)   ,  Vec2.weak(1024,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,293);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road1"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(1024,303)   ,  Vec2.weak(1024,41)   ,  Vec2.weak(986,38)   ,  Vec2.weak(812,58)   ,  Vec2.weak(0,303)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(0,42)   ,  Vec2.weak(0,303)   ,  Vec2.weak(39,44)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(332,2)   ,  Vec2.weak(295,0)   ,  Vec2.weak(261,2)   ,  Vec2.weak(226,7)   ,  Vec2.weak(179,17)   ,  Vec2.weak(379,19)   ,  Vec2.weak(365,12)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(741,47)   ,  Vec2.weak(687,47)   ,  Vec2.weak(645,53)   ,  Vec2.weak(620,61)   ,  Vec2.weak(790,58)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(39,44)   ,  Vec2.weak(0,303)   ,  Vec2.weak(57,43)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(57,43)   ,  Vec2.weak(0,303)   ,  Vec2.weak(122,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(832,52)   ,  Vec2.weak(820,57)   ,  Vec2.weak(986,38)   ,  Vec2.weak(905,39)   ,  Vec2.weak(852,47)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(122,31)   ,  Vec2.weak(0,303)   ,  Vec2.weak(436,46)   ,  Vec2.weak(401,29)   ,  Vec2.weak(179,17)   ,  Vec2.weak(140,26)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(379,19)   ,  Vec2.weak(179,17)   ,  Vec2.weak(401,29)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(620,61)   ,  Vec2.weak(601,67)   ,  Vec2.weak(790,58)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(601,67)   ,  Vec2.weak(566,75)   ,  Vec2.weak(0,303)   ,  Vec2.weak(812,58)   ,  Vec2.weak(790,58)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(436,46)   ,  Vec2.weak(0,303)   ,  Vec2.weak(476,65)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(476,65)   ,  Vec2.weak(0,303)   ,  Vec2.weak(498,74)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(498,74)   ,  Vec2.weak(0,303)   ,  Vec2.weak(518,80)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(518,80)   ,  Vec2.weak(0,303)   ,  Vec2.weak(533,80)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(533,80)   ,  Vec2.weak(0,303)   ,  Vec2.weak(566,75)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,303);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road2"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(0,293)   ,  Vec2.weak(1024,293)   ,  Vec2.weak(559,87)   ,  Vec2.weak(42,17)   ,  Vec2.weak(0,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(1024,32)   ,  Vec2.weak(1004,32)   ,  Vec2.weak(980,35)   ,  Vec2.weak(837,59)   ,  Vec2.weak(1024,293)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(837,59)   ,  Vec2.weak(710,77)   ,  Vec2.weak(1024,293)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(710,77)   ,  Vec2.weak(619,86)   ,  Vec2.weak(1024,293)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(108,2)   ,  Vec2.weak(75,8)   ,  Vec2.weak(55,13)   ,  Vec2.weak(42,17)   ,  Vec2.weak(233,18)   ,  Vec2.weak(205,8)   ,  Vec2.weak(169,1)   ,  Vec2.weak(139,0)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(619,86)   ,  Vec2.weak(559,87)   ,  Vec2.weak(1024,293)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(189,4)   ,  Vec2.weak(169,1)   ,  Vec2.weak(205,8)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(233,18)   ,  Vec2.weak(42,17)   ,  Vec2.weak(243,21)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(243,21)   ,  Vec2.weak(42,17)   ,  Vec2.weak(264,27)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(264,27)   ,  Vec2.weak(42,17)   ,  Vec2.weak(357,50)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(357,50)   ,  Vec2.weak(42,17)   ,  Vec2.weak(375,54)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(375,54)   ,  Vec2.weak(42,17)   ,  Vec2.weak(403,60)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(403,60)   ,  Vec2.weak(42,17)   ,  Vec2.weak(463,72)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,293);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road3"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(0,303)   ,  Vec2.weak(1024,303)   ,  Vec2.weak(212,58)   ,  Vec2.weak(192,54)   ,  Vec2.weak(39,38)   ,  Vec2.weak(0,41)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(283,47)   ,  Vec2.weak(234,58)   ,  Vec2.weak(438,71)   ,  Vec2.weak(379,53)   ,  Vec2.weak(337,47)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(1024,42)   ,  Vec2.weak(1003,42)   ,  Vec2.weak(986,44)   ,  Vec2.weak(1024,303)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(692,2)   ,  Vec2.weak(659,12)   ,  Vec2.weak(638,22)   ,  Vec2.weak(1024,303)   ,  Vec2.weak(828,15)   ,  Vec2.weak(798,7)   ,  Vec2.weak(751,1)   ,  Vec2.weak(713,0)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(986,44)   ,  Vec2.weak(967,43)   ,  Vec2.weak(1024,303)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(967,43)   ,  Vec2.weak(905,32)   ,  Vec2.weak(1024,303)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(905,32)   ,  Vec2.weak(879,26)   ,  Vec2.weak(1024,303)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(631,24)   ,  Vec2.weak(585,46)   ,  Vec2.weak(549,66)   ,  Vec2.weak(1024,303)   ,  Vec2.weak(638,22)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(119,39)   ,  Vec2.weak(39,38)   ,  Vec2.weak(192,54)   ,  Vec2.weak(172,47)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(649,16)   ,  Vec2.weak(638,22)   ,  Vec2.weak(659,12)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(879,26)   ,  Vec2.weak(858,20)   ,  Vec2.weak(828,15)   ,  Vec2.weak(1024,303)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(549,66)   ,  Vec2.weak(530,74)   ,  Vec2.weak(1024,303)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(438,71)   ,  Vec2.weak(234,58)   ,  Vec2.weak(212,58)   ,  Vec2.weak(1024,303)   ,  Vec2.weak(500,81)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(530,74)   ,  Vec2.weak(500,81)   ,  Vec2.weak(1024,303)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,303);
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

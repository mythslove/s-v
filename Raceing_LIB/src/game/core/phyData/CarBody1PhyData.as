package  game.core.phyData{

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

public class CarBody1PhyData {

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
							[   Vec2.weak(0,54)   ,  Vec2.weak(0,62)   ,  Vec2.weak(21,61)   ,  Vec2.weak(14,53)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(158,59)   ,  Vec2.weak(160,40)   ,  Vec2.weak(150,31)   ,  Vec2.weak(114,19)   ,  Vec2.weak(47,6)   ,  Vec2.weak(36,14)   ,  Vec2.weak(21,61)   ,  Vec2.weak(121,64)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(107,6)   ,  Vec2.weak(92,0)   ,  Vec2.weak(64,0)   ,  Vec2.weak(47,6)   ,  Vec2.weak(114,19)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(14,53)   ,  Vec2.weak(21,61)   ,  Vec2.weak(36,14)   ,  Vec2.weak(21,32)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(146,23)   ,  Vec2.weak(133,19)   ,  Vec2.weak(114,19)   ,  Vec2.weak(150,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,64);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["CarBody"] = new BodyPair(body,anchor);
		
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

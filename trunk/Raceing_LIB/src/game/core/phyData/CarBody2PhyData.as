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

public class CarBody2PhyData {

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
							[   Vec2.weak(0,45)   ,  Vec2.weak(38,59.5)   ,  Vec2.weak(31,16.5)   ,  Vec2.weak(9,12.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(241,50)   ,  Vec2.weak(235,33.5)   ,  Vec2.weak(203,22.5)   ,  Vec2.weak(180,19.5)   ,  Vec2.weak(39.5,59)   ,  Vec2.weak(176,61)   ,  Vec2.weak(211,59)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(31,16.5)   ,  Vec2.weak(38,59.5)   ,  Vec2.weak(39.5,59)   ,  Vec2.weak(77,-0.5)   ,  Vec2.weak(76,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(227,28.5)   ,  Vec2.weak(203,22.5)   ,  Vec2.weak(235,33.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(123,-0.5)   ,  Vec2.weak(77,-0.5)   ,  Vec2.weak(39.5,59)   ,  Vec2.weak(162,19)   ,  Vec2.weak(134,3.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(180,19.5)   ,  Vec2.weak(162,19)   ,  Vec2.weak(39.5,59)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,69);
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

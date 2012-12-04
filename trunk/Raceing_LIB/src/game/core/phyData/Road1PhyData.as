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
							[   Vec2.weak(0,292.5)   ,  Vec2.weak(1023.5,292)   ,  Vec2.weak(559,86.5)   ,  Vec2.weak(463,71.5)   ,  Vec2.weak(-0.5,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1023,31.5)   ,  Vec2.weak(1004,31.5)   ,  Vec2.weak(980,34.5)   ,  Vec2.weak(836,58.5)   ,  Vec2.weak(1023.5,292)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(836,58.5)   ,  Vec2.weak(709,76.5)   ,  Vec2.weak(1023.5,292)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(709,76.5)   ,  Vec2.weak(618,85.5)   ,  Vec2.weak(1023.5,292)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(108,1.5)   ,  Vec2.weak(75,7.5)   ,  Vec2.weak(42,16.5)   ,  Vec2.weak(-0.5,31)   ,  Vec2.weak(357,49.5)   ,  Vec2.weak(141,-0.5)   ,  Vec2.weak(140,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(618,85.5)   ,  Vec2.weak(559,86.5)   ,  Vec2.weak(1023.5,292)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(168,0.5)   ,  Vec2.weak(141,-0.5)   ,  Vec2.weak(264,26.5)   ,  Vec2.weak(188,3.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(463,71.5)   ,  Vec2.weak(357,49.5)   ,  Vec2.weak(-0.5,31)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,293);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road3"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(0,302.5)   ,  Vec2.weak(1023.5,302)   ,  Vec2.weak(212,57.5)   ,  Vec2.weak(39,37.5)   ,  Vec2.weak(-0.5,41)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(283,46.5)   ,  Vec2.weak(233,57.5)   ,  Vec2.weak(438,70.5)   ,  Vec2.weak(378,52.5)   ,  Vec2.weak(336,46.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(692,1.5)   ,  Vec2.weak(659,11.5)   ,  Vec2.weak(620,28.5)   ,  Vec2.weak(547,64.5)   ,  Vec2.weak(1023.5,302)   ,  Vec2.weak(762,1.5)   ,  Vec2.weak(715,-0.5)   ,  Vec2.weak(714,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(1023,41.5)   ,  Vec2.weak(1003,41.5)   ,  Vec2.weak(985,43.5)   ,  Vec2.weak(1023.5,302)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(985,43.5)   ,  Vec2.weak(967,42.5)   ,  Vec2.weak(1023.5,302)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(967,42.5)   ,  Vec2.weak(902,30.5)   ,  Vec2.weak(1023.5,302)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(902,30.5)   ,  Vec2.weak(797,6.5)   ,  Vec2.weak(762,1.5)   ,  Vec2.weak(1023.5,302)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(118,38.5)   ,  Vec2.weak(39,37.5)   ,  Vec2.weak(204,56.5)   ,  Vec2.weak(198,53.5)   ,  Vec2.weak(171,46.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(438,70.5)   ,  Vec2.weak(233,57.5)   ,  Vec2.weak(212,57.5)   ,  Vec2.weak(1023.5,302)   ,  Vec2.weak(499,80.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(547,64.5)   ,  Vec2.weak(516,76.5)   ,  Vec2.weak(1023.5,302)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(516,76.5)   ,  Vec2.weak(499,80.5)   ,  Vec2.weak(1023.5,302)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,303);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road4"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(1023.5,292)   ,  Vec2.weak(1023,30.5)   ,  Vec2.weak(526,77.5)   ,  Vec2.weak(463,86.5)   ,  Vec2.weak(0,292.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(-0.5,32)   ,  Vec2.weak(0,292.5)   ,  Vec2.weak(200,60.5)   ,  Vec2.weak(29,32.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(200,60.5)   ,  Vec2.weak(0,292.5)   ,  Vec2.weak(331,78.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(331,78.5)   ,  Vec2.weak(0,292.5)   ,  Vec2.weak(405,85.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(835,3.5)   ,  Vec2.weak(759,26.5)   ,  Vec2.weak(873,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(906,0.5)   ,  Vec2.weak(873,-0.5)   ,  Vec2.weak(692,43.5)   ,  Vec2.weak(1023,30.5)   ,  Vec2.weak(968,12.5)   ,  Vec2.weak(939,5.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(405,85.5)   ,  Vec2.weak(0,292.5)   ,  Vec2.weak(463,86.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(759,26.5)   ,  Vec2.weak(692,43.5)   ,  Vec2.weak(873,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(526,77.5)   ,  Vec2.weak(1023,30.5)   ,  Vec2.weak(620,59.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(620,59.5)   ,  Vec2.weak(1023,30.5)   ,  Vec2.weak(692,43.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,293);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road1"] = new BodyPair(body,anchor);
		
			body = new Body();
            cbtype(body.cbTypes,"");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");

				
					
						s = new Polygon(
							[   Vec2.weak(1023.5,302)   ,  Vec2.weak(1023,40.5)   ,  Vec2.weak(985,37.5)   ,  Vec2.weak(811,57.5)   ,  Vec2.weak(0,302.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(331,1.5)   ,  Vec2.weak(297,-0.5)   ,  Vec2.weak(476,64.5)   ,  Vec2.weak(403,28.5)   ,  Vec2.weak(364,11.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(740,46.5)   ,  Vec2.weak(687,46.5)   ,  Vec2.weak(645,52.5)   ,  Vec2.weak(600,66.5)   ,  Vec2.weak(790,57.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(-0.5,42)   ,  Vec2.weak(0,302.5)   ,  Vec2.weak(46,43.5)   ,  Vec2.weak(21,41.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(46,43.5)   ,  Vec2.weak(0,302.5)   ,  Vec2.weak(63,41.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(63,41.5)   ,  Vec2.weak(0,302.5)   ,  Vec2.weak(135,27.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(135,27.5)   ,  Vec2.weak(0,302.5)   ,  Vec2.weak(498,73.5)   ,  Vec2.weak(476,64.5)   ,  Vec2.weak(297,-0.5)   ,  Vec2.weak(296,-0.5)   ,  Vec2.weak(261,1.5)   ,  Vec2.weak(226,6.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(905,38.5)   ,  Vec2.weak(852,46.5)   ,  Vec2.weak(825,53.5)   ,  Vec2.weak(819,56.5)   ,  Vec2.weak(985,37.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(600,66.5)   ,  Vec2.weak(565,74.5)   ,  Vec2.weak(790,57.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(565,74.5)   ,  Vec2.weak(532,79.5)   ,  Vec2.weak(0,302.5)   ,  Vec2.weak(811,57.5)   ,  Vec2.weak(790,57.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(498,73.5)   ,  Vec2.weak(0,302.5)   ,  Vec2.weak(518,79.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
						s = new Polygon(
							[   Vec2.weak(518,79.5)   ,  Vec2.weak(0,302.5)   ,  Vec2.weak(532,79.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
                        cbtype(s.cbTypes,"");
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(0,303);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["road2"] = new BodyPair(body,anchor);
		
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

package bing.a3d.core
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.objects.WireFrame;
	
	import flash.geom.Vector3D;
	
	public class Trident extends Object3D
	{
		public function Trident()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false ;
			makeAxes();
		}
		
		private function makeAxes():void 
		{
			var axisX:WireFrame = WireFrame.createLinesList(Vector.<Vector3D>([new Vector3D(0, 0, 0), new Vector3D(100, 0, 0),  new Vector3D(100, 0, 0),  new Vector3D(90, 5, 0),  new Vector3D(100, 0, 0),  new Vector3D(90, -5, 0) ,
				new Vector3D(105,5,0) , new Vector3D(110,-5,0) , new Vector3D(110,5,0) ,new Vector3D(105,-5,0 )  ]), 0x0000ff, 2);
			var axisY:WireFrame = WireFrame.createLinesList(Vector.<Vector3D>([new Vector3D(0, 0, 0), new Vector3D(0, 100, 0), new Vector3D(0, 100, 0),new Vector3D(0, 90, 5),new Vector3D(0, 100, 0),new Vector3D(0, 90, -5) ,
				new Vector3D(0,105,5) , new Vector3D(0,110,0) , new Vector3D(0,115,5) ,new Vector3D(0,110,0) , new Vector3D(0,110,0) , new Vector3D(0,110,-15 )  ]), 0xff0000, 2);
			var axisZ:WireFrame = WireFrame.createLinesList(Vector.<Vector3D>([new Vector3D(0, 0, 0), new Vector3D(0, 0, 100), new Vector3D(0, 0, 100),new Vector3D(5, 0, 90),new Vector3D(0, 0, 100),new Vector3D(-5, 0, 90) ,
				new Vector3D(-2,0,110),new Vector3D(2,0,110) ,new Vector3D(2,0,110),new Vector3D(-2,0,105),new Vector3D(-2,0,105),new Vector3D(2,0,105) ]), 0x00ff00, 2);
			this.addChild(axisX);
			this.addChild(axisY);
			this.addChild(axisZ);
		}
	}
}
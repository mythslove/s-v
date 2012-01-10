package map.cell
{
	import bing.iso.IsoUtils;
	import bing.iso.path.Grid;
	import bing.utils.ContainerUtil;
	
	import comm.GameSetting;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import map.elements.BuildingBase;
	/**
	 * 建筑拥有的格子组
	 * @author zhouzhanglin
	 */	
	public class BuildingGridLayer extends Sprite
	{
		private var _build:BuildingBase ;
		public function BuildingGridLayer( building:BuildingBase )
		{
			super();
			_build = building ;
		}
		
		public function drawGrid():void
		{
			ContainerUtil.removeChildren(this);
			var points:Vector.<Vector3D> = _build.spanPosition ;
			for each( var point:Vector3D in points)
			{
				var rhomebus:BuildingGridRhombus = new BuildingGridRhombus(point.x/GameSetting.GRID_SIZE,point.z/GameSetting.GRID_SIZE );
				var p:Vector3D = point.clone();
				p.x -=_build.x;
				p.z -=_build.z ;
				var screenPos:Point = IsoUtils.isoToScreen(p);
				rhomebus.x = screenPos.x ;
				rhomebus.y = screenPos.y ;
				this.addChild( rhomebus );
			}
		}
		
		public function update(nodeX:int,nodeZ:int):void
		{
			const LEN:int = this.numChildren ;
			for( var i:int =0  ; i<LEN ; ++i  )
			{
				(this.getChildAt(i) as BuildingGridRhombus ).update(nodeX,nodeZ);
			}
		}
		
		public function setWalkabled( value:Boolean ):void
		{
			const LEN:int = this.numChildren ;
			for( var i:int =0  ; i<LEN ; ++i  )
			{
				(this.getChildAt(i) as BuildingGridRhombus ).setWalkabled(value);
			}
		}
		
		public function dispose():void
		{
			_build = null ;
		}
	}
}
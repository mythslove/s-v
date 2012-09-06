package local.map.cell
{
	import bing.iso.IsoUtils;
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import local.comm.GameSetting;
	import local.map.item.BaseBuilding;
	
	/**
	 * 建筑的底座 
	 * @author zhouzhanglin
	 */	
	public class BuildingBottomGrid extends Sprite
	{
		public static var rhombus:Vector.<BuildingGridRhombus> = Vector.<BuildingGridRhombus>([
			new BuildingGridRhombus(),new BuildingGridRhombus(),new BuildingGridRhombus(),new BuildingGridRhombus(),new BuildingGridRhombus(),
			new BuildingGridRhombus(),new BuildingGridRhombus(),new BuildingGridRhombus(),new BuildingGridRhombus()
		]);
		
		
		private var _building:BaseBuilding ;
		
		public function BuildingBottomGrid( building:BaseBuilding )
		{
			super();
			this.mouseChildren = this.mouseEnabled = false ;
			_building = building ;
		}
		
		/**
		 * 画网格 
		 */		
		public function drawGrid():void
		{
			ContainerUtil.removeChildren(this);
			var points:Vector.<Vector3D> = _building.spanPosition ;
			var bottom:BuildingGridRhombus ;
			var screenPos:Point  ;
			var p:Vector3D ;
			var i:int ;
			for each( var point:Vector3D in points)
			{
				bottom = rhombus[i] ;
				bottom.nodeX = (point.x-_building.x)/GameSetting.GRID_SIZE ;
				bottom.nodeZ = (point.z-_building.z)/GameSetting.GRID_SIZE ;
				p = point.clone();
				p.x -=_building.x;
				p.z -=_building.z ;
				screenPos = IsoUtils.isoToScreen(p);
				bottom.x = screenPos.x-GameSetting.GRID_SIZE ;
				bottom.y = screenPos.y ;
				this.addChild( bottom );
				bottom.updateBuildingGridRhombus( _building.nodeX , _building.nodeZ );
				++i ;
			}
		}
		
		/**
		 * 主要检测建筑层数据
		 * 更新所有的子格子颜色，会一个一个检查 
		 */		
		public function updateBuildingGridLayer():void
		{
			var len:int = this.numChildren ;
			for( var i:int =0  ; i<len ; ++i  )
			{
				(this.getChildAt(i) as BuildingGridRhombus ).updateBuildingGridRhombus(_building.nodeX,_building.nodeZ);
			}
		}
		
		/**
		 * 获取此建筑是否可以放下 
		 * @return 
		 */		
		public function getWalkable():Boolean
		{
			const LEN:int = this.numChildren-1 ;
			var bottom:BuildingGridRhombus ;
			for( var i:int =0  ; i<LEN ; ++i  )
			{
				bottom = getChildAt(i) as BuildingGridRhombus;
				if(bottom.walkable==false) return false;
			}
			return true ;
		}
		
		public function dispose():void
		{
			ContainerUtil.removeChildren(this);
			_building = null ;
		}
	}
}
package map.cell
{
	import bing.iso.IsoUtils;
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
		/**
		 * 建筑网格的构造函数 
		 * @param building 哪个建筑的网格
		 */		
		public function BuildingGridLayer( building:BuildingBase )
		{
			super();
			this.mouseChildren = this.mouseEnabled = false ;
			_build = building ;
		}
		
		/**
		 * 画网格 
		 */		
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
		
		/**
		 * 更新所有的子格子颜色，会一个一个检查 
		 * @param nodeX
		 * @param nodeZ
		 * 
		 */		
		public function update(nodeX:int,nodeZ:int):void
		{
			const LEN:int = this.numChildren ;
			for( var i:int =0  ; i<LEN ; ++i  )
			{
				(this.getChildAt(i) as BuildingGridRhombus ).update(nodeX,nodeZ);
			}
		}
		
		/**
		 * 获取此建筑是否可以放下 
		 * @return 
		 */		
		public function getWalkable():Boolean
		{
			const LEN:int = this.numChildren ;
			for( var i:int =0  ; i<LEN ; ++i  )
			{
				if( !(this.getChildAt(i) as BuildingGridRhombus ).walkable ) {
					return false;
				}
			}
			return true ;
		}
		
		/**
		 * 设置此网格所有的子格子颜色，直接全部设置，不单独检测
		 * @param value
		 */		
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
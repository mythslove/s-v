package local.map.cell
{
	import bing.iso.path.Grid;
	import bing.starling.iso.SIsoUtils;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import local.comm.GameSetting;
	import local.enum.ItemType;
	import local.map.item.BaseItem;
	import local.map.item.Wall;
	import local.model.MapGridDataModel;
	import local.model.PlayerModel;
	
	import starling.display.Sprite;
	
	/**
	 * 建筑的底座 
	 * @author zhouzhanglin
	 */	
	public class ItemBottomGrid extends Sprite
	{
		public static var rhombus:Vector.<ItemGridRhombus> = Vector.<ItemGridRhombus>([
			new ItemGridRhombus(),new ItemGridRhombus(),new ItemGridRhombus(),
			new ItemGridRhombus(),new ItemGridRhombus(), new ItemGridRhombus(),
			new ItemGridRhombus(),new ItemGridRhombus(), new ItemGridRhombus()
		]);
		
		
		private var _item:BaseItem ;
		
		public function ItemBottomGrid( building:BaseItem )
		{
			super();
			_item = building ;
		}
		
		/**
		 * 画网格 
		 */		
		public function drawGrid():void
		{
			removeChildren();
			var points:Vector.<Vector3D> = _item.spanPosition ;
			var bottom:ItemGridRhombus ;
			var screenPos:Point  ;
			var p:Vector3D ;
			var i:int ;
			for each( var point:Vector3D in points)
			{
				bottom = rhombus[i] ;
				bottom.nodeX = (point.x-_item.position.x)/GameSetting.GRID_SIZE ;
				bottom.nodeZ = (point.z-_item.position.z)/GameSetting.GRID_SIZE ;
				p = point.clone();
				p.x -=_item.position.x;
				p.z -=_item.position.z ;
				screenPos = SIsoUtils.isoToScreen(p);
				bottom.x = screenPos.x-GameSetting.GRID_SIZE ;
				bottom.y = screenPos.y ;
				this.addChild( bottom );
				++i ;
			}
		}
		
		/**
		 * 主要检测建筑层数据
		 * 更新所有的子格子颜色，会一个一个检查 
		 */		
		public function updateItemGridLayer():void
		{
			var gameGrid:Grid = MapGridDataModel.instance.gameGridData ;
			var rhombus:ItemGridRhombus ;
			if(_item.itemVO.baseVO.type==ItemType.WALL_PAPER || _item.itemVO.baseVO.type==ItemType.WALL_DECOR)
			{
				var temp:Boolean ;
				rhombus = this.getChildAt(0) as ItemGridRhombus ;
				var size:int = PlayerModel.instance.me.mapSize ;
				if( (_item.nodeX^_item.nodeZ)>0 && _item.nodeX<size && _item.nodeZ<size){
					temp = true ;
				}
				rhombus.setWalkabled( temp );
			}
			else
			{
				var len:int = this.numChildren ;
				for( var i:int =0  ; i<len ; ++i  )
				{
					(this.getChildAt(i) as ItemGridRhombus ).updateItemGridRhombus(_item.nodeX,_item.nodeZ,gameGrid);
				}
			}
		}
		
		/**
		 * 获取此建筑是否可以放下 
		 * @return 
		 */		
		public function getWalkable():Boolean
		{
			var bottom:ItemGridRhombus ;
			for( var i:int =0  ; i<numChildren ; ++i  )
			{
				bottom = getChildAt(i) as ItemGridRhombus;
				if(bottom.walkable==false) return false;
			}
			return true ;
		}
		
		override public function dispose():void
		{
			_item = null ;
		}
	}
}
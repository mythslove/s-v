package bing.iso
{
	import bing.iso.path.Grid;
	import bing.utils.ContainerUtil;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class IsoScene extends Sprite
	{
		protected var _sprites:Vector.<IsoObject> = new Vector.<IsoObject>();
		protected var _size:int ;
		protected var _gridData:Grid;
		
		public function IsoScene( size:int )
		{
			super();
			this._size = size ;
		}
		
		
		/********************************************************
		 * 添加对象
		 * ********************************************************/
		public function addIsoObject( obj:IsoObject , isSort:Boolean=true ):IsoObject
		{
			this.addChildAt( obj,0 );
			_sprites.push( obj );
			if(isSort) sortAll();
			return obj ;
		}
		/********************************************************
		 * 移除对象
		 * ********************************************************/
		public function removeIsoObject( obj:IsoObject) :IsoObject
		{
			this.removeChild( obj );
			for(var i:int = 0 ; i<_sprites.length ; i++){
				if(_sprites[i]==obj){
					_sprites.splice( i ,1 );
					break ;
				}
			}
			return obj ;
		}
		
		
		/********************************************************
		 * 更新：遍历所有的对象，并进行排序和更新操作
		 * ********************************************************/
		public function update():void
		{
			for each(var obj:IsoObject in _sprites )
			{
				obj.update();
				if(obj.isSort)	sortIsoObject(obj);
			}
		}
		
		/** 对场景中所有的对象进行排序  */
		public function sortAll():void
		{
			for each(var obj:IsoObject in _sprites )
			{
				sortIsoObject(obj);
				obj.isSort = false ;
			}
		}
		
		/**        对一个iso对象进行深度排序           */
		protected function sortIsoObject( obj:IsoObject ):void
		{
			this.setChildIndex( obj , 0);
			//排序
			var len:int = this.numChildren ;
			var target:IsoObject ;
			for(var i:int = len-1 ; i>=0 ; i--)
			{
				target= this.getChildAt(i) as IsoObject ;
				if(target && target!=obj && this.sortCompare(target,obj)<0)
				{
					this.setChildIndex( obj , i );
					break ;
				}
			}
			obj.isSort = false ;
		}
		
		/**        排序算法           */
		protected function sortCompare( target:IsoObject , item:IsoObject ):int
		{
			var targetRect:Rectangle = target.rect ;
			var itemRect:Rectangle = item.rect ;
			if(targetRect.x>itemRect.x+itemRect.width ||  targetRect.y>itemRect.y+itemRect.height || target.y>item.y){
				return 1;
			}else if(targetRect.x==itemRect.x+itemRect.width &&  targetRect.y==itemRect.y+itemRect.height && target.y==item.y){
				return 0 ;
			}
			return -1;
		}
		
		
		
		/********************************************************
		 * 创建网格数据
		 * ********************************************************/
		public function createGridData( gridX:int , gridZ:int ):void
		{
			_gridData = new Grid( gridX , gridZ ) ;
		}
		/**      返回网格数据      */
		public function get gridData():Grid
		{
			return _gridData ;
		}
		/**  设置网格数据，有时需要共用一个网格数据源 */
		public function set gridData( gird:Grid ):void
		{
			this._gridData = gird ;
		}
		
		
		/********************************************************
		 * 清除数据
		 * ********************************************************/
		public function dispose():void
		{
			for each( var obj:IsoObject in _sprites){
				obj = null ;
			}
			_sprites=  null ;
			ContainerUtil.removeChildren( this );
		}
		
		/********************************************************
		 * 清空场景
		 * ********************************************************/
		public function clear():void
		{
			for each( var obj:IsoObject in _sprites){
				obj = null ;
			}
			ContainerUtil.removeChildren( this );
		}
	}
}
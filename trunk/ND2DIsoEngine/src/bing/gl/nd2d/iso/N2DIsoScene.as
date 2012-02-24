package bing.gl.nd2d.iso
{
	import bing.iso.path.Grid;
	
	import flash.geom.Rectangle;
	
	public class N2DIsoScene extends N2DIsoObject
	{
		protected var _sprites:Vector.<N2DIsoObject> = new Vector.<N2DIsoObject>();
		protected var _gridData:Grid;
		
		public function N2DIsoScene( size:int, xSpan:int = 1, zSpan:int =1 )
		{
			super(size,xSpan,zSpan);
		}
		
		/********************************************************
		 * 添加对象
		 * ********************************************************/
		public function addIsoObject( obj:N2DIsoObject , isSort:Boolean=true ):N2DIsoObject
		{
			this.addChildAt( obj,0 );
			_sprites.push( obj );
			if(isSort){
				sortIsoObject(obj);
			}
			return obj ;
		}
		/********************************************************
		 * 移除对象
		 * ********************************************************/
		public function removeIsoObject( obj:N2DIsoObject) :N2DIsoObject
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
		override public function update():void
		{
			super.update();
			for each(var obj:N2DIsoObject in _sprites ) {
				obj.update();
				if(obj.isSort)	{
					setChildIndex( obj,0 );
					sortIsoObject(obj);
				}
			}
		}
		
		/** 对场景中所有的对象进行排序  */
		public function sortAll():void
		{
			for each(var obj:N2DIsoObject in _sprites )
			{
				setChildIndex( obj,0 );
				sortIsoObject(obj);
				obj.isSort = false ;
			}
		}
		
		/**        对一个iso对象进行深度排序           */
		protected function sortIsoObject( obj:N2DIsoObject ):void
		{
			var index:int = getChildIndex(obj);
			//排序
			var len:int = this.numChildren ;
			var target:N2DIsoObject ;
			for(var i:int = len-1 ; i>index ; --i)
			{
				target= this.getChildAt(i) as N2DIsoObject ;
				if(target && target!=obj && this.sortCompare(target,obj)<0)
				{
					this.setChildIndex( obj , i );
					break ;
				}
			}
			obj.isSort = false ;
		}
		
		/**        排序算法           */
		protected function sortCompare( target:N2DIsoObject , item:N2DIsoObject ):int
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
		 * 清除数据，以后不会这个scene时使用。
		 * ********************************************************/
		override public function dispose():void
		{
			super.dispose();
			for each( var obj:N2DIsoObject in _sprites){
				obj = null ;
			}
			_sprites=  null ;
		}
		
		/********************************************************
		 * 清空场景
		 * ********************************************************/
		public function clear():void
		{
			for each( var obj:N2DIsoObject in _sprites){
				obj = null ;
			}
			removeAllChildren();
			_sprites = new Vector.<N2DIsoObject>();
		}
	}
}
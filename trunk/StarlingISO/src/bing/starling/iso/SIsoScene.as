package bing.starling.iso
{
	import bing.iso.path.Grid;
	
	import flash.geom.Rectangle;

	public class SIsoScene extends SIsoObject
	{
		protected var _sprites:Vector.<SIsoObject> = new Vector.<SIsoObject>();
		protected var _gridData:Grid;
		
		public function SIsoScene( size:int, xSpan:int = 1, zSpan:int =1 )
		{
			super(size, xSpan, zSpan);
		}
		
		public function get children():Vector.<SIsoObject>{
			return _sprites;
		}
		
		/********************************************************
		 * 添加对象
		 * ********************************************************/
		public function addIsoObject( obj:SIsoObject , isSort:Boolean=true ):SIsoObject
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
		public function removeIsoObject( obj:SIsoObject) :SIsoObject
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
			for each(var obj:SIsoObject in _sprites ) {
				obj.update();
				if(obj.isSort)	{
					sortIsoObject(obj);
					obj.isSort = false ;
				}
			}
		}
		
		/** 对场景中所有的对象进行排序  */
		public function sortAll():void
		{
			for each(var obj:SIsoObject in _sprites )
			{
				sortIsoObject(obj);
				obj.isSort = false ;
			}
		}
		
		/**        对一个iso对象进行深度排序           */
		public function sortIsoObject( obj:SIsoObject ):void
		{
			setChildIndex( obj,0 );
			//排序
			var target:SIsoObject ;
			for(var i:int = numChildren-1 ; i>0 ; --i)
			{
				target= this.getChildAt(i) as SIsoObject ;
				if(target && target!=obj && this.sortCompare(target,obj)<0)
				{
					this.setChildIndex( obj , i );
					break ;
				}
			}
		}
		
		/**        排序算法           */
		protected function sortCompare( target:SIsoObject , item:SIsoObject ):int
		{
			var targetRect:Rectangle = target.rect ;
			var itemRect:Rectangle = item.rect ;
			if(targetRect.x>itemRect.x+itemRect.width ||  targetRect.y>itemRect.y+itemRect.height || target.position.y >item.position.y ){
				return 1;
			}else if(targetRect.x==itemRect.x+itemRect.width &&  targetRect.y==itemRect.y+itemRect.height && target.position.y == item.position.y){
				return item.screenY-target.screenY ;
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
		override public function sdispose():void
		{
			super.sdispose();
			for each( var obj:SIsoObject in _sprites){
				obj = null ;
			}
			_sprites=  null ;
			removeAll();
		}
		
		/********************************************************
		 * 清空场景
		 * ********************************************************/
		public function clear():void
		{
			for each( var obj:SIsoObject in _sprites){
				obj = null ;
			}
			removeAll();
			_sprites = new Vector.<SIsoObject>();
		}
		
		//仅仅清除场景上的对象
		private function removeAll():void
		{
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
		}
	}
}
package bing.iso
{
	import bing.iso.path.Grid;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	public class IsoObject extends Sprite
	{
		public var isSort:Boolean = false ;
		protected var _position3D:Vector3D; //像素坐标
		protected var _size:Number; //格子大小
		protected var _xSpan:int ; //X方向占用的格子数
		protected var _zSpan:int ; //Z方向占用的格子数
		protected var _nodeX:int ; //格子坐标(地图单元格坐标)
		protected var _nodeZ:int ; //格子坐标(地图单元格坐标)
		protected var _spanPosition:Vector.<Vector3D> ; //占用了哪几个格子
		protected var _isRotate:Boolean=false ; //是否旋转
		protected var _boundRect:Rectangle = new Rectangle();
		
		// a more accurate version of 1.2247...
		public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) * Math.SQRT2;

		/**
		 *  
		 * @param size 格子大小
		 * @param xSpan X坐标上跨多少行
		 * @param zSpan Z坐标上跨多少行
		 * 
		 */		
		public function IsoObject(size:Number , xSpan:int = 1, zSpan:int =1 )
		{
			_size = size;
			_xSpan = xSpan ;
			_zSpan = zSpan ;
			_position3D = new Vector3D();
			updateScreenPosition();
		}
		
		public function sort():void
		{
			this.isSort = true ;
		}
		
		/**
		 * 旋转 
		 * @param value
		 */		
		public function rotateX( value:Boolean ):void
		{
			this._isRotate = value ;
			this.updateSpanPosition() ;
		}
		
		/**
		 * Converts current 3d position to a screen position 
		 * and places this display object at that position.
		 */
		protected function updateScreenPosition():void
		{
			var screenPos:Point = IsoUtils.isoToScreen(_position3D);
			super.x = screenPos.x;
			super.y = screenPos.y;
			updateSpanPosition();
		}
		
		/**
		 * 计算占用了哪几个格子 
		 */		
		protected function updateSpanPosition():void
		{
			_spanPosition = new Vector.<Vector3D>();
			var pos:Vector3D;
			if(_isRotate)
			{
				for( i = 0 ;  i<_zSpan ; i++)
				{
					for( j = 0 ; j<_xSpan ; j++)
					{
						pos = new Vector3D( i*_size+this.x , this.y , j*_size+this.z );
						_spanPosition.push( pos );
					}
				}
			}
			else
			{
				for( var i:int = 0 ;  i<_xSpan ; i++)
				{
					for( var j:int = 0 ; j<_zSpan ; j++)
					{
						pos = new Vector3D( i*_size+this.x , this.y , j*_size+this.z );
						_spanPosition.push( pos );
					}
				}
			}
		}
		
		public function setScreenPosition(x:Number , y:Number):void 
		{
			super.x = x ;
			super.y= y ;
		}
		
		/**
		 * 不断执行 
		 */		
		public function update():void
		{
			
		}
		
		/**
		 * String representation of this object.
		 */
		override public function toString():String
		{
			return "[IsoObject (x:" + _position3D.x + ", y:" + _position3D.y + ", z:" + _position3D.z + ") ]";
		}
		
		/**
		 * Sets / gets the x position in 3D space.
		 */
		override public function set x(value:Number):void
		{
			_position3D.x = value;
			updateScreenPosition();
			updateSpanPosition();
		}
		override public function get x():Number
		{
			return _position3D.x;
		}
		
		/**
		 * Sets / gets the y position in 3D space.
		 */
		override public function set y(value:Number):void
		{
			_position3D.y = value;
		}
		override public function get y():Number
		{
			return _position3D.y;
		}
		
		/**
		 * Sets / gets the z position in 3D space.
		 */
		override public function set z(value:Number):void
		{
			_position3D.z = value;
			updateScreenPosition();
			updateSpanPosition();
		}
		override public function get z():Number
		{
			return _position3D.z;
		}
		
		/**
		 * Sets / gets the position in 3D space as a Vecter3D.
		 */
		public function set position(value:Vector3D):void
		{
			_position3D = value;
			updateScreenPosition();
			updateSpanPosition();
		}
		public function get position():Vector3D
		{
			return _position3D;
		}
		
		/**
		 * Returns the transformed 3D depth of this object.
		 */ 
		public function get depth():Number
		{
			return (_position3D.x + _position3D.z) * .866 - _position3D.y * .707;
		}
		
		/**
		 * Indicates whether the space occupied by this object can be occupied by another object.
		 */
		public function setWalkable(value:Boolean , grid:Grid ):void
		{
			updateSpanPosition();
			var points:Vector.<Vector3D> = this.spanPosition ;
			for each( var point:Vector3D in points)
			{
				grid.setWalkable( Math.floor(point.x/_size) , Math.floor(point.z/_size) , value );
			}
		}
		public function getWalkable( grid:Grid ):Boolean
		{
			var points:Vector.<Vector3D> = this.spanPosition ;
			var flag:Boolean ;
			for each( var point:Vector3D in points)
			{
				var nodeX:int = Math.floor(point.x/_size) ;
				var nodeY:int = Math.floor(point.z/_size) ;
				if( nodeX<0 || nodeX>grid.numCols-1) return false ;
				if( nodeY<0 || nodeY>grid.numRows-1) return false ;
				
				flag = grid.getNode( nodeX , nodeY ).walkable ;
				if( !flag) return false ;
			}
			return true ;
		}
		
		public function getRotatable( grid:Grid  ):Boolean
		{
			if(this._xSpan==this._zSpan) return true;
			
			setWalkable(true,grid);
			_isRotate = !_isRotate;
			updateSpanPosition();
			var bool:Boolean = getWalkable(grid);
			//还原
			_isRotate = !_isRotate;
			setWalkable(false,grid);
			return bool;
		}
		
		/**
		 * Returns the size of this object.
		 */
		public function get size():Number
		{
			return _size;
		}
		
		/**
		 * Returns the square area on the x-z plane that this object takes up.
		 */
		public function get rect():Rectangle
		{
			_boundRect.x = x ;
			_boundRect.y = z ;
			if(this._isRotate){
				_boundRect.width = size*(_zSpan-1)  ;
				_boundRect.height = size*(_xSpan-1)  ;
			}else{
				_boundRect.height = size*(_zSpan-1)  ;
				_boundRect.width = size*(_xSpan-1)  ;
			}
			return _boundRect ;
		}
		
		/**
		 * 网格坐标 X
		**/
		public function set nodeX( value:int ):void
		{
			_nodeX = value ;
			this.x = value*_size ;
		}
		
		/**
		 *  网格坐标Z
		 * @param value
		 */		
		public function set nodeZ( value:int ):void
		{
			_nodeZ = value ;
			this.z = value*_size ;
		}
		
		public function get nodeX():int 
		{
			return  this.x/_size  ;
		}
		
		public function get nodeZ():int
		{
			return  this.z/_size  ;
		}
		/**
		 * flash坐标系的X 
		 */		
		public function get screenX():Number
		{
			return super.x ;
		}
		/**
		 * flash坐标系的Y 
		 */		
		public function get screenY():Number
		{
			return super.y;
		}
		
		/**
		 * 占用的格子,像素坐标 
		 * @return 
		 */		
		public function get spanPosition():Vector.<Vector3D>
		{
			return _spanPosition;
		}
		
		/**
		 * 消除资源 
		 */		
		public function dispose():void
		{
			_boundRect = null ;
			_spanPosition = null ;
			_position3D = null ;
		}
	}
}
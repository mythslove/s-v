package bing.starling.component
{
	import starling.display.Quad;
	/**
	 * 线 
	 * @author zhouzhanglin
	 * 
	 */	
	public class Line extends Quad
	{
		private var _thickness:Number = 1;
		
		/**
		 * 线 
		 * @param thickness 线粗度
		 * @param color 线颜色
		 */		
		public function Line( thickness:int = 1 , color:uint=16777215)
		{
			super(1 , thickness , color , true );
			this._thickness = thickness ;
		}
		
		public function set thickness(t:Number):void
		{
			var currentRotation:Number = rotation;
			rotation = 0;
			height = _thickness = t;
			rotation = currentRotation;
		}
		
		public function get thickness():Number
		{
			return _thickness;
		}
		
		public function lineTo(toX:int, toY:int):void
		{
			var px:int = toX-x ;
			var py:int = toY-y ;
			width = Math.round(Math.sqrt((px*px)+(py*py)));
			rotation = Math.atan2(py , px );
		}
		
		public function moveTo(toX:Number, toY:Number):void
		{
			x = toX ;
			y = toY ;
		}
	}
}
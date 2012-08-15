package bing.map.model
{
	import bing.map.data.MapData;
	
	import flash.display.Shape;

	/**
	 * 圆圈 
	 * @author zhouzhanglin
	 */	
	public class Circle extends Shape
	{
		/**
		 * 构造函数 
		 * @param color 16进制的数字
		 * @param bgColor 背景颜色
		 */		
		public function Circle(borderColor:uint,bgColor:uint){
			//格子的行 列
			var gridW:Number=MapData.tileWidth;
			var gridH:Number=MapData.tileHeight;
			
			this.graphics.beginFill(borderColor);
			this.graphics.lineStyle(1,borderColor);
			this.graphics.drawCircle( 0 , 0 , 10 );
			this.graphics.endFill();
		}
	}
}
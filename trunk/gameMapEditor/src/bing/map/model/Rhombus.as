package bing.map.model
{
	import bing.map.data.MapData;
	
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * 菱形 
	 * @author zhouzhanglin
	 * 
	 */	
	public class Rhombus extends Shape
	{
		/**
		 * 构造函数 
		 * @param color 16进制的数字
		 * @param bgColor 背景颜色
		 */		
		public function Rhombus(borderColor:uint,bgColor:uint):void{
			
			//格子的行 列
			var gridW:Number=MapData.tileWidth;
			var gridH:Number=MapData.tileHeight;
			
			this.graphics.beginFill(bgColor);
			this.graphics.lineStyle(1,borderColor);
			this.graphics.moveTo(gridW*0.5,0);
			this.graphics.lineTo(0,gridH*0.5);
			this.graphics.lineTo(gridW*0.5,gridH);
			this.graphics.lineTo(gridW,gridH*0.5);

			this.graphics.endFill();
		}
	}
}
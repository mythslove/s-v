package  tool.local.vos
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 位置动画资源 ，在二进制中，按照此属性的顺序写
	 * @author zhouzhanglin
	 */	
	public class BitmapAnimResVO
	{
		public var offsetX:int ; //偏移
		public var offsetY:int ;
		public var bmds:Vector.<BitmapData> ;
		public var isAnim:Boolean ;
		public var row:int ;
		public var col:int ;
		public var frame:int ;
		public var rate:int ;
		public var scaleX:Number = 1 ;
		public var scaleY:Number = 1 ;
		public var resName:String ;//也许有相同的资源
		
		public var roads:Vector.<Point> ;
		
		//不保存，原图
		public var png:BitmapData ;
		
		
		
		/*将切割的图片合并成一张图*/
		public function mergeBmds():void
		{
			if(!isAnim)  {
				png = this.bmds[0] ;
				return ;
			}
			
			var wid:int = this.bmds[0].width ;
			var het:int = this.bmds[0].height ;
			png = new BitmapData(wid*col , het*row );
			var count:int =0 ;
			var p:Point= new Point();
			var bitmaps:Vector.<BitmapData> = bitmaps;
			for ( var i:int = 0 ; i<row ; i++)
			{
				for( var j:int = 0 ; j<col ; j++ )
				{
					p.x = j*wid ;
					p.y = i*het ;
					png.copyPixels( this.bmds[count] , this.bmds[count].rect , p );
					count++;
					if(count==frame) return ;
				}
			}
		}
	}
}
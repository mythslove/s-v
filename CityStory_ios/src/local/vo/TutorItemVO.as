package local.vo
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TutorItemVO
	{
		public var rect:Rectangle ; //范围
		/** 框的类型 , circle圆, roundRect圆角矩形 , none:清除 , all 所有 <br/>
		 * tippop指示窗口  , pause等待 , info消息框 , upgardeInfo消息框
		 */
		public var rectType:String ; 
		/** 是否显示箭头*/
		public var showArrow:Boolean ;
		/** 箭头位置*/
		public var arrowPoint:Point ;
		/** 箭头角度*/
		public var arrowAngle:int ;
		/** mask透明度*/
		public var alpha:Number=0.6;
		/** 提示消息*/
		public var info:String ;
	}
}
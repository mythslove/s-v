package local.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 游戏工具类 
	 * @author zhouzhanglin
	 */	
	public class GameUtil
	{
		/**
		 * 方向位置 
		 * @param p1
		 * @param p2
		 * @return 
		 */		
		public static function getDirection4( x1:Number , y1:Number , x2:Number , y2:Number  ):int{
			var nx:Number=x1-x2 ;
			var ny:Number=y1-y2 ;
			var r:Number=Math.sqrt(nx*nx+ny*ny);
			var cos:Number=nx/r;
			var angle:int=int(Math.floor(Math.acos(cos)*180/Math.PI));
			if(ny<0){
				angle=360-angle;
			}
			if(angle>270 ){
				return 1 ;
			}else if(angle>180)	{
				return 4;	
			}else if(angle>90){
				return 3 ;
			}else {
				return 2 ;
			}
		}
		
		/**
		 * 将数字转化成字符串 
		 * @param value
		 * @return 
		 */		
		public static function moneyFormat( value:int ):String
		{
			var str:String = value +"";
			var len:int= str.length ;
			var result:String="" ;
			var temp:int = len%3 ;
			var count:int ;
			for( var i:int = 0 ; i<len ; ++i){
				result = result.concat(str.charAt(i));
				if(i>=temp){
					++count ;
					if(count>2 && i<len-1){
						result = result.concat(",");
						count =0 ;
					}
				}else if(len>3 && i+1==temp){
					result = result.concat(",");
				}
			}
			return result ;
		}
		
		
		/**
		 * 转成相应的表示 ，如15Hours .30Mins
		 * @param time 以秒为单位。
		 * @return 
		 */		
		public static function getTimeString( time:int ):String{
			if(time>24*3600) return Math.floor(time/3600/24)+" Day"
			if( time>3600) return Math.floor(time/3600)+ " Hours" ;
			if( time>60) return Math.floor(time/60)+ " Mins" ;
			return time + " Secs" ;
		}
		
		/**
		 * 加粗显示字符串
		 * @param tf
		 * @param txt
		 */		
		public static function boldTextField( tf:TextField , txt:String ):void{
			tf.mouseEnabled = false ;
			var tfort:TextFormat = tf.defaultTextFormat;
			tfort.bold = true;
			tf.defaultTextFormat = tfort ;
			tf.text = txt ;
		}
		
		

		
		
		
		
		
		//================游戏中的数量计算=========================
		
		/**
		 * 时间兑换成Cash
		 */		
		public static function timeToCash( time:int ):int
		{
			return ( 1 + Math.log( (time/60 + 10)/10 )/Math.LN10*8 )>>0 ;
		}
		
		/**
		 * 过期后，要保存所有的
		 * @param goods
		 * @return 
		 */		
		public static function expiredSaveAllCash( goods:int ):int
		{
			return Math.ceil( expiredRecverGoods(goods)/35 );
		}
		
		/**
		 * 过期后，可以得到多少goods 
		 * @param goods
		 * @return 
		 */		
		public static function expiredRecverGoods( goods:int ):int
		{
			return (goods/5)>>0;
		}
	}
}
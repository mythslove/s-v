package game.util
{
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;

	public class GameUtil
	{
		public static function dark( container:DisplayObjectContainer ):void
		{
			for( var i:int  = 0 ; i<container.numChildren ; ++i )
			{
				if(container.getChildAt(i).hasOwnProperty("color") && !(container.getChildAt(i) is TextField)){
					container.getChildAt(i)["color"] = 0x666666 ;
				}else if(container.getChildAt(i) is DisplayObjectContainer){
					dark(container.getChildAt(i) as DisplayObjectContainer) ;
				}
			}
		}
		public static function light( container:DisplayObjectContainer ):void{
			for( var i:int  = 0 ; i<container.numChildren ; ++i )
			{
				if(container.getChildAt(i).hasOwnProperty("color") && !(container.getChildAt(i) is TextField)){
					container.getChildAt(i)["color"] = 0xffffff ;
				}else if(container.getChildAt(i) is DisplayObjectContainer){
					light(container.getChildAt(i) as DisplayObjectContainer) ;
				}
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
				result += str.charAt(i) ;
				if(i>=temp){
					++count ;
					if(count>2 && i<len-1){
						result += "," ;
						count =0 ;
					}
				}else if(len>3 && i+1==temp){
					result +=  ","  ;
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
			if(time>24*3600) return Math.floor(time/3600/24)+" Days";
			if( time>3600) return Math.floor(time/3600)+" Hours";
			if( time>60) return Math.floor(time/60)+" Mins";
			return time +" Secs";
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
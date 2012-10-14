package local.util
{
	import local.model.BuildingModel;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
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
		 * 通过key获取本地化语言 
		 * @param key
		 * @param param 占位符文字替换
		 * @return 
		 */		
		public static function localizationString( key:String , ...param ):String
		{
			return "";
//			var temp:String = GameData.lang[key]  ;
//			if(temp){
//				if(param && param.length>0){
//					temp = StringUtil.stringFormat (temp , param );
//				}
//			}else{
//				temp = "";
//			}
//			return temp;
		}
		
		
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
			if(time>24*3600) return Math.floor(time/3600/24)+" "+localizationString("days");
			if( time>3600) return Math.floor(time/3600)+" "+localizationString("hours");
			if( time>60) return Math.floor(time/60)+" "+localizationString("mins");
			return time +" "+localizationString("secs");
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
		
		/**
		 * 返回扩地需要花费的时间 
		 * @return 
		 */		
		public static function getExpandTime():int
		{
//			var len:int = LandModel.instance.expands.length ;
			return 0;//120*len ;
		}
		
		/**
		 * 修建工厂需要几个人口 
		 * @return 
		 */		
		public static function buildIndustryPop():int
		{
			var count:int ;
			if( BuildingModel.instance.industry){
				count = BuildingModel.instance.industry.length ;
			}
			return  80*count*count+10*count*count+150 ;
		}
	}
}
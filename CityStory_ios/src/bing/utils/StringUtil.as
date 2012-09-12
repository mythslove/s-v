package bing.utils
{
	

	/**
	 * 字符串工具类 
	 * @author zzhanglin
	 * 
	 */	
	public class StringUtil
	{
		public static function trim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp = /^\s*|\s*$/;
			return char.replace(pattern, "");
		}        
		// 去左空格
		public static function ltrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp = /^\s*/;
			return char.replace(pattern, "");
		}
		// 去右空格
		public static function rtrim(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp = /\s*$/;
			return char.replace(pattern, "");
		}
		
		/**
		 * StringUtil.stringFormat( "我是{0}adaf{1},哈", "一名","!") 
		 * @param str
		 * @param param
		 * @return 
		 */		
		public static function stringFormat( str:String , ...param ):String{
			var reg:RegExp = /\{(\d)\}/ ;
			var i:int ;
			while(str.search(reg)>-1 ){
				str = str.replace( reg , param[i] );
				++ i ;
			}
			return str;
		}
		
		/**
		 * 将数字转化成字符串 
		 * @param value
		 * @return 
		 * 
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
	}
}
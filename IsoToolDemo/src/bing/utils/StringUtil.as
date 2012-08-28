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
	}
}
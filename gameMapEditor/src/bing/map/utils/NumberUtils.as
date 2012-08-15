package bing.map.utils{

	/**
	* 数字工具类
	*/
	public class NumberUtils {
		/**
		*  判断字符串是否是数字
		*true表示是数字
		*/
		public static function checkNumber(num:String):Boolean {
			var rep:RegExp=/^[0-9]*$/;
			if (rep.test(num)) {
				return true;
			}
			return false;
		}
		/**
		 * 类型转换
		 */
		public static function radixChange(txt:String,radix:uint,target:uint):String {
			var num:Number = parseInt(txt,radix);//把2~32进制转换为10进制 
			return num.toString(target);//把10进制转换为2~32进制 
		}
	}
}
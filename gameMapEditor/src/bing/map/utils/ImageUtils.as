package bing.map.utils
{
	import flash.net.FileFilter;
	/**
	 * 图片工具类 
	 * @author zhouzhanglin
	 */	
	public class ImageUtils
	{
		/**
		 * 限制文件选择类型
		 * */
		public static function getTypes():Array {
			var allTypes:Array = new Array(new FileFilter("Images (*.jpg, *.jpeg*.png)", "*.jpg;*.jpeg;*.png"));
			return allTypes;
		}
	}
}
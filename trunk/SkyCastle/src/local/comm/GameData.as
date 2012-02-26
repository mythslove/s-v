package local.comm
{
	import bing.utils.ContainerUtil;
	
	import  local.enums.BuildingCurrentOperation;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	

	public class GameData
	{
		//********************************************************************		
		private static var _buildingCurrOperation:String = "add";
		/**
		 *  设置当前对鼠标的操作，并更改鼠标跟随icon
		 * @param value BuildingCurrentOperation中的常量
		 */
		public static function set buildingCurrOperation(value:String):void
		{
			
		}
		/** 当前对建筑的操作  */
		public static function get buildingCurrOperation():String
		{
			return _buildingCurrOperation;
		}
	
	
	}
}
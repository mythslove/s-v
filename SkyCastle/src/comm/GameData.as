package comm
{
	import enums.BuildingCurrentOperation;
	
	import map.GameWorld;

	public class GameData
	{
		/**
		 *  当前对建筑的操作
		 */		
		private static var _buildingCurrOperation:String = "none";
		public static function get buildingCurrOperation():String{
			return _buildingCurrOperation ;
		}
		public static function set buildingCurrOperation(value:String):void{
			_buildingCurrOperation = value ;
			if( value==BuildingCurrentOperation.ADD)
			{
				GameWorld.instance.gridScene.visible=true;
			}
			else
			{
				GameWorld.instance.gridScene.visible=false;
			}
		}
	}
}
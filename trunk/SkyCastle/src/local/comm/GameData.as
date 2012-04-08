package local.comm
{
	import local.enum.BuildingOperation;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.model.vos.ConfigBaseVO;
	import local.utils.MouseManager;
	import local.views.icon.*;
	

	public class GameData
	{
		//********************************************************************		
		private static var _buildingCurrOperation:String = BuildingOperation.NONE ;
		/**
		 *  设置当前对鼠标的操作，并更改鼠标跟随icon
		 * @param value BuildingCurrentOperation中的常量
		 */
		public static function set buildingCurrOperation(value:String):void
		{
			if(_buildingCurrOperation==BuildingOperation.MOVE){ 
				//如果原来是move,则将原来的建筑还原
				GameWorld.instance.moveFail();
			}
			_buildingCurrOperation = value;
			switch(value){
				case BuildingOperation.BUY:
				case BuildingOperation.NONE:
					MouseManager.instance.mouseStatus = MouseStatus.NONE ;
					GameWorld.instance.clearTopScene() ;
					break ;
				case BuildingOperation.MOVE:
					MouseManager.instance.mouseStatus = MouseStatus.MOVE_BUILDING ;
					break ;
				case BuildingOperation.STASH:
					MouseManager.instance.mouseStatus = MouseStatus.STASH_BUILDING ;
					break ;
				case BuildingOperation.SELL:
					MouseManager.instance.mouseStatus = MouseStatus.SELL_BUILDING ;
					break ;
				case BuildingOperation.ROTATE:
					MouseManager.instance.mouseStatus = MouseStatus.ROTATE_BUILDING ;
					break ;
			}
		}
		/** 当前对建筑的操作  */
		public static function get buildingCurrOperation():String
		{
			return _buildingCurrOperation;
		}
		
		/** 是否是管理员 */
		public static var isAdmin:Boolean;
		
		/** 系统配置 */
		public static var config:ConfigBaseVO ;
		
		/** 当前的地图 */
		public static var currentMapId:String = "MAP_01";
		
		/** 是否在自己的村庄*/
		public static var isHome:Boolean = true ;
		
		
		
		/** 当前用户的uid*/
		public static var me_uid:String ;
	}
}
package comm
{
	import enums.BuildingCurrentOperation;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import map.elements.BuildingBase;
	
	import utils.MouseManager;
	
	import views.icon.MoveIconBitmapData;
	import views.icon.RotateIconBitmapData;
	import views.icon.SellIconBitmapData;
	import views.icon.StashIconBitmapData;

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
			_buildingCurrOperation = value;
			switch(value){
				case BuildingCurrentOperation.ADD:
				case BuildingCurrentOperation.NONE:
					MouseManager.instance.removeMouseIcon();
					break ;
				case BuildingCurrentOperation.MOVE:
					MouseManager.instance.addMouseIcon( new Bitmap( new MoveIconBitmapData ));
					break ;
				case BuildingCurrentOperation.STASH:
					MouseManager.instance.addMouseIcon( new Bitmap( new StashIconBitmapData ));
					break ;
				case BuildingCurrentOperation.SELL:
					MouseManager.instance.addMouseIcon( new Bitmap( new SellIconBitmapData ));
					break ;
				case BuildingCurrentOperation.ROTATE:
					MouseManager.instance.addMouseIcon( new Bitmap( new RotateIconBitmapData ));
					break ;
			}
		}
		/** 当前对建筑的操作  */
		public static function get buildingCurrOperation():String
		{
			return _buildingCurrOperation;
		}
		//********************************************************************//
		
		
		/**
		 * 鼠标在哪个上面 
		 */		
		public static var mouseBuilding:BuildingBase ; 
		
		/**
		 * 坐标0点 
		 */		
		public static const zeroPoint:Point = new Point();

	

	}
}
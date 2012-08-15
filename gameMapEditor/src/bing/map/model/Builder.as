package bing.map.model
{
	import flash.display.Bitmap;
	import flash.geom.Point;

	/**
	 * 建筑 
	 * @author zhouzhanglin
	 * 
	 */	
	public class Builder
	{
		private var _location:Point = null ;//位置，为地图坐标
		private var _id:String = ""; //格式为1_1，第一个1为类型，第二个1为子图片


		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get location():Point
		{
			return _location;
		}

		public function set location(value:Point):void
		{
			_location = value;
		}

		/**
		 * 建筑模型 
		 * @param id 建筑的ID 。格式为1_1
		 * @param location 位置
		 */		
		public function Builder(id:String , location:Point ){
			this.id = id;
			this.location = location;
		}
	}
}
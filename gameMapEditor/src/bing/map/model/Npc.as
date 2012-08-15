package bing.map.model
{
	import flash.geom.Point;
	/**
	 * npc模型类 
	 * @author zhouzhanglin
	 * @date 2010/10/5
	 */	
	public class Npc
	{
		private var _location:Point = null ;//位置，为地图坐标
		private var _id:String = ""; //地图编辑器中的npc的id，相同的npc，此id是相同的
		/** 自己填写的npc - ID  , 相同的npc的此id也不同，至少一个地图上会不同 */
		public var npcId:int = 0;
		/** npc的名字 */
		public var npcName:String = "";
		/** 点击npc后要打开的面板，此面板的名称 */
		public var npcPanel:String ="";

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
		 * NPC构造函数 
		 * @param id ID,格式为1,2,3
		 * @param loc 地图坐标位置
		 */		
		public function Npc(id:String,loc:Point) :void {
			this.id=id;
			this.location=loc;
		}
	}
}
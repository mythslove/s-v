package bing.map.model
{
	/**
	 * 传输区 
	 * @author zhouzhanglin
	 * 
	 */	
	public class Transport
	{
		
		public function Transport( tempLoc:String , isShow:Boolean ){
			this.tempLoc = tempLoc ;
			this.isShow = isShow;
		}
		
		/**
		 * 传送区的坐标，格式为x-y的地图坐标 
		 */		
		public var tempLoc:String = "";
		/**
		 * 是否在游戏时的场景上显示 
		 */		
		public var isShow:Boolean = false ;
		/**
		 *  下一个地图的ID
		 */		
		public var nextMapId:int = 0;
		/**
		 * 下一个地图的坐标，格式x-y 
		 */		
		public var nextMapLoc:String = "";
		/**
		 * 出生时的方向 
		 */		
		public var direction:int = 1;
	}
}
package local.model.buildings.vos
{
	/**
	 * 游戏所有建筑基础VO基类 
	 * @author zzhanglin
	 */	
	public class BaseBuildingVO
	{
		/** 建筑基础VO的id*/
		public var baseId:String ;
		
		/** 名称或标题 */
		public var name:String ;
		
		/** 资源的id */
		public var resId:String ;
		
		/** 别名，类名 */
		public var alias:String ;
		
		/**  npc或英雄是否可以从上面走，0为不可走，1为可以走  */
		public var walkable:int ;
		
		/** 在哪一层，为LayerType的常量*/
		public var layer:int ;
		
		/**对建筑的描述信息*/
		public var description:String ;
		
		/** 占据的网格数*/
		public var xSpan:int ;
		/** 占据的网格数*/
		public var zSpan:int ;
		
		/** 建筑的类型 */
		public var type:String ;
		
		/** 修建获得的经验 */
		public var buildEarnExp:int ;
		
		/** 变化的繁荣度 */
		public var rank:int ;
		
		/** 步骤数 */
		public var step:int ;
		
		/** 修建完成需要的材料 , 多个，key为pickupId , value为数量*/
		public var materials:Object ;
		
		//在哪个文件夹
		protected var _file:String = "building";
		
		
		protected var _url:String ;
		/** 资源的路径 */
		public function get url():String
		{
			if(!_url) _url="res/"+_file+"/"+resId+".swf";
			return _url ;
		}
		
		protected var _thumb:String ;
		/** 缩略图位置*/
		public function get thumb():String
		{
			if(!_thumb) _thumb="res/"+_file+"/"+alias+"Thumb.png";
			return _thumb ;
		}
	}
}
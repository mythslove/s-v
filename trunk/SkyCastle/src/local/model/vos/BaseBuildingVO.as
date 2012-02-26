package local.model.vos
{
	/**
	 * 建筑基础VO 
	 * @author zzhanglin
	 */	
	public class BaseBuildingVO
	{
		/** 建筑基础VO的id*/
		public var baseId:String ;
		
		/** 名称或标题 */
		public var name:String ;
		
		/** 别名，类名 */
		public var alias:String ;
		
		/** 是否还可以在此建筑上面修新的建筑 */
		public var onBuildAble:int ;
		
		/**  npc或英雄是否可以从上面走  */
		public var walkable:int ;
		
		/** 在哪一层，为LayerType的常量*/
		public var layer:int ;
		
		/**对建筑的描述信息*/
		public var description:String ;
		
		/** 占据的网格数*/
		public var xSpan:int ;
		/** 占据的网格数*/
		public var zSpan:int ;
		
		/** 最大的等级，可以升到多少级，默认为1*/
		public var maxLevel:int ;
	}
}
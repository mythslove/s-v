package local.model.buildings.vos
{
	import local.enum.BuildingType;

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
		
		/** 最大的等级，可以升到多少级，默认为1*/
		public var maxLevel:int ;
		
		/** 资源的路径 */
		public var url:String ;
		
		/** 缩略图位置*/
		public var thumb:String ;
		
		/** 建筑的类型 */
		public var type:String ;
		
		/** 修建获得经验 */
		public var buildEarnExp:int ;
		
		/** 是否是基本的建筑，基本建筑包括石头，磐石，树*/
		public function isBasicBuilding():Boolean
		{
			if(type==BuildingType.DEC_ROCK || type==BuildingType.DEC_STONE || type==BuildingType.DEC_TREE){
				return true ;
			}
			return false ;
		}
	}
}
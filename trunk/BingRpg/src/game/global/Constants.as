package game.global
{
	public class Constants
	{
		/**  地图数据类型：0为可行，1为碰撞，2为遮罩 */		
		public static const MAPDATA_TYPE_ROAD:int = 0 ;
		public static const MAPDATA_TYPE_IMPACT:int =1 ;
		public static const MAPDATA_TYPE_MASK:int =2 ;
		
		/** 寻路方式 */
		public static const SEARCH_ROAD_TYPE_MESH:int = 1 ; //网格寻路
		public static const SEARCH_ROAD_TYPE_ASTAR:int = 2 ; //astar寻路1
		public static const SEARCH_ROAD_TYPE_ASTAR1:int = 3 ; //astar寻路2，只寻当前屏幕的
		
		
		public static const NPC_NPCTYPE_STAND:int =1 ; //只站立
		public static const NPC_NPCTYPE_RUN:int =2 ; //可走动的
		public static const NPC_NPCTYPE_FIGHT:int =3 ; //可攻击的
	}
}
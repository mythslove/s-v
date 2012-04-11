package local.enum
{
	/**
	 * itemType
	 * 建筑的类型分为大类型和小类型 
	 * @author zzhanglin
	 */	
	public class ItemType
	{
		
		/**
		 * 大类：建筑 ，对应的类为Architecture
		 */		
		public static const BUILDING:String = "building"; 
		/** 建筑：房子 ，对应的类为House */
		public static const BUILDING_HOUSE:String = "house" ;
		/** 建筑：工厂，对应的类为Factory  */
		public static const BUILDING_FACTORY:String = "factory" ;
		
		
		/**
		 * 大类：装饰 
		 */		
		public static const DECORATION:String = "decoration";
		/** 装饰：树，树藤*/
		public static const DEC_TREE:String = "tree" ;
		/** 装饰：石头 */
		public static const DEC_STONE:String = "stone" ;
		/** 装饰：磐石，岩石 */
		public static const DEC_ROCK:String = "rock" ;
		/** 装饰：路，草坪，水渠 */
		public static const DEC_ROAD:String = "road" ;
		
		/**
		 * 大类：种植 
		 */		
		public static const PLANT:String = "plant";
		/** 种植：土地 */
		public static const PLANT_LAND:String = "land" ;
		/** 种植：农作物*/
		public static const PLANT_CROP:String = "crop" ;
		
		
		/** 大类：人*/
		public static const CHACTERS:String = "character" ;
		
		/**  动物  */		
		public static const ANIMAIL:String = "animal";
		
		/**
		 * 获得大的类型 
		 */		
		public static function getSumType( type:String ):String 
		{
			if(type==BUILDING || type==BUILDING_HOUSE|| type==BUILDING_FACTORY){
				return BUILDING;
			}else if( type==DECORATION || type==DEC_ROAD){ // || type==DEC_TREE|| type==DEC_STONE || type==DEC_ROCK 
				return DECORATION ;
			}else if(type==PLANT|| type==PLANT_LAND|| type==PLANT_CROP){
				return PLANT ;
			}else if(type==ANIMAIL){
				return ANIMAIL ;
			}
			return CHACTERS ;
		}
	}
}
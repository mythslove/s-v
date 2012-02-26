package local.enum
{
	/**
	 * 资源对象应该在游戏中的哪个层次 
	 * 地面层主要是水渠，草坪，路
	 * 建筑层主要是房子，工厂，装饰，门等。
	 * 天空层主要是云
	 * @author zzhanglin
	 */	
	public class LayerType
	{
		/**
		 * 地面层 
		 */		
		public static const GROUND:int = 1;
		
		/**
		 * 建筑层 
		 */		
		public static const BUILDING:int = 2 ;
		
		/**
		 * 天空层 
		 */		
		public static const SKY:int = 3;
	}
}
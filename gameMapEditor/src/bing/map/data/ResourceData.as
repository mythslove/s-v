package bing.map.data
{
	import flash.display.Bitmap;

	/**
	 * 资源的存储 
	 * @author zhouzhanglin
	 */	
	public class ResourceData
	{
		/** 建筑配置文件 */
		public static var buildConfig:XML = null ;
		
		/** npc配置文件 */
		public static var npcConfig:XML = null ;
		
		/**
		 * 通过建筑的类型ID和ID ，获得此建筑的图片路径
		 * @param typeId 建筑类型ID和id的结合 
		 * @return 图片路径
		 */		
		public static function getBuildPathByTypeIdAndId(typeAndID:String ):String{
			return buildConfig..img.(@id==typeAndID).@src;
		}
		
		/**
		 * 通过NPC的ID，获得NPC的图片的路径 
		 * @param id NPC的ID
		 * @return 图片路径
		 */		
		public static function getNpcPathById(id:String):String{
			return npcConfig.img.(@id==id).@src ;
		}
	}
}
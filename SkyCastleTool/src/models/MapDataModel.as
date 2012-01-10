package models
{
	import bing.ds.HashMap;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * 地图数据 
	 * @author zhouzhanglin
	 */	
	public class MapDataModel
	{
		private static var _instance:MapDataModel;
		public static function get instance():MapDataModel
		{
			if(!_instance) _instance = new MapDataModel();
			return _instance ;
		}
		//=====================================
		
		/**
		 *  建筑不能放的地方
		 */		
		public var forbiddenHash:Dictionary = new Dictionary();
		/**
		 * 英雄不能走的地方
		 */		
		public var impactHash:HashMap = new HashMap();
		
		/**
		 *  添加建筑不能放的地方
		 * @param nodeX
		 * @param nodeY
		 * @param rho
		 */		
		public function addForbidden( nodeX:int , nodeY:int , rho:DisplayObject ):void
		{
			if(!forbiddenHash[nodeX+"-"+nodeY] )
			{
				forbiddenHash[nodeX+"-"+nodeY] = rho ;
			}
		}
		
		/**
		 *  删除建筑不能放的地方
		 * @param nodeX
		 * @param nodeY
		 */		
		public function deleteForbidden( nodeX:int , nodeY:int ):DisplayObject
		{
			return deleteHash(nodeX,nodeY,forbiddenHash);
		}
		
		/**
		 *  添加英雄不能走的地方
		 * @param nodeX
		 * @param nodeY
		 * @param rho
		 */		
		public function addImpact( nodeX:int , nodeY:int , rho:DisplayObject ):void
		{
			if(!impactHash.containsKey(nodeX+"-"+nodeY)  )
			{
				impactHash.put( nodeX+"-"+nodeY ,rho);
			}
		}
		
		/**
		 *  删除英雄不能走的地方
		 * @param nodeX
		 * @param nodeY
		 */		
		public function deleteImpact( nodeX:int , nodeY:int ):DisplayObject
		{
			var rho:DisplayObject = impactHash.getValue(nodeX+"-"+nodeY) as DisplayObject;
			impactHash.remove( nodeX+"-"+nodeY);
			return rho ;
		}
		
		private function deleteHash( nodeX:int , nodeY:int , hash:Dictionary ):DisplayObject
		{
			if(hash[nodeX+"-"+nodeY] )
			{
				var rho:DisplayObject = hash[nodeX+"-"+nodeY] as DisplayObject ;
				delete hash[nodeX+"-"+nodeY];
				return rho;
			}
			return null;
		}
	}
}
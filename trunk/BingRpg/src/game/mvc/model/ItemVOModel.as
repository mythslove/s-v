package game.mvc.model
{
	import bing.ds.HashMap;
	import bing.utils.XMLAnalysis;
	
	import game.mvc.base.GameModel;
	import game.mvc.model.vo.ItemVO;
	import game.mvc.model.vo.MagicVO;
	import game.mvc.model.vo.NpcVO;

	/**
	 * 所有的ItemVO,  npcVO数据缓存区 
	 * @author zzhanglin
	 */	
	public class ItemVOModel extends GameModel
	{
		private static var _instance:ItemVOModel;
		public static function get instance():ItemVOModel
		{
			if(!_instance) _instance = new ItemVOModel();
			return _instance ;
		}
		//====================================
		
		//所有的itemVO , npcVO
		private var _itemVOHash:HashMap = new HashMap();
		
		/**
		 * 解析游戏主配置文件
		 */		
		public function parseConfigXML( configXML:XML ):void
		{
			var config:XML = configXML ;
			//itemVO
			var itemVOXML:* = config.items[0].itemVO ;
			var arr:Array = XMLAnalysis.createInstanceArrayByXMLList(itemVOXML,ItemVO,",");
			var len:int = arr.length;
			var itemVO:ItemVO ;
			for( var i:int = 0 ; i<len ; i++ )
			{
				itemVO = arr[i] as ItemVO;
				_itemVOHash.put( itemVO.faceId , itemVO );
			}
			//npcVO
			var npcVOXML:* = config.items[0].npcVO ;
			arr = XMLAnalysis.createInstanceArrayByXMLList(npcVOXML,NpcVO,",");
			len = arr.length ;
			var npcVO:NpcVO ;
			for( i = 0 ; i<len ; i++ )
			{
				npcVO = arr[i] ;
				_itemVOHash.put( npcVO.faceId , npcVO );
			}
			//magicVO
			var magicVOXML:* = config.items[0].magicVO ;
			arr = XMLAnalysis.createInstanceArrayByXMLList(magicVOXML,MagicVO,",");
			len = arr.length ;
			var magicVO:MagicVO ;
			for( i = 0 ; i<len ; i++ )
			{
				magicVO = arr[i] ;
				_itemVOHash.put( magicVO.faceId , magicVO );
			}
		}
		/**
		 * 通过itemId获得itemVO 
		 * @param faceId
		 * @return 
		 */		
		public function getItemVOByFaceId( faceId:int ):ItemVO
		{
			return _itemVOHash.getValue( faceId ) as ItemVO ;
		}
		
		/**
		 * 返回NPCVO 
		 * @param faceId
		 * @return 
		 */		
		public function getNpcVOByFaceId( faceId:int ):NpcVO
		{
			return _itemVOHash.getValue( faceId ) as NpcVO ;
		}
		
		/**
		 * 返回魔法，特效 MagicVO
		 * @param faceId
		 * @return 
		 */		
		public function getMagicVOByFaceId( faceId:int ):MagicVO
		{
			return _itemVOHash.getValue( faceId ) as MagicVO ;
		}
	}
}
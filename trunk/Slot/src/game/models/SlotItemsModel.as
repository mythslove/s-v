package game.models
{
	import bing.utils.XMLAnalysis;
	
	import game.models.vos.SlotItemVO;
	
	public class SlotItemsModel
	{
		private static var _instance:SlotItemsModel;
		public static function get  instance():SlotItemsModel
		{
			if(!_instance) _instance = new SlotItemsModel();
			return _instance ;
		}

		//----------------------------------------------------------------
		
		public var slotItemVOs:Vector.<SlotItemVO> ;
		
		public function parseConfig( config:XML ):void
		{
			var arr:Array = XMLAnalysis.createInstanceArrayByXMLList(config.gamelist.item ,SlotItemVO);
			slotItemVOs = Vector.<SlotItemVO>(arr);
		}
	}
}
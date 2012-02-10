package game.models
{
	import bing.utils.XMLAnalysis;
	
	import game.models.vos.SlotItemVO;
	
	public class SlotItemModel
	{
		private static var _instance:SlotItemModel;
		public static function get  instance():SlotItemModel
		{
			if(!_instance) _instance = new SlotItemModel();
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
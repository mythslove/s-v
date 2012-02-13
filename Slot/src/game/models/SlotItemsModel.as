package game.models
{
	import bing.utils.XMLAnalysis;
	
	import flash.events.EventDispatcher;
	
	import game.models.vos.SlotItemVO;
	import game.models.vos.SlotVO;
	
	public class SlotItemsModel extends EventDispatcher
	{
		private static var _instance:SlotItemsModel;
		public static function get  instance():SlotItemsModel
		{
			if(!_instance) _instance = new SlotItemsModel();
			return _instance ;
		}
		//----------------------------------------------------------------
		
		/** 所有的SlotItemVO */
		public var slotItemVOs:Vector.<SlotItemVO> ;
		
		/** 当前正在玩的SlotItemVO */
		public var currentItem:SlotItemVO ;
		
		/** 当前正在玩的SlotVO */
		public var currentSlot:SlotVO ;
		
		/**
		 * 解析slotItemVO部分的配置信息
		 * @param config
		 */		
		public function parseConfig( config:XML ):void
		{
			var arr:Array = XMLAnalysis.createInstanceArrayByXMLList(config.gamelist.item ,SlotItemVO);
			slotItemVOs = Vector.<SlotItemVO>(arr);
		}
		
		public function createSlotById( id:int ):void
		{
			for each(var itemVO:SlotItemVO in slotItemVOs)
			{
				
			}
		}
	}
}
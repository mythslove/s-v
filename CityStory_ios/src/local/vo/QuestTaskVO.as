package local.vo
{
	import local.enum.QuestType;
	import local.model.BuildingModel;
	import local.model.PlayerModel;
	import local.model.ShopModel;
	import local.util.QuestUtil;

	public class QuestTaskVO
	{
		public var sum:int=1 ; //总共需要多少个
		public var title:String ="" ; //标题
		public var info:String ="" ;
		public var skipCash:int ; //跳过这个任务需要的钱，如果为0，则不判断这个
		public var isSkipped:Boolean ; //是否跳过
		public var icon:String ; //icon图标
		
		public var questType:String="" ; //任务的类型
		public var sonType:String="" ; //子类型
		
		private var _current:int ; //当前多少个
		
		public var isSendAnalysis:Boolean ; //用于flurry统计
		
		/** 当前数量*/
		public function get current():int {
			if ( _current<0) _current = 0;
			return _current;
		}
		public function set current(value:int):void { _current = value; }
		
		
		/**
		 * 这个item是否完成 
		 * @return 
		 */		
		public function get isComplete():Boolean
		{
			if( (skipCash>0 && isSkipped) || current>=sum ) return true;
			return false ;
		}
		
		
		/**
		 * 初始化数据
		 */		
		public function init( acceptTime:Number ):void
		{
			if ( current>0 ) return ;
			switch( questType)
			{
				case QuestType.OWN_BD_BY_NAME:
					_current = BuildingModel.instance.getCountByName( questType , sonType ) ;
					break ;
				case QuestType.OWN_BD_BY_TYPE:
					_current = BuildingModel.instance.getCountByType( questType ) ;
					break ;
				case QuestType.HAVE_POP:
					_current = PlayerModel.instance.getCurrentPop() ;
					break ;
			}
		}
		
		
	}
}
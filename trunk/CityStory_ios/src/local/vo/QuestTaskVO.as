package local.vo
{
	import local.enum.QuestType;
	import local.model.BuildingModel;
	import local.model.ShopModel;

	public class QuestTaskVO
	{
		public var sum:int=1 ; //总共需要多少个
		public var title:String ="" ; //标题
		public var info:String ="" ;
		public var skipCash:int ; //跳过这个任务需要的钱，如果为0，则不判断这个
		public var isSkipped:Boolean ; //是否跳过
		
		public var questType:String="" ; //任务的类型
		public var sonType:String="" ; //子类型
		
		private var _current:int ; //当前多少个
		
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
		public function init( acceptTime:int ):void
		{
			if ( current>0 ) return ;
			var model:BuildingModel = BuildingModel.instance ;
			switch( questType)
			{
				case QuestType.OWN_BUILDING:
					if(sonType){
						var baseVO:BaseBuildingVO = ShopModel.instance.allBuildingHash[sonType] as BaseBuildingVO ;
						current = model.getCountByName( baseVO.type , baseVO.name ) ;
					}
					break ;
				case QuestType.OWN_TYPE:
					if(sonType){
						current = model.getCountByType( sonType ) ;
					}
					break ;
			}
		}
		
		
	}
}
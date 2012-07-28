package local.model.vos
{
	import local.enum.QuestType;
	import local.model.PlayerModel;
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.MapBuildingModel;

	public class QuestItemVO
	{
		public var itemId:int ; //id
		public var current:int ; //当前多少个
		public var sum:int=1 ; //总共需要多少个
		private var _title:String ; //标题
		public var skipCash:int ; //跳过这个任务需要的钱，如果为0，则不判断这个
		public var isSkipped:Boolean ; //是否跳过
		public var icon:String ; //icon名称
		
		public var questType:String ; //任务的类型
		public var sonType:String ; //子类型
		
		public function get title():String
		{
			if(sonType && _title.indexOf("<name>")>-1 ){
				return _title.replace("<name>",BaseBuildingVOModel.instance.getBaseVOById(sonType).name) ;
			}
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

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
			
			switch( questType)
			{
				case QuestType.OWN_BUILDING:
					if(sonType){
						current = MapBuildingModel.instance.getCountByBaseId( sonType );
					}
					break ;
				case QuestType.PLAYER_PROPERTY:
					if(sonType){
						current = PlayerModel.instance.getProperty( sonType );
					}
					break;
			}
		}
	}
}
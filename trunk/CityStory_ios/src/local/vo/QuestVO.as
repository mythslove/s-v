package local.vo
{
	import local.comm.GameData;

	public class QuestVO
	{
		public var qid:String ; //任务的id
		public var title:String ; //标题
		public var info:String ; //描述
		public var icon:String ; //icon名称 
		public var completeMsg:String ; //任务完成后的描述
		
		public var received:Boolean ;//是否已经拿过奖励了
		public var isComplete:Boolean; //是否完成任务
		public var acceptTime:Number ; //接受任务的时间
		public var tasks:Array ; //所有的QuestTaskVO 
		public var rewards:String; //完成任务后的奖励
		
		private var _isAccept:Boolean  ; //是否接受任务
		/** 是否接受了这个quest */
		public function get isAccept():Boolean { return _isAccept ; }
		/**
		 * 接受了就先初始化数据
		 */
		public function set isAccept(value:Boolean):void {
			_isAccept = value;
			if (value && tasks && tasks.length>0 ){
				var task:QuestTaskVO ;
				acceptTime = GameData.commDate.time; //接任务的时间
				var len:int = tasks.length ;
				for( var i:int  = 0 ; i<len ; ++i ){
					task = tasks[i] ;
					task.init( acceptTime ) ;
				}
			}
		}
		
		//=======获得此quest的条件===========
		
		public var restrictLevel:int =0; //要求玩家的等级
		
		public var restrictQuest:Array ; //前置quest的id
		
		
		
		
		
		
		/**
		 * 返回完成了的QuestTaskVO数量 
		 * @return 
		 */		
		public function getCompletedTaskCount():int
		{
			var count:int ;
			if(tasks){
				var len :int = tasks.length;
				for( var i:int = 0 ;  i<len ; ++i ) {
					if( (items[i] as QuestTaskVO).isComplete) {
						++count;
					}
				}
			}
			return count ;
		}
		
		
	}
}
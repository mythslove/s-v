package local.model.vos
{
	public class QuestVO
	{
		public var qid:int ; //任务的id
		public var title:String ; //标题
		public var info:String ; //描述
		public var icon:String ; //icon名称
		public var completeMsg:String ; //任务完成后的描述
		public var shareMsg:String ; //分享的信息
		public var shareTitle:String ; //分享的标题
		
		public var isAccept:Boolean; //是否接受任务
		public var isComplete:Boolean; //是否完成任务
		public var isReceived:Boolean ; //是否收到礼物
		public var acceptTime:Number ; //接受任务的时间
		public var items:Array ; //所有的QuestItemVO 
		public var rewardsVO:RewardsVO; //完成任务后的奖励
		
		/**
		 * 判断整个任务是否完成 
		 * @return 
		 */		
		public function checkComple():Boolean
		{
			if(isComplete) return true ;
			if(items){
				for each( var itemVO:QuestItemVO in items){
					if(!itemVO.isComplete) return false ;
				}
			}
			return false ;
		}
		
		
		public function updateCount( mainType:String , sonType:String="" , num:int = 1 ):Boolean
		{
			var isUpDate:Boolean = false ;
			if (items)
			{
				for each( var itemVO:QuestItemVO in items)
				{
					if( itemVO.questType== mainType)
					{
						if ( sonType )
						{
							if ( itemVO.sonType &&  itemVO.sonType==sonType){
								itemVO.current+=num;
								isUpDate = true ;
							}
						}
						else 
						{
							itemVO.current =num;
							isUpDate = true ;
						}	
					}
				}
			}
			return isUpDate;
		}
		
		/**
		 *  统计建筑方面的任务，主要是有建筑时间的限制
		 * @param mainType
		 * @param sonType
		 * @param num
		 * @param time 时间限制
		 * @return 
		 */		
		public function updateBuildingCount( mainType:String , sonType:String , time:Number , num:int = 1 ):Boolean
		{
			if( this.acceptTime>=time)
				return updateCount( mainType , sonType ,num ) ;
			return false ;
		}
		
		/**
		 * 统计建筑类型的数量 
		 * @param mainType
		 * @param sonType
		 * @return 
		 */		
		public function updateBuildingTypeCount( mainType:String , sonType:String ):Boolean
		{
			
		}
	}
}
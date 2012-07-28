package local.model.vos
{
	import local.enum.QuestType;
	import local.model.PlayerModel;
	import local.model.buildings.MapBuildingModel;

	public class QuestVO
	{
		public var qid:String ; //任务的id
		public var title:String ; //标题
		public var info:String ; //描述
		public var icon:String ; //icon名称 , resId为"quest"+_vo.icon
		public var completeMsg:String ; //任务完成后的描述
		public var requestId:String ;
		public var requireRank:int ; //rank要求，未到rank时，不能接受
		
		public var isAccept:Boolean; //是否接受任务
		public var isComplete:Boolean; //是否完成任务
		public var isReceived:Boolean ; //是否收到礼物
		public var acceptTime:Number ; //接受任务的时间
		public var items:Array ; //所有的QuestItemVO 
		public var rewardsVO:RewardsVO; //完成任务后的奖励
		
		/**
		 * 初始化任务 
		 */		
		public function init():void
		{
			for each( var itemVO:QuestItemVO in items){
				itemVO.init(acceptTime);
			}
		}
		
		/**
		 * 判断整个任务是否完成 
		 * @return 
		 */		
		public function checkComplete():Boolean
		{
			if(isComplete) return true ;
			for each( var itemVO:QuestItemVO in items){
				if(!itemVO.isComplete) return false ;
			}
			return false ;
		}
		
		/**
		 * 统计更新所有的quest 
		 * @param mainType
		 * @param sonType
		 * @param num
		 * @param time
		 * @return 
		 * 
		 */		
		public function update(mainType:String , sonType:String="" , num:int = 1 , time:Number=NaN):Boolean
		{
			var flag:Boolean ;
			switch(mainType)
			{
				case QuestType.PLAYER_PROPERTY : //玩家属性信息统计
				case QuestType.OWN_BUILDING:
					flag = setCount( mainType , sonType ); //直接赋值的
					break;
				default:
					flag = updateCount( mainType , sonType , num , time ); //叠加
					break ;
			}
			return flag ;
		}
		
		/**
		 * 统计 ，用于数值叠加的任务类型
		 * @param mainType 主类型
		 * @param sonType 子类型
		 * @param num 变化数量
		 * @param time 时间限制
		 * @return 
		 */		
		private function updateCount( mainType:String , sonType:String="" , num:int = 1 , time:Number=NaN ):Boolean
		{
			var isUpdate:Boolean ;
			for each( var itemVO:QuestItemVO in items)
			{
				if( itemVO.questType== mainType)
				{
					if( !time || acceptTime>=time) //如果没有时间限制，或者接受任务的时候大于建筑的建造时间
					{
						if ( sonType )
						{
							if ( itemVO.sonType &&  itemVO.sonType==sonType){
								itemVO.current+=num;
								isUpdate = true ;
							}
						}
						else 
						{
							itemVO.current += num;
							isUpdate = true ;
						}	
					}
				}
			}
			return isUpdate;
		}
		
		/**
		 * 用于直接赋值的任务
		 * @param mainType
		 * @param sonType
		 * @return 任务结果有否有变化
		 */		
		private function setCount(mainType:String , sonType:String ):Boolean
		{
			var isUpdate:Boolean ;
			for each( var itemVO:QuestItemVO in items)
			{
				if( itemVO.questType== mainType)
				{
					switch(mainType)
					{
						case QuestType.OWN_BUILDING:
							itemVO.current = MapBuildingModel.instance.getCountByBaseId( sonType );
							isUpdate=true;
							break ;
						case QuestType.PLAYER_PROPERTY:
							itemVO.current = PlayerModel.instance.getProperty( sonType );
							isUpdate = true ;
							break ;
					}
				}
			}
			return isUpdate;
		}
	}
}
package local.model
{
	import flash.utils.Dictionary;
	
	import local.vo.ComponentVO;

	/**
	 * Component数据 
	 * @author zhouzhanglin
	 * 
	 */	
	public class CompsModel
	{
		private static var _instance:CompsModel ;
		public static function get instance():CompsModel
		{
			if(!_instance) _instance = new CompsModel();
			return _instance;
		}
		//=======================================
		
		public static const MAX_COUNT:int = 50 ;
		
		/** 所有的components */
		public var allComps:Dictionary ;
		
		/** 我拥有的components*/
		public var myComps:Dictionary ;
		
		
		
		
		/**
		 * 通过名字来找到ComponentVO 
		 * @param name
		 * @return 
		 */		
		public function getCompByName( name:String ):ComponentVO
		{
			if(allComps && allComps.hasOwnProperty(name)){
				return allComps[name] ;
			}
			return null ;
		}
		
		
		/**
		 * 获取我的Compoent的数量
		 * @param name
		 * @return 
		 */		 
		public function getCompCount(name:String ):int
		{
			if(myComps && myComps.hasOwnProperty(name)){
				return myComps[name] ;
			}
			return 0 ;
		}
		
		
		/**
		 * 添加一个Component 
		 * @param name
		 * @param value
		 */		
		public function addComp( name:String , value:int ):void
		{
			if(!myComps) myComps = new Dictionary();
			
			if(myComps.hasOwnProperty(name)){
				myComps[name]+=value ;
				if( myComps[name]>MAX_COUNT ){
					myComps[name] = MAX_COUNT ;
				}
			}else if(allComps && allComps.hasOwnProperty(name)){
				myComps[name] = value ;
			}
//			QuestUtil.instance.handleOwn( QuestType.OWN_COMP , name );
		}
		
		/**
		 * 从我的comps中减去value个Componentt 
		 * @param name
		 * @param value
		 */		
		public function reduceComp( name:String , value:int ):void
		{
			if(myComps && myComps.hasOwnProperty(name)){
				myComps[name]-=value ;
				if(myComps[name]<0){
					myComps[name] = 0 ;
				}
//				QuestUtil.instance.handleOwn( QuestType.OWN_COMP , name );
			}
		}
	
	}
}
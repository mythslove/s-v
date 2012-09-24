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
		
		
		public function parseConfig( comps:Vector.<String>):void
		{
			
		}
		
		public function getCompByName( name:String ):ComponentVO
		{
			if(allComps && allComps.hasOwnProperty(name)){
				return allComps[name] ;
			}
			return null ;
		}
		
		
		public function getCompCount(name:String ):int
		{
			if(myComps && myComps.hasOwnProperty(name)){
				return myComps[name] ;
			}
			return 0 ;
		}
		
		
		
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
//			QuestModel.instance.handleTypeCount( QuestType.OWNPKUP , pickupAlias );
		}
		
		public function reduceComp( name:String , value:int ):void
		{
			if(myComps && myComps.hasOwnProperty(name)){
				myComps[name]-=value ;
				if(myComps[name]<0){
					myComps[name] = 0 ;
				}
//				QuestModel.instance.handleTypeCount( QuestType.OWNPKUP , pickupAlias );
			}
		}
	
	}
}
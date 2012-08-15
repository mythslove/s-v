package game.mvc.model
{
	import bing.animation.ActionVO;
	import bing.ds.HashMap;
	import bing.utils.XMLAnalysis;
	
	import game.mvc.base.GameModel;
	import game.mvc.model.vo.AniBaseVO;
	
	public class AniBaseModel extends GameModel
	{
		private static var _instance:AniBaseModel;
		public static function get instance():AniBaseModel
		{
			if(!_instance) _instance = new AniBaseModel();
			return _instance ;
		}
		//=====================================
		private var _aniBaseVOHash:HashMap = new HashMap(); 
		private var _config:XML ;
		
		public function parseConfigXML(configXML:XML):void
		{
			_config = configXML ;
			var aniBaseVOXML:* = _config.aniBaseVO[0].vo ;
			var aniBaseArray:Array = XMLAnalysis.createInstanceArrayByXMLList(aniBaseVOXML,AniBaseVO,",");
			const LEN:int = aniBaseArray.length;
			var aniBaseVO:AniBaseVO ;
			for ( var i:int=0 ; i <LEN ; i++)
			{
				aniBaseVO = aniBaseArray[i] as AniBaseVO ;
				var actionVOXML:* =  aniBaseVOXML[i].actionVO[0] ; 
				aniBaseVO.actions = new Vector.<ActionVO>(1,true);
				aniBaseVO.actions[0] = new ActionVO( String( actionVOXML.@actionName) , int( actionVOXML.@frameNum ) ); 
				_aniBaseVOHash.put( aniBaseVO.name , aniBaseVO );
			}
		}
		
		public function getAniBaseByName( name:String ):AniBaseVO 
		{
			return _aniBaseVOHash.getValue( name ) as AniBaseVO ;
		}
	}
}
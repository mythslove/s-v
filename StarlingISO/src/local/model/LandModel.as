package local.model
{
	import bing.iso.path.Grid;
	
	import flash.utils.Dictionary;
	
	import local.vo.ExpandVO;
	import local.vo.LandVO;

	/**
	 * 土地可用区域 
	 * @author zhouzhanglin
	 */	
	public class LandModel
	{
		private static var _instance:LandModel ;
		public static function get instance():LandModel
		{
			if(!_instance) _instance = new LandModel();
			return _instance;
		}
		//=======================================
		
		/** 所有的的地块的配置  */
		public var expands:Vector.<ExpandVO> ;
		
		/** 当前玩家拥有的地钱 */
		public var lands:Vector.<LandVO> ;
		
		/**如果当前没有Land，则初始化四块地**/
		public function initLands():void
		{
			lands = new Vector.<LandVO>();
			var vo:LandVO ;
			var count:int ;
			for( var i:int = 0 ; i <2 ; ++i ){
				for( var j:uint = 0 ; j<2 ; ++j ){
					vo= new LandVO();
					vo.nodeX = 7+i ;
					vo.nodeZ = 7+j ;
					lands[count] = vo ;
					++count ;
					if(count>4) return ;
				}
			}
		}
		
		/**
		 *  返回 可以扩地的块 
		 * @return  Dictionary key为nodeX-nodeZ value为1
		 */		
		public function getCanExpandLand():Dictionary
		{
			var mapGrid:Grid = MapGridDataModel.instance.mapGridData ; //不能修的地方
			var landGrid:Grid = MapGridDataModel.instance.landGridData ; //已经拥有的地块
			var dic:Dictionary = new Dictionary();
			var nodeX:int , nodeZ:int ;
			for each( var vo:LandVO in lands){
				nodeX = vo.nodeX-1;
				nodeZ = vo.nodeZ ;
				if(!dic[nodeX+"-"+nodeZ] &&
					!mapGrid.getNode(nodeX,nodeZ).walkable && !landGrid.getNode(nodeX,nodeZ).walkable)
				{
					dic[nodeX+"-"+nodeZ] = 1 ;
				}
				
				nodeX = vo.nodeX+1;
				nodeZ = vo.nodeZ ;
				if(!dic[nodeX+"-"+nodeZ] &&
					!mapGrid.getNode(nodeX,nodeZ).walkable && !landGrid.getNode(nodeX,nodeZ).walkable)
				{
					dic[nodeX+"-"+nodeZ] = 1 ;
				}
				
				nodeX = vo.nodeX;
				nodeZ = vo.nodeZ+1 ;
				if(!dic[nodeX+"-"+nodeZ] &&
					!mapGrid.getNode(nodeX,nodeZ).walkable && !landGrid.getNode(nodeX,nodeZ).walkable)
				{
					dic[nodeX+"-"+nodeZ] = 1 ;
				}
				
				nodeX = vo.nodeX;
				nodeZ = vo.nodeZ-1 ;
				if(!dic[nodeX+"-"+nodeZ] &&
					!mapGrid.getNode(nodeX,nodeZ).walkable && !landGrid.getNode(nodeX,nodeZ).walkable)
				{
					dic[nodeX+"-"+nodeZ] = 1 ;
				}
				
			}
			return dic ;
		}
	}
}
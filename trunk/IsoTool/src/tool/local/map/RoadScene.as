package tool.local.map
{
	import bing.ds.HashMap;
	import bing.iso.IsoScene;
	
	import flash.utils.Dictionary;
	
	import tool.comm.Setting;
	
	public class RoadScene extends IsoScene
	{
		private var _groundNodeHash:Dictionary = new Dictionary();
		
		public var L:String,R:String, U:String, B:String , M:String ;
		public var LU:String, LB:String,RU:String , RB:String ;
		public var LU_M:String, LB_M:String,RU_M:String,RB_M:String;
		public var LM:String , RM:String ;
		
		public function RoadScene()
		{
			super(Setting.SIZE , Setting.GRID_X , Setting.GRID_Z);
			
			L = "_L";
			R = "_R";
			U = "_U";
			B = "_B";
			M = "_M";
			LU = "_LU";
			LB = "_LB";
			RU = "_RU";
			RB = "_RB";
			LU_M = "_LU_M";
			LB_M = "_LB_M";
			RU_M = "_RU_M";
			RB_M = "_RB_M";
			LM = "_LM";
			RM = "_RM";
		}
		/**
		 *  添加建筑
		 * @param building
		 * @param updatePos
		 */		
		public function addBuilding( building:Road , updatePos:Boolean=true ):void
		{
			this.addIsoObject( building );
			_groundNodeHash[building.nodeX+"-"+building.nodeZ]=building;
			if(updatePos){
				updateUI(building);
			}
		}
		
		/**
		 * 移除建筑 
		 * @param buildingBase
		 */		
		public function removeBuilding( building:Road):void
		{
			this.removeIsoObject( building );
			delete _groundNodeHash[building.nodeX+"-"+building.nodeZ];
			updateUI(building);
		}
		
		/**
		 * 清除所有的 
		 */		
		public function clearBuildings():void
		{
			clear();
			_groundNodeHash = new Dictionary();
		}
		
		/**
		 * 更新方向 
		 * @param buildingBase
		 */		
		private function updateUI( building:Road ):void
		{
			for( var i:int = building.nodeX-1 ; i<building.nodeX+2 && i<Setting.GRID_X ; ++i )
			{
				for( var j:int = building.nodeZ-1 ;  j<building.nodeZ+2 && j<Setting.GRID_Z ; ++j )
				{
					if( _groundNodeHash[i+"-"+j])
					{
						updateRoadPosition(  _groundNodeHash[i+"-"+j] );
					}
				}
			}
		}
		
		//周围的四个位置
		private var _roundRoadHash:HashMap = new HashMap(); 
		//更新一个路的方向
		private function updateRoadPosition( building:Road ):void
		{
			var luBuilding:Road = _groundNodeHash[ (building.nodeX-1)+"-"+building.nodeZ];
			var ruBuilding:Road = _groundNodeHash[ building.nodeX+"-"+(building.nodeZ-1)];
			var lbBuilding:Road = _groundNodeHash[ building.nodeX+"-"+(building.nodeZ+1)];
			var rbBuilding:Road = _groundNodeHash[ (building.nodeX+1)+"-"+building.nodeZ];
			if( luBuilding ) _roundRoadHash.put( "POS_LU_M",true);
			if( ruBuilding ) _roundRoadHash.put( "POS_RU_M",true);
			if( lbBuilding ) _roundRoadHash.put( "POS_LB_M",true);
			if( rbBuilding ) _roundRoadHash.put( "POS_RB_M",true);
			
			const len:int = _roundRoadHash.size() ;
			if(len==0) (building as Object).updateUI(""); 
			else if(len==4) (building as Object).updateUI(M); 
			else if(len==3) check3(building);
			else if(len==2) check2(building);
			else if(len==1) check1(building);
			
			_roundRoadHash.clear();
		}
		
		private function check3(building:Object):void 
		{
			if(!_roundRoadHash.containsKey("POS_LU_M")) building.updateUI(LU_M);
			else if(!_roundRoadHash.containsKey("POS_RU_M")) building.updateUI(RU_M);
			else if(!_roundRoadHash.containsKey("POS_LB_M")) building.updateUI(LB_M);
			else if(!_roundRoadHash.containsKey("POS_RB_M")) building.updateUI(RB_M);
		}
		
		private function check2(building:Object):void
		{
			if(_roundRoadHash.containsKey("POS_LU_M") && _roundRoadHash.containsKey("POS_RU_M") ) building.updateUI(B);
			else if(_roundRoadHash.containsKey("POS_RU_M") && _roundRoadHash.containsKey("POS_RB_M")) building.updateUI(L);
			else if(_roundRoadHash.containsKey("POS_RB_M")&& _roundRoadHash.containsKey("POS_LB_M")) building.updateUI(U);
			else if(_roundRoadHash.containsKey("POS_LB_M")&& _roundRoadHash.containsKey("POS_LU_M")) building.updateUI(R);
			else if(_roundRoadHash.containsKey("POS_LU_M")&& _roundRoadHash.containsKey("POS_RB_M")) building.updateUI(LM);
			else if(_roundRoadHash.containsKey("POS_RU_M")&& _roundRoadHash.containsKey("POS_LB_M")) building.updateUI(RM);
		}
		
		private function check1(building:Object):void
		{
			var temp:String =_roundRoadHash.keys()[0].toString();
			if( temp=="POS_LU_M") building.updateUI(RB);
			else if( temp=="POS_RU_M") building.updateUI(LB);
			else if( temp=="POS_RB_M") building.updateUI(LU);
			else if( temp=="POS_LB_M") building.updateUI(RU);
		}
		
	}
}
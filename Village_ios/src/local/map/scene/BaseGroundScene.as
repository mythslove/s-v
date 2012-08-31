package local.map.scene
{
	import bing.ds.HashMap;
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import flash.utils.Dictionary;
	
	import local.map.item.BaseMapObject;
	
	public class BaseGroundScene extends IsoScene
	{
		protected var _groundNodeHash:Dictionary = new Dictionary();
		
		public var L:String,R:String, U:String, B:String , M:String ;
		public var LU:String, LB:String,RU:String , RB:String ;
		public var LU_M:String, LB_M:String,RU_M:String,RB_M:String;
		public var LM:String , RM:String ;
		
		public function BaseGroundScene(size:int, xSpan:int=1, zSpan:int=1)
		{
			super(size, xSpan, zSpan);
			mouseEnabled = false ;
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
		 * 更新所有的方向 
		 */		
		public function updateAllUI():void
		{
			for each( var obj:IsoObject in children){
				updateUI( obj as BaseMapObject);
			}
		}
		
		/**
		 * 更新一个对象的方向 
		 * @param BaseMapObject
		 */		
		public function updateUI( mapObj:BaseMapObject ):void
		{
			var baseGround:BaseMapObject ;
			for( var i:int = mapObj.nodeX-1 ; i<mapObj.nodeX+2 && i<gridData.numCols ; ++i )
			{
				for( var j:int = mapObj.nodeZ-1 ;  j<mapObj.nodeZ+2 && j<gridData.numRows ; ++j )
				{
					baseGround = _groundNodeHash[i+"-"+j] as BaseMapObject;
					if( baseGround )
					{
						updateRoadPosition(  _groundNodeHash[i+"-"+j] );
					}
				}
			}
		}
		
		//周围的四个位置
		private var _roundRoadHash:HashMap = new HashMap(); 
		//更新一个路的方向
		private function updateRoadPosition( mapObj:BaseMapObject ):void
		{
			var luBuilding:BaseMapObject = _groundNodeHash[ (mapObj.nodeX-1)+"-"+mapObj.nodeZ];
			var ruBuilding:BaseMapObject = _groundNodeHash[ mapObj.nodeX+"-"+(mapObj.nodeZ-1)];
			var lbBuilding:BaseMapObject = _groundNodeHash[ mapObj.nodeX+"-"+(mapObj.nodeZ+1)];
			var rbBuilding:BaseMapObject = _groundNodeHash[ (mapObj.nodeX+1)+"-"+mapObj.nodeZ];
			if( luBuilding&&luBuilding.name==mapObj.name ) _roundRoadHash.put( "POS_LU_M",true);
			if( ruBuilding&&ruBuilding.name==mapObj.name ) _roundRoadHash.put( "POS_RU_M",true);
			if( lbBuilding&&lbBuilding.name==mapObj.name ) _roundRoadHash.put( "POS_LB_M",true);
			if( rbBuilding&&rbBuilding.name==mapObj.name ) _roundRoadHash.put( "POS_RB_M",true);
			
			const len:int = _roundRoadHash.size() ;
			if(len==0) (mapObj as Object).updateUI(""); 
			else if(len==4) (mapObj as Object).updateUI(M); 
			else if(len==3) check3(mapObj);
			else if(len==2) check2(mapObj);
			else if(len==1) check1(mapObj);
			
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
		
		/**
		 * 清空这个村庄 
		 */		
		override public function clear():void
		{
			super.clear();
			_groundNodeHash = null ;
		}
	}
}
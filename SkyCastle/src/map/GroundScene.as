package map
{
	import bing.ds.HashMap;
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import comm.GameSetting;
	
	import enums.BuildingType;
	
	import flash.utils.Dictionary;
	
	import map.elements.Building;
	import map.elements.Road;
	
	import models.vos.BuildingVO;
	
	public class GroundScene extends IsoScene
	{
		private var _groundNodeHash:Dictionary = new Dictionary();
		
		
		public var L:String,R:String, U:String, B:String , M:String ;
		public var LU:String, LB:String,RU:String , RB:String ;
		public var LU_M:String, LB_M:String,RU_M:String,RB_M:String;
		public var LM:String , RM:String ;
		
		public function GroundScene()
		{
			super(GameSetting.GRID_SIZE);
			this.cacheAsBitmap = true ;
			mouseEnabled = false ;
			
			L = "L";
			R = "R";
			U = "U";
			B = "B";
			M = "M";
			LU = "LU";
			LB = "LB";
			RU = "RU";
			RB = "RB";
			LU_M = "LUM";
			LB_M = "LBM";
			RU_M = "RUM";
			RB_M = "RBM";
			LM = "LM";
			RM = "RM";
		}
		
		/**
		 * 添加一个建筑  
		 * @param dx 建筑的位置
		 * @param dy 
		 * @param buildingVO
		 * @param updateDirection 是否更新周围的方向
		 * @return 添加成功添加的建筑
		 */		
		public function addBuildingByVO( dx:Number , dz:Number , buildingVO:BuildingVO , updateDirection:Boolean=true ):Building
		{
			var obj:Building ;
			if( buildingVO.baseVO.type==BuildingType.ROAD){
				obj= new Road(buildingVO);
			}
			obj.x = dx;
			obj.z = dz;
			if( obj.getWalkable(this.gridData) )
			{
				this.addIsoObject( obj );
				obj.setWalkable( false , this.gridData );
				_groundNodeHash[obj.nodeX+"-"+obj.nodeZ]=obj;
				if(updateDirection)updateUI(obj);
				return obj;
			}
			return null ;
		}
		
		/**
		 * 添加建筑 
		 * @param building
		 */		
		public function addBuilding( building:Building , updateDirection:Boolean=true):Building
		{
			this.addIsoObject( building );
			building.setWalkable( false , this.gridData );
			_groundNodeHash[building.nodeX+"-"+building.nodeZ]=building;
			if(updateDirection)updateUI(building);
			return building;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeBuilding( building:Building):void
		{
			building.setWalkable( true , this.gridData );
			this.removeIsoObject( building );
			delete _groundNodeHash[building.nodeX+"-"+building.nodeZ];
		}
		
		/**
		 * 更新方向 
		 * @param building
		 */		
		private function updateUI( building:Building ):void
		{
			for( var i:int = building.nodeX-1 ; i<building.nodeX+2 && i<gridData.numCols ; ++i )
			{
				for( var j:int = building.nodeZ-1 ;  j<building.nodeZ+2 && j<gridData.numRows ; ++j )
				{
					if( _groundNodeHash[i+"-"+j])
					{
						updateRoadDirection(  _groundNodeHash[i+"-"+j] );
					}
				}
			}
		}
		
		//周围的四个位置
		private var _roundRoadHash:HashMap = new HashMap(); 
		//更新一个路的方向
		private function updateRoadDirection( building:Building ):void
		{
			var alias:String = building.buildingVO.baseVO.alias;
			var luBuilding:Building = _groundNodeHash[ (building.nodeX-1)+"-"+building.nodeZ];
			var ruBuilding:Building = _groundNodeHash[ building.nodeX+"-"+(building.nodeZ-1)];
			var lbBuilding:Building = _groundNodeHash[ building.nodeX+"-"+(building.nodeZ+1)];
			var rbBuilding:Building = _groundNodeHash[ (building.nodeX+1)+"-"+building.nodeZ];
			if( luBuilding&&luBuilding.buildingVO.baseVO.alias==alias ) _roundRoadHash.put( "POS_LU_M",true);
			if( ruBuilding&&ruBuilding.buildingVO.baseVO.alias==alias ) _roundRoadHash.put( "POS_RU_M",true);
			if( lbBuilding&&lbBuilding.buildingVO.baseVO.alias==alias ) _roundRoadHash.put( "POS_LB_M",true);
			if( rbBuilding&&rbBuilding.buildingVO.baseVO.alias==alias ) _roundRoadHash.put( "POS_RB_M",true);
			
			const len:int = _roundRoadHash.size() ;
			if(len==4) (building as Object).updateUI(M); 
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
		
		/**
		 * 清除数据和对象 
		 */		
		override public function clear():void
		{
			for each( var obj:IsoObject in children){
				obj.setWalkable( true , gridData );
			}
			super.clear();
		}
		
		override public function update():void{}
		
		override public function sortAll():void
		{
			this.children.sort( groundObjectSort );
			const LEN:int = this.numChildren;
			for( var i:int = 0 ; i< LEN ; ++i)
			{
				setChildIndex( children[i] , i );
			}
		}
		
		private function groundObjectSort( obj1:IsoObject , obj2:IsoObject ):int  
		{
			return obj1.depth-obj2.depth;
		}
	}
}
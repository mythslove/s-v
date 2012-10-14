package local.map
{
	import local.comm.GameData;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.item.BaseBuilding;
	import local.map.item.Road;
	import local.model.BuildingModel;
	import local.model.FriendVillageModel;
	import local.util.BuildingFactory;
	import local.vo.BuildingVO;
	
	import starling.display.*;
	import starling.events.Event;
	
	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld {
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//-----------------------------------------------------------------
		override protected function addedToStageHandler(e:Event):void{
			super.addedToStageHandler(e);
			GameWorld.instance.showBuildings();
			GameData.villageMode = VillageMode.NORMAL ;
		}
		
		public function goHome():void
		{
			
		}
		
		private var _mouseBuilding:BaseBuilding; //按下时点击到的建筑
//		private var _expandLandBtns:Vector.<ExpandLandButton> = new Vector.<ExpandLandButton>();//扩地按钮
		
		/** 
		 * 显示所有的建筑 
		 */
		public function showBuildings( isHome:Boolean=true ):void
		{
			if( isHome ) //显示自己的村庄
			{
				var myModel:BuildingModel = BuildingModel.instance ;
				if(myModel.expandBuilding){ //有扩地
					buildingScene.addBuilding( BuildingFactory.createBuildingByVO( myModel.expandBuilding ) , false , true );
//					visibleExpandSigns(false);
				}
				tempShowBuilding(myModel.basicTrees);
				tempShowBuilding(myModel.business);
				tempShowBuilding(myModel.industry);
				tempShowBuilding(myModel.community);
				tempShowBuilding(myModel.decorations);
				tempShowBuilding(myModel.homes);
				
				roadScene.sortAll();
				buildingScene.sortAll();
				if(iconScene.visible){
//					sortIcons();
				}
				run() ;
			}
			else //显示好友村庄
			{
				var friendModel:FriendVillageModel = FriendVillageModel.instance ;
				if(friendModel.expandBuilding){ //有扩地
					buildingScene.addBuilding( BuildingFactory.createBuildingByVO( friendModel.expandBuilding ) , false , false );
				}
				tempShowBuilding(friendModel.basicTrees);
				tempShowBuilding(friendModel.business);
				tempShowBuilding(friendModel.industry);
				tempShowBuilding(friendModel.community);
				tempShowBuilding(friendModel.decorations);
				tempShowBuilding(friendModel.homes);
				
				roadScene.sortAll();
				buildingScene.sortAll();
				
				friendModel.clear();
			}
		}
		private function tempShowBuilding( bvos:Vector.<BuildingVO>):void{
			if(bvos){
				var building:BaseBuilding ;
				for each( var bvo:BuildingVO in bvos){
					building = BuildingFactory.createBuildingByVO( bvo );
					if(bvo.baseVO.subClass==BuildingType.DECORATION_ROAD || bvo.baseVO.subClass==BuildingType.DECORATION_GROUND ){
						roadScene.addRoad( building as Road , false , false );
					}else{
						buildingScene.addBuilding( building , false , true );
					}
				}
			}
		}
	}
}
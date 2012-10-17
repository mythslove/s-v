package local.map
{
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.item.BaseBuilding;
	import local.map.item.Road;
	import local.model.BuildingModel;
	import local.model.FriendVillageModel;
	import local.util.BuildingFactory;
	import local.view.CenterViewLayer;
	import local.view.building.MoveBuildingButtons;
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
				
				
				
				
				
				//添加测试建筑
				var house:BaseBuilding ;
				var houses:Array = ["My House","Red Victorian House","PandaFood","Red Victorian House","Hermes Shop","Coco","Clutch","Higher"] ;
				var bvo:BuildingVO ;
				var bName:String ;
				for( var i:int = 7*4 ; i<7*4+8 ; ++i )
				{
					for( var j:int = 7*4 ; j<7*4+8 ; ++j )
					{
						if(Math.random()>0.25){
							var temp:int = (Math.random()*houses.length)>>0 ;
							bName = houses[temp] ;
							bvo = new BuildingVO();
							bvo.name = bName ;
							bvo.nodeX = i ;
							bvo.nodeZ = j ;
							house = new BaseBuilding(bvo);
							buildingScene.addBuilding( house,false,true);
						}
					}
				}

				
				
				
				
				
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
		
		
		/**
		 * 添加建筑到移动的的层上面，主要是从商店和收藏箱中的建筑 
		 * @param building
		 */		
		public function addBuildingToTopScene( building:BaseBuilding ):void
		{
			//放在当前屏幕中间
			var offsetY:Number = building.buildingVO.baseVO.span*0.5*_size;
			var p:Point = pixelPointToGrid( GameSetting.SCREEN_WIDTH*0.5 , GameSetting.SCREEN_HEIGHT*0.5 , 0,  offsetY );
			building.nodeX = p.x ;
			building.nodeZ = p.y ;
			
			topScene.clearAndDisposeChild();
			topScene.addIsoObject( building , false );
			building.drawBottomGrid();
			building.bottom.updateBuildingGridLayer();
			
			var moveBtns:MoveBuildingButtons  = MoveBuildingButtons.instance ;
			building.addChild( moveBtns );
			if(building.bottom.getWalkable()){
				if( !moveBtns.okBtn.enabled){
					moveBtns.okBtn.enabled = true  ;
				}
			}else{
				if( moveBtns.okBtn.enabled){
					moveBtns.okBtn.enabled = false ;
				}
			}
		}
		
	}
}
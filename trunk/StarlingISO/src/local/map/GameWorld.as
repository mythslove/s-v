package local.map
{
	import flash.geom.Point;
	
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.item.BaseBuilding;
	import local.map.item.Road;
	import local.model.BuildingModel;
	import local.model.FriendVillageModel;
	import local.util.BuildingFactory;
	import local.view.building.MoveBuildingButtons;
	import local.vo.BuildingVO;
	
	import starling.animation.Juggler;
	import starling.display.*;
	import starling.events.EnterFrameEvent;
	
	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld {
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//-----------------------------------------------------------------
		private var _juggle:Juggler = new Juggler() ;
//		private var _expandLandBtns:Vector.<ExpandLandButton> = new Vector.<ExpandLandButton>();//扩地按钮
		
		public function GameWorld()
		{
			super();
			addEventListener(EnterFrameEvent.ENTER_FRAME , onEnterFrame );
		}
		
		public function run():void{ 
			_juggle.add(this);
			touchable=true ;
		}
		public function stopRun():void{ 
			_juggle.remove(this);
			touchable=false ;
		}
		
		private function onEnterFrame( e:EnterFrameEvent ):void
		{
			if(runUpdate)	{
				buildingScene.advanceTime(e.passedTime) ;
			}
			if(x!=_endX) x += ( _endX-x)*_moveSpeed ; //缓动地图
			if(y!=_endY) y += (_endY-y)*_moveSpeed ;
		}
		
		
		public function goHome():void
		{
			
		}
		
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
				
				roadScene.updateAllUI();
				roadScene.sortAll();
				buildingScene.sortAll();
				if(iconScene.visible){
					sortIcons();
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
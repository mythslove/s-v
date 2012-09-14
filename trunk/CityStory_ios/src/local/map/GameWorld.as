package local.map
{
	import bing.iso.IsoObject;
	
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.item.BaseBuilding;
	import local.map.item.Road;
	import local.map.land.ExpandLandButton;
	import local.model.BuildingModel;
	import local.model.LandModel;
	import local.util.BuildingFactory;
	import local.view.building.EditorBuildingButtons;
	import local.view.building.MoveBuildingButtons;
	import local.vo.BuildingVO;

	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld {
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//-----------------------------------------------------------------
		private var _mouseBuilding:BaseBuilding; //按下时点击到的建筑
		
		/** 
		 * 显示所有的建筑 
		 */
		public function showBuildings():void
		{
			if( GameData.villageMode==VillageMode.VISIT) //显示好友村庄
			{
				
			}
			else //显示自己的村庄
			{
				var myModel:BuildingModel = BuildingModel.instance ;
				tempShowBuilding(myModel.basicTrees);
				tempShowBuilding(myModel.business);
				tempShowBuilding(myModel.industry);
				tempShowBuilding(myModel.community);
				tempShowBuilding(myModel.decorations);
				tempShowBuilding(myModel.homes);
			}
			roadScene.sortAll();
			buildingScene.sortAll();
			buildingScene.addMoveItems();
			if(iconScene.visible){
				sortIcons();
			}
			run() ;
		}
		private function tempShowBuilding( bvos:Vector.<BuildingVO>):void{
			if(bvos){
				var building:BaseBuilding ;
				for each( var bvo:BuildingVO in bvos){
					building = BuildingFactory.createBuildingByVO( bvo );
					if(bvo.baseVO.subClass==BuildingType.DECORATION_ROAD || bvo.baseVO.subClass==BuildingType.DECORATION_GROUND ){
						roadScene.addRoad( building as Road , false , false );
					}else{
						buildingScene.addBuilding( building , false );
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
			var p:Point = pixelPointToGrid( GameSetting.SCREEN_WIDTH*0.5 , GameSetting.SCREEN_HEIGHT*0.5,0,  offsetY , _size );
			building.nodeX = p.x ;
			building.nodeZ = p.y ;
			
			topScene.clearAndDisposeChild();
			topScene.addIsoObject( building , false );
			building.drawBottomGrid();
			building.bottom.updateBuildingGridLayer();
			
			building.addChild( MoveBuildingButtons.instance );
		}
		
		override protected function configListeners():void
		{
			super.configListeners() ;
			this.addEventListener(MouseEvent.MOUSE_DOWN , onMouseEvtHandler); 
		}
		
		protected function onMouseEvtHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch( e.type )
			{
				case MouseEvent.MOUSE_DOWN:
					_isGesture = false ;
					_isMove = false ;
					_moveSpeed = 0.36 ;
					_mouseDownPos.x = root.mouseX ;
					_mouseDownPos.y = root.mouseY ;
					_worldPos.x = x ;
					_worldPos.y = y ;
					if(e.target.parent is BaseBuilding){
						_mouseBuilding = e.target.parent as BaseBuilding ;
					}else{
						_mouseBuilding = null ;
					}
					addEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler); 
					addEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
					break ;
				case MouseEvent.MOUSE_MOVE:
					_isMove = true ;
					mouseChildren = false; 
					if(e.buttonDown && !_isGesture )
					{
						if( _mouseBuilding && _mouseBuilding.parent == topScene)  {
							//如果是编译状态，则移动建筑
							moveTopBuilding();
							if(EditorBuildingButtons.instance.parent){
								EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
							}
						}else {
							//如果不是编译状态，则移动地图
							_endX =  _worldPos.x + root.mouseX-_mouseDownPos.x ;
							_endY = _worldPos.y + root.mouseY-_mouseDownPos.y ;
							modifyEndPosition();
						}
					}
					break ;
				case MouseEvent.MOUSE_UP:
					if(_mouseBuilding && _mouseBuilding.parent == topScene)
					{
						if(GameData.villageMode == VillageMode.EDIT )
						{
							if(_mouseBuilding.bottom.getWalkable()){
								_mouseBuilding.addToSceneFromTopScene();
								_mouseBuilding = null ;
								currentSelected = null ;
								if(EditorBuildingButtons.instance.parent){
									EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
								}
							}else{
								_mouseBuilding.addChild( EditorBuildingButtons.instance );
							}
						}
					}
					else if(!_isGesture && !_isMove)
					{
						if(e.target.parent==_mouseBuilding)
						{
							if(e.target.parent!=currentSelected  ){
								if(currentSelected) currentSelected.flash(false);
								currentSelected = e.target.parent as BaseBuilding ;
								//移动到中间
								_endX =  GameSetting.SCREEN_WIDTH*0.5 - (sceneLayerOffsetX+currentSelected.screenX)*scaleX ;
								_endY = GameSetting.SCREEN_HEIGHT*0.5 - (sceneLayerOffsetY+currentSelected.screenY+currentSelected.buildingVO.baseVO.span*_size)*scaleY ;
								modifyEndPosition();
								_moveSpeed = 0.15 ;
							}
							currentSelected.onClick();
						}
						else if(currentSelected) 
						{
							if( currentSelected.parent==topScene && GameData.villageMode == VillageMode.EDIT && currentSelected.bottom.getWalkable()){
								currentSelected.addToSceneFromTopScene();
								_mouseBuilding=null;
								if(EditorBuildingButtons.instance.parent){
									EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
								}
							}
							currentSelected.flash(false);
							currentSelected = null ;
						}
						else if(GameData.villageMode==VillageMode.EXPAND)
						{
							//用点击区域来判断
							clickExpandButton( pixelPointToGrid(root.mouseX , root.mouseY,0,0,_size*4 ) );
						}
					}
					
				default :
					mouseChildren = true ;
					_isMove = false ;
					removeEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler); 
					removeEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
					break ;
			}
		}
		
		private function moveTopBuilding():void
		{
			var span:int = _mouseBuilding.buildingVO.baseVO.span ;
			var offsetY:Number = (span-1)*_size ;
			var p:Point = pixelPointToGrid(root.mouseX,root.mouseY , 0 ,offsetY , _size ); 
			if(_mouseBuilding.nodeX!=p.x || _mouseBuilding.nodeZ!=p.y) {
				_mouseBuilding.nodeX = p.x ;
				_mouseBuilding.nodeZ= p.y ;
				_mouseBuilding.bottom.updateBuildingGridLayer();
				
				if(GameData.villageMode==VillageMode.BUILDING_SHOP ||GameData.villageMode==VillageMode.BUILDING_STORAGE )
				{
					var moveBtns:MoveBuildingButtons  = MoveBuildingButtons.instance ;
					if(_mouseBuilding.bottom.getWalkable()){
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
		
		private function clickExpandButton( nodePoint:Point ):void
		{
			//判断此区域是否可以扩展
			for each( var obj:IsoObject in topScene.children){
				if( obj.nodeX==nodePoint.x && obj.nodeZ == nodePoint.y ){
					//可以扩展，弹出扩地提示
					trace("expand");
					break ;
				}
			}
		}
		
		/** 显示扩地状态 */
		public function showExpandState():void
		{
			topScene.clear();
			var lands:Dictionary = LandModel.instance.getCanExpandLand();
			var arr:Array ;
			var expandLandBtn:ExpandLandButton ;
			for( var key:String in lands)
			{
				arr = key.split("-");
				expandLandBtn = new ExpandLandButton();
				expandLandBtn.nodeX = int( arr[0] ) ;
				expandLandBtn.nodeZ = int (arr[1] ) ;
				topScene.addIsoObject( expandLandBtn , false );
			}
			topScene.sortAll() ;
			
			var obj:Object = {scale:scaleX};
			TweenLite.to( obj , 1 , {scale:GameSetting.minZoom , onUpdate:function():void{
				changeWorldScale( obj.scale , GameSetting.SCREEN_WIDTH*0.5 , GameSetting.SCREEN_HEIGHT*0.5 ) ;
			}});
		}
	}
}
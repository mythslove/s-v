package local.map
{
	import bing.iso.path.Grid;
	import bing.starling.component.Rhombus;
	import bing.starling.component.TileImage;
	import bing.starling.iso.SIsoScene;
	import bing.starling.iso.SIsoUtils;
	import bing.starling.iso.SIsoWorld;
	
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingStatus;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.cell.StatusIcon;
	import local.map.item.BaseBuilding;
	import local.map.item.BasicBuilding;
	import local.map.scene.*;
	import local.model.FriendVillageModel;
	import local.model.LandModel;
	import local.model.MapGridDataModel;
	import local.util.EmbedManager;
	import local.view.building.EditorBuildingButtons;
	import local.view.building.MoveBuildingButtons;
	import local.vo.BaseBuildingVO;
	import local.vo.BuildingVO;
	import local.vo.LandVO;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class BaseWorld extends SIsoWorld
	{
		public var landScene:SIsoScene; //地区域
		public var roadScene:RoadScene ; //道路，水层
		public var buildingScene:BuildingScene; //建筑层
		public var iconScene:SIsoScene ; //显示icon层
		public var topScene:SIsoScene ; //最上层,显示移动的建筑，以及显示一些特效动画
		public var effectScene:SIsoScene ; //特效层
		
		protected var _mouseBuilding:BaseBuilding ; //鼠标按下时的建筑
		protected var _mouseDownPos:Point = new Point(); //鼠标点击的位置
		protected var _worldPos:Point = new Point(); //鼠标点击时场景的世界位置
		public var currentSelected:BaseBuilding ; //当前选中的建筑
		protected var _basicVOs:Vector.<BaseBuildingVO> ; //所有的树的BaseBuildingVO
//		protected var _expandSigns:Vector.<ExpandSign> = new Vector.<ExpandSign>() ; //所有的扩地标志
		protected var _trees:Vector.<BasicBuilding> = new Vector.<BasicBuilding>();//所有的树
		
		/**===============用于地图移动和缩放=========================*/
		protected var _moveSpeed:Number =0.6 ; //移动的速度
		public var runUpdate:Boolean = true ; //是否运行建筑 的update
		protected var _endX:int ;
		protected var _endY:int;
		private var _touchFinger1:Point = new Point();
		private var _middle:Point = new Point();
		private var _isMove:Boolean ;
		
		public function BaseWorld()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE );
			
			this.x = (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			y=-1260*GameSetting.GAMESCALE ;
			_endX = x ;
			_endY = y ;
			addBackground();
		}
		
		private function addBackground():void
		{
			var offset:Number ;
			var map:Sprite = new Sprite();
			
			var tiledImg:TileImage = new TileImage(EmbedManager.createTextureByName("MAPBLOCK"));
			tiledImg.setSize( GameSetting.MAP_WIDTH,GameSetting.MAP_HEIGHT);
			map.addChild( tiledImg );
			
			var img:Image = EmbedManager.getMapImage("bottomsea1");
			img.y = GameSetting.MAP_HEIGHT-img.height ;
			map.addChild(img);
			offset = img.width ;
			
 			img = EmbedManager.getMapImage("bottomsea2");
			img.x = offset ; img.y = GameSetting.MAP_HEIGHT-img.height ;
			map.addChild(img);
			offset += img.width ;
			
			img = EmbedManager.getMapImage("bottomsea2");
			img.scaleX = -1 ; img.pivotX = img.width ;
			img.x = offset ; img.y = GameSetting.MAP_HEIGHT-img.height ;
			map.addChild(img);
			offset += img.width ;
			
			img =EmbedManager.getMapImage("bottomsea1");
			img.scaleX = -1 ; img.pivotX = img.width ;
			img.x = offset ; img.y = GameSetting.MAP_HEIGHT-img.height ;
			map.addChild(img);
			//=================================
			img = EmbedManager.getMapImage("heightmap1");
			img.y = 300*GameSetting.GAMESCALE ;
			map.addChild(img);
			offset = img.width ;
			
			img = EmbedManager.getMapImage("heightmap2");
			img. x=offset ; img.y = 215*GameSetting.GAMESCALE ;
			map.addChild(img);
			offset += img.width+50*GameSetting.GAMESCALE ;
			
			img =EmbedManager.getMapImage("rightheight1");
			img.x = offset ;
			map.addChild(img);
			
			//=========================
			offset = 100*GameSetting.GAMESCALE ;
			img = EmbedManager.getMapImage("rightsea1");
			img. x=GameSetting.MAP_WIDTH-img.width ; img.y = offset ;
			map.addChild(img);
			offset += img.height ;
			
			img = EmbedManager.getMapImage("rightsea2");
			img. x=GameSetting.MAP_WIDTH-img.width ; img.y = offset ;
			map.addChild(img);
			offset += img.height ;
			
			img = EmbedManager.getMapImage("water1");
			img. x = 2760*GameSetting.GAMESCALE ; img.y = 300*GameSetting.GAMESCALE ;
			map.addChild(img);
			//===============================
			img = EmbedManager.getMapImage("smallheightmap1");
			img.y = 1000*GameSetting.GAMESCALE ;
			map.addChild(img);
			
			img = EmbedManager.getMapImage("smallheightmap1");
			img.x = 3600*GameSetting.GAMESCALE ;  img.y = 1800*GameSetting.GAMESCALE ;
			map.addChild(img);
	
			map.flatten();
			this.setBackGround( map );
		}
	
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			//添加iso场景
			landScene = new SIsoScene(GameSetting.GRID_SIZE);
			landScene.touchable = false ;
			roadScene = new RoadScene();
			buildingScene = new BuildingScene();
			iconScene = new SIsoScene(GameSetting.GRID_SIZE);
			effectScene = new SIsoScene(GameSetting.GRID_SIZE);
			topScene = new SIsoScene(GameSetting.GRID_SIZE);
			addScene( landScene );
			addScene( roadScene );
			addScene(buildingScene);
			addScene(iconScene);
			addScene( effectScene );
			addScene(topScene);
			//显示地图网格
//			var gridScene:SIsoScene = new SIsoScene(GameSetting.GRID_SIZE);
//			gridScene.addChild( new SIsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE)) as SIsoGrid
//			gridScene.flatten() ;
//			this.addScene(gridScene);
			//初始化地图
			initMap();
			//添加侦听
			configListeners();
		}
		
		/** 初始化地图 */
		public function initMap( isHome:Boolean=true ):void
		{
			var i:int , j:int ;
			var gameGridData:Grid = MapGridDataModel.instance.gameGridData ;
			var maxX:int ,maxZ:int ;
			//地图数据
			this.panTo( MapGridDataModel.instance.mapPanX*GameSetting.GAMESCALE , 
				MapGridDataModel.instance.mapPanY*GameSetting.GAMESCALE );
			//添加地图区域
			if(!LandModel.instance.lands)  LandModel.instance.initLands();
			
			var lands:Vector.<LandVO> = isHome? LandModel.instance.lands : FriendVillageModel.instance.lands ;
			landScene.clearAndDisposeChild() ;
			for each( var landVO:LandVO in lands) {
				drawMapZoneByFill(landVO);
				MapGridDataModel.instance.landGridData.setWalkable( landVO.nodeX , landVO.nodeZ , true );
				//将GameGridData的数据设置为可行
				maxX = landVO.nodeX*4+4 ;
				maxZ = landVO.nodeZ*4+4 ;
				for( i = landVO.nodeX*4 ; i<maxX ; ++i){
					for( j = landVO.nodeZ*4 ; j<maxZ ; ++j){
						gameGridData.setWalkable( i , j , true ) ;
					}
				}
			}
			//添加扩地牌
//			if(isHome) addExpandSign();
			//随机添加树
			addTrees();
		}
		/** 用填充色画这个土地区域*/
		public function drawMapZoneByFill( landVO:LandVO ):void
		{
			var p:Vector3D = GameData.commVec ;
			p.setTo(0,0,0);
			var screenPos:Point = GameData.commPoint ;
			screenPos.setTo(0,0);
	
			p.x = landVO.nodeX; p.z=landVO.nodeZ;
			screenPos = SIsoUtils.isoToScreen(p);
			
			var landBlock:Rhombus = new Rhombus(GameSetting.GRID_SIZE*8,GameSetting.GRID_SIZE*4,0x97B425);
			landBlock.alpha = 0.6 ;
			landBlock.x = screenPos.x*_size*4 ;
			landBlock.y = screenPos.y*_size*4 
			landScene.addChild(landBlock);
		}
		
		private function addTrees():void
		{
			var i:int , j:int ;
			var gameGridData:Grid = MapGridDataModel.instance.gameGridData ;
			if(!_basicVOs){
				var basicVO:BaseBuildingVO ;
				_basicVOs = new Vector.<BaseBuildingVO>( 8 , true );
				for(i = 0 ; i<8 ; ++i ) {
					basicVO = new BaseBuildingVO();
					basicVO.name = "Basic_Tree"+( i+1 ) ; 
					basicVO.type = BuildingType.BASIC ;
					if(i<6) {
						basicVO.span = 1 ;
					}
					_basicVOs[i] = basicVO ;
				}
			}
			
			var basicBuild:BasicBuilding ;
			var bvo:BuildingVO ;
			var treeIndex:int ;
			var rate:Number = GameSetting.isIpad ? 0.92 : 0.945 ;
			for( i = 0 ; i<GameSetting.GRID_X ; ++i  ){
				for( j = 0 ; j<GameSetting.GRID_Z ;  ++j ){
					if( Math.random()>rate && !gameGridData.getNode(i,j).walkable &&
						MapGridDataModel.instance.mapGridData.getNode(i,j).walkable ){
						if(_trees.length>treeIndex)
						{
							basicBuild = _trees[treeIndex] ;
							basicBuild.buildingVO.nodeX = i ;
							basicBuild.buildingVO.nodeZ = j ;
							basicBuild.nodeX = i ;
							basicBuild.nodeZ = j ;
							buildingScene.addBuilding( basicBuild , false  );
						}
						else
						{
							var index:int = (Math.random()*8 )>>0 ;
							bvo = new BuildingVO();
							bvo.nodeX = i ; bvo.nodeZ = j ;
							bvo.baseVO = _basicVOs[index] ;
							bvo.name = _basicVOs[index].name ;
							basicBuild = new BasicBuilding(bvo ) ;
							basicBuild.touchable =  false ;
							buildingScene.addBuilding( basicBuild , false  );
							_trees.push( basicBuild );
						}
						++treeIndex ;
					}
				}
			}
		}
		
		/** 移除所有的树 */
		protected function removeTrees():void
		{
			if(_trees){
				for each( var basicBuilding:BasicBuilding in _trees){
					if(basicBuilding.parent==buildingScene){
						buildingScene.removeBuilding( basicBuilding );
					}
				}
			}
		}
		
		protected function configListeners():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouchedHandler); 
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheel );
		}
		
		
		private function onMouseWheel( e:MouseEvent ):void
		{
			e.stopPropagation();
			var value:Number = e.delta>0?1.2:0.92 ;
			changeWorldScale(value,e.stageX/Starling.contentScaleFactor , e.stageY/Starling.contentScaleFactor);
		}
		
		private function onTouchedHandler( e:TouchEvent ):void
		{
			if(e.touches.length==1)
			{
				var touch:Touch = e.getTouch(stage); 
				if(!touch) return ;
				
				var pos:Point = touch.getLocation(stage); 
				if(touch.phase==TouchPhase.BEGAN)
				{
					_moveSpeed = 0.6 ;
					_touchFinger1.x = pos.x ;
					_touchFinger1.y = pos.y ;
					_endX = x ;
					_endY = y ;
					_isMove = false ;
					if(touch.target.parent.parent is BaseBuilding){
						_mouseBuilding = touch.target.parent.parent as BaseBuilding ;
					}else{
						_mouseBuilding = null ;
					}
				}
				else if( touch.phase==TouchPhase.MOVED)
				{
					_isMove = true ;
					if( _mouseBuilding && _mouseBuilding.parent == topScene)  {
						//如果是编译状态，则移动建筑
						moveTopBuilding( pos.x,pos.y);
						if(EditorBuildingButtons.instance.parent){
							EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
						}
					}else {
						//如果不是编辑状态，则移动地图
						var offsetX:int =  _endX+touch.globalX-touch.previousGlobalX ;
						var offsetY:int =  _endY+touch.globalY-touch.previousGlobalY ;
						
						if(offsetX>0) offsetX=0 ;
						else if(offsetX<-GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH){
							offsetX = -GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH ;
						}
						if(offsetY>0) offsetY=0 ;
						else if(offsetY<-GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT){
							offsetY = -GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT ;
						}
						_endX = offsetX;
						_endY = offsetY ;
					}
				}
				else if( touch.phase == TouchPhase.ENDED)
				{
					if(_mouseBuilding && _mouseBuilding.parent == topScene)
					{
						if(GameData.villageMode == VillageMode.EDIT )
						{
							if(_mouseBuilding.bottom.getWalkable()){
								_mouseBuilding.addToWorldFromTopScene();
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
					else if(!_isMove)
					{
						if(touch.target.parent is StatusIcon)
						{
							if(currentSelected) currentSelected.flash(false);
							currentSelected = (touch.target.parent as StatusIcon).building ;
							currentSelected.onClick();
						}
//						else if(touch.target is ExpandSign)
//						{
//							if( !GameData.hasExpanding ){
//								GameData.villageMode = VillageMode.EXPAND ;
//							}else{
//								trace("已经有地在扩了");
//							}
//						}
						else if(_mouseBuilding && touch.target.parent.parent==_mouseBuilding)
						{
							if(touch.target.parent.parent!=currentSelected  ){
								if(currentSelected) currentSelected.flash(false);
								currentSelected = touch.target.parent.parent as BaseBuilding ;
								if( GameData.villageMode==VillageMode.VISIT ||
									(currentSelected.buildingVO.status!=BuildingStatus.PRODUCTION_COMPLETE && 
										currentSelected.buildingVO.status!=BuildingStatus.LACK_MATERIAL) )
								{
									moveToCenter( currentSelected ) ;
								}
							}
							//判断是不是在好友村庄
							if(GameData.villageMode!=VillageMode.VISIT){
								currentSelected.onClick();
							}else{
								currentSelected.flash(true);
							}
						}
						else if(currentSelected) 
						{
							if( currentSelected.parent==topScene && GameData.villageMode == VillageMode.EDIT && currentSelected.bottom.getWalkable()){
								currentSelected.addToWorldFromTopScene();
								_mouseBuilding=null;
								if(EditorBuildingButtons.instance.parent){
									EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
								}
							}
							currentSelected.flash(false);
							currentSelected = null ;
//							CenterViewLayer.instance.gameTip.hide() ; //隐藏gameTip
						}
						else if(GameData.villageMode==VillageMode.EXPAND)
						{
							//用点击区域来判断
//							clickExpandButton( pixelPointToGrid(root.mouseX , root.mouseY,0,0,_size*4 ) );
						}
						//隐藏gameTip
//						if( currentSelected && CenterViewLayer.instance.gameTip.currentBuilding!=currentSelected){
//							CenterViewLayer.instance.gameTip.hide() ;
//						}
					}
					
				}
			}
			else if(e.touches.length==2)
			{
				//放大缩小
				var touches:Vector.<Touch> = e.getTouches(stage);
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point  = new Point( touchA.globalX,touchA.globalY );
				var previousPosA:Point = new Point( touchA.previousGlobalX , touchA.previousGlobalY );
				var currentPosB:Point  = new Point( touchB.globalX,touchB.globalY );
				var previousPosB:Point = new Point( touchB.previousGlobalX , touchB.previousGlobalY );
				
				if(touchB.phase==TouchPhase.BEGAN){
					_middle.x = _touchFinger1.x+(previousPosB.x-_touchFinger1.x)*0.5 ;
					_middle.y = _touchFinger1.y+(previousPosB.y-_touchFinger1.y)*0.5 ;
				}
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				// scale
				var sizeDiff:Number = currentVector.length / previousVector.length;
				sizeDiff = sizeDiff>1 ? 1+(sizeDiff-1)*1.2 : 1-(1-sizeDiff)*1.2 ;
				changeWorldScale( sizeDiff , _middle.x , _middle.y );
				_isMove = true ;
			}
			else
			{
				_endX = x ;
				_endY = y ;
			}
		}
		
		//将building移动到屏幕中间
		private function moveToCenter( building:BaseBuilding):void
		{
			//移动到中间
			_endX =  GameSetting.SCREEN_WIDTH*0.5 - (sceneLayerOffsetX+building.screenX)*scaleX ;
			_endY = GameSetting.SCREEN_HEIGHT*0.5 - (sceneLayerOffsetY+building.screenY+building.buildingVO.baseVO.span*_size)*scaleY ;
			modifyEndPosition();
			_moveSpeed = 0.1 ;
		}
		
		private function moveTopBuilding( mouseX:Number , mouseY:Number ):void
		{
			var span:int = _mouseBuilding.buildingVO.baseVO.span ;
			var offsetY:Number = (span-1)*_size ;
			var p:Point = pixelPointToGrid(mouseX,mouseY , 0 ,offsetY ); 
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
		
		//================缩放地图=======================
		private var _zoomObj:Object = {"value":1};
		private var _zoomTween:TweenLite ;
		private var _zoomM:Matrix = new Matrix();
		private function changeWorldScale( value:Number , px:Number , py:Number , time:Number=0.2 ):void
		{
			if(scaleX*value>0.5 && scaleX*value<2.5 ) {
				var prevScale:Number = scaleX ;
				var prevX:Number =x , prevY:Number = y ;
				_zoomObj.value=1;
				if(_zoomTween){
					_zoomTween.kill() ;
					_zoomTween = null ;
				}
				_zoomTween = TweenLite.to( _zoomObj , time , { value:value , onUpdate:function():void
				{
					_zoomM.identity() ;
					_zoomM.scale(prevScale,prevScale);
					_zoomM.translate( prevX , prevY );
					_zoomM.tx -= px;
					_zoomM.ty -= py;
					_zoomM.scale(_zoomObj.value,_zoomObj.value);
					_zoomM.tx += px;
					_zoomM.ty += py;
					
					scaleX = _zoomM.a ;
					scaleY = _zoomM.d ;
					_endX = x = _zoomM.tx ;
					_endY = y = _zoomM.ty ;
					
					modifyEndPosition();
					changeIconSize();
				}} );
			}
			_endX = x;
			_endY = y ;
		}
		
		
		protected function changeIconSize():void
		{
			if(MoveBuildingButtons.instance.parent)	{
				MoveBuildingButtons.instance.scaleY =MoveBuildingButtons.instance.scaleX = 1/scaleX ;
			} else if(EditorBuildingButtons.instance.parent) {
				EditorBuildingButtons.instance.scaleY =EditorBuildingButtons.instance.scaleX = 1/scaleX ;
			}
			var obj:DisplayObject ;
			for( var i:int = 0 ; i <effectScene.numChildren ; ++i ){
				obj = effectScene.getChildAt(i) ;
				obj.scaleY = obj.scaleX = 1/scaleX ;
			}
		}
		
		private function modifyEndPosition():void{
			if(_endX>0) x = _endX=0 ;
			else if(_endX<-GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH){
				x = _endX = -GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH ;
			}
			if(_endY>0) y=_endY=0 ;
			else if(_endY<-GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT){
				y=_endY = -GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT ;
			}
		}
		
		/**
		 * 对建筑上面的icon标志进行深度排序 
		 */		
		public function sortIcons():void
		{
			var arr:Array = [];
			for( var i:int = 0 ; i<iconScene.numChildren ; ++i){
				arr.push( iconScene.getChildAt(i));
			}
			arr.sortOn("y",Array.CASEINSENSITIVE) ;
			for( i = arr.length-1 ; i>=0 ; --i){
				iconScene.setChildIndex( arr[i] ,i );
			}
		}
	}
}
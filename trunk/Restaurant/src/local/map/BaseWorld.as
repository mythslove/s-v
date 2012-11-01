package local.map
{
	import bing.starling.component.TileImage;
	import bing.starling.iso.SIsoScene;
	import bing.starling.iso.SIsoWorld;
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.ItemType;
	import local.enum.VillageMode;
	import local.map.item.BaseItem;
	import local.map.item.Wall;
	import local.map.scene.FloorScene;
	import local.map.scene.RoomScene;
	import local.map.scene.WallDecorScene;
	import local.map.scene.WallPaperScene;
	import local.model.MapGridDataModel;
	import local.model.PlayerModel;
	import local.util.EmbedManager;
	import local.vo.PlayerVO;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class BaseWorld extends SIsoWorld
	{
		private var _tileImg:TileImage ;
		
		public var wallScene:SIsoScene ; //墙层
		public var wallPaperScene:WallPaperScene ; //墙纸层
		public var wallDecorScene:WallDecorScene ; //墙装饰
		public var floorScene:FloorScene;//地板层
		public var roomScene:RoomScene ; //房间内部物品层
		public var iconScene:SIsoScene ; //显示icon层
		public var topScene:SIsoScene ; //最上层,显示移动的建筑，以及显示一些特效动画
		public var effectScene:SIsoScene ; //特效层
		
		
		protected var _mouseItem:BaseItem ; //鼠标按下时的Item
		protected var _mouseDownPos:Point = new Point(); //鼠标点击的位置
		protected var _worldPos:Point = new Point(); //鼠标点击时场景的世界位置
		public var currentSelected:BaseItem ; //当前选中的Item
		
		/**===============用于地图移动和缩放=========================*/
		protected var _moveSpeed:Number =0.5 ; //移动的速度
		public var runUpdate:Boolean = true ; //是否运行建筑 的update
		protected var _endX:int ;
		protected var _endY:int;
		private var _touchFinger1:Point = new Point();
		private var _middle:Point = new Point();
		private var _isMove:Boolean ;
		
		
		public function BaseWorld()
		{
			super( GameSetting.MAX_SIZE,GameSetting.MAX_SIZE,GameSetting.GRID_SIZE);
			_endX = x = (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			_endY = y = -100 ;
			this.panTo(GameSetting.MAP_WIDTH/2,300 );
			
			addBackground();
		}
		
		private function addBackground():void
		{
			var map:Sprite = new Sprite();
//			var quad:Quad = new Quad(GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT , 0x7DB643 , false );
//			map.addChild( quad );
			var tileBmd:Bitmap = new EmbedManager.BG_TILE() as Bitmap;
			_tileImg = new TileImage( Texture.fromBitmap(tileBmd,false));
			_tileImg.blendMode = BlendMode.NONE ;
			map.addChild( _tileImg );
			tileBmd.bitmapData.dispose();
			tileBmd = null ;
			
			var roads:Sprite = new Sprite();
			var img:Image = EmbedManager.getMapImage("BG_ROAD_2");
			img.x = 462 ;
			roads.addChild( img );
			
			img = EmbedManager.getMapImage("BG_ROAD_1");
			img.y = 184 ;
			roads.addChild( img );
			
			img = EmbedManager.getMapImage("BG_ROAD_3");
			img.x = 1024 ;
			img.y = 140 ;
			roads.addChild( img );
			
			roads.rotation = deg2rad(-26);
			roads.y = 500 ;
			roads.x = -350 ;
			map.addChild(roads);
			
			map.flatten();
			this.setBackGround( map );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			//添加场景层
			floorScene = new FloorScene();
			floorScene.touchable = false ;
			wallScene = new SIsoScene(GameSetting.GRID_SIZE , GameSetting.MAX_SIZE, GameSetting.MAX_SIZE );
			wallScene.touchable = false ;
			roomScene  = new RoomScene();
			wallPaperScene = new WallPaperScene();
			wallDecorScene = new WallDecorScene();
			iconScene = new SIsoScene(GameSetting.GRID_SIZE);
			effectScene = new SIsoScene(GameSetting.GRID_SIZE);
			effectScene.touchable = false ;
			topScene = new SIsoScene(GameSetting.GRID_SIZE);
			addScene( wallScene );
			addScene( wallPaperScene );
			addScene( wallDecorScene );
			addScene(floorScene);
			addScene(roomScene);
			addScene(iconScene);
			addScene( effectScene );
			addScene(topScene);
			
			//显示地图网格
//			var gridScene:SIsoScene = new SIsoScene(GameSetting.GRID_SIZE);
//			gridScene.addChild( new SIsoGrid(GameSetting.MAX_SIZE,GameSetting.MAX_SIZE,GameSetting.GRID_SIZE)) as SIsoGrid ;
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
			var player:PlayerVO = isHome? PlayerModel.instance.me : null ;
			GameSetting.MAP_HEIGHT -= (GameSetting.MAX_SIZE-player.mapSize)*GameSetting.GRID_SIZE ;
			_tileImg.setSize( GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT );
			addWalls( player );
		}
		
		protected function addWalls(player:PlayerVO):void
		{
			var wall:Wall ;
			for( var i:int = 0 ; i<player.mapSize ; ++ i){
				wall = new Wall();
				wall.nodeX = 0 ;
				wall.nodeZ = i ;
				wall.direction = 2 ;
				wallScene.addIsoObject( wall , false );
				MapGridDataModel.instance.wallNodeHash[wall.nodeX+"-"+wall.nodeZ+"-"+wall.direction] = wall ;
			}
			for( i = 0 ; i<player.mapSize ; ++ i){
				wall = new Wall();
				wall.nodeX = i ;
				wall.nodeZ = 0 ;
				wall.direction = 3 ;
				wallScene.addIsoObject( wall ,false );
				MapGridDataModel.instance.wallNodeHash[wall.nodeX+"-"+wall.nodeZ+"-"+wall.direction] = wall ;
			}
			wallScene.sortAll() ;
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
					if(touch.target.parent.parent is BaseItem){
						_mouseItem = touch.target.parent.parent as BaseItem ;
					}else{
						_mouseItem = null ;
					}
				}
				else if( touch.phase==TouchPhase.MOVED)
				{
					_isMove = true ;
					if( _mouseItem && _mouseItem.parent == topScene)  {
						//如果是编译状态，则移动建筑
						moveTopBuilding( pos.x,pos.y);
//						if(EditorBuildingButtons.instance.parent){
//							EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
//						}
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
						modifyEndPosition();
					}
				}
				else if( touch.phase == TouchPhase.ENDED)
				{
					if(_mouseItem && _mouseItem.parent == topScene)
					{
						if(GameData.villageMode == VillageMode.EDIT )
						{
							if(_mouseItem.bottom.getWalkable()){
								_mouseItem.addToWorldFromTopScene();
								_mouseItem = null ;
								currentSelected = null ;
//								if(EditorBuildingButtons.instance.parent){
//									EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
//								}
							}else{
//								_mouseItem.addChild( EditorBuildingButtons.instance );
							}
						}
					}
					else if(!_isMove)
					{
						if(_mouseItem && touch.target.parent.parent==_mouseItem)
						{
							if(touch.target.parent.parent!=currentSelected  ){
//								if(currentSelected) currentSelected.flash(false);
								currentSelected = touch.target.parent.parent as BaseItem ;
							}
							//判断是不是在好友村庄
							if(GameData.villageMode!=VillageMode.VISIT){
								currentSelected.onClick();
							}else{
//								currentSelected.flash(true);
							}
						}
						else if(currentSelected) 
						{
							if( currentSelected.parent==topScene && GameData.villageMode == VillageMode.EDIT && currentSelected.bottom.getWalkable()){
								currentSelected.addToWorldFromTopScene();
								_mouseItem=null;
//								if(EditorBuildingButtons.instance.parent){
//									EditorBuildingButtons.instance.parent.removeChild( EditorBuildingButtons.instance );
//								}
							}
//							currentSelected.flash(false);
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
				sizeDiff = sizeDiff>1 ? 1+(sizeDiff-1)*1.4 : 1-(1-sizeDiff)*1.4 ;
				changeWorldScale( sizeDiff , _middle.x , _middle.y );
				_isMove = true ;
			}
			else
			{
				_endX = x ;
				_endY = y ;
			}
		}
		
		private function moveTopBuilding( mouseX:Number , mouseY:Number ):void
		{
			var span:int = _mouseItem.itemVO.baseVO.xSpan ;
			var offsetY:Number = (span-1)*_size ;
			var p:Point = pixelPointToGrid(mouseX,mouseY , 0 ,offsetY ); 
			if(p.x<0) p.x = 0 ;
			if(p.y<0) p.y = 0 ;
			if(_mouseItem.nodeX!=p.x || _mouseItem.nodeZ!=p.y) {
				_mouseItem.nodeX = p.x ;
				_mouseItem.nodeZ= p.y ;
				_mouseItem.bottom.updateItemGridLayer();
				var gridModel:MapGridDataModel = MapGridDataModel.instance ;
				var size:int = PlayerModel.instance.me.mapSize ;
				if( _mouseItem.itemVO.baseVO.type==ItemType.WALL_DECOR || _mouseItem.itemVO.baseVO.type==ItemType.WALL_PAPER) 
				{
					if(_mouseItem.screenX!=0){
						_mouseItem.itemObject.scaleX = _mouseItem.screenX<0 ? 1: -1 ;
					}
				}
				
				if(GameData.villageMode==VillageMode.ITEM_SHOP || GameData.villageMode==VillageMode.ITEM_STORAGE )
				{
//					var moveBtns:MoveBuildingButtons  = MoveBuildingButtons.instance ;
//					if(_mouseItem.bottom.getWalkable()){
//						if( !moveBtns.okBtn.enabled){
//							moveBtns.okBtn.enabled = true  ;
//						}
//					}else{
//						if( moveBtns.okBtn.enabled){
//							moveBtns.okBtn.enabled = false ;
//						}
//					}
				}
			}
		}
		
		
		
		//================缩放地图=======================
		private var _zoomObj:Object = {"value":1};
		private var _zoomTween:TweenLite ;
		private var _zoomM:Matrix = new Matrix();
		private function changeWorldScale( value:Number , px:Number , py:Number , time:Number=0.2 ):void
		{
			if(scaleX*value>GameSetting.minZoom && scaleX*value<2.5 ) {
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
				}} );
			}
			_endX = x;
			_endY = y ;
		}
		
		
		private function modifyEndPosition():void{
			if(_endY>0) y=_endY=0 ;
			else if(_endY<-GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT){
				y=_endY = -GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT ;
			}
			
			var temp:Number=0 ;
			if(_endY<-GameSetting.MAP_HEIGHT*0.5){
				temp = -_endY*0.2 ;
			}else{
				temp = (GameSetting.MAP_HEIGHT+_endY)*0.2 ;
			}
			if(_endX>-temp*scaleX) _endX = x =-temp*scaleX ;
			else if(_endX<-GameSetting.MAP_WIDTH*scaleX+temp*scaleX+GameSetting.SCREEN_WIDTH){
				_endX = x = -GameSetting.MAP_WIDTH*scaleX+temp*scaleX+GameSetting.SCREEN_WIDTH ;
			}
		}
	}
}
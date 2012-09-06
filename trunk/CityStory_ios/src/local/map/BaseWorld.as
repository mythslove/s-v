package  local.map
{
	import bing.iso.*;
	import bing.iso.path.Grid;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	
	import local.comm.*;
	import local.enum.BuildingType;
	import local.map.item.*;
	import local.map.scene.*;
	import local.model.LandModel;
	import local.model.MapGridDataModel;
	import local.util.EmbedsManager;
	import local.vo.*;
	
	public class BaseWorld extends IsoWorld
	{
		public var roadScene:RoadScene ; //道路，水层
		public var buildingScene:BuildingScene; //建筑层
		public var iconScene:IsoScene ; //显示icon层
		public var topScene:IsoScene ; //最上层,显示移动的建筑，以及显示一些特效动画
		
		protected var _mouseDownPos:Point = new Point(); //鼠标点击的位置
		protected var _worldPos:Point = new Point(); //鼠标点击时场景的世界位置
		
		public var currentSelected:BaseBuilding ; //当前选中的建筑
		
		/**===============用于地图移动和缩放=========================*/
		protected var _isMove:Boolean ; //当前是否在移动地图
		protected var _isGesture:Boolean ; //当前是否在缩放地图
		protected var _endX:int ; //地图最终的位置X坐标，用于地图缓移动
		protected var _endY:int; //地图最终的位置Y坐标，用于地图缓移动
		
		private var _touches:Vector.<Touch> = Vector.<Touch>([ new Touch(0,0,0) , new Touch(0,0,0) ]) ; //两个手指的触摸对象
		protected var _touchCount:int ; //手指触摸数量
		private var _touchFinger1:Point = new Point(); //第一个点击的手指
		private var _middle:Point = new Point(); //缩放时的中间点位置
		protected var _moveSpeed:Number = 0.36 ; //移动的速度
		/**====================================================*/
		
		public function BaseWorld()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE);
			
			this.x =-50 + (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			y=-1200;
			_endX = x ;
			_endY = y ;
			addBackground();
		}
		
		private function addBackground():void
		{
			var mat:Matrix = new Matrix();
			var offset:Number ;
			
			var map:Shape = new Shape();
//			map.graphics.beginFill(0x006600  );
//			map.graphics.drawRect(0,0,GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT);
//			map.graphics.endFill();
//			this.setBackGround( map );
//			return ;
			
			var bmd:BitmapData = EmbedsManager.instance.getBitmapByName("MapBlock").bitmapData;
			map.graphics.beginBitmapFill( bmd , mat , true  );
			map.graphics.drawRect(0,0,GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT);
			map.graphics.endFill();
			
			bmd = EmbedsManager.instance.getBitmapByName("Bottomsea1").bitmapData;
			mat.identity();
			mat.translate( 0,GameSetting.MAP_HEIGHT-bmd.height);
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect(0,GameSetting.MAP_HEIGHT-bmd.height,bmd.width , bmd.height );
			map.graphics.endFill();
			offset = bmd.width ;
			
			bmd = EmbedsManager.instance.getBitmapByName("Bottomsea2").bitmapData;
			mat.identity(); mat.translate( offset ,GameSetting.MAP_HEIGHT-bmd.height);
			map.graphics.beginBitmapFill( bmd , mat , true  );
			map.graphics.drawRect(offset , GameSetting.MAP_HEIGHT-bmd.height , bmd.width , bmd.height );
			map.graphics.endFill();
			offset += bmd.width ;
			
			mat.identity(); mat.scale(-1,1); mat.translate( offset ,GameSetting.MAP_HEIGHT-bmd.height);
			map.graphics.beginBitmapFill( bmd , mat , true  );
			map.graphics.drawRect(offset , GameSetting.MAP_HEIGHT-bmd.height , bmd.width , bmd.height );
			map.graphics.endFill();
			offset += bmd.width ;
			
			bmd = EmbedsManager.instance.getBitmapByName("Bottomsea1").bitmapData;
			mat.identity(); mat.scale(-1,1); 	mat.translate( offset ,GameSetting.MAP_HEIGHT-bmd.height);
			map.graphics.beginBitmapFill( bmd , mat , true  );
			map.graphics.drawRect(offset , GameSetting.MAP_HEIGHT-bmd.height , bmd.width , bmd.height );
			map.graphics.endFill();
			//=========================
			
			bmd = EmbedsManager.instance.getBitmapByName("HeightMap1").bitmapData;
			mat.identity(); mat.translate( 0 ,300 );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect(0 , 300 , bmd.width , bmd.height );
			map.graphics.endFill();
			offset = bmd.width ;
			
			bmd = EmbedsManager.instance.getBitmapByName("HeightMap2").bitmapData;
			mat.identity(); mat.translate( offset ,215 );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect(offset , 215 , bmd.width , bmd.height );
			map.graphics.endFill();
			offset += bmd.width+50 ;
			
			bmd = EmbedsManager.instance.getBitmapByName("RightHeight1").bitmapData;
			mat.identity(); mat.translate( offset ,0 );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect(offset , 0 , bmd.width , bmd.height );
			map.graphics.endFill();
			
			//=========================
			offset = 100;
			bmd = EmbedsManager.instance.getBitmapByName("Rightsea1").bitmapData;
			mat.identity(); mat.translate( GameSetting.MAP_WIDTH-bmd.width ,offset );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect( GameSetting.MAP_WIDTH-bmd.width ,offset , bmd.width , bmd.height );
			map.graphics.endFill();
			offset+=bmd.height ;
			
			bmd = EmbedsManager.instance.getBitmapByName("Rightsea2").bitmapData;
			mat.identity(); mat.translate( GameSetting.MAP_WIDTH-bmd.width ,offset );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect( GameSetting.MAP_WIDTH-bmd.width ,offset , bmd.width , bmd.height );
			map.graphics.endFill();
			offset+=bmd.height ;
			
			bmd = EmbedsManager.instance.getBitmapByName("Water1").bitmapData;
			mat.identity(); mat.translate( 2760 ,300 );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect( 2760 ,300 , bmd.width , bmd.height );
			map.graphics.endFill(); 
			
			//=====================
			bmd = EmbedsManager.instance.getBitmapByName("SmallHeightMap").bitmapData;
			mat.identity(); mat.translate( 0  ,1000 );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect( 0 ,1000 , bmd.width , bmd.height );
			map.graphics.endFill();
			
			mat.identity(); mat.translate( 3500  ,1500 );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect( 3500  , 1500 , bmd.width , bmd.height );
			map.graphics.endFill();
			
			this.setBackGround( map );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			//显示地图网格
//			var gridScene:IsoScene = new IsoScene(GameSetting.GRID_SIZE);
//			(gridScene.addChild( new IsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE)) as IsoGrid).render() ;
//			gridScene.cacheAsBitmap=true;
//			this.addScene(gridScene);
			//添加iso场景
			roadScene = new RoadScene();
			roadScene.mouseChildren = true ; 
			buildingScene = new BuildingScene();
			iconScene = new IsoScene(0);
			iconScene.mouseEnabled = iconScene.mouseChildren = false ;
			topScene = new IsoScene(0);
			topScene.mouseEnabled = false ;
			topScene.visible = false ;
			addScene( roadScene );
			addScene(buildingScene);
			addScene(iconScene);
			addScene(topScene);
			//设置背景
			initMap();
			//添加侦听
			configListeners();
		}
		
		/** 初始化地图 */
		protected function initMap():void
		{
			var i:int , j:int ;
			var gameGridData:Grid = MapGridDataModel.instance.gameGridData ;
			var maxX:int ,maxZ:int ;
			
			//地图数据
			this.panTo( MapGridDataModel.instance.mapPanX , MapGridDataModel.instance.mapPanY );
			
			//添加地图区域
			for each( var landVO:LandVO in LandModel.instance.lands) {
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
			//	drawMapZoneByLine();
			
			//随机添加树，石头
			var basicBuild:BasicBuilding ;
			var basicVO:BaseBuildingVO ;
			var basicVOs:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>( 8 , true );
			for( i = 0 ; i<8 ; ++i ) {
				basicVO = new BaseBuildingVO();
				basicVO.name = "Basic_Tree"+( i+1 ) ; 
				basicVO.type = BuildingType.BASIC ;
				if(i<6) {
					basicVO.span = 1 ;
				}
				basicVOs[i] = basicVO ;
			}
			
			var bvo:BuildingVO ;
			for( i = 0 ; i<GameSetting.GRID_X ; i+=2  ){
				for( j = 0 ; j<GameSetting.GRID_Z ;  j+=2){
					if( !gameGridData.getNode(i,j).walkable && MapGridDataModel.instance.mapGridData.getNode(i,j).walkable 
						&& Math.random()>0.8 ){
						var index:int = (Math.random()*8 )>>0 ;
						bvo = new BuildingVO();
						bvo.baseVO = basicVOs[index] ;
						bvo.name = basicVOs[index].name ;
						bvo.nodeX = i ;
						bvo.nodeZ = j ;
						basicBuild = new BasicBuilding(bvo ) ;
						basicBuild.mouseChildren =  false ;
						buildingScene.addBuilding( basicBuild , false  );
					}
				}
			}
		}
		
		/** 添加侦听 */
		protected function configListeners():void
		{
			if(Multitouch.supportsGestureEvents){
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT ;
				this.addEventListener(TouchEvent.TOUCH_BEGIN , onTouchHandler ) ;
				this.addEventListener(TouchEvent.TOUCH_MOVE , onTouchHandler ) ;
				this.addEventListener(TouchEvent.TOUCH_END , onTouchHandler ) ;
				this.addEventListener(TouchEvent.TOUCH_END , onTouchHandler , false,0,true ) ;
			}else{
				this.addEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheelHandler);
			}
		}
		
		/*多点缩放地图*/
		private function onTouchHandler( e:TouchEvent ):void
		{
			e.stopPropagation();
			switch(e.type)
			{
				case TouchEvent.TOUCH_BEGIN:
					++_touchCount ;
					if(_touchCount==1){
						_touchFinger1.x = e.stageX ;
						_touchFinger1.y = e.stageY ;
						_touches[0].stageX = e.stageX ;
						_touches[0].stageY = e.stageY ;
						_touches[0].prevX = e.stageX ;
						_touches[0].prevY = e.stageY ;
						_touches[0].id = e.touchPointID ;
					}
					else if(_touchCount==2){
						_middle.x = _touchFinger1.x+(e.stageX-_touchFinger1.x)*0.5 ;
						_middle.y = _touchFinger1.y+(e.stageY-_touchFinger1.y)*0.5 ;
						_touches[1].stageX = e.stageX ;
						_touches[1].stageY = e.stageY ;
						_touches[1].prevX = e.stageX ;
						_touches[1].prevY = e.stageY ;
						_touches[1].id = e.touchPointID ;
					}
					break;
				case TouchEvent.TOUCH_MOVE :
					if(_touchCount>=2){
						_isGesture = true ;
						var touch:Touch;
						for(var i:int=0;i<2;++i){
							touch = _touches[i] as Touch ;
							if(touch.id==e.touchPointID){
								touch.prevX = touch.stageX ;
								touch.prevY = touch.stageY;
								touch.stageX = e.stageX ;
								touch.stageY = e.stageY ;
								//放大缩小
								var touchA:Touch = _touches[0];
								var touchB:Touch = _touches[1];
								
								var currentPosA:Point  = new Point( touchA.stageX , touchA.stageY  );
								var previousPosA:Point = new Point( touchA.prevX , touchA.prevY );
								var currentPosB:Point  = new Point( touchB.stageX,touchB.stageY );
								var previousPosB:Point = new Point( touchB.prevX , touchB.prevY );
								
								var currentVector:Point  = currentPosA.subtract(currentPosB);
								var previousVector:Point = previousPosA.subtract(previousPosB);
								
								// scale
								var sizeDiff:Number = currentVector.length / previousVector.length;
								sizeDiff = sizeDiff>1 ? 1+(sizeDiff-1)*.25 : 1-(1-sizeDiff)*.25 ;
								changeWorldScale( sizeDiff , _middle.x , _middle.y );
								
							}
						}
					}
					break ;
				case TouchEvent.TOUCH_END:
					--_touchCount ;
					if(_touchCount<0) _touchCount = 0 ;
					break ;
			}
		}
		
		public function run():void{ addEventListener(Event.ENTER_FRAME , onEnterFrameHandler ); }
		public function stopRun():void{ removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler ); }
		override public function update():void { buildingScene.update() ; }
		
		private function onEnterFrameHandler(e:Event):void
		{
			update();
			if(x!=_endX) x += ( _endX-x)*_moveSpeed ; //缓动地图
			if(y!=_endY) y += (_endY-y)*_moveSpeed ;
		}
		
		/** 修正地图位置，防止地图溢出边缘 */
		protected function modifyEndPosition():void{
			if(_endX>0) _endX=0 ;
			else if(_endX<-GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH){
				_endX = -GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH ;
			}
			if(_endY>0) _endY=0 ;
			else if(_endY<-GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT){
				_endY = -GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT ;
			}
		}
		
		/*用于鼠标缩放地图*/
		private function onMouseWheelHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			var value:Number = e.delta>0?1.1:0.95 ;
			changeWorldScale(value,root.mouseX,root.mouseY);
		}
		
		/*修改地图的缩放值和地图的位置*/
		private function changeWorldScale( value:Number , px:Number , py:Number ):void
		{
			if(scaleX*value>GameSetting.minZoom && scaleX*value<2) {
				var m:Matrix = this.transform.matrix;
				m.tx -= px;
				m.ty -= py;
				m.scale(value, value);
				m.tx += px;
				m.ty += py;
				this.transform.matrix = m;
				_mouseDownPos.x = _endX = x;
				_mouseDownPos.y = _endY = y ;
				modifyEndPosition();
				x = _endX ;
				y = _endY ;
			}
			_endX = x;
			_endY = y ;
		}
		
		
		/** 用线画这个地图的区域*/
		private function drawMapZoneByLine():void
		{
			var size:int = _size*4 ;
			var grid:Grid = MapGridDataModel.instance.landGridData;
			roadScene.graphics.lineStyle(2 ,0x97B425 );
			for each(var landVO:LandVO in LandModel.instance.lands) {
				var p:Vector3D = GameData.commVec ;
				p.setTo(0,0,0);
				var screenPos:Point = GameData.commPoint ;
				screenPos.setTo(0,0);
				//第一个点
				p.x = landVO.nodeX; p.z=landVO.nodeZ;
				screenPos = IsoUtils.isoToScreen(p);
				var px:int = screenPos.x*size ; 
				var py:int = screenPos.y*size ;
				roadScene.graphics.moveTo(  px , py );
				//第二个点
				p.x = landVO.nodeX+1; p.z=landVO.nodeZ ;
				screenPos = IsoUtils.isoToScreen(p);
				p.x =  screenPos.x*size ; p.z = screenPos.y*size ;
				if( landVO.nodeZ-1>=0 && !grid.getNode(landVO.nodeX,landVO.nodeZ-1).walkable ) {
					roadScene.graphics.lineTo( p.x , p.z );
				}
				roadScene.graphics.moveTo(  p.x , p.z );
				//第三个点
				p.x = landVO.nodeX+1 ; p.z=landVO.nodeZ+1;
				screenPos = IsoUtils.isoToScreen(p);
				p.x =  screenPos.x*size ; p.z = screenPos.y*size ;
				if( landVO.nodeX+1<GameSetting.GRID_X/4 && !grid.getNode(landVO.nodeX+1,landVO.nodeZ).walkable ) {
					roadScene.graphics.lineTo( p.x , p.z );
				}
				roadScene.graphics.moveTo(  p.x , p.z );
				//第四个点
				p.x = landVO.nodeX ; p.z=landVO.nodeZ+1;
				screenPos = IsoUtils.isoToScreen(p);
				p.x =  screenPos.x*size ; p.z = screenPos.y*size ;
				if( landVO.nodeZ+1<GameSetting.GRID_Z/4 && !grid.getNode(landVO.nodeX,landVO.nodeZ+1).walkable ) {
					roadScene.graphics.lineTo( p.x , p.z );
				}
				roadScene.graphics.moveTo(  p.x , p.z );
				//原点
				p.x = landVO.nodeX ; p.z=landVO.nodeZ;
				screenPos = IsoUtils.isoToScreen(p);
				px = screenPos.x*size ;  py = screenPos.y*size ;
				if( landVO.nodeX-1>=0 && !grid.getNode(landVO.nodeX-1 , landVO.nodeZ).walkable ) {
					roadScene.graphics.lineTo( px , py );
				}
			}
		}
		
		/** 用填充色画这个土地区域*/
		public function drawMapZoneByFill( landVO:LandVO ):void
		{
			var p:Vector3D = GameData.commVec ;
			p.setTo(0,0,0);
			var screenPos:Point = GameData.commPoint ;
			screenPos.setTo(0,0);
			roadScene.graphics.beginFill( 0x97B425 , 1 );
			p.x = landVO.nodeX; p.z=landVO.nodeZ;
			screenPos = IsoUtils.isoToScreen(p);
			var px:int = screenPos.x*_size*4 ;
			var py:int = screenPos.y*_size*4 ;
			roadScene.graphics.moveTo(  px , py );
			
			p.x = landVO.nodeX+1; p.z=landVO.nodeZ;
			screenPos = IsoUtils.isoToScreen(p);
			roadScene.graphics.lineTo( screenPos.x*_size*4 , screenPos.y*_size*4);
			
			p.x = landVO.nodeX+1; p.z=landVO.nodeZ+1;
			screenPos = IsoUtils.isoToScreen(p);
			roadScene.graphics.lineTo( screenPos.x*_size*4 ,screenPos.y*_size*4);
			
			p.x = landVO.nodeX; p.z=landVO.nodeZ+1;
			screenPos = IsoUtils.isoToScreen(p);
			roadScene.graphics.lineTo( screenPos.x*_size*4 ,screenPos.y*_size*4);
			
			roadScene.graphics.lineTo( px , py );
			roadScene.graphics.endFill();
		}
		
	}
}









class Touch
{
	public var id:int ;
	public var stageX:Number ;
	public var stageY:Number ;
	
	public var prevX:Number ;
	public var prevY:Number ;
	
	public function Touch( id:int , stageX:Number , stageY:Number )
	{
		this.id = id ;
		this.stageX = stageX ;
		this.stageY = stageY ;
	}
}
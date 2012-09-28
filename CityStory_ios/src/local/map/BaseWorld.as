package  local.map
{
	import bing.iso.*;
	import bing.iso.path.Grid;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.Dictionary;
	
	import local.comm.*;
	import local.enum.BuildingType;
	import local.enum.VillageMode;
	import local.map.item.*;
	import local.map.land.ExpandSign;
	import local.map.scene.*;
	import local.model.LandModel;
	import local.model.MapGridDataModel;
	import local.util.EmbedsManager;
	import local.view.building.EditorBuildingButtons;
	import local.view.building.MoveBuildingButtons;
	import local.vo.*;
	
	public class BaseWorld extends IsoWorld
	{
		public var roadScene:RoadScene ; //道路，水层
		public var buildingScene:BuildingScene; //建筑层
		public var iconScene:IsoScene ; //显示icon层
		public var topScene:IsoScene ; //最上层,显示移动的建筑，以及显示一些特效动画
		public var effectScene:IsoScene ; //特效层
		
		protected var _mouseDownPos:Point = new Point(); //鼠标点击的位置
		protected var _worldPos:Point = new Point(); //鼠标点击时场景的世界位置
		
		public var currentSelected:BaseBuilding ; //当前选中的建筑
		
		protected var _basicVOs:Vector.<BaseBuildingVO> ; //所有的树的BaseBuildingVO
		protected var _expandSigns:Vector.<ExpandSign> = new Vector.<ExpandSign>() ; //所有的扩地标志
		protected var _trees:Vector.<BasicBuilding> = new Vector.<BasicBuilding>();//所有的树
		/**===============用于地图移动和缩放=========================*/
		protected var _isMove:Boolean ; //当前是否在移动地图
		protected var _isGesture:Boolean ; //当前是否在缩放地图
		protected var _endX:int ; //地图最终的位置X坐标，用于地图缓移动
		protected var _endY:int; //地图最终的位置Y坐标，用于地图缓移动
		
		private var _touches:Vector.<Touch> = Vector.<Touch>([ new Touch(0,0,0) , new Touch(0,0,0) ]) ; //两个手指的触摸对象
		protected var _touchCount:int ; //手指触摸数量
		private var _touchFinger1:Point = new Point(); //第一个点击的手指
		private var _middle:Point = new Point(); //缩放时的中间点位置
		protected var _moveSpeed:Number  ; //移动的速度
		public var runUpdate:Boolean = true ; //是否运行建筑 的update
		/**====================================================*/
		
		public function BaseWorld()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE);
			mouseChildren = mouseEnabled = false ;
			
			this.x =-50 + (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			y=-1260;
			_endX = x ;
			_endY = y ;
			addBackground();
		}
		
		private function addBackground():void
		{
			var mat:Matrix = new Matrix();
			var offset:Number ;
			
			var map:Shape = new Shape();
//			map.graphics.beginFill(0x859E21  );
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
			
			mat.identity(); mat.translate( 3600  ,1800 );
			map.graphics.beginBitmapFill( bmd , mat , false  );
			map.graphics.drawRect( 3600  , 1800 , bmd.width , bmd.height );
			map.graphics.endFill();
			
			this.setBackGround( map );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			//添加iso场景
			roadScene = new RoadScene();
			roadScene.mouseChildren = false ; 
			buildingScene = new BuildingScene();
			iconScene = new IsoScene(0);
			iconScene.mouseEnabled = false ;
			effectScene = new IsoScene(0);
			effectScene.mouseEnabled = false ;
			topScene = new IsoScene(0);
			topScene.visible = topScene.mouseEnabled = false ;
			addScene( roadScene );
			addScene(buildingScene);
			addScene(iconScene);
			addScene( effectScene );
			addScene(topScene);
			//显示地图网格
//			var gridScene:IsoScene = new IsoScene(GameSetting.GRID_SIZE);
//			(gridScene.addChild( new IsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE)) as IsoGrid).render() ;
//			gridScene.cacheAsBitmap=true;
//			this.addScene(gridScene);
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
			if(!LandModel.instance.lands)  LandModel.instance.initLands();
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
			//添加扩地牌
			addExpandSign();
			//随机添加树
			addTrees();
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
			var rate:Number = GameSetting.device=="iphone" ? 0.95 : 0.92 ;
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
							basicBuild.mouseChildren =  false ;
							buildingScene.addBuilding( basicBuild , false  );
							_trees.push( basicBuild );
						}
						++treeIndex ;
					}
				}
			}
		}
		
		/**
		 *  添加扩地牌子
		 * @param sort 为ture表示不是初始化地图时，而是后面扩地完成后重新添加的
		 */		
		public function addExpandSign( sort:Boolean = false ):void
		{
			if(GameData.villageMode!=VillageMode.VISIT){
				var lands:Dictionary = LandModel.instance.getCanExpandLand();
				var arr:Array ;
				var expandSign:ExpandSign ;
				var temp:Boolean=true ; //必须至少有一个扩地牌
				var index:int , nx:int , nz:int ;
				for( var key:String in lands)
				{
					if(temp || Math.random()>0.6)
					{
						arr = key.split("-");
						for( var i:int = 1 ; i<4 ; ++i ){
							for( var j:int = 1 ;  j<4 ; ++j ){
								nx = int( arr[0] )*4+i ;
								nz = int (arr[1] )*4+j ;
								if( ( sort && buildingScene.gridData.getNode(nx,nz).walkable) || !buildingScene.gridData.getNode(nx,nz).walkable )
								{
									if(_expandSigns.length>index){
										expandSign = _expandSigns[index] ;
									}else{
										expandSign = new ExpandSign();
										_expandSigns.push( expandSign );
									}
									expandSign.nodeX = nx ;
									expandSign.nodeZ = nz ;
									buildingScene.addIsoObject( expandSign , sort );
									expandSign.setWalkable( false , buildingScene.gridData );
									MapGridDataModel.instance.addBuildingGridData(expandSign);
									expandSign.checkScale();
									temp = false ;
									++index;
									i = 4;j=4; //跳出两个for循环
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * 显示和隐藏扩地标志 
		 * @param value
		 */		
		public function visibleExpandSigns( value:Boolean):void{
			for each( var sign:ExpandSign in _expandSigns){
				if( !sign.getWalkable(buildingScene.gridData)){
					sign.visible = value ;
				}
			}
		}
		
		/** 移除场景上所有的扩地标志 */
		public function removeExpandSigns():void
		{
			for each( var sign:ExpandSign in _expandSigns){
				if(sign.parent){
					buildingScene.removeIsoObject( sign);
					MapGridDataModel.instance.removeBuildingGridData(sign);
				}
			}
		}
		
		/** 添加侦听 */
		protected function configListeners():void
		{
			if(Multitouch.supportsTouchEvents){
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT ;
				this.addEventListener(TouchEvent.TOUCH_BEGIN , onTouchHandler ) ;
				this.addEventListener(TouchEvent.TOUCH_MOVE , onTouchHandler ) ;
				stage.addEventListener(TouchEvent.TOUCH_END , onTouchHandler ) ;
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
						_touchFinger1.x = e.stageX/root.scaleX ;
						_touchFinger1.y = e.stageY/root.scaleX ;
						_touches[0].stageX = e.stageX/root.scaleX ;
						_touches[0].stageY = e.stageY/root.scaleX ;
						_touches[0].prevX = e.stageX/root.scaleX ;
						_touches[0].prevY = e.stageY/root.scaleX ;
						_touches[0].id = e.touchPointID ;
					}
					else if(_touchCount==2){
						_middle.x = _touchFinger1.x+(e.stageX/root.scaleX-_touchFinger1.x)*0.5 ;
						_middle.y = _touchFinger1.y+(e.stageY/root.scaleX-_touchFinger1.y)*0.5 ;
						_touches[1].stageX = e.stageX/root.scaleX ;
						_touches[1].stageY = e.stageY/root.scaleX ;
						_touches[1].prevX = e.stageX/root.scaleX ;
						_touches[1].prevY = e.stageY/root.scaleX ;
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
								touch.stageX = e.stageX/root.scaleX ;
								touch.stageY = e.stageY/root.scaleX ;
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
								sizeDiff = sizeDiff>1 ? 1+(sizeDiff-1)*.15 : 1-(1-sizeDiff)*.15 ;
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
		
		public function run():void{ 
			addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			mouseEnabled = mouseChildren=true ;
		}
		public function stopRun():void{ 
			removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler ); 
			mouseEnabled = mouseChildren=false ;
		}
		override public function update():void { buildingScene.update() ; }
		
		private function onEnterFrameHandler(e:Event):void
		{
			if(runUpdate)	update();
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
		
		/**修改地图的缩放值和地图的位置*/
		protected function changeWorldScale( value:Number , px:Number , py:Number ):void
		{
			if(scaleX*value>GameSetting.minZoom && scaleX*value<2.5) {
				var m:Matrix = this.transform.matrix;
				var vx:Number = x ;
				var vy:Number = y ;
				m.tx -= px+vx ;
				m.ty -= py+vy ;
				m.scale(value, value);
				m.tx += px+vx*value ;
				m.ty += py+vy*value ;
				this.transform.matrix = m;
				_mouseDownPos.x = _endX = x;
				_mouseDownPos.y = _endY = y ;
				modifyEndPosition();
				x = _endX ;
				y = _endY ;
				
				changeIconSize();
			}
			_endX = x;
			_endY = y ;
		}
		
		protected function changeIconSize():void
		{
			if(MoveBuildingButtons.instance.parent)
			{
				MoveBuildingButtons.instance.scaleY =MoveBuildingButtons.instance.scaleX = 1/scaleX ;
			}
			else if(EditorBuildingButtons.instance.parent)
			{
				EditorBuildingButtons.instance.scaleY =EditorBuildingButtons.instance.scaleX = 1/scaleX ;
			}
			var obj:DisplayObject ;
			for( var i:int = 0 ; i <effectScene.numChildren ; ++i ){
				obj = effectScene.getChildAt(i) ;
				obj.scaleY = obj.scaleX = 1/scaleX ;
			}
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
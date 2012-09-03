package  local.map
{
	import bing.iso.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	
	import local.comm.*;
	import local.map.item.*;
	import local.map.scene.*;
	import local.util.EmbedsManager;
	import local.vo.*;
	
	public class BaseWorld extends IsoWorld
	{
		public var roadScene:RoadScene ; //道路，水层
		public var buildingScene:BuildingScene; //建筑层
		
		protected var _mouseDownPos:Point = new Point(); //鼠标点击的位置
		protected var _worldPos:Point = new Point(); //鼠标点击时场景的世界位置
		
		public var currentSelected:BaseBuilding ; //当前选中的建筑
		private var _mouseBuilding:BaseBuilding; //按下时点击到的建筑
		
		/**===============用于地图移动和缩放=========================*/
		protected var _isMove:Boolean ; //当前是否在移动地图
		protected var _isGesture:Boolean ; //当前是否在缩放地图
		protected var _endX:int ; //地图最终的位置X坐标，用于地图缓移动
		protected var _endY:int; //地图最终的位置Y坐标，用于地图缓移动
		
		private var _touches:Vector.<Touch> = Vector.<Touch>([ new Touch(0,0,0) , new Touch(0,0,0) ]) ; //两个手指的触摸对象
		private var _touchCount:int ; //手指触摸数量
		private var _touchFinger1:Point = new Point(); //第一个点击的手指
		private var _middle:Point = new Point(); //缩放时的中间点位置
		private var _moveSpeed:Number = 0.36 ; //移动的速度
		/**====================================================*/
		
		
		
		public function BaseWorld()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE);
			
			this.panTo(GameSetting.MAP_WIDTH>>1 , 600);
			this.x = (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			y=-400;
			_endX = x ;
			_endY = y ;
			addBackground();
		}
		
		private function addBackground():void
		{
			var mat:Matrix = new Matrix();
			var offset:Number ;
			
			var map:Shape = new Shape();
			map.graphics.beginFill(0x006600  );
			map.graphics.drawRect(0,0,GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT);
			map.graphics.endFill();
			this.setBackGround( map );
			return ;
			
			
			
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
			
			mat.identity() ;
			map.cacheAsBitmapMatrix = mat ;
			map.cacheAsBitmap = true ;
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
			buildingScene = new BuildingScene();
			addScene( roadScene );
			addScene(buildingScene);
			//设置背景
			initMap();
			//添加侦听
			configListeners();
		}
		
		/** 初始化地图 */
		protected function initMap():void
		{
			
		}
	
		/** 添加侦听 */
		protected function configListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN , onMouseEvtHandler); 
			if(Multitouch.supportsGestureEvents){
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT ;
				this.addEventListener(TouchEvent.TOUCH_BEGIN , onTouchHandler ) ;
				this.addEventListener(TouchEvent.TOUCH_MOVE , onTouchHandler ) ;
				this.addEventListener(TouchEvent.TOUCH_END , onTouchHandler ) ;
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
					if(_touchCount>=2)
					{
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
								
								_isGesture = true ;
							}
						}
					}
					break ;
				case TouchEvent.TOUCH_END:
					--_touchCount ;
					break ;
			}
		}
		
		public function run():void{
			addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		public function stopRun():void{
			removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		override public function update():void { buildingScene.update() ; }
		
		private function onEnterFrameHandler(e:Event):void
		{
			update();
			if(x!=_endX) x += ( _endX-x)*_moveSpeed ; //缓动地图
			if(y!=_endY) y += (_endY-y)*_moveSpeed ;
		}
		
		/* 修正地图位置，防止地图溢出边缘 */
		private function modifyEndPosition():void{
			if(_endX>0) _endX=0 ;
			else if(_endX<-GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH){
				_endX = -GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH ;
			}
			if(_endY>0) _endY=0 ;
			else if(_endY<-GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT){
				_endY = -GameSetting.MAP_HEIGHT*scaleY+GameSetting.SCREEN_HEIGHT ;
			}
		}

		protected function onMouseEvtHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch( e.type )
			{
				case MouseEvent.MOUSE_DOWN:
					_moveSpeed = 0.36 ;
					_mouseDownPos.x = root.mouseX ;
					_mouseDownPos.y = root.mouseY ;
					_worldPos.x = x ;
					_worldPos.y = y ;
					_isGesture = false ;
					if(e.target.parent is BaseBuilding){
						_mouseBuilding = e.target.parent as BaseBuilding ;
					}
					addEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler); 
					addEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
					break ;
				case MouseEvent.MOUSE_MOVE:
					_isMove = true ;
					mouseChildren = false; 
					if(e.buttonDown && !_isGesture ){
						_endX =  _worldPos.x + root.mouseX-_mouseDownPos.x ;
						_endY = _worldPos.y + root.mouseY-_mouseDownPos.y ;
						modifyEndPosition();
					}
					break ;
				case MouseEvent.MOUSE_UP:
					if(!_isGesture && !_isMove){
						if(e.target.parent is BaseBuilding && e.target.parent!=currentSelected && e.target.parent==_mouseBuilding){
							if(currentSelected) {
								currentSelected.flash(false);
							}
							currentSelected = e.target.parent as BaseBuilding ;
							currentSelected.flash(true);
							//移动到中间
							_endX =  GameSetting.SCREEN_WIDTH*0.5 - (sceneLayerOffsetX+currentSelected.screenX)*scaleX ;
							_endY = GameSetting.SCREEN_HEIGHT*0.5 -(currentSelected.screenY +sceneLayerOffsetY+GameSetting.GRID_SIZE*2)*scaleY ;
							modifyEndPosition();
							_moveSpeed = 0.15 ;
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
			if(scaleX*value>0.8 && scaleX*value<2) {
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
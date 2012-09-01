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
	import local.vo.*;
	
	public class BaseWorld extends IsoWorld
	{
		protected var _isMove:Boolean ;
		protected var _buildingCachePos:Point = new Point() ;
		protected var _mouseDownPos:Point = new Point();
		protected var _worldPos:Point = new Point();
		protected var _isGesture:Boolean ;
		protected var _endX:int ;
		protected var _endY:int;
		
		public var landScene:LandScene ;
		public var roadScene:RoadScene ;
		public var buildingScene:BuildingScene;
		
		public var currentSelected:BaseBuilding ;
		private var _mouseBuilding:BaseBuilding;
		
		private var _touches:Vector.<Touch> = Vector.<Touch>([
			new Touch(0,0,0) , new Touch(0,0,0)
		]) ;
		private var _touchCount:int ;
		private var _touchFinger1:Point = new Point();
		private var _middle:Point = new Point();
		
		public function BaseWorld()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE);
			
			this.panTo(GameSetting.MAP_WIDTH>>1 , 300);
			this.x = (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			y=-120;
			_endX = x ;
			_endY = y ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			//显示地图网格
			var gridScene:IsoScene = new IsoScene(GameSetting.GRID_SIZE);
			(gridScene.addChild( new IsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE)) as IsoGrid).render() ;
			gridScene.cacheAsBitmap=true;
			this.addScene(gridScene);
			//添加iso场景
			landScene = new LandScene();
			roadScene = new RoadScene();
			buildingScene = new BuildingScene();
			addScene(landScene);
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
								sizeDiff = sizeDiff>1 ? 1+(1-sizeDiff)*.5 : 1-(1-sizeDiff)*.5 ;
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
		
		private function onEnterFrameHandler(e:Event):void
		{
			update();
			if(x!=_endX){
				x += ( _endX-x)*0.36 ;
			}
			if(y!=_endY){
				y += (_endY-y)*0.36 ;
			}
		}
		
		
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
		
		private function onMouseWheelHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			var value:Number = e.delta>0?1.1:0.95 ;
			changeWorldScale(value,root.mouseX,root.mouseY);
		}
		
		private function changeWorldScale( value:Number , px:Number , py:Number ):void
		{
			if(scaleX*value>0.8 && scaleX*value<2) {
				_endX = x;
				_endY = y ;
				var m:Matrix = this.transform.matrix;
				m.tx -= px;
				m.ty -= py;
				m.scale(value, value);
				m.tx += px;
				m.ty += py;
				this.transform.matrix = m;
				modifyEndPosition();
				_mouseDownPos.x = _endX = x;
				_mouseDownPos.y = _endY = y ;
			}
			_endX = x ;
			_endY = y ;
		}
		
		override public function update():void
		{
			buildingScene.update() ;
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
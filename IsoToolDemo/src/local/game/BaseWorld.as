package local.game
{
	import assets.houses.Assets;
	
	import bing.iso.IsoScene;
	import bing.iso.IsoUtils;
	import bing.iso.IsoWorld;
	
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import local.comm.*;
	import local.game.iso.BaseBuilding;
	import local.game.scenes.BuildingScene;
	import local.vos.*;
	
	public class BaseWorld extends IsoWorld
	{
		private var _bg:Shape; 
		protected var _isMove:Boolean ;
		protected var _buildingCachePos:Point = new Point() ;
		protected var _mouseDownPos:Point = new Point();
		protected var _worldPos:Point = new Point();
		protected var _isGesture:Boolean ;
		protected var _endX:int ;
		protected var _endY:int;
		
		public var buildingScene:BuildingScene;
		public var groundScene:IsoScene;
		public var skyScene:IsoScene;
		public var topScene:IsoScene ;
		
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
			
			this.panTo(GameSetting.MAP_WIDTH>>1 , 250);
			this.x = (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			y=-120;
			_endX = x ;
			_endY = y ;
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
			groundScene = new BuildingScene();
			buildingScene = new BuildingScene();
			skyScene= new IsoScene(GameSetting.GRID_SIZE,GameSetting.GRID_X,GameSetting.GRID_Z);
			skyScene.mouseEnabled=false;
			topScene = new IsoScene(GameSetting.GRID_SIZE,GameSetting.GRID_X,GameSetting.GRID_Z);
			topScene.mouseEnabled=false;
			addScene(groundScene);
			addScene(buildingScene);
			addScene(topScene);
			addScene(skyScene);
			//设置背景
//			_bg = ResourceUtil.instance.getResVOByResId("background").resObject as Shape;
//			_bg.x = (GameSetting.MAP_WIDTH-_bg.width)>>1 ;
//			this.setBackGround( _bg );
			
			drawZone(GameSetting.GRID_X,GameSetting.GRID_Z);
			configListeners();
		}
		
	
		
		/** 画地图区域 */
		protected function drawZone( xPan:int , zPan:int  ):void
		{
			
			var shape:Shape = new Shape();
			var bmd:BitmapData = ( new Assets.BGFILL()).bitmapData ;
			shape.graphics.beginBitmapFill( bmd );
			shape.graphics.drawRect(0,0,GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT );
			shape.graphics.endFill();
			
			bmd = (new Assets.BG()).bitmapData;
			shape.graphics.beginBitmapFill( bmd );
			shape.graphics.drawRect(0,0,GameSetting.MAP_WIDTH , bmd.height );
			shape.graphics.endFill();
			
			var matx:Matrix = new Matrix();
			matx.scale( 1,1);
			shape.cacheAsBitmapMatrix = matx;
			shape.cacheAsBitmap = true ;
			this.setBackGround( shape );
			
			
			
			
			
			groundScene.graphics.clear();
			
			groundScene.graphics.beginFill(0x549733,.5);
			groundScene.graphics.moveTo( 0,0);
			
			var p:Vector3D = new Vector3D();
			var screenPos:Point =new Point();
			
			p.x = xPan; p.z=0;
			screenPos = IsoUtils.isoToScreen(p);
			groundScene.graphics.lineTo( screenPos.x*GameSetting.GRID_SIZE , screenPos.y*GameSetting.GRID_SIZE);
			
			p.x = xPan; p.z=zPan;
			screenPos = IsoUtils.isoToScreen(p);
			groundScene.graphics.lineTo( screenPos.x*GameSetting.GRID_SIZE ,screenPos.y*GameSetting.GRID_SIZE);
			
			p.x = 0; p.z=zPan;
			screenPos = IsoUtils.isoToScreen(p);
			groundScene.graphics.lineTo( screenPos.x*GameSetting.GRID_SIZE ,screenPos.y*GameSetting.GRID_SIZE);
			
			groundScene.graphics.lineTo( 0,0);
			
			groundScene.graphics.endFill();
			
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

		protected function onMouseEvtHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch( e.type )
			{
				case MouseEvent.MOUSE_DOWN:
					_mouseDownPos.x = GameData.app.mouseX ;
					_mouseDownPos.y = GameData.app.mouseY ;
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
						_endX =  _worldPos.x + GameData.app.mouseX-_mouseDownPos.x ;
						_endY = _worldPos.y + GameData.app.mouseY-_mouseDownPos.y ;
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
		
		private function onMouseWheelHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			var value:Number = e.delta>0?1.1:0.95 ;
			changeWorldScale(value,GameData.app.mouseX,GameData.app.mouseY);
		}
		
		private function changeWorldScale( value:Number , px:Number , py:Number ):void
		{
			if(scaleX*value>0.6 && scaleX*value<2) {
				_endX = x;
				_endY = y ;
				var m:Matrix = this.transform.matrix;
				m.tx -= px;
				m.ty -= py;
				m.scale(value, value);
				m.tx += px;
				m.ty += py;
				this.transform.matrix = m;
				if(x>0) x=0 ;
				else if(x<-GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH){
					x = -GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH ;
				}
				if(y>0) y=0 ;
				else if(y<-GameSetting.MAP_HEIGHT*scaleX+GameSetting.SCREEN_HEIGHT){
					y = -GameSetting.MAP_HEIGHT*scaleX+GameSetting.SCREEN_HEIGHT ;
				}
//				buildingScene.updateBuildingSize( scaleX );
				var len:int = skyScene.numChildren;
				var effect:DisplayObject ;
				_mouseDownPos.x = _endX = x;
				_mouseDownPos.y = _endY = y ;
			}
			_endX = x ;
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
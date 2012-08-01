package local
{
	import bing.starling.iso.SIsoGrid;
	import bing.starling.iso.SIsoObject;
	import bing.starling.iso.SIsoScene;
	import bing.starling.iso.SIsoWorld;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.*;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class GameWorld extends SIsoWorld
	{
		public var buildingScene:SIsoScene ;
		protected var _endX:int ;
		protected var _endY:int;
		protected var _mouseDownPos:Point = new Point();
		protected var _worldPos:Point = new Point();
		private var _initFingerDis:Number ;
		
		public function GameWorld()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE );
			this.panTo(GameSetting.MAP_WIDTH>>1 , 250);
			this.x = (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			y=-120;
			
			
			_endX = x ;
			_endY = y ;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			addMouseConfig();
			addBg();
			
			var gridScene:SIsoScene = new SIsoScene(GameSetting.GRID_SIZE);
			var grid:SIsoGrid = new SIsoGrid(_gridX,_gridZ,_size);
			gridScene.addChild(grid ) ;
			this.addScene(gridScene);
			
			buildingScene = new SIsoScene( _size ,_gridX,_gridZ );
			this.addScene(buildingScene);
			
			//添加一个建筑
			var house:SIsoObject = new SIsoObject(_size , 2 , 1 );
			var img:Image = new Image( Assets.createTextureByName("house1") );
			img.x = -59 ;
			img.y = -54 ;
			house.addChild(img);
			buildingScene.addIsoObject( house,false );
			trace( house.screenX , house.screenY  );

//			house = new SIsoObject(_size , 2 , 1 );
//			house.y = 100 ;
//			img = new Image( Assets.createTextureByName("house1") );
//			img.x = -59 ;
//			img.y = -54 ;
//			house.addChild(img);
//			buildingScene.addIsoObject( house,false );
			
			
			
			
			
			addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		private function onEnterFrameHandler( e:Event ):void
		{
			update();
			if(x!=_endX){
				x += ( _endX-x)*0.36 ;
			}
			if(y!=_endY){
				y += (_endY-y)*0.36 ;
			}
		}
		
		private function addMouseConfig():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouchedHandler); 
		}
		
		private function onTouchedHandler( e:TouchEvent ):void
		{
			if(e.touches.length==1)
			{
				var touch:Touch = e.getTouch(stage); 
				var pos:Point = touch.getLocation(stage); 
				if(touch.phase==TouchPhase.BEGAN)
				{
					_mouseDownPos.x = pos.x ;
					_mouseDownPos.y = pos.y ;
					_worldPos.x = x ;
					_worldPos.y = y ;
				}
				else if( touch.phase==TouchPhase.MOVED)
				{
					var offsetX:int =  _worldPos.x + pos.x-_mouseDownPos.x ;
					var offsetY:int = _worldPos.y + pos.y-_mouseDownPos.y ;
					
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
			else if(e.getTouches(stage, TouchPhase.MOVED ).length>1)
			{
				//放大缩小
				var touches:Vector.<Touch> = e.getTouches(stage, TouchPhase.MOVED );
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point  = touchA.getLocation(stage);
				var previousPosA:Point = touchA.getPreviousLocation(stage);
				var currentPosB:Point  = touchB.getLocation(stage);
				var previousPosB:Point = touchB.getPreviousLocation(stage);
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				// scale
				var sizeDiff:Number = currentVector.length / previousVector.length;
				if(scaleX*sizeDiff>0.6 && scaleX*sizeDiff<2) {
					_endX = x;
					_endY = y ;
					scaleX *= sizeDiff;
					scaleY *= sizeDiff;
					if(x>0) x=0 ;
					else if(x<-GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH){
						x = -GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH ;
					}
					if(y>0) y=0 ;
					else if(y<-GameSetting.MAP_HEIGHT*scaleX+GameSetting.SCREEN_HEIGHT){
						y = -GameSetting.MAP_HEIGHT*scaleX+GameSetting.SCREEN_HEIGHT ;
					}
					_mouseDownPos.x = _endX = x;
					_mouseDownPos.y = _endY = y ;
				}
			}
		}
		
		private function addBg():void
		{
			var bg:Sprite = new Sprite() ;
			//地面
			var bgTexture:Texture = Assets.createTextureByName("bgFill1");
			bgTexture.repeat = true ;
			var img:Image = new Image(bgTexture);
			var factor:Number = GameSetting.MAP_WIDTH/GameSetting.MAP_HEIGHT ;
			var tile:int = GameSetting.MAP_WIDTH/256 ;
			var horizontally:int = tile ;
			var vertically:int = tile/factor ;
			img.setTexCoords(1,new Point(horizontally,0));
			img.setTexCoords(2,new Point(0,vertically));
			img.setTexCoords(3,new Point(horizontally,vertically));
			img.width = GameSetting.MAP_WIDTH ;
			img.height = GameSetting.MAP_HEIGHT ;
			bg.addChild( img );
			//树
			var treeTexture:Texture = Assets.createTextureByName("bgTree");
			treeTexture.repeat = true ;
			img = new Image(treeTexture);
			factor = GameSetting.MAP_WIDTH/GameSetting.MAP_HEIGHT ;
			tile = GameSetting.MAP_WIDTH/512 ;
			horizontally = tile ;
			vertically = 1 ;
			img.setTexCoords(1,new Point(horizontally,0));
			img.setTexCoords(2,new Point(0,vertically));
			img.setTexCoords(3,new Point(horizontally,vertically));
			img.width = GameSetting.MAP_WIDTH ;
			img.height = 218 ;
			bg.addChild( img );
			
			this.setBackGround( bg );
			bg.flatten();
		}
	
		
		private function changeWorldScale( value:Number , px:Number , py:Number ):void
		{
			if(scaleX*value>0.7 && scaleX*value<2) {
				_endX = x;
				_endY = y ;
				var m:Matrix = this.transformationMatrix ;
				m.tx -= px;
				m.ty -= py;
				m.scale(value, value);
				m.tx += px;
				m.ty += py;
				if(x>0) x=0 ;
				else if(x<-GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH){
					x = -GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH ;
				}
				if(y>0) y=0 ;
				else if(y<-GameSetting.MAP_HEIGHT*scaleX+GameSetting.SCREEN_HEIGHT){
					y = -GameSetting.MAP_HEIGHT*scaleX+GameSetting.SCREEN_HEIGHT ;
				}
				_mouseDownPos.x = _endX = x;
				_mouseDownPos.y = _endY = y ;
			}
		}
	}
}
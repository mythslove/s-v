package local
{
	import bing.starling.iso.SIsoGrid;
	import bing.starling.iso.SIsoObject;
	import bing.starling.iso.SIsoScene;
	import bing.starling.iso.SIsoWorld;
	
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.core.Starling;
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
		private var _zoomM:Matrix = new Matrix();
		private var _touchFinger1:Point = new Point();
		private var _middle:Point = new Point();
		
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
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			addMouseConfig();
			addBg();
			
			var gridScene:SIsoScene = new SIsoScene(GameSetting.GRID_SIZE);
			var grid:SIsoGrid = new SIsoGrid(_gridX,_gridZ,_size);
			gridScene.addChild(grid ) ;
			this.addScene(gridScene);
			
			buildingScene = new SIsoScene( _size ,_gridX,_gridZ );
			this.addScene(buildingScene);
			
			//添加筑
			var house:SIsoObject ;
			var bird:Birds ;
			for( var i:int = 0 ; i<13 ; ++i )
			{
				for( var j:int =0 ; j<13 ; ++j )
				{
					if(i%2==0){
						house = new SIsoObject(_size , 2 , 1 );
						house.nodeX = i*2 ;
						house.nodeZ = j*2 ;
						var img:Image = new Image( Assets.createTextureByName("house1") );
						img.touchable = false ;
						img.x = -59 ;
						img.y = -54 ;
						house.addChild(img);
						buildingScene.addIsoObject( house,false );
					}
					else
					{
						bird = new Birds(_size , 1 , 1 );
						bird.nodeX = i*2 ;
						bird.nodeZ = j*2 ;
						buildingScene.addIsoObject( bird,false );
					}
				}
			}
			buildingScene.sortAll();
			
			addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		private function onEnterFrameHandler( e:Event ):void
		{
			super.update();
			if(x!=_endX){
				x += ( _endX-x)*0.4 ;
			}
			if(y!=_endY){
				y += (_endY-y)*0.4 ;
			}
		}
		
		private function addMouseConfig():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouchedHandler); 
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL , onMouseWheel );
		}
		
		private function onMouseWheel( e:MouseEvent ):void
		{
			e.stopPropagation();
			var value:Number = e.delta>0?1.1:0.95 ;
			changeWorldScale(value,e.stageX , e.stageY);
		}
		
		private function onTouchedHandler( e:TouchEvent ):void
		{
			if(e.touches.length==1)
			{
				var touch:Touch = e.getTouch(stage); 
				var pos:Point = touch.getLocation(stage); 
				if(touch.phase==TouchPhase.BEGAN)
				{
					_touchFinger1.x = pos.x ;
					_touchFinger1.y = pos.y ;
					_endX = x ;
					_endY = y ;
				}
				else if( touch.phase==TouchPhase.MOVED)
				{
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
				changeWorldScale( sizeDiff , _middle.x , _middle.y );
			}
			else
			{
				_endX = x ;
				_endY = y ;
			}
		}
		
		private function changeWorldScale( value:Number , px:Number , py:Number ):void
		{
			if(scaleX*value>0.7 && scaleX*value<2 ) {
				
				_zoomM.identity() ;
				_zoomM.scale(scaleX,scaleY);
				_zoomM.translate( x , y );
				_zoomM.tx -= px;
				_zoomM.ty -= py;
				_zoomM.scale(value, value);
				_zoomM.tx += px;
				_zoomM.ty += py;
				
				this.scaleX = _zoomM.a ;
				this.scaleY = _zoomM.d ;
				this.x = _zoomM.tx ;
				this.y = _zoomM.ty ;
				
				if(x>0) x=0 ;
				else if(x<-GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH){
					x = -GameSetting.MAP_WIDTH*scaleX+GameSetting.SCREEN_WIDTH ;
				}
				if(y>0) y=0 ;
				else if(y<-GameSetting.MAP_HEIGHT*scaleX+GameSetting.SCREEN_HEIGHT){
					y = -GameSetting.MAP_HEIGHT*scaleX+GameSetting.SCREEN_HEIGHT ;
				}
			}
			_endX = x;
			_endY = y ;
		}
		
		
		private function addBg():void
		{
			var bg:Sprite = new Sprite() ;
			//地面
			var bgTexture:Texture = Assets.createTextureByName("bgFill1");
			bgTexture.repeat = true ;
			var img:Image = new Image(bgTexture);
			img.blendMode = BlendMode.NONE ;
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
		
	}
}
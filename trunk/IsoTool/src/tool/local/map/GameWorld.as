package tool.local.map
{
	import bing.iso.IsoGrid;
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	import bing.iso.IsoUtils;
	import bing.iso.IsoWorld;
	import bing.iso.Rhombus;
	import bing.utils.ContainerUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import tool.comm.Setting;
	import tool.local.vos.MapVO;
	
	public class GameWorld extends IsoWorld
	{
		public var mapVO:MapVO ;
		public var impactScene:IsoScene ;
		public var mouseContainer:IsoObject ;
		private var _isMove:Boolean ;
		private var _impactHash:Dictionary = new Dictionary();
		
		public function GameWorld(mapVO:MapVO)
		{
			this.mapVO=mapVO ;
			super(mapVO.xSpan,mapVO.zSpan,Setting.SIZE);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(-1000,-1000,6000,6000);
			this.graphics.endFill() ;
			
			setBackGround( new Bitmap(mapVO.bg));
			var gridScene:IsoScene = new IsoScene(Setting.SIZE);
			var grid:IsoGrid = new IsoGrid(mapVO.xSpan,mapVO.zSpan,Setting.SIZE);
			grid.render();
			grid.cacheAsBitmap = true ;
			gridScene.addChild(grid);
			addScene(gridScene);
			
			impactScene = new IsoScene(Setting.SIZE );
			impactScene.alpha = 0.4;
			addScene(impactScene);
			
			mouseContainer = new IsoObject(Setting.SIZE,1,1) ;
			mouseContainer.alpha=0.6 ;
			gridScene.addIsoObject(mouseContainer) ;
			
			this.panTo(mapVO.offsetX , mapVO.offsetY );
			
			configListeners();
		}
		
		/**
		 * 侦听事件  
		 */		
		protected function configListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP , onMouseUpHandler );
			this.addEventListener(MouseEvent.ROLL_OUT , onMouseRollOut);
			this.addEventListener(MouseEvent.RIGHT_CLICK , onRightClickHandler);
		}
		
		protected function onRightClickHandler(e:MouseEvent):void
		{
			Setting.isAddImpact = false ;
			ContainerUtil.removeChildren(mouseContainer);
		}
		/**
		 * 鼠标移出地图区域时 
		 * @param e
		 */		
		protected function onMouseRollOut(e:MouseEvent):void
		{
			this.stopDrag();
			_isMove = false ;
		}
		
		/**
		 * 鼠标按下 
		 * @param e
		 */		
		protected function onMouseDownHandler(e:MouseEvent):void
		{
			if(e.altKey || mouseContainer.numChildren==0)
			{
				this.startDrag( false);
			}
		}
		
		/**
		 * 鼠标按下弹起时 
		 * @param e
		 */		
		protected function onMouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
			if(!_isMove){
				addRhombus(e);
			}
			_isMove = false ;
		}
		
		/**
		 * 添加菱形到场景上
		 * @param e
		 */		
		protected function addRhombus(e:MouseEvent):void
		{
			if(Setting.isAddImpact)
			{
				var obj:IsoObject ;
				 if( e.ctrlKey) //删除
				{
					obj = _impactHash[mouseContainer.x+"-"+mouseContainer.z] ;
					if(obj){
						obj.setWalkable( true , mapVO.gridData );
						delete _impactHash[obj.x+"-"+obj.z] ;
						impactScene.removeIsoObject( obj );
					}
				}
				 else if(mouseContainer.getWalkable(mapVO.gridData))
				{
					obj = new IsoObject(Setting.SIZE,1,1);
					obj.addChild( new Rhombus(Setting.SIZE));
					obj.x = mouseContainer.x;
					obj.z = mouseContainer.z ;
					obj.setWalkable( false , mapVO.gridData );
					impactScene.addIsoObject( obj ,false );
					_impactHash[obj.x+"-"+obj.z] = obj ;
				}
			}
		}
		
		/**
		 * 鼠标移动时 
		 * @param e
		 */		
		protected function onMouseMoveHandler(e:MouseEvent):void
		{
			if(e.buttonDown)_isMove = true ;
			
			var xx:int = (e.stageX-this.x)/scaleX - this.sceneLayerOffsetX ;
			var yy:int = (e.stageY -this.y-Setting.SIZE)/scaleX - this.sceneLayerOffsetY;
			
			var p:Point = IsoUtils.screenToIsoGrid( Setting.SIZE,xx,yy);
			
			var dx:int = p.x*Setting.SIZE ;
			var dz:int = p.y*Setting.SIZE ;
			mouseContainer.x = dx;
			mouseContainer.z = dz;
			
			if(e.buttonDown && !e.altKey){
				addRhombus(e);
			}
		}
		
		public function showImpact():void
		{
			impactScene.clear();
			var obj:IsoObject ;
			for( var i:int = 0 ; i<mapVO.xSpan ; ++i)
			{
				for( var j:int = 0 ; j<mapVO.zSpan ; ++j)
				{
					if(!mapVO.gridData.getNode( i,j).walkable){
						obj = new IsoObject(Setting.SIZE,1,1);
						obj.addChild( new Rhombus(Setting.SIZE));
						obj.nodeX = i ;
						obj.nodeZ = j;
						impactScene.addIsoObject( obj ,false );
						_impactHash[obj.x+"-"+obj.z] = obj ;
					}
				}
			}
		}
	}
}
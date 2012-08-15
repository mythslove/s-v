package game.elements.cell
{
	import bing.tiled.IsoMapHelp;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import game.global.GameData;
	import game.mvc.base.GameContext;
	import game.mvc.model.MapDataModel;
	import game.mvc.model.vo.MapVO;
	
	public class BaseItem extends Sprite
	{
		public var item:Bitmap = new Bitmap();
		private var _isOnScreen:Boolean=true ; //是否在可视区
		
		public function BaseItem()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false ;
			if(stage) addedToStageHandler( null ) ;
			else addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addedToStage();
		}
		
		protected function addedToStage():void
		{
			addChild(item);
		}
		
		public function update():void
		{
			
		}
		
		public function beforeUpdate():void 
		{
			
		}
		
		public function afterUpdate():void 
		{
			
		}
		
		public function addContextListeners( type:String , listener:Function):void 
		{
			GameContext.instance.addContextListener(type,listener);
		}
		
		public function dispatchContextEvent( e:Event ):void 
		{
			GameContext.instance.dispatchContextEvent( e );
		}
		
		public function removeContextEvent( type:String , listener:Function ):void 
		{
			GameContext.instance.removeContextListener( type ,listener );
		}
		
		public function onEnterFrame():void
		{
			this.checkOnScreen() ;
			beforeUpdate();
			update();
			afterUpdate();
		}
		
		/**
		 * 设置网格坐标位置 
		 * @param txPoint 网格坐标
		 */		
		public function setTilePoint( tx:int , ty:int  ):void
		{
			var mapVO:MapVO = MapDataModel.instance.currentMapVO;
			var point:Point = IsoMapHelp.getPixelPoint(mapVO.tileWidth , mapVO.tileHeight , tx,ty );
			this.x = point.x+mapVO.tileWidth*0.5 ;
			this.y = point.y+mapVO.tileHeight*0.5 ;
		}
		
		/**
		 * 获得此对象当前的网格坐标位置 
		 * @return 
		 */		
		public function get tilePoint():Point
		{
			var mapVO:MapVO = MapDataModel.instance.currentMapVO ;
			return IsoMapHelp.getCellPoint( mapVO.tileWidth , mapVO.tileHeight , x , y );
		}
		
		/**
		 * 计算是否在可见屏幕类 
		 * @return 
		 */		
		private function checkOnScreen():void
		{
			if( x>= GameData.screenRect.x-item.width && y>=GameData.screenRect.y-item.height
				&& x <=GameData.screenRect.x+GameData.screenRect.width+item.width
				&& y<=GameData.screenRect.y+GameData.screenRect.height+item.height )
			{
				_isOnScreen = true ;
			}
			else
			{
				_isOnScreen = false ;
			}
		}
		
		/**
		 * 判断点是否和此对象碰撞 
		 * @param px
		 * @param py
		 * @return 
		 */		
		public function checkHitPoint( px:Number,py:Number ):Boolean
		{
			if(_isOnScreen && item.bitmapData)
			{
				if( item.bitmapData.hitTest(new Point(item.x+x,item.y+y),1,new Point(px,py)) )
				{
					return true ;
				}
			}
			return false ;
		}
		
		/**
		 * 是否在可见屏幕上 
		 * @return 
		 */		
		public function get isOnScreen():Boolean
		{
			return _isOnScreen ;
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			item = null ;
		}
	}
}
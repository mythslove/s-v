package bing.starling.iso
{
	import flash.geom.Point;
	
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SIsoWorld extends Sprite implements IAnimatable
	{
		protected var _gridX:int ;
		protected var _gridZ:int ;
		protected var _size:int ;
		
		protected var _backGround:DisplayObject ;
		protected var _scenesLayer:Sprite = new Sprite();
		protected var _scenes:Vector.<SIsoScene> = new Vector.<SIsoScene>();
		
		/** 返回所有的场景  */
		public function get scenes():Vector.<SIsoScene>
		{
			return _scenes ;
		}
		
		public function SIsoWorld(gridX:int , gridZ:int ,size:int )
		{
			super();
			this._gridX = gridX ;
			this._gridZ = gridZ ;
			this._size = size ;
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		protected function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addChild(_scenesLayer);
		}
		
		
		/********************************************************
		 * 添加场景 
		 * ********************************************************/
		public function addScene( scene:SIsoScene ):SIsoScene
		{
			_scenes.push( scene);
			_scenesLayer.addChild( scene );
			return scene ;
		}
		
		
		
		
		
		/********************************************************
		 * 移动位置
		 * ********************************************************/
		public function panTo( x:Number , y:Number ):void
		{
			this._scenesLayer.x = x ;
			this._scenesLayer.y = y;
		}
		/**
		 * 场景偏移X 
		 * @return 
		 */		
		public function get sceneLayerOffsetX():Number
		{
			return _scenesLayer.x;
		}
		/**
		 *  场景偏移Y
		 * @return 
		 */		
		public function get sceneLayerOffsetY():Number
		{
			return _scenesLayer.y;
		}
		
		
		
		
		/********************************************************
		 * IsoWord坐标转成正确的网格坐标
		 * ********************************************************/
		public function pixelPointToGrid( px:Number , py:Number , offsetX:Number=0 , offsetY:Number=0 ):Point
		{
			var xx:int = (px-x)/scaleX -sceneLayerOffsetX - offsetX ;
			var yy:int = (py-y)/scaleY - sceneLayerOffsetY-offsetY;
			return SIsoUtils.screenToIsoGrid( _size,xx,yy);
		}
		
		
		
		/********************************************************
		 * stage全局坐标转成IsoWorld场景像素坐标
		 * ********************************************************/
		public function globalPointToWorld( px:Number , py:Number):Point
		{
			var xx:int = (px-x)/scaleX -sceneLayerOffsetX  ;
			var yy:int = (py-y)/scaleY - sceneLayerOffsetY ;
			return new Point(xx,yy);
		}
		
		
		/********************************************************
		 * 设置背景
		 * ********************************************************/
		public function setBackGround( ground:DisplayObject ):void
		{
			if(_backGround && this.contains( _backGround) ){
				this.removeChild( _backGround );
			}
			_backGround = ground ;
			addChildAt(_backGround , 0 );
		}
		
		
		/********************************************************
		 * 遍历所有IsoScene，并调用它的update方法
		 * ********************************************************/
		public function advanceTime(passedTime:Number):void
		{
			for each( var scene:SIsoScene in _scenes )
			{
				scene.advanceTime(passedTime) ;
			}
		}
		
		/********************************************************
		 * 遍历所有IsoScene，并调用它的dispose方法
		 * ********************************************************/
		public function sdispose():void
		{
			for each(var scene:SIsoScene in _scenes){
				scene.dispose();
			}
			_scenes = null ;
		}
		
		/********************************************************
		 * 遍历所有IsoScene，并调用它的clear方法
		 * 清空iso世界的所有isoObject对象
		 * ********************************************************/
		public function clear():void
		{
			for each(var scene:SIsoScene in _scenes){
				scene.clear() ;
			}
		}
	}
}
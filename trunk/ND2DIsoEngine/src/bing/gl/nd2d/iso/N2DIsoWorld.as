package bing.gl.nd2d.iso
{
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	
	import flash.events.Event;
	
	public class N2DIsoWorld extends Node2D
	{
		protected var _gridX:int ;
		protected var _gridZ:int ;
		protected var _size:int ;
		protected var _w :Number ;
		protected var _h:Number;
		
		protected var _backGround:N2DIsoSprite ;
		protected var _scenesLayer:N2DIsoSprite = new N2DIsoSprite();
		protected var _scenes:Vector.<N2DIsoScene> = new Vector.<N2DIsoScene>();
		
		/** 返回所有的场景  */
		public function get scenes():Vector.<N2DIsoScene>
		{
			return _scenes ;
		}
		
		public function N2DIsoWorld(width:Number, height:Number ,  gridX:int , gridZ:int ,size:int )
		{
			super();
			this._gridX = gridX ;
			this._gridZ = gridZ ;
			this._size = size ;
			this._w  = width ;
			this._h = height ;
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
		public function addScene( scene:N2DIsoScene ):N2DIsoScene
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
		 * 设置背景
		 * ********************************************************/
		public function setBackGround( ground:N2DIsoSprite ):void
		{
			if(_backGround && _backGround.parent){
				_backGround.parent.removeChild( _backGround );
			}
			_backGround = ground ;
			addChildAt(_backGround , 0 );
		}
		
		
		/********************************************************
		 * 遍历所有IsoScene，并调用它的update方法
		 * ********************************************************/
		public function update():void
		{
			for each( var scene:N2DIsoScene in _scenes )
			{
				scene.update() ;
			}
		}
		
		/********************************************************
		 * 遍历所有IsoScene，并调用它的dispose方法
		 * ********************************************************/
		override public function dispose():void
		{
			super.dispose();
			for each(var scene:N2DIsoScene in _scenes){
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
			for each(var scene:N2DIsoScene in _scenes){
				scene.clear() ;
			}
		}
	}
}
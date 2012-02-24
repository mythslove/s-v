package bing.gl.nd2d.iso
{
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.display.World2D;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class N2DIsoWorld extends World2D
	{
		protected var _gridX:int ;
		protected var _gridZ:int ;
		protected var _size:int ;
		protected var _w :Number ;
		protected var _h:Number;
		
		protected var _backGround:Sprite2D;
		protected var _scenes:Vector.<N2DIsoScene> = new Vector.<N2DIsoScene>();
		private var _defaultScene:Scene2D ;
		
		/** 返回所有的场景  */
		public function get scenes():Vector.<N2DIsoScene>
		{
			return _scenes ;
		}
		
		public function N2DIsoWorld( size:int , gridX:int , gridZ:int , renderMode:String, 
									 frameRate:uint = 60, bounds:Rectangle = null, stageID:uint = 0 )
		{
			super(renderMode, frameRate, bounds);
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
			_defaultScene = new Scene2D();
			this.setActiveScene( _defaultScene );
		}
		
		
		/********************************************************
		 * 添加场景 
		 * ********************************************************/
		public function addScene( scene:N2DIsoScene ):N2DIsoScene
		{
			_scenes.push( scene);
			_defaultScene.addChild( scene );
			return scene ;
		}
		
		/********************************************************
		 * 设置背景
		 * ********************************************************/
		public function setBackGround( ground:Sprite2D ):void
		{
			if(_backGround ){
				_backGround.parent.removeChild( _backGround );
			}
			_backGround = ground ;
			_defaultScene.addChildAt(_backGround , 0 );
		}
		
		/********************************************************
		 * 移动位置
		 * ********************************************************/
		public function panTo( x:Number , y:Number ):void
		{
			_defaultScene.x = x ;
			_defaultScene.y = y;
		}
		/**
		 * 场景偏移X 
		 * @return 
		 */		
		public function get sceneLayerOffsetX():Number
		{
			return _defaultScene.x;
		}
		/**
		 *  场景偏移Y
		 * @return 
		 */		
		public function get sceneLayerOffsetY():Number
		{
			return _defaultScene.y;
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
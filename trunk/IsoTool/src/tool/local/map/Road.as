package tool.local.map
{
	import bing.iso.IsoObject;
	import bing.utils.ContainerUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import tool.comm.Setting;
	import tool.local.vos.RoadResVO;
	
	public class Road extends IsoObject
	{
		private var _skin:Bitmap ;
		private var itemLayer:Sprite;
		private var _currentAlias:String; //当前资源的名称
		private var _roadResVO:RoadResVO ;
		
		public function get currentAlias():String{
			return _currentAlias ;
		}
		
		public function Road( name:String , roadResVO:RoadResVO )
		{
			super(Setting.SIZE);
			this.name = name ;
			this._roadResVO = roadResVO ;
			addEventListener(Event.ADDED_TO_STAGE ,addedHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedHandler);
		}
		
		protected function addedHandler(e:Event):void
		{
			_currentAlias = name ;
			itemLayer = new Sprite();
			addChild(itemLayer);
			show();
		}
		
		/**
		 * 显示图像
		 */		
		private function show():void
		{
			ContainerUtil.removeChildren(itemLayer);
			var bmd:BitmapData= _roadResVO.bmds[_currentAlias] ;
			_skin = new Bitmap( bmd  );
			itemLayer.addChild(_skin);
			_skin.x = _roadResVO.offsetXs[_currentAlias] ;
			_skin.y= _roadResVO.offsetYs[_currentAlias] ;
		}
		
		/**
		 * 更新UI的方向 
		 * @param position
		 */		
		public function updateUI( position:String):void
		{
			_currentAlias = name+position;
			show();
		}
		
		
		private function removedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE ,addedHandler );
			removeEventListener(Event.REMOVED_FROM_STAGE , removedHandler);
			_roadResVO = null ;
		}
	}
}
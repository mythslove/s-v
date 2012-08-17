package game
{
	import bing.iso.IsoObject;
	import bing.utils.ContainerUtil;
	
	import comm.GameSetting;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class Road extends IsoObject
	{
		private var _skin:Bitmap ;
		private var itemLayer:Sprite;
		private var _currentUrl:String ; //当前资源的路径
		private var _currentAlias:String; //当前资源的名称
		private var _alias:String ;
		private var _url:String ;
		
		public function get currentAlias():String{
			return _currentAlias ;
		}
		
		public function Road(url:String , alias:String )
		{
			super(GameSetting.SIZE);
			_alias = alias ;
			_url = url ;
			addEventListener(Event.ADDED_TO_STAGE ,addedHandler );
		}
		
		protected function addedHandler(e:Event):void
		{
			_currentAlias = _alias;
			_currentUrl = _url+_currentAlias+".png" ;
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
			var bmd:BitmapData= _skin?_skin.bitmapData:null ;
			_skin = new Thumb( _currentAlias , _currentUrl , 1 , bmd );
			itemLayer.addChild(_skin);
			_skin.x = -GameSetting.SIZE-2;
			_skin.y=-2;
		}
		
		/**
		 * 更新UI的方向 
		 * @param position
		 */		
		public function updateUI( position:String):void
		{
			_currentAlias = _alias+position;
			_currentUrl = _url+_currentAlias+".png" ;
			var file:File = new File(_currentUrl);
			if(!file.exists){
				_currentAlias= _alias;
				_currentUrl = _url+_currentAlias+".png" ;
			}
			show();
		}
		
	}
}
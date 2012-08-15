package game.elements.ground
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import game.global.GameData;
	import game.mvc.model.MapDataModel;

	/**
	 * 地图分块的块 
	 * @author zzhanglin
	 */	
	public class Block extends Bitmap
	{
		private var _rect:Rectangle ;
		private var _loader:Loader ;
		private var _blockBmp:Bitmap ;
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function Block( rect:Rectangle , bitmapData:BitmapData=null)
		{
			super(bitmapData, "auto", false );
			this._rect = rect ;
			this.x = _rect.x ;
			this.y = _rect.y ;
		}
		
		public function init():void 
		{
			if(!bitmapData && !_loader ){
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , blockBmpLoadedHandler );
				var url:String=GameData.baseURL+"map/"+MapDataModel.instance.currentMapVO.alias+"/blocks/"+this.name+".jpg";
				_loader.load( new URLRequest(url));
			}
		}
		
		private function blockBmpLoadedHandler(e:Event):void 
		{
			e.stopPropagation();
			_loader.removeEventListener(Event.COMPLETE , blockBmpLoadedHandler );
			_blockBmp = _loader.content as Bitmap ;
			this.bitmapData = _blockBmp.bitmapData ;
			
			_blockBmp = null ;
			_loader = null ;
		}
		
		public function dispose():void 
		{
			if(!_loader)
			{
				_loader.unloadAndStop();
				_loader.removeEventListener(Event.COMPLETE , blockBmpLoadedHandler );
				_loader = null ;
			}
			if(this.bitmapData){
				this.bitmapData.dispose();
			}
			
			_rect = null ;
		}
	}
}
package bing.tiled
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	public class TiledLoader extends EventDispatcher
	{
		private var _loader:TilesetLoader ;
		private var _tilesets:Vector.<Tileset> ;
		private var _count:int =0  ;
		private var _set:Tileset ;
		
		public function TiledLoader( tileset:Vector.<Tileset>)
		{
			_tilesets = tileset ;
		}
		
		public function load():void 
		{
			_set = _tilesets[_count] ;
			_loader = new TilesetLoader(_set);
			_loader.addEventListener(Event.COMPLETE , loaded );
			_loader.load();
		}
		
		private function loaded(e:Event):void 
		{
			_loader.removeEventListener(Event.COMPLETE , loaded );
			_loader.dispose() ;
			_count++;
			if(_count<_tilesets.length)
			{
				var proEvt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
				proEvt.bytesLoaded = _count+1;
				proEvt.bytesTotal = _tilesets.length ;
				this.dispatchEvent( proEvt);
				load();
			}
			else
			{
				this.dispatchEvent(new Event(Event.COMPLETE ));
			}
		}
		
		public function dispose():void 
		{
			_loader.dispose() ;
			_loader = null ;
			if(_tilesets)
			{
				for each(var tileset:Tileset in _tilesets)
				{
					tileset.dispose();
				}
			}
			_tilesets = null ;
			_set = null ;
		}
	}
}

/////////////////////////////////////////

import bing.tiled.Tileset;
import bing.utils.SystemUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;

[Event(name="complete",type="flash.events.Event")]
class TilesetLoader extends EventDispatcher
{
	private var _loader:Loader ;
	private var _tileset:Tileset ;
	private var _imgs:Vector.<BitmapData> = new Vector.<BitmapData>();
	
	public function TilesetLoader(tileset:Tileset)
	{
		_tileset = tileset ;
	}
	
	public function load():void 
	{
		_loader = new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loaded );
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , loadError );
		_loader.load( new URLRequest(_tileset.imgUrl)) ;
	}
	
	private function loadError(e:IOErrorEvent):void 
	{
		SystemUtil.debug(e.text);
	}
	
	private function loaded(e:Event):void 
	{
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE , loaded );
		var bmp:Bitmap =  e.target.content as Bitmap ;
		var bmd:BitmapData ;
		
		const WID:int = Math.floor( bmp.width/_tileset.tilewidth )*_tileset.tilewidth ;
		const HET:int = Math.floor( bmp.height/_tileset.tileheight )*_tileset.tileheight ;
		for( var i:int = 0 ; i<HET  ; i+=_tileset.tilewidth+ _tileset.margin )
		{
			for( var j:int = 0 ; j<WID ; j+=_tileset.tileheight+_tileset.spacing  )
			{
				bmd = new BitmapData(_tileset.tilewidth,_tileset.tileheight);
				bmd.copyPixels( bmp.bitmapData , new  Rectangle(j+_tileset.margin ,i+_tileset.spacing , bmd.width ,bmd.height ) ,new Point ,null,null,true );
				_imgs.push(bmd);
			}
		}
		_tileset.bmds = _imgs ;
		
		bmp.bitmapData.dispose() ;
		bmp=  null ;
		this.dispatchEvent(new Event(Event.COMPLETE ));
	}
	
	public function dispose():void 
	{
		if(_loader)
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE , loaded );
			_loader.unloadAndStop();
		}
		_loader = null ;
		_imgs = null ;
	}
}
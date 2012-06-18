package app.core
{
	import app.comm.Data;
	import app.comm.Setting;
	import app.core.base.BaseView;
	import app.core.pen.ColorPen;
	import app.util.PopUpManager;
	import app.view.SmallLoading;
	
	import bing.components.ext.ScrollCanvas;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class BaseGameScene extends BaseView
	{
		protected var _pens:ScrollCanvas ; //笔的容器
		protected var _selectedPen:ColorPen ; //当前选择的笔
		
		protected var _picBmp:Bitmap = new Bitmap() ; //最后显示的图片
		protected var _picTempBmd:BitmapData ;  //副本
		protected var _lineBmp:Bitmap ; //只有线条的图片
		protected var _lineMaskBmd:BitmapData ; //颜色分区图片
		protected var _canvas:Shape = new Shape()  ; //矢量画板
		
		protected var _loading:SmallLoading ;
		protected var _container:Sprite; 
		protected var _picName:String ;
		private var _loadedCount:int ;
		
		public function BaseGameScene( picName:String  )
		{
			super();
			mouseEnabled = false ;
			this._picName = picName ;
		}
		
		override protected function addedToStage():void
		{
			_container = new Sprite();
			_container.mouseChildren = false ;
			addChild(_container);
			if(_picName){
				var loader:Loader = new Loader();
				loader.name="pic" ;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loadedHandler );
				loader.load( new URLRequest("res/"+Data.currentType+"/"+_picName+".png"));
				loader = new Loader();
				loader.name="mask" ;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loadedHandler );
				loader.load( new URLRequest("res/"+Data.currentType+"/"+_picName+"_mask.gif"));
				_loadedCount = 2 ;
				_loading = new SmallLoading();
				_loading.x = Setting.SCREEN_WID>>1 ;
				_loading.y = Setting.SCREEN_HET>>1 ;
				PopUpManager.instance.addPopUp( _loading );
			}
			createPens();
			_pens.addEventListener(MouseEvent.CLICK , onPenClickHandler );
		}
		
		private function loadedHandler( e:Event ):void
		{
			_loadedCount-- ;
			var loader:Loader = e.target.loader as Loader ;
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE , loadedHandler );
			if(loader.name=="pic")  _lineBmp = loader.content as Bitmap;
			else _lineMaskBmd = ( loader.content as Bitmap).bitmapData ;
			if(_loadedCount==0){
				//下载完成
				PopUpManager.instance.removePopUp( _loading );
				_loading.stop();
				_loading = null ;
				//初始化
				_container.addChild(_picBmp);
				_container.addChild( _lineBmp );
				_picBmp.bitmapData = new BitmapData(_lineBmp.width,_lineBmp.height);
				_picTempBmd = new BitmapData(_lineBmp.width,_lineBmp.height);
			}
		}
		
		private function onPenClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(e.target is ColorPen)
			{
				if(_selectedPen) _selectedPen.selected( false );
				_selectedPen = e.target as ColorPen ;
				_selectedPen.selected( true );
			}
		}
		
		protected function createPens():void
		{
			var colors:Vector.<uint> = Data.penColors ;
			var len:int = colors.length ;
			_pens = new ScrollCanvas();
			_pens.row = len ;
			_pens.col=1;
			_pens.rowGap = 60 ;
			_pens.x=-50 ;
			addChild(_pens);
			_pens.init(160 , Setting.SCREEN_HET , ScrollCanvas.SLIDER_TYPE_V , false) ;
			
			var renders:Array = [] ;
			var pen:ColorPen ;
			for( var i:int = 0 ; i<len ; ++i)
			{
				pen = new ColorPen( colors[i]);
				pen.y=i*60 ;
				renders.push( pen);
			}
			_pens.renders = renders ;
			_selectedPen = renders[0] as ColorPen;
			_selectedPen.selected( true );
		}
		
		override protected function removedFromStage():void
		{
			_pens.removeEventListener(MouseEvent.CLICK , onPenClickHandler );
			_lineMaskBmd.dispose() ;
			_lineMaskBmd = null ;
			_lineBmp.bitmapData.dispose();
			_lineBmp = null ;
			_pens = null ;
			_selectedPen = null ;
		}
	}
}
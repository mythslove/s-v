package app.core
{
	import app.comm.Data;
	import app.comm.Setting;
	import app.core.base.BaseView;
	import app.core.pen.ColorPen;
	
	import bing.components.ext.ScrollCanvas;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BaseGameScene extends BaseView
	{
		protected var _pens:ScrollCanvas ; //笔的容器
		protected var _selectedPen:ColorPen ; //当前选择的笔
		protected var _picMaskBmd:BitmapData ;
		protected var _picBmp:Bitmap ;
		
		public function BaseGameScene( picBmp:Bitmap ,  maskBmd:BitmapData)
		{
			super();
			mouseEnabled = false ;
			this._picBmp = picBmp ;
			this._picMaskBmd = maskBmd ;
		}
		
		override protected function addedToStage():void
		{
			createPens();
			_pens.addEventListener(MouseEvent.CLICK , onPenClickHandler );
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
			_pens.init(154 , Setting.SCREEN_HET , ScrollCanvas.SLIDER_TYPE_V , false) ;
			
			var renders:Array = [] ;
			var pen:ColorPen ;
			for( var i:int = 0 ; i<len ; ++i)
			{
				pen = new ColorPen( colors[i]);
				pen.y=i*60 ;
				renders.push( pen);
			}
			_selectedPen = renders[0] as ColorPen;
			_selectedPen.selected( true );
			_pens.renders = renders ;
		}
		
		override protected function removedFromStage():void
		{
			_pens.removeEventListener(MouseEvent.CLICK , onPenClickHandler );
			_picMaskBmd.dispose() ;
			_picMaskBmd = null ;
			_picBmp.bitmapData.dispose();
			_picBmp = null ;
			_pens = null ;
			_selectedPen = null ;
		}
	}
}
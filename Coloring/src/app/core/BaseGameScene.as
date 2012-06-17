package app.core
{
	import app.comm.Data;
	import app.core.base.BaseView;
	import app.core.pen.ColorPen;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BaseGameScene extends BaseView
	{
		protected var _pens:Sprite ; //笔的容器
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
			_pens = new Sprite();
			_pens.x=-60 ;
			addChild(_pens);
			var colors:Vector.<uint> = Data.penColors ;
			var len:int = colors.length ;
			var pen:ColorPen ;
			for( var i:int = 0 ; i<len ; ++i)
			{
				pen = new ColorPen( colors[i]);
				pen.y=i*60 ;
				_pens.addChild( pen);
			}
			_selectedPen = _pens.getChildAt(0) as ColorPen;
			_selectedPen.selected( true );
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
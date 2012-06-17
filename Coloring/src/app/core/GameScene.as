package app.core
{
	import app.comm.Data;
	import app.core.base.BaseView;
	import app.core.pen.ColorPen;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class GameScene extends BaseView
	{
		private var _pens:Sprite ; //笔的容器
		private var _selectedPen:ColorPen ; //当前选择的笔
		
		public function GameScene()
		{
			super();
			mouseEnabled = false ;
		}
		
		override protected function addedToStage():void
		{
			createPens();
			configListeners();
		}
		
		private function configListeners():void
		{
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
		
		private function createPens():void
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
		}
	}
}
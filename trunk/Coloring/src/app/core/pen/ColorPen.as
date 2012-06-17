package app.core.pen
{
	import app.comm.Resource;
	import app.core.base.BaseView;
	
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	
	public class ColorPen extends BaseView
	{
		private var _penBmp:Bitmap ;
		public var color:uint ;
		
		public function ColorPen( color:uint )
		{
			super();
			mouseChildren = false ;
			this.color = color; 
		}
		
		override protected function addedToStage():void
		{
			_penBmp= Resource.getPenBmp( color );
			addChild(_penBmp);
		}
		
		public function selected( value:Boolean ):void
		{
			if( value) x = 50 ;
			else x = 0 ;
		}
		
		override protected function removedFromStage():void
		{
			_penBmp.bitmapData.dispose() ;
			_penBmp = null ;
		}
	}
}
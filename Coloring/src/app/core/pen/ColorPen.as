package app.core.pen
{
	import app.comm.Resource;
	import app.core.base.BaseView;
	import app.util.ResourceUtil;
	
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.utils.getDefinitionByName;
	
	public class ColorPen extends BaseView
	{
		private var _penBmp:Bitmap ;
		private var _penMaskBmp:Bitmap;
		public var color:uint ;
		
		public function ColorPen( color:uint )
		{
			super();
			mouseChildren = false ;
			this.color = color; 
		}
		
		override protected function addedToStage():void
		{
			_penBmp= new Bitmap(ResourceUtil.instance.pen) ;
			var colorTf:ColorTransform = _penBmp.transform.colorTransform ;
			colorTf.color = color ;
			_penBmp.transform.colorTransform = colorTf ;
			addChild(_penBmp);
			
			_penMaskBmp = new Bitmap(ResourceUtil.instance.penMask) ;
			addChild(_penMaskBmp);
		}
		
		public function selected( value:Boolean ):void
		{
			if( value) x = 50 ;
			else x = 0 ;
		}
		
		override protected function removedFromStage():void
		{
			_penBmp = null ;
			_penMaskBmp = null ;
		}
	}
}
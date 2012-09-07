package local.map.cell
{
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	
	import local.map.cell.BaseAnimObject;
	import local.vo.BitmapAnimResVO;
	
	public class BuildingObject extends InteractivePNG
	{
		private var _bavos:Vector.<BitmapAnimResVO> ;
		private var _tinyBmp:Bitmap ;
		private var _tinyAlpha:Number = 0.05 ;
		
		public function BuildingObject( bavos:Vector.<BitmapAnimResVO> )
		{
			super();
			mouseChildren = false ;
			this._bavos = bavos ;
			init();
		}
		
		private function init():void
		{
			var len:int = _bavos.length ;
			var animObj:BaseAnimObject ;
			var vo:BitmapAnimResVO ;
			for( var i:int = 0 ; i <len ; ++i ){
				vo = _bavos[i] ;
				animObj = new BaseAnimObject( vo );
				animObj.x = vo.offsetX ;
				animObj.y = vo.offsetY ;
				addChild(animObj);
				if(i==0){
					super._bitmapForHitDetection = animObj ;
				}
			}
			_tinyBmp = new Bitmap( _bavos[0].bmds[0] );
			var transform:ColorTransform = _tinyBmp.transform.colorTransform;
			transform.color = 0xffffff;
			_tinyBmp.transform.colorTransform = transform ;
			_tinyBmp.x =  _bavos[0].offsetX ;
			_tinyBmp.y =  _bavos[0].offsetY ;
			_tinyBmp.visible=false ;
			addChild(_tinyBmp);
		}
		
		public function update():void
		{
			for( var i:int = 0 ; i<numChildren ; ++i){
				if(getChildAt(i) is BaseAnimObject ){
					( getChildAt(i) as BaseAnimObject ).update() ;
				}
			}
			if(_tinyBmp.visible){
				_tinyBmp.alpha += _tinyAlpha;
				if(_tinyBmp.alpha>1){
					_tinyAlpha = -0.05 ;
				}else if(_tinyBmp.alpha<-0.5){
					_tinyAlpha = 0.05 ;
				}
			}
		}
		
		public function flash( value:Boolean ):void
		{
			_tinyBmp.visible=value ;
			if(value){
				_tinyBmp.alpha=0.5;
				_tinyAlpha = 0.1 ;
			}
		}
		
		public function dispose():void
		{
			for( var i:int = 0 ; i<numChildren ; ++i){
				if(getChildAt(i) is BaseAnimObject ){
					( getChildAt(i) as BaseAnimObject ).dispose() ;
				}
			}
			_bavos = null ;
			_tinyBmp = null ;
			super.disableInteractivePNG() ;
		}
	}
}
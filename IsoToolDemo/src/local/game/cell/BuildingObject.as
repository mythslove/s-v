package local.game.cell
{
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import local.vos.BitmapAnimResVO;
	
	public class BuildingObject extends InteractivePNG
	{
		private var _bavos:Vector.<BitmapAnimResVO> ;
		public var container:Sprite ;
		public var roads:Vector.<Point> ;
		public var tinyBmp:Bitmap ;
		private var _tinyAlpha:Number = 0.1 ;
		
		public function BuildingObject( bavos:Vector.<BitmapAnimResVO> )
		{
			super();
			mouseChildren = false ;
			this._threshold = 10 ;
			this._bavos = bavos ;
			init();
		}
		
		private function init():void
		{
			var len:int = _bavos.length ;
			var animObj:AnimObject ;
			var vo:BitmapAnimResVO ;
			for( var i:int = 0 ; i <len ; ++i ){
				vo = _bavos[i] ;
				if( vo.roads ){
					roads = vo.roads ;
					container = new Sprite();
					addChild(container);
				}
				else
				{
					animObj = new AnimObject( vo );
					animObj.x = vo.offsetX ;
					animObj.y = vo.offsetY ;
					addChild(animObj);
					if(i==0){
						super._bitmapForHitDetection = animObj ;
					}
				}
			}
			
			tinyBmp = new Bitmap( _bavos[0].bmds[0] );
			var transform:ColorTransform = tinyBmp.transform.colorTransform;
			transform.color = 0xffffff;
			tinyBmp.transform.colorTransform = transform ;
			tinyBmp.x =  _bavos[0].offsetX ;
			tinyBmp.y =  _bavos[0].offsetY ;
			tinyBmp.visible=false;
			addChild(tinyBmp);
		}
		
		public function update():void
		{
			for( var i:int = 0 ; i<numChildren ; ++i){
				if(getChildAt(i) is AnimObject ){
					( getChildAt(i) as AnimObject ).update() ;
				}
			}
			if(tinyBmp.visible){
				tinyBmp.alpha += _tinyAlpha;
				if(tinyBmp.alpha>1){
					_tinyAlpha = -0.1 ;
				}else if(tinyBmp.alpha<-0.5){
					_tinyAlpha = 0.1 ;
				}
			}
		}
		
		public function flash( value:Boolean ):void
		{
			tinyBmp.visible=value ;
			if(value){
				tinyBmp.alpha=0.5;
				_tinyAlpha = 0.1 ;
			}
		}
		
		public function dispose():void
		{
			for( var i:int = 0 ; i<numChildren ; ++i){
				if(getChildAt(i) is AnimObject ){
					( getChildAt(i) as AnimObject ).dispose() ;
				}
			}
			roads = null ;
			_bavos = null ;
			container = null ;
			tinyBmp = null ;
			super.disableInteractivePNG() ;
		}
	}
}
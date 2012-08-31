package local.map.cell
{
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	import local.vo.RoadResVO;
	
	public class RoadObject extends InteractivePNG
	{
		private var _roadResVO:RoadResVO ;
		private var _tinyBmp:Bitmap = new Bitmap() ;
		private var _roadBmp:Bitmap = new Bitmap() ;
		private var _tinyAlpha:Number = 0.05 ;
		
		public function RoadObject( name:String , roadResVO:RoadResVO )
		{
			super();
			this.name = name ;
			mouseChildren = false ;
			this._roadResVO = roadResVO ;
			addChild(_roadBmp);
			addChild(_tinyBmp);
		}
		
		public function show( direction:String=""):void
		{
			super._bitmapForHitDetection = _roadBmp ;
			_roadBmp.bitmapData = _roadResVO.bmds[name+direction] ;
			_tinyBmp.bitmapData = _roadBmp.bitmapData ;
			var transform:ColorTransform = _tinyBmp.transform.colorTransform;
			transform.color = 0xffffff;
			_tinyBmp.transform.colorTransform = transform ;
			_tinyBmp.x =  _roadResVO.offsetXs[name+direction ] ;
			_tinyBmp.y =  _roadResVO.offsetYs[name+direction ] ;
			_roadBmp.x = _tinyBmp.x
			_roadBmp.y = _tinyBmp.y
			_tinyBmp.visible=false ;
		}
		
		public function flash( value:Boolean ):void
		{
			_tinyBmp.visible=value ;
			if(value){
				_tinyBmp.alpha=0.5;
				_tinyAlpha = 0.1 ;
				addEventListener(Event.ENTER_FRAME , onEnterFrame );
			}else{
				removeEventListener(Event.ENTER_FRAME , onEnterFrame );
			}
		}
		
		private function onEnterFrame( e:Event ):void
		{
			if(_tinyBmp.visible){
				_tinyBmp.alpha += _tinyAlpha;
				if(_tinyBmp.alpha>1){
					_tinyAlpha = -0.05 ;
				}else if(_tinyBmp.alpha<-0.5){
					_tinyAlpha = 0.05 ;
				}
			}
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME , onEnterFrame );
			_roadResVO = null ;
			_tinyBmp = null ;
			_roadBmp = null ;
			super.disableInteractivePNG() ;
		}
	}
}
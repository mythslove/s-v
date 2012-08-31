package local.map.item
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.vo.LandVO;
	import local.vo.RoadResVO;

	/**
	 * 土地区域 
	 * @author zhouzhanglin
	 */	
	public class Land extends BaseMapObject
	{
		public var landVO:LandVO ;
		private var _roadResVO:RoadResVO ;
		private var _landBmp:Bitmap;
		
		public function Land( landVO:LandVO , roadResVO:RoadResVO )
		{
			super(GameSetting.GRID_SIZE*4 );
			this.landVO = landVO ;
			this._roadResVO = roadResVO ;
			addEventListener(Event.ADDED_TO_STAGE , onAddedHandler );
		}
		
		/**
		 * 更新UI的方向 
		 * @param position
		 */		
		public function updateUI( position:String):void
		{
			landVO.direction = position;
			show();
		}
		
		private function onAddedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , onAddedHandler );
			_landBmp=  new Bitmap();
			addChild(_landBmp);
			show();
		}
		
		protected function show():void
		{
			var bmd:BitmapData= _roadResVO.bmds[landVO.direction] ;
			_landBmp.bitmapData = bmd ;
			_landBmp.x = _roadResVO.offsetXs[landVO.direction] ;
			_landBmp.y= _roadResVO.offsetYs[landVO.direction] ;
		}
		
		override public function dispose():void
		{
			super.dispose() ;
			landVO = null ;
			_roadResVO = null ;
			_landBmp = null ;
		}
	}
}
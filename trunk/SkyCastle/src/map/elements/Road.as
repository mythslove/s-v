package map.elements
{
	import bing.ds.HashMap;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import models.vos.BuildingVO;
	
	import views.base.Thumb;
	
	public class Road extends BuildingBase
	{
		private var _roundRoadHash:HashMap;
		private var _tempUrl:String ; //截断的资源路径
		private var _currentUrl:String ; //当前资源的路径
		private var _currentAlias:String; //当前资源的名称
		
		public function Road(buildingVO:BuildingVO)
		{
			super(buildingVO);
			_currentUrl = buildingVO.baseVO.url ;
			_currentAlias = buildingVO.baseVO.alias;
			var url:String = buildingVO.baseVO.url ;
			_tempUrl =  url.substring(0, url.lastIndexOf('/')+1)  ;
		}
		
		override protected function addedHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			show();
		}
		
		/**
		 * 显示图像
		 */		
		private function show():void
		{
			_itemLayer.removeChildren();
			var bmd:BitmapData= _skin?_skin.bitmapData:null ;
			_skin = new Thumb( _currentAlias , _currentUrl , bmd );
			_itemLayer.addChild(_skin);
			
			_skin.x = buildingVO.baseVO.offsetX;
			_skin.y = buildingVO.baseVO.offsetY;
		}
		
		/**
		 * 更新UI的方向 
		 * @param position
		 */		
		public function updateUI( position:String):void
		{
			_currentAlias = buildingVO.baseVO.alias+position;
			_currentUrl = _tempUrl+_currentAlias+".png" ;
			show();
		}
		
	}
}
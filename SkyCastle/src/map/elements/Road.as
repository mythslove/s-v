package map.elements
{
	import flash.events.Event;
	
	import models.vos.BuildingVO;
	
	public class Road extends BuildingBase
	{
		private var _currentLabel:String="NONE";
		
		public function Road(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override protected function resLoadedHandler( e:Event):void
		{
			super.resLoadedHandler(e);
			_skin.gotoAndStop(_currentLabel);
		}
		
		/**
		 * 更新UI的方向 
		 * @param position
		 */		
		public function updateUI( position:String):void
		{
			_currentLabel = position;
			if(_skin){
				_skin.gotoAndStop(_currentLabel);
			}else{
				super.loadRes();
			}
		}
		
	}
}
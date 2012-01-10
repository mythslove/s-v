package map.elements
{
	import flash.events.Event;
	
	import models.vos.BuildingVO;
	/**
	 * 路 
	 * @author zhouzhanglin
	 */	
	public class Road extends BuildingBase
	{
		/**
		 * 当前的方向 
		 */		
		private var _currentLabel:String="NONE";
		
		/**
		 * 路构造函数 
		 * @param buildingVO
		 */		
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
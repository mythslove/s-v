package game.views.slotlist
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.MouseEvent;
	
	import game.views.BaseView;

	/**
	 * 大厅中间的列表视图，有按钮和遮罩
	 * @author zzhanglin
	 */	
	public class HallCenterView extends BaseView
	{
		public var hallList:HallList ;
		public var btnNextPage:ListPageButton;
		public var btnPrevPage:ListPageButton;
		//-----------------------------------------
		private var _moveDis:Number ;
		private var _pageIndex:int=0;
		private var _pageTotal:int = 2 ;
		
		public function HallCenterView()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			_moveDis = hallList.width>>1 ;
			btnPrevPage.visible=false;
			btnNextPage.visible=true;
			configListeners();
		}
		
		private function configListeners():void
		{
			btnPrevPage.addEventListener(MouseEvent.CLICK , pageClickHandler );
			btnNextPage.addEventListener(MouseEvent.CLICK , pageClickHandler );
		}
		
		private function pageClickHandler(e:MouseEvent):void
		{
			btnPrevPage.visible=btnNextPage.visible=false;
			switch(e.target)
			{
				case btnPrevPage:
					_pageIndex--;
					break ;
				case btnNextPage:
					_pageIndex++;
					break ;
			}
			mouseChildren=false;
			TweenLite.to( hallList,1,{x:-_moveDis*_pageIndex+4,onComplete:moveComplete,ease:Back.easeInOut});
		}
		
		private function moveComplete():void
		{
			mouseChildren=true ;
			if(_pageIndex>0){
				btnPrevPage.visible=true;
			}
			if(_pageIndex+1<_pageTotal){
				btnNextPage.visible=true;
			}
		}
	}
}
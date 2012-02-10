package game.views.slotlist
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quart;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.views.BaseView;
	import game.views.friendsbar.FriendBar;
	import game.views.specialbar.SpecialBar;

	/**
	 * 大厅中间的列表视图，有按钮和遮罩
	 * @author zzhanglin
	 */	
	public class HallCenterView extends BaseView
	{
		public var hallBg:Sprite;
		public var hallList:HallList ;
		public var btnNextPage:ListPageButton;
		public var btnPrevPage:ListPageButton;
		public var specialBar:SpecialBar ;
		public var friendBar:FriendBar;
		//-----------------------------------------
		private var _moveDis:Number ;
		private var _pageIndex:int=0;
		private var _pageTotal:int = 2 ;
		
		public function HallCenterView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			hallBg.mouseChildren=hallBg.mouseEnabled=false;
			hallBg.cacheAsBitmap=true;
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
			TweenLite.to( hallList,0.75,{x:-_moveDis*_pageIndex+10,onComplete:moveComplete,ease:Quart.easeOut});
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
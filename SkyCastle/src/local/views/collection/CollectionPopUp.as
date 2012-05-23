package local.views.collection
{
	import bing.components.button.BaseButton;
	import bing.components.button.BaseToggleButton;
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.model.CollectionModel;
	import local.model.vos.CollectionVO;
	import local.utils.PopUpManager;
	import local.views.base.BaseView;

	/**
	 * 所有收集的弹出窗口 
	 * @author zzhanglin
	 */	
	public class CollectionPopUp extends BaseView
	{
		public var btnClose:BaseButton;
		public var btnPrevPage:BaseButton;
		public var btnNextPage:BaseButton;
		public var container:Sprite ;
		//=============================
		private var _currCollections:Vector.<CollectionVO > ;
		private const COUNT:int = 2 ;//一页显示两个
		private var _totalPage:int ;
		private var _page:int ;
		
		public function CollectionPopUp()
		{
			super();
			container.visible=false;
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
		}
		
		override protected function added():void
		{
			TweenLite.from(this,0.3,{x:x-200 , ease:Back.easeOut , onComplete:inTweenOver });
			btnPrevPage.addEventListener(MouseEvent.CLICK , pageBtnHandler , false , 0 , true );
			btnNextPage.addEventListener(MouseEvent.CLICK , pageBtnHandler , false , 0 , true );
			btnClose.addEventListener( MouseEvent.CLICK , closeClickHandler , false , 0 , true );
			
			_currCollections = CollectionModel.instance.collectionArray ;
			_totalPage = 0 ;
			if(_currCollections){
				_totalPage = Math.ceil(_currCollections.length/COUNT);
			}
			showList(0);
		}
		private function inTweenOver():void{
			container.visible=true;
		}
		
		private function pageBtnHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch( e.target)
			{
				case btnPrevPage:
					_page--;
					break ;
				case btnNextPage:
					_page++;
					break;
			}
			showList(_page);
		}
		
		private function showList( page:int ):void
		{
			if(!_currCollections) return ;
			
			ContainerUtil.removeChildren(container);
			var render:CollectionItemRenderer ;
			var len:int = _currCollections.length;
			var col:int = 1 ;
			var temp:int = 0 ;
			for( var i:int = _page*COUNT ; i<len && i<_page*COUNT+COUNT ; ++i )
			{
				render = new CollectionItemRenderer(_currCollections[i]);
				render.y = temp*(render.height+20);
				container.addChild(render);
				temp++;
			}
			updatePageButton();
		}
		
		private function updatePageButton():void
		{
			if(_totalPage==0){
				btnNextPage.enabled=btnPrevPage.enabled=false ;
			}else{
				btnNextPage.enabled=btnPrevPage.enabled=true ;
				if(_page==_totalPage-1){
					btnNextPage.enabled = false;
				}
				if(_page==0){
					btnPrevPage.enabled = false ;
				}
			}
		}
		
		private function closeClickHandler( e:MouseEvent ):void
		{
			mouseChildren = false ;
			container.visible=false;
			TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
		}
		
		private function tweenComplete():void {
			PopUpManager.instance.removeCurrentPopup(); 
		}
		
		override protected function removed():void
		{
			_currCollections = null ;
			btnPrevPage.removeEventListener(MouseEvent.CLICK , pageBtnHandler);
			btnNextPage.removeEventListener(MouseEvent.CLICK , pageBtnHandler );
			btnClose.removeEventListener( MouseEvent.CLICK , closeClickHandler);
		}
	}
}
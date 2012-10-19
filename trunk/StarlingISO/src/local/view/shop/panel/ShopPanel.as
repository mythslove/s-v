package local.view.shop.panel
{
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.layout.TiledRowsLayout;
	
	import local.util.EmbedManager;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	import local.view.shop.ShopItemRenderer;
	
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ShopPanel extends BaseView
	{
		protected var _list:List ;
		protected var _pageTf:TextField ;
		private var _layout:TiledRowsLayout ;
		
		public var prevBtn:GameButton ;
		public var nextBtn:GameButton ;
		
		public function ShopPanel()
		{
			super();
			init();
		}
		
		protected function init():void
		{
			_layout = new TiledRowsLayout();
			_layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			_layout.useSquareTiles = false;
			_layout.gap = 5 ;
			_layout.tileHorizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			_layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			
			
			_list = new List();
			_list.width = _list.maxWidth = 840 ;
			_list.height = 340;
			_list.itemRendererFactory = function():IListItemRenderer {
				return new ShopItemRenderer();
			};
			_list.layout = _layout;
			_list.y = 80 ;
			_list.x = 20 ;
			_list.scrollerProperties.snapToPages = true;
			_list.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			_list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			_list.onScroll.add( listOnScroll );
			addChild(_list);
			
			
			prevBtn = new GameButton(EmbedManager.getUIImage("PageButton"));
			prevBtn.x = 30-prevBtn.pivotX ;
			prevBtn.scaleX = -1 ;
			prevBtn.y = 260 ;
			addChild(prevBtn);
			prevBtn.onRelease.add( pageClickHandler );
			
			nextBtn = new GameButton(EmbedManager.getUIImage("PageButton"));
			nextBtn.x = _list.width+nextBtn.pivotX ;
			nextBtn.y = 260 ;
			addChild(nextBtn);
			nextBtn.onRelease.add( pageClickHandler );
			
			_pageTf = new TextField(250,60,"Page: 10/10" , "Verdana" , 30 , 0 , true );
			_pageTf.hAlign = HAlign.LEFT ;
			_pageTf.x = 80;
			_pageTf.y = 420 ;
			addChild(_pageTf);
		}
		
		protected function listOnScroll( list:List ):void
		{
			var cha:int = list.horizontalScrollPosition / list.maxHorizontalScrollPosition - list.horizontalPageIndex
			if( cha==0||cha==1||cha==-1){
				var maxPage:int = list.maxHorizontalScrollPosition / list.maxWidth ;
				var page:int = list.horizontalScrollPosition / list.maxHorizontalScrollPosition ;
				if(maxPage==0){
					nextBtn.visible = prevBtn.visible = false ;
				}else if(page==0){
					prevBtn.visible = false ;
					nextBtn.visible = true ;
				}else if(page==maxPage){
					prevBtn.visible = true ;
					nextBtn.visible = false ;
				}else{
					nextBtn.visible = prevBtn.visible = true ;
				}
				_pageTf.text = "Page: "+(page+1)+ "/"+(maxPage+1) ;
				
			}else if(nextBtn.visible || prevBtn.visible){
				nextBtn.visible = prevBtn.visible = false ;
			}
		}
		
		protected function pageClickHandler( btn:GameButton ):void
		{
			var page:int = _list.horizontalScrollPosition / _list.maxHorizontalScrollPosition ;
			if(btn==prevBtn){
				_list.scrollToDisplayIndex( (page-1)*3 , 0.3 );
			}else{
				_list.scrollToDisplayIndex( (page+1)*3 , 0.3 );
			}
		}
	}
}
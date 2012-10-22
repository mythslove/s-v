package local.view.products
{
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.map.item.Industry;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.PopUpCloseButton;
	import local.view.iap.PopUpCashButton;
	import local.view.iap.PopUpCoinButton;
	import local.vo.ProductVO;
	
	public class ProductsPopUp extends BaseView
	{
		private static var _instance:ProductsPopUp;
		public static function get instance():ProductsPopUp{
			if(!_instance) _instance = new ProductsPopUp();
			return _instance ;
		}
		//=====================================
		public var btnClose:PopUpCloseButton ;
		public var container:Sprite;
		public var btnCash:PopUpCashButton ;
		public var btnCoin:PopUpCoinButton ;
		//=====================================
		
		private var _cacheProducts:Vector.<ProductsItemRenderer> = Vector.<ProductsItemRenderer>([
			new ProductsItemRenderer(),new ProductsItemRenderer(),new ProductsItemRenderer(),new ProductsItemRenderer()
		]);
		
		public var industry:Industry ;
		
		public function ProductsPopUp(){
			super();
			btnClose.addEventListener(MouseEvent.CLICK , onMouseHandler );
		}
		
		override protected function addedToStageHandler( e:Event ):void
		{
			super.addedToStageHandler(e);
			mouseChildren=true;
			GameWorld.instance.stopRun();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			TweenLite.from( this , 0.3 , { x:x-200 , ease: Back.easeOut });
		}
		
		public function show( industry:Industry ):void
		{
			ContainerUtil.removeChildren( container );
			this.industry = industry ;
			var products:Vector.<ProductVO > = industry.buildingVO.baseVO.products ;
			if(products){
				var len:int = products.length ;
				var render:ProductsItemRenderer ;
				var colGap:int = 40 , rowGap:int = 15 ;
				var row:int , col:int ;
				for( var i:int = 0 ; i<len ; ++i )
				{
					render = _cacheProducts[i] ;
					render.proVO = products[i] ;
					render.x = col*(render.width + colGap);
					render.y = row*(render.height+rowGap);
					container.addChild( render );
					
					col++;
					if(col==2){
						col = 0;
						row++;
					}
				}
			}
		}
		
		
		private function onMouseHandler( e:MouseEvent ):void
		{
			switch( e.target )
			{
				case btnClose:
					close();
					break ;
			}
		}
		
		private function close():void{
			mouseChildren=false;
			TweenLite.to( this , 0.3 , { x:x+200 , ease: Back.easeIn , onComplete:onTweenCom});
		}
		private function onTweenCom():void{
			PopUpManager.instance.removeCurrentPopup() ;
		}
		
		override protected function removedFromStageHandler(e:Event):void{
			super.removedFromStageHandler(e);
			GameWorld.instance.run();
			industry = null ;
			ContainerUtil.removeChildren( container );
		}
	}
}
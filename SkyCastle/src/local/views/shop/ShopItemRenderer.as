package local.views.shop
{
	import bing.components.BingComponent;
	import bing.components.button.BaseButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GlobalDispatcher;
	import local.events.ShopEvent;
	import local.model.buildings.vos.*;
	import local.model.vos.ShopItemVO;
	import local.utils.GameUtil;
	import local.views.base.Image;
	import local.views.tooltip.GameToolTip;
	
	public class ShopItemRenderer extends BingComponent
	{
		public var container:Sprite;
		public var btnNormal:BaseButton;
		public var btnBg:InteractiveObject ;
		public var txtBtn:TextField ,txtName:TextField;
		public var payMode:ShopItemPayMode;
		//==========================
		private const LABEL_DEFAULT:String = "defalut";
		private const LABEL_ADVANCED:String = "advanced";
		
		public var itemVO:ShopItemVO;
		
		public function ShopItemRenderer()
		{
			super();
			stop();
			container.mouseEnabled = container.mouseChildren=false ;
			GameUtil.disableTextField(this);
		}
		
		/**
		 * 显示此建筑 
		 * @param vo
		 */		
		public function showBuilding( vo:ShopItemVO ):void
		{
			this.itemVO = vo ;
			txtName.text = vo.baseVO.name ; //显示名称
			container.addChild( new Image(vo.baseVO.thumbAlias , vo.baseVO.thumb) ); //显示缩略图
			GameToolTip.instance.register(btnBg,stage,vo.baseVO.description); //注册ToolTip
			
			payMode.showPay( vo );
			btnNormal.addEventListener(MouseEvent.CLICK , clickNormalBtnHandler,false,0,true);
			disabledSprite();
		}
		
		private function clickNormalBtnHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			GlobalDispatcher.instance.dispatchEvent( new ShopEvent(ShopEvent.SELECTED_BUILDING,itemVO));
		}
		
		private function disabledSprite():void
		{
			var inter:InteractiveObject; 
			for(var i:int = 0 ;i<numChildren ; ++i){
				inter = getChildAt(i) as InteractiveObject ;
				if( inter && !(inter is BaseButton) && !( inter is SimpleButton)){
					inter.mouseEnabled = false ;
					if(inter is DisplayObjectContainer){
						(inter as DisplayObjectContainer).mouseChildren=false;
					}
				}
			}
		}
		
		override protected function removedFromStage():void
		{
			btnNormal.removeEventListener(MouseEvent.CLICK , clickNormalBtnHandler );
			itemVO = null ;
			GameToolTip.instance.unRegister(btnBg);
		}
	}
}
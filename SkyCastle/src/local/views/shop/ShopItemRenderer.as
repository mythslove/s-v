package local.views.shop
{
	import bing.components.button.BaseButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GlobalDispatcher;
	import local.enum.ItemType;
	import local.events.ShopEvent;
	import local.model.buildings.vos.*;
	import local.model.vos.ShopItemVO;
	import local.views.base.Image;
	import local.views.tooltip.GameToolTip;
	
	public class ShopItemRenderer extends MovieClip
	{
		public var container:Sprite;
		public var btnNormal:BaseButton;
		public var btnBg:SimpleButton ;
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
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler , false , 0 , true  );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addEventListener( Event.REMOVED_FROM_STAGE , removedFromStageHandler , false , 0 , true  );
		}
		
		/**
		 * 显示此建筑 
		 * @param vo
		 */		
		public function showBuilding( vo:ShopItemVO ):void
		{
			this.itemVO = vo ;
			txtName.text = vo.baseVO.name ; //显示名称
			container.addChild( new Image(vo.baseVO.alias+"Thumb" , vo.baseVO.thumb) ); //显示缩略图
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
		
		private function removedFromStageHandler( e:Event ):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removedFromStageHandler);
			btnNormal.removeEventListener(MouseEvent.CLICK , clickNormalBtnHandler );
			itemVO = null ;
			GameToolTip.instance.unRegister(btnBg);
		}
	}
}
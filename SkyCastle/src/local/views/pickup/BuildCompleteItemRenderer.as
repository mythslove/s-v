package local.views.pickup
{
	import bing.components.BingComponent;
	import bing.components.button.BaseButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.model.PlayerModel;
	import local.views.alert.CostCashAlert;

	/**
	 * 建造完成时材料窗口的renderer 
	 * 有两帧，skip和default
	 * @author zzhanglin
	 */	
	public class BuildCompleteItemRenderer extends BingComponent
	{
		public var txtName:TextField ;
		public var txtCount:TextField ;
		public var btnSkip:BaseButton;
		public var container:Sprite;
		//=============================
		
		public function BuildCompleteItemRenderer()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			if(btnSkip) {
				btnSkip.addEventListener(MouseEvent.CLICK , onSkipHandler , false , 0 , true );
			}
		}
		
		private function onSkipHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			var arr:Array=txtCount.text.split("/");
			if(PlayerModel.instance.me.cash<int(arr[0]))
			{
				//弹出cash商店
			}else{
				CostCashAlert.show("Are you sure to purchase this item for gems?" , arr[0] , skip );
			}
		}
		
		private function skip():void
		{
			var arr:Array=txtCount.text.split("/");
			PlayerModel.instance.me.cash -= int(arr[0]);
			var parentPopup:BuildCompleteMaterialPopUp=materialPopup;
			if(parentPopup){
				parentPopup.architechture.buildingVO.addSkipMaterial(this.name) ;
				parentPopup.refresh();
			}
		}
		
		private function get materialPopup():BuildCompleteMaterialPopUp
		{
			var obj:DisplayObjectContainer = this.parent ;
			while(obj){
				if( obj is BuildCompleteMaterialPopUp) return obj ;
				obj = obj.parent ;
			}
			return null ;
		}
		
		override protected function removedFromStage():void
		{
			if(btnSkip ){
				btnSkip.removeEventListener(MouseEvent.CLICK , onSkipHandler );
			}
		}
	}
}
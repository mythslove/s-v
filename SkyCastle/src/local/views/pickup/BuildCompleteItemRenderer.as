package local.views.pickup
{
	import bing.amf3.ResultEvent;
	import bing.components.BingComponent;
	import bing.components.button.BaseButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameRemote;
	import local.model.PickupModel;
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
			var cash:int = int(arr[1]) -  int(arr[0]) ;
			if(PlayerModel.instance.me.cash<cash)
			{
				//弹出cash商店
			}else{
				CostCashAlert.show("Are you sure to purchase this item for gems?" , cash+"" , skip );
			}
		}
		
		private function skip():void
		{
			btnSkip.enabled = false ;
			var arr:Array=txtCount.text.split("/");
			var cash:int = int(arr[1]) -  int(arr[0]) ;
			var ro:GameRemote = new GameRemote("CommService");
			ro.addEventListener(ResultEvent.RESULT , onResultHandler , false , 0 , true );
			ro.getOperation( "buildSkip").send( this.name ,cash );
		}
		
		private function onResultHandler( e:ResultEvent ):void
		{
			e.target.removeEventListener(ResultEvent.RESULT , onResultHandler );
			var arr:Array=txtCount.text.split("/");
			var cash:int = int(arr[1]) -  int(arr[0]) ;
			PlayerModel.instance.me.cash -= cash;
			PickupModel.instance.addPickup( name , cash ); //直接添加material
			var parentPopup:BuildCompleteMaterialPopUp=materialPopup;
			if(parentPopup){
				parentPopup.refresh();
			}
		}
			
		
		private function get materialPopup():BuildCompleteMaterialPopUp
		{
			var obj:DisplayObjectContainer = this.parent ;
			while(obj){
				if( obj is BuildCompleteMaterialPopUp) return obj as BuildCompleteMaterialPopUp;
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
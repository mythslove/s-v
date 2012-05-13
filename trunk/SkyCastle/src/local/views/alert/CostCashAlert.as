package local.views.alert
{
	import flash.text.TextField;
	
	import local.utils.PopUpManager;
	import local.views.BaseView;

	/**
	 * 花cash时的提示框 
	 * @author zzhanglin
	 */	
	public class CostCashAlert extends SimpleAlert
	{
		public var txtCash:TextField;
		//=========================
		
		public function CostCashAlert( cash:String , info:String ,  yesFun:Function = null , noFun:Function = null )
		{
			super( info ,  yesFun , noFun );
			this.txtCash.text = cash ;
		}
		
		
		public static function show(cash:String ,  info:String ,  yesFun:Function = null , noFun:Function = null  ):void
		{
			var alert:CostCashAlert = new CostCashAlert(cash, info ,  yesFun, noFun);
			PopUpManager.instance.addPopUp( alert , true , true , 0.4 );
		}		
	}
}
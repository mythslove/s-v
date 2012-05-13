package local.views.alert
{
	import flash.text.TextField;
	
	import local.utils.PopUpManager;

	/**
	 *卖建筑确认窗口 
	 * @author zzhanglin
	 */
	public class SellBuildingAlert extends BuildingAlert
	{
		public var txtCoin:TextField;
		//============================
		
		public function SellBuildingAlert(coin:String , baseId:String, info:String, yesFun:Function=null, noFun:Function=null)
		{
			super(baseId, info, yesFun, noFun);
			txtCoin.text = coin ;
		}
		
		public static function show(coin:String , baseId:String ,  info:String ,  yesFun:Function = null , noFun:Function = null  ):void
		{
			var alert:SellBuildingAlert = new SellBuildingAlert(coin,baseId ,info ,  yesFun, noFun);
			PopUpManager.instance.addPopUp( alert , true , true , 0.4 );
		}
	}
}
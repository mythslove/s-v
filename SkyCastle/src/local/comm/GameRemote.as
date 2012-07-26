package local.comm
{
	import bing.amf3.FaultEvent;
	import bing.amf3.RemoteObject;
	import bing.utils.SystemUtil;
	
	import local.utils.PopUpManager;
	import local.views.alert.BugAlert;
	
	/**
	 * AMF3通信基类 
	 * @author zzhanglin
	 */	
	public class GameRemote extends RemoteObject
	{
		public static var gateWay:String ;
		
		public function GameRemote(servicePath:String)
		{
			if(!gateWay){
				gateWay = "http://199.68.199.132/MyService/Apps/gateway.php?";
				gateWay+="sandbox=1" ;
				gateWay+="&mId="+GameData.currentMapId
				gateWay+="&uId="+GameData.me_uid ;
			}
			super(gateWay, servicePath);
			this.addEventListener( FaultEvent.FAULT , onFaultHandler );
		}
		
		private function onFaultHandler( e:FaultEvent ):void
		{
			SystemUtil.debug("接口ERROR:"+e.faultObj.faultDetail , e.faultObj.faultString );
			
			this.removeEventListener( FaultEvent.FAULT , onFaultHandler );
			var alert:BugAlert=new BugAlert();
			PopUpManager.instance.addPopUp( alert);
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.removeEventListener( FaultEvent.FAULT , onFaultHandler );
		}
	}
}
package utils
{
	import bing.utils.ContainerUtil;
	
	import comm.GameSetting;
	
	import flash.display.DisplayObject;
	
	import views.CenterViewContainer;
	import views.base.PopupMask;

	public class PopUpManager
	{
		public static function addPopUpToFront( mc:DisplayObject , modal:Boolean=true ):void 
		{
			if(modal){
				var popMask:PopupMask = new PopupMask();
				CenterViewContainer.instance.popUpContainer.addChild(popMask);
			}
			mc.x = (GameSetting.SCREEN_WIDTH-mc.width)*0.5 ;
			mc.y = (GameSetting.SCREEN_HEIGHT-mc.height)*0.5 ;
			CenterViewContainer.instance.popUpContainer.addChild(mc);
		}
		
		public static function addPopUpToBehind( mc:DisplayObject , modal:Boolean=true ):void 
		{
			CenterViewContainer.instance.popUpContainer.addChildAt(mc,0);
			if(modal)
			{
				var popMask:PopupMask = new PopupMask();
				CenterViewContainer.instance.popUpContainer.addChildAt(popMask,0);
				mc.x = (GameSetting.SCREEN_WIDTH-mc.width)*0.5 ;
				mc.y = (GameSetting.SCREEN_HEIGHT-mc.height)*0.5 ;
			}
		}
		
		public static function removePopup( mc:DisplayObject ):void 
		{
			if(mc.parent){
				var index:int = mc.parent.getChildIndex( mc );
				if(index-1>=0 && mc.parent.getChildAt(index-1) is PopupMask)
				{
					mc.parent.removeChildAt( index-1);
				}
				mc.parent.removeChild( mc );
			}
		}
		
		public static  function removeAllPopup():void
		{
			ContainerUtil.removeChildren(CenterViewContainer.instance.popUpContainer);
		}
	}
}
package game.utils
{
	import bing.utils.ContainerUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import game.mvc.base.GameContext;
	import game.mvc.view.components.PopUpMask;

	public class PopUpManager
	{
		public static var popUpLayer:Sprite ;
		
		/**
		 * 弹出窗口 
		 * @param mc
		 * @param model 是否是模式窗口
		 * @param maskAlpha 遮罩层的透明度，当model为true才有用
		 * @param isFront 是否弹在其他弹出窗口的前面
		 */		
		public static function addPopUp( mc:DisplayObject , model:Boolean , maskAlpha:Number=0 , isFront:Boolean=true ):void 
		{
			if(popUpLayer)
			{
				mc.x = (GameContext.instance.contextView.stage.stageWidth-mc.width)*0.5 ;
				mc.y = (GameContext.instance.contextView.stage.stageHeight-mc.height)*0.5 ;
				if(model){
					var mask:PopUpMask = new PopUpMask(maskAlpha);
					popUpLayer.addChild( mask );
				}
				popUpLayer.addChild( mc );
			}
		}
		
		public static function removePopUp( mc:DisplayObject ):void 
		{
			if( popUpLayer && popUpLayer.contains(mc))
			{
				popUpLayer.removeChild( mc );
				if( popUpLayer.numChildren>0 && popUpLayer.getChildAt(popUpLayer.numChildren-1) is PopUpMask)
				{
					popUpLayer.removeChildAt( popUpLayer.numChildren-1 );
				}
			}
		}
		
		public static function createPopUp( classAlias:Class , model:Boolean , maskAlpha:Number=0 , isFront:Boolean=true ):void 
		{
			if(popUpLayer)
			{
				var mc:DisplayObject = new classAlias() as DisplayObject ;
				mc.x = (GameContext.instance.contextView.stage.stageWidth-mc.width)*0.5 ;
				mc.y = (GameContext.instance.contextView.stage.stageHeight-mc.height)*0.5 ;
				if(model){
					var mask:PopUpMask = new PopUpMask(maskAlpha);
					popUpLayer.addChild( mask );
				}
				popUpLayer.addChild( mc );
			}
		}
		
		public static function removeAllPopUp():void 
		{
			if(popUpLayer)
			{
				ContainerUtil.removeChildren( popUpLayer );
			}
		}
	}
}
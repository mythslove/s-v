package local.map.pk
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import local.enum.PickupType;
	import local.map.GameWorld;
	import local.util.EmbedsManager;
	
	import pxBitmapFont.PxTextAlign;
	import pxBitmapFont.PxTextField;
	
	public class FlyLabelImage extends Sprite
	{
		private var txt:PxTextField ;
		
		public function FlyLabelImage( pkType:String , value:int )
		{
			super();
			mouseEnabled = mouseChildren = false ;
			//图标
			var bmp:Bitmap = new Bitmap();
//			bmp.name = pkType ;
			switch( pkType)
			{
				case PickupType.COIN:
					bmp.bitmapData = EmbedsManager.instance.getSwfBmd("local.view.pk.PickupCoinSmall");
					break ;
				case PickupType.EXP:
					bmp.bitmapData = EmbedsManager.instance.getSwfBmd("local.view.pk.PickupExpSmall");
					break ;
				case PickupType.GOOD:
					bmp.bitmapData = EmbedsManager.instance.getSwfBmd("local.view.pk.PickupGoodsSmall");
					break ;
				case PickupType.ENERGY:
					bmp.bitmapData = EmbedsManager.instance.getSwfBmd("local.view.pk.PickupEnergySmall");
					break ;
				case PickupType.CASH:
					bmp.bitmapData = EmbedsManager.instance.getSwfBmd("local.view.pk.PickupCashSmall");
					break ;
				default: //component
					bmp.bitmapData = EmbedsManager.instance.getSwfBmd("local.view.comp.Comp"+pkType);
					bmp.scaleX = bmp.scaleY = 0.7 ;
					break ;
			}
			bmp.y = - bmp.height>>1 ;
			addChild(bmp);
			
			//文字
			txt = new PxTextField( EmbedsManager.instance.getBitmapFontByName("VerdanaBig",false) );
			txt.fixedWidth = false ;
			txt.useColor = false ;
			txt.mouseChildren = txt.mouseChildren = false ;
			txt.alignment = PxTextAlign.RIGHT;
			txt.text = value>0 ? "+"+value : ""+value ;
			txt.x = -txt.width-5 ;
			txt.y = -txt.height>>1  ;
			addChild(txt);
			
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			scaleX = scaleY = 0 ;
			var scale:Number = 1/GameWorld.instance.scaleX ;
			TweenLite.to( this , 0.3 , { scaleX:scale  , scaleY:scale , onComplete: scaleOver}  );
		}
		
		private function scaleOver():void
		{
			TweenLite.to( this , 2 , {y: y-60 , alpha:0 , onComplete:remove} );
		}
		
		private function remove():void
		{
			if(parent){
				parent.removeChild(this);
			}
			txt.destroy() ;
			txt= null ;
		}
	}
}
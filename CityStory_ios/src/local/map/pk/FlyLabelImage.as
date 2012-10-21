package local.map.pk
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import local.enum.PickupType;
	import local.map.GameWorld;
	import local.util.EmbedsManager;
	import local.util.ResourceUtil;
	
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
			switch( pkType)
			{
				case PickupType.COIN:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Coin") as BitmapData;
					break ;
				case PickupType.EXP:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Exp") as BitmapData;
					break ;
				case PickupType.GOOD:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Goods") as BitmapData;
					break ;
				case PickupType.ENERGY:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Energy") as BitmapData;
					break ;
				case PickupType.CASH:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Cash") as BitmapData
					break ;
				default: //component
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk."+pkType) as BitmapData
					break ;
			}
			bmp.scaleX = bmp.scaleY = 0.5 ;
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
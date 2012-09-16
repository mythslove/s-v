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
	
	public class FlyLabelImage extends Sprite
	{
		public function FlyLabelImage( pkType:String , value:int )
		{
			super();
			mouseEnabled = mouseChildren = false ;
			//图标
			var bmp:Bitmap = new Bitmap();
			bmp.name = pkType ;
			switch( pkType)
			{
				case PickupType.COIN:
					bmp.bitmapData = EmbedsManager.instance.getBitmapByName("PickupCoin").bitmapData;
					break ;
				case PickupType.EXP:
					bmp.bitmapData = EmbedsManager.instance.getBitmapByName("PickupExp").bitmapData;
					break ;
				case PickupType.GOOD:
					bmp.bitmapData = EmbedsManager.instance.getBitmapByName("PickupGoods").bitmapData;
					break ;
				case PickupType.ENERGY:
					bmp.bitmapData = EmbedsManager.instance.getBitmapByName("PickupEnergy").bitmapData;
					break ;
			}
			bmp.y = - bmp.height>>1 ;
			bmp.scaleX = bmp.scaleY = 0.6 ;
			addChild(bmp);
			
			//文字
			var txtf:TextField = new TextField();
			var tf:TextFormat = txtf.defaultTextFormat ;
			tf.size = 20 ;
			tf.bold = true ;
			txtf.text = value>0 ? "+"+value : "-"+value ;
			txtf.x = -txtf.textWidth-10 ;
			txtf.y = -bmp.height>>1 ;
			addChild(txtf);
			
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			scaleX = scaleY = 0 ;
			var scale:Number = 1/GameWorld.instance.scaleX ;
			TweenLite.to( this , 0.25 , { scaleX:scale  , scaleY:scale , onComplete: scaleOver}  );
		}
		
		private function scaleOver():void
		{
			TweenLite.to( this , 2 , {y: y-50 , alpha:0 , onComplete:remove} );
		}
		
		private function remove():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}
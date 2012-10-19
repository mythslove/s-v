package local.map.pk
{
	import com.greensock.TweenLite;
	
	import local.comm.GameSetting;
	import local.enum.PickupType;
	import local.map.GameWorld;
	import local.util.EmbedManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class FlyLabelImage extends Sprite
	{
		private var txt:TextField ;
		
		public function FlyLabelImage( pkType:String , value:int )
		{
			super();
			touchable= false ;
			//图标
			var bmp:Image  ;
			switch( pkType)
			{
				case PickupType.COIN:
					bmp = EmbedManager.getUIImage("CoinIcon") ;
					break ;
				case PickupType.EXP:
					bmp = EmbedManager.getUIImage("ExpIcon") ;
					break ;
				case PickupType.GOOD:
					bmp = EmbedManager.getUIImage("GoodsIcon") ;
					break ;
				case PickupType.ENERGY:
					bmp = EmbedManager.getUIImage("EnergyIcon") ;
					break ;
				case PickupType.CASH:
					bmp = EmbedManager.getUIImage("CashIcon") ;
					break ;
			}
			bmp.pivotY =  bmp.height>>1 ;
			addChild(bmp);
			
			//文字
			txt = new TextField( 200*GameSetting.GAMESCALE,60*GameSetting.GAMESCALE,"","Verdana",30*GameSetting.GAMESCALE,0xffffff,true );
			txt.hAlign = HAlign.RIGHT;
			txt.vAlign = VAlign.CENTER ;
			txt.text = value>0 ? "+"+value : ""+value ;
			txt.x = -txt.width-5*GameSetting.GAMESCALE ;
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
			TweenLite.to( this , 2 , {y: y-60*GameSetting.GAMESCALE , alpha:0 , onComplete:remove} );
		}
		
		private function remove():void
		{
			if(parent){
				parent.removeChild(this);
			}
			txt= null ;
			this.dispose();
		}
	}
}
package local.map.pk
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.enum.PickupType;
	import local.map.GameWorld;
	import local.model.PlayerModel;
	import local.util.EmbedsManager;
	import local.view.base.BaseView;
	import local.vo.PlayerVO;
	
	public class PickupImages extends BaseView
	{
		private var _pkHash:Dictionary = new Dictionary(true);
		private var _timeoutId:int ;
		
		public function PickupImages()
		{
			super();
			mouseChildren = false ;
		}
		
		public function addPK( pkType:String , value:int ):void
		{
			_pkHash[ pkType ] = value ;
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
			}
			bmp.y = - bmp.height>>1 ;
			bmp.x = numChildren==0 ? -bmp.width*0.8 : -bmp.width*0.25  ;
			addChild(bmp);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			scaleX = scaleY = 1/GameWorld.instance.scaleX ;
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler , false , 0 , true  );
			_timeoutId = setTimeout( fly , 3000 );
		}
		
		private function onMouseDownHandler( e:MouseEvent):void
		{
			fly();
		}
		
		private function fly():void
		{
			if(_timeoutId>0) {
				clearTimeout( _timeoutId );
			}
			mouseEnabled = false ;
			var obj:DisplayObject ;
			var me:PlayerVO = PlayerModel.instance.me ;
			for( var i:int = 0 ; i<numChildren ; ++i)
			{
				obj = getChildAt(i) ;
				switch( obj.name )
				{
					case PickupType.COIN:
						me.coin += _pkHash[obj.name] ;
						break ;
					case PickupType.EXP:
						me.exp += _pkHash[obj.name] ;
						break ;
					case PickupType.GOOD:
						me.goods += _pkHash[obj.name] ;
						break ;
				}
			}
		}
		
		override protected function removedFromStageHandler(e:Event):void
		{
			_pkHash = null ;
			super.removeEventListener(e);
			removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler ) ;
			dispose() ;
		}
	}
}
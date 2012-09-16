package local.map.pk
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.enum.PickupType;
	import local.map.GameWorld;
	import local.model.PlayerModel;
	import local.util.EmbedsManager;
	import local.view.CenterViewLayer;
	import local.view.base.BaseView;
	
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
			scaleX = scaleY = 0.2 ;
			
			var scale:Number = 1/GameWorld.instance.scaleX ;
			
			var bezierArray:Array = [ { x:x , y: y-70 } , { x:x , y:y+40+Math.random()*50 } ] ;
			TweenMax.to( this , 0.25 , {bezierThrough:bezierArray , onComplete:show , scaleX:scale , scaleY:scale });
		}
		
		private function show():void
		{
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
			var target:DisplayObject ; //要飞向的目标
			var targetPoint:Point = new Point() ; //要飞向的目标位置
			var centerLayer:CenterViewLayer = CenterViewLayer.instance ;
			for( var i:int = 0 ; i<numChildren ; ++i)
			{
				obj = getChildAt(i) ;
				switch( obj.name )
				{
					case PickupType.COIN:
						PlayerModel.instance.changeCoin(  _pkHash[obj.name] );
						target = centerLayer.topBar.coinBar ;
						break ;
					case PickupType.EXP:
						PlayerModel.instance.changeExp ( _pkHash[obj.name] );
						target = centerLayer.topBar.lvBar ;
						break ;
					case PickupType.GOOD:
						PlayerModel.instance.changeGoods(  _pkHash[obj.name] );
						target = centerLayer.topBar.goodsBar ;
						break ;
				}
//				targetPoint.setTo( target.x+centerLayer.x , target.y+ centerLayer.y );
				movePickup( targetPoint , obj );
				i--;
			}
			if( parent) parent.removeChild(this);	
		}
		
		private function movePickup( targetPoint:Point , displayObj:DisplayObject ):void
		{
			GameData.commPoint.setTo(0,0);
			var p:Point = this.localToGlobal( GameData.commPoint ) ;
			displayObj.x += p.x ;
			displayObj.y += p.y ;
			CenterViewLayer.instance.addChildAt( displayObj,0);
			
			var obj:Object = {x: displayObj.x + (targetPoint.x > displayObj.x ? (-50) : (50)), y: displayObj.y + (targetPoint.y - displayObj.y) * 0.5 };
			TweenMax.to( displayObj , 0.25 , {bezier:[ obj, { x:targetPoint.x , y:targetPoint.y }] , onComplete:over , onCompleteParams:[displayObj] ,alpha:0 });
		}
		
		private function over( obj:DisplayObject ):void
		{
			if(obj .parent){
				obj.parent.removeChild(obj );
			}
		}
				
		
		override protected function removedFromStageHandler(e:Event):void
		{
			_pkHash = null ;
			removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler ) ;
			dispose() ;
		}
	}
}
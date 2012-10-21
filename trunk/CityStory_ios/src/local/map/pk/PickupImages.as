package local.map.pk
{
	import bing.utils.MathUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.PickupType;
	import local.map.GameWorld;
	import local.model.CompsModel;
	import local.model.PlayerModel;
	import local.util.ResourceUtil;
	import local.view.CenterViewLayer;
	
	public class PickupImages extends Sprite
	{
		public var _pkType:String ; 
		public var _value:int ;
		public var _span:int ;
		private var _timeoutId:int ;
		
		public function PickupImages(pkType:String , value:int , x:Number , y:Number , span:int )
		{
			super();
			this.mouseChildren = false ;
			this.visible = false ;
			this._pkType = pkType ;
			this._value = value ;
			this._span = span ;
			this.x = x ;
			this.y = y ;
			
			setTimeout( init , Math.random()*600 );
		}
		
		public static function addPK( pkType:String , value:int , x:Number , y:Number , span:int ):void
		{
			var instance:PickupImages = new PickupImages(pkType , value , x , y,span);
			
			var bmp:Bitmap = new Bitmap();
			switch( pkType)
			{
				case PickupType.COIN:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Coin") as BitmapData ;
					break ;
				case PickupType.EXP:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Exp") as BitmapData ;
					break ;
				case PickupType.GOOD:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Goods") as BitmapData ;
					break ;
				case PickupType.ENERGY:
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk.Energy") as BitmapData ;
					break ;
				default: //comp
					bmp.bitmapData = ResourceUtil.instance.getInstanceByClassName("ui_pk","local.view.pk."+pkType) as BitmapData ;
					break ;
			}
			bmp.x = -bmp.width>>1 ;
			bmp.y = - bmp.height>>1 ;
			instance.addChild( bmp );
			
			GameWorld.instance.effectScene.addChild( instance );
		}
		
		private function init():void
		{
			visible = true ;
			scaleX = scaleY = 1/GameWorld.instance.scaleX ;
			var temp:Number = GameSetting.GRID_SIZE*_span*0.5 ;
			TweenLite.to(this, 0.75, {x: x+(temp+Math.random()*GameSetting.GRID_SIZE)*MathUtil.getRandomFlag()  , ease:Linear.easeNone});
			TweenLite.to(this, 0.75, {y: y+temp+Math.random()*GameSetting.GRID_SIZE , ease:Bounce.easeOut , onComplete:show});
		}
		
		private function show():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler , false  ,0 , true );
			_timeoutId = setTimeout( fly , 2000+Math.random()*2000 );
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
			var flyImg:FlyLabelImage ;
			var target:DisplayObject ; //要飞向的目标
			var targetPoint:Point = new Point() ; //要飞向的目标位置
			var centerLayer:CenterViewLayer = CenterViewLayer.instance ;
			switch( _pkType )
			{
				case PickupType.COIN:
					PlayerModel.instance.changeCoin(  _value );
					target = centerLayer.topBar.coinBar ;
					break ;
				case PickupType.EXP:
					PlayerModel.instance.changeExp ( _value );
					target = centerLayer.topBar.lvBar ;
					break ;
				case PickupType.GOOD:
					PlayerModel.instance.changeGoods( _value );
					target = centerLayer.topBar.goodsBar ;
					break ;
				case PickupType.ENERGY:
					PlayerModel.instance.changeEnergy( _value );
					target = centerLayer.topBar.energyBar ;
					break ;
				default://comp
					CompsModel.instance.addComp( _pkType ,_value );
					target = centerLayer.topBar.lvBar ;
					break ;
			}
			targetPoint.setTo( target.x+centerLayer.topBar.x , target.y+centerLayer.topBar.y );
			movePickup( targetPoint);
			
			flyImg = new FlyLabelImage( _pkType ,_value ) ;
			flyImg.x = x ;
			flyImg.y = y ;
			parent.addChild( flyImg );
		}
		
		private function movePickup( targetPoint:Point):void
		{
			GameData.commPoint.setTo(0,0);
			var p:Point = this.localToGlobal( GameData.commPoint ) ;
			x = p.x/root.scaleX ;
			y = p.y/root.scaleX ;
			scaleX = scaleY =  1;
			CenterViewLayer.instance.addChildAt( this,0);
			
			var temp:Number = Point.distance( targetPoint , new Point(this.x,this.y));
			temp = temp>400 ? 0.5 : 0.3 ;
			var obj:Object = {x: this.x + (targetPoint.x > this.x ? -50 : 50 ) , y: this.y + (targetPoint.y - this.y) * 0.5 };
			TweenMax.to( this , temp , {bezier:[ obj, { x:targetPoint.x , y:targetPoint.y }] , onComplete:over  ,alpha:0 });
		}
		
		private function over():void
		{
			if(this .parent){
				this.parent.removeChild(this );
			}
			removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler ) ;
		}
	}
}
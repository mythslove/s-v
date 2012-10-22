package local.map.pk
{
	import bing.utils.MathUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.PickupType;
	import local.map.GameWorld;
	import local.model.PlayerModel;
	import local.util.EmbedManager;
	import local.view.CenterViewLayer;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PickupImages extends Sprite
	{
		public var _pkType:String ; 
		public var _value:int ;
		public var _span:int ;
		private var _timeoutId:int ;
		
		public function PickupImages(pkType:String , value:int , x:Number , y:Number , span:int)
		{
			super();
			this.touchable = false ;
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
			var bmp:Image;
			switch( pkType)
			{
				case PickupType.COIN:
					bmp = EmbedManager.getUIImage("CoinIcon");
					break ;
				case PickupType.EXP:
					bmp = EmbedManager.getUIImage("ExpIcon");
					break ;
				case PickupType.GOOD:
					bmp = EmbedManager.getUIImage("GoodsIcon");
					break ;
				case PickupType.ENERGY:
					bmp = EmbedManager.getUIImage("EnergyIcon");
					break;
			}
			bmp.pivotX = bmp.width>>1 ;
			bmp.pivotY = bmp.height>>1 ;
			if(GameSetting.SCREEN_WIDTH<1024) bmp.scaleX = bmp.scaleY = 2 ;
			
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
			touchable = true ;
			this.addEventListener(TouchEvent.TOUCH , onTouchHandler);
			_timeoutId = setTimeout( fly , Math.random()*2000 );
		}
		
		
		private function onTouchHandler( e:TouchEvent):void
		{
			if(e.touches.length>0 && e.touches[0].phase == TouchPhase.BEGAN){
				fly();
			}
		}
		
		private function fly():void
		{
			if(_timeoutId>0) {
				clearTimeout( _timeoutId );
			}
			touchable = false ;
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
//					CompsModel.instance.addComp( _pkType ,_value );
					break ;
			}
			flyImg = new FlyLabelImage( _pkType ,_value ) ;
			flyImg.x = x ;
			flyImg.y = y ;
			parent.addChild( flyImg );
			
			if(target){
				targetPoint.setTo( target.x+centerLayer.topBar.x , target.y+centerLayer.topBar.y );
				movePickup( targetPoint);
			}else{
				over();
			}
		}
		
		private function movePickup( targetPoint:Point ):void
		{
			GameData.commPoint.setTo(0,0);
			var p:Point = this.localToGlobal( GameData.commPoint ) ;
			x = p.x/root.scaleX ;
			y = p.y/root.scaleX ;
			scaleX = scaleY =  1;
			CenterViewLayer.instance.addChildAt( this,0);
			
			var temp:Number = Point.distance( targetPoint , new Point(this.x,this.y));
			temp = temp>400*GameSetting.GAMESCALE ? 0.5 : 0.3 ;
			var obj:Object = {x: this.x + (targetPoint.x > this.x ? -50*GameSetting.GAMESCALE : 50*GameSetting.GAMESCALE ) , y: this.y + (targetPoint.y - this.y) * 0.5 };
			TweenMax.to( this , temp , {bezier:[ obj, { x:targetPoint.x , y:targetPoint.y }] , onComplete:over  ,alpha:0 });
		}
		
		private function over():void
		{
			if(this .parent){
				this.parent.removeChild(this );
			}
			dispose() ;
		}
	}
}
package local.views.icon
{
	import bing.utils.MathUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.enum.BasicPickup;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.vos.PlayerVO;
	import local.views.CenterViewContainer;
	import local.views.base.Image;
	import local.views.effects.MapWordEffect;
	
	public class PickupImage extends Image
	{
		private var _value:int ;
		private var _name:String;
		private var _type:String;
		private var _timeoutId:int ;
		
		/**
		 * 构造
		 * @param name pickup的名字，如pickupExp1 ,pickupWood2
		 * @param value 值
		 * @param type 0为不是基础pickup
		 */		
		public function PickupImage(name:String , value:int , type:String=null )
		{
			super(name, "res/pickup/"+name+".png", true);
			_name = name ;
			_type = type ;
			mouseChildren =false ;
			mouseEnabled = false ;
			this._value = value ;
			visible = false ;
			setTimeout( init , Math.random()*200 );
		}
		
		private function init():void
		{
			visible = true ;
			TweenLite.to(this, 0.65, {x: x+(45+Math.random()*75)*MathUtil.getRandomFlag()  , ease:Linear.easeNone});
			TweenLite.to(this, 0.65, {y: y+75+Math.random()*75 , ease:Bounce.easeOut , onComplete:inOver});
		}
		
		private function inOver():void {
			mouseEnabled = true ;
			_timeoutId = setTimeout( fly , 3000+Math.random()*2000 );
		}
		
		public function fly():void
		{
			clearTimeout(_timeoutId);
			_timeoutId = 0 ;
			var target:DisplayObject ;
			mouseEnabled = false ;
			if(_type)
			{
				var temp:String ="";
				var me:PlayerVO = PlayerModel.instance.me ;
				var color:uint = MapWordEffect.YELLOW ;
				switch(_type)
				{
					case BasicPickup.PICKUP_COIN:
						temp="Coin";
						me.coin+=_value ;
						target = CenterViewContainer.instance.topBar.coinBar ;
						color = MapWordEffect.WHITE ;
						break ;
					case BasicPickup.PICKUP_ENERGY:
						temp="Energy";
						me.energy+=_value ;
						target = CenterViewContainer.instance.topBar.energyBar ;
						color = MapWordEffect.ENERGY_COLOR ;
						break ;
					case BasicPickup.PICKUP_EXP:
						temp="Exp";
						me.exp+=_value ;
						target = CenterViewContainer.instance.topBar.expBar ;
						break ;
					case BasicPickup.PICKUP_WOOD:
						temp="Wood";
						me.wood+=_value ;
						target = CenterViewContainer.instance.topBar.woodBar ;
						color = MapWordEffect.WOOD_COLOR ;
						break ;
					case BasicPickup.PICKUP_STONE:
						temp="Stone";
						me.stone+=_value ;
						target = CenterViewContainer.instance.topBar.stoneBar ;
						color = MapWordEffect.STONE_COLOR ;
						break ;
				}
				var targetPoint:Point = new Point(target.x+CenterViewContainer.instance.x,target.y+CenterViewContainer.instance.y);
				var world:GameWorld = GameWorld.instance ;
				targetPoint.x = (targetPoint.x-world.x)/world.scaleX-world.sceneLayerOffsetX ;
				targetPoint.y = (targetPoint.y-world.y)/world.scaleX-world.sceneLayerOffsetY ;
				TweenLite.to( this , 1 , {x:targetPoint.x , y:targetPoint.y , alpha:0 , onComplete:remove});
				
				CenterViewContainer.instance.topBar.updateTopBar();
				var worldEffect:MapWordEffect = new MapWordEffect( temp+" +"+_value ,color );
				GameWorld.instance.addEffect( worldEffect , x , y );
			}
			else
			{
				//飞到搜集箱中
			}
		}
		
		private function remove():void
		{
			if(parent){
				parent.removeChild(this);
			}
			if(_timeoutId>0){
				clearTimeout(_timeoutId);
			}
		}
	}
}
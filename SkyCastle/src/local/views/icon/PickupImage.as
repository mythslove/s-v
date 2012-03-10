package local.views.icon
{
	import bing.utils.MathUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	
	import local.enum.BasicPickup;
	import local.game.GameWorld;
	import local.model.village.VillageModel;
	import local.model.village.vos.PlayerVO;
	import local.views.CenterViewContainer;
	import local.views.base.Image;
	import local.views.effects.MapWordEffect;
	
	public class PickupImage extends Image
	{
		private var _value:int ;
		private var _name:String;
		private var _type:String;
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
			this._value = value ;
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			mouseEnabled = false ;
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			TweenLite.to(this, 0.65, {x: x+(35+Math.random()*75)*MathUtil.getRandomFlag()  , ease:Linear.easeNone});
			TweenLite.to(this, 0.65, {y: y+75+Math.random()*75 , ease:Bounce.easeOut , onComplete:inOver});
		}
		
		private function inOver():void {
			mouseEnabled = true ;
		}
		
		public function fly():void
		{
			mouseEnabled = false ;
			if(_type)
			{
				var temp:String ="";
				var me:PlayerVO = VillageModel.instance.me ;
				switch(_type)
				{
					case BasicPickup.PICKUP_COIN:
						temp="Coin";
						me.coin+=_value ;
						break ;
					case BasicPickup.PICKUP_ENERGY:
						temp="Energy";
						me.energy+=_value ;
						break ;
					case BasicPickup.PICKUP_EXP:
						temp="Exp";
						me.exp+=_value ;
						break ;
					case BasicPickup.PICKUP_WOOD:
						temp="Wood";
						me.wood+=_value ;
						break ;
					case BasicPickup.PICKUP_STONE:
						temp="Stone";
						me.stone+=_value ;
						break ;
				}
				CenterViewContainer.instance.topBar.updateTopBar();
				var worldEffect:MapWordEffect = new MapWordEffect( temp+" +"+_value , MapWordEffect.WHITE);
				GameWorld.instance.addEffect( worldEffect , x , y );
				TweenLite.to( this , 0.5 , {y:y-300,alpha:0 , onComplete:remove });
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
		}
	}
}
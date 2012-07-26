package local.views.icon
{
	import bing.utils.MathUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.enum.BasicPickup;
	import local.enum.ItemType;
	import local.game.GameWorld;
	import local.model.PickupModel;
	import local.model.PlayerModel;
	import local.model.vos.PickupVO;
	import local.model.vos.PlayerVO;
	import local.utils.SoundManager;
	import local.views.CenterViewContainer;
	import local.views.RightBar;
	import local.views.base.Image;
	import local.views.effects.MapWordEffect;
	
	public class PickupImage extends Image
	{
		private var _value:int ;
		private var _pkAlias:String;
		private var _type:String;
		private var _timeoutId:int ;
		private var _pkId:String ;
		
		/**
		 * 构造
		 * @param name pickup的名字，如pickupExp1 ,pickupWood2
		 * @param value 值
		 * @param type 0为不是基础pickup
		 */		
		public function PickupImage(pickupAlias:String , pickupId:String = null , value:int =1 , type:String=null )
		{
			var url:String =  "res/pickup/pickup"+pickupAlias+".png" ;
			var pickupAlias:String ="pickup"+pickupAlias ;
			super(pickupAlias, url, true);
			
			_pkAlias = pickupAlias ;
			_pkId = pickupId ;
			_type = type ;
			mouseChildren =false ;
			mouseEnabled = false ;
			this._value = value ;
			visible = false ;
			setTimeout( init , Math.random()*600 );
		}
		
		private function init():void
		{
			visible = true ;
			SoundManager.instance.playSoundLootdrop();
			TweenLite.to(this, 0.5, {x: x+(75+Math.random()*60)*MathUtil.getRandomFlag()  , ease:Linear.easeNone});
			TweenLite.to(this, 0.5, {y: y+85+Math.random()*60 , ease:Bounce.easeOut , onComplete:inOver});
		}
		
		private function inOver():void {
			mouseEnabled = true ;
			_timeoutId = setTimeout( fly , 3000+Math.random()*2000 );
		}
		
		/**
		 * @param mouseTrigger 是否是鼠标触发的
		 */		
		public function fly( mouseTrigger:Boolean=false ):void
		{
			clearTimeout(_timeoutId);
			_timeoutId = 0 ;
			var target:DisplayObject ;
			var targetPoint:Point ;
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
						if(mouseTrigger) SoundManager.instance.playSoundPickupCoin();
						break ;
					case BasicPickup.PICKUP_ENERGY:
						temp="Energy";
						me.energy+=_value ;
						target = CenterViewContainer.instance.topBar.energyBar ;
						color = MapWordEffect.ENERGY_COLOR ;
						if(mouseTrigger) SoundManager.instance.playSoundPickupEnergy();
						break ;
					case BasicPickup.PICKUP_EXP:
						temp="Exp";
						me.exp+=_value ;
						target = CenterViewContainer.instance.topBar.expBar ;
						if(mouseTrigger) SoundManager.instance.playSoundPickupXp();
						break ;
					case BasicPickup.PICKUP_WOOD:
						temp="Wood";
						me.wood+=_value ;
						target = CenterViewContainer.instance.topBar.woodBar ;
						color = MapWordEffect.WOOD_COLOR ;
						if(mouseTrigger) SoundManager.instance.playSoundPickupWood();
						break ;
					case BasicPickup.PICKUP_STONE:
						temp="Stone";
						me.stone+=_value ;
						target = CenterViewContainer.instance.topBar.stoneBar ;
						color = MapWordEffect.STONE_COLOR ;
						if(mouseTrigger) SoundManager.instance.playSoundPickupStone();
						break ;
				}
				CenterViewContainer.instance.topBar.updateTopBar();
				var worldEffect:MapWordEffect = new MapWordEffect( temp+" +"+_value ,color );
				GameWorld.instance.addEffect( worldEffect , x , y-Math.random()*100 );
				targetPoint = new Point(target.x+CenterViewContainer.instance.x,target.y+CenterViewContainer.instance.y);
			}
			else
			{
				var pickupVO:PickupVO = PickupModel.instance.getPickupById( _pkId );
				if(pickupVO)
				{
					//添加到玩家pickup中
					PickupModel.instance.addPickup( pickupVO.pickupId , _value );
					if( pickupVO.type==ItemType.PICKUP_COLLECTION )
					{
						//弹出搜集箱
						target = RightBar.instance.collectionHud  ;
						RightBar.instance.showCollectionHud( pickupVO );
						targetPoint = new Point(target.x+RightBar.instance.x+CenterViewContainer.instance.x,target.y+CenterViewContainer.instance.y);
					}
					else
					{
						//飞到搜集箱中
						target=CenterViewContainer.instance.bottomBar.toolBox.btnBagTool ;
						var gpos:Point = target.localToGlobal(new Point(target.x , target.y));
						targetPoint = new Point(gpos.x,gpos.y);
					}
				}
			}
			var world:GameWorld = GameWorld.instance ;
			targetPoint.x = (targetPoint.x-world.x)/world.scaleX-world.sceneLayerOffsetX ;
			targetPoint.y = (targetPoint.y-world.y)/world.scaleX-world.sceneLayerOffsetY ;
			var obj:Object = {x:x + (targetPoint.x > x ? (-50) : (50)), y:y + (targetPoint.y - y) * 0.5, alpha:0.9};
			TweenLite.to( this , 1 , {bezier:[obj, {x:targetPoint.x , y:targetPoint.y, alpha:0}]  , onComplete:remove});
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
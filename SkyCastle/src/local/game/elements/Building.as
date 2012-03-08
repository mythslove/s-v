package local.game.elements
{
	import flash.display.MovieClip;
	
	import local.comm.GameSetting;
	import local.enum.BasicPickup;
	import local.enum.BuildingOperation;
	import local.enum.BuildingType;
	import local.game.GameWorld;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.EffectManager;
	import local.utils.PickupUtil;
	import local.views.effects.BaseMovieClipEffect;
	import local.views.effects.EffectPlacementBuilding;
	import local.views.effects.EffectPlacementDecoration;
	import local.views.effects.MapWordEffect;
	
	public class Building extends InteractiveBuilding
	{
		public var offsetY:Number ;//可用偏移Y
		
		public function Building(vo:BuildingVO)
		{
			super(vo);
			offsetY = Math.floor((buildingVO.baseVO.xSpan+buildingVO.baseVO.zSpan)*0.5-1)*GameSetting.GRID_SIZE ;
		}
		
		/**
		 * 发送操作到服务器
		 */		
		public function sendOperation( operation:String ):void
		{
			switch( operation )
			{
				case BuildingOperation.ADD:
					playPlaceEffect();
					CharacterManager.instance.updateCharacters( this );
					break ;
				case BuildingOperation.ROTATE:
					buildingVO.scale = scaleX ;
					CharacterManager.instance.updateCharacters( this );
					break ;
				case BuildingOperation.STASH:
					break ;
				case BuildingOperation.MOVE:
					playPlaceEffect();
					CharacterManager.instance.updateCharacters( this );
					break ;
				case BuildingOperation.SELL :
					break ;
			}
		}
		
		/* 播放放置的动画*/
		protected function playPlaceEffect():void
		{
			var placementMC:MovieClip;
			var type:String = BuildingType.getSumType( buildingVO.baseVO.type );
			if(type==BuildingType.BUILDING){
				placementMC= new  EffectPlacementBuilding ();
			}else if(type==BuildingType.DECORATION){
				placementMC= new  EffectPlacementDecoration ();
			}
			if(placementMC){
				
				var placementEffect:BaseMovieClipEffect = EffectManager.instance.createMapEffect(placementMC);
				placementEffect.y = offsetY+this.screenY ;
				placementEffect.x = this.screenX;
				GameWorld.instance.effectScene.addChild(placementEffect);
			}
		}
		
		override public function onClick():void
		{
			characterMoveTo(CharacterManager.instance.hero);
			PickupUtil.addPickup2Wold(BasicPickup.PICKUP_COIN,32,screenX,screenY-offsetY);
		}
		
		/**
		 * 人移动到此建筑旁边或上面 
		 * @param character
		 */
		protected function characterMoveTo( character:Character):void
		{
			var result:Boolean ;
			if(!baseBuildingVO.walkable){
				var arr:Array = getRoundAblePoint(); 
				if(arr.length>0){
					arr.sortOn("x", Array.DESCENDING |Array.NUMERIC );
					result = character.searchToRun( arr[0].x/_size , arr[0].z/_size);
				}
			}else{
				result = character.searchToRun( nodeX , nodeZ );
			}
			if(character is Hero &&!result) {
				var effect:MapWordEffect = new MapWordEffect("I can 't get here!");
				GameWorld.instance.addEffect( effect , screenX , screenY);
			}
		}
	}
}
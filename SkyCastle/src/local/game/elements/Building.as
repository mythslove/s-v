package local.game.elements
{
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	
	import local.comm.GameSetting;
	import local.enum.BuildingOperation;
	import local.enum.BuildingType;
	import local.game.GameWorld;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.EffectManager;
	import local.views.effects.BaseMovieClipEffect;
	import local.views.effects.EffectPlacementBuilding;
	import local.views.effects.EffectPlacementDecoration;
	import local.views.effects.MapWordEffect;
	
	public class Building extends InteractiveBuilding
	{
		public var offsetY:Number ;//可用偏移Y
		protected var _timeoutId:int ;
		
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
			CollectQueueUtil.instance.addBuilding( this ); //添加到处理队列中
			enable = false ;
		}
		
		/**
		 * 人移动到此建筑旁边或上面 
		 * @param character
		 */
		public function characterMoveTo( character:Character):void
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
			if(character is Hero && !result) 
			{
				var effect:MapWordEffect = new MapWordEffect("I can 't get here!");
				GameWorld.instance.addEffect( effect , screenX , screenY);
				CollectQueueUtil.instance.clear(); //不能走到建筑旁边，则清除队列
			}
		}
		
		/**
		 * 英雄移动到建筑旁边，开始执行动作 
		 */		
		public function execute():void
		{
			itemLayer.alpha=1 ;
		}
		
		/**
		 * 掉物品 ，并接着下一个收集
		 */		
		public function showPickup():void
		{
			enable=true ;
			CollectQueueUtil.instance.nextBuilding();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_timeoutId>0){
				clearTimeout(_timeoutId);
			}
		}
	}
}
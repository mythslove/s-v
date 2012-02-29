package local.game.elements
{
	import flash.display.MovieClip;
	
	import local.comm.GameSetting;
	import local.enum.BuildingOperation;
	import local.enum.BuildingType;
	import local.game.GameWorld;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.EffectManager;
	import local.views.effects.BaseMovieClipEffect;
	import local.views.effects.EffectPlacementBuilding;
	import local.views.effects.EffectPlacementDecoration;
	
	public class Building extends InteractiveBuilding
	{
		public function Building(vo:BuildingVO)
		{
			super(vo);
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
					break ;
				case BuildingOperation.ROTATE:
					buildingVO.scale = scaleX ;
					break ;
				case BuildingOperation.STASH:
					break ;
				case BuildingOperation.MOVE:
					playPlaceEffect();
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
				var offsetY:Number = Math.floor((buildingVO.baseVO.xSpan+buildingVO.baseVO.zSpan)*0.5-1)*GameSetting.GRID_SIZE ;
				var placementEffect:BaseMovieClipEffect = EffectManager.instance.createMapEffect(placementMC);
				placementEffect.y = offsetY+this.screenY ;
				placementEffect.x = this.screenX;
				GameWorld.instance.effectScene.addChild(placementEffect);
			}
		}
	}
}
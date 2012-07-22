package local.game.elements
{
	import flash.events.Event;
	
	import local.comm.GameData;
	import local.enum.AvatarAction;
	import local.enum.ItemType;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BaseCharacterVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CollectQueueUtil;
	import local.utils.SettingCookieUtil;

	/**
	 * 英雄 
	 * @author zzhanglin
	 */	
	public class Hero extends Character
	{
		
		public function Hero()
		{
			var baseVO:BaseCharacterVO = new BaseCharacterVO();
			baseVO.resId="Basic_Avatar";
			baseVO.alias="Basic_AvatarMale";
			baseVO.walkable=1 ;
			baseVO.xSpan = 1 ;
			baseVO.zSpan = 1 ;
			baseVO.layer = 2 ;
			baseVO.name="Sky Castle";
			baseVO.description = "Hello ! I am "+PlayerModel.instance.me.name+" .";
			baseVO.type = ItemType.CHACTERS ;
			var vo:BuildingVO = new BuildingVO();
			vo.baseVO = baseVO ;
			super(vo);
		}
		
		/* 添加到舞台上*/
		override protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			createCharacterSkin();
			this.gotoAndPlay(AvatarAction.ACTIVATEWONDER );
		}
		
		override public function searchToRun(endNodeX:int, endNodeZ:int):Boolean
		{
			var result:Boolean = super.searchToRun( endNodeX, endNodeZ);
			if(result && !nextPoint){
				//如果有路，但英雄就在此路的终点
				arrived();
			}
			return result ;
		}
		
		/**
		 * 英雄到达目的地了 
		 */		
		override protected function arrived():void
		{
			var building:Building = CollectQueueUtil.instance.currentBuilding ;
			if( building){
				if(this.screenX>building.screenX){
					this.scaleX = -1;
				}else{
					this.scaleX = 1;
				}
				building.execute();
			}
			if(GameData.isHome){
				SettingCookieUtil.saveHeroPoint( nodeX , nodeZ );
			}
		}
		
		
		override public function onClick():void
		{
			if(!CollectQueueUtil.instance.currentBuilding)
			{
				//说话
			}
		}
	}
}
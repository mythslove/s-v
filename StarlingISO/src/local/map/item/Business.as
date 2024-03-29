package local.map.item
{
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingStatus;
	import local.enum.PickupType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.pk.FlyLabelImage;
	import local.map.pk.PickupImages;
	import local.model.PlayerModel;
	import local.view.CenterViewLayer;
	import local.vo.BuildingVO;
	
	public class Business extends Building
	{
		public function Business(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function onClick():void
		{
			if( GameData.villageMode==VillageMode.NORMAL)
			{
				if( buildingVO.status==BuildingStatus.LACK_MATERIAL)
				{
					flash(true);
					if(PlayerModel.instance.me.goods>buildingVO.baseVO.goodsCost)
					{
						CenterViewLayer.instance.topBar.costGoodsToBuilding( this );
						//显示减去多少goods
						PlayerModel.instance.changeGoods( -buildingVO.baseVO.goodsCost ) ;
						var flyImg:FlyLabelImage = new FlyLabelImage( PickupType.GOOD , -buildingVO.baseVO.goodsCost ) ;
						flyImg.x = screenX ;
						flyImg.y = screenY-20*GameSetting.GAMESCALE ;
						GameWorld.instance.effectScene.addChild( flyImg );
						//开始生产
						buildingVO.haveGoods = true ;
						startProduct() ;
						removeBuildingFlagIcon() ;
					}else{
						//没有足够的goods
//						CenterViewLayer.instance.gameTip.showLackGoods( this ) ;
					}
				}
				else if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
				{
					flash(true);
					collect();
				}
				else
				{
					super.onClick();
				}
			}
			else
			{
				super.onClick();
			}
		}

		
		/* 收获*/
		private function collect():void
		{
			if( reduceEnergy() ){
				if(buildingVO.baseVO.earnCoin>0 ){
					PickupImages.addPK( PickupType.COIN , buildingVO.baseVO.earnCoin ,screenX,screenY,_xSpan );
				}
				if( buildingVO.baseVO.earnExp>0 ){
					PickupImages.addPK( PickupType.EXP , buildingVO.baseVO.earnExp ,screenX,screenY,_xSpan );
				}
				
				buildingVO.status = BuildingStatus.LACK_MATERIAL ;
				buildingVO.haveGoods = false ;
				showBuildingFlagIcon();
				
				//任务判断
//				QuestUtil.instance.handleAddCount( QuestType.COLLECT , buildingVO.name );
			}
		}
	}
}
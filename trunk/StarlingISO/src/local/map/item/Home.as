package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.VillageMode;
	import local.vo.BuildingVO;
	
	public class Home extends Building
	{
		public function Home(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function onClick():void
		{
			if( GameData.villageMode==VillageMode.NORMAL)
			{
				if( buildingVO.status==BuildingStatus.PRODUCTION_COMPLETE)
				{
					flash(true);
					//收钱
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
//			if( reduceEnergy() ){
//				var pkImgs:PickupImages = new PickupImages();
//				if(buildingVO.baseVO.earnCoin>0 ){
//					pkImgs.addPK( PickupType.COIN , buildingVO.baseVO.earnCoin );
//				}
//				if( buildingVO.baseVO.earnExp>0 ){
//					pkImgs.addPK( PickupType.EXP , buildingVO.baseVO.earnExp );
//				}
//				pkImgs.x = screenX ;
//				pkImgs.y = screenY ;
//				GameWorld.instance.effectScene.addChild( pkImgs );
//				
//				startProduct();
//				showBuildingFlagIcon();
//				
//				//收Comp-----------------------测试用------------------
//				if(Math.random()>0.85){
//					setTimeout( collectComp , 100 , "Wood" , 2 );
//					setTimeout( collectComp , 800 , "Stone" , 1 );
//				}
//				
//				//任务判断
//				QuestUtil.instance.handleAddCount( QuestType.COLLECT , buildingVO.name );
//			}
		}
	}
}
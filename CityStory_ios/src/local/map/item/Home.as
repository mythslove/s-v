package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.PickupType;
	import local.enum.QuestType;
	import local.enum.VillageMode;
	import local.map.pk.PickupImages;
	import local.util.QuestUtil;
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
			if( reduceEnergy() ){
				if(buildingVO.baseVO.earnCoin>0 ){
					PickupImages.addPK( PickupType.COIN , buildingVO.baseVO.earnCoin , screenX ,screenY,_xSpan );
				}
				if( buildingVO.baseVO.earnExp>0 ){
					PickupImages.addPK( PickupType.EXP , buildingVO.baseVO.earnExp , screenX ,screenY,_xSpan );
				}
				
				startProduct();
				showBuildingFlagIcon();
				
				//收Comp-----------------------测试用------------------
				if(Math.random()>0.25){
					PickupImages.addPK( "Wood" ,2  , screenX ,screenY ,_xSpan);
					PickupImages.addPK( "Stone" ,1  , screenX ,screenY,_xSpan );
				}
				
				//任务判断
				QuestUtil.instance.handleCount( QuestType.COLLECT_BY_NAME , buildingVO.name );
				QuestUtil.instance.handleCount( QuestType.COLLECT_BY_SONTYPE , buildingVO.baseVO.subClass );
				QuestUtil.instance.handleCount( QuestType.COLLECT_BY_TYPE , buildingVO.baseVO.type );
			}
		}
	}
}
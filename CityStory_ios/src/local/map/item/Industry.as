package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.PickupType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.pk.PickupImages;
	import local.vo.BuildingVO;
	
	public class Industry extends Building
	{
		public function Industry(buildingVO:BuildingVO)
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
					//弹出product窗口
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
				var pkImgs:PickupImages = new PickupImages();
				if(buildingVO.product.earnExp>0 ){
					pkImgs.addPK( PickupType.EXP , buildingVO.product.earnExp );
				}
				if( buildingVO.product.earnGoods>0 ){
					pkImgs.addPK( PickupType.GOOD , buildingVO.product.earnGoods );
				}
				pkImgs.x = screenX ;
				pkImgs.y = screenY ;
				GameWorld.instance.effectScene.addChild( pkImgs );
				
				buildingVO.status = BuildingStatus.LACK_MATERIAL ;
				buildingVO.product = null ;
				showBuildingFlagIcon();
			}
		}
	}
}
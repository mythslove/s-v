package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.PickupType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.pk.PickupImages;
	import local.vo.BuildingVO;

	/**
	 * 地图上基础建筑，主要是为了好看用的 
	 * @author zzhanglin
	 */	
	public class BasicBuilding extends Building
	{
		public function BasicBuilding( buildingVO:BuildingVO )
		{
			super(buildingVO);
		}
		
		override public function onClick():void
		{
			if( GameData.villageMode==VillageMode.NORMAL && buildingVO.status==BuildingStatus.BUILDING ){
				flash(true);
				//点击一次砍一次 ，并加经验，减能量
				if(reduceEnergy()){
					buildClick();
				}
			}
		}
		
		/*砍树时点击*/
		override protected function buildClick():void
		{
			++buildingVO.buildClick ;
			
			//掉修建时的经验
			if(buildingVO.baseVO.clickExp>0){
				var pkImgs:PickupImages = new PickupImages();
				pkImgs.addPK( PickupType.EXP , buildingVO.baseVO.clickExp );
				pkImgs.x = screenX ;
				pkImgs.y = screenY ;
				GameWorld.instance.effectScene.addChild( pkImgs );
			}
			
			if( buildingVO.buildClick >= buildingVO.baseVO.click )
			{
				GameWorld.instance.buildingScene.removeBuilding( this );
				this.dispose() ;
			}else{
				showBuildingFlagIcon() ;
			}
		}
	}
}
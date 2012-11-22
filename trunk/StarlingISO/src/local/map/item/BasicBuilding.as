package local.map.item
{
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.PickupType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.cell.BuildingObject;
	import local.map.pk.PickupImages;
	import local.model.BuildingModel;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
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
		
		override public function showUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			_buildingObject = new BuildingObject(name,barvo);
			addChildAt(_buildingObject,0);
			this.scaleX = buildingVO.rotation ;
			showBuildingFlagIcon();
		}
		
		/*砍树时点击*/
		override protected function buildClick():void
		{
			++buildingVO.buildClick ;
			
			//掉修建时的经验
			if(buildingVO.baseVO.clickExp>0){
				PickupImages.addPK( PickupType.EXP , buildingVO.baseVO.clickExp,screenX,screenY,_xSpan );
			}
			
			if( buildingVO.buildClick >= buildingVO.baseVO.click )
			{
				GameWorld.instance.buildingScene.removeBuilding( this );
				BuildingModel.instance.removeBuilding( this );
				this.dispose() ;
				//砍树任务
//				QuestUtil.instance.handleAddCount( QuestType.CHOP );
			}else{
				showBuildingFlagIcon() ;
			}
		}
	}
}
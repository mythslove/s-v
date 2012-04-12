package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.enum.BuildingStatus;
	import local.enum.MouseStatus;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.MouseManager;
	
	/**
	 * 工厂，房子的等建筑的基类 
	 * 修建完成时最后一步，需要判断材料
	 * @author zzhanglin
	 */	
	public class Architecture extends Building
	{
		public function Architecture(vo:BuildingVO)
		{
			super(vo);
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(!MouseManager.instance.checkControl() )
			{
				if(buildingVO.buildingStatus == BuildingStatus.BUILDING )
				{
					MouseManager.instance.mouseStatus = MouseStatus.BUILD_BUILDING ;
				}
			}
		}
		
		override public function onClick():void
		{
			super.onClick();
			switch( buildingVO.buildingStatus )
			{
				case BuildingStatus.BUILDING:
					break;
				case BuildingStatus.FINISH :
					break ;
				case BuildingStatus.PRODUCT:
					break;
				case BuildingStatus.HARVEST :
					break ;
			}
		}
		
		override protected function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug(e.service+"."+e.method , e.result);
			switch( e.method)
			{
				case "build":
					break ;
			}
		}
		
		override public function execute():Boolean
		{
			super.execute() ;
			
			if( buildingVO.buildingStatus==BuildingStatus.BUILDING && buildingVO.currentStep+1==buildingVO.baseVO.step && baseBuildingVO.materials)
			{
				//判断材料
				return false ;
			}
			return true ;
		}
	}
}
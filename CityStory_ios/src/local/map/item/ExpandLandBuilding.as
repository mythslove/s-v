package local.map.item
{
	import local.map.cell.BuildingObject;
	import local.util.EmbedsManager;
	import local.vo.BuildingVO;
	
	/**
	 * 正在扩地时，显示的建筑 
	 * @author zhouzhanglin
	 */	
	public class ExpandLandBuilding extends Building
	{
		public function ExpandLandBuilding(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		override public function showUI():void
		{
			buildingObject = new BuildingObject(EmbedsManager.instance.getAnimResVOByName("ExpandLandBuilding"));
			addChildAt(buildingObject,0);
		}
		
		override public function flash( value:Boolean):void
		{ }
	}
}
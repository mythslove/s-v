package local.map.item
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResVO;
	
	import local.map.cell.BuildingObject;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.BuildingVO;

	/**
	 * 地图上基础建筑，主要是为了好看用的 
	 * @author zzhanglin
	 */	
	public class BasicBuilding extends BaseBuilding
	{
		
		public function BasicBuilding( buildingVO:BuildingVO )
		{
			super(buildingVO);
		}
		
		override public function showUI():void
		{
			if(ResourceUtil.instance.checkResLoaded(name)){
				changeUI();
			}else{
				ResourceUtil.instance.addEventListener( name , resLoadedHandler );
				ResourceUtil.instance.loadRes( new ResVO(name, "basic/"+name+".bd"));
			}
		}
		
		private function resLoadedHandler( e:ResLoadedEvent):void
		{
			ResourceUtil.instance.removeEventListener( name , resLoadedHandler );
			changeUI();
		}
		
		private function changeUI():void
		{
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			buildingObject = new BuildingObject(barvo);
			addChildAt(buildingObject,0);
		}
	}
}
package local.map.item
{
	import local.map.cell.RoadObject;
	import local.map.interfaces.IRoad;
	import local.util.ResourceUtil;
	import local.vo.BuildingVO;
	import local.vo.RoadResVO;

	/**
	 * 游戏中的水和路 
	 * @author zhouzhanglin
	 */	
	public class Road extends BaseBuilding implements IRoad 
	{
		private var _direction:String ;
		public function get direction():String{
			return _direction;
		}
		
		public function Road( buildingVO:BuildingVO )
		{
			super(buildingVO);
		}
		
		override public function showUI():void
		{
			if(roadObject){
				roadObject.show( this._direction);
			} else {
				var roadResVO:RoadResVO = ResourceUtil.instance.getResVOByResId( name ).resObject as RoadResVO ;
				roadObject = new RoadObject( name , roadResVO );
				addChildAt(roadObject,0);
				roadObject.show( this._direction);
			}
		}
		
		public function updateUI( direction:String ):void
		{
			_direction = direction ;
			showUI();
		}
	}
}
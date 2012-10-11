package local.map.item
{
	import local.map.cell.RoadObject;
	import local.map.interfaces.IRoad;
	import local.util.ResourceUtil;
	import local.vo.BuildingVO;
	import local.vo.RoadResVO;

	/**
	 * 游戏中的水和路 或其他地上的装饰块
	 * @author zhouzhanglin
	 */	
	public class Road extends BaseBuilding implements IRoad 
	{
		private var _direction:String="";
		public function get direction():String{
			return _direction;
		}
		
		public function Road( buildingVO:BuildingVO )
		{
			super(buildingVO);
			_direction = buildingVO.direction ;
		}
		
		override public function showUI():void
		{
			if(_roadObject){
				_roadObject.show( this._direction);
			} else {
				var roadResVO:RoadResVO = ResourceUtil.instance.getResVOByResId( name ).resObject as RoadResVO ;
				_roadObject = new RoadObject( name , roadResVO );
				addChildAt(_roadObject,0);
				_roadObject.show( this._direction);
			}
		}
		
		public function updateUI( direction:String ):void
		{
			if(_roadObject && _roadObject.roadResVO && 
				_roadObject.roadResVO.offsetXs.hasOwnProperty(name+direction)){
				_direction = direction ;
				buildingVO.direction = direction ;
				showUI();
			}
		}
	}
}
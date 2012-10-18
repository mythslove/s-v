package local.map.item
{
	import flash.events.Event;
	
	import local.enum.BuildingStatus;
	import local.map.cell.BuildStatusObject;
	import local.util.GameTimer;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.BuildingVO;
	
	public class Building extends BaseBuilding
	{
		public var gameTimer:GameTimer ;
		
		public function Building(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
		
		public function recoverStatus():void
		{
			
		}
		
		public function checkRoadAndIcon():void
		{
			
		}
		
		protected function buildClick():void
		{
			
		}
		
		override public function showUI():void 
		{
			if( buildingVO.status==BuildingStatus.BUILDING)
			{
				if( buildingVO.buildClick<=1){ 
					if(!_buildStatusObj) {
						var barvs:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( "BuildStatus_"+xSpan+"_0" ).resObject as  Vector.<BitmapAnimResVO>;
						_buildStatusObj = new BuildStatusObject(barvs[0].resName+"_000" ,barvs  );
					}
					addChildAt( _buildStatusObj , 0 );
				}else{
					if(_buildStatusObj){
						removeChild( _buildStatusObj , true );
					}
					barvs = ResourceUtil.instance.getResVOByResId( "BuildStatus_"+xSpan+"_1" ).resObject as  Vector.<BitmapAnimResVO>;
					_buildStatusObj = new BuildStatusObject(barvs[0].resName+"_000" ,barvs  );
					addChildAt( _buildStatusObj , 0 );
				}
			}else{
				super.showUI();
			}
//			showBuildingFlagIcon() ;
		} 
		
		protected function createGameTimer(duration:int):void
		{
			
		}
		protected function clearGameTimer():void
		{
		}
		protected function gameTimerCompleteHandler(e:flash.events.Event):void
		{
			
		}
	}
}
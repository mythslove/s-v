package local.map.item
{
	import flash.events.Event;
	
	import local.comm.GameData;
	import local.enum.BuildingStatus;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.cell.BuildingObject;
	import local.model.BuildingModel;
	import local.model.MapGridDataModel;
	import local.model.ShopModel;
	import local.util.BuildingFactory;
	import local.util.EmbedsManager;
	import local.util.GameUtil;
	import local.view.CenterViewLayer;
	import local.vo.BaseBuildingVO;
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
			buildingVO.status = BuildingStatus.EXPANDING ;
		}
		
		override public function showUI():void
		{
			_buildingObject = new BuildingObject(EmbedsManager.instance.getAnimResVOByName("ExpandBuilding"));
			addChildAt(_buildingObject,0);
		}
		
		override public function flash( value:Boolean):void
		{ }
		
		override public function onClick():void
		{
			if(GameData.villageMode==VillageMode.NORMAL){
				super.onClick() ;
				CenterViewLayer.instance.gameTip.showBuildingTip( this );
			}
		}
		
		override public function startProduct():void
		{
			clearGameTimer();
			createGameTimer( GameUtil.getExpandTime() );
		}
		
		/*计时完成*/
		override protected function gameTimerCompleteHandler( e:Event ):void
		{
			MapGridDataModel.instance.landGridData.setWalkable( nodeX/4 , nodeZ/4 , true );
			//删除此对象
			GameWorld.instance.buildingScene.removeBuilding( this );
			BuildingModel.instance.removeBuilding( this );
			//随机添加几棵树
			var basics:Vector.<BaseBuildingVO> = ShopModel.instance.basicBuildings ;
			if( basics){
				var span:int = buildingVO.baseVO.span;
				var building:BaseBuilding ;
				for( var i:int = 0 ; i <span ; ++i ){
					for( var j:int = 0 ; j<span ; ++j ){
						if ( Math.random()>.8 && GameWorld.instance.buildingScene.gridData.getNode( nodeX+i , nodeZ+j).walkable )
						{
							building = BuildingFactory.createBuildingByBaseVO(  basics[(Math.random()*basics.length)>>0 ] ) ;
							building.nodeX = nodeX+i ;
							building.nodeZ = nodeZ+j ;
							building.buildingVO.nodeX = nodeX+i ;
							building.buildingVO.nodeZ = nodeZ+j ;
							building.buildingVO.status=BuildingStatus.BUILDING ; //修建状态，说明可以点击
							GameWorld.instance.buildingScene.addBuilding( building );
							BuildingModel.instance.addBuilding( building );
						}
					}
				}
			}
			//清理
			this.dispose();
			GameData.hasExpanding = false ;
			GameWorld.instance.removeExpandSigns();
			GameWorld.instance.addExpandSign(true);
		}
	}
}
package local.map.item
{
	import flash.events.Event;
	
	import local.map.GameWorld;
	import local.map.cell.BuildingObject;
	import local.model.BuildingModel;
	import local.model.LandModel;
	import local.model.MapGridDataModel;
	import local.model.ShopModel;
	import local.util.BuildingFactory;
	import local.util.EmbedsManager;
	import local.vo.BaseBuildingVO;
	import local.vo.BuildingVO;
	import local.vo.LandVO;
	
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
			_buildingObject = new BuildingObject(EmbedsManager.instance.getAnimResVOByName("ExpandLandBuilding"));
			addChildAt(_buildingObject,0);
		}
		
		override public function flash( value:Boolean):void
		{ }
		
		/*计时完成*/
		override protected function gameTimerCompleteHandler( e:Event ):void
		{
			//删除此对象
			GameWorld.instance.buildingScene.removeBuilding( this );
			//画地图
			var landVO:LandVO = new LandVO();
			landVO.nodeX = nodeX ;
			landVO.nodeZ = nodeZ ;
			LandModel.instance.lands.push(landVO);
			GameWorld.instance.drawMapZoneByFill( landVO );
			//随机添加几棵树
			var basics:Vector.<BaseBuildingVO> = ShopModel.instance.basicBuildings ;
			if( basics){
				var span:int = buildingVO.baseVO.span;
				var building:BaseBuilding ;
				for( var i:int = 0 ; i <span ; ++i ){
					for( var j:int = 0 ; j<span ; ++j ){
						if ( Math.random()>.5 && GameWorld.instance.buildingScene.gridData.getNode( nodeX+i , nodeZ+j).walkable )
						{
							building = BuildingFactory.createBuildingByBaseVO(  basics[(Math.random()*basics.length)>>0 ] ) ;
							GameWorld.instance.buildingScene.addBuilding( building );
							BuildingModel.instance.addBuilding( building );
						}
					}
				}
			}
			
			//清理
			this.dispose();
		}
	}
}
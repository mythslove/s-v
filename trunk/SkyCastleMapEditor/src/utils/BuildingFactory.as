package utils
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import map.Building;
	
	import vos.BuildingVO;

	public class BuildingFactory
	{
		public static function createBuildingByType( type:String , isRandom:Boolean=true ):Building
		{
			var building:Building ;
			var vo :BuildingVO = new BuildingVO();
			var cls:Class = getDefinitionByName(type);
			var skin:MovieClip = new cls() as MovieClip;
			if(skin){
				skin.stop();
				var index:int  =1;
				if(isRandom){
					index = Math.ceil( Math.random()*skin.totalFrames ) ;
					skin.gotoAndStop(index);
				}
				vo.clsName = type ;
				vo.frame = index ;
				building = new Building(vo);
				building.itemLayer.addChild(skin);
			}
			return building ;
		}
		
		public static function createBuildingByVO( vo:BuildingVO ):Building
		{
			var cls:Class = getDefinitionByName(vo.clsName);
			var skin:MovieClip = new cls() as MovieClip;
			skin.gotoAndStop(vo.frame);
			var building:Building = new Building(vo);
			building.itemLayer.addChild(skin);
		}
	}
}
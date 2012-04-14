package local.utils
{
	import flash.geom.Vector3D;
	
	import local.game.elements.Building;
	import local.game.elements.Character;
	import local.game.elements.Hero;
	import local.game.elements.NPC;

	/**
	 * 场景上的人管理类 
	 * @author zzhanglin
	 */	
	public class CharacterManager
	{
		private static var _instance:CharacterManager ;
		public static function get instance():CharacterManager
		{
			if(!_instance) _instance = new CharacterManager();
			return _instance ;
		}
		//================================
		
		/**英雄*/
		public var hero:Hero ;
		
		/**所有的npc*/
		public var npcs:Vector.<NPC> ;
		
		/**
		 * 更新所有的人，以免得人不能移动 
		 * @param building
		 */		
		public function updateCharacters( building:Building ):void
		{
			if(!building.baseBuildingVO.walkable){
				updateCharacter(hero,building);
				if(npcs){
					for each( var npc:NPC in npcs){
						updateCharacter(npc,building);
					}
				}
			}
		}
		
		private function updateCharacter ( character:Character , building:Building ):void
		{
			var spans:Vector.<Vector3D> = building.spanPosition ;
			for each( var vec:Vector3D in spans)
			{
				if(character.x == vec.x && character.z == vec.z )
				{
					var arr:Array = building.getRoundAblePoint() ;
					if(arr&&arr.length){
						character.x = arr[arr.length-1].x ;
						character.z = arr[arr.length-1].z ;
						character.sort();
						break ;
					}
				}
			}
		}
	}
}
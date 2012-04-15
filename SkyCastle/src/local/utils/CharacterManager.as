package local.utils
{
	import bing.iso.IsoScene;
	
	import flash.geom.Vector3D;
	
	import local.comm.GameData;
	import local.game.GameWorld;
	import local.game.elements.Building;
	import local.game.elements.Character;
	import local.game.elements.Hero;
	import local.game.elements.NPC;
	import local.game.npcs.NpcAnnie;
	import local.game.npcs.NpcNick;
	import local.game.npcs.NpcRocky;
	import local.game.npcs.NpcTony;

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
		
		/*所有的npc类名*/
		private var _allNpcClass:Vector.<Class> = Vector.<Class>([NpcNick,NpcTony,NpcAnnie,NpcRocky]);
		
		/**所有的npc*/
		public var npcs:Vector.<NPC> ;
		
		/**
		 * 添加npc到世界中 
		 */		
		public function addNpcToWorld():void
		{
			npcs = null ;
			if(GameData.isHome){
				var len:int = _allNpcClass.length ;
				npcs = new Vector.<NPC>(len ,true );
				var npc:NPC ;
				for( var i:int = 0 ; i<len-2 ; ++i){
					npc = new 	_allNpcClass[i]() as NPC ;
					npc.nodeX = GameData.heroBornPoint1.nodeX ;
					npc.nodeZ = GameData.heroBornPoint1.nodeZ ;
					npcs[i] = npc ;
					var scene:IsoScene = GameWorld.instance.getBuildingScene( npc.nodeX , npc.nodeZ );
					scene.addIsoObject( npc , false );
				}
				
				for( i = 0 ; i<len ; ++i){
					npc = new 	_allNpcClass[i]() as NPC ;
					npc.nodeX = GameData.heroBornPoint2.nodeX ;
					npc.nodeZ = GameData.heroBornPoint2.nodeZ ;
					npcs[i] = npc ;
					scene = GameWorld.instance.getBuildingScene( npc.nodeX , npc.nodeZ );
					scene.addIsoObject( npc, false );
				}
				
				for( i = 0 ; i<len ; ++i){
					npc = new 	_allNpcClass[i]() as NPC ;
					npc.nodeX = GameData.heroBornPoint3.nodeX ;
					npc.nodeZ = GameData.heroBornPoint3.nodeZ ;
					npcs[i] = npc ;
					scene = GameWorld.instance.getBuildingScene( npc.nodeX , npc.nodeZ );
					scene.addIsoObject( npc, false );
				}
			}
		}
		
		
		/**
		 * 更新所有的人，以免得人不能移动 
		 * @param building
		 */		
		public function updateCharactersPos( building:Building ):void
		{
			if(!building.baseBuildingVO.walkable){
				updateCharacterPoint(hero,building);
				if(npcs){
					for each( var npc:NPC in npcs){
						updateCharacterPoint(npc,building);
					}
				}
			}
		}
		
		private function updateCharacterPoint ( character:Character , building:Building ):void
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
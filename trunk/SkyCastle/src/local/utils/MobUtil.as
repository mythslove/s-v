package local.utils
{
	import bing.utils.MathUtil;
	
	import local.game.elements.Building;
	import local.game.elements.Mob;
	import local.model.buildings.MapBuildingModel;

	public class MobUtil
	{
		public static const RADIU:int = 300 ;
		
		/**
		 * 判断建筑是否在怪的攻击范围内 ，如果在攻击范围内，则
		 * @param building
		 * @return 如果在范围内，返回false
		 */		
		public static function checkMobZoneAndAction( building:Building ):Boolean
		{
			var mobs:Array = MapBuildingModel.instance.mobs ;
			var len:int = mobs.length ;
			var mob:Mob ;
			for( var i:int = 0 ; i<len ; ++i)
			{
				mob = mobs[i] as Mob ;
				if(MathUtil.distance(building.screenX,building.screenY,mob.screenX,mob.screenY)<RADIU )
				{
					CollectQueueUtil.instance.clear(true); //清除英雄队列
					mob.actionAttack() ;
					return false ;
				}
			}
			return true;
		}
	}
}
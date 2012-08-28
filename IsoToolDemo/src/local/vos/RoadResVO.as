package local.vos
{
	import flash.utils.Dictionary;

	/**
	 * 路资源VO 
	 * @author zhouzhanglin
	 */	
	public class RoadResVO
	{
		public var bmds:Dictionary =new Dictionary() ; //key为name+方向 , value为bitmap
		public var offsetXs:Dictionary = new Dictionary(); //key为name+方向 , value为offsetX
		public var offsetYs:Dictionary = new Dictionary(); //key为name+方向 , value为offsetY
	}
}
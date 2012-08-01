package bing.starling.iso.path
{
	/**
	 * Represents a specific node evaluated as part of a pathfinding algorithm.
	 */
	public class SNode
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var walkable:Boolean = false;
		public var parent:SNode;
		public var costMultiplier:Number = 1.0;
		
		public function SNode(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
		
		public function clone():SNode
		{
			var node:SNode = new SNode(x,y);
			return node;
		}
	}
}
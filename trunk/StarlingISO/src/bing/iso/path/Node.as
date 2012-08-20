package  bing.iso.path
{
	/**
	 * Represents a specific node evaluated as part of a pathfinding algorithm.
	 */
	public class Node
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var walkable:Boolean = false;
		public var parent:Node;
		public var links:Array;
		public var version:int = 1; 
		
		public function Node(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
		
		public function clone():Node
		{
			var node:Node = new Node(x,y);
			return node;
		}
	}
}
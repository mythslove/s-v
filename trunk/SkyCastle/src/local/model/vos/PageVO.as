package local.model.vos
{
	/**
	 * 用于分页 
	 * @author zhouzhanglin
	 * 
	 */	
	public class PageVO
	{
		public var currentPage:int;			//当前页
		public var totalPages:int;				//总页数
		public var totalItems:int;				//总条目数
		public var data:Array;					//页面数据
		
		public function hasPrevPage():Boolean
		{
			return currentPage > 1 ? true : false;
		}
		
		public function hasNextPage():Boolean
		{
			return currentPage < totalPages ? true : false;
		}
	}
}
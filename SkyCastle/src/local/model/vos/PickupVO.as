package local.model.vos
{
	/**
	 * 收集物的子元素，传说，材料 
	 * @author zzhanglin
	 */	
	public class PickupVO
	{
		public var alias:String; //英文别名，用于拼图片路径，唯一键
		
		public var name:String ; //名称
		
		public var type:String ; //ItemType中的pickup类型常量
		
		public var descript:String ; //描述
		
		public var num:int =1 ; //数量，用于统计
		
		/** 图标路径 */
		public function get url():String 
		{
			return "res/pickup/pickup"+alias+".png";
		}
	}
}
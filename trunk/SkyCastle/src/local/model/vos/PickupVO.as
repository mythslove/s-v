package local.model.vos
{
	/**
	 * 收集物的子元素，传说，材料 
	 * @author zzhanglin
	 */	
	public class PickupVO
	{
		public var pickupId:String ;
		
		public var alias:String; //英文别名，用于拼图片路径
		
		public var name:String ; //名称
		
		public var type:String ; //ItemType中的pickup类型常量
		
		public var describe:String ; //描述
		
		/** 图标路径 */
		public function get url():String 
		{
			return "res/pickup/pickup"+alias+".png";
		}
		
		public function get thumbAlias():String{
			return "pickup"+alias ;
		}
	}
}
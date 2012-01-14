package models.vos
{
	/**
	 * 建筑基础类 
	 * @author zhouzhanglin
	 */	
	public class BuildingBaseVO
	{
		public var baseId:String; //基础id
		public var title:String; //标题
		public var info:String;//说明
		public var type:int ; //类型
		public var xSpan:int; //占用x轴的节点长度
		public var zSpan:int; //占用z轴的节点长度
		public var clsName:String; //需要反射的元件类名
		public var resId:String ; //此资源的唯一id , 可以用资源的hash
		public var url:String; //swf文件路径
		public var thumb:String; //缩略图路径
		public var animClsName:String; //如果有动画，则动画的别名
		public var layerType:int ; //0为ground层，1为建筑层
		public var walkable:Boolean=true ; //false为不能从上面通过。true为能从上面是通过，寻路时忽略
	}
}
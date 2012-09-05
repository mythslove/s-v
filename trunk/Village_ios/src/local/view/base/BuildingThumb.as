package local.view.base
{
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;
	import local.vo.RoadResVO;
	
	/**
	 * 建筑的缩略图 
	 * @author zhouzhanglin
	 */	
	public class BuildingThumb extends Bitmap
	{
		/**
		 * 建筑的缩略图构造函数 
		 * @param name 建筑的名称
		 * @param maxW 最大的宽度
		 * @param maxH 最大的高度
		 */		
		public function BuildingThumb( name:String ,  maxW:int , maxH:int )
		{
			super();
			var resVO:ResVO = ResourceUtil.instance.getResVOByResId(name);
			if(resVO.resObject is Vector.<BitmapAnimResVO>)
			{
				var barvo:Vector.<BitmapAnimResVO> = resVO.resObject as Vector.<BitmapAnimResVO> ;
				this.bitmapData = barvo[0].bmds[0] ;
				this.x=barvo[0].offsetX ;
				this.y=barvo[0].offsetY ;
			}
			else if( resVO.resObject is RoadResVO )
			{
				var roadResVO:RoadResVO = resVO.resObject as RoadResVO ;
				this.bitmapData = roadResVO.bmds[name];
				this.x=roadResVO.offsetXs[name];
				this.y=roadResVO.offsetYs[name];
			}
		}
	}
}
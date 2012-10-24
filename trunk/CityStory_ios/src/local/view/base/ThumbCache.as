package local.view.base
{
	import bing.res.ResVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import local.util.ResourceUtil;

	public class ThumbCache extends Thumb
	{
		private var _resId:String ;
		
		public function ThumbCache( resId:String ,  url:String , scale:Number = 1.0  )
		{
			super(url,scale);
			this._resId = resId ;
		}
		
		override protected function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , added);
			addEventListener(Event.REMOVED_FROM_STAGE , removed );
			
			//加载图片资源
			ResourceUtil.instance.addEventListener( _resId , loaded);
			ResourceUtil.instance.loadRes( new ResVO(_resId,_url));
		}
		
		private function loaded(e:Event):void
		{
			var resVO:ResVO = ResourceUtil.instance.getResVOByResId(_resId);
			if(resVO){
				show(resVO);
			}
		}
		
		private function show( resVO:ResVO ):void
		{
			this.bitmapData= resVO.resObject as BitmapData; 
			scaleX = scaleY  = _scale ;
			if(_isCenter){
				x=-(width>>1);
				y=-(height>>1);
			}
		}
		
		override protected function removed(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removed );
			ResourceUtil.instance.removeEventListener( _resId , loaded);
		}
	}
}
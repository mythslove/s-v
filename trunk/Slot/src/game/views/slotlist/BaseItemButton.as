package game.views.slotlist
{
	import bing.res.ResVO;
	import bing.utils.ContainerUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import game.utils.ResourceUtil;
	import game.views.loading.MiniPreloading;
	import game.vos.SlotItemVO;
	
	/**
	 * 大厅中老虎机关卡列表中的按钮基类 
	 * @author zhouzhanglin
	 */	
	public class BaseItemButton extends MovieClip
	{
		public var imgContainer:MovieClip;
		//--------------------------------------------
		
		protected var _slotItemVO:SlotItemVO ;
		public function get slotItemVO():SlotItemVO{
			return _slotItemVO 
		}
		protected var _resId:String ;
		private var _loading:MiniPreloading;
		
		public function BaseItemButton( slotItemVO:SlotItemVO )
		{
			super();
			this._slotItemVO = slotItemVO ;
			_resId =  "icon"+_slotItemVO.id ;
			
			stop();
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler);
		}
		
		protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler );
			
			_loading = new MiniPreloading();
			imgContainer.addChild(_loading);
			
			ResourceUtil.instance.addEventListener( _resId , iconLoadedHandler );
			ResourceUtil.instance.loadRes( new ResVO(_resId, _slotItemVO.iconUrl ));
		}
		
		protected function iconLoadedHandler(e:Event):void
		{
			ResourceUtil.instance.removeEventListener(_resId , iconLoadedHandler );
			var bmd:BitmapData = ResourceUtil.instance.getResVOByResId(_resId).resObject as BitmapData;
			if(bmd){
				ContainerUtil.removeChildren(imgContainer);
				imgContainer.addChild( new Bitmap( bmd ) );
			}
		}
		
		protected function removedFromStageHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler );
			ResourceUtil.instance.removeEventListener( _resId , iconLoadedHandler );
		}
	}
}
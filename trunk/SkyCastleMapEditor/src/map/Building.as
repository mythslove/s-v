package map
{
	import bing.iso.IsoObject;
	import bing.utils.InteractivePNG;
	
	import com.greensock.TweenMax;
	
	import comm.GameSetting;
	
	import flash.events.Event;
	
	import vos.BuildingVO;
	
	public class Building extends IsoObject
	{
		public var vo:BuildingVO ;
		public var itemLayer:InteractivePNG;
		
		public function Building(vo:BuildingVO)
		{
			super(GameSetting.GRID_SIZE, 1, 1);
			this.vo = vo ;
			addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			
			itemLayer = new InteractivePNG();
			addChild(itemLayer);
		}
		
		protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedFromStageHandler );
			
		}
		
		protected function removedFromStageHandler(e:Event):void
		{
			
		}
		
		/**设置是否显示被选择状态  */		
		public function selectedStatus( flag:Boolean ):void
		{
			if(flag ){
				TweenMax.to(itemLayer, 0, {dropShadowFilter:{color:0xffff00, alpha:1, blurX:2, blurY:2, strength:5}});
			}else{
				itemLayer.filters=null ;
			}
		}
	}
}
package game.views.slotlist
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import game.models.SlotItemModel;
	import game.utils.ResourceUtil;
	import game.views.BaseView;

	/**
	 * 大厅列表，只有列表
	 * @author zzhanglin
	 */	
	public class HallList extends BaseView
	{
		public var item0:BlackHallItem, item1:BlackHallItem, item2:BlackHallItem, item3:BlackHallItem, item4:BlackHallItem
		, item5:BlackHallItem, item6:BlackHallItem, item7:BlackHallItem;
		public var item8:GreenHallItem, item9:GreenHallItem, item10:GreenHallItem
		, item11:GreenHallItem, item12:GreenHallItem, item13:GreenHallItem, item14:GreenHallItem, item15:GreenHallItem;
		//------------------------------------------------------------------------------------------------
		
		public function HallList()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			for( var i:int=4;i<8;++i)
			{
				(this["item"+i] as MovieClip).gotoAndStop("locked");
			}
			for( i=10;i<16;++i)
			{
				(this["item"+i] as MovieClip).gotoAndStop("soon");
			}
			
			//添加图标
			var icon:Sprite ;
			for( i=0;i<16;++i)
			{
				icon = ResourceUtil.instance.getInstanceByClassName("skin_hallLogo",SlotItemModel.instance.slotItemVOs[i].icon ) as Sprite;
				((this["item"+i] as MovieClip).getChildAt(0) as MovieClip)["logo_con"].addChild(icon);
			}
		}
	}
}
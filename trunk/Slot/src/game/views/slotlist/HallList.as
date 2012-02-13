package game.views.slotlist
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import game.models.MeInfoModel;
	import game.models.SlotItemsModel;
	import game.models.vos.SlotItemVO;
	import game.models.vos.UserVO;
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
		public const LEN:int  = 16 ;
		
		public function HallList()
		{
			super();
		}
		
		override protected function addedToStage():void
		{
			var icon:Sprite ;
			var me:UserVO = MeInfoModel.instance.me ;
			var vo:SlotItemVO;
			for( var i:int=0;i<LEN;++i)
			{
				vo = SlotItemsModel.instance.slotItemVOs[i] ;
				(this["item"+i] as MovieClip).gotoAndStop("normal");
				if(vo.enabled)
				{
					if(me.level<vo.minLevel)
					{
						(this["item"+i] as MovieClip).gotoAndStop("locked");
						//添加文字
						var txt:TextField = ((this["item"+i] as MovieClip).getChildAt(0) as MovieClip)["level_dock"].txtLevel as TextField ;
						txt.text=txt.text.replace("[num]",vo.minLevel);
					}
				}
				else
				{
					(this["item"+i] as MovieClip).gotoAndStop("soon");
				}
				//添加图标
				icon = ResourceUtil.instance.getInstanceByClassName("skin_hallLogo",SlotItemsModel.instance.slotItemVOs[i].icon ) as Sprite;
				((this["item"+i] as MovieClip).getChildAt(0) as MovieClip)["logo_con"].addChild(icon);
			}
		}
	}
}
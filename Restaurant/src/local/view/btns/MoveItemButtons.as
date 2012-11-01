package local.view.btns
{
	import com.greensock.TweenLite;
	
	import local.comm.GameData;
	import local.enum.ItemType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseItem;
	import local.model.PlayerModel;
	import local.util.EmbedManager;
	import local.util.ItemFactory;
	import local.view.base.BaseView;
	import local.view.base.GameButton;
	import local.vo.BaseItemVO;
	import local.vo.PlayerVO;
	
	import starling.events.Event;
	
	public class MoveItemButtons extends BaseView
	{
		private static var _instance:MoveItemButtons;
		public static function get instance():MoveItemButtons{
			if(!_instance) _instance = new MoveItemButtons();
			return _instance ;
		}
		//===========================================
		
		public var cancelBtn:GameButton ;
		public var okBtn:GameButton ;
		
		public function MoveItemButtons()
		{
			super();
			cancelBtn = new GameButton(EmbedManager.getUIImage("Button1")  );
			cancelBtn.disabledSkin = EmbedManager.getUIImage("Button1Disabled") ;
			cancelBtn.defaultIcon = EmbedManager.getUIImage("WhiteCancel");
			cancelBtn.x = -100 ;
			cancelBtn.y = -100 ;
			
			okBtn = new GameButton(EmbedManager.getUIImage("Button1"));
			okBtn.disabledSkin = EmbedManager.getUIImage("Button1Disabled") ;
			okBtn.defaultIcon = EmbedManager.getUIImage("WhiteRight");
			okBtn.x = 100 ;
			okBtn.y = -100 ;
			addChild(okBtn);
			addChild(cancelBtn);
			
			cancelBtn.addEventListener(Event.TRIGGERED , onClickHandler) ;
			okBtn.addEventListener(Event.TRIGGERED , onClickHandler) ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			scaleX = scaleY = 0 ;
			var value:Number = 1/GameWorld.instance.scaleX ;
			TweenLite.to( this , 0.25 , { scaleX:value , scaleY:value } );
//			if(GameData.isShowTutor){
//				cancelBtn.enabled = false ;
//			}else{
//				cancelBtn.enabled = true ;
//			}
		}
		
		private function onClickHandler( e:Event ):void
		{
			var building:BaseItem = GameWorld.instance.topScene.getChildAt(0) as BaseItem ;
			switch( e.target )
			{
				case okBtn:
					if( GameData.villageMode==VillageMode.ITEM_STORAGE)
					{
						building.storageToWorld();
						GameData.villageMode = VillageMode.EDIT ;
					}
					else if( GameData.villageMode==VillageMode.ITEM_SHOP)
					{
						building.shopToWorld();
						var baseVO:BaseItemVO = building.itemVO.baseVO ;
						if( baseVO.type==ItemType.FLOOR || baseVO.type==ItemType.WALL_PAPER )
						{
							var me:PlayerVO = PlayerModel.instance.me ;
							if( me.cash>= baseVO.costCash && me.coin>= baseVO.costCoin ){
								building = ItemFactory.createItemByBaseVO( baseVO );
								GameWorld.instance.addItemToTopScene( building );
								return ;
							}else if( (baseVO.costCash>0 && me.cash<baseVO.costCash)||(baseVO.costCoin>0 && me.coin<baseVO.costCoin) ){
								GameData.villageMode = VillageMode.NORMAL ;
							}
						}
						else
						{
							GameData.villageMode = VillageMode.NORMAL ;
						}
					}
					break ;
				case cancelBtn:
					if( GameData.villageMode==VillageMode.ITEM_STORAGE){
						GameData.villageMode = VillageMode.EDIT ;
					}else if( GameData.villageMode==VillageMode.ITEM_SHOP){
						GameData.villageMode = VillageMode.NORMAL ;
					}
					break ;
			}
			if(parent) parent.removeChild(this);
		}
		
		/**
		 * 防止被清除 
		 */		
		override public function dispose():void{}
	}
}
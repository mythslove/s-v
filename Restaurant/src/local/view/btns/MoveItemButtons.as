package local.view.btns
{
	import com.greensock.TweenLite;
	
	import feathers.display.Scale3Image;
	
	import local.comm.GameData;
	import local.enum.ItemType;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseItem;
	import local.model.PlayerModel;
	import local.util.EmbedManager;
	import local.util.ItemFactory;
	import local.util.StyleSetting;
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
			var img:Scale3Image = new Scale3Image(StyleSetting.instance.button1Texture);
			img.width = 70 ;
			cancelBtn = new GameButton(img );
			img = new Scale3Image(StyleSetting.instance.button1DisabledTexture);
			img.width = 70 ;
			cancelBtn.disabledSkin = img ;
			cancelBtn.defaultIcon = EmbedManager.getUIImage("WhiteCancel");
			cancelBtn.x = -100 ;
			cancelBtn.y = -100 ;
			
			img = new Scale3Image(StyleSetting.instance.button1Texture);
			img.width = 70 ;
			okBtn =new GameButton(img );
			img = new Scale3Image(StyleSetting.instance.button1DisabledTexture);
			img.width = 70 ;
			okBtn.disabledSkin = img ;
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
		}
		
		private function onClickHandler( e:Event ):void
		{
			var item:BaseItem = GameWorld.instance.topScene.getChildAt(0) as BaseItem ;
			switch( e.target )
			{
				case okBtn:
					if( GameData.villageMode==VillageMode.ITEM_STORAGE)
					{
						item.storageToWorld();
						GameData.villageMode = VillageMode.EDIT ;
					}
					else if( GameData.villageMode==VillageMode.ITEM_SHOP)
					{
						item.shopToWorld();
						var baseVO:BaseItemVO = item.itemVO.baseVO ;
						if( baseVO.isWallLayer() )
						{
							var me:PlayerVO = PlayerModel.instance.me ;
							if( me.cash>= baseVO.costCash && me.coin>= baseVO.costCoin ){
								item = ItemFactory.createItemByBaseVO( baseVO );
								GameWorld.instance.addItemToTopScene( item );
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
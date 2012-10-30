package local.view.shop
{
	import bing.utils.FixScale;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseItem;
	import local.util.EmbedManager;
	import local.util.GameUtil;
	import local.util.ItemFactory;
	import local.util.StyleSetting;
	import local.view.base.BuildingThumb;
	import local.vo.BaseItemVO;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ShopItemRender extends FeathersControl implements IListItemRenderer
	{
		private var _data:Object ;
		public function get data():Object{ return _data ; }
		public function set data(value:Object):void{
			_data = value;
			baseVO = value as BaseItemVO;
			show();
		}
		private var _index:int ;
		public function get index():int{ return _index ; };
		public function set index(value:int):void{ _index = value ;}
		private var _owner:List ;
		public function get owner():List{ return _owner ;}
		public function set owner(value:List):void{ _owner = value ;}
		private var _isSelected:Boolean 
		public function get isSelected():Boolean{ return _isSelected ;}
		public function set isSelected(value:Boolean):void{ _isSelected = value ;}
		
		
		public var baseVO:BaseItemVO ;
		private var _wid:int = 180 ;
		private var _het:int = 180 ;
		private var _isMove:Boolean;
		
		public function ShopItemRender()
		{
			super();
			this.width = _wid ;
			this.height = _het ;
			addEventListener(TouchEvent.TOUCH , onTouchHandler );
		}
		
		private function show():void
		{
			this.removeChildren(0,-1,true);
			
			var bg:Scale9Image = new Scale9Image( StyleSetting.instance.ShopItemRenderBgTexture );
			bg.width = _wid;
			bg.height = _het;
			addChild(bg);
			
			//图片
			var thumbName:String = baseVO.directions==2? baseVO.name: baseVO.name+"_1"
			var img:BuildingThumb = new BuildingThumb(  thumbName , baseVO.isWallLayer() , 150 , 150 );
			img.touchable = false ;
			img.x=_wid>>1;
			img.y = _het>>1 ;
			addChild( img );
			img.center();
			
			//价格
			var icon:Image = baseVO.costCoin>0 ? EmbedManager.getUIImage("CoinIcon"):EmbedManager.getUIImage("CashIcon");
			icon.touchable = false ;
			FixScale.setScale( icon , 60 , 40);
			icon.x = 30 ;
			icon.y = 20;
			addChild( icon );
			var price:int = baseVO.costCoin>0 ? baseVO.costCoin : baseVO.costCash ;
			var txtPrice:TextField =new TextField( _wid-icon.x-icon.width , 40 , price+"" , "Verdana" , 30 , 0xffffff ,true ) ;
			txtPrice.touchable = false;
			txtPrice.hAlign = HAlign.LEFT ;
			txtPrice.vAlign = VAlign.CENTER ;
			txtPrice.x = icon.x + icon.width+5 ;
			txtPrice.y = icon.y  ;
			addChild(txtPrice);
		}
		
		private function onTouchHandler( e:TouchEvent ):void
		{
			if(e.touches.length>0){
				var touch:Touch = e.touches[0] ;
				if(touch.phase==TouchPhase.BEGAN){
					GameUtil.dark( this );
					_isMove = false ;
				}else{
					GameUtil.light( this );
				}
				if(touch.phase==TouchPhase.MOVED){
					_isMove = true ;
				}else if(touch.phase==TouchPhase.ENDED){
					if(!_isMove){
						var item:BaseItem = ItemFactory.createItemByBaseVO( baseVO );
						GameWorld.instance.addItemToTopScene( item);
						GameData.villageMode=VillageMode.ITEM_SHOP ;
						ShopBar.instance.removeFromParent();
					}
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_data = null ;
			_owner = null ;
			baseVO = null ;
		}
	}
}
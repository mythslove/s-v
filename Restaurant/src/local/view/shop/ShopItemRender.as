package local.view.shop
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import local.util.EmbedManager;
	import local.util.GameUtil;
	import local.util.StyleSetting;
	import local.view.base.BuildingThumb;
	import local.vo.BaseItemVO;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
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
			icon.scaleX = icon.scaleY = 0.4 ;
			icon.x= 20 ;
			icon.y = 20;
			addChild( icon );
			var price:int = baseVO.costCoin>0 ? baseVO.costCoin : baseVO.costCash ;
			var txtPrice:TextField =new TextField(_wid,50,price+"","verdana",25,0xffffff ,true) ;
			txtPrice.touchable = false;
			txtPrice.hAlign = HAlign.CENTER ;
			txtPrice.autoScale = true ;
			txtPrice.y = icon.y ;
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
//						var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO( baseVO );
//						GameWorld.instance.addBuildingToTopScene( building);
//						GameData.villageMode=VillageMode.BUILDING_SHOP ;
//						PopUpManager.instance.removeCurrentPopup();
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
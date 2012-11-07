package local.view.storage
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseItem;
	import local.model.ShopModel;
	import local.util.GameUtil;
	import local.util.ItemFactory;
	import local.util.StyleSetting;
	import local.view.base.BuildingThumb;
	import local.vo.BaseItemVO;
	import local.vo.StorageItemVO;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class StorageItemRender extends FeathersControl implements IListItemRenderer
	{
		private var _data:Object ;
		public function get data():Object{ return _data ; }
		public function set data(value:Object):void{
			_data = value;
			itemVO = value as StorageItemVO;
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
		
		
		public var itemVO:StorageItemVO ;
		private var _wid:int = 160 ;
		private var _het:int = 160 ;
		private var _isMove:Boolean;
		
		public function StorageItemRender()
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
			var baseVO:BaseItemVO = ShopModel.instance.allItemsHash[itemVO.name] as BaseItemVO ;
			var thumbName:String = baseVO.directions==2? baseVO.name: baseVO.name+"_1" ;
			var img:BuildingThumb = new BuildingThumb(  thumbName , baseVO.isWallLayer() , _wid-10 , _het-10 );
			img.touchable = false ;
			img.x=_wid>>1;
			img.y = _het>>1 ;
			addChild( img );
			img.center();
			
			var txtCount:TextField =new TextField( _wid , 40 , itemVO.num+"" , "Verdana" , 30 , 0xffffff ,true ) ;
			txtCount.touchable = false;
			txtCount.hAlign = HAlign.CENTER ;
			txtCount.vAlign = VAlign.CENTER ;
			txtCount.y = _het-50 ;
			addChild(txtCount);
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
						var item:BaseItem = ItemFactory.createItemByBaseVO( ShopModel.instance.allItemsHash[itemVO.name] as BaseItemVO );
						GameData.villageMode=VillageMode.ITEM_STORAGE ;
						GameWorld.instance.addItemToTopScene( item);
						StorageBar.instance.removeFromParent();
					}
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_data = null ;
			_owner = null ;
			itemVO = null ;
		}
	}
}
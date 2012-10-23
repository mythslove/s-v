package local.view.storage
{
	import bing.utils.FixScale;
	
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.CompsModel;
	import local.model.ShopModel;
	import local.util.BuildingFactory;
	import local.util.EmbedManager;
	import local.util.GameUtil;
	import local.view.base.BuildingThumb;
	import local.vo.BaseBuildingVO;
	import local.vo.ComponentVO;
	import local.vo.StorageBuildingVO;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class StorageItemRenderer extends FeathersControl implements IListItemRenderer
	{
		public var txtTitle:TextField ; //标题
		public var imgContainer:Sprite; //图片
		public var txtCount:TextField ;//数量
		//============================
		
		private var isBuilding:Boolean = true ;
		
		//如果是建筑时，则是StorageBuildingVO ,如果是String ，则为Component的名称
		private var _data:Object ;
		public function get data():Object{ return _data ; }
		public function set data(value:Object):void{
			_data = value;
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
		
		protected var _onChange:Signal = new Signal(StorageItemRenderer);
		public function get onChange():ISignal{ return _onChange; }
		
		
		public var baseVO:BaseBuildingVO ;
		private var _wid:int = 176*GameSetting.GAMESCALE ;
		private var _het:int = 212*GameSetting.GAMESCALE ;
		private var _isMove:Boolean;
		
		
		public function StorageItemRenderer()
		{
			super();
			init();
			addEventListener(TouchEvent.TOUCH , onTouchHandler );
		}
		
		private function init():void
		{
			var bg:Image = EmbedManager.getUIImage("StorageItemRenderBg");
			addChild(bg);
			width = bg.width ;
			height = bg.height ;
			
			txtTitle =new TextField(bg.width,50*GameSetting.GAMESCALE,"","Verdana",18*GameSetting.GAMESCALE,0,true) ;
			txtTitle.touchable = false;
			txtTitle.hAlign = HAlign.CENTER ;
			txtTitle.autoScale = true ;
			txtTitle.y = 2*GameSetting.GAMESCALE ;
			addChild(txtTitle);
			
			txtCount =new TextField(bg.width,50*GameSetting.GAMESCALE,"","Verdana",20*GameSetting.GAMESCALE,0,true) ;
			txtCount.touchable = false;
			txtCount.hAlign = HAlign.CENTER ;
			txtCount.autoScale = true ;
			txtCount.y = bg.height-50*GameSetting.GAMESCALE ;
			addChild(txtCount);
			
			imgContainer = new Sprite();
			imgContainer.x = bg.width>>1 ;
			imgContainer.y = bg.height>>1 ;
			imgContainer.touchable = false ;
			addChild(imgContainer);
		}
		
		private function show():void
		{
			if(data is String){
				isBuilding = false ;
				var compVO:ComponentVO = CompsModel.instance.allComps[ data.toString() ];
				txtTitle.text= compVO.title;
				txtCount.text = CompsModel.instance.getCompCount(data.toString())+"/"+CompsModel.MAX_COUNT ;
				var bmp:Image = EmbedManager.getUIImage( data.toString());
				FixScale.setScale(bmp, 120*GameSetting.GAMESCALE , 90*GameSetting.GAMESCALE);
				imgContainer.addChild( bmp );
				bmp.x = -bmp.width>>1 ;
				bmp.y = -bmp.height>>1 ;
				bmp.touchable = false ;
			}else{
				isBuilding = true ;
				var sbvo:StorageBuildingVO = data as StorageBuildingVO ;
				var bvo:BaseBuildingVO =  ShopModel.instance.allBuildingHash[sbvo.name] as BaseBuildingVO ;
				txtTitle.text =  bvo.title ;
				txtCount.text ="×"+sbvo.num ;
				//图片
				var img:BuildingThumb = new BuildingThumb( sbvo.name , 120*GameSetting.GAMESCALE , 90*GameSetting.GAMESCALE );
				imgContainer.addChild( img );
				img.center();
			}
			txtTitle.y += (50*GameSetting.GAMESCALE-txtTitle.height)>>1 ;
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
						var stvo:StorageBuildingVO = data as StorageBuildingVO ;
						var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO(  ShopModel.instance.allBuildingHash[stvo.name] as BaseBuildingVO );
						GameWorld.instance.addBuildingToTopScene( building);
						GameData.villageMode=VillageMode.BUILDING_STORAGE ;
						
						StorageBar.instance.removeFromParent(false);
					}
				}
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			_onChange.removeAll();
			_onChange = null ;
			_data = null ;
			_owner = null ;
		}
	}
}
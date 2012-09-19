package local.view.storage
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import local.model.ShopModel;
	import local.util.GameUtil;
	import local.view.base.BuildingThumb;
	import local.vo.BaseBuildingVO;
	import local.vo.StorageBuildingVO;
	
	public class StorageItemRenderer extends Sprite
	{
		public var txtTitle:TextField ; //标题
		public var imgContainer:Sprite; //图片
		public var txtCount:TextField ;//数量
		//============================
		
		private var _isBuilding:Boolean = true ;
		public var vo:Object ; //如果是建筑时，则是StorageBuildingVO ,如果是String ，则为Component的名称
		
		public function StorageItemRenderer( vo:Object )
		{
			super();
			mouseChildren = false ;
			this.vo = vo ;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		protected function addedHandler(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , addedHandler ) ;
			
			if(vo is String){
				_isBuilding = false ;
				GameUtil.boldTextField( txtTitle , vo.toString() );
			}else{
				var sbvo:StorageBuildingVO = vo as StorageBuildingVO ;
				var bvo:BaseBuildingVO =  ShopModel.instance.allBuildingHash[sbvo.name] as BaseBuildingVO ;
				GameUtil.boldTextField( txtTitle , bvo.title );
				GameUtil.boldTextField( txtCount , "×"+sbvo.num );
				//图片
				var img:BuildingThumb = new BuildingThumb( sbvo.name , 120 , 90 );
				imgContainer.addChild( img );
				img.center();
			}
		}
		
	}
}
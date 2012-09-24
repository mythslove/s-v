package local.view.storage
{
	import bing.utils.ContainerUtil;
	import bing.utils.FixScale;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import local.model.CompsModel;
	import local.model.ShopModel;
	import local.util.EmbedsManager;
	import local.util.GameUtil;
	import local.view.base.BaseView;
	import local.view.base.BuildingThumb;
	import local.vo.BaseBuildingVO;
	import local.vo.ComponentVO;
	import local.vo.StorageBuildingVO;
	
	public class StorageItemRenderer extends BaseView
	{
		public var txtTitle:TextField ; //标题
		public var imgContainer:Sprite; //图片
		public var txtCount:TextField ;//数量
		//============================
		
		private var isBuilding:Boolean = true ;
		public var vo:Object ; //如果是建筑时，则是StorageBuildingVO ,如果是String ，则为Component的名称
		
		public function StorageItemRenderer()
		{
			super();
			mouseChildren = false ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			if(vo is String){
				isBuilding = false ;
				var compVO:ComponentVO = CompsModel.instance.allComps[ vo.toString() ];
				GameUtil.boldTextField( txtTitle , compVO.title );
				GameUtil.boldTextField( txtCount , "×"+CompsModel.instance.getCompCount(vo.toString()) );
				var bmp:Bitmap = new Bitmap( EmbedsManager.instance.getBitmapByName("Comp_"+vo.toString(),true).bitmapData ) ;
				FixScale.setScale(bmp, 120 , 90);
				imgContainer.addChild( bmp );
				bmp.x = -bmp.width>>1 ;
				bmp.y = -bmp.height>>1 ;
				
			}else{
				isBuilding = true ;
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
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
			txtTitle.text = txtCount.text="";
			ContainerUtil.removeChildren( imgContainer );
			vo = null ;
		}
	}
}
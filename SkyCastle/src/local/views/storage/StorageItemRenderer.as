package local.views.storage
{
	import bing.components.BingComponent;
	import bing.components.button.BaseButton;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.model.PickupModel;
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.vos.PickupVO;
	import local.model.vos.StorageItemVO;
	import local.utils.GameUtil;
	import local.views.base.Image;

	/**
	 *  收藏箱的项
	 * @author zzhanglin
	 */	
	public class StorageItemRenderer extends BingComponent
	{
		public var txtName:TextField ;
		public var txtCount:TextField ;
		public var txtBtn:TextField ;
		public var btnNormal:BaseButton;
		public var container:Sprite ;
		public var btnBg:InteractiveObject ;
		//==================================
		private const LABEL_DEFAULT:String = "defalut";
		private const LABEL_MATERIAL:String = "material";
		private var _storageItemVO:StorageItemVO ;
		
		public function StorageItemRenderer()
		{
			super();
			stop();
			container.mouseChildren=container.mouseEnabled=false; 
			txtBtn.mouseEnabled = txtName.mouseEnabled = txtName.mouseEnabled=false ; 
			GameUtil.disableTextField(this);
		}
		
		/**
		 * 显示收藏中的建筑 
		 * @param vo
		 */		
		public function showBuilding( vo:StorageItemVO ):void
		{
			this._storageItemVO = vo ;
			var baseVO:BaseBuildingVO = BaseBuildingVOModel.instance.getBaseVOById(vo.baseId);
			txtName.text = baseVO.name ;
			var img:Image = new Image(baseVO.thumbAlias,baseVO.thumb);
			container.addChild(img);
			btnNormal.addEventListener(MouseEvent.CLICK , onNormalHandler );
		}
		
		private function onNormalHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			
		}
		
		/**
		 * 显示Marterial项 
		 * @param pid PickupVO的id
		 */		
		public function showMaterial( pid:String ):void
		{
			this.gotoAndStop("material");
			var pkvo:PickupVO = PickupModel.instance.getPickupById(pid);
			var img:Image = new Image(pkvo.thumbAlias,pkvo.url);
			container.addChild(img);
			txtName.text = pkvo.name ;
			txtCount.text = PickupModel.instance.getMyPickupCount( pid )+"/50";
		}
		
		override protected function removedFromStage():void
		{
			_storageItemVO = null ;
			if(btnNormal && btnNormal.hasEventListener(MouseEvent.CLICK))
				btnNormal.removeEventListener(MouseEvent.CLICK , onNormalHandler );
		}
	}
}
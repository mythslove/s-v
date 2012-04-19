package local.views.storage
{
	import bing.components.BingComponent;
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.model.PickupModel;
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
		//==================================
		private const LABEL_DEFAULT:String = "defalut";
		private const LABEL_MATERIAL:String = "material";
		
		public function StorageItemRenderer()
		{
			super();
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
	}
}
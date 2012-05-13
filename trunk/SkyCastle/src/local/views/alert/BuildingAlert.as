package local.views.alert
{
	import flash.display.Sprite;
	
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.utils.PopUpManager;
	import local.views.base.Image;
	
	/**
	 * 建筑一些操作时弹出的确认窗口 
	 * @author zzhanglin
	 */	
	public class BuildingAlert extends SimpleAlert
	{
		public var container:Sprite ;
		//============================
		private var _baseId:String ;
		
		public function BuildingAlert(baseId:String , info:String ,  yesFun:Function = null , noFun:Function = null )
		{
			super(info ,  yesFun , noFun );
			_baseId = baseId ;
		}
		
		override protected function added():void
		{
			super.added();
			var baseVO:BaseBuildingVO = BaseBuildingVOModel.instance.getBaseVOById(_baseId);
			var img:Image = new Image(baseVO.thumbAlias , baseVO.thumb );
			container.addChild( img );
		}
		
		public static function show(baseId:String ,  info:String ,  yesFun:Function = null , noFun:Function = null  ):void
		{
			var alert:BuildingAlert = new BuildingAlert( baseId ,info ,  yesFun, noFun);
			PopUpManager.instance.addPopUp( alert , true , true , 0.4 );
		}
	}
}
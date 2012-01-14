package views.tooltip
{
	
	/**
	 * 建筑的tooltip 
	 * @author zzhanglin
	 */
	public class BuildingToolTip extends GameToolTip
	{
		private static var _instance:BuildingToolTip ;
		
		public function BuildingToolTip()
		{
			super();
			if(_instance) throw new Error("只能实例化一个BuildingTooltip");
			else _instance = this ;
		}
		public static function get instance():BuildingToolTip{
			if(!_instance) _instance = new BuildingToolTip();
			return _instance ;
		}
		
		/**
		 * 显示tooltip 
		 * @param info
		 * @param title
		 */		
		public function showTooltip( info:String , title:String=""):void
		{
			this.visible=true;
			txtInfo.text=info ;
			txtTitle.text=title;
			update();
		}
		
		/**
		 * 隐藏Tooltip 
		 */		
		public function hideTooltip():void
		{
			this.visible=false;
		}
		
		/**
		 * 更新位置 
		 * @param stageX
		 * @param stageY
		 * @param stage
		 * 
		 */		
		public function updatePosition( stageX:int , stageY:int):void
		{
			if(stage){
				super.move( stageX,stageY);
			}
		}
	}
}
package local.game.elements
{
	import flash.events.Event;
	
	import local.enum.AvatarAction;
	import local.model.buildings.vos.BaseRoadVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;

	/**
	 * 路，草坪，水渠 
	 * @author zzhanglin
	 */	
	public class Road extends Decortation
	{
		/**
		 * 当前的方向 
		 */		
		private var _currentLabel:String="NONE";
		
		public function Road(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseRoadVO():BaseRoadVO{
			return buildingVO.baseVO as BaseRoadVO ;
		}
		
		/** 获取此建筑的描述 */
		override public function get description():String 
		{
			return "";
		}
		
		/* 重写资源加载完成   */
		override protected function resLoadedHandler( e:Event):void
		{
			super.resLoadedHandler(e);
			_skin.gotoAndStop(_currentLabel);
		}
		
		/**
		 * 更新UI的方向 
		 * @param position
		 */		
		public function updateUI( position:String):void
		{
			_currentLabel = position;
			if(_skin){
				_skin.gotoAndStop(_currentLabel);
			}else{
				super.loadRes();
			}
		}
		
		override public function onClick():void
		{
			if(!CollectQueueUtil.instance.currentBuilding){
				characterMoveTo(CharacterManager.instance.hero);
			}
		}
	}
}
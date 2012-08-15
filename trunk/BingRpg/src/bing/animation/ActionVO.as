package bing.animation
{
	/**
	 * 动作模型类 
	 * @author 周张林
	 * @date 2010/8/21
	 */	
	public class ActionVO
	{
		private var _actionName:String = ""; //动作的名称
		private var _frameNum:int = 0; //动作的帧数
		/**
		 * 构造函数：动作模型 
		 * @param actionName 动作的名称
		 * @param frameNum 此动作的帧数 
		 */		
		public function ActionVO( actionName:String , frameNum:int )
		{
			this._actionName = actionName; 
			this._frameNum = frameNum ;
		}
		
		
		public function get frameNum():int
		{
			return _frameNum;
		}

		public function set frameNum(value:int):void
		{
			_frameNum = value;
		}

		public function get actionName():String
		{
			return _actionName;
		}

		public function set actionName(value:String):void
		{
			_actionName = value;
		}

	}
}
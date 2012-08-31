package bing.animation
{
	/**
	 * 动作模型类 
	 * @author 周张林
	 * @date 2010/8/21
	 */	
	public class ActionVO
	{
		public var actionName:String = ""; //动作的名称
		public var frameNum:int = 0; //动作的帧数
		public var startFrame:int ; //开始帧 
		public var endFrame:int ; //结束帧
		/**
		 * 构造函数：动作模型 
		 * @param actionName 动作的名称
		 * @param frameNum 此动作的帧数 
		 * @param startFrame 开始帧 
		 * @param endFrame 结束帧
		 */		
		public function ActionVO( actionName:String , frameNum:int , startFrame:int=0 , endFrame:int=0 )
		{
			this.actionName = actionName; 
			this.frameNum = frameNum ;
			this.startFrame = startFrame; 
			this.endFrame = endFrame ;
		}

	}
}
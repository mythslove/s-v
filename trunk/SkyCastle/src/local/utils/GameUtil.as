package local.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	import local.enum.QuestType;
	import local.model.QuestModel;

	/**
	 * 游戏中用到的一些工具 类 
	 * @author zzhanglin
	 */
	public class GameUtil
	{
		/**
		 * 禁用所有的文本鼠标事件 
		 * @param container
		 */		
		public static function disableTextField( container:DisplayObjectContainer ):void
		{
			var len:int = container.numChildren ;
			for( var i:int = 0 ; i<len;++i){
				if(container.getChildAt(i) is TextField){
					(container.getChildAt(i) as TextField).mouseEnabled=false; 
				}
			}
		}
		
		/**
		 * cash转coin 
		 * @param cash
		 * @return 
		 * 
		 */		
		public static function cashToCoin( cash:int ):int
		{
			return cash*100 ;
		}
		
		/**
		 * 分享 
		 * @param title
		 * @param info
		 * @param icon
		 */		
		public static function share( title:String , info:String , icon:String ):void
		{
			
			QuestModel.instance.updateQuests( QuestType.SHARE);
		}
	}
}
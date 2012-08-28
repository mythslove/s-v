package bing.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 显示对象工具类 
	 * @author zhouzhanglin
	 * @date 2010/10/10
	 */	
	public class ContainerUtil
	{
		/**
		 * 清空容器中的对象 
		 * @param displayObjectContainer 
		 */		
		public static function removeChildren( displayObjectContainer:DisplayObjectContainer ):void {
			while( displayObjectContainer.numChildren>0 ){
				displayObjectContainer.removeChildAt( 0 );
			}
		}
	
		/**
		 * 通过名称来找对象 
		 * @param xPath 例如 mc.son.test_mc
		 * @param container 例如container，其中container包含了mc
		 * @return 
		 */		
		public static function getChildByNames( xPath:String , container:DisplayObjectContainer ):DisplayObject
		{
			var arr:Array = xPath.split(".");
			var name:String = "";
			while (arr.length>0 )
			{
				name = arr.shift();
				if(container.getChildByName(name))
				{
					if (arr.length == 0)
					{
						return container.getChildByName(name);
					}
					if (container.getChildByName(name) is DisplayObjectContainer)
					{
						container = container.getChildByName(name) as DisplayObjectContainer;
					}
				}
			}
			return null;
		}
		
		
		private static var arr:Vector.<DisplayObject> = null ;
		
		/**
		 * 通过名称来获取对象 
		 * @param name
		 * @param container
		 * @param precise 是否精确查找，默认为是
		 * @return 
		 */		
		public static function getChildsByName( name:String , container:DisplayObjectContainer , precise:Boolean = true ):Vector.<DisplayObject> 
		{
			arr = new Vector.<DisplayObject>();
			queryChildren(name,container,precise);
			return arr ;
		}
		
		private static function queryChildren( name:String , container:DisplayObjectContainer, precise:Boolean = true):void 
		{
			const LEN:int = container.numChildren ;
			var obj:DisplayObject ;
			for( var i:int = 0 ; i<LEN ; i++ )
			{
				obj = container.getChildAt(i) ;
				if(precise && obj.name==name )
				{
					arr.push( obj );
				}
				else if(obj.name.indexOf(name)>-1)
				{
					arr.push( obj );
				}
				if(obj is DisplayObjectContainer)
				{
					queryChildren( name , obj as DisplayObjectContainer,precise);
				}
			}
		}
		
	}
}
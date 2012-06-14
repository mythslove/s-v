package bing.utils
{
	import flash.utils.describeType;

	/**
	 * 通过xml文件来反射对象
	 * reflect object by XML 
	 * @author zhouzhanglin
	 * 
	 */	
	public class XMLAnalysis
	{

		public static function createInstanceByXML( xmlNode:XML , clsName:Class , arraySeparator:String=null ):Object
		{
			var obj:Object = new clsName();
			var describeType:XML = flash.utils.describeType(obj) as XML ;
			for each(var prop:* in xmlNode.attributes())
			{
				var propName:String = String(prop.name());

				var type:String = describeType.variable.(@name==propName).@type;
				switch( type )
				{
					case "int":
						obj[ propName ] = int( prop );
						break;
					case "Array" :
						if ( arraySeparator!=null && arraySeparator!="" )
						{
							obj[ propName ] = String( prop ).split(arraySeparator);
						}
						break;
					case "String":
						obj[ propName ] = String( prop );
						break;
					case "Boolean":
						obj[ propName ] = int( prop )>0 ? true : false ;
						break ;
					case "Number":
						obj[ propName ] = Number( prop );
						break ;
				}
			}
			return obj;
		}
		

		public static function createInstanceArrayByXMLList( xmlList:XMLList , clsName:Class, arraySeparator:String=null ):Array
		{
			var arr:Array = new Array() ;
			var len:int = xmlList.length() ;
			for (var i:int = 0 ; i<len ; i++ )
			{
				var xmlNode:XML =  xmlList[i] as XML ;
				arr.push( createInstanceByXML(xmlNode ,clsName , arraySeparator) );
			}
			return arr ;
		}
		
		
		public static function createInstanceArrayByXML( xml:XML , clsName:Class , arraySeparator:String=null):Array
		{
			return createInstanceArrayByXMLList( xml.children() , clsName, arraySeparator);
		}
	}
}
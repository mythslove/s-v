package bing.res
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ResURLLoader extends URLLoader
	{
		public var name:String ;
		public function ResURLLoader(request:URLRequest=null)
		{
			super(request);
		}
	}
}
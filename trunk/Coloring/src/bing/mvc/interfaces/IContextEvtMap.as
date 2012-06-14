package bing.mvc.interfaces
{
	import flash.events.Event;

	public interface IContextEvtMap
	{
		function addContextListener( type:String , callFun:Function ):void ;
		function removeContextListener(type:String , callFun:Function):void ;
		function dispatchContextEvent( event:Event):void ;
	}
}
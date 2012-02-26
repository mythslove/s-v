package bing.mvc.interfaces
{
	public interface IMediator extends IContextEvtMap
	{
		function preRegister():void ;
		function onRegister():void ;
		function dispose():void ;
	}
}
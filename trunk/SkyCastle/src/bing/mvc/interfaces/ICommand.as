package bing.mvc.interfaces
{
	public interface ICommand extends IContextEvtMap
	{
		function execute():void ;
		function dispose():void ;
	}
}
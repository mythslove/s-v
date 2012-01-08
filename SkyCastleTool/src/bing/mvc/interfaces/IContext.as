package bing.mvc.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IContext extends IEventDispatcher
	{
		function preStart():void ;
		function startUp():void ;
		function registerMeditor( mediator:IMediator):void;
		function retrieveMediator(className:Class):IMediator;
		function hasMediatorByName( className:Class ):Boolean;
		function hasMediator( mediator:IMediator ):Boolean;
		function removeMediatorByName(className:Class ):void ;
		function removeMediator(mediator:IMediator ):void ;
		
		function registerModel( model:IModel):void ;
		function retrieveModel(className:Class):IModel;
		function hasModelByName( className:Class ):Boolean;
		function hasModel( model:IModel):Boolean;
		function removeModelByName(className:Class ):void ;
		function removeModel(model:IModel ):void ;
		
		function getName(obj:*):String;
	}
}
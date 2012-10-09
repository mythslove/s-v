package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	[SWF(width="800",height="600",frameRate="60")]
	public class ScrollTest extends Sprite
	{
		private var scroller:HPageScroller ;
		private var content:Sprite ;
		
		public function ScrollTest()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			var container:Sprite = new Sprite();
			container.graphics.beginFill(0xffcc00);
			container.graphics.drawRect(0,0,700,400 );
			container.graphics.endFill() ;
			container.x = container.y = 20 ;
			addChild(container);
			
			content = new Sprite();
			content.addEventListener(MouseEvent.CLICK , onClickHandler );
			container.addChild( content );
			
			scroller = new HPageScroller();
			scroller.addScrollControll( container,content,3);
			for( var i:int = 0  ; i<14 ; ++i){
				scroller.addItem( createItem(i) );
			}
			scroller.addEventListener("ScrollOver",onScrollOver);
		}
		
		private function onScrollOver( e:Event):void
		{
			trace(scroller.currentPage , scroller.totalPage );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
//			scroller.scrollToPage(6,true);
			scroller.scrollToItem( content.getChildAt(7) , true );
		}
		
		private function createItem( index:int ):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.name = "aaa" ;
			sprite.mouseChildren = false ;
			sprite.graphics.beginFill(0xff0000);
			sprite.graphics.drawRect(0,0,200,380 );
			sprite.graphics.endFill() ;
			
			var tf:TextField = new TextField();
			tf.width=100;
			tf.text = index+"" ;
			sprite.addChild(tf);
			
			return sprite;
		}
	}
}
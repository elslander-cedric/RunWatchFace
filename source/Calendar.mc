import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Complications;
import Toybox.Lang;

class Calendar extends WatchUi.Drawable {
    const x1=95, y1=60, w1=20, h1=4, h2=10;

    function initialize(params as Dictionary) {
        Drawable.initialize(params);
    }
    
    function draw(dc as Dc) as Void {
        var calendarEventId = new Id(Complications.COMPLICATION_TYPE_CALENDAR_EVENTS);
        var calendarEventComplication = Complications.getComplication(calendarEventId);
        
        if(calendarEventComplication.value != null) {                     
            dc.setPenWidth(2);
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawRectangle(x1, y1, w1, h1);
            dc.drawRectangle(x1, y1+h1, w1, h2);
            dc.drawLine(x1 + (w1*1/3), y1 - 2, x1 + (w1*1/3), y1 + 6);
            dc.drawLine(x1 + (w1*2/3), y1 - 2, x1 + (w1*2/3), y1 + 6);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(150, 50, Graphics.FONT_SYSTEM_TINY, calendarEventComplication.value.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
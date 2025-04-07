import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Complications;
import Toybox.Lang;

class Notifications extends WatchUi.Drawable {
    const x=205, y=105, radius=15;

    function initialize(params as Dictionary) {
        Drawable.initialize(params);
    }
    
    function draw(dc as Dc) as Void {
        var notificationCountId = new Id(Complications.COMPLICATION_TYPE_NOTIFICATION_COUNT);
        var notificationCountComplication = Complications.getComplication(notificationCountId);
        
        if(notificationCountComplication.value != null && notificationCountComplication.value != 0) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(x, y, radius);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(x+1, y-1, Graphics.FONT_SYSTEM_TINY, notificationCountComplication.value.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
}
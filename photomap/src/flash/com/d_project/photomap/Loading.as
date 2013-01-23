package com.d_project.photomap {

    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * Loading
     * @author Kazuhiko Arase
     */
    public class Loading extends TextField {

        /**
         * 下記のパスにフォントが存在しない場合は、適宜修正が必要
         */
        [Embed(source="C:\\WINDOWS\\Fonts\\verdana.ttf", fontFamily="Verdana", unicodeRange="U+002E,U+004C,U+0061,U+0064,U+0067,U+0069,U+006E,U+006F")]
        private static var fontVerdana : Class;

        private var step : int;

        private var status : String;
        
        public function Loading() {
            
            step = 0;
            status = Status.STOP;
            
            defaultTextFormat = new TextFormat("Verdana", 14, 0x666666);
            embedFonts = true;
            text = "Loading...";

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        public function start() : void {
            alpha = 0;
            step = 0;
            status = Status.FADE_IN_DELAY;
        }
        
        public function stop() : void {
            status = Status.STOP;
        }
        
        private function onEnterFrame(e : Event) : void {

            switch(status) {

            case Status.STOP :
                step = 0;
                alpha = 0;
                break;

            case Status.FADE_IN_DELAY :
                step++;
                if (step >= 20) {
                    step = 0;
                    status = Status.FADE_IN;
                }
                break;

            case Status.FADE_IN :
                step++;
                if (step >= 10) {
                    step = 10;
                    status = Status.FADE_OUT;
                }
                alpha = step / 10;
                break;

            case Status.FADE_OUT :
                step--;
                if (step <= 0) {
                    step = 0;
                    status = Status.FADE_IN;
                }
                alpha = step / 10;
                break;
            }
        }        
    }
}

final class Status {

    public static const STOP : String = "stop";

    public static const FADE_IN_DELAY : String = "fadeInDelay";

    public static const FADE_IN : String = "fadeIn";

    public static const FADE_OUT : String  = "fadeOut";
}

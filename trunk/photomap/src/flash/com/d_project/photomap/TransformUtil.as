package com.d_project.photomap {

    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.display.Graphics;
    import flash.display.BitmapData;
    
    /**
     * TransformUtil
     * @author Kazuhiko Arase
     */
    public class TransformUtil {

        /**
         * 0 - 1
         * | /  
         * 2 
         */
        public static function drawBitmapTriangle(
            g : Graphics, bitmapData : BitmapData,
            a0 : Point, a1 : Point, a2 : Point, 
            b0 : Point, b1 : Point, b2 : Point
        ) : void {
            var matrix : Matrix = createMatrix(a0, a1, a2, b0, b1, b2);
            g.beginBitmapFill(bitmapData, matrix);
            drawTriangle(g, a0, a1, a2, matrix);
            g.endFill();
        }

        /**
         *
         * 0 - 1
         * |   |
         * 2 - 3
         */
        public static function drawBitmapQuadrangle(
            g : Graphics, bitmapData : BitmapData,
            a0 : Point, a1 : Point, a2 : Point, a3 : Point, 
            b0 : Point, b1 : Point, b2 : Point, b3 : Point,
            hDiv : Number = 4, vDiv : Number = 4
        ) : void {

            for (var h : int = 0; h < hDiv; h++) {

                var h0 : Number = h / hDiv;
                var h1 : Number = (h + 1) / hDiv;

                var ta0 : Point = getPoint(a1, a0, h0);
                var ta1 : Point = getPoint(a1, a0, h1);
                var ta2 : Point = getPoint(a3, a2, h0);
                var ta3 : Point = getPoint(a3, a2, h1);

                var tb0 : Point = getPoint(b1, b0, h0);
                var tb1 : Point = getPoint(b1, b0, h1);
                var tb2 : Point = getPoint(b3, b2, h0);
                var tb3 : Point = getPoint(b3, b2, h1);

                for (var v : int = 0; v < vDiv; v++) {

                    var v0 : Number = v / vDiv;
                    var v1 : Number = (v + 1) / vDiv;

                    var tta0 : Point = getPoint(ta1, ta0, v0);
                    var tta1 : Point = getPoint(ta1, ta0, v1);
                    var tta2 : Point = getPoint(ta3, ta2, v0);
                    var tta3 : Point = getPoint(ta3, ta2, v1);
    
                    var ttb0 : Point = getPoint(tb1, tb0, v0);
                    var ttb1 : Point = getPoint(tb1, tb0, v1);
                    var ttb2 : Point = getPoint(tb3, tb2, v0);
                    var ttb3 : Point = getPoint(tb3, tb2, v1);

                    drawBitmapTriangle(g, bitmapData,
                        tta0, tta1, tta2, ttb0, ttb1, ttb2);
                    drawBitmapTriangle(g, bitmapData,
                        tta3, tta1, tta2, ttb3, ttb1, ttb2);
                }
            }
        }

        private static function getPoint(p0 : Point, p1 : Point, ratio : Number) : Point {
            return new Point(
                p0.x + (p1.x - p0.x) * ratio,
                p0.y + (p1.y - p0.y) * ratio
            );
        }

        private static function createMatrix(
            a0 : Point, a1 : Point, a2 : Point, 
            b0 : Point, b1 : Point, b2 : Point
        ) : Matrix {

            var ma : Matrix = new Matrix(
                a1.x - a0.x, a1.y - a0.y,
                a2.x - a0.x, a2.y - a0.y);
            ma.invert();

            var mb : Matrix = new Matrix(
                b1.x - b0.x, b1.y - b0.y,
                b2.x - b0.x, b2.y - b0.y);

            var m : Matrix = new Matrix();
            m.translate(-a0.x, -a0.y);
            m.concat(ma);
            m.concat(mb);
            m.translate(b0.x, b0.y);

            return m;
        }

        private static function drawTriangle(
            g : Graphics,
            p0 : Point, p1 : Point, p2 : Point,
            matrix : Matrix
        ) : void {

            p0 = matrix.transformPoint(p0);
            p1 = matrix.transformPoint(p1);
            p2 = matrix.transformPoint(p2);

            g.moveTo(p0.x, p0.y);
            g.lineTo(p1.x, p1.y);
            g.lineTo(p2.x, p2.y);
            g.lineTo(p0.x, p0.y);
        }        
    }
}
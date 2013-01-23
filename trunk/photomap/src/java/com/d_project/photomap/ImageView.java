package com.d_project.photomap;

import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Rectangle;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;

import javax.swing.JComponent;

/**
 * ImageView
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
public class ImageView extends JComponent {

    private transient BufferedImage image;
    private transient BufferedImage tempImage;
    private double scale;
    private String label = "[Drop Here]";
    private int gap = 4;
    
    public ImageView() {

        addComponentListener(new ComponentAdapter() {

            public void componentResized(ComponentEvent e) {
                if (scale == 0) {
                    tempImage = null;
                    repaint();
                }
            }

        } );
    }
    
    public void setImage(BufferedImage image) {
        this.image = image;
        this.tempImage = null;
        repaint();
    }
    
    public BufferedImage getImage() {
        return image;
    }

    public void setScale(double scale) {
        this.scale = scale;
        this.tempImage = null;
        repaint();
    }

    public double getScale() {
        return scale;
    }

    public void paint(Graphics g) {
        
        super.paint(g);
        
        Dimension size = getSize();

        if (tempImage == null) {
            tempImage = createScaledImage();
        }
        
        if (tempImage != null) {
            int x = (size.width - tempImage.getWidth() ) / 2;
            int y = (size.height - tempImage.getHeight() ) / 2;
            g.drawImage(tempImage, x, y, this);
        }

        if (image == null) {
            Font font = getFont();
            FontMetrics fm = getFontMetrics(font);
            int x = (size.width - fm.stringWidth(label) ) / 2;
            int y = (size.height - fm.getMaxAscent() ) / 2 + fm.getMaxAscent();
            g.setFont(font);
            g.setColor(getForeground() );
            g.drawString(label, x, y);
        }
    }

    public Dimension getPreferredSize() {

        if (image != null) {
            if (scale != 0) {
                return new Dimension(
                    (int)(image.getWidth() * scale) + gap * 2,
                    (int)(image.getHeight() * scale) + gap * 2);
            } else {
                return new Dimension(gap * 2, gap * 2);
            }

        } else {
            Font font = getFont();
            FontMetrics fm = getFontMetrics(font);
            return new Dimension(
                fm.stringWidth(label) + gap * 2,
                fm.getMaxAscent() + gap * 2);
        }
    }

    
    private double getFitScale() {
        
        Rectangle rect = getVisibleRect();            
        double scale = 1.0;

        if (image != null) {
            double bw = Math.max(0, rect.width  - gap * 2);
            double bh = Math.max(0, rect.height - gap * 2);
            double iw = image.getWidth();
            double ih = image.getHeight();
            
            if (bw / bh > iw / ih) {
                scale = bh / ih;
            } else {
                scale = bw / iw;
            }
        }
        
        return Math.min(scale, 1.0);
    }

    private BufferedImage createScaledImage() {

        double scale = getScale();

        if (scale == 0) {
            scale = getFitScale();
        }
        
        if (scale != 1.0 && scale > 0) {

            AffineTransformOp op = new AffineTransformOp(
                new AffineTransform(scale, 0, 0, scale, 0, 0),
                AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
                
            return op.filter(image, null);

        } else {
            return image;
        }
                        
    }

}

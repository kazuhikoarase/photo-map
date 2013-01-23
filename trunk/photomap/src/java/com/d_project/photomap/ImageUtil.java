package com.d_project.photomap;

import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.awt.image.ColorConvertOp;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.imageio.ImageIO;

/**
 * ImageUtil
 * @author Kazuhiko Arase
 */
public class ImageUtil {
    
    private ImageUtil() {
    }

    public static void createImage(File srcImageFile, File dstImageFile, int size) throws IOException {

        BufferedImage image = ImageIO.read(srcImageFile);
            
        double scale = 1.0;

        scale = (double)size / image.getHeight();
         
        if (scale != 1.0) {
            AffineTransformOp atop = new AffineTransformOp(
                new AffineTransform(scale, 0, 0, scale, 0, 0),
                    AffineTransformOp.TYPE_BILINEAR);
            image = atop.filter(image, null);
        }

        if (image.getType() != BufferedImage.TYPE_INT_RGB) {
            ColorConvertOp ccop = new ColorConvertOp(null);
            image = ccop.filter(image, new BufferedImage(image.getWidth(), image.getHeight(), BufferedImage.TYPE_INT_RGB) );
        }

        if (!dstImageFile.getParentFile().exists() ) {
            dstImageFile.getParentFile().mkdirs();
        }

        OutputStream tempOut = new BufferedOutputStream(
            new FileOutputStream(dstImageFile) );

        try {
            ImageIO.write(image, "jpg", tempOut);           
        } finally {
            tempOut.close();
        }

    }

}

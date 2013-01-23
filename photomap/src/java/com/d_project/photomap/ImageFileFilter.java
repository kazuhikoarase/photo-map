package com.d_project.photomap;

import java.io.File;

/**
 * ImageFileFilter
 * @author Kazuhiko Arase
 */
public class ImageFileFilter implements java.io.FileFilter {

    public ImageFileFilter() {
    }
    
    public boolean accept(File f) {
        return f.isFile() && f.getName().toLowerCase().endsWith(".jpg");
    }
}

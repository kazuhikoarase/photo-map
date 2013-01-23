package com.d_project.photomap;

import java.io.File;

/**
 * DirectoryFileFilter
 * @author Kazuhiko Arase
 */
public class DirectoryFileFilter implements java.io.FileFilter {


    public DirectoryFileFilter() {
    }
    
    public boolean accept(File f) {
        return f.isDirectory()
            && !f.isHidden()
            && !f.getName().startsWith(".");
    }
}

package com.d_project.photomap;

import java.io.File;

import javax.swing.filechooser.FileFilter;

/**
 * XMLFileFilter
 * @author Kazuhiko Arase
 */
public class XMLFileFilter extends FileFilter
implements java.io.FileFilter {

    private String extension;

    public XMLFileFilter() {
        this.extension = "xml";
    }
    
    public boolean accept(File f) {
        return f.isDirectory() || f.getName().endsWith("." + extension);
    }

    public String getDescription() {
        return extension + " files";
    }
}

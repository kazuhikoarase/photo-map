package com.d_project.photomap;

import java.io.File;
import java.io.FileFilter;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Vector;

import javax.swing.tree.TreeNode;

/**
 * FileTreeNode
 * @author Kazuhiko Arase
 */
public class FileTreeNode implements TreeNode {

    private File file;

    private FileFilter filter;
    
    private Vector<File> files;
     
    public FileTreeNode(File file) {
        this(file, new DirectoryFileFilter() );
    }
    
    private FileTreeNode(File file, FileFilter filter) {

        if (file == null) {
            throw new NullPointerException();
        }
        
        this.file = file;
        this.filter = filter;

        if (file.isDirectory() ) {
            this.files = new Vector<File>();
            files.addAll(Arrays.asList(file.listFiles(filter) ) );
        }
    }
    
    public boolean equals(Object o) {
        return file.equals( ((FileTreeNode)o).file);
    }
    
    public int hashCode() {
        return file.hashCode();
    }
    
    public Enumeration<File> children() {
        return files.elements();
    }

    public File getFile(int index) {
        return (File)files.get(index);
    }
    
    public boolean getAllowsChildren() {
        return file.isDirectory();
    }

    public TreeNode getChildAt(int childIndex) {
        return new FileTreeNode(getFile(childIndex), filter);
    }

    public File getFile() {
        return file;
    }

    public int getChildCount() {
        return (files != null)? files.size() : 0;
    }

    public int getIndex(TreeNode node) {
        return files.indexOf( ( (FileTreeNode)node).file);
    }

    public TreeNode getParent() {
        if (file.getParentFile() != null) {
            return new FileTreeNode(file.getParentFile(), filter);
        } else {
            return null;
        }
    }

    public boolean isLeaf() {
        return file.isFile();
    }
    
    public String toString() {
        return file.getName();
    }

}
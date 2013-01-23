package com.d_project.photomap;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * FileUtil
 * @author Kazuhiko Arase
 */
public class FileUtil {

    private static String[] getPath(File path) throws IOException {
        
        List<String> list = new ArrayList<String>();

        path = path.getCanonicalFile();

        while (path != null) {
            list.add(0, path.getName() );
            path = path.getParentFile();
        }

        return (String[])list.toArray(new String[list.size()]);
    }
    
    public static String getRelativePath(File file1, File file2) throws IOException {

        String[] path1 = getPath(file1);
        String[] path2 = getPath(file2);

        int baseIndex = 0;

        while (baseIndex < path1.length && baseIndex < path2.length
                && path1[baseIndex].equals(path2[baseIndex]) ) {
            baseIndex++;
        }

        StringBuffer buffer = new StringBuffer();
        int count = 0;

        for (int i = path2.length - 1; i >= baseIndex; i--) {
            if (count > 0) {
                buffer.append('/');
            }
            buffer.append("..");
            count++;
        }                

        for (int i = baseIndex; i < path1.length; i++) {
            if (count > 0) {
                buffer.append('/');
            }
            buffer.append(path1[i]);
            count++;
        }                

        return buffer.toString();
    }   

}

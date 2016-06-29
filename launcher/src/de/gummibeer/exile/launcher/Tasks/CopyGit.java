package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import de.gummibeer.exile.launcher.Launcher;
import org.apache.log4j.Logger;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

public class CopyGit implements Task {
    private static Logger logger = Logger.getLogger(CopyGit.class);

    public static String source = "";
    private static String destination = "";

    public static boolean run() {
        logger.info("Start Task: CopyGit");
        File[] directories = new File(source).listFiles(File::isDirectory);
        source = directories[0].getAbsolutePath();
        logger.debug("Source: " + source);
        destination = Launcher.getConfig("armafolder");
        logger.debug("Destination: " + destination);

        try {
            logger.debug("copy files");
            List<File> files = new ArrayList<>();
            files.add(new File(source + File.separator + "@ExileServer"));
            files.add(new File(source + File.separator + "@infiSTAR_Exile"));
            files.add(new File(source + File.separator + "mpmissions"));
            files.add(new File(source + File.separator + "keys"));
            files.add(new File(source + File.separator + "config"));
            for (File file : files) {
                copyFileOrFolder(
                        file,
                        (new File(destination + File.separator + file.getName())),
                        StandardCopyOption.REPLACE_EXISTING
                );
            }
        } catch (FileNotFoundException exception) {
            logger.error(exception.getMessage());
            return false;
        } catch (IOException exception) {
            logger.error(exception.getMessage());
            return false;
        }

        return true;
    }

    private static void copyFileOrFolder(File source, File dest, CopyOption options) throws IOException {
        logger.debug("delete: " + dest.getName());
        deleteFileOrFolder(dest);
        logger.debug("copy: " + source.getName());
        if (source.isDirectory()) {
            copyFolder(source, dest, options);
        } else {
            ensureParentFolder(dest);
            copyFile(source, dest, options);
        }
    }

    private static void copyFolder(File source, File dest, CopyOption options) throws IOException {
        if (!dest.exists()) {
            dest.mkdirs();
        }
        File[] contents = source.listFiles();
        if (contents != null) {
            for (File f : contents) {
                File newFile = new File(dest.getAbsolutePath() + File.separator + f.getName());
                if (f.isDirectory()) {
                    copyFolder(f, newFile, options);
                } else {
                    copyFile(f, newFile, options);
                }
            }
        }
    }

    private static void copyFile(File source, File dest, CopyOption options) throws IOException {
        Files.copy(source.toPath(), dest.toPath(), options);
    }

    private static void ensureParentFolder(File file) {
        File parent = file.getParentFile();
        if (parent != null && !parent.exists()) {
            parent.mkdirs();
        }
    }

    private static void deleteFileOrFolder(File f) throws IOException, NullPointerException {
        if (f.isDirectory()) {
            for (File c : f.listFiles()) {
                deleteFileOrFolder(c);
            }
        }
        if (!f.delete()) {
            throw new FileNotFoundException("Failed to delete file: " + f);
        }
    }
}

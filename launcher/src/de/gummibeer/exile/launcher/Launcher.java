package de.gummibeer.exile.launcher;

import de.gummibeer.exile.launcher.Tasks.*;
import org.apache.log4j.*;
import org.ini4j.Ini;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Launcher {

    private static Logger logger = Logger.getRootLogger();

    public static Ini ini;

    public static String version = "live";

    public static void main(String[] args) {
        try {
            SimpleLayout layout = new SimpleLayout();
            ConsoleAppender consoleAppender = new ConsoleAppender(layout);
            logger.addAppender(consoleAppender);
            FileAppender fileAppender = new FileAppender(layout, "logs/launcher.log", false);
            logger.addAppender(fileAppender);
            logger.setLevel(Level.ALL);
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

        logger.info("Start Arma 3 Launcher");
        logger.debug("all args: " + Arrays.toString(args));

        try {
            ini = new Ini(new File("config.ini"));
        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        }

        List<String> argsList = new ArrayList<>();
        List<String> optsList = new ArrayList<>();

        for (String arg : args) {
            switch (arg.charAt(0)) {
                case '-':
                    if (arg.length() < 2)
                        throw new IllegalArgumentException("Not a valid argument: " + arg);
                    if (arg.charAt(1) == '-') {
                        if (arg.length() < 3) {
                            throw new IllegalArgumentException("Not a valid argument: " + arg);
                        }
                        optsList.add(arg.substring(2, arg.length()));
                    }
                    break;
                default:
                    argsList.add(arg);
                    break;
            }
        }
        logger.debug("args: " + Arrays.toString(argsList.toArray()));
        logger.debug("opts: " + Arrays.toString(optsList.toArray()));

        List<String> tasks = new ArrayList<>();
        tasks.add("stop");
        tasks.add("pack");
        for (String option : optsList) {
            switch (option) {
                case "restart":
                    tasks.add("start");
                    break;
                case "live":
                    version = "live";
                    break;
                case "test":
                    version = "test";
                    break;
                default:
                    tasks.add(option);
                    break;
            }
        }

        logger.info("Version: " + version);

        logger.info("Tasks to do: " + Arrays.toString(tasks.toArray()));
        if (tasks.contains("stop")) {
            StopServer.run();
        }
        if (tasks.contains("update")) {
            UpdateServer.run();
        }
        if (tasks.contains("pull")) {
            DownloadGit.run();
            ExtractGit.run();
            CopyGit.run();
        }
        if (tasks.contains("pack")) {
            PackPbos.run();
        }
        if (tasks.contains("start")) {
            StartServer.run();
        }
    }

    public static String getConfig(String key) {
        return ini.get(version, key);
    }

}

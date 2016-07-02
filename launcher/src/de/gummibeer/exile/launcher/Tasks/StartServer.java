package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import de.gummibeer.exile.launcher.Launcher;
import org.apache.log4j.Logger;

import java.io.IOException;

public class StartServer implements Task {
    private static Logger logger = Logger.getLogger(StartServer.class);

    public static boolean run() {
        logger.info("Start Task: StartServer");
        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            try {
                logger.debug("start arma3server.exe");
                Runtime rt = Runtime.getRuntime();
                String armaStart = "start \"arma3\" /min /high" +
                        " \"" + Launcher.getConfig("armaserver") + "\"" +
                        " \"-profiles=" + Launcher.getConfig("armaprofiles") + "\"" +
                        " \"-BEPath=" + Launcher.getConfig("armabe") + "\"" +
                        " \"-config=" + Launcher.getConfig("armaconfig") + "\"" +
                        " \"-cfg=" + Launcher.getConfig("armacfg") + "\"" +
                        " -port=" + Launcher.getConfig("armaport") +
                        " -world=empty -autoinit -malloc=system -nosplash -high" +
                        " \"-mod=" + Launcher.getConfig("armamods") + "\"";
                logger.debug(armaStart);
                rt.exec(armaStart);
                logger.debug("started arma3server.exe");
                logger.debug("start bec.exe");
                String becStart = "start \"\" /min " +
                        " \"" + Launcher.getConfig("becexe") + "\"" +
                        " -f config.cfg";
                logger.debug(becStart);
                rt.exec(becStart);
                logger.debug("started bec.exe");
            } catch(IOException ex) {
                logger.error(ex.getMessage());
                return false;
            }
        } else {
            logger.warn("unsupported OS");
            return false;
        }
        return true;
    }
}

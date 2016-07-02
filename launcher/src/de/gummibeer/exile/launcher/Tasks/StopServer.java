package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import org.apache.log4j.Logger;

import java.io.IOException;

public class StopServer implements Task {
    private static Logger logger = Logger.getLogger(StopServer.class);

    public static boolean run() {
        logger.info("Start Task: StopServer");
        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            try {
                Runtime rt = Runtime.getRuntime();
                logger.debug("stop arma3server.exe");
                rt.exec("taskkill /f /im arma3server.exe");
                logger.debug("stopped arma3server.exe");
                logger.debug("stop bec.exe");
                rt.exec("taskkill /f /im bec.exe");
                logger.debug("stopped bec.exe");
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

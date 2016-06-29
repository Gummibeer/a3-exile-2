package de.gummibeer.exile.launcher.Tasks;

import de.gummibeer.exile.launcher.Contracts.Task;
import org.apache.log4j.Logger;

public class StopServer implements Task {
    private static Logger logger = Logger.getLogger(StopServer.class);

    public static boolean run() {
        logger.info("Start Task: StopServer");
        return true;
    }
}

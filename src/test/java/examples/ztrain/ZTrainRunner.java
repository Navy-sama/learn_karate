package examples.ztrain;

import com.intuit.karate.junit5.Karate;

class ZTrainRunner {
    
    @Karate.Test
    Karate testZTrain() {
        return Karate.run("ztrain").relativeTo(getClass());
    }
    
}
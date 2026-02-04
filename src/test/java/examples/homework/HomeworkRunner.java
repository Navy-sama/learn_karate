package examples.homework;

import com.intuit.karate.junit5.Karate;

class HomeworkRunner {
    
    @Karate.Test
    Karate testHomework() {
        return Karate.run("HomeWork").relativeTo(getClass());
    }
    
}
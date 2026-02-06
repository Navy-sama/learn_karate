package examples.homework;

import com.intuit.karate.junit5.Karate;

class HomeworkRunner {
    
    @Karate.Test
    Karate testHomework() {
        return Karate.run().relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testByTagsParallel() {
        return Karate.run()
            .tags("@str-art,@str-comm");
    }
    
    @Karate.Test
    Karate testCommentExamples() {
        return Karate.run()
            .tags("@comment-examples");
    }
    
    @Karate.Test
    Karate testZtrainWithRetry() {
        return Karate.run()
            .tags("@ztrain-retry");
    }
    
    @Karate.Test
    Karate testWithTokenInit() {
        return Karate.run()
            .tags("@token-init");
    }
    
    @Karate.Test
    Karate testNoTokenFeatures() {
        return Karate.run()
            .tags("@no-token");
    }
    
    @Karate.Test
    Karate testWithTokenFeatures() {
        return Karate.run()
            .tags("@with-token");
    }
    
    @Karate.Test
    Karate testConditionalLogic() {
        return Karate.run()
            .tags("@conditional-logic");
    }
     
}
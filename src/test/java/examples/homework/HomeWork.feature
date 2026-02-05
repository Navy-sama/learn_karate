Feature: Home Work

    Background: Preconditions
        * url apiUrl
        * def login = call read('login.feature')
        * def authToken = "Token " + login.response.user.token
        * def username = login.response.user.username 
        * def articles_schema = read('json/article.json')
        * def comment_schema = read('json/comment.json')

    @str-art
    Scenario: Favorite articles
        # Step 1: Get atricles of the global feed
        * def articlesResponse = call read('get_articles.feature')
        * def articles = articlesResponse.response.articles
        
        
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def firstArticle = articles[0]
        * def firstArticleSlug = firstArticle.slug
        * def firstArticleFavCount = firstArticle.favoritesCount


        # Step 3: Make POST request to increse favorites count for the first article
        * def addFavorite = call read('add_favorite.feature') {slug: '#(firstArticleSlug)'} 
        * def addFavoriteResponse = addFavorite.response
        

        # Step 4: Verify response schema
        * match addFavoriteResponse == articles_schema


        # Step 5: Verify that favorites article incremented by 1
        * def updatedFavCount = addFavoriteResponse.article.favoritesCount
        * match updatedFavCount == firstArticleFavCount + 1


        # Step 6: Get updated articles list and filter for favorited articles
        * def favoritedArticlesResponse = call read('get_fav_articles.feature') {username: "#(username)"}
        * def favoritedArticles = favoritedArticlesResponse.response.articles


        # Step 7: Verify response schema for each favorited article
        * match each favoritedArticles == articles_schema.article


        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        * def slugExists = favoritedArticles.filter(article => article.slug == firstArticleSlug).length > 0
        * match slugExists == true


    @str-comm
    Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        * def articlesResponse = call read('get_articles.feature')
        * def articles = articlesResponse.response.articles
        
        
        # Step 2: Get the slug ID for the first arice, save it to variable
        * def firstArticle = articles[0]
        * def firstArticleSlug = firstArticle.slug


        # Step 3: Make a GET call to 'comments' end-point to get all comments
        * def commentsResponse = call read('get_comments.feature')


        # Step 4: Verify response schema
        * match commentsResponse.response == {"comments": "#array"}
        * def comments = commentsResponse.response.comments


        # Step 5: Get the count of the comments array lentgh and save to variable
        * def commentsCount = comments.length


        # Step 6: Make a POST request to publish a new comment
       * def publishComment = call read('publish_comment.feature') {slug: '#(firstArticleSlug)'} 


        # Step 7: Verify response schema that should contain posted comment text
        * match publishComment.response == comment_schema
        * def newComment = publishComment.response.comment

        
        # Step 8: Get the list of all comments for this article one more time
        * def newCommentsResponse = call read('get_comments.feature')
        * def newComments = newCommentsResponse.response.comments

        
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        * def newCommentsCount = newComments.length
        * match newCommentsCount == commentsCount + 1

        
        # Step 10: Make a DELETE request to delete comment
        * def deleteComment = call read('delete_comment.feature') {slug: '#(firstArticleSlug)', id: '#(newComment.id)'} 

        
        # Step 11: Get all comments again and verify number of comments decreased by 1
        * def finalCommentsResponse = call read('get_comments.feature')
        * def finalComments = finalCommentsResponse.response.comments
        * def finalCommentsCount = finalComments.length
        * match finalCommentsCount == newCommentsCount - 1
        * match finalCommentsCount == commentsCount

        # Special Step 12: create four distincts features grouping some steps done earlier and add tags to these features to have two features which necessitate token and 2 features which do not (give representative titles to features)



        # Special Step 13: Add regex verifications for dates("2024-01-27T21:32:21.056Z")
        * match firstArticle.createdAt == '#regex \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z'
        * match newComment.createdAt == '#regex \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z'


        
        # Special Step 14: To create comments, use examples with scenario outline


        
        # Special Step 15: Add an after scenario to delete those comments


        
        # Special Step 16: Create a feature to generate a valid token


        
        # Special Step 17: Create a global variable in karate-config for the token


        
        # Special Step 18: Make the feature of step 16 execute and initialize the variable of step 17 when a specific tag is present within the feature run when the tests launched


        
        # Special Step 19: Create a feature with Ztrain api and integrate retry for some of the test steps


        
        # Special Step 20: Run tests by tags and in parallel using the runner


        
        # Special Step 21: Run tests by tags and in parallel using command line


        
        # Special Step 22: Add conditional logic to some feature (par exemple lorsque que l'on contrôle le tableau des favorites faire un if si le tableau est vide lors du match)


        

        
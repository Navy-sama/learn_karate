Feature: Conditional Logic Examples

    Background: Preconditions
        * url apiUrl
        * def login = call read('login.feature')
        * def authToken = "Token " + login.response.user.token
        * def username = login.response.user.username

    @conditional-logic
    Scenario: Conditional verification of favorites
        # Get favorited articles
        * def favoritedArticlesResponse = call read('get_fav_articles.feature') {username: "#(username)"}
        * def favoritedArticles = favoritedArticlesResponse.response.articles
        
        # Conditional logic: Check if favorites array is empty
        * if (favoritedArticles.length == 0) karate.log('No favorite articles found - array is empty')
        * if (favoritedArticles.length == 0) match favoritedArticles == []
        * if (favoritedArticles.length > 0) karate.log('Found', favoritedArticles.length, 'favorite articles')
        * if (favoritedArticles.length > 0) match favoritedArticles == '#array'
        * if (favoritedArticles.length > 0) match each favoritedArticles == '#object'
        
        # Get all articles for comparison
        * def articlesResponse = call read('get_articles.feature')
        * def articles = articlesResponse.response.articles
        
        # Conditional logic: Only verify first article if favorites exist
        * if (favoritedArticles.length > 0) def firstFavorite = favoritedArticles[0]
        * if (favoritedArticles.length > 0) match firstFavorite.favorited == true
        * if (favoritedArticles.length > 0) match firstFavorite.slug == '#string'
        
        # Conditional logic: Add to favorites if array is empty, otherwise verify existing
        * if (favoritedArticles.length == 0) def firstArticle = articles[0]
        * if (favoritedArticles.length == 0) def addFavorite = call read('add_favorite.feature') {slug: '#(firstArticle.slug)'}
        * if (favoritedArticles.length == 0) match addFavorite.response.article.favorited == true
        
        # Final verification with conditional logic
        * def finalFavoritesResponse = call read('get_fav_articles.feature') {username: "#(username)"}
        * def finalFavorites = finalFavoritesResponse.response.articles
        * if (finalFavorites.length > 0) karate.log('Final favorites count:', finalFavorites.length)
        * if (finalFavorites.length > 0) match finalFavorites == '#array'
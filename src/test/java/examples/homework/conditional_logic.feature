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
        * eval if (favoritedArticles.length == 0) karate.match(favoritedArticles, [])
        * if (favoritedArticles.length > 0) karate.log('Found', favoritedArticles.length, 'favorite articles')
        * eval if (favoritedArticles.length > 0) karate.match(favoritedArticles, '#array')
        * match each favoritedArticles == '#object'
        
        # Get all articles for comparison
        * def articlesResponse = call read('get_articles.feature')
        * def articles = articlesResponse.response.articles
        
        # Conditional logic: Only verify first article if favorites exist
        * def firstFavorite = favoritedArticles.length > 0 ? favoritedArticles[0] : null
        * if (favoritedArticles.length > 0) karate.match(firstFavorite.favorited, true)
        * if (favoritedArticles.length > 0) karate.match(firstFavorite.slug, '#string')
        
        # Conditional logic: Add to favorites if array is empty, otherwise verify existing
        * def firstArticle = favoritedArticles.length == 0 ? articles[0] : null
        * if (favoritedArticles.length == 0) karate.def('addFavorite', karate.call(read('add_favorite.feature'), {slug: firstArticle.slug}))
        * if (favoritedArticles.length == 0) karate.match(addFavorite.response.article.favorited, true)
        
        # Final verification with conditional logic
        * def finalFavoritesResponse = call read('get_fav_articles.feature') {username: "#(username)"}
        * def finalFavorites = finalFavoritesResponse.response.articles
        * if (finalFavorites.length > 0) karate.log('Final favorites count:', finalFavorites.length)
        * if (finalFavorites.length > 0) karate.match(finalFavorites, '#array')
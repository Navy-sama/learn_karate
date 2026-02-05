Feature: Favorites Operations With Token

    Background: Preconditions
        * url apiUrl
        * def login = call read('login.feature')
        * def authToken = "Token " + login.response.user.token
        * def username = login.response.user.username

    @with-token @favorites @token-init
    Scenario: Manage article favorites
        # Get articles
        * def articlesResponse = call read('get_articles.feature')
        * def articles = articlesResponse.response.articles
        * def firstArticle = articles[0]
        * def firstArticleSlug = firstArticle.slug
        
        # Add to favorites
        * def addFavorite = call read('add_favorite.feature') {slug: '#(firstArticleSlug)'}
        * match addFavorite.response.article.favorited == true
        
        # Get user's favorites
        * def favoritesResponse = call read('get_fav_articles.feature') {username: "#(username)"}
        * match favoritesResponse.response.articles == '#array'
        
        # Verify the article is in favorites
        * def slugExists = favoritesResponse.response.articles.filter(article => article.slug == firstArticleSlug).length > 0
        * match slugExists == true
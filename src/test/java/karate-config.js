function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: 'https://api-ztrain.onrender.com/',
    apiUrl: 'https://conduit-api.bondaracademy.com/api/',
    email: 'yvannouafo29@gmail.com',
    password: 'Azerty1234567',
    globalAuthToken: null // Will be initialized by generate_token.feature when @token-init tag is present
  }
  
  // Initialize global token if @token-init tag is present
  if (karate.tags && karate.tags.includes('@token-init')) {
    var tokenResult = karate.callSingle('classpath:examples/homework/generate_token.feature');
    config.globalAuthToken = tokenResult.globalToken;
    karate.log('Global token initialized:', config.globalAuthToken);
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  return config;
}
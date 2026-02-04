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
    password: 'Azerty1234567'
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  return config;
}
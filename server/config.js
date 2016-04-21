const config = {
  ENV: process.env.ENV || 'local',
  SERVER_PROTOCOL: 'http',
  DB_HOST: 'localhost',
  DB_PORT: 27017,
  DB_NAME: 'memo-server-dev',
  EXPRESS_PORT: 3000,
};

switch (config.ENV) {
  case 'local':
    Object.assign(config, {
      DB_HOST: 'localhost',
      DB_PORT: 27017,
      DB_NAME: 'memo-server-dev',
      EXPRESS_PORT: 3000,
    });
    break;
  default:
    console.error("Unknown ENV");
    process.exit();
}

console.log(`Welcome to memo-server! Environment is ${config.ENV} now!!`);

module.exports = config;

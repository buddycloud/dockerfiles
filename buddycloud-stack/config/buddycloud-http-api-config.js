// config.js:
// HTTP API server configuration. See README.md for details.

// Default settings (apply to all profiles)
exports._ = {
  port: 9123,
};

// Production settings (used by default)
exports.production = {
  debug: true,
  xmppDomain: 'buddycloud.dev',
  xmppHost: '127.0.0.1',
  xmppAnonymousDomain: 'anon.buddycloud.dev',
  channelDomain: 'buddycloud.buddycloud.dev',
  searchComponent: 'search.buddycloud.org',
  homeMediaRoot: 'http://localhost:60080',
  disableWebsocket: false,
  logTransport: 'file',
  logFile: '/var/log/buddycloud/buddycloud-http-api/buddycloud-http-api.log',
  logLevel: 'debug',
  logUseJson: false
};

// config.js:
// HTTP API server configuration. See README.md for details.

// Default settings (apply to all profiles)
exports._ = {
  port: 9123,
};

// Production settings (used by default)
exports.production = {
  debug: true,
  xmppDomain: 'buddycloud.f24.com',
  xmppHost: '127.0.0.1',
  xmppAnonymousDomain: 'anon.buddycloud.f24.com',
  channelDomain: 'buddycloud.buddycloud.f24.com',
  searchComponent: 'search.buddycloud.org',
  homeMediaRoot: 'http://localhost:60080',
  disableWebsocket: false
};

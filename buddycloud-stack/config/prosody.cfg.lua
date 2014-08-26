modules_enabled = {
  "saslauth";           -- Authentication for clients and servers. Recommended if you want to log in.
  "tls";                -- Add support for secure TLS on c2s/s2s connections
  "dialback";           -- s2s dialback support
  "disco";              -- Service discovery
  "time";               -- Let others know the time here on this server
  "ping";               -- Replies to XMPP pings with pongs
  "posix";              -- Do posixy things
  "register";           -- Allow users to register on this server using a client and change passwords
  "watchregistrations"; -- Alert admins of registrations (check "admins" option below too)
  "compression";        -- Enable mod_compression
};

storage                 = "internal"
admins                  = { "your-username@buddycloud.dev" }  -- who receives registration alerts
pidfile                 = "/var/run/prosody/prosody.pid"
log                     = {{ levels = { min = "error" }, to = "file", filename = "/var/log/prosody/prosody.err" };
                           { levels = { min = "info"  }, to = "file", filename = "/var/log/prosody/prosody.log" };}
registration_whitelist      = { "127.0.0.1" }
whitelist_registration_only = true


VirtualHost "buddycloud.dev"
  authentication        = "internal_hashed"
  allow_registration    = true 
  anonymous_login       = false
  ssl                   = { certificate = "/etc/apache2/certs/buddycloud.dev.cert.pem";
                                    key = "/etc/apache2/certs/buddycloud.dev.key.pem" }

-- for non-logged in browsing of open channels.
VirtualHost "anon.buddycloud.dev"
  authentication        = "anonymous"
  anonymous_login       = true
  allow_anonymous_s2s   = true

-- Buddycloud Channel Server XMPP component configuration.
Component "buddycloud.buddycloud.dev"
  component_secret      = "tellnoone"

-- Buddycloud Channel Server (optional topic channels).
Component "topics.buddycloud.dev"
  component_secret      = "tellnoone"

-- Buddycloud Media Server XMPP component configuration.
Component "media.buddycloud.dev"
  component_secret      = "tellnoone"

-- Buddycloud Pusher Server XMPP component configuration.
Component "pusher.buddycloud.dev"
  component_secret      = "tellnoone"

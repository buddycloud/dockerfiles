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
admins                  = { "your-username@buddycloud.f24.com" }  -- who receives registration alerts
pidfile                 = "/var/run/prosody/prosody.pid"
log                     = {{ levels = { min = "error" }, to = "file", filename = "/var/log/buddycloud/prosody.err" };
                           { levels = { min = "info"  }, to = "file", filename = "/var/log/buddycloud/prosody.log" };}
registration_whitelist      = { "127.0.0.1" }
whitelist_registration_only = true


VirtualHost "buddycloud.f24.com"
  authentication        = "internal_hashed"
  allow_registration    = true 
  anonymous_login       = false
  ssl                   = { certificate = "/srv/ssl/certs/star_f24_com.crt";
                                    key = "/srv/ssl/private/f24_wildcard_digicert.key" }

-- for non-logged in browsing of open channels.
VirtualHost "anon.buddycloud.f24.com"
  authentication        = "anonymous"
  anonymous_login       = true
  allow_anonymous_s2s   = true

-- Buddycloud Channel Server XMPP component configuration.
Component "buddycloud.buddycloud.f24.com"
  component_secret      = "tellnoone"

-- Buddycloud Channel Server (optional topic channels).
Component "topics.buddycloud.f24.com"
  component_secret      = "tellnoone"

-- Buddycloud Media Server XMPP component configuration.
Component "media.buddycloud.f24.com"
  component_secret      = "tellnoone"

-- Buddycloud Pusher Server XMPP component configuration.
Component "pusher.buddycloud.f24.com"
  component_secret      = "tellnoone"

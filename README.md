# Ixtlan #

this gem adds more security related headers to the response for a rails3 application. mainly inspired by
[google-gets-a-1-for-browser-security](http://www.barracudalabs.com/wordpress/index.php/2011/07/21/google-gets-a-1-for-browser-security-3/)
and
[HttpCaching](http://code.google.com/p/doctype/wiki/ArticleHttpCaching).
and
[Clickjacking](http://www.owasp.org/index.php/Clickjacking)

the extra headers are

* x-frame headers
* x-content-type headers
* x-xss-protection headers
* caching headers

the main idea is to set the default as strict as possible and the application might relax the setup here and there.

## rails configuration ##

in _config/application.rb_ or in one of the _config/environments/*rb_ files or in an initializer. all three x-headers can be configured here, for example

    config.x_content_type_headers = :nosniff

## controller configuration ##

just add in your controller something like

    x_xss_protection :block
    
## option for each *render*, *send\_file*, *send\_data* methods

an example for an inline render

    render :inline => 'behappy', :x_frame_headers => :deny
    
## possible values ##

* x\_frame\_headers : `:deny, :sameorigin, :off` default `:deny`

* x\_content\_type\_headers : `:nosniff, :off` default `:nosniff`

* x\_xss\_protection\_headers : `:block, :disabled, :off` default `:block`

## cache headers

the cache headers needs to have a **current\_user**, i.e. the current\_user method of the controller needs to return a non-nil value. further the the method needs to `:get` and the response status an "ok" status,

then you can use the controller configuration or the options with *render*, *send\_file* and *send\_data*.

## possible values ##

* `:private` : which tells not to cache or store any data except the browser memory: [no caching](http://code.google.com/p/doctype/wiki/ArticleHttpCaching#No_caching)

* `:protected` : no caching but the browser: [Only the end user's browser is allowed to cache](http://code.google.com/p/doctype/wiki/ArticleHttpCaching#Only_the_end_user%27s_browser_is_allowed_to_cache)

* `:public` : caching is allowed: [Both browser and proxy allowed to cache](http://code.google.com/p/doctype/wiki/ArticleHttpCaching#Both_browser_and_proxy_allowed_to_cache)

* `:my_headers` : custom header method like 

>     def my_headers
        no_store = false
        no_caching(no_store)
      end

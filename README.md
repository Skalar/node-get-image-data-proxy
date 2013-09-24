# Get Image Data Proxy

Node HTTP server used as a backend / proxy for fetching images via JSONP
for browsers which do not support CORS set on images.

Takes two get params `url` to the image and `callback` for JSONP.
HTTP server streams image, base64 encodes it together with the JSONP related parts.

Could be used together with something like for instance
https://github.com/betamax/getImageData

This node app may be deployed to Heroku.

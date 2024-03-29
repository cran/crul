% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/verbs.R
\name{verb-PUT}
\alias{verb-PUT}
\title{HTTP verb info: PUT}
\description{
The PUT method replaces all current representations of the target
resource with the request payload.
}
\section{The PUT method}{

The PUT method requests that the state of the target resource be
created or replaced with the state defined by the representation
enclosed in the request message payload.  A successful PUT of a given
representation would suggest that a subsequent GET on that same
target resource will result in an equivalent representation being
sent in a 200 (OK) response. However, there is no guarantee that
such a state change will be observable, since the target resource
might be acted upon by other user agents in parallel, or might be
subject to dynamic processing by the origin server, before any
subsequent GET is received.  A successful response only implies that
the user agent's intent was achieved at the time of its processing by
the origin server.

If the target resource does not have a current representation and the
PUT successfully creates one, then the origin server MUST inform the
user agent by sending a 201 (Created) response.  If the target
resource does have a current representation and that representation
is successfully modified in accordance with the state of the enclosed
representation, then the origin server MUST send either a 200 (OK) or
a 204 (No Content) response to indicate successful completion of the
request.
}

\examples{
\dontrun{
x <- HttpClient$new(url = "https://hb.opencpu.org")
x$put(path = 'put', body = list(foo = "bar"))
}

}
\references{
\url{https://datatracker.ietf.org/doc/html/rfc7231#section-4.3.4}
}
\seealso{
\link{crul-package}

Other verbs: 
\code{\link{verb-DELETE}},
\code{\link{verb-GET}},
\code{\link{verb-HEAD}},
\code{\link{verb-PATCH}},
\code{\link{verb-POST}}
}
\concept{verbs}

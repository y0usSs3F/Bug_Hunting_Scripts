import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;
import net.sf.ehcache.config.CacheConfiguration;
import net.sf.ehcache.config.PersistenceConfiguration;
import net.sf.ehcache.store.MemoryStoreEvictionPolicy;
/**
* Sample filter implementation to scrutiny CORS “Origin” HTTP header.<br/>
* 
* This implementation has a dependency on EHCache API because<br/>
* it use Caching for blacklisted client IP in order to enhance performance.
* 
* Assume here that all CORS resources are grouped in context path “/cors/”.
* 
*/
@WebFilter(“/cors/*”)
public class CORSOriginHeaderScrutiny implements Filter {
/** Filter configuration */
@SuppressWarnings(“unused”)
private FilterConfig filterConfig = null;
/** Cache used to cache blacklisted Clients (request sender) IP address */
private Cache blackListedClientIPCache = null;
/** Domains allowed to access to resources (white list) */
private List<String> allowedDomains = new ArrayList<String>();
/**
* {@inheritDoc}
* 
* @see Filter#init(FilterConfig)
*/
@Override
public void init(FilterConfig fConfig) throws ServletException {
// Get filter configuration
this.filterConfig = fConfig;
// Initialize Client IP address dedicated cache with a cache of 60 minutes expiration delay for each item
PersistenceConfiguration cachePersistence = new PersistenceConfiguration();
cachePersistence.strategy(PersistenceConfiguration.Strategy.NONE);
CacheConfiguration cacheConfig = new CacheConfiguration().memoryStoreEvictionPolicy(MemoryStoreEvictionPolicy.FIFO)
.eternal(false)
.timeToLiveSeconds(3600)
.diskExpiryThreadIntervalSeconds(450)
.persistence(cachePersistence)
.maxEntriesLocalHeap(10000)
.logging(false);
cacheConfig.setName(“BlackListedClientsCacheConfig”);
this.blackListedClientIPCache = new Cache(cacheConfig);
this.blackListedClientIPCache.setName(“BlackListedClientsCache”);
CacheManager.getInstance().addCache(this.blackListedClientIPCache);
// Load domains allowed white list (hard coded here only for example)
this.allowedDomains.add(“http://www.html5rocks.com”);
this.allowedDomains.add(“https://www.mydomains.com”);
}
/**
* {@inheritDoc}
* 
* @see Filter#destroy()
*/
@Override
public void destroy() {
// Remove Cache
CacheManager.getInstance().removeCache(“BlackListedClientsCache”);
}
/**
* {@inheritDoc}
* 
* @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
*/
@Override
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
throws IOException, ServletException {
HttpServletRequest httpRequest = ((HttpServletRequest) request);
HttpServletResponse httpResponse = ((HttpServletResponse) response);
List<String> headers = null;
boolean isValid = false;
String origin = null;
String clientIP = httpRequest.getRemoteAddr();
/* Step 0 : Check presence of client IP in black list */
if (this.blackListedClientIPCache.isKeyInCache(clientIP)) {
// Return HTTP Error without any information about cause of the request reject !
httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
// Add trace here
// ….
// Quick Exit
return;
}
/* Step 1 : Check that we have only one and non empty instance of the “Origin” header */
headers = CORSOriginHeaderScrutiny.enumAsList(httpRequest.getHeaders(“Origin”));
if ((headers == null) || (headers.size() != 1)) {
// If we reach this point it means that we have multiple instance of the “Origin” header
// Add client IP address to black listed client
addClientToBlacklist(clientIP);
// Return HTTP Error without any information about cause of the request reject !
httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
// Add trace here
// ….
// Quick Exit
return;
}
origin = headers.get(0);
/* Step 2 : Check that we have only one and non empty instance of the “Host” header */
headers = CORSOriginHeaderScrutiny.enumAsList(httpRequest.getHeaders(“Host”));
if ((headers == null) || (headers.size() != 1)) {
// If we reach this point it means that we have multiple instance of the “Host” header
// Add client IP address to black listed client
addClientToBlacklist(clientIP);
// Return HTTP Error without any information about cause of the request reject !
httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
// Add trace here
// ….
// Quick Exit
return;
}
/* Step 3 : Perform analysis — Origin header is required */
if ((origin != null) && !””.equals(origin.trim())) {
if (this.allowedDomains.contains(origin)) {
// Check if origin is in allowed domain
isValid = true;
} else {
// Add client IP address to black listed client
addClientToBlacklist(clientIP);
isValid = false;
// Add trace here
// ….
}
}
/* Step 4 : Finalize request next step */
if (isValid) {
// Analysis OK then pass the request along the filter chain
chain.doFilter(request, response);
} else {
// Return HTTP Error without any information about cause of the request reject !
httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
}
}
/**
* Blacklist client
* 
* @param clientIP Client IP address
*/
private void addClientToBlacklist(String clientIP) {
// Add client IP address to black listed client
Element cacheElement = new Element(clientIP, clientIP);
this.blackListedClientIPCache.put(cacheElement);
}
/**
* Convert a enumeration to a list
* 
* @param tmpEnum Enumeration to convert
* @return list of string or null is input enumeration is null
*/
private static List<String> enumAsList(Enumeration<String> tmpEnum) {
if (tmpEnum != null) {
return Collections.list(tmpEnum);
}
return null;
}
}
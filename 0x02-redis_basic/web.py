# web.py
import redis
import requests
import time
from functools import wraps

# Initialize Redis connection
cache = redis.Redis(host='localhost', port=6379, db=0)

def cache_page(expiration=10):
    """Decorator to cache the page content and track URL access."""
    def decorator(func):
        @wraps(func)
        def wrapper(url):
            cache_key = f"count:{url}"
            cache_html_key = f"html:{url}"

            # Increment the access count
            cache.incr(cache_key)

            # Try to get the cached HTML content
            cached_html = cache.get(cache_html_key)
            if cached_html:
                return cached_html.decode('utf-8')

            # If not cached, get the HTML content using the original function
            html_content = func(url)

            # Cache the new HTML content with expiration
            cache.setex(cache_html_key, expiration, html_content)

            return html_content
        return wrapper
    return decorator

@cache_page(expiration=10)
def get_page(url: str) -> str:
    """Fetch the HTML content of a given URL."""
    response = requests.get(url)
    return response.text

if __name__ == "__main__":
    test_url = "http://slowwly.robertomurray.co.uk"
    print(get_page(test_url))
    time.sleep(5)
    print(get_page(test_url))
    time.sleep(6)
    print(get_page(test_url))

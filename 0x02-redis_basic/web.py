#!/usr/bin/env python3
"""Expiring web cache and tracker"""

import requests  # Importing the requests library for HTTP requests
import redis  # Importing the Redis client library
from functools import wraps  # Importing wraps for decorator functionality
from typing import Callable  # Importing Callable for type annotations

# Create a Redis client
r = redis.Redis()

def count_accesses(method: Callable) -> Callable:
    """
    Decorator to count the number of times a particular URL is accessed.
    It takes a single method Callable argument and returns a Callable.
    """
    @wraps(method)
    def wrapper(url: str) -> str:
        """
        Wrapper function that increments the access count for the URL
        and calls the original method.
        """
        # Increment the access count for the URL
        r.incr(f"count:{url}")
        # Call the original method
        return method(url)
    # Return the wrapper function
    return wrapper

@count_accesses
def get_page(url: str) -> str:
    """
    Function to obtain the HTML content of a URL and cache it with an expiration time.

    Args:
        url (str): The URL to fetch the content from.

    Returns:
        str: The HTML content of the URL.
    """
    # Check if the URL content is already cached
    cached_page = r.get(f"cached:{url}")
    if cached_page:
        # Return the cached content if available
        return cached_page.decode('utf-8')

    # Fetch the content from the URL
    response = requests.get(url)
    content = response.text

    # Cache the content with an expiration time of 10 seconds
    r.setex(f"cached:{url}", 10, content)

    # Return the fetched content
    return content

if __name__ == "__main__":
    url = "http://slowwly.robertomurray.co.uk"
    print(get_page(url))
    print(get_page(url))
    print(r.get(f"count:{url}").decode('utf-8'))

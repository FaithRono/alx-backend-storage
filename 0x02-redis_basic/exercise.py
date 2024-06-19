import redis  # Import the Redis client library
import uuid  # Import the UUID library for generating random keys
from typing import Union  # Import Union from typing for type annotations

class Cache:
    def __init__(self):
        # Initialize the Redis client and store it as a private attribute
        self._redis = redis.Redis()
        # Flush the Redis database to ensure it's empty
        self._redis.flushdb()

    def store(self, data: Union[str, bytes, int, float]) -> str:
        """
        Store the input data in Redis using a randomly generated key.

        Args:
            data (Union[str, bytes, int, float]): The data to be stored.

        Returns:
            str: The randomly generated key used to store the data.
        """
        # Generate a random key using uuid4 and convert it to a string
        key = str(uuid.uuid4())
        # Store the data in Redis using the generated key
        self._redis.set(key, data)
        # Return the generated key
        return key

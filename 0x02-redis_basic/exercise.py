#!/usr/bin/env python3
"""Redis and Python exercise"""

# Importing the UUID library for generating unique keys
import uuid

# Importing wraps for decorator functionality
from functools import wraps

# Importing Callable and Union for type annotations
from typing import Callable, Union

# Importing the Redis client library
import redis


def count_calls(method: Callable) -> Callable:
    """
    Decorator to count the number of times a method is called.
    It takes a single method Callable argument and returns a Callable.
    """
    # Get the qualified name of the method
    key = method.__qualname__

    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """
        Wrapper function that increments the count for the key every time
        the method is called and returns the value returned by the original method.
        """
        # Increment the count for the method key
        self._redis.incr(key)
        # Call the original method
        return method(self, *args, **kwargs)
    # Return the wrapper function
    return wrapper


def call_history(method: Callable) -> Callable:
    """
    Decorator to store the history of inputs and outputs for a particular function.
    It takes a single method Callable argument and returns a Callable.
    """
    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """
        Wrapper function that saves the input and output of each function call in Redis.
        """
        # Key for storing inputs
        input_key = method.__qualname__ + ":inputs"
        # Key for storing outputs
        output_key = method.__qualname__ + ":outputs"

        # Call the original method
        output = method(self, *args, **kwargs)

        # Save the inputs in Redis
        self._redis.rpush(input_key, str(args))
        # Save the outputs in Redis
        self._redis.rpush(output_key, str(output))

        # Return the output of the original method
        return output

    # Return the wrapper function
    return wrapper


def replay(fn: Callable):
    """
    Function to display the history of calls of a particular function.
    It takes a single Callable argument.
    """
    # Create a new Redis client
    r = redis.Redis()
    # Get the qualified name of the function
    f_name = fn.__qualname__
    # Get the number of calls from Redis
    n_calls = r.get(f_name)
    try:
        # Decode the number of calls
        n_calls = n_calls.decode('utf-8')
    except Exception:
        # Default to 0 if decoding fails
        n_calls = 0
    # Print the number of calls
    print(f'{f_name} was called {n_calls} times:')

    # Get the list of inputs from Redis
    ins = r.lrange(f_name + ":inputs", 0, -1)
    # Get the list of outputs from Redis
    outs = r.lrange(f_name + ":outputs", 0, -1)

    for i, o in zip(ins, outs):
        try:
            # Decode each input
            i = i.decode('utf-8')
        except Exception:
            i = ""
        try:
            # Decode each output
            o = o.decode('utf-8')
        except Exception:
            o = ""

        # Print the input and output
        print(f'{f_name}(*{i}) -> {o}')


class Cache():
    """
    Cache class that interacts with Redis for storing and retrieving data.
    """

    def __init__(self) -> None:
        """Initialize the Redis client and flush the database."""
        # Create a Redis client
        self._redis = redis.Redis()
        # Flush the Redis database
        self._redis.flushdb()

    @count_calls  # Apply the count_calls decorator
    @call_history  # Apply the call_history decorator
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """
        Store method to save data in Redis with a randomly generated key.

        Args:
            data (Union[str, bytes, int, float]): Data to be stored.

        Returns:
            str: The randomly generated key used to store the data.
        """
        # Generate a random key
        key = str(uuid.uuid4())
        # Store the data in Redis
        self._redis.set(key, data)
        # Return the generated key
        return key

    def get(self, key: str, fn: Callable = None) -> Union[str, bytes, int, float]:
        """
        Get method to retrieve data from Redis and optionally transform
        it to a Python type.

        Args:
            key (str): The key used to retrieve the data.
            fn (Callable, optional): A function to transform the data.

        Returns:
            Union[str, bytes, int, float]: The retrieved data.
        """
        # Get the data from Redis
        data = self._redis.get(key)
        if fn:
            # Transform the data if a function is provided
            return fn(data)
        # Return the raw data
        return data

    def get_str(self, key: str) -> str:
        """
        Get method to retrieve data from Redis and transform it to a string.

        Args:
            key (str): The key used to retrieve the data.

        Returns:
            str: The retrieved data as a string.
        """
        # Get the data from Redis
        variable = self._redis.get(key)
        # Decode the data to a string
        return variable.decode("UTF-8")

    def get_int(self, key: str) -> int:
        """
        Get method to retrieve data from Redis and transform it to an integer.

        Args:
            key (str): The key used to retrieve the data.

        Returns:
            int: The retrieved data as an integer.
        """
        # Get the data from Redis
        variable = self._redis.get(key)
        try:
            # Decode the data to an integer
            variable = int(variable.decode("UTF-8"))
        except Exception:
            # Default to 0 if decoding fails
            variable = 0
        return variable

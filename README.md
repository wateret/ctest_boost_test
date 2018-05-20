# CTest x Boost.Test
An example of using Boost unit test framework on CTest

## Usage

TBD

## Run Example

```
$ mkdir build && cd build
$ cmake ..
$ make && make test
```

If you don't like test cases run individually, add an argument like below in `cmake` step:

```
$ cmake .. -DTESTRUN_ONESHOT=1
```

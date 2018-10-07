# dmcurl

Copyright (c) 2013-2018 brinkqiang (brink.qiang@gmail.com)

[dmcurl GitHub](https://github.com/brinkqiang/dmcurl)

## Build status
| [Linux][lin-link] | [MacOSX][osx-link] | [Windows][win-link] |
| :---------------: | :----------------: | :-----------------: |
| ![lin-badge]      | ![osx-badge]       | ![win-badge]        |

[lin-badge]: https://travis-ci.org/brinkqiang/dmcurl.svg?branch=master "Travis build status"
[lin-link]:  https://travis-ci.org/brinkqiang/dmcurl "Travis build status"
[osx-badge]: https://travis-ci.org/brinkqiang/dmcurl.svg?branch=master "Travis build status"
[osx-link]:  https://travis-ci.org/brinkqiang/dmcurl "Travis build status"
[win-badge]: https://ci.appveyor.com/api/projects/status/github/brinkqiang/dmcurl?branch=master&svg=true "AppVeyor build status"
[win-link]:  https://ci.appveyor.com/project/brinkqiang/dmcurl "AppVeyor build status"

## Intro
dmcurl
curl version: 7.61.0
curlpp version: 0.81
```cpp
#include <sstream>

#include <cstdlib>
#include <cstdio>
#include <cstring>

#include <dmos.h>

#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>
#include <curlpp/Exception.hpp>

int main(int argc, char *argv[])
{
  if (argc != 3)
  {
    std::cerr << "Example 2: Missing argument" << std::endl
              << "Example 2: Usage: example02 url string-to-send"
              << std::endl;
    return EXIT_FAILURE;
  }
  char *url = argv[1];

  std::istringstream myStream(argv[2]);
  int size = myStream.str().size();

  char buf[50];
  try
  {
    curlpp::Cleanup cleaner;
    curlpp::Easy request;

    std::list<std::string> headers;
    headers.push_back("Content-Type: text/*");
    sprintf(buf, "Content-Length: %d", size);
    headers.push_back(buf);

    using namespace curlpp::Options;
    request.setOpt(new Verbose(true));
    request.setOpt(new ReadStream(&myStream));
    request.setOpt(new InfileSize(size));
    request.setOpt(new Upload(true));
    request.setOpt(new HttpHeader(headers));
    request.setOpt(new Url(url));

    request.perform();
  }
  catch (curlpp::LogicError &e)
  {
    std::cout << e.what() << std::endl;
  }
  catch (curlpp::RuntimeError &e)
  {
    std::cout << e.what() << std::endl;
  }

  return 0;
}
```
## Contacts
[![Join the chat](https://badges.gitter.im/brinkqiang/dmcurl/Lobby.svg)](https://gitter.im/brinkqiang/dmcurl)

## Thanks

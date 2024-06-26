# dmcurl

Copyright (c) 2013-2018 brinkqiang (brink.qiang@gmail.com)

[dmcurl GitHub](https://github.com/brinkqiang/dmcurl)

## Build status
| [Linux][lin-link] | [Mac][mac-link] | [Windows][win-link] |
| :---------------: | :----------------: | :-----------------: |
| ![lin-badge]      | ![mac-badge]       | ![win-badge]        |

[lin-badge]: https://github.com/brinkqiang/dmcurl/workflows/linux/badge.svg "linux build status"
[lin-link]:  https://github.com/brinkqiang/dmcurl/actions/workflows/linux.yml "linux build status"
[mac-badge]: https://github.com/brinkqiang/dmcurl/workflows/mac/badge.svg "mac build status"
[mac-link]:  https://github.com/brinkqiang/dmcurl/actions/workflows/mac.yml "mac build status"
[win-badge]: https://github.com/brinkqiang/dmcurl/workflows/win/badge.svg "win build status"
[win-link]:  https://github.com/brinkqiang/dmcurl/actions/workflows/win.yml "win build status"

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

## Thanks

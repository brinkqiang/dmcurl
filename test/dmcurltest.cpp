
#include <sstream>

#include <cstdlib>
#include <cstdio>
#include <cstring>

#include "dmos.h"

#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>
#include <curlpp/Exception.hpp>

#include "dmformat.h"

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

    try
    {
        curlpp::Cleanup cleaner;
        curlpp::Easy request;

        std::list<std::string> headers;
        headers.push_back("Content-Type: text/*");
        std::string strBuf = fmt::format("Content-Length: {}", size);
        headers.push_back(strBuf);

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

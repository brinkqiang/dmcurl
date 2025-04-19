
#include "dmformat.h"

#include <cstdlib>
#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>
#include <curlpp/Exception.hpp>
#include <curlpp/Infos.hpp>
 

int main(int argc, char *argv[])
{

    std::string url = "https://api.github.com/users/brinkqiang/repos";

	try 
	{
		curlpp::Cleanup cleaner;
		curlpp::Easy request;

		using namespace curlpp::Options;
		request.setOpt(Verbose(true));
		request.setOpt(Url(url));
		request.setOpt(curlpp::Options::SslVerifyPeer(false));
		request.setOpt(curlpp::Options::SslVerifyHost(0));

		request.perform();

		std::string effURL;
		curlpp::infos::EffectiveUrl::get(request, effURL);
		std::cout << "Effective URL: " << effURL << std::endl;

		//other way to retreive URL
		std::cout << std::endl 
			<< "Effective URL: " 
			<< curlpp::infos::EffectiveUrl::get(request)
			<< std::endl;

		std::cout << "Response code: " 
			<< curlpp::infos::ResponseCode::get(request) 
			<< std::endl;

		std::cout << "SSL engines: " 
			<< curlpp::infos::SslEngines::get(request)
			<< std::endl;
	}
	catch ( curlpp::LogicError & e ) {
		std::cout << e.what() << std::endl;
	}
	catch ( curlpp::RuntimeError & e ) {
		std::cout << e.what() << std::endl;
	}

	return 0;
}
